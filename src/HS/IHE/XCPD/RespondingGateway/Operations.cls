Include (HS.IHE.ATNA, HS.IHE.XCPD)

Class HS.IHE.XCPD.RespondingGateway.Operations Extends (HS.Util.SOAPClient.Operations, HS.IHE.Common.Actor.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "-SOAPVersion,SSLConfiguration,-SOAPCredentials,XCPDQueryServiceName";

/// If defined forward this message on to another service
/// Otherwise the operation is used to process the asynchronouse responses
Property XCPDQueryServiceName As %String;

/// This is the default message handler.  All request types not declared in the message map are delivered here
Method OnMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eOnMessage As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		If ..XCPDQueryServiceName]"" {
			Set ..TargetName=..XCPDQueryServiceName
			Set tAction=pRequest.AdditionalInfo.GetAt("SOAPAction")
			Set tAsyncAddress=pRequest.AdditionalInfo.GetAt("ReplyAddress")
			Do pRequest.AdditionalInfo.RemoveAt("ReplyAddress")
			Set tSC = ..InvokeWebService(,, tAction, pRequest, .pResponse) $$$HSThrowErrors(tSC)
			If tAsyncAddress]"" {
				Do pResponse.AdditionalInfo.SetAt(tAsyncAddress,"ReplyAddress")
				Set tSC = ..InvokeWebService(,,$$$XCPDPatientDiscoveryResponseAction(1),pResponse,.tResponse,1)
			}
			Quit
		}


		#; async XCPD response
		If (pRequest.Name = $$$XCPDPatientDiscoveryResponse) {
			Set tSC	=..InvokeWebService(,pRequest.AdditionalInfo.GetAt("ReplyAddress"), $$$XCPDPatientDiscoveryResponseAction(1), pRequest, .tResponse,1)
			$$$ThrowOnError(tSC)
			Quit
		}
		Else {
			Set tSC = $$$ERROR($$$GeneralError, "Request type not handled:  " _ pRequest.Name) Quit
		}
	} Catch eOnMessage {
		
		Set tSC = eOnMessage.AsStatus()
		$$$LOGSTATUS(tSC)
	}
	Quit tSC
}

}
