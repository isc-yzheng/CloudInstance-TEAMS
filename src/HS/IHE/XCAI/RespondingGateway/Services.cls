Include HS.IHE.XCAI

Class HS.IHE.XCAI.RespondingGateway.Services Extends (HS.IHE.Common.Services.SOAPServer.FileStream, HS.IHE.Common.Actor.Base) [ Inheritance = right ]
{

Parameter NAMESPACE = "urn:ihe:rad:xdsi-b:2009";

Parameter OUTPUTTYPEATTRIBUTE = 1;

Parameter SERVICENAME = "RespondingImagingGateway_Service";

Parameter SETTINGS = "RetrieveTarget:Basic";

Property RetrieveTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XCAI.RespondingGateway.Process" ];

Method OnProcessInput(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage = {$$$NULLOREF}) As %Status [ ServerOnly = 1 ]
{
	Set tSC = $$$OK
	Try {
		If ..isAsync {
			Set pResponse = ##class(HS.Message.XMLMessage).%New()
		}
	
		Set tAction = pRequest.AdditionalInfo.GetAt("SOAPAction")
		If tAction = $$$XCAIRetrieveAction(1) {
			Set pRequest.Name = $$$XCAIRetrieveRequest
			Do ..ValidateMessage(pRequest,tAction,"Request")
			$$$ThrowOnError(..Retrieve(pRequest, .pResponse))
			If '..isAsync Do ..ValidateMessage(pResponse,$$$XCAIRetrieveResponseAction(1),"Response")
		}
		Else {
			$$$ThrowStatus($$$EnsError("Unknown SOAP action:  " _ tAction))
		}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
		$$$LOGSTATUS(tSC)
	}	
	Quit tSC
}

Method Retrieve(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:rad:2011:CrossGatewayRetrieveImagingDocumentSet", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	Set tSC = $$$OK
	Try {
		If ..isAsync {
			$$$ThrowOnError(..SendRequestAsync(..RetrieveTarget,pRequest))
			Quit
		}
		
		Do ..SetAddressingOut($$$XCAIRetrieveResponseAction(1))
		$$$ThrowOnError(..SendRequestSync(..RetrieveTarget, pRequest, .pResponse))
		$$$ThrowOnError(..MoveAttachments(pResponse))
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
