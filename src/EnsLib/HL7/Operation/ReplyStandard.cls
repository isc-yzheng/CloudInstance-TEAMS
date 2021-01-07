/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This is an abstract superclass for HL7 Operations that can receive a reply to a sent HL7 message
Class EnsLib.HL7.Operation.ReplyStandard Extends (EnsLib.HL7.Operation.Standard, EnsLib.EDI.ServiceInterface) [ Abstract, ClassType = "", Inheritance = right, ProcedureBlock, System = 4 ]
{

/// <p>A comma-separated list of codes specifying what action this Operation will take on receipt of various types of ACK response messages and other reply status conditions.
/// The format of the list is: <br/>&lt;code&gt;=&lt;action&gt;,&lt;code&gt;=&lt;action&gt;,...<br/>
/// Types of reply status condition are identified by a specification code:
/// A &lt;code&gt; value starting with a colon - e.g. :&lt;char&gt;&lt;char&gt; represents a literal value found in field MSA:1 of the response message.
/// Also, the following special code values may be used: <br/>
/// <ul style="list-style-type: none;">
/// <li><b>:?A</b> - matches AA or CA values (Accept)</li>
/// <li><b>:?E</b> - matches AE or CE values (Error)</li>
/// <li><b>:?R</b> - matches AR or CR values (Reject)</li>
/// <li><b>:_</b>  - matches replies with an empty MSA:1 field</li>
/// <li><b>:*</b>  - matches any MSA:1 value not matched otherwise (default=F)</li>
/// <li><b>:~</b>  - matches replies that do not contain an MSA segment</li>
/// <li><b>:I?</b> - matches where the reply MSA:2 ControlId does not match the ControlId of the original message</li>
/// <li><b>:T?</b> - matches where the reply MSH:9 Type name does not match the schema's declared reply type for the original message</li>
/// </ul></p>
/// <p>The default behavior is ':?R=RF,:?E=S,:~=S,:?A=C,:*=S,:I?=W,:T?=C' <br/>
/// This means for NACKs received with error code AR or CR retry, while codes AE or CE suspend the current outbound
/// message and move on to the next.</p>
/// <p>Also, the following standard status conditions may be used:
/// <ul style="list-style-type: none;">
/// <li><b>E</b> - Error status returned from message handler</li>
/// <li><b>E#&lt;statuscode&gt;</b> - Error status returned from message handler has status code equal to &lt;statuscode&gt;</li>
/// <li><b>E*&lt;text&gt;</b> - Error status returned from message handler contains text string &lt;text&gt;</li>
/// <li><b>X</b> - there is no reply message at all</li>
/// </ul></p>
/// <p>The following values for &lt;actions&gt; may be used alone or in combinations: 
/// <ul style="list-style-type: none;">
/// <li><b>C</b> - Treat the message as Completed OK.</li>
/// <li><b>W</b> - Log a warning. If no other non-warning &lt;actions&gt; are triggered, the message will be treated as Completed OK.</li>
/// <li><b>R</b> - Retry the message according to the configured RetryInterval and FailureTimeout; finally Fail unless a 
/// different action is also specified.</li>
/// <li><b>S</b> - Suspend the message, log an error, and move on to try the next message.</li>
/// <li><b>D</b> - Disable the Operation, log an error and restore the message to the front of the Operation's queue.</li>
/// <li><b>F</b> - Fail with an error and move on to try the next message from the Operation's queue.</li></ul>
/// An example of a valid ReplyCodeActions specification is 'E#6301=R,E#&lt;Ens&gt;ErrGeneral=RD,E=F'. This specification will result in a 
/// retry when error code 6301 is encountered. When error code &lt;Ens&gt;ErrGeneral is encountered, the Operation first retries to send 
/// the message until FailureTimeout and then, if the error continues, it disables the Operation instead of failing. Any other errors will 
/// cause the Operation to fail processing of the current message and return the error status to the caller, without retrying first.</p>
/// <p><b>The default behavior is 'E=F'.</b> Thus any error status will result in the error being logged and returned to the caller,
/// no retries will be attempted, and the Operation will move on to try the next message from its queue.</p>
/// <p>All codes where &lt;actions&gt; consists of only 'W' (for 'log a Warning') will be evaluated, and a warning will be
/// generated for each matching &lt;code&gt;. Other &lt;code&gt; values will be evaluated in left-to-right order, executing the
/// first matching &lt;code&gt; that has a non-warning &lt;actions&gt; value. As noted in the details for the 'W' flag, an error
/// that only triggers 'W' &lt;actions&gt; will be treated as Completed OK.</p>
Property ReplyCodeActions As %String(MAXLEN = 1000);

Parameter SETTINGS = "ReplyCodeActions,NoFailWhileDisconnected,SaveReplies";

Property %Parser As EnsLib.HL7.Parser;

/// [Deprecated] The <property>SaveReplies</property> property/setting should be used instead.
/// If SearchTableClass is given, use it to index any replies (including ACKs unless IndexACKs=0 or OK and SaveOKACKs=0)
Parameter IndexReplies As %Boolean = 1;

/// [Deprecated] The <property>SaveReplies</property> property/setting should be used instead.
/// Index ACKs if IndexReplies is also true and SearchTable class is given
Parameter IndexACKs As %Boolean = 0;

/// [Deprecated] The <property>SaveReplies</property> property/setting should be used instead.
/// Save OK ACKs
Parameter SaveOKACKs As %Boolean = 0;

/// Log a Warning if the reply MSA:2 ControlId does not match the original message's control ID
/// (Deprecated - use Setting ReplyCodeActions instead of subclassing)
Parameter WarnACKControlId As %Boolean = 1;

/// Don't report an error for reply messages containing no MSA:1 field
/// (Deprecated - use Setting ReplyCodeActions instead of subclassing)
Parameter AllowNonMSA As %Boolean = 0;

/// Set the DocType and MessageTypeCategory properties of the reply message if possible
Parameter SetReplyDocType As %Boolean = 1;

/// Save a copy of reply messages sent back to the remote system. Also optionally index them using the configured SearchTableClass, if any.<br/>
/// The options for this setting are as follows: <ul>
/// <li>None : Don't save or index any reply messages.</li>
/// <li>NotOKs : Save replies that are not a simple OK ACK message: e.g. error NACKS and query responses.</li>
/// <li>All : Save a copy of all reply messages sent back to the remote system.</li>
/// <li>IndexNotOKs : Save replies that are not a simple OK ACK message and index them using the configured SearchTable.
/// This is the default behaviour, unless <parameter>IndexReplies</parameter>, <parameter>SaveOKACKs</parameter> or 
/// <parameter>IndexACKs</parameter> has been overridden in this class.</li>
/// <li>IndexAll : Save a copy of all reply messages and index them using the configured SearchTable.</li></ul>
Property SaveReplies As %String(VALUELIST = ",None,NotOKs,All,IndexNotOKs,IndexAll") [ InitialExpression = {$select(..#IndexReplies: "Index"_$select(..#IndexACKs: "All", 1: "NotOKs"), ..#SaveOKACKs: "All", 1: "NotOKs")} ];

/// parsed array property of ReplyCodeActions setting
Property %replyActionMap [ MultiDimensional ];

Method OnInit() As %Status
{
	Set ..%Parser=##class(EnsLib.HL7.Parser).%New($this)
	If "*"=$E(..Framing,*) { Set ..%Parser.Framing="Flexible", ..Framing=$E(..Framing,1,*-1) }
	Else { Set ..%Parser.Framing=..Framing }
	Set ..%Parser.DefCharEncoding=..DefCharEncoding
 // The default behavior is ':?R=RF,:?E=S,:~=S,:?A=C,:*=S,:I?=W,:T?=C' <br/>
	Set:""=..ReplyCodeActions ..ReplyCodeActions=":?R=RF,:?E=S,:~="_$S(..#AllowNonMSA:"W",1:"S")_",:?A=C,:*=S,:I?="_$S(..#WarnACKControlId:"W",1:"C")_",:T?=C"
	Do ..buildReplyActionMap()
	Quit ##super()
}

/// build parsed array property of ReplyCodeActions setting
Method buildReplyActionMap() As %Status
{
	Set nActions=$S(""=$ZStrip(..ReplyCodeActions,"<>W"):0, 1:$L(..ReplyCodeActions,","))
	Set (tFirst,tOther)=0
	For i=1:1:nActions { Set tType=$P(..ReplyCodeActions,",",i)  Continue:""=tType
		Set tCode=$ZStrip($P(tType,"="),"<>W"), tCodeU=$ZCVT(tCode,"U")
		Set tAction=$ZCVT($ZStrip($P(tType,"=",2),"<>W"),"U")
		Continue:tCode_tAction=""
		If tOther { If tOther-tFirst>1 { Continue } Else { Set (tFirst,tOther)=0 Kill ..%replyActionMap /* loner; start again */ } }
		If ":"=$E(tCode)&&$Case(tCodeU,":I?":0,":T?":0,:1) { Set:'tFirst tFirst=i } Else { Set:("W"'=tAction)&&tFirst tOther=i  Continue }
		
		#; Now we are in a cluster of : values that we want to build a map from
		Set tCode=$E(tCode,2,*), tCodeU=$E(tCodeU,2,*)
		Continue:""=tCode&&$D(..%replyActionMap("_"))

		Set:""=tCode tCode="_"
		Set:"~"=tCode tCode="~NoMSA"
		Set:tAction'?1.(1"C",1"W",1"R",1"S",1"D",1"F") tAction=$Case(tCodeU
																	,"?A":"C"
																	,"AA":"C"
																	,"CA":"C"
																	,:"F")
		Set:tAction?1."R" tAction="RF"
		If tCodeU?1"?"1(1"A",1"E",1"R") {
			Set ..%replyActionMap("A"_$E(tCodeU,2))=tAction
			Set ..%replyActionMap("C"_$E(tCodeU,2))=tAction
		} ElseIf tCodeU?1(1"A",1"C")1(1"A",1"E",1"R") {
			Set ..%replyActionMap(tCodeU)=tAction
		} Else {
			Set ..%replyActionMap(tCode)=tAction
		}
	}
	#; optimization: use map if ':' conditions are grouped together
	Set tEnd=$S(tOther:tOther-1,1:nActions)
	Set:tFirst&&(tEnd-tFirst>0) ..%replyActionMap("%UseMapAt",tFirst)=tEnd
	Quit $$$OK
}

Method SendMessage(pMsgOut As EnsLib.HL7.Message, Output pMsgIn As EnsLib.HL7.Message, pExpectedSequenceNumber As %String) As %Status [ CodeMode = expression ]
{
$$$ERROR($$$EnsErrGeneral,"Subclass Responsibility")
}

Method OnMessage(pRequest As EnsLib.HL7.Message, Output pResponse As EnsLib.HL7.Message) As %Status
{
	Set pResponse=$$$NULLOREF
	
	Set tSC=$method($this,"validateAndIndex",pRequest) Quit:$$$ISERR(tSC) tSC
	
	#; Send the message and get reply if any
	Set tESN=$G($$$ExpectedSequenceNumber) Set:'tESN tESN=""
	Set tSC=$method($this,"SendMessage",pRequest,.tReplyDoc,tESN) Quit:$$$ISERR(tSC) tSC
	Set:tESN $$$ExpectedSequenceNumber=tESN+1

	If $IsObject(tReplyDoc) {
		Set tReqId=pRequest.%Id(), tReplyDoc.Source=tReqId_$C(13,10)_..Adapter.GetAddress()
		#; Add on CorrespondingMessageId as 3rd piece.
		Try {Set tReplyDoc.Source=tReplyDoc.Source_$C(13,10)_..%RequestHeader.%Id()} Catch {}
	}
	Do $method($this,"OnReplyDocument",.tReplyDoc,pRequest)
	Quit:'$IsObject(tReplyDoc) tSC

	Set tReplyDoc.OriginalDocId=tReqId
	Set tReplyTypeName=tReplyDoc.Name, tReplyCategory=$S(""'=pRequest.MessageTypeCategory:pRequest.MessageTypeCategory,1:$P(pRequest.DocType,":"))
	Do ##class(EnsLib.HL7.Schema).ResolveReplyNameAndDocType(tReplyCategory_":"_pRequest.Name,.tReplyDocName,.tReplyDocType,0)
	$$$sysTRACE("Got reply message "_tReplyDoc_" of type "_tReplyTypeName_$S(tReplyTypeName=tReplyDocName:"",1:", expected type "_tReplyDocName))
	If ..#SetReplyDocType
	 && ((..%RequestHeader.needsReply()) || ("None" '= ..SaveReplies))
	 && (""=tReplyDoc.DocType) && (""'=tReplyDocType) {
		Do tReplyDoc.PokeTypeCategory(tReplyCategory)
		If tReplyDocName'=tReplyTypeName {
			Set tReplyDocType=##class(EnsLib.HL7.Schema).ResolveSchemaTypeToDocType(tReplyCategory,tReplyTypeName)
		}
		Do:""'=tReplyDocType tReplyDoc.PokeDocType(tReplyDocType)
	}
	Set tReplyDoc.IsMutable=0
	Kill ..%ActionHint  Set ..%ActionHint("AckType")=tReplyTypeName, ..%ActionHint("ReplyDocName")=tReplyDocName, ..%ActionHint("MsgType")="HL7"
	Set:$$$ISOK(tSC) pResponse = tReplyDoc
	Quit tSC
}

/// Construct and return an Action string consisting of supported action code letters, based on qualities of the Request, Response, and Error Status.
Method OnGetReplyAction(pRequest As EnsLib.HL7.Message, Output pResponse As EnsLib.HL7.Message, ByRef pSC As %Status) As %String
{
	Set (tCode,tAckCode,tAckCodeU,tFullAction,tText)=""
	Set nActions=$S(""=$ZStrip(..ReplyCodeActions,"<>W"):0, 1:$L(..ReplyCodeActions,","))
	Set tUseMapAt=$O(..%replyActionMap("%UseMapAt",""),1,tLastI)  Set:""=tUseMapAt tUseMapAt=nActions+1
	Set tReplyTypeName=$G(..%ActionHint("AckType"))
	For i=1:1:nActions { Set tType=$P(..ReplyCodeActions,",",i)  Continue:""=tType
		If ""'=tCode $$$LOGWARNING("Unrecognized reply code:'"_tCode_"'")
		Set tAction="", tCode=$ZStrip($P(tType,"="),"<>W"), tCodeU=$ZCVT(tCode,"U")
		Set tKnown=$Case($E(tCodeU)
						,"E":$Case($E(tCode,2)
								,"#":1
								,"*":1
								,"":1
								,:0)
						,"X":$Case($E(tCode,2),"":1,:0)
						,":":1
						,:0)
		Continue:'tKnown
		Set tMatch=$Case($E(tCodeU)
			,"":0
			,"E":$$$ISERR(pSC)
			,"X":'$$$IsdefObject(pResponse)
			,":":-1
			,:"")
		If tMatch>0 {
			Set tMatch=$Case($E(tCode,2)
							,"#":$$$StatusEquals(pSC,$E(tCode,3,*))
							,"*":$$$StatusText(pSC)[$E(tCode,3,*)
							,:1)
			If tMatch {
				If $E(tCodeU)="X" {
					#;If we have an error then ignore empty response match
					If $$$ISERR(pSC) {
						Set tMatch = 0
					} Else {
						Set tMatchText="Empty Response object matched ReplyCodeAction "_i_" : ':"_tCode_"'"
					}
				} Else {
					Set tMatchText="Status '"_$$$StatusDisplayString(pSC)_"' matched ReplyCodeAction "_i_" : '"_tCode_"'"
				}
			}
		} ElseIf tMatch<0 {
			Set tMatch=0
			If '$$$IsdefObject(pResponse) Set tCode=""  Continue
			If ":I?"=tCode {
				Do:""=tAckCode getACKCode
				If ("~NoMSA"'=tAckCode)&&("1-byte "'=$E(tMSA.GetValueAt(3),1,$L("1-byte "))) {
					Set tReq=pRequest  While $Case(tReq.Name,"FHS":1,"BHS":1,:0) {
						Set tReq=tReq.NextChild()
						If '$IsObject(tReq) Set tReq=pRequest  Quit
					}
					Set tRequestControlID = tReq.GetValueAt("1:10")
					If (tRequestControlID'=tMSA.GetValueAt(2)) {
						Set tMatch=1, tMatchText="MSA:2 ControlId '"_tMSA.GetValueAt(2)_"' does not match original message ControlId '"_tRequestControlID_"'"
					}
				}
			} ElseIf ":T?"=tCode {
				Set tMatch=0, tReplyDocName=..%ActionHint("ReplyDocName")
				If ((tReplyTypeName '= tReplyDocName) && (tReplyDocName'="")) || (tReplyTypeName="") {
					Set tMatch=1, tMatchText="Reply message type "_tReplyTypeName_" does not match expected type "_tReplyDocName
				}
			} Else {
				#; Get MSA code if not already cached
				Do:""=tAckCode getACKCode
				#; Get action from the map, or test for a match the old fashioned way
				If i=tUseMapAt {
					#; Use map
					Set tAction=$G(..%replyActionMap(tAckCode))  If ""=tAction Set tAction=$G(..%replyActionMap(tAckCodeU))  If ""=tAction Set tAction=$G(..%replyActionMap("*"))
					Set tMatch=(""'=tAction)
					Set:tMatch tMatchText= "MSA code '"_tAckCode_"' matched ReplyCodeActions "_i_"-"_tLastI_" : '"_$P(..ReplyCodeActions,",",i,tLastI)_"'"
					Set i=tLastI ; skip other contiguous mapped ':' entries
				} Else {
					#; Don't use map; check it manually
					Set tCode=$E(tCode,2,*)
					If tCode?1"?"1(1"A",1"a",1"E",1"e",1"R",1"r") { Set tMatch=(tAckCodeU?1(1"A",1"C").E && ($E(tAckCodeU,2,*)=$ZCVT($E(tCode,2),"U"))) }
					ElseIf "_"=tCode { Set tMatch=("_"=tAckCode) }
					ElseIf "~"=tCode { Set tMatch=("~NoMSA"=tAckCode) }
					ElseIf "*"=tCode { Set tMatch=("~NoMSA"'=tAckCode) }
					ElseIf tCode?1(1"A",1"a",1"C",1"c")1(1"A",1"a",1"E",1"e",1"R",1"r") { Set tMatch=(tAckCodeU=$ZCVT(tCode,"U")) }
					Else {             Set tMatch=(tAckCode=tCode) }
					Set:tMatch tMatchText="MSA code '"_tAckCode_"' matched ReplyCodeAction "_i_" : ':"_tCode_"'"
				}
			}
		}
		If tMatch {
			Set:""=tAction tAction=$ZCVT($ZStrip($P(tType,"=",2),"<>W"),"U")
			If ""=tAction Set tCode=""  Continue
			Set:""'=tMatchText tText=tText_$S(""'=tText:" and ",1:"")_tMatchText
			#; Make sure tFullAction has no more than 1 'W' in it; Quit if it is not just 'W'
			Set:tAction["W" tFullAction=""
			Set tFullAction=tAction_$S(tAction["W":"",1:tFullAction)
			Quit:tFullAction'?1."W"
		} ElseIf tMatch'=0 {
			$$$LOGWARNING("Unrecognized reply code:'"_tCode_"'")
		} ; else it remains 0 and is not a match
		Set tCode=""
	}
	Set:""'=tText ..%ActionHint("CodeReason")=
		"HL7 Message body "_pRequest_" / "_pRequest.%Id()_" because response "_
		$S('$IsObject(pResponse):"'"_pResponse_"'", 1:pResponse_$S(""=pResponse.%Id():"",1:" / "_pResponse.%Id()))_" "_
		tText_", resulting in Action code "_tFullAction_
		$TR($S('$IsObject(pResponse):pResponse,1:" : "_pResponse.RawContent),$C(13)," ")

	#; Save reply if it's special, or if we're built to save even ordinary OK ACKs
	If $IsObject(pResponse) && ("None" '= ..SaveReplies) {
		Set tIsACK = ("ACK" = $P(tReplyTypeName,"_"))
		Set tDoAll = "All" = $extract(..SaveReplies,*-2,*)
		Do:(""=tAckCode)&&tIsACK&&'tDoAll getACKCode
		#; Save the reply if we are saving/indexing all replies, OR this is not a simple OK ACK message: e.g. error NACKS and query responses
		If tDoAll || 'tIsACK || '$Case(tAckCodeU, "AA":1, "CA":1, :0) {
			#; Index reply if indexing is enabled
			If (""'=..SearchTableClass) && ("Index" = $extract(..SaveReplies,1,5)) {
				Set tSCStore=$classmethod(..SearchTableClass,"IndexDoc",pResponse)
				If $$$ISERR(tSCStore) $$$LOGWARNING("Failed to construct SearchTable instance for message "_pResponse_$S(""=pResponse.%Id():"",1:" / "_pResponse.%Id())_" with DocType='"_pResponse.DocType_"' using class '"_..SearchTableClass_"' "_$$$StatusDisplayString(tSCStore))
			}
			Else {
				Set tSCSave=pResponse.%Save()
				If $$$ISERR(tSCSave) $$$LOGERROR("Failed to save reply message "_pResponse_$S(""=pResponse.%Id():"",1:" / "_pResponse.%Id())_" with DocType='"_pResponse.DocType_"': "_$$$StatusDisplayString(tSCSave))
			}
		}
	}
	Quit tFullAction
getACKCode
	#; Get MSA code if not already cached
	Set tReplyDoc=pResponse
	While $Case(tReplyDoc.Name,"FHS":1,"BHS":1,:0) {
		Set tReplyDoc=tReplyDoc.NextChild()
		If '$IsObject(tReplyDoc) Set tReplyDoc=pResponse  Quit
	}
	Set tSegName=""  For iSeg=2:1 {
		Set tMSA=tReplyDoc.GetSegmentAt(iSeg)
		If '$IsObject(tMSA) Quit
		Set tPrevSeg=tSegName, tSegName=tMSA.GetValueAt(0)
		Quit:$Case(tSegName, "MSA":1, "SFT":$Case(tPrevSeg,"":0,"SFT":0,:1), "UAC":$Case(tPrevSeg,"":0,"SFT":0,:1), :1)
	}
	Set tAckCode=$S($IsObject(tMSA)&&("MSA"=tSegName):$ZStrip(tMSA.GetValueAt(1),"<>W"), 1:"~NoMSA")
	
	#; If no MSA found try using schema path
	If (tAckCode="~NoMSA")&&(tReplyDoc.DocType'="") {
		#dim tSCMSA As %Status = $$$OK
		Set tAckCode=tReplyDoc.GetValueAt("MSA:1",,.tSCMSA)
		If $$$ISERR(tSCMSA) Set tAckCode="~NoMSA"
	}
	
	Set:""=tAckCode tAckCode="_"
	Set tAckCodeU=$ZCVT(tAckCode,"U")
	Quit
}

/// Override this method to modify or delete or log the reply (ACK) message document object
Method OnReplyDocument(ByRef pReplyDocument As EnsLib.HL7.Message, pRequest As EnsLib.HL7.Message)
{
	Quit
}

/// Return the segment terminator string that the Parser will use.
Method GetSegmentTerminator() As %String
{
	Quit $C(13) ; $C(##class(EnsLib.HL7.Message).%GetParameter("SegTerminatorAscii"))
}

/// Add discarded characters to IO Archive
Method IOLogDiscard(pSC As %Status, pNote As %String, pDiscard As %GlobalCharacterStream)
{
	Set tIOLogEntry = ..IOLogEntry, ..IOLogEntry=$$$NULLOREF ; Save a separate entry for the unexpected input
	$$$NEWOUTIOLOGENTRY(pSC,pNote,$$$CurrentMethod,"%GlobalCharacterStream")
	$$$CLOSEIOLOGENTRY($$$OK,"",pDiscard)
	Set ..IOLogEntry = tIOLogEntry
}

}
