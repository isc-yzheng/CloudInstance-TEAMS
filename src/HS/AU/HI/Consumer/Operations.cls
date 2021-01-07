Include HS.AU.Common

Class HS.AU.HI.Consumer.Operations Extends (HS.Util.SOAPClient.Operations, HS.IHE.Common.Actor.Base, HS.Util.XSLTTransformer) [ Inheritance = right, ProcedureBlock ]
{

Parameter SETTINGS;

/// Allow a different header class by overriding paramter value
Parameter HEADERCLASS = "HS.AU.HI.WebRequest";

XData MessageMap
{
<MapItems>
<MapItem MessageType="HS.AU.Message.HI.SearchIHIRequest"> 
<Method>SearchIHI</Method>
</MapItem>
<MapItem MessageType="HS.AU.Message.HI.SearchIHIBatchSyncRequest"> 
<Method>SearchIHIBatchSync</Method>
</MapItem>
<MapItem MessageType="HS.AU.Message.HI.CreateProvisionalIHIRequest"> 
<Method>CreateProvisionalIHI</Method>
</MapItem>
<MapItem MessageType="HS.AU.Message.HI.CreateUnverifiedIHIRequest"> 
<Method>CreateUnverifiedIHI</Method>
</MapItem>
<MapItem MessageType="HS.AU.Message.HI.MergeProvisionalIHIRequest"> 
<Method>MergeProvisionalIHI</Method>
</MapItem>
<MapItem MessageType="HS.AU.Message.HI.NotifyDuplicateIHIRequest"> 
<Method>NotifyDuplicateIHI</Method>
</MapItem>
<MapItem MessageType="HS.AU.Message.HI.NotifyReplicaIHIRequest"> 
<Method>NotifyReplicaIHI</Method>
</MapItem>
<MapItem MessageType="HS.AU.Message.HI.UpdateIHIRequest"> 
<Method>UpdateIHI</Method>
</MapItem>
<MapItem MessageType="HS.AU.Message.HI.UpdateProvisionalIHIRequest"> 
<Method>UpdateProvisionalIHI</Method>
</MapItem>
<MapItem MessageType="HS.AU.Message.HI.ResolveProvisionalIHIRequest"> 
<Method>ResolveProvisionalIHI</Method>
</MapItem>
<MapItem MessageType="HS.AU.Message.HI.SearchIHIBatchSyncRequest"> 
<Method>SearchIHIBatchSync</Method>
</MapItem>
<MapItem MessageType="HS.AU.Message.HI.SearchIndividualProviderRequest"> 
<Method>SearchIndividualProvider</Method>
</MapItem>
<MapItem MessageType="HS.AU.Message.HI.SearchOrganisationProviderRequest"> 
<Method>SearchOrganisationProvider</Method>
</MapItem>

</MapItems>
}

/// This is the default message handler.  All request types not declared in the message map are delivered here
Method OnMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eOnMessage As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		$$$HSTRACE("In HI Request","Request",pRequest)

		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		If (pRequest.Name = $$$HISearchIHIRequest) {
			Set tAction			= $$$HISearchIHIAction
			Set pResponse.Name	= $$$HISearchIHIResponse
		} ElseIf (pRequest.Name = $$$HISearchIHIBatchSyncRequest) {
			Set tAction			= $$$HISearchIHIBatchSyncAction
			Set pResponse.Name	= $$$HISearchIHIBatchSyncResponse
		} ElseIf (pRequest.Name = $$$HICreateProvisionalIHIRequest) {
			Set tAction			= $$$HICreateProvisionalIHIAction
			Set pResponse.Name	= $$$HICreateProvisionalIHIResponse
		} ElseIf (pRequest.Name = $$$HICreateUnverifiedIHIRequest) {
			Set tAction			= $$$HICreateUnverifiedIHIAction
			Set pResponse.Name	= $$$HICreateUnverifiedIHIResponse
		} ElseIf (pRequest.Name = $$$HIMergeProvisionalIHIRequest) {
			Set tAction			= $$$HIMergeProvisionalIHIAction
			Set pResponse.Name	= $$$HIMergeProvisionalIHIResponse
		
		} ElseIf (pRequest.Name = $$$HINotifyDuplicateIHIRequest) {
			Set tAction			= $$$HINotifyDuplicateIHIAction
			Set pResponse.Name	= $$$HINotifyDuplicateIHIResponse
		} ElseIf (pRequest.Name = $$$HINotifyReplicaIHIRequest) {
			Set tAction			= $$$HINotifyReplicaIHIAction
			Set pResponse.Name	= $$$HINotifyReplicaIHIResponse
		} ElseIf (pRequest.Name = $$$HIResolveProvisionalIHIRequest) {
			Set tAction			= $$$HIResolveProvisionalIHIAction
			Set pResponse.Name	= $$$HIResolveProvisionalIHIResponse
		} ElseIf (pRequest.Name = $$$HIUpdateIHIRequest) {
			Set tAction			= $$$HIUpdateIHIAction
			Set pResponse.Name	= $$$HIUpdateIHIResponse
		} ElseIf (pRequest.Name = $$$HIUpdateProvisionalIHIRequest) {
			Set tAction			= $$$HIUpdateProvisionalIHIAction
			Set pResponse.Name	= $$$HIUpdateProvisionalIHIResponse
		} ElseIf (pRequest.Name = $$$HISearchIndividualProviderRequest) {
			Set tAction			= $$$HISearchIndividualProviderAction
			Set pResponse.Name	= $$$HISearchIndividualProviderResponse
		} ElseIf (pRequest.Name = $$$HISearchOrganisationProviderRequest) {
			Set tAction			= $$$HISearchOrganisationProviderAction
			Set pResponse.Name	= $$$HISearchOrganisationProviderResponse

		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Request type not handled:  " _ pRequest.Name) Quit
		}
		Set tRequest = $classMethod(..#HEADERCLASS,"%New")
		Set tSC= ..InvokeWebService(tRequest,, tAction, pRequest, .tResponse)
		Quit:$$$ISERR(tSC)
		$$$HSTRACE("HI Response","tResponse",tResponse)
		Set pResponse.ContentStream	= tResponse.ContentStream
	}
	Catch eOnMessage {
		Set tSC = eOnMessage.AsStatus()
	}
	
	Quit tSC
}

/// Take Internal SearchIHIRequest and convert to AU IHI request
Method SearchIHI(pRequest As HS.AU.Message.HI.SearchIHIRequest, ByRef pResponse As HS.AU.Message.HI.SearchIHIResponse) As %Status
{
	Quit ..CommonIHIRequest(pRequest,
			.pResponse,
			"AU/HI/SearchIHIRequest.xsl",
			"AU/HI/SearchIHIResponse.xsl",
			$$$HISearchIHIAction,
			$$$HISearchIHIRequest,
			$$$HISearchIHIResponse,
			"searchIHIResponse",
			"HS.AU.Message.HI.SearchIHIResponse")
}

/// Take Internal SearchIHIBatchSyncRequest and convert to AU IHI request
Method SearchIHIBatchSync(pRequest As HS.AU.Message.HI.SearchIHIBatchSyncRequest, ByRef pResponse As HS.AU.Message.HI.SearchIHIBatchSyncResponse) As %Status
{
	Set tSC = ..CommonIHIRequest(pRequest,
			.pResponse,
			"AU/HI/SearchIHIBatchSyncRequest.xsl",
			"AU/HI/SearchIHIBatchSyncResponse.xsl",
			$$$HISearchIHIBatchSyncAction,
			$$$HISearchIHIBatchSyncRequest,
			$$$HISearchIHIBatchSyncResponse,
			"searchIHIBatchResponse",
			"HS.AU.Message.HI.SearchIHIBatchSyncResponse")
	Quit tSC
}

/// Take Internal CreateProvisionalIHIRequest and convert to AU IHI request
Method CreateProvisionalIHI(pRequest As HS.AU.Message.HI.CreateProvisionalIHIRequest, ByRef pResponse As HS.AU.Message.HI.CreateProvisionalIHIResponse) As %Status
{
	Quit ..CommonIHIRequest(pRequest,
			.pResponse,
			"AU/HI/CreateProvisionalIHIRequest.xsl",
			"AU/HI/CreateProvisionalIHIResponse.xsl",
			$$$HICreateProvisionalIHIAction,
			$$$HICreateProvisionalIHIRequest,
			$$$HICreateProvisionalIHIResponse,
			"createProvisionalIHIResponse",
			"HS.AU.Message.HI.CreateProvisionalIHIResponse")

	Quit tSC
}

/// Take Internal CreateUnverifiedIHIRequest and convert to AU IHI request
Method CreateUnverifiedIHI(pRequest As HS.AU.Message.HI.CreateUnverifiedIHIRequest, ByRef pResponse As HS.AU.Message.HI.CreateUnverifiedIHIResponse) As %Status
{
	Quit ..CommonIHIRequest(pRequest,.pResponse,
			"AU/HI/CreateUnverifiedIHIRequest.xsl",
			"AU/HI/CreateUnverifiedIHIResponse.xsl",
			$$$HICreateUnverifiedIHIAction,
			$$$HICreateUnverifiedIHIRequest,
			$$$HICreateUnverifiedIHIResponse,
			"createUnverifiedIHIResponse",
			"HS.AU.Message.HI.CreateUnverifiedIHIResponse")
}

/// Take Internal MergeProvisionalIHIRequest and convert to AU IHI request
Method MergeProvisionalIHI(pRequest As HS.AU.Message.HI.MergeProvisionalIHIRequest, ByRef pResponse As HS.AU.Message.HI.MergeProvisionalIHIResponse) As %Status
{
	Quit ..CommonIHIRequest(
			pRequest,
			.pResponse,
			"AU/HI/MergeProvisionalIHIRequest.xsl",
			"AU/HI/MergeProvisionalIHIResponse.xsl",
			$$$HIMergeProvisionalIHIAction,
			$$$HIMergeProvisionalIHIRequest,
			$$$HIMergeProvisionalIHIResponse,
			"mergeProvisionalIHIResponse",
			"HS.AU.Message.HI.MergeProvisionalIHIResponse")
}

/// Take Internal NotifyDuplicateIHIRequest and convert to AU IHI request
Method NotifyDuplicateIHI(pRequest As HS.AU.Message.HI.NotifyDuplicateIHIRequest, ByRef pResponse As HS.AU.Message.HI.NotifyDuplicateIHIResponse) As %Status
{
	Quit ..CommonIHIRequest(
			pRequest,
			.pResponse,
			"AU/HI/NotifyDuplicateIHIRequest.xsl",
			"AU/HI/NotifyDuplicateIHIResponse.xsl",
			$$$HINotifyDuplicateIHIAction,
			$$$HINotifyDuplicateIHIRequest,
			$$$HINotifyDuplicateIHIResponse,
			"notifyDuplicateIHIResponse",
			"HS.AU.Message.HI.NotifyDuplicateIHIResponse")
}

/// Take Internal NotifyReplicaIHIRequest and convert to AU IHI request
Method NotifyReplicaIHI(pRequest As HS.AU.Message.HI.NotifyReplicaIHIRequest, ByRef pResponse As HS.AU.Message.HI.NotifyReplicaIHIResponse) As %Status
{
	Quit ..CommonIHIRequest(
			pRequest,
			.pResponse,
			"AU/HI/NotifyReplicaIHIRequest.xsl",
			"AU/HI/NotifyReplicaIHIResponse.xsl",
			$$$HINotifyReplicaIHIAction,
			$$$HINotifyReplicaIHIRequest,
			$$$HINotifyReplicaIHIResponse,
			"notifyReplicaIHIResponse",
			"HS.AU.Message.HI.NotifyReplicaIHIResponse")
}

/// Take Internal UpdateIHIRequest and convert to AU IHI request
Method UpdateIHI(pRequest As HS.AU.Message.HI.UpdateIHIRequest, ByRef pResponse As HS.AU.Message.HI.UpdateIHIResponse) As %Status
{
	Quit ..CommonIHIRequest(
			pRequest,
			.pResponse,
			"AU/HI/UpdateIHIRequest.xsl",
			"AU/HI/UpdateIHIResponse.xsl",
			$$$HIUpdateIHIAction,
			$$$HIUpdateIHIRequest,
			$$$HIUpdateIHIResponse,
			"updateIHIResponse",
			"HS.AU.Message.HI.UpdateIHIResponse")
}

/// Take Internal UpdateProvisionalIHIRequest and convert to AU IHI request
Method UpdateProvisionalIHI(pRequest As HS.AU.Message.HI.UpdateProvisionalIHIRequest, ByRef pResponse As HS.AU.Message.HI.UpdateProvisionalIHIResponse) As %Status
{
	Quit ..CommonIHIRequest(
			pRequest,
			.pResponse,
			"AU/HI/UpdateProvisionalIHIRequest.xsl",
			"AU/HI/UpdateProvisionalIHIResponse.xsl",
			$$$HIUpdateProvisionalIHIAction,
			$$$HIUpdateProvisionalIHIRequest,
			$$$HIUpdateProvisionalIHIResponse,
			"updateProvisionalIHIResponse",
			"HS.AU.Message.HI.UpdateProvisionalIHIResponse")
}

/// Take Internal ResolveProvisionalIHIRequest and convert to AU IHI request
Method ResolveProvisionalIHI(pRequest As HS.AU.Message.HI.ResolveProvisionalIHIRequest, ByRef pResponse As HS.AU.Message.HI.ResolveProvisionalIHIResponse) As %Status
{
	Quit ..CommonIHIRequest(
			pRequest,
			.pResponse,
			"AU/HI/ResolveProvisionalIHIRequest.xsl",
			"AU/HI/ResolveProvisionalIHIResponse.xsl",
			$$$HIResolveProvisionalIHIAction,
			$$$HIResolveProvisionalIHIRequest,
			$$$HIResolveProvisionalIHIResponse,
			"resolveProvisionalIHIResponse",
			"HS.AU.Message.HI.ResolveProvisionalIHIResponse")
}

/// Take Internal ResolveProvisionalIHIRequest and convert to AU IHI request
Method SearchIndividualProvider(pRequest As HS.AU.Message.HI.SearchIndividualProviderRequest, ByRef pResponse As HS.AU.Message.HI.SearchIndividualProviderResponse) As %Status
{
	Quit ..CommonIHIRequest(
			pRequest,
			.pResponse,
			"AU/HI/SearchIndividualProviderRequest.xsl",
			"AU/HI/SearchIndividualProviderResponse.xsl",
			$$$HISearchIndividualProviderAction,
			$$$HISearchIndividualProviderRequest,
			$$$HISearchIndividualProviderResponse,
			"searchForProviderIndividualResponse",
			"HS.AU.Message.HI.SearchIndividualProviderResponse")
}

Method SearchOrganisationProvider(pRequest As HS.AU.Message.HI.SearchOrganisationProviderRequest, ByRef pResponse As HS.AU.Message.HI.SearchOrganisationProviderResponse) As %Status
{
	Quit ..CommonIHIRequest(
			pRequest,
			.pResponse,
			"AU/HI/SearchOrganisationProviderRequest.xsl",
			"AU/HI/SearchOrganisationProviderResponse.xsl",
			$$$HISearchOrganisationProviderAction,
			$$$HISearchOrganisationProviderRequest,
			$$$HISearchOrganisationProviderResponse,
			"searchForProviderOrganisationResponse",
			"HS.AU.Message.HI.SearchOrganisationProviderResponse")
}

Method CommonIHIRequest(pRequest As Ens.Request, ByRef pResponse As Ens.Response, pOutXSL = "", pInXSL = "", pAction = "", pRequestName = "", pResponseName = "", pInXSLTag = "", pInXSLObjectType = "") As %Status
{
	#dim tSC As %Status
	#dim eException As %Exception.AbstractException

	Set tSC=$$$OK
	try {
		Set tSC = pRequest.NewResponse(.pResponse)
		Quit:$$$ISERR(tSC)

		#dim tInput as %Stream.GlobalCharacter 
		#dim tWriter as %XML.Writer
  		Set tXSLArguments = ""
		Set tInput = ##class(%Stream.GlobalCharacter).%New()
		Set tWriter = ##class(%XML.Writer).%New()
		Set tSC = tWriter.OutputToStream(tInput)
		Set tSC=tWriter.RootObject(pRequest)
		IF $$$ISERR(tSC) {
	   		$$$LOGERROR("Unable to export request")
	   		Quit
	   	}
		#dim tTarget as %Stream.GlobalCharacter
	   	Set tSC = ..Transform(tInput,pOutXSL,.tTarget,.tXSLArguments) 
		Quit:$$$ISERR(tSC)		
			   	
	 	#dim tStreamTemp as %Stream.GlobalCharacter
		Set tAddRequest = ##class(HS.Message.XMLMessage).%New()
		Set tAddRequest.Name = pRequestName
		Do tAddRequest.AdditionalInfo.SetAt(pAction,"SOAPAction")
		Do:pRequest.AdditionalInfo.IsDefined("ServiceName") tAddRequest.AdditionalInfo.SetAt(pRequest.AdditionalInfo.GetAt("ServiceName"),"ServiceName")
		Do:pRequest.AdditionalInfo.IsDefined("NoSSL") tAddRequest.AdditionalInfo.SetAt(pRequest.AdditionalInfo.GetAt("NoSSL"),"NoSSL")
		Set tAddRequest.SAMLData=pRequest.SAMLData
		Set tAddRequest.ContentStream = tTarget
		Do tAddRequest.ContentStream.Rewind()
		Do tTarget.Rewind() 
		Set tSC=..OnMessage(tAddRequest,.tResponse) 
		Set pResponse.ServiceCallStatus=tSC
		If $$$ISERR(tSC) {
			Set tSC=$$$OK
			Quit
		}

		Kill tXSLArguments
		$$$HSTRACE("Response","tResponse",tResponse)
	   	Set tSC = ..TransformIntoObject(tResponse.ContentStream,pInXSL,.tResponseObject,,pInXSLObjectType,pInXSLTag) 
		Quit:$$$ISERR(tSC)
		If $IsObject(tResponseObject) Set pResponse=tResponseObject
	} Catch eException {
		Set tSC = eException.AsStatus()
		Set pResponse.ServiceCallStatus=tSC
	}
	Quit tSC
}

}
