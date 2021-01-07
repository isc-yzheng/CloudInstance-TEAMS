/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (%soap, Ensemble, EnsITK)

/// Performs ITK subscript, fault, queue collection and distribution envelope routing.
Class EnsLib.ITK.Framework.Process.ITKMessageRouter Extends Ens.BusinessProcess [ ProcedureBlock, System = 4 ]
{

/// Configuration item to which to send responses
Property SendReponsesTo As %String;

/// Configuration item to which to send bad messages
Property BadMessageHandler As %String(MAXLEN = 1000);

/// The reportor uri to report any technical errors against	
Property FaultReporterURI As %String;

/// Vocabulary to use for creating fault messages from this Service.
Property FaultVocabulary As %String;

Parameter SETTINGS = "SendReponsesTo,BadMessageHandler,FaultVocabulary,FaultReporterURI";

Method OnRequest(pRequest As Ens.Request, Output pResponse As Ens.Response) As %Status
{
	Set sc = $$$OK
	set faultcode=""
	Quit:'pRequest.%IsA("EnsLib.ITK.Framework.RequestData") $$$ERROR($$$EnsErrGeneral,"Unexpected Message Type :"_$classname(pRequest))
	
	set r = pRequest
	#dim r As EnsLib.ITK.Framework.RequestData
	
	set:$$$ISOK(r.Status) sc=..ValidateContent(r)
	
	set tOriginalMessage=""
	#dim tOriginalMessage As EnsLib.ITK.Framework.RequestData
	
	// If response
	if ($$$ISOK(sc) && (pRequest.InvocationPattern = $$$ITKAsyncResponseInvocationPattern))
	{
		set sc = ..ResolveMessageRelationships(r,.tOriginalMessage)
	}
	
	set service = ##class(EnsLib.ITK.Setup.ServiceDefinition).%OpenId(pRequest.ServiceName)

	if ($$$ISERR(sc))
	{
		$$$LOGWARNING($system.Status.GetOneStatusText(sc,1)_"- Attempting to send fault")
		set sc=..SimulateResponse(pRequest,tOriginalMessage,sc)
	}
	else
	{
		set:pRequest.InvocationPattern=$$$ITKAsyncInvocationPattern sc=..ValidateAddressing(r)
		goto:$$$ISERR(sc) onerror
		
		if (service.BehaviourType=$$$ITKBPQueueCollection)
		{
			set sc=..RouteQueueCollection(r)
		}
		elseif (pRequest.InvocationPattern = $$$ITKAsyncResponseInvocationPattern)
		{
			set sc=..RouteReply(r,tOriginalMessage)
		}
		else
		{
			set sc=..RouteStandardMessage(r, service)
		}
onerror		
		if $$$ISERR(sc) && (..BadMessageHandler '= "")
		{

			 do ..SendRequestAsync(..BadMessageHandler, pRequest, 0)
		}
	}
	Quit sc
}

/// Resolves the endpoints and passes the message onto each unique end point found
Method RouteStandardMessage(pRequest As EnsLib.ITK.Framework.RequestData, service As EnsLib.ITK.Setup.ServiceDefinition)
{
	Set sc=$$$OK
	
	// Get all the routes (there may be duplication which is resolved in the loop below)
	set distributionRoutes=..GetDistributionRoutes(pRequest)
	set contentRoutes=..GetContentRoutes(pRequest, service)
	set routes=..GetSubscriptionRoutes(pRequest.SourceApplication, pRequest.ServiceName)

	set:distributionRoutes'="" routes=routes_$S(routes="":distributionRoutes,1:","_distributionRoutes)
	set:contentRoutes'="" routes=routes_$S(routes="":contentRoutes,1:","_contentRoutes)

	/// Make sure if sync request/reply there is only 1 route to pass to
	if ($LENGTH(routes,",")>1) && (pRequest.InvocationPattern=$$$ITKSyncInvocationPattern) && (service.BehaviourType=$$$ITKBPRequestResponse)
	{
		Quit $$$ERROR($$$EnsErrGeneral,$$$ITKFaultMultipleSubscribers(pRequest.ServiceName,pRequest.SourceApplication))
	}

	/// Distribute to each unique route
	if routes'=""
	{
		set setroutes=""
		For i=1:1:$L(routes,",") 
		{ 
			Set route=$ZStrip($P(routes,",",i),"<>W")  
			if ""=$get($$$DispatchNameToConfigName(route))
			{
				$$$LOGERROR("Endpoint not defined for route: "_route)
			}
			else
			{
				set:$g(setroutes(route))="" sc = ..SendRequestAsync(route,pRequest)
				set setroutes(route)=1
			}
			Quit:$$$ISERR(sc)
		}
	}
	Quit sc
}

/// Route if a Queue Collection request
Method RouteQueueCollection(pRequest As EnsLib.ITK.Framework.RequestData)
{
	Set tSC = $$$OK
	
	set service = ##class(EnsLib.ITK.Setup.ServiceDefinition).%OpenId(pRequest.ServiceName)

	if '$IsObject(service)
	{
		Set tSC = $$$ERROR($$$EnsErrGeneral, $$$ITKGeneralError_"Queue collection service not registered:"_pRequest.ServiceName)
		goto exit
	}
	
	set target=""
	set tDeviceName=""
	If $ISOBJECT(pRequest.Payload) 
	{
		set doc=##class(EnsLib.EDI.XML.Document).ImportFromLibraryStream(pRequest.Payload, .tSC)
		goto:$$$ISERR(tSC) exit
		
		set tDeviceName=doc.GetValueAt("*:/1/QueueName")
		set appname=$P(tDeviceName,":",1)

		Set:appname=pRequest.SourceApplication target = ##class(EnsLib.ITK.Util.UtilityMethods).ResolveOpertaionByDeviceName(tDeviceName)
	}

	If (target '= "") {
		// Send Asynch Request to the Operation
		Set tSC = ..SendRequestAsync(target, pRequest, 1)
		
	} Else {
		$$$LOGWARNING("Queue not recognised:"_tDeviceName)
		do ..SimulateResponse(pRequest,"",$$$ERROR($$$EnsErrGeneral,$$$ITKInvalidRequest_"No Queue exists for Queue Name: "_tDeviceName) )
	}
exit
	Quit tSC
}

/// This method actually routes a reply to a request-response message by
/// either sending the reply (pRequest) onto deferred handler or by sending
/// the response asychronously back to the call
Method RouteReply(pRequest As EnsLib.ITK.Framework.RequestData, pOriginalMessage As EnsLib.ITK.Framework.RequestData) As %Status
{
	Set sc = $$$OK
	
	/// Service is still waiting, send back to deferred response
	if (pOriginalMessage.InvocationPattern = $$$ITKSyncInvocationPattern) 
	{	
		Set cl = ##class(EnsLib.ITK.Framework.CallBackLog).%OpenId(pRequest.OriginalRelatesTo)
		Set tToken = ##class(EnsLib.ITK.Util.UtilityMethods).GetDeferredToken(cl.RequestSessionId) 
		
		Set pResponse = ##class(EnsLib.ITK.Framework.ResponseData).%New()
		Set pResponse.MessageId = ##class(EnsLib.ITK.Util.UtilityMethods).CreateGUID()
		set pResponse.ResponseInvocationPattern = $$$ITKAsyncInvocationPattern
		Set pResponse.RequestInvocationPattern = pRequest.InvocationPattern
		Set pResponse.BehaviourType = $$$ITKBPRequestResponse
		Set pResponse.SourceApplication = pRequest.SourceApplication
		Set pResponse.ResponseBody = pRequest.Payload 
		Set pResponse.Status = pRequest.Status

		Set sc = ..SendDeferredResponse(tToken, pResponse)
	}
	
	/// Service is not waiting, route reply asychronously
	else
	{
		Set tTargetOp = ##class(EnsLib.ITK.Util.UtilityMethods).ResolveOpertaionByURL(pRequest.ResolvedEndpoint)
		if tTargetOp=""
		{
			Set sc = $$$ERROR($$$EnsErrGeneral, $$$ITKInvalidAddressing_"non-resolvable Endpoint Address:"_pRequest.ResolvedEndpoint)
		}
		else
		{
			Set sc = ..SendRequestAsync(tTargetOp, pRequest, 1)
		}
	}
	Quit sc
}

/// Called to validate the content, if content validation is turned on for the given sender.
/// TODO: ITK 2.0, when validating may have distribution envelope wrapping given requestClass, need to handle!! (also should be virtual XML Doc!)
Method ValidateContent(pRequest As EnsLib.ITK.Framework.RequestData) As %Status
{
	Set tSC = $$$OK

	set scn = ##class(EnsLib.ITK.Util.UtilityMethods).SessionServiceConfigName(..%SessionId)
	
	Set tIsValidationRequired = ##class(EnsLib.ITK.Setup.SenderRegistry).IsValidationRequired(scn,pRequest.SourceApplication, pRequest.ServiceName)

	// If validation not required, skip everything and forward the request.
	Quit:'tIsValidationRequired $$$OK
	
	// Note: The content validation code is removed. It is not part of the tests or used
	// The validation needs to use Schema validation with Virtual XML Docs. This will be added
	$$$LOGWARNING("Content of request message for Session Id "_ ..%SessionId _ " cannot be validated.")
	Set tSC =  $$$ERROR($$$EnsErrGeneral, $$$ITKInvalidRequest_"Message cannot be vaildation")
	Quit tSC
}

/// Ensures that there is a business operation under the given replyTo address
/// If there is not this switchboard is not capable to routing the async reply!
Method ValidateAddressing(pRequest As EnsLib.ITK.Framework.RequestData) As %Status
{
	set sc=$$$OK
	if pRequest.ReplyTo '=""
	{
		Set tTargetOp = ##class(EnsLib.ITK.Util.UtilityMethods).ResolveOpertaionByURL(pRequest.ReplyTo)
		Quit:tTargetOp="" $$$ERROR($$$EnsErrGeneral, $$$ITKInvalidAddressing_"non-resolvable ReplyTo Address:"_pRequest.ReplyTo)

	}
	if pRequest.FaultTo '=""
	{
		Set tTargetOp = ##class(EnsLib.ITK.Util.UtilityMethods).ResolveOpertaionByURL(pRequest.FaultTo)		
		Quit:tTargetOp="" $$$ERROR($$$EnsErrGeneral, $$$ITKInvalidAddressing_"non-resolvable FaultTo Address:"_pRequest.FaultTo)
	}
	Quit sc
}

/// When handling an async response this tues the request back up and determines
/// where we are going to send the response to (based on original request that had
/// the replyTo address).
Method ResolveMessageRelationships(pRequest As EnsLib.ITK.Framework.RequestData, Output pOriginalMessage As EnsLib.ITK.Framework.RequestData) As %Status
{
	Set sc = $$$OK
	set service = ##class(EnsLib.ITK.Setup.ServiceDefinition).%OpenId(pRequest.ServiceName)

 	// Process all response messages - even those in error.
	Set cl = ##class(EnsLib.ITK.Framework.CallBackLog).%OpenId(pRequest.RelatesTo)
		
	if '$IsObject(cl)
	{
		Set sc =  $$$ERROR($$$EnsErrGeneral, $$$ITKNoCallbackDataForMessage(pRequest.RelatesTo))
		Goto Exit
	}
	if (cl.ResponseMessageId'="") || (cl.FaultMessageId'="")
	{
		Set sc =  $$$ERROR($$$EnsErrGeneral, $$$ITKNoDuplicatedResponse(pRequest.RelatesTo))
		Goto Exit
	}
	
	if ($$$ISERR(pRequest.Status) || service.BehaviourType=$$$ITKBPFaultHandler)
	{
		set cl.FaultMessageId=pRequest.MessageId
	}
	else
	{
		Set cl.ResponseMessageId = pRequest.MessageId
	}
	Set cl.Status = $$$ITKResponseComplete
	Set sc = cl.%Save()
		
	Set pRequest.OriginalRelatesTo = pRequest.RelatesTo
	Set pRequest.RelatesTo = cl.RequestMessageId
	Set pRequest.SourceDevice = $P(cl.RelatedMessageSentTo,":")
		
	set pOriginalMessage = ##class(EnsLib.ITK.Framework.RequestData).RequestDataU1Open(cl.RequestMessageId)
		
	set service = ##class(EnsLib.ITK.Setup.ServiceDefinition).%OpenId(pRequest.ServiceName)
		
	if (pOriginalMessage.InvocationPattern = $$$ITKSyncInvocationPattern) 
	{
		// Stop the message from passing through the subscription router
		set pRequest.ResolvedEndpoint = "Syncronous Response"
	}
	elseif service.BehaviourType = $$$ITKBPFaultHandler
	{
		Set:pRequest.FaultTo'="" pRequest.ResolvedEndpoint = pOriginalMessage.FaultTo
		Set:pRequest.FaultTo="" pRequest.ResolvedEndpoint = pOriginalMessage.ReplyTo
	}
	else
	{
		set pRequest.ResolvedEndpoint = pOriginalMessage.ReplyTo
	}
					
Exit	
	
	Quit sc
}

/// This method will process the Subscription Rules to determine a comma separate list
/// of consumers to send onto
ClassMethod GetSubscriptionRoutes(pSourceApp As %String, pService As %String) As %String
{
	if ($G(pSourceApp)'="") && ($G(pService)'="")
	{
		set subscribers = ##class(EnsLib.ITK.Setup.SubscriptionRules).GetSubscribers(pSourceApp, pService)
	}
	else
	{
		set subscribers = ##class(EnsLib.ITK.Setup.SubscriptionRules).GetAllSubscribers()
	}

	set componentList = ""
	
	For i=1:1:$L(subscribers,",") 
	{ 
		Set tOne=$ZStrip($P(subscribers,",",i),"<>W")   
		set approuter=""
		set app = ##class(EnsLib.ITK.Setup.SystemDefinition).%OpenId(tOne)
		if $IsObject(app) Set approuter = app.ApplicationRouter
		set:approuter="" approuter = tOne
		
		set componentList=componentList_$S(componentList="":approuter,1:","_approuter)
	}
	Quit componentList
}

/// Call to find the routes to distribute the message onto given the address list
/// in the distribution rules.
Method GetDistributionRoutes(pRequest As EnsLib.ITK.Framework.RequestData) As %String
{
	quit:pRequest.DistributionEnvelope="" ""
	
	set routes=""
	set addressCount=pRequest.DistributionEnvelope.GetValueAt("*:/1/header/addresslist/*")
	for i=1:1:addressCount
	{
		set uri=pRequest.DistributionEnvelope.GetValueAt("*:/1/header/addresslist/address["_i_"]/@uri")
		continue:uri=""
		
		set address = ##class(EnsLib.ITK.Setup.DistributionRules).GetBestMatch(uri,pRequest.DistributionMode,pRequest.ServiceName)
		if ('$IsObject(address) && (pRequest.DistributionMode=$$$ITKDMRoute))
		{
			// We only need to be able to distribute requests if we are operating in ROUTE mode
			$$$LOGERROR("No route for address: "_uri_" on service:"_pRequest.ServiceName_" on mode:"_pRequest.DistributionMode)
		}
		elseif $IsObject(address)
		{
			set routes=routes_$S(routes="":address.TargetComponent,1:","_address.TargetComponent)
		}
	}
			
	/// Return the routes found
	quit routes
}

/// Call to find the routes based on the content of the message
Method GetContentRoutes(pRequest As EnsLib.ITK.Framework.RequestData, service As EnsLib.ITK.Setup.ServiceDefinition) As %String
{
	set routes = ""
	quit:pRequest.SourceApplication="" routes
	
	// a. Determine the content router from system
	set sd=##class(EnsLib.ITK.Setup.SystemDefinition).%OpenId(pRequest.SourceApplication)
	quit:'$IsObject(sd) routes
	set router=sd.ApplicationRouter
	quit:router="" routes
	
	// Note: Maybe Base64 Encoded HL7, in which case this has effect on router (for now assume XML!)
		
	// b. Construct Request
	set context=##class(EnsLib.ITK.Framework.ContentContext).%New()
	set context.Service=pRequest.ServiceName
	set context.Envelope=pRequest.DistributionEnvelope
	set context.Content=##class(EnsLib.EDI.XML.Document).ImportFromLibraryStream(pRequest.Payload)
	
	// c. Evaluation Rules
	do ##class(Ens.Rule.Definition).EvaluateRules(router, ..%SessionId, context, "ITKRoute", .routes)
			
	/// Return the routes found
	quit routes
}

/// Called to send a response back (usually an error!!)
Method SimulateResponse(pRequest As EnsLib.ITK.Framework.RequestData, pOriginalMessage As EnsLib.ITK.Framework.RequestData, sc As %Status)
{
	
	if (pRequest.InvocationPattern '= $$$ITKAsyncResponseInvocationPattern) && (..SendReponsesTo '= "") 
	{
		set sd = ##class(EnsLib.ITK.Setup.ServiceDefinition).%OpenId(pRequest.ServiceName)
		
		Set pResponse = ##class(EnsLib.ITK.Framework.ResponseData).%New()
		Set pResponse.MessageId = ##class(EnsLib.ITK.Util.UtilityMethods).CreateGUID()
		
		/// Create the call back log so there is one!
		if (sd.BehaviourType=$$$ITKBPRequestResponse)
 		{
	 		Set tCallBackLog = ##class(EnsLib.ITK.Framework.CallBackLog).%New()
			Set tCallBackLog.RequestMessageId = pRequest.MessageId
			Set tCallBackLog.RelatedMessageId = pResponse.MessageId
			Set tCallBackLog.RequestSessionId = ..%SessionId
			Set tCallBackLog.RelatedMessageSentTo = "ITK"
			Set tCallBackLog.Status = $$$ITKResponsePending
			Set tCallBackLog.CallBackLogCreated = $ZDATETIME($ZTIMESTAMP,3,1,6)
		
			Set tSC = tCallBackLog.%Save()
 		}

		set pResponse.ResponseInvocationPattern = $$$ITKSyncInvocationPattern
		Set pResponse.RequestInvocationPattern = pRequest.InvocationPattern
		Set pResponse.BehaviourType = sd.BehaviourType
		Set pResponse.SourceApplication = "ITK" 
		Set pResponse.Status = sc
		set sc = ..SendRequestAsync(..SendReponsesTo,pResponse,0)
	}
	elseif (..BadMessageHandler'="")
	{
		set sc = ..SendRequestAsync(..BadMessageHandler,pRequest,0)

	}
	Quit sc
}

/// Handle a 'Response' by passing it to the 'SendResponsesTo' component.
/// This is typically the DispatchResponse component
Method OnResponse(request As %Library.Persistent, ByRef response As %Library.Persistent, callrequest As %Library.Persistent, callresponse As %Library.Persistent, pCompletionKey As %String) As %Status
{
	Quit:('$IsObject(callresponse) || ('$classname(callresponse)="EnsLib.ITK.Framework.ResponseData")) $$$OK
	
	set sc = $$$OK

	set cr = callresponse
	#dim cr as EnsLib.ITK.Framework.ResponseData
	
	set r = request
	#dim r as EnsLib.ITK.Framework.RequestData
	
	if (r.InvocationPattern '= $$$ITKAsyncResponseInvocationPattern) && (..SendReponsesTo '= "") set sc = ..SendRequestAsync(..SendReponsesTo,cr,0)

	Quit sc
}

/// IRIS Callback to work out which config items we connect to
ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("SendReponsesTo",.tValue) {
		Set tOne=$ZStrip(tValue,"<>W")
		Set:""'=tOne pArray(tOne)=""
	}
	If pItem.GetModifiedSetting("BadMessageHandler",.tValue) {
		Set tOne=$ZStrip(tValue,"<>W")
		Set:""'=tOne pArray(tOne)=""
	}

	Set routes = ..GetSubscriptionRoutes()
	For i=1:1:$L(routes,",") 
	{ 
		Set tOne=$ZStrip($P(routes,",",i),"<>W")  
		Continue:""=tOne  
		Set pArray(tOne)="" 
	}
	
	// Queue collection candidates
	Set rs= ##class(%ResultSet).%New("EnsLib.ITK.Setup.SenderRegistry:QueueEnabledSubscripers")
	do rs.Execute()
	while rs.Next()
	{
		do ##class(EnsLib.ITK.Util.UtilityMethods).ResolveOpertaionByApplicationName(rs.GetData(1),.operations)
		#dim operations As %ArrayOfDataTypes
		
		set key=""
		do
		{
			do operations.GetNext(.key)
			set:key'="" pArray(key)=""
		}
		while key'=""
	}
	
	// Distribution Rules
	Set rs= ##class(%ResultSet).%New("EnsLib.ITK.Setup.DistributionRules:DistributionTargets")
	do rs.Execute()
	while rs.Next()
	{
		set pArray(rs.GetData(1))=""
	}
}

/// This method is called when an error response is received
/// Returning the same error will cause the BusinessProcess to set its status to error and close down
/// Returning $$$OK from this method causes the BusinessProcess to recover from this error
Method OnError(request As %Library.Persistent, ByRef response As %Library.Persistent, callrequest As %Library.Persistent, pErrorStatus As %Status, pCompletionKey As %String) As %Status
{
		set sc=$$$OK
		if ($G(request)="") quit $$$OK
				
		if request.%IsA("EnsLib.ITK.Framework.RequestData")
		{
			set sd = ##class(EnsLib.ITK.Setup.ServiceDefinition).%OpenId(request.ServiceName)
			Set pResponse = ##class(EnsLib.ITK.Framework.ResponseData).%New()
			Set pResponse.MessageId = ##class(EnsLib.ITK.Util.UtilityMethods).CreateGUID()
			Set pResponse.BehaviourType = sd.BehaviourType
			Set pResponse.SourceApplication = "ITK" 
			Set pResponse.Status = pErrorStatus
			set sc = ..SendRequestAsync(..SendReponsesTo,pResponse,0)
		}
 		
		quit sc
}

Storage Default
{
<Data name="ITKMessageRouterDefaultData">
<Subscript>"ITKMessageRouter"</Subscript>
<Value name="1">
<Value>SendReponsesTo</Value>
</Value>
<Value name="2">
<Value>BadMessageHandler</Value>
</Value>
<Value name="3">
<Value>FaultReporterURI</Value>
</Value>
<Value name="4">
<Value>FaultVocabulary</Value>
</Value>
</Data>
<DefaultData>ITKMessageRouterDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
