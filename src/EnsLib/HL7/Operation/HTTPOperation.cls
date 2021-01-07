/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.HL7.Operation.HTTPOperation Extends EnsLib.HL7.Operation.ReplyStandard [ ClassType = "", ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Method OnInit() As %Status
{
	Set tSC=##super()
	Set:$$$ISOK(tSC) ..%Parser.StartTimeout=..Adapter.ResponseTimeout
	Set ..Adapter.SkipBodyAttrs=""
	Quit tSC
}

Method SendMessage(pMsgOut As EnsLib.HL7.Message, Output pMsgIn As EnsLib.HL7.Message, pExpectedSequenceNumber As %String) As %Status
{
	Set pMsgIn=$$$NULLOREF, tHttpRequest=##class(%Net.HttpRequest).%New(), tHttpRequest.WriteRawMode=1
	Set tMetaIOStream=##class(%IO.MetaCharacterStream).%New(tHttpRequest.EntityBody)
	Set tSC=..OutputFramedToIOStream(tMetaIOStream,pMsgOut,..Separators,pExpectedSequenceNumber,1,..IOLogEntry)  Quit:$$$ISERR(tSC) tSC
	Set tHttpRequest.ResponseStream=##class(%IO.StringStream).%New()
	Set tSC=..Adapter.SendFormDataArray(.tHttpResponse, "Post", tHttpRequest)
	#; Account for Adapter generating an error based on StatusCode
	If $$$ISERR(tSC),'$$$StatusEquals(tSC,$$$EnsErrHTTPStatus) Quit tSC
	If $IsObject(tHttpResponse.Data),tHttpResponse.Data.Size {
		Set tSC1=..%Parser.ParseFramedIOStream(tHttpResponse.Data,.pMsgIn,0,..IOLogEntry)  Quit:$$$ISERR(tSC1) $$$ADDSC(tSC,tSC1)
	}
	Set:$$$StatusEquals(tSC,$$$EnsErrHTTPStatus) tSC=$$$OK
	Quit:$$$ISERR(tSC) tSC
	#; If no body response message, construct an ACK message from the HTTP Status Code
	If '$IsObject(pMsgIn) {
		Set pMsgIn=pMsgOut.NewReplyDocument()
		Set pMsgIn.Envelope="ACK_HTTP_"_+tHttpResponse.StatusCode_":"_tHttpResponse.StatusLine
		Set tCode="A"_$Case(+tHttpResponse.StatusCode, 200:"A", 503:"R", :"E")
		#; Create a message object to represent the HTTP ACK ; set 00 control id, 2.1 version
		Do pMsgIn.SetValueAt($TR($P(pMsgIn.Envelope,":"),"_",pMsgIn.CS),"1:9")
		Set tControlId=pMsgOut.GetValueAt("1:10") Set tControlId=$S(""'=tControlId:tControlId,1:"00")
		Do pMsgIn.SetValueAt("00","1:10")
		Do pMsgIn.SetValueAt(2.1,"1:12")
		Set tDesc="HTTP "_$S("AA"=tCode:"",1:"(N)")_"ACK '"_tHttpResponse.StatusLine_"'"
		If $IsObject(tHttpResponse.Data) {
			Do tHttpResponse.Data.Rewind()
			Set tDesc=tDesc_$S('tHttpResponse.Data.Size:"",1:" : "_tHttpResponse.Data.Read(1000))
		}
		Set tMSAText="MSA"_pMsgIn.FS_tCode_pMsgIn.FS_tControlId_pMsgIn.FS_tDesc
		Set tAckMSA=##class(EnsLib.HL7.Segment).%New($LB(,1,,pMsgIn.Separators_tMSAText))
		Do pMsgIn.AppendSegment(tAckMSA)
	}
	Quit tSC
}

}
