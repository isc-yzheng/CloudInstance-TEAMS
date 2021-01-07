/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// A specialized HL7 TCP Operation that sends out ACKs on behalf of a paired HL7 TCP Service. It also
/// depends on this partner Service to collect ACKs on its behalf, for example to send messages to a dual-channel iSoft iCM application.
Class EnsLib.HL7.Operation.AckOutStandard Extends EnsLib.HL7.Operation.ReplyStandard [ Abstract, ClassType = "", ProcedureBlock, System = 4 ]
{

/// The amount of time to wait for our partner Service to forward us an ACK corresponding to a normal outbound message we sent.
Property PartnerAckTimeout As %Numeric [ InitialExpression = 600 ];

Parameter SETTINGS = "PartnerAckTimeout";

/* override comment to remove ':I?' references since we forcibly ignore ACKS with ControlID mismatches on the partner Service, and the 1-byte immediate Commit Acks have no ControlID */
/// A comma-separated list of codes specifying what action this Operation will take on receipt of various types of ACK response messages and other reply status conditions. <br/>
/// The format of the list is: &lt;code&gt;=&lt;action&gt;,&lt;code&gt;=&lt;action&gt;,... <br/>
/// A &lt;code&gt; value starting with a colon - e.g. :&lt;char&gt;&lt;char&gt; represents a literal value found in field MSA:1 of the response message. <br/>
/// Also, the following special code values may be used: <br/>
/// :?A - matches AA or CA values (Accept) <br/>
/// :?E - matches AE or CE values (Error) <br/>
/// :?R - matches AR or CR values (Reject) <br/>
/// :_  - matches replies with an empty MSA:1 field <br/>
/// :*  - matches any MSA:1 value not matched otherwise (default=F) <br/>
/// :~  - matches replies that do not contain an MSA segment <br/>
/// :T? - matches where the reply MSH:9 Type name does not match the schema's declared reply type for the original message <br/>
///  <br/>
/// Also, the following standard status conditions may be used: <br/>
/// E - Error status returned from message handler <br/>
/// E#&lt;statuscode&gt; - Error status returned from message handler has status code equal to &lt;statuscode&gt; <br/>
/// E*&lt;text&gt; - Error status returned from message handler contains text string &lt;text&gt; <br/>
/// X - there is no reply message at all <br/>
/// Note: an empty or whitespace code value is the same as :_. <br/>
///  <br/>
/// The following values for &lt;action&gt; may be used alone or in combinations: <br/>
/// C - Treat the message as Completed OK. <br/>
/// W - Log a warning but treat the message as Completed OK. <br/>
/// R - Retry the message according to the configured RetryInterval and FailureTimeout; finally Fail unless a different action is also specified <br/>
/// S - Suspend the message, log an error, and move on to try the next message <br/>
/// D - Disable the Operation, log an error and restore the outbound message to the front of the Operation's queue <br/>
/// F - Fail with an error and move on to try the next message <br/>
/// Note: F is the default action if no other is given, except for code ?A where the default action is C <br/>
///  <br/>
/// The default behavior is ':?R=RF,:?E=S,:~=S,:?A=C,:*=S,:T?=C' <br/>
/// This means for NACKs received with error code AR or CR retry, while codes AE or CE suspend the current outbound
/// message and move on to the next.<br/>
///  <br/>
/// All codes where the &lt;actions&gt; consists of only 'W' (for 'log a Warning') will be evaluated and warnings generated if they trigger.
/// Other codes will be evaluated in left-to-right order, executing the first one that triggers that has a non-warning &lt;actions&gt; value.
Property ReplyCodeActions As %String(MAXLEN = 1000);

Method OnInit() As %Status
{
	Set tSC=##class(Ens.Queue).Create("ACK_"_..%ConfigName)  Quit:$$$ISERR(tSC) tSC
	Set tSC=##super()
	#; Note: in this context of alternate-channel ACKs we require the control ID to match, so we ignore the I?= configuration
	Set:$$$ISOK(tSC) ..%replyActionMap("I?")="X" ; special value meaning to discard the mismatched ACK and wait for a different ACK
	Quit tSC
}

/// Upon dequeueing each message, send it and wait for Commit ACK. If recieved, dequeue for Application ACK from PartnerService using PartnerAckTimeout.
/// While waiting, loop to send ACKs from Service if any
/// Upon dequeueing ACK originating from PartnerService send it and wait for Commit ACK.
Method OnMessage(pRequest As EnsLib.HL7.Message, Output pResponse As EnsLib.HL7.Message) As %Status
{
	#; There are 3 types of message we receive and handle here:
	#; 1: normal outbound messages queued to this Operation
	#; 2: outbound ACKs queued to us at top priority by our partner Service to match messages received by it
	#; 3: incoming ACKs matching type 1 messages we sent; these are queued to us by our partner Service on a special ACK_ queue
	
	Set tIsACK=$Case(pRequest.GetValueAt("1:9.1"),"ACK":1,"ADR":1,:0)

	Set tSC=##super(pRequest,.pResponse)
	Quit:$$$ISERR(tSC)||tIsACK tSC ; no wait for ack-of-ack
	
	#; Wait for an ACK from the Partner Service
	$$$sysTRACE("Beginning wait for ACK to come in via Partner Service")
	Set tAckTimeout = ..PartnerAckTimeout
	Set:tAckTimeout>=0 tEndTime=$ZH+tAckTimeout
	Set pResponse=$$$NULLOREF ; chuck the 1-byte immediate ACK
	Set tHang=0 ; delay the spin if no action
	While 1 {
		Set tSC = ##class(Ens.Queue).DeQueue("ACK_"_..%ConfigName,.tAckHeader,tHang)  Quit:$$$ISERR(tSC)
		If $IsObject(tAckHeader) {
			Set tAckHeader.SessionId=..%SessionId  Do tAckHeader.%Save()
			Do tAckHeader.SetStatus($$$eMessageStatusDelivered)
			If tAckHeader.MessageBodyClassName'="" {
				Set tACK = $zobjclassmethod(tAckHeader.MessageBodyClassName,"%OpenId",tAckHeader.MessageBodyId)
				If '$IsObject(tACK) $$$LOGERROR("ACK body does not exist for ACK Header #"_tAckHeader.%Id()_" with body class "_tAckHeader.MessageBodyClassName)
			} Else {
				Set tACK=$$$NULLOREF  $$$LOGERROR("No MessageBody classname for MessageHeader #"_tAckHeader.%Id())
			}
			If '$IsObject(tACK) {
				Do tAckHeader.SetStatus($$$eMessageStatusError)
			} Else {
				Set tReqId=pRequest.%Id(), tACK.Source=tReqId_$C(13,10)_..Adapter.GetAddress()
				#; Add on CorrespondingMessageId as 3rd piece.
				Try {Set tACK.Source=tACK.Source_$C(13,10)_..%RequestHeader.%Id()} Catch {}
				Do ..OnReplyDocument(.tACK,pRequest)
				If '$IsObject(tACK) {
					Do tAckHeader.SetStatus($$$eMessageStatusDiscarded)
				} Else {
					Set tACK.OriginalDocId=tReqId
					Set tAckType=tACK.Name, tReplyCategory=$S(""'=pRequest.MessageTypeCategory:pRequest.MessageTypeCategory,1:$P(pRequest.DocType,":"))
					Do ##class(EnsLib.HL7.Schema).ResolveReplyNameAndDocType(tReplyCategory_":"_pRequest.Name,.tReplyDocName,.tReplyDocType,0)
					$$$sysTRACE("Got reply ACK "_tACK_" "_$S('$IsObject(tACK):"",1:" / "_tACK.%Id())_" of type "_tAckType_$S(tAckType=tReplyDocName:"",1:", expected type "_tReplyDocName))
					If ..#SetReplyDocType
					 && ((..%RequestHeader.needsReply()) || ("None" '= ..SaveReplies))
					 && (""=tACK.DocType) && (""'=tReplyDocType) {
						Do tACK.PokeTypeCategory(tReplyCategory)
						If tReplyDocName'=tAckType {
							Set tReplyDocType=##class(EnsLib.HL7.Schema).ResolveSchemaTypeToDocType(tReplyCategory,tAckType)
						}
						Do:""'=tReplyDocType tACK.PokeDocType(tReplyDocType)
					}
					Set tACK.IsMutable=0
					Set timeDiff=$$$timeCmp(tAckHeader.TimeCreated,..%RequestHeader.TimeCreated)
					If timeDiff<0 {
						Set tOK=0  $$$LOGWARNING("Discarding HL7 service-forwarded ACK "_tACK_$S(""=tACK.%Id():"",1:" / "_tACK.%Id())_" created before the current message was received")
					} Else {
						Set tReq=pRequest  While $Case(tReq.Name,"FHS":1,"BHS":1,:0) {
							Set tReq=tReq.NextChild()
							If '$IsObject(tReq) Set tReq=pRequest  Quit
						}
						Set tRequestControlID = tReq.GetValueAt("1:10")
						Do getACKCode
						If $IsObject(tMSA)&&(tRequestControlID'=tMSA.GetValueAt(2)) {
							Set tOK=0  $$$LOGWARNING("Discarding HL7 service-forwarded ACK "_tACK_$S(""=tACK.%Id():"",1:" / "_tACK.%Id())_" whose "_"MSA:2 ControlId '"_tMSA.GetValueAt(2)_"' does not match original message ControlId '"_tRequestControlID_"'")
						} Else {
							Set tOK=1
						}
					}
					If 'tOK {
						Do tAckHeader.SetStatus($$$eMessageStatusDiscarded)
						Set tHang=0
						Continue ; no quit - loop and try again
					}
					Do tAckHeader.SetStatus($$$eMessageStatusCompleted)
					Set pResponse = tACK
					Quit ; we got a service-forwarded ACK: either OK or indicating original msg needs to be retried or suspended
				}
			}
		}
		If tAckTimeout>=0,$ZH>=tEndTime {
			Set tSC=$$$ERROR($$$EnsErrGeneral,"PartnerAckTimeout "_tAckTimeout_" expired waiting for ACK from Partner Service for message header "_..%RequestHeader.%Id())
			Set ..Retry=1
			Quit
		}
		#; We got no ACK; while waiting, check for outbound Service ACKs on top of the queue
		Set tSC = ##class(Ens.Queue).DeQueue(..QueueName(),.tSvcAckHeader,tHang,,,$$$eMessagePriorityHighSync) Quit:$$$ISERR(tSC)
		If $IsObject(tSvcAckHeader) {
			Do tSvcAckHeader.SetStatus($$$eMessageStatusDelivered)
			If tSvcAckHeader.MessageBodyClassName'="" {
				Set tSvcAck = $zobjclassmethod(tSvcAckHeader.MessageBodyClassName,"%OpenId",tSvcAckHeader.MessageBodyId)
				If '$IsObject(tSvcAck) $$$LOGERROR("ACK body does not exist for ACK Header #"_tSvcAckHeader.%Id()_" with body class "_tSvcAckHeader.MessageBodyClassName)
			} Else {
				Set tSvcAck=$$$NULLOREF  $$$LOGERROR("No MessageBody classname for MessageHeader #"_tSvcAckHeader.%Id())
			}
			If '$IsObject(tSvcAck) {
				Do tSvcAckHeader.SetStatus($$$eMessageStatusError)
			} Else {
				#; Handle the Service ACK by sending it out like a normal message
				Set tSC=##super(tSvcAck)
				If $$$ISERR(tSC)||..Retry||..SuspendMessage {
					#; Give up and drop out to normal retry loop. We will retry the original message when it comes back up on the queue
					$$$LOGWARNING("Failed to send ACK "_tSvcAckHeader.MessageBodyId_" on behalf of Partner Service while waiting for ACK of our outbound message header "_..%RequestHeader.%Id()_" from Partner Service. Error "_$$$StatusDisplayString(tSC)_". Requeueing that and retrying send of the ACK instead.")
					Do ##class(Ens.Queue).PutBackToQueue(..%RequestHeader)
					Set ..%RequestHeader=tSvcAckHeader
					Do tSvcAckHeader.SetStatus($S($$$ISERR(tSC):$$$eMessageStatusError,1:$$$eMessageStatusCompleted))
					Quit
				}
				Do tSvcAckHeader.SetStatus($$$eMessageStatusCompleted)
			}
		} Else {
			#; Check for shutdown signals
			Set tTerminate=##class(Ens.Job).ShouldTerminate()
			If ##class(Ens.Job).ShouldBeQuiescent() || tTerminate {
				If ..%RequestHeader.Priority'=$$$eMessagePrioritySync||tTerminate {
					$$$LOGINFO("Stopping wait for ACK of outbound message with header "_..%RequestHeader.%Id()_" from Partner Service due to shutdown request; re-queueing")
					Set tSC=##class(Ens.Queue).PutBackToQueue(..%RequestHeader)
					Quit
				}
 				$$$LOGINFO("Ignoring Quiescent request while waiting for ACK for high priority (i.e. synchronous) request "_..%RequestHeader.%Id())
			}
			Set tHang=0.1
		}
	} ; end While 1
	Quit tSC

getACKCode
	#; Get MSA code if not already cached
	Set tReplyMsg=tACK
	While $Case(tReplyMsg.Name,"FHS":1,"BHS":1,:0) {
		Set tReplyMsg=tReplyMsg.NextChild()
		If '$IsObject(tReplyMsg) Set tReplyMsg=tACK  Quit
	}
	Set tMSA=tReplyMsg.GetSegmentAt(2)

	Set tAckCode=$S($IsObject(tMSA)&&("MSA"=tMSA.GetValueAt(0)):$ZStrip(tMSA.GetValueAt(1),"<>W"), 1:"~NoMSA")
	Set:""=tAckCode tAckCode="_"
	Set tAckCodeU=$ZCVT(tAckCode,"U")
	Quit
}

}
