/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.EDI.ASTM.Operation.TCPOperation Extends EnsLib.EDI.ASTM.Operation.Standard [ ClassType = "", ProcedureBlock, System = 4 ]
{

Parameter ADAPTER;

/// The name of an ASTM service to which outbound messages will be forwarded for sending
/// to a remote ASTM device.  Additionally the IP address of the remote ASTM device may
/// be appended after a colon if the service allows connections from multiple remote
/// devices. Services with JobPerConnection = true will not receive messages from this
/// operation unless the IP address is appended.  Services with JobPerConnection = false
/// will work with just the service name entered here.
Property PartnerService As %String(MAXLEN = 128);

/// This is the GetReply setting from the service's adapters GetReply
Property PartnerServiceGetReply As %Boolean [ InitialExpression = 1 ];

/// In the case a synchronous response is called for by the sender, this value governs how long this Operation should wait for a response from the instrument via the PartnerService.
/// A value of -1 means to wait forever and not fail.  Note that this may prevent un-forced shutdown of this Operation.
Property ResponseTimeout As %Numeric [ InitialExpression = -1 ];

Parameter SETTINGS = "PartnerService:Basic:selector?context={Ens.ContextSearch/ProductionItems?services=1&productionName=@productionId}";

Method OnInit() As %Status
{
	Quit:(""=..PartnerService) $$$ERROR($$$EnsErrGeneral,"PartnerService is not configured")
	Quit:(""=$G($$$DispatchNameToConfigName($P(..PartnerService,":")))) $$$ERROR($$$EnsErrGeneral,"Configured PartnerService '"_..PartnerService_"' is not registered to run")
	Quit:'$classmethod($$$ConfigClassName($P(..PartnerService,":")),"%Extends","EnsLib.EDI.ASTM.Service.TCPService") $$$ERROR($$$EnsErrGeneral,"Configured Partner Service '"_..PartnerService_"' does not extend EnsLib.EDI.ASTM.Service.TCPService")

	#dim tItem As Ens.Host
	#dim tSC As %Status
	Set tItem=##class(Ens.Host).GetShadowInstance($P(..PartnerService,":"),.tSC)
	If $$$ISERR(tSC) Quit tSC
	If ""'=$P(..PartnerService,":",2,99) {
		Quit:""=tItem.Adapter.JobPerConnection&&("!"'=$E(tItem.Adapter.AllowedIPAddresses)) $$$ERROR($$$EnsErrGeneral,"Can only send to PartnerService '"_..PartnerService_"' if it uses JobPerConnection or if a remote IP address is appended to its name")
	}
	#; Safety check before referencing GetReply even though Partner Service extends EnsLib.EDI.ASTM.Service.TCPService
	If $IsObject(tItem.Adapter) && tItem.Adapter.%Extends("EnsLib.EDI.ASTM.Adapter.TCPAdapter") {
		Set ..PartnerServiceGetReply = tItem.Adapter.GetReply
	}

	Quit ##super()
}

Method OnMessage(pRequest As EnsLib.EDI.ASTM.Document, Output pResponse As %Persistent) As %Status
{
	Set pResponse=$$$NULLOREF
	Set tSC=..validateAndIndex(pRequest)  Quit:$$$ISERR(tSC) tSC

	If ""'=$P(..PartnerService,":",2,99) || (""=..%RequestHeader.ReturnQueueName) {
	}
	Set tServiceQueue=$S(
	   ""'=$P(..PartnerService,":",2,99):..PartnerService
	  ,$P(pRequest.Envelope,":")=..PartnerService:pRequest.Envelope
	  ,$P(pRequest.Source,":")=..PartnerService:$P(pRequest.Source,$C(13))
	  ,1:..PartnerService)
	Quit:""=tServiceQueue $$$ERROR($$$EnsErrGeneral,"Unable to determine PartnerService to which to forward ASTM document "_pRequest_"/"_pRequest.%Id())

	#; Output the main Document
	Set tSC=..EnQueueToService(tServiceQueue,pRequest,..%RequestHeader,.tNewRequestHeader)
	Quit:$$$ISERR(tSC)||(""=..%RequestHeader.ReturnQueueName) tSC

	If '..PartnerServiceGetReply  {
		$$$catTRACE("protocol","Not waiting for a response since partner service configured for no reply")
		Quit tSC
	}
	#; Wait (no timeout) for response to come back
	$$$catTRACE("protocol","Waiting for a response from the remote instrument connected to the ASTM partner service '"_tServiceQueue_"' with timeout "_..ResponseTimeout)
	Set tSC=..DeQueueFromService(.pResponse,.tResponseHeader,tNewRequestHeader,..ResponseTimeout)
	Set:$$$ISERR(tSC)&&$$$StatusEquals(tSC,$$$EnsErrInConnectionLost,$$$EnsErrTCPReadTimeoutExpired) ..Retry=1
	Quit tSC
}

ClassMethod EnQueueToService(pTargetQueueName As %String, pRequest As EnsLib.EDI.ASTM.Document, pOriginalHeader As Ens.MessageHeader, Output pNewHeader As Ens.MessageHeader) As %Status [ Internal ]
{
	Set tSC = ##class(Ens.MessageHeader).NewRequestMessage(.pNewHeader,pRequest,pOriginalHeader.SessionId) Quit:$$$ISERR(tSC) tSC
	Set pNewHeader.CorrespondingMessageId = pOriginalHeader.%Id()
	Set pNewHeader.SourceConfigName = pOriginalHeader.TargetConfigName
	Set pNewHeader.TargetConfigName = $P(pTargetQueueName,":")
	Set pNewHeader.SourceBusinessType = $$$eHostTypeOperation
	Set pNewHeader.TargetBusinessType = $$$eHostTypeService
	Set pNewHeader.TargetQueueName = pTargetQueueName
	Set:""'=pOriginalHeader.ReturnQueueName pNewHeader.ReturnQueueName = $$$queueSyncCallQueueName
	Set pNewHeader.Description = "ASTM forwarded message"
	Quit ##class(Ens.Queue).EnQueue(pNewHeader)
}

/// Code copied from the second half of Ens.Queue:queueRequestSync()
ClassMethod DeQueueFromService(Output pResponse As EnsLib.EDI.ASTM.Document, Output pResponseHeader As Ens.MessageHeader, pRequestHeader As Ens.MessageHeader = {$$$NULLOREF}, pTimeout As %Numeric = -1) As %Status [ Internal ]
{
	While 1 {
		Set tSC = ##class(Ens.Queue).DeQueue($$$queueSyncCallQueueName,.tResponseHeader,pTimeout,.tIsTimedOut,0)  Quit:$$$ISERR(tSC)
		Quit:tIsTimedOut 
		Continue:$IsObject(tResponseHeader)=0
		If tResponseHeader.CorrespondingMessageId=pRequestHeader.%Id() {
			If tResponseHeader.IsError {
				Set tSC=tResponseHeader.ErrorStatus
				Do tResponseHeader.SetStatus($$$eMessageStatusCompleted)
				Quit
			}
			If tResponseHeader.MessageBodyClassName'="" {
				Set pResponse=$classmethod(tResponseHeader.MessageBodyClassName,"%OpenId",tResponseHeader.MessageBodyId,,.tSC)
				If pResponse=$$$NULLOREF Set tSC=$$$EnsError($$$EnsErrGeneral,"Could not open MessageBody "_tResponseHeader.MessageBodyId_" for MessageHeader #"_tResponseHeader.%Id()_" with body class "_tResponseHeader.MessageBodyClassName_":"_$$$StatusDisplayString(tSC)) Quit
			}
			Do tResponseHeader.SetStatus($$$eMessageStatusCompleted)
			Quit
		}
		$$$sysTRACE("Out-of-band message '"_tResponseHeader.%Id()_"' discarded")
		Do tResponseHeader.SetStatus($$$eMessageStatusDiscarded)
	}
	Set tSC2 = ##class(Ens.Queue).Delete($$$queueSyncCallQueueName,"*")
	Quit tSC
}

/// Add discarded characters to IO Archive
Method IOLogDiscard(pSC As %Status, pNote As %String, pDiscard As %GlobalCharacterStream) [ Internal ]
{
	Set tIOLogEntry = ..IOLogEntry, ..IOLogEntry=$$$NULLOREF ; Save a separate entry for the unexpected input
	$$$NEWOUTIOLOGENTRY(pSC,pNote,$$$CurrentMethod,"%GlobalCharacterStream")
	$$$CLOSEIOLOGENTRY($$$OK,"",pDiscard)
	Set ..IOLogEntry = tIOLogEntry
}

/// Return an array of connections for drawing lines on the config diagram
ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("PartnerService",.tValue) {
		Set pArray($ZStrip($P(tValue,":"),"<>W"))=""
	}
}

}
