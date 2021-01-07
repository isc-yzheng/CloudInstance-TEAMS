Include (HS.IHE.XCA, HS.IHE.XDSb)

/// 
Class HS.IHE.XCA.InitiatingGateway.Services Extends (HS.IHE.Common.Services.SOAPServer.Base, HS.IHE.Common.Actor.Base) [ Inheritance = right ]
{

/// This is the namespace used by the Service
Parameter NAMESPACE = "urn:ihe:iti:xds-b:2007";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "InitiatingGateway_Service";

Parameter SETTINGS = "XCAQueryTarget,XCARetrieveTarget";

Property XCAQueryTarget As Ens.DataType.ConfigName;

Property XCARetrieveTarget As Ens.DataType.ConfigName;

Method OnProcessInput(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage = {$$$NULLOREF}) As %Status [ ServerOnly = 1 ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Set tAction = pRequest.AdditionalInfo.GetAt("SOAPAction")
		
		If (tAction = "urn:ihe:iti:2007:RegistryStoredQuery") {
			Set pRequest.Name = $$$XDSbQueryRequest
			Do ..ValidateMessage(pRequest,tAction,"Request")
			Set tSC = ..Query(pRequest, .pResponse)
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
			Do ..ValidateMessage(pResponse,$$$XDSbQueryResponseAction(1),"Response")
		}
		ElseIf (tAction = "urn:ihe:iti:2007:RetrieveDocumentSet") {
			Set pRequest.Name = $$$XDSbRetrieveRequest
			Do ..ValidateMessage(pRequest,tAction,"Request")
			Set tSC = ..Retrieve(pRequest, .pResponse)
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
			Do ..ValidateMessage(pResponse,$$$XDSbRetrieveResponseAction(1),"Response")
		}
		Else {
			Set tSC = $$$EnsError("Unknown SOAP action:  " _ tAction)
			Throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
		}
	}
	Catch eException {
		$$$LOGERROR(eException.DisplayString())

		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method Query(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:iti:2007:RegistryStoredQuery", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Do ..SetAddressingOut($$$XDSbQueryResponseAction(1))
		Set tSC = ..SendRequestSync(..XCAQueryTarget, pRequest, .pResponse)
		Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

Method Retrieve(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:iti:2007:RetrieveDocumentSet", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Do ..SetAddressingOut($$$XDSbRetrieveResponseAction(1))
		Set tSC = ..SendRequestSync(..XCARetrieveTarget, pRequest, .pResponse)
		Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
		Set tSC = ..MoveAttachments(pResponse)
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

}
