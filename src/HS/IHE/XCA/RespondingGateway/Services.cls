Include HS.IHE.XCA

/// The typical XCA responding gateway accepts requests for a community and dispenses that request to the local registry (if defined)<br>
/// and also sends requests to other communities.<br><br>
/// The non-typical approach has the XCA Responding Gateway accept the request and based on the patient assigning authority, send the<br>
/// request out to the home community for that patient.  This configuration is often referred to as "The Big Bus"<br>
/// For this type of configuration to work there need to be service registry entries with DeviceFunction = XCA.Query where the AssigningAuthority = <br>
/// the coded value for the assigning authority oid.<br><br>
/// A non-standard use of the responding gateway is to pass in a parameter in the url /?sendingCommunityId=home.community.oid which will use cached patients (when defined in XCPD & responding gateway process)
/// 
Class HS.IHE.XCA.RespondingGateway.Services Extends (HS.IHE.Common.Services.SOAPServer.Base, HS.IHE.Common.Actor.Base) [ Inheritance = right ]
{

/// This is the namespace used by the Service
Parameter NAMESPACE = "urn:ihe:iti:xds-b:2007";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "RespondingGateway_Service";

Parameter SETTINGS = "XCAQueryTarget,XCARetrieveTarget";

Property XCAQueryTarget As Ens.DataType.ConfigName;

Property XCARetrieveTarget As Ens.DataType.ConfigName;

Method OnProcessInput(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage = {$$$NULLOREF}) As %Status [ ServerOnly = 1 ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Set tAction = pRequest.AdditionalInfo.GetAt("SOAPAction")
		If ..isAsync {
			Set pResponse = ##class(HS.Message.XMLMessage).%New()
		}
		
		If (tAction = $$$XCAQueryAction(1)) {
			Set pRequest.Name = $$$XCAQueryRequest
			Do ..ValidateMessage(pRequest,tAction,"Request")
			Set tSC = ..Query(pRequest, .pResponse)
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
			Do ..ValidateMessage(pResponse,$$$XCAQueryResponseAction(1),"Response")
		}
		ElseIf (tAction = $$$XCARetrieveAction(1)) {
			Set pRequest.Name = $$$XCARetrieveRequest
			Do ..ValidateMessage(pRequest,tAction,"Request")
			Set tSC = ..Retrieve(pRequest, .pResponse)
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
			Do ..ValidateMessage(pResponse,$$$XCARetrieveResponseAction(1),"Response")
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

/// Cross Gateway Query [ITI-38]
Method Query(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:iti:2007:CrossGatewayQuery", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		#; If the URL for the web service call includes a parameter named
		#; "sendingCommunityId" then add its value to AdditionalInfo.
		If %request.Get("sendingCommunityId")'="" Do pRequest.AdditionalInfo.SetAt(%request.Get("sendingCommunityId"),"sendingCommunityId")
		
		If ..isAsync {
			Set tSC = ..SendRequestAsync(..XCAQueryTarget, pRequest)
		} Else {
			Do ..SetAddressingOut($$$XCAQueryResponseAction(1))
			Set tSC = ..SendRequestSync(..XCAQueryTarget, pRequest, .pResponse)
		}
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

/// Cross Gateway Query [ITI-38]
Method QueryAsync(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:iti:2007:CrossGatewayQueryAsync", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
/// this code is never called.  The method is here for the action to appear
}

/// Cross Gateway Retrieve [ITI-39]
Method Retrieve(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:iti:2007:CrossGatewayRetrieve", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		if ..isAsync {
			Set tSC = ..SendRequestAsync(..XCARetrieveTarget, pRequest)
		} Else {
			Do ..SetAddressingOut($$$XCARetrieveResponseAction(1))
			Set tSC = ..SendRequestSync(..XCARetrieveTarget, pRequest, .pResponse)
			Quit:$$$ISERR(tSC)
			Set tSC = ..MoveAttachments(pResponse)
		}
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

/// Cross Gateway Retrieve [ITI-39]
Method RetrieveAsync(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:iti:2007:CrossGatewayRetrieveAsync", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
/// this code is never called.  The method is here for the action to appear
}

XData WSDL
{
<?xml version="1.0" encoding="utf-8"?>
<!-- This wsdl file is for an XCA Responding Gateway Actor -->
<definitions xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" 
	xmlns="http://schemas.xmlsoap.org/wsdl/" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
	xmlns:ihe="urn:ihe:iti:xds-b:2007" 
	xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0" 
	xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0" 
	xmlns:soap12="http://schemas.xmlsoap.org/wsdl/soap12/" 
	xmlns:wsaw="http://www.w3.org/2006/05/addressing/wsdl" 
	targetNamespace="urn:ihe:iti:xds-b:2007" name="RespondingGateway">
<types>
<xsd:schema elementFormDefault="qualified">
<xsd:import namespace="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0" schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/ebRS/rs.xsd"/>
<xsd:import namespace="urn:ihe:iti:xds-b:2007" schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/IHE/XDS.b_DocumentRepository.xsd"/>
<xsd:import namespace="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0" schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/ebRS/query.xsd"/>
</xsd:schema>
</types>
<!-- XCA Query -->
<message name="CrossGatewayQuery_Message">
<documentation>Cross Gateway Query</documentation>
<part name="body" element="query:AdhocQueryRequest"/>
</message>
<message name="CrossGatewayQueryResponse_Message">
<documentation>Cross Gateway Query Response</documentation>
<part name="body" element="query:AdhocQueryResponse"/>
</message>
<!-- XCA Retrieve -->
<message name="CrossGatewayRetrieve_Message">
<documentation>Cross Gateway Retrieve</documentation>
<part name="body" element="ihe:RetrieveDocumentSetRequest"/>
</message>
<message name="CrossGatewayRetrieveResponse_Message">
<documentation>Cross Gateway Retrieve Response</documentation>
<part name="body" element="ihe:RetrieveDocumentSetResponse"/>
</message>

<!-- XCA Query -->
<portType name="RespondingGatewayQuery_PortType">
<operation name="RespondingGateway_CrossGatewayQuery">
<input message="ihe:CrossGatewayQuery_Message" wsaw:Action="urn:ihe:iti:2007:CrossGatewayQuery"/>
<output message="ihe:CrossGatewayQueryResponse_Message" wsaw:Action="urn:ihe:iti:2007:CrossGatewayQueryResponse"/>
</operation>
</portType>

<!-- XCA Retrieve -->
<portType name="RespondingGatewayRetrieve_PortType">
<operation name="RespondingGateway_CrossGatewayRetrieve">
<input message="ihe:CrossGatewayRetrieve_Message" wsaw:Action="urn:ihe:iti:2007:CrossGatewayRetrieve"/>
<output message="ihe:CrossGatewayRetrieveResponse_Message" wsaw:Action="urn:ihe:iti:2007:CrossGatewayRetrieveResponse"/>
</operation>
</portType>

<!-- XCA Query -->
<binding name="RespondingGatewayQuery_Binding_Soap12" type="ihe:RespondingGatewayQuery_PortType">
<soap12:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>
<operation name="RespondingGateway_CrossGatewayQuery">
<soap12:operation soapAction="urn:ihe:iti:2007:CrossGatewayQuery"/>
<input>
<soap12:body use="literal"/>
</input>
<output>
<soap12:body use="literal"/>
</output>
</operation>
</binding>

<!-- XCA Retrieve -->
<binding name="RespondingGatewayRetrieve_Binding_Soap12" type="ihe:RespondingGatewayRetrieve_PortType">
<soap12:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>
<operation name="RespondingGateway_CrossGatewayRetrieve">
<soap12:operation soapAction="urn:ihe:iti:2007:CrossGatewayRetrieve"/>
<input>
<soap12:body use="literal"/>
</input>
<output>
<soap12:body use="literal"/>
</output>
</operation>
</binding>

<!-- XCA Query -->
<service name="RespondingGatewayQuery_Service">
<port name="RespondingGatewayQuery_Port_Soap12" binding="ihe:RespondingGatewayQuery_Binding_Soap12">
<soap12:address location="http://servicelocation/RespondingGatewayQuery_Service"/>
</port>
</service>

<!-- XCA Retrieve -->
<service name="RespondingGatewayRetrieve_Service">
<port name="RespondingGatewayRetrieve_Port_Soap12" binding="ihe:RespondingGatewayRetrieve_Binding_Soap12">
<soap12:address location="http://servicelocation/RespondingGatewayRetrieve_Service"/>
</port>
</service>

</definitions>
}

}
