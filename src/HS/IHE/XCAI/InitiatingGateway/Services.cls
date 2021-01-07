Include HS.IHE.XCAI

Class HS.IHE.XCAI.InitiatingGateway.Services Extends (HS.IHE.Common.Services.SOAPServer.FileStream, HS.IHE.Common.Actor.Base) [ Inheritance = right ]
{

Parameter NAMESPACE = "urn:ihe:rad:xdsi-b:2009";

Parameter OUTPUTTYPEATTRIBUTE = 1;

Parameter SERVICENAME = "InitiatingImagingGateway_Service";

Parameter SETTINGS = "RetrieveTarget:Basic";

Property RetrieveTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XCAI.InitiatingGateway.Process" ];

Method OnProcessInput(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage = {$$$NULLOREF}) As %Status [ ServerOnly = 1 ]
{
	Set tSC = $$$OK
	Try {
		Set tAction = pRequest.AdditionalInfo.GetAt("SOAPAction")
		If tAction = $$$XDSIRetrieveAction(1) {
			Set pRequest.Name = $$$XDSIRetrieveRequest
			Do ..ValidateMessage(pRequest,tAction,"Request")
			$$$ThrowOnError(..Retrieve(pRequest, .pResponse))
			Do ..ValidateMessage(pResponse,$$$XDSIRetrieveResponseAction(1),"Response")
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

Method Retrieve(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:rad:2009:RetrieveImagingDocumentSet", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	Set tSC = $$$OK
	Try {
		Do ..SetAddressingOut($$$XDSIRetrieveResponseAction(1))
		$$$ThrowOnError(..SendRequestSync(..RetrieveTarget, pRequest, .pResponse))
		$$$ThrowOnError(..MoveAttachments(pResponse))
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
