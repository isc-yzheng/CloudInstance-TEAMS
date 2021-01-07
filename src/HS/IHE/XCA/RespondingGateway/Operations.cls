Include HS.IHE.XCA

Class HS.IHE.XCA.RespondingGateway.Operations Extends (HS.HC.Util.Trace.Helper, HS.Util.SOAPClient.Operations) [ Inheritance = right, ProcedureBlock ]
{

Parameter SETTINGS = "DefaultSSLConfig,XCAQueryServiceName,XCARetrieveServiceName,-ServiceName,-TargetName,-IHEVersion,DisableSSLCheckServerIdentity:Dev";

/// For Asynchronous responses, (if not defined in the service registry) the SSL configuration to be used.
Property DefaultSSLConfig As %String;

Property IHEVersion As %String [ InitialExpression = 1 ];

/// ONLY defined when the request should be forwarded on to another service
Property XCAQueryServiceName As %String(MAXLEN = 512);

/// ONLY defined when the request should be forwarded on to another service
Property XCARetrieveServiceName As %String(MAXLEN = 512);

/// This is the default message handler.  All request types not declared in the message map are delivered here
Method OnMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eOnMessage As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Set ..SSLConfiguration = ..DefaultSSLConfig
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		#; if XCAQueryServiceName is populated we are forwarding the request
		If ..XCAQueryServiceName]"" || (pRequest.AdditionalInfo.GetAt("ServiceName")]"") {
			Set tAction=pRequest.AdditionalInfo.GetAt("SOAPAction")
			Set ..TargetName=pRequest.AdditionalInfo.GetAt("TargetName")
			Set:..TargetName="" ..TargetName=$S(tAction["Query":..XCAQueryServiceName,1:..XCARetrieveServiceName)
			Set tSOAPClient=##class(%SOAP.WebRequest).%New()
			Set tSC = ..InvokeWebService(tSOAPClient,, tAction, pRequest, .pResponse) $$$HSThrowErrors(tSC)
			$$$HSTRACE("Forwarded Request to "_..TargetName)
			Quit
		}

		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		Set tAction = $Case(pRequest.Name, $$$XCAQueryResponse:$$$XCAQueryResponseAction(..IHEVersion), $$$XCARetrieveResponse:$$$XCARetrieveResponseAction(..IHEVersion),:"")
		If tAction="" Set tSC = $$$ERROR($$$GeneralError, "Request type not handled:  " _ pRequest.Name) Quit
		Set tWebRequest = ##class(%SOAP.WebRequest).%New()
		If tAction=$$$XCARetrieveResponseAction(1) Set tWebRequest.MTOMRequired=1		
		Set tSC	=..InvokeWebService(tWebRequest,pRequest.AdditionalInfo.GetAt("ReplyAddress"), tAction, pRequest, .tResponse,1)
		$$$HSTRACE("Web Service Response","tResponse,tSC",tResponse,tSC) 
	}
	Catch eOnMessage {
		Set pResponse = $$$NULLOREF	
		Set tSC = eOnMessage.AsStatus()
	}
	
	Quit tSC
}

}
