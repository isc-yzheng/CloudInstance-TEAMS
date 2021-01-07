Include HS.IHE.PIX

Class HS.IHE.PIXv3.Consumer.Services Extends (HS.IHE.Common.Services.SOAPServer.Base, HS.IHE.Common.Actor.Base) [ Inheritance = right ]
{

Parameter MUSTUNDERSTANDACTION As %Boolean = 0;

/// This is the namespace used by the Service
Parameter NAMESPACE = "urn:ihe:iti:pixv3:2007";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "PIXConsumer_Service";

/// This is the namespace used for types by the Service
Parameter TYPENAMESPACE = "urn:hl7-org:v3";

Parameter SETTINGS As %String = "PIXv3ReviseTarget,XCPDCacheReviseTarget";

Property PIXv3ReviseTarget As Ens.DataType.ConfigName;

Property XCPDCacheReviseTarget As Ens.DataType.ConfigName;

Method OnProcessInput(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage = {$$$NULLOREF}) As %Status [ ServerOnly = 1 ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Set tAction = pRequest.AdditionalInfo.GetAt("SOAPAction")
		
		If (tAction = $$$PIXv3ReviseAction(1)) {
			Set pRequest.Name = $$$PIXv3ReviseRequest
			Set tSC = ..Revise(pRequest, .pResponse)
			Do ..ValidateMessage(pRequest,tAction,"Request")
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
			Do ..ValidateMessage(pResponse,$$$PIXv3ReviseResponseAction(1),"Response")
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

Method Revise(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:hl7-org:v3:PRPA_IN201302UV02", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Do ..SetAddressingOut($$$PIXv3ReviseResponseAction(1))
		
		If ..PIXv3ReviseTarget'="" {
			Set tSC = ..SendRequestSync(..PIXv3ReviseTarget, pRequest, .pResponse)
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		
		If (..XCPDCacheReviseTarget'="")&&(..XCPDCacheReviseTarget'=..PIXv3ReviseTarget) {
			Set tSC = ..SendRequestSync(..XCPDCacheReviseTarget, pRequest, .pResponse)
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
		}
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

XData WSDL
{
<?xml version="1.0" encoding="UTF-8"?>
<definitions name="PIXConsumer" targetNamespace="urn:ihe:iti:pixv3:2007"
xmlns:tns="urn:ihe:iti:pixv3:2007" xmlns:wsoap11="http://schemas.xmlsoap.org/wsdl/soap/"
xmlns:wsoap12="http://schemas.xmlsoap.org/wsdl/soap12/" xmlns="http://schemas.xmlsoap.org/wsdl/"
xmlns:wsaw="http://www.w3.org/2006/05/addressing/wsdl"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:hl7="urn:hl7-org:v3">
<documentation>WSDL for PIX Consumer, receiving update notifications</documentation>
<types>
<xsd:schema elementFormDefault="qualified" targetNamespace="urn:hl7-org:v3"
xmlns:hl7="urn:hl7-org:v3">
<!-- Include the message schema -->
<xsd:include
schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/HL7V3/NE2008/multicacheschemas/PRPA_IN201302UV02.xsd"/>
</xsd:schema>
<xsd:schema elementFormDefault="qualified" targetNamespace="urn:hl7-org:v3"
xmlns:hl7="urn:hl7-org:v3">
<!-- Include the message schema -->
<xsd:include
schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/HL7V3/NE2008/multicacheschemas/MCCI_IN000002UV01.xsd"/>
</xsd:schema>
</types>
<message name="PRPA_IN201302UV02_Message">
<part element="hl7:PRPA_IN201302UV02" name="Body"/>
</message>
<message name="MCCI_IN000002UV01_Message">
<part element="hl7:MCCI_IN000002UV01" name="Body"/>
</message>
<portType name="PIXConsumer_PortType">
<operation name="PIXConsumer_PRPA_IN201302UV02">
<input message="tns:PRPA_IN201302UV02_Message"
wsaw:Action="urn:hl7-org:v3:PRPA_IN201302UV02"/>
<output message="tns:MCCI_IN000002UV01_Message"
wsaw:Action="urn:hl7-org:v3:MCCI_IN000002UV01"/>
</operation>
</portType>
<binding name="PIXConsumer_Binding_Soap12" type="tns:PIXConsumer_PortType">
<wsoap12:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>
<operation name="PIXConsumer_PRPA_IN201302UV02">
<wsoap12:operation soapAction="urn:hl7-org:v3:PRPA_IN201302UV02"/>
<input>
<wsoap12:body use="literal"/>
</input>
<output>
<wsoap12:body use="literal"/>
</output>
</operation>
</binding>
<service name="PIXConsumer_Service">
<port binding="tns:PIXConsumer_Binding_Soap12" name="PIXConsumer_Port_Soap12">
<wsoap12:address location="http://servicelocation/PIXConsumer_Soap12"/>
</port>
</service>
</definitions>
}

}
