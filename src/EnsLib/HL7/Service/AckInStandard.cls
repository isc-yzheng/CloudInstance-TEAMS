/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// A specialized HL7 TCP Service that receives ACKs on behalf of a paired HL7 TCP Operation It also
/// depends on this partner Operation to send ACKs on its behalf, for example to respond to messages from a dual-channel iSoft iCM application.
Class EnsLib.HL7.Service.AckInStandard Extends EnsLib.HL7.Service.Standard [ ClassType = "", ProcedureBlock, System = 4 ]
{

/// ConfigName of the partner operation used to send application ACK responses for this Service
Property PartnerOperation As %String(MAXLEN = 128);

Parameter SETTINGS = "PartnerOperation,ImmediateByteAck";

/* Remove 'Byte' options from inherited definition; controlled by 'ImmediateByteAck' instead */
/// Control of ACK handling; ACKs are returned on a separate TCP socket via the Partner Operation. On this service's channel each received message may also be acknowledged with an immediate byte response, according to the value of the ImmediateByteAck setting.
/// Options:
/// - Never : Do not send any ACK
/// - Immediate : Send (commit) ACK reply message immediately upon receipt of the inbound message
/// - Application : If message passes validation, wait for ACK from target config item and forward it when it arrives
/// - MSH-determined : Send ACK messages as requested in the MSH header of the incoming message
Property AckMode As %String(DISPLAYLIST = ",Never,Immediate,Application,MSH-determined", VALUELIST = ",Never,Immed,App,Msh") [ InitialExpression = "App", Required ];

/* Override inherited default value */
/// Ignore inbound ACK messages to avoid ACK feedback loop
Property IgnoreInboundAck As %Boolean [ InitialExpression = 0 ];

/* Override inherited default value */
/// In addition to forwarding a full ACK message according to the AckMode setting, return immediate 1-byte ACKs on this Service's TCP connection
Property ImmediateByteAck As %Boolean [ InitialExpression = 1 ];

Method OnInit() As %Status
{
	#; There are 3 types of message we receive or generate and then enqueue from here:
	#; 1: normal inbound messages; we queue these to their configured targets
	#; 2: inbound Application ACKs corresponding to messages sent by our partner Operation; these we queue to our partner Service on a special ACK_ queue
	#; 3: ACKs that we construct to match type 1 messages we receive; we queue these to the partner Operation at top priority

	Quit:""=..PartnerOperation||(""=$G($$$DispatchNameToConfigName(..PartnerOperation))) $$$ERROR($$$EnsErrGeneral,"Configured PartnerOperation '"_..PartnerOperation_"' is not registered to run")
	Quit:'$classmethod($$$ConfigClassName(..PartnerOperation),"%Extends","EnsLib.HL7.Operation.AckOutStandard") $$$ERROR($$$EnsErrGeneral,"Configured PartnerOperation '"_..PartnerOperation_"' does not extend EnsLib.HL7.Operation.AckOutStandard")
	Quit ##super()
}

Method SendEarlyReply(pReplyDocument As EnsLib.EDI.Document, pOriginalDoc As EnsLib.EDI.Document) As %Status
{
	#; reply with 1-byte ACK on our own socket, or the Commit ACK from a dual-ACK response specified via MSH
	$$$ASSERT((..AckMode="Msh"&&'..ImmediateByteAck)||'$IsObject(pReplyDocument))
	Quit $this.NormalSendReply(pReplyDocument,pOriginalDoc)
}

Method SendReply(pReplyDocument As EnsLib.EDI.Document, pOriginalDoc As EnsLib.EDI.Document = {$$$NULLOREF}) As %Status
{
	$$$ASSERT($IsObject(pReplyDocument))

	#; Forward type 3 Application ACKs to PartnerOperation at top priority
	Set tSessionId=..%SessionId
	Set tSC = ##class(Ens.MessageHeader).NewRequestMessage(.tMsgHeader,pReplyDocument,.tSessionId) Quit:$$$ISERR(tSC) tSC
	Set tMsgHeader.SourceConfigName = ..%ConfigName
	Set tMsgHeader.TargetConfigName = ..PartnerOperation
	Set tMsgHeader.SourceBusinessType = $$$eHostTypeService
	Set tMsgHeader.TargetBusinessType = $$$ConfigBusinessType(..PartnerOperation)
	Set tMsgHeader.TargetQueueName = $$$ConfigQueueName(..PartnerOperation)
	Set tMsgHeader.Priority = $$$eMessagePriorityHighSync ; the Operation must be able to get these ahead of all others

	Set tSC=##class(Ens.Queue).EnQueue(tMsgHeader)
	Set (..%SessionId,$$$JobSessionId)=tSessionId
	Quit tSC
}

/// Returning nonzero means we are handling it and the normal framework should ignore it
Method OnInboundAck(pDoc As EnsLib.EDI.Document, pMSH As EnsLib.HL7.Segment, ByRef pSC As %Status) As %Boolean
{
	If ..IgnoreInboundAck {
		$$$LOGWARNING("Not processing inbound "_pDoc.Name_" message "_pDoc_"/"_pDoc.%Id())
		Set pDoc.IsMutable=0
	} Else {
		Set tSC=pSC, tSCVal=..resolveAndIndex(pDoc,pMSH)
		If $$$ISOK(tSCVal) {
			#; Forward type 2 inbound Application ACKs to PartnerOperation on special ACK_ queue
			Set tSessionId=..%SessionId
			Set tSC = ##class(Ens.MessageHeader).NewRequestMessage(.tMsgHeader,pDoc,.tSessionId) Quit:$$$ISERR(tSC) tSC
			Set tMsgHeader.SourceConfigName = ..%ConfigName
			Set tMsgHeader.TargetConfigName = ..PartnerOperation
			Set tMsgHeader.SourceBusinessType = $$$eHostTypeService
			Set tMsgHeader.TargetBusinessType = $$$ConfigBusinessType(..PartnerOperation)
			Set tMsgHeader.TargetQueueName = "ACK_"_..PartnerOperation
			Set tMsgHeader.Priority = $$$eMessagePriorityHighSync ; doesn't really matter because no other messages will be on the queue
	
			Set tSC=##class(Ens.Queue).EnQueue(tMsgHeader)
			Set (..%SessionId,$$$JobSessionId)=tSessionId
			Set ..%RequestHeader=tMsgHeader
		}
		If ..ImmediateByteAck {
			Set tReplyCode=..getReplyCode(pMSH,tSC,tSCVal,-1)
			Do ..reportReply(pDoc,tReplyCode,.tSC,-1)
		}
	}
	Quit 1
}

ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("PartnerOperation",.tValue) {
		For i=1:1:$L(tValue,",") { Set tOne=$ZStrip($P(tValue,",",i),"<>W")  Continue:""=tOne  Set pArray(tOne)="" }
	}
}

}
