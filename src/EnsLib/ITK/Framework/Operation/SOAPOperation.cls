/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This class is the internal ITK switchboard send operation.
/// This class should not be used outside of the ITK Switchboard
Class EnsLib.ITK.Framework.Operation.SOAPOperation Extends EnsLib.ITK.Framework.Operation.SOAPOperationBase [ System = 4 ]
{

/// The Application category for the Device that this Business Operation sends messages to.
/// Set this as ApplicationCategory:DeviceName e.g. Kiosk:WardAKiosk.
/// Where there is only one device in a category just specify the category e.g. Kiosk.
/// This is used as the Subscription Queue name if the operation is switched to Subscription Pull mode. And it is also used in the SLA Reporting. This is a free text and should be set to a suitable alias for the target application.
Property ApplicationName As %String;

/// Flag to indicate if the receving system wants ITK to hold the messages untill requested.
Property SubscriptionPull As %Boolean [ InitialExpression = 0 ];

/// Maximum number of messages served to a GetMessage request (-1 for no limit).
Property SubscriptionPullLimit As %Integer(MINVAL = -1) [ InitialExpression = -1 ];

Parameter SETTINGS = "ApplicationName,SubscriptionPull,SubscriptionPullLimit";

XData MessageMap
{
<MapItems>
  <MapItem MessageType="EnsLib.ITK.Framework.RequestData">
    <Method>SendWebRequest</Method>
  </MapItem>  
</MapItems>
}

/// Overridden to handle the case we are in subscription pull mode or
/// we need to get the messages for the subscription (i.e. a pull)
Method SendWebRequest(pRequest As EnsLib.ITK.Framework.RequestData, pResponse As EnsLib.ITK.Framework.ResponseData) As %Status
{
	// Note: Could cache the service definition at this point
	set sd = ##class(EnsLib.ITK.Setup.ServiceDefinition).%OpenId(pRequest.ServiceName)
	if '$IsObject(sd) {
		Set sc=$$$ERROR($$$EnsErrGeneral, $$$ITKInvalidRequest_"Service "_pRequest.ServiceName_" is not registered.")
		$$$LOGERROR($$$ITKInvalidRequest_"Service "_pRequest.ServiceName_" is not registered.")
		
		set pResponse = ##class(EnsLib.ITK.Framework.ResponseData).%New()
		set pResponse.Status = sc
		
		quit $$$OK
	}
	
	// Go get the messages or act upon pull request
	if sd.BehaviourType=$$$ITKBPQueueCollection {
		quit ..HandleSubscriptionPullRequest(sd, pRequest, .pResponse)
	}
	
	// If in subscription pull, save the messages
	elseif ..SubscriptionPull {
		quit ..StoreSubscriptionMessage(sd, pRequest, .pResponse)
	}
	
	// Otherwise just go to the base
	else {
		set sc=##super(pRequest, .pResponse)
		if pResponse'="" {
			set pResponse.RequestInvocationPattern = pRequest.InvocationPattern
			set pResponse.RequestMessageId = pRequest.MessageId
		}
		quit sc
	}
}

/// Overridden to save the request/response message away for later
/// correlation.
Method OnITKRequest(pStatus As %Status, pRequest As EnsLib.ITK.Framework.RequestData, tMessageId As %String, tBehaviourType As %String) As %Status
{
	// Keep a callbacklog for all request types.
 	if (tBehaviourType=$$$ITKBPRequestResponse)
 	{
		Set tCallBackLog = ##class(EnsLib.ITK.Framework.CallBackLog).%New()
		Set tCallBackLog.RequestMessageId = pRequest.MessageId
		Set tCallBackLog.RelatedMessageId = tMessageId
		Set tCallBackLog.RequestSessionId = ..%SessionId
		Set tCallBackLog.RelatedMessageSentTo = ..ApplicationName
		Set tCallBackLog.Status = $$$ITKResponsePending
		Set tCallBackLog.CallBackLogCreated = $ZDATETIME($ZTIMESTAMP,3,1,6)
		
		Set tSC = tCallBackLog.%Save()
 	}
 	
 	quit $$$OK
}

/// This method determines the payload. This is either as per the request
/// or if the request status is not OK then it forms a fault payload.
Method DeterminePayload(pRequest As EnsLib.ITK.Framework.RequestData, ByRef payload As %Stream.Object) As %Status
{
	if $$$ISOK(pRequest.Status) {
		if $IsObject(pRequest.DistributionEnvelope) {
			set tDe=pRequest.DistributionEnvelope.OutputToString(,.sc)
			set en=$FIND(tDe, ">@@PAYLOAD@@<")
			
			set payload=##class(%Stream.GlobalCharacter).%New()
			do payload.Write($EXTRACT(tDe, 1, (en-$LENGTH(">@@PAYLOAD@@<"))))
			do payload.CopyFrom(pRequest.Payload)
			do payload.Write($EXTRACT(tDe, en-1, *))
			do payload.Rewind()
		}
		else {
			set payload=pRequest.Payload 
		}
	}
	else { 
		do ..MakeFaultPayload(pRequest.FaultCode, pRequest.Status, .payload) 
	}
	
	quit $$$OK
}

/// This method determines the logical url to send the request into
/// Note the default endpoint is used if there is one 
Method DetermineLogicalURL(pRequest As EnsLib.ITK.Framework.RequestBase, ByRef pUrl As %String) As %Status
{
	set sc = $$$OK
	
	set pUrl=..EndpointBaseURL
	set:pUrl="" pUrl=..Adapter.WebServiceURL
	
	if pRequest.ResolvedEndpoint="" {
		Set partialLogicalURL = ##class(EnsLib.ITK.Setup.ConsumerServiceRegistry).GetEndpoint(..ApplicationName, pRequest.ServiceName, 1)
	}
	else {
		Set partialLogicalURL = $E(pRequest.ResolvedEndpoint,$L(..EndpointBaseURL)+1,*)
	}

	// Add partial to back of standard endpoint
	set pUrl = pUrl_partialLogicalURL
	
	quit sc
}

/// The method determines the physical url to send the request into
Method DeterminePhysicalURL(pRequest As EnsLib.ITK.Framework.RequestBase, ByRef pUrl As %String) As %Status
{
	set sc = $$$OK
	
	// Find partial physicaly from registry, if there is not one, use the partial logical
	set partialPhysicalURL = ##class(EnsLib.ITK.Setup.ConsumerServiceRegistry).GetEndpoint(..ApplicationName, pRequest.ServiceName, 0)
	if partialPhysicalURL="" {
		if pRequest.ResolvedEndpoint="" {
			Set partialPhysicalURL = ##class(EnsLib.ITK.Setup.ConsumerServiceRegistry).GetEndpoint(..ApplicationName, pRequest.ServiceName, 1)
		}
		else {
			set partialPhysicalURL = $E(pRequest.ResolvedEndpoint,$L(..EndpointBaseURL)+1,*)
		}
	}
	
	// Form URL from the base inside the url and the partial logical from registry
	set pUrl = ..Adapter.WebServiceURL_partialPhysicalURL
	
	quit sc
}

/// This method determines the invocation pattern for the request.
/// This must be implemented by the derived class
Method DetermineInvocationPattern(pRequest As EnsLib.ITK.Framework.RequestBase, ByRef pattern As %String) As %Status
{
	set sc = $$$OK
	
	set tAppName = $P(..ApplicationName, ":", 1)
	
	set sd = ##class(EnsLib.ITK.Setup.ServiceDefinition).%OpenId(pRequest.ServiceName)
	if '$IsObject(sd) {
		set sc=$$$ERROR($$$EnsErrGeneral,$$$ITKInvalidRequest_"Service "_pRequest.ServiceName_" is not registered.")
	}
	elseif (sd.BehaviourType '= $$$ITKBPFaultHandler) && (sd.BehaviourType '= $$$ITKBPAsynchResponseHandler)
	{
		Set csr = ##class(EnsLib.ITK.Setup.ConsumerServiceRegistry).%OpenId(tAppName_"||"_pRequest.ServiceName)
		
		if '$IsObject(csr) {
			set sc=$$$ERROR($$$EnsErrGeneral,$$$ITKInvalidRequest_$$$ITKFaultUnregisteredConsumerCapability(pRequest.ServiceName))
		}
		else {
			set pattern = csr.InvocationPattern
		}
	}
	else {
		set pattern = $$$ITKAsyncInvocationPattern
	}
	
	quit sc
}

/// This method determines the URL to send request into
Method DetermineAddressing(pRequest As EnsLib.ITK.Framework.RequestBase, ByRef fromURL As %String, ByRef relatesTo As %String) As %Status
{
	set fromURL = pRequest.To
	set relatesTo=pRequest.RelatesTo
	
	quit $$$OK
}

/// This method determines the application the business operation represents
Method DetermineApplication(pRequest As EnsLib.ITK.Framework.RequestBase, ByRef appName As %String) As %Status
{
	set application=$P(..ApplicationName,":")
	Quit $$$OK
}

/// This method builds a response message and populates it with specifics relevant to the context
Method GenerateResponse(pRequest As EnsLib.ITK.Framework.RequestBase, pResponseInvocationPattern As %String, pBehaviourType As %String, sourceApplication As %String) As EnsLib.ITK.Framework.ResponseBase
{
	set tResponse = ##class(EnsLib.ITK.Framework.ResponseData).%New()
	set tResponse.ResponseInvocationPattern = pResponseInvocationPattern
	set tResponse.RequestInvocationPattern = pRequest.InvocationPattern
	set tResponse.BehaviourType = pBehaviourType
	set tResponse.SourceApplication = sourceApplication

	Quit tResponse
}

/// This is called when forming the SOAP header if we have an asynchronous request.
/// We use the SenderRegistry to get the name of the business service that the 
/// application is registered to use for the response and fault services
Method DetermineAsyncReplyAddresses(ByRef pReplyTo As %String, ByRef pFaultTo As %String) As %Status
{
	set pReplyTo=""
	set pFaultTo=""
	
	// Get Response Endpoint Business Service Name
	Set tApp = $P(..ApplicationName, ":", 1)

	Set bs = ##class(EnsLib.ITK.Setup.SenderRegistry).GetAsyncResponseHandler(tApp)
	set:bs'="" pReplyTo=##class(Ens.Director).GetHostSettingValue($$$EnsRuntime("Name")_"||"_bs,"EndpointURL",.tSC)

	Set fhbs = ##class(EnsLib.ITK.Setup.SenderRegistry).GetAsyncFaultHandler(tApp)
	set:fhbs'="" pFaultTo=##class(Ens.Director).GetHostSettingValue($$$EnsRuntime("Name")_"||"_fhbs,"EndpointURL",.tSC)
	
	quit $$$OK
}

/// Called when the request is to pull something from the subscription
Method HandleSubscriptionPullRequest(pService As EnsLib.ITK.Setup.ServiceDefinition, pRequest As EnsLib.ITK.Framework.RequestData, pResponse As EnsLib.ITK.Framework.ResponseData) As %Status
{
	set sc=$$$OK
	Set tResponse = ""
	
	set pResponse = ##class(EnsLib.ITK.Framework.ResponseData).%New()
	set pResponse.Status=sc
	
	try {
		if (pService.RequestClass="")
		{
			Set sc=$$$ERROR($$$EnsErrGeneral,$$$ITKInvalidRequest_$$$ITKFaultBadRequestClass(pRequest.ServiceName))
			throw
		}
		
		set tRequestDoc=##class(EnsLib.EDI.XML.Document).ImportFromLibraryStream(pRequest.Payload, .tSC)
		
		If (pRequest.ServiceName = "ConfirmMessageReceipt-v1-0") 
		{	
			Set sc = ..UpdateQueueStatus(tRequestDoc, .tResponse)
		}
		elseif (pRequest.ServiceName = "GetMessages-v1-0") 
		{
			Set sc = ..GetUncollectedMessages(tRequestDoc, .tResponse)
		}
		elseif (pRequest.ServiceName = "SwitchQueueCollectionMode-v1-0") 
		{
			Set sc = ..SwitchQueueMode(tRequestDoc, .tResponse)
		}
		else
		{
			Set sc=$$$ERROR($$$EnsErrGeneral,$$$ITKInvalidRequest_$$$ITKFaultUnknownqueueService(pRequest.ServiceName))
			throw
		}
	}
	catch ex {
		set:sc=1 sc=$$$ERROR($$$EnsErrGeneral, $ZERROR)
		$$$LOGERROR($ZERROR)
	}
	
	Set pResponse.MessageId = ""
	set pResponse.ResponseInvocationPattern = ""
	Set pResponse.RequestInvocationPattern = pRequest.InvocationPattern
	Set pResponse.BehaviourType = pService.BehaviourType
	Set pResponse.SourceApplication = $P(..ApplicationName, ":", 1)
	set pResponse.ResponseBody = $G(tResponse,"")
	Set pResponse.Status = sc
	
	quit $$$OK
}

/// Called when the service is in subscription pull mode to simply store the request
Method StoreSubscriptionMessage(pService As EnsLib.ITK.Setup.ServiceDefinition, pRequest As EnsLib.ITK.Framework.RequestData, ByRef pResponse As EnsLib.ITK.Framework.ResponseData) As %Status
{
	set sc=$$$OK
	
	try {
		if ( (pService.BehaviourType = $$$ITKBPFaultHandler) || (pService.BehaviourType = $$$ITKBPAsynchResponseHandler) || (pService.BehaviourType=$$$ITKBPPost) || ((pService.BehaviourType=$$$ITKBPRequestResponse) && (pRequest.InvocationPattern=$$$ITKAsyncInvocationPattern) ) ) {
	 	
		 	Set tQueueName = $P(..ApplicationName, ":", 2)
		 	If (tQueueName = "") Set tQueueName = $P(..ApplicationName, ":", 1)
	 	
			Set tLog = ##class(EnsLib.ITK.Framework.SubscriptionPullLog).%New()
			Set tLog.MessageHeadId = ..%RequestHeader.%Id()
			Set tLog.ServiceName = pRequest.ServiceName
			Set tLog.SubscriptionPullStatus = $$$ITKSubscriptionPullUncollected
			Set tLog.SubscriptionQueueName = tQueueName
			Set tLog.SubscriptionPullMsgCreatedDate = $ZDATETIME($ZTIMESTAMP,3,1,6)
			Do tLog.%Save()
		
			Set ..SuspendMessage = 1
		}
 		else
 		{
 			set sc=$$$ERROR($$$EnsErrGeneral, $$$ITKNonRetryableError_$$$ITKFaultBadSubscriptionCall)
	 		throw
 		}
 	}
	catch ex {
		set:sc=1 sc=$$$ERROR($$$EnsErrGeneral, $ZERROR)
		$$$LOGERROR($ZERROR)
	}
	
	Set pResponse = ##class(EnsLib.ITK.Framework.ResponseData).%New()
	Set pResponse.MessageId = ""
	set pResponse.ResponseInvocationPattern = $$$ITKAsyncInvocationPattern
	Set pResponse.RequestInvocationPattern = pRequest.InvocationPattern
	Set pResponse.BehaviourType = pService.BehaviourType
	Set pResponse.SourceApplication = $P(..ApplicationName, ":", 1)
	Set pResponse.ResponseBody = ""
	Set pResponse.Status = sc
	
	quit $$$OK
}

Method GetUncollectedMessages(pDoc As EnsLib.EDI.XML.Document, ByRef pResponseBody As %GlobalCharacterStream) As %Status
{
	Set sc =$$$OK
	Set $ZT = "OnError"	
	
	set pQueueName=pDoc.GetValueAt("*:/QueueMessage/QueueName")
	set pServiceName=pDoc.GetValueAt("*:/QueueMessage/ServiceMessageType")
	set pMessageCount=pDoc.GetValueAt("*:/QueueMessage/RequestedMessageCount")

	If (pMessageCount = 0) Set pMessageCount = 1
	Set pMessageCount = $S(..SubscriptionPullLimit=-1:pMessageCount, pMessageCount>..SubscriptionPullLimit:..SubscriptionPullLimit , 1:pMessageCount)
	
	Set tResponse = ##class(EnsLib.ITK.Framework.itk.QueueMessageResponse).%New()
	
	Set tLoopCount = 0
	Set tResult =  ""

	If (pServiceName = "") {
		Set tResult = ##class(%ResultSet).%New("EnsLib.ITK.Framework.SubscriptionPullLog:GetMessages")
		Do tResult.Execute(pQueueName, $$$ITKSubscriptionPullUncollected)
	} Else {
		Set tResult = ##class(%ResultSet).%New("EnsLib.ITK.Framework.SubscriptionPullLog:GetMessagesForService")
		Do tResult.Execute(pQueueName, pServiceName, $$$ITKSubscriptionPullUncollected)
	}

	While (tResult.Next(.sc)  && (tLoopCount < pMessageCount)) { 

		Set tResponseMessage = ##class(EnsLib.ITK.Framework.MessageDetails).%New()
		
		Set key = tResult.Get("MessageHeadId")
		Set tMessageHead = ##class(Ens.MessageHeader).%OpenId(key)
		Set:$IsObject(tMessageHead) tMessageBody = $CLASSMETHOD(tMessageHead.MessageBodyClassName, "%OpenId", tMessageHead.MessageBodyId)
				
		If ($IsObject($G(tMessageBody))) {
			Set tResponseMessage.MessagePayload = tMessageBody.Payload 
			Set tResponseMessage.ServiceMessageType = tMessageBody.ServiceName
			Set tResponseMessage.MessageHandle = key

			Do tResponse.Message.Insert(tResponseMessage)

			Set tLog = ##class(EnsLib.ITK.Framework.SubscriptionPullLog).%OpenId(key)
			Set tLog.SubscriptionPullStatus = $$$ITKSubscriptionPullDispatched
			Set tLog.SubscriptionPullMsgStatusUpdatedDate = $ZDATETIME($ZTIMESTAMP,3,1,6)
			Set tLog.SubscriptionPullMsgSentDate = $ZDATETIME($ZTIMESTAMP,3,1,6)
			Set sc = tLog.%Save()
			
			Set tLoopCount = tLoopCount + 1
		}
	}

	Set tResponse.MessageCount = tLoopCount

	set writer=##class(%XML.Writer).%New()
	set sc=writer.OutputToStream(.pResponseBody)
	Set writer.OutputTypeAttribute  = 0
	Set writer.NoXMLDeclaration = 1
	Set writer.ElementQualified   = 1
	set status=writer.RootObject(tResponse)

exit
	Quit sc

OnError
	set sc =$ZERROR
	Set $ZT=""
	
	goto exit
}

Method SwitchQueueMode(pDoc As EnsLib.EDI.XML.Document, ByRef pResponseBody As %GlobalCharacterStream) As %Status
{
	Set sc =$$$OK
	Set $ZT = "OnError"	
	
	set pQueueName=pDoc.GetValueAt("*:/1/QueueName")
	set pQueueMode=$S(pDoc.GetValueAt("*:/1/QueueMode")="true":1, 1:0)
	
	do ##class(Ens.Director).ParseConfigItemName("",.tProd)
	set tProduction=##class(Ens.Config.Production).%OpenId(tProd)

	Set tItemObj = tProduction.FindItemByConfigName(..%ConfigName)
	Set tSettingObj = tItemObj.FindSettingByName("SubscriptionPull")
	Set tSettingObj.Value = pQueueMode
	
	do tProduction.%Save(1)
	
	set ..SubscriptionPull=pQueueMode
	
	set tResponse = ##class(EnsLib.ITK.Framework.itk.QueueSwitchModeResponse).%New()
	set tResponse.QueueMode=pQueueMode
	if ..SubscriptionPull=0
	{
		// unsuspend any pending messages
		
		Set tResult = ##class(%ResultSet).%New("EnsLib.ITK.Framework.SubscriptionPullLog:GetMessages")
		Do tResult.Execute(pQueueName, $$$ITKSubscriptionPullUncollected)

		set iCount=0
		While tResult.Next(.sc)
		{ 
			
			Set key = tResult.Get("MessageHeadId")
			Set sc = ##class(Ens.MessageHeader).ResubmitMessage(key)
			if $$$ISOK(sc)
			{
				set iCount=iCount+1
				do tResponse.MessageHandle.SetAt(iCount,key)
				Set tLog = ##class(EnsLib.ITK.Framework.SubscriptionPullLog).%OpenId(key)
				Set tLog.SubscriptionPullStatus = $$$ITKSubscriptionPullConfirmed
				Set tLog.SubscriptionPullMsgStatusUpdatedDate = $ZDATETIME($ZTIMESTAMP,3,1,6)
				Set tLog.SubscriptionPullMsgSentDate = $ZDATETIME($ZTIMESTAMP,3,1,6)
				Set sc = tLog.%Save()
			}
			else
			{
				$$$LOGERROR($system.Status.GetOneStatusText(sc,1))
				set sc=$$$OK
			}
		}
		Set tResponse.MessageCount = iCount
	}
	
	set writer=##class(%XML.Writer).%New()
	set sc=writer.OutputToStream(.pResponseBody)
	Set writer.OutputTypeAttribute  = 0
	Set writer.NoXMLDeclaration = 1
	Set writer.ElementQualified   = 1
	set status=writer.RootObject(tResponse)
	
exit
	Quit sc

OnError
	set sc =$ZERROR
	Set $ZT=""
	
	goto exit
}

Method UpdateQueueStatus(pDoc As EnsLib.EDI.XML.Document, ByRef pResponseBody As %GlobalCharacterStream) As %Status
{
	Set sc = $$$OK
	Set $ZT="OnError"
	
	set messageCount=pDoc.GetValueAt("*:/1/MessageHandle[*]")
	for i=1:1:messageCount {
		set key=pDoc.GetValueAt("*:/1/MessageHandle["_i_"]")
		
		Set tLog = ##class(EnsLib.ITK.Framework.SubscriptionPullLog).%OpenId(key)
		If ($IsObject(tLog)) {
			Set tLog.SubscriptionPullMsgStatusUpdatedDate = $ZDATETIME($ZTIMESTAMP,3,1,6)
			Set tLog.SubscriptionPullStatus = $$$ITKSubscriptionPullConfirmed
			Set sc = tLog.%Save()		
				
			Set tMessageHead = ##class(Ens.MessageHeader).%OpenId(key)
			If ($IsObject(tMessageHead)) {
				Set tMessageHead.Status = $$$eMessageStatusCompleted
				Set sc = tMessageHead.%Save()
			}				
		}
	}

Exit	
	do ..MakeStandardResponse(.pResponseBody)
	If $$$ISERR(sc) $$$LOGERROR(sc)
	Quit sc
	
OnError
	$$$LOGERROR($ZERROR)
	Set $ZT=""
	Goto Exit
}

/// The helper method forms a simple ITK response containing the stream
/// as it's contents
Method MakeStandardResponse(ByRef pStream As %GlobalCharacterStream)
{
	Set tResponseObj = ##class(EnsLib.ITK.Standard.SimpleMessageResponse).%New()
	Set tResponseStr = ##class(EnsLib.ITK.Util.UtilityMethods).XMLExportToString(tResponseObj,1)
	set pStream=##class(%GlobalCharacterStream).%New()

	Do pStream.Write(tResponseStr)
}

}
