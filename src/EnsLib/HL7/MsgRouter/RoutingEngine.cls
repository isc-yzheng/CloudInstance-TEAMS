/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7

Class EnsLib.HL7.MsgRouter.RoutingEngine Extends EnsLib.EDI.MsgRouter.SegmentedRoutingEngine [ ClassType = persistent, ProcedureBlock, System = 4 ]
{

/// Colon-separated LocalFacility:LocalApplication codes representing this (receiving) facility and application.<p>
/// This value is used as SendingFacility:SendApplication if constructing an ACK or NACK reply message locally.
Property LocalFacilityApplication As %String [ InitialExpression = "ISC:EnsembleHL7" ];

/// Determines the ACK type (e.g. AA vs. CA) if constructing an ACK or NACK reply message locally.<p>
/// 'A' is the default code.
Property AckType As %String(VALUELIST = ",Application,Commit") [ InitialExpression = "Application" ];

/// Determines the NACK code type (e.g. AE vs. AR) if constructing a NACK reply message locally to report an error.<p>
/// 'E' is the default code.
Property NackCode As %String(VALUELIST = ",Error,Reject") [ InitialExpression = "Error" ];

/// Add ERR error code segment when generating NACK messages; otherwise do not embed internal error state information in NACK messages
Property AddNackERR As %Boolean;

Parameter SETTINGS = "LocalFacilityApplication,AckType,NackCode,AddNackERR";

/* Override description to add words about ACKs. */
/// Names the target(s) from which an ACK response should be forwarded back to the caller, if the caller requested
/// a response. If this value is empty, no reply will be requested from any target and this router will
/// generate an ACK response if needed.<p>
/// Otherwise, this value is a comma-separated list of target config names. The response returned will be the first
/// one that arrives back from any target in the list.  A value of '*' will match any target, so the first response
/// received will be the one returned.<p>
/// If none of the listed targets gets called or the replying target does not return a document, this router will
/// generate an ACK response if needed.<p>
/// If the list of targets begins with a '+' character, the responses from all the targets called
/// will be returned in a new HL7 batch document, or a new ACK response if no responses appear before the timeout expires.<p>
/// If the list of targets begins with a '-' character, all error responses only from any of the targets called
/// will be returned in a new HL7 batch document, or a new ACK response if no error responses appear before the timeout expires.
Property ResponseFrom As %String(MAXLEN = 1000) [ Transient ];

/* Override description to add words about DocType requirement and Z-segment loophole
	Validation: a string specifying types of validation to perform; If you override OnValidate() and need to provide more
	options, you can add more supported values to it and document them by also overriding the definition of this Validation property.
*/
/// String specifying types of Validation to perform <p>
/// Set to 1 to block documents that don't pass default validation. Default validation requires a DocType, allows messages 
/// with unmapped Z-segments, and blocks messages with any other error encountered while mapping the document's 
/// sequence of segments using the HL7 schema structure specified by the document's DocType. This is equivalent to 'dm-z'. <p/>
/// (The '-z' means 'the opposite of z', i.e. do tolerate unrecognized trailing Z-segments, which is the customary HL7 behavior.) <p/>
/// 'd' - require DocType <br/>
/// 'm' - don't tolerate BuildMap segment mapping errors (includes 'z' by default; specify '-z' to tolerate unrecognized trailing Z-segments) <br/>
/// 'z' - don't tolerate unrecognized trailing Z-segments <br/>
/// 'n' - enforce segment structures <br/>
/// 'r' - enforce required fields being present <br/>
/// 'l' - enforce field size restrictions <br/>
/// 'a' - enforce field array repetition limits <br/>
/// 't' - enforce code tables <br/>
/// 'b' - permit values not explicitly listed in a code table to pass validation when the code table uses "..." to indicate that any other values are also allowed. <br/>
/// 'u' - ignore code tables that do not list any permissible values; permit any value in fields that use such a code table. <br/>
/// 'y' - enforce data types <br/>
/// 'p' - enforce component data structures <br/>
/// 'j' - enforce optionality at the subcomponent level <br/>
/// 'w' - enforce subcomponent size restrictions <br/>
/// 's' - perform all available subcomponent-level validations.  Equivalent to 'pjw'. <br/>
/// 'g' - enforce field data structures <br/>
/// 'o' - enforce optionality at the component level <br/>
/// 'i' - enforce component size restrictions <br/>
/// 'c' - perform all available component - level validations.  Equivalent to 'gois'. <br/>
/// 'f' - perform all validations available within an individual segment.  Equivalent to 'nrlatbuyc'. <br/>
/// 'e' - perform every available validation.  Equivalent to 'dmf'. <br/>
/// 'x' - stop validating when an error is encountered. This is the default behavior.  Specify '-x' to scan the entire document and report all errors. <br/>
Property Validation As %String(MAXLEN = 20) [ InitialExpression = "dm-z", Transient ];

/// we need this property for EvaluateRules to get access to the HL7 message
Property HL7 As EnsLib.HL7.Message [ Calculated, ReadOnly, Transient ];

/// we need this property for EvaluateRules to get access to the HL7 Segments
Property Segment As EnsLib.HL7.Segment [ Transient ];

/// In Reply/ACK messages, use the ControlId of the message we are replying to, rather than constructing a new unique one
Parameter UseOriginalControlId As %Boolean = 1;

/// Override this method to implement your own method for validating a Document.
/// Return non-zero to prevent default validation of the message;
/// return an error code in pStatus to indicate a validation failure.
Method OnValidate(pDoc As EnsLib.HL7.Message, pValSpec As %String, Output pStatus As %Status = {$$$OK}) As %Boolean
{
	Set pStatus=##class(EnsLib.HL7.Util.Validator).Validate(pDoc,pValSpec)
	Quit 1
}

Method HL7Get() As EnsLib.HL7.Message [ CodeMode = expression ]
{
..Document
}

Method IsErrorResponse(request As EnsLib.HL7.Message, response As EnsLib.HL7.Message) As %Boolean
{
	// For nested batch ACKs, only check the first one
	Set tReplyMsg=response
	While $Case(tReplyMsg.Name,"FHS":1,"BHS":1,:0) {
		Set tReplyMsg=tReplyMsg.NextChild()
		If '$IsObject(tReplyMsg) Set tReplyMsg=response  Quit
	}
	Quit "A"'=$E(tReplyMsg.GetValueAt("2:1"),2)
}

Method OnPrepareReply(request As EnsLib.HL7.Message, ByRef response As EnsLib.HL7.Message)
{
	Quit:$$$IsdefObject(response)
	If ""=..%WaitAll {
		#; Construct an ACK reply object and return that
		$$$sysTRACE("Constructing an "_$S($$$ISERR(..%ErrorStatus):"error NACK",1:"OK ACK")_" as response from routing BP "_..%Id()_" due to no ACK received from any declared target")
		Set tSCErr=..%ErrorStatus, tSC=..OnConstructReply(.response, request,.tSCErr)  If $$$ISERR(tSC) $$$LOGSTATUS(tSC)  Quit
		Set:""=$G(response) response=..constructReply(request,tSCErr)
	} Else {
		#; Construct a batch reply document containing all replies...
		Set tSCErr="batch", tSC=..OnConstructReply(.response, request,.tSCErr)
		If $$$ISERR(tSC) $$$LOGSTATUS(tSC)  Quit
		Quit:$$$IsdefObject(response)
		If tSCErr'="batch" {
			$$$sysTRACE("Constructing non-batch "_$S($$$ISERR(tSCErr):"ACK",1:"NACK")_" because OnConstructReply() returned no response object but error "_$$$StatusDisplayString(tSCErr))
			Set response=..constructReply(request,tSCErr)
		} Else {
			$$$sysTRACE("Constructing batch "_$S("-"=..%WaitAll:"NACK",1:"ACK"))
			Set tBatch=request.NewReplyDocument(, ..LocalFacilityApplication)
			If ""'=request.MessageTypeCategory {
				Do tBatch.PokeTypeCategory(request.MessageTypeCategory)
				Set tBatch.DocType=request.MessageTypeCategory_":BHS"
			}
			Do tBatch.SetValueAt("BHS","1:0")
			 , tBatch.SetValueAt(tBatch.GetValueAt("1:10"),"1:11")
			 , tBatch.SetValueAt("Routing fanout Batch "_$S("-"=..%WaitAll:"NACK",1:"ACK"),"1:10")
			 , tBatch.SetValueAt(request.GetValueAt("1:10"),"1:12")
			 , tBatch.SetValueAt("","1:13")
			Set childs=0, tCnt=..%ResponseList.Count()  For i=1:1:tCnt { Set tHdrId=..%ResponseList.GetAt(i)
				Set tIsError=0,tErrStatus=$$$OK,tTarget=""
				&sql(Select IsError,ErrorStatus,TargetConfigName,MessageBodyClassName,MessageBodyId Into :tIsError,:tErrStatus,:tTarget,:tBodyClass,:tBodyId From Ens.MessageHeader where ID=:tHdrId)
				If 'SQLCODE {
					If 'tIsError&&(""'=tBodyClass) {
						Set child=$zobjclassmethod(tBodyClass,"%OpenId",tBodyId,,.tSC)
						If $IsObject(child) { Set childs=childs+1, childs(childs)=child, tErrStatus="" }
						Else { Set tIsError=1, tErrStatus=$$$ERROR($$$EnsErrGeneral,"Unable to open message body for response "_tHdrId_" : "_$$$StatusDisplayString(tSC)) }
					} ElseIf ""=tTarget {
						#; Delete temp header we used to hold the error code
						Do ##class(Ens.MessageHeader).%DeleteId(tHdrId)
					}
				}
				Set:""'=tErrStatus childs=childs+1, childs(childs)=..constructReply(request,tErrStatus,$S(""=tTarget:"",1:tHdrId))
			}
			Set seg=##class(EnsLib.HL7.Segment).%New()
			Set seg.Separators=tBatch.Separators
			Do seg.SetValueAt("MessageDocsRef"_seg.FS_2)
			Do tBatch.SetSegmentAt(seg,2)
			Set bts=##class(EnsLib.HL7.Segment).%New()
			Set bts.Separators=tBatch.Separators
			Do bts.SetValueAt("BTS"_bts.FS_childs)
			Do tBatch.SetSegmentAt(bts,3)
			Do tBatch.AddChildArray(2, .childs)
			Set response=tBatch
		}
	}
}

Method constructReply(pOriginalDoc As EnsLib.EDI.Document, pSC As %Status, pHeaderId As %String = "") As EnsLib.EDI.Document
{
	Set tReplyDoc=pOriginalDoc.NewReplyDocument(,..LocalFacilityApplication)
	Set tReplyDoc.Source=pOriginalDoc.%Id()
	Do:..#UseOriginalControlId tReplyDoc.SetValueAt(pOriginalDoc.GetValueAt("1:10"),"1:10") ; copy the control id to the ack control id
	Set tAckMSA=##class(EnsLib.HL7.Segment).%New($LB("",1))
	Set tAckMSA.Separators=tReplyDoc.Separators
	Do tAckMSA.SetValueAt("MSA",0)
	Set tAckType=$E(..AckType)  Set:""=tAckType tAckType="A"
	Set tNackCode=$E(..NackCode)  Set:""=tNackCode tNackCode="E"
	Do tAckMSA.SetValueAt(tAckType_$S($$$ISOK(pSC):"A",1:tNackCode),1)
	Do tAckMSA.SetValueAt(pOriginalDoc.GetValueAt("1:10"),2)
	Do:$G($$$ExpectedSequenceNumber) tAckMSA.SetValueAt($$$ExpectedSequenceNumber,4)
	#; Deprecated since v2.1 - Do tAckMSA.SetValueAt($S(pForwardMsg:"D",1:"F"),5//"DelayedAcknowledgmentType")
	Do tReplyDoc.AppendSegment(tAckMSA)
	If ..AddNackERR&&$$$ISERR(pSC) {
		// Now build an ERR segment in case of error
		Set tAckERR=##class(EnsLib.HL7.Segment).%New($LB("",1))
		Set tAckERR.Separators=tReplyDoc.Separators
		Do tAckERR.SetValueAt("ERR",0)
		#;Do tAckERR.SetValueAt("207"_tAckERR.CS_"Application internal error",3) 
		Do tAckERR.SetValueAt("E",4)  // It's an error
		Do tAckERR.SetValueAt($P($system.Status.GetErrorCodes(pSC),","),5)
		Do tAckERR.SetValueAt(tAckERR.Escape($$$StatusDisplayString(pSC)_$S(""=pHeaderId:"",1:" (HdrId="_pHeaderId_")")),8)
		Do tReplyDoc.AppendSegment(tAckERR)
	}
	Set tReplyDoc.IsMutable=0
	Quit tReplyDoc
}

/// Override this method to construct a customized reply document. Inputs are the original document and
///  the status code that the framework produced in processing the original document.
///  If you change the status code but do not construct a reply document, the framework will use the new value to construct a standard reply document.
Method OnConstructReply(Output pReplyDoc As EnsLib.HL7.Message, pOriginalDoc As EnsLib.HL7.Message, ByRef pSC As %Status) As %Status
{
	Quit $$$OK
}

Storage Default
{
<Data name="RoutingEngineDefaultData1">
<Subscript>"RoutingEngine1"</Subscript>
<Value name="1">
<Value>LocalFacilityApplication</Value>
</Value>
<Value name="2">
<Value>AckType</Value>
</Value>
<Value name="3">
<Value>NackCode</Value>
</Value>
<Value name="4">
<Value>AddNackERR</Value>
</Value>
</Data>
<DefaultData>RoutingEngineDefaultData1</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
