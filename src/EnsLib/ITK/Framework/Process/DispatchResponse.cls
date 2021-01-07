/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (%soap, EnsITK, EnsConstants)

/// Dispatches responses on beahlf of the ITKMessageRouter 
Class EnsLib.ITK.Framework.Process.DispatchResponse Extends Ens.BusinessProcess [ ProcedureBlock, System = 4 ]
{

/// The reportor uri to report any technical errors against
Property FaultReporterURI As %String;

/// Vocabulary to use for creating fault messages from this Service.
Property FaultVocabulary As %String;

Parameter SETTINGS = "FaultReporterURI, FaultVocabulary";

Method OnRequest(pRequest As EnsLib.ITK.Framework.ResponseData, Output pResponse As Ens.Response) As %Status
{
	Set sc = $$$OK 	

	// Determine the response style (sync or async)
	set sendResponse=""
	if pRequest.BehaviourType = $$$ITKBPQueueCollection 
	{
		set sendResponse=$$$SendSyncResponse
	}
	elseif (pRequest.BehaviourType = $$$ITKBPRequestResponse) && ((pRequest.ResponseInvocationPattern = $$$ITKSyncInvocationPattern) || $$$ISERR(pRequest.Status))
	{
		if (pRequest.RequestInvocationPattern = $$$ITKSyncInvocationPattern) 
		{
			set sendResponse=$$$SendSyncResponse
		}
		elseif (pRequest.RequestInvocationPattern = $$$ITKAsyncInvocationPattern) 
		{
			set sendResponse=$$$SendAsyncResponse
		}
	}
	
	/// Send the response onto deferred handler
	If sendResponse=$$$SendSyncResponse
	{
		Set tToken = ##class(EnsLib.ITK.Util.UtilityMethods).GetDeferredToken(..%SessionId) 
		Set sc = ..SendDeferredResponse(tToken, pRequest)
	}
	
	/// Send the response onto the route at the replyTo address
	elseif sendResponse=$$$SendAsyncResponse
	{
		set cl = ##class(EnsLib.ITK.Framework.CallBackLog).%OpenId(pRequest.MessageId)
		/*Set cl.ResponseMessageId = pRequest.MessageId
		Set cl.Status = $$$ITKResponseComplete
		Set sc = cl.%Save()*/
		
		set pOriginalRequest = ##class(EnsLib.ITK.Framework.RequestData).RequestDataU1Open(cl.RequestMessageId)
		
		set pCallbackRequest =  ##class(EnsLib.ITK.Util.UtilityMethods).CreateSkeletonITKRequestMessage($$$ITKAsyncResponseHandler, pOriginalRequest.Action_"Response",$$$ITKAsyncResponseInvocationPattern,  pRequest.SourceApplication,.sc)
		Set pCallbackRequest.To = pOriginalRequest.ReplyTo
		Set pCallbackRequest.RelatesTo = pRequest.MessageId
		Set pCallbackRequest.Payload = pRequest.ResponseBody
		Set pCallbackRequest.Status = pRequest.Status
		Set pCallbackRequest.FaultCode = pRequest.FaultCode
		
		Set scn = ##class(EnsLib.ITK.Util.UtilityMethods).SessionServiceConfigName(..%SessionId)

		Set target = ##class(Ens.Director).GetHostSettingValue(scn,"TargetConfigName")
		
		set sc = ..SendRequestAsync(target,pCallbackRequest,0)
	}
	
	/// Generate an alert if error
	elseif $$$ISERR(pRequest.Status)
	{
		if pRequest.BehaviourType = $$$ITKBPAcknowledged {
			set originalRequest = ##class(EnsLib.ITK.Framework.RequestData).RequestDataU1Open(pRequest.RequestMessageId)
			if ('$IsObject(originalRequest))||(originalRequest.DistributionEnvelope="") {
				set sc=..SendAlert(##class(Ens.AlertRequest).%New($lb(..%ConfigName, "Cannot send technical acknowledgement back as no sender "_pRequest.Status)))
			}
			else {
				set ackRequest = ##class(EnsLib.ITK.Framework.SOAPCommon).MakeTechnicalNack(originalRequest, pRequest.Status, "Failed to send message", ..FaultVocabulary, ..FaultReporterURI)
				set sc=..SendRequestAsync("ITKMessageRouter", ackRequest, 0)
			}
		}
		else {
			set sc=..SendAlert(##class(Ens.AlertRequest).%New($lb(..%ConfigName, "Error sending un-acknowledged message: "_pRequest.Status)))
		}
	}
	
	Quit sc
}

Storage Default
{
<Data name="DispatchResponseDefaultData">
<Subscript>"DispatchResponse"</Subscript>
<Value name="1">
<Value>FaultReporterURI</Value>
</Value>
<Value name="2">
<Value>FaultVocabulary</Value>
</Value>
</Data>
<DefaultData>DispatchResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
