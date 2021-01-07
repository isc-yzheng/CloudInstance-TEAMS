Include HS.IHE.XCPD

Class HS.IHE.XCPD.RespondingGateway.Services Extends (HS.IHE.Common.Services.SOAPServer.Base, HS.IHE.Common.Actor.Base) [ Inheritance = right ]
{

Parameter MUSTUNDERSTANDACTION As %Boolean = 0;

/// This is the namespace used by the Service
Parameter NAMESPACE = "urn:ihe:iti:xds-b:2007";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "RespondingGateway_Service";

Parameter SETTINGS = "XCPDDiscoveryTarget";

Property XCPDDiscoveryTarget As Ens.DataType.ConfigName;

Method OnProcessInput(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage = {$$$NULLOREF}) As %Status [ ServerOnly = 1 ]
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		If ..isAsync {
			Set pResponse = ##class(HS.Message.XMLMessage).%New()
		}
		Set tAction = pRequest.AdditionalInfo.GetAt("SOAPAction")
		If (tAction = $$$XCPDPatientDiscoveryAction(1)) {
			Set pRequest.Name = $$$XCPDPatientDiscoveryRequest
			Do ..ValidateMessage(pRequest,tAction,"Request")
			Set tStatus = ..PatientDiscovery(pRequest, .pResponse) $$$ThrowOnError(tStatus)
			Do ..ValidateMessage(pResponse,$$$XCPDPatientDiscoveryResponseAction(1),"Response")
		}
		Else {
			Set tStatus = $$$EnsError("Unknown SOAP action:  " _ tAction)
			Throw ##class(%Exception.StatusException).CreateFromStatus(tStatus)
		}
	}
	Catch eException {
		$$$LOGERROR(eException.DisplayString())
		Set tStatus = eException.AsStatus()
	}
	
	Quit tStatus
}

/// ITI-55
Method PatientDiscovery(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:hl7-org:v3:PRPA_IN201305UV02:CrossGatewayPatientDiscovery", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		If ..isAsync {
			Set tStatus = ..SendRequestAsync(..XCPDDiscoveryTarget,pRequest)
		} Else {
			Do ..SetAddressingOut($$$XCPDPatientDiscoveryResponseAction(1))
			Set tStatus = ..SendRequestSync(..XCPDDiscoveryTarget, pRequest, .pResponse)
		}
		Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}

	Quit tStatus
}

XData WSDL
{
<?xml version="1.0" encoding="UTF-8"?>
<wsdl:definitions name="XCPDRespondingGateway" targetNamespace="urn:ihe:iti:xcpd:2009"
xmlns:tns="urn:ihe:iti:xcpd:2009" 
xmlns:soap12="http://schemas.xmlsoap.org/wsdl/soap12/" 
xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
xmlns:wsaw="http://www.w3.org/2007/05/addressing/metadata"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:hl7="urn:hl7-org:v3">
<wsdl:documentation>WSDL for XCPD Responding Gateway</wsdl:documentation>
<wsdl:types>
<xsd:schema elementFormDefault="qualified" 
targetNamespace="urn:hl7-org:v3" xmlns:hl7="urn:hl7-org:v3">
<!-- Include the message schema -->
<xsd:include schemaLocation="http://www.intersystems.com/healthshare/ihe/schema/HL7V3/NE2008/multicacheschemas/PRPA_IN201305UV02.xsd"/>
</xsd:schema>
<xsd:schema elementFormDefault="qualified" 
targetNamespace="urn:hl7-org:v3" xmlns:hl7="urn:hl7-org:v3">
<!-- Include the message schema -->
<xsd:include schemaLocation="http://www.intersystems.com/healthshare/ihe/schema/HL7V3/NE2008/multicacheschemas/PRPA_IN201306UV02.xsd"/>
</xsd:schema>
<xsd:schema elementFormDefault="qualified" targetNamespace="urn:ihe:iti:xcpd:2009">
<!-- Include the message schema -->
<xsd:include schemaLocation="http://www.intersystems.com/healthshare/ihe/schema/IHE/XCPD_PLQ.xsd"/>
</xsd:schema>
</wsdl:types>

<wsdl:message name="PRPA_IN201305UV02_Message">
<wsdl:part element="hl7:PRPA_IN201305UV02" name="Body"/>
</wsdl:message>
<wsdl:message name="PRPA_IN201306UV02_Message">
<wsdl:part element="hl7:PRPA_IN201306UV02" name="Body"/>
</wsdl:message>

<wsdl:portType name="RespondingGateway_PortType">
<wsdl:operation name="RespondingGateway_PRPA_IN201305UV02">
<wsdl:input message="tns:PRPA_IN201305UV02_Message"
wsaw:Action="urn:hl7-org:v3:PRPA_IN201305UV02:CrossGatewayPatientDiscovery"/>
<wsdl:output message="tns:PRPA_IN201306UV02_Message"
wsaw:Action="urn:hl7-org:v3:PRPA_IN201306UV02:CrossGatewayPatientDiscovery"/>
</wsdl:operation>
</wsdl:portType>

<wsdl:binding name="RespondingGateway_Binding_Soap12" type="tns:RespondingGateway_PortType">
<soap12:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>
<wsdl:operation name="RespondingGateway_PRPA_IN201305UV02">
<wsdl:input>
<soap12:body use="literal"/>
</wsdl:input>
<wsdl:output>
<soap12:body use="literal"/>
</wsdl:output>
</wsdl:operation>
</wsdl:binding>

<wsdl:service name="RespondingGateway_Service">
<wsdl:port binding="tns:RespondingGateway_Binding_Soap12" name="RespondingGateway_Port_Soap12">
<soap12:address location="https://example.org/RespondingGateway_Soap12"/>
</wsdl:port>
</wsdl:service>
</wsdl:definitions>
}

}
