Include HS.IHE.PDQ

Class HS.IHE.PDQv3.Supplier.Services Extends (HS.IHE.Common.Services.SOAPServer.Base, HS.IHE.Common.Actor.Base) [ Inheritance = right ]
{

Parameter MUSTUNDERSTANDACTION As %Boolean = 0;

/// This is the namespace used by the Service
Parameter NAMESPACE = "urn:ihe:iti:pdqv3:2007";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "PDQSupplier_Service";

/// This is the namespace used for types by the Service
Parameter TYPENAMESPACE = "urn:hl7-org:v3";

Parameter SETTINGS As %String = "PDQv3CancelTarget,PDQv3ContinueTarget,PDQv3QueryTarget";

Property PDQv3CancelTarget As Ens.DataType.ConfigName;

Property PDQv3ContinueTarget As Ens.DataType.ConfigName;

Property PDQv3QueryTarget As Ens.DataType.ConfigName;

Method OnProcessInput(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage = {$$$NULLOREF}) As %Status [ ServerOnly = 1 ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Set tAction = pRequest.AdditionalInfo.GetAt("SOAPAction")
		
		If (tAction = $$$PDQv3QueryAction(1)) {
			Set pRequest.Name = $$$PDQv3QueryRequest
			Set tSC = ..Query(pRequest, .pResponse)
			Do ..ValidateMessage(pRequest,tAction,"Request")
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
			Do ..ValidateMessage(pResponse,$$$PDQv3QueryResponseAction(1),"Response")
			If ..SchemaErrorCount() $$$LOGERROR("Additional errors"_..SchemaErrorString())
		}
		ElseIf (tAction = $$$PDQv3ContinueAction(1)) {
			Set pRequest.Name = $$$PDQv3ContinueRequest
			Set tSC = ..Continue(pRequest, .pResponse)
			Do ..ValidateMessage(pRequest,tAction,"Request")
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
			Do ..ValidateMessage(pResponse,$$$PDQv3ContinueResponseAction(1),"Response")
		}
		ElseIf (tAction = $$$PDQv3CancelAction(1)) {
			Set pRequest.Name = $$$PDQv3CancelRequest
			Set tSC = ..Cancel(pRequest, .pResponse)
			Do ..ValidateMessage(pRequest,tAction,"Request")
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
			Do ..ValidateMessage(pResponse,$$$PDQv3CancelResponseAction(1),"Response")
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

Method Query(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:hl7-org:v3:PRPA_IN201305UV02", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Do ..SetAddressingOut($$$PDQv3QueryResponseAction(1))
		Set tSC = ..SendRequestSync(..PDQv3QueryTarget, pRequest, .pResponse)
		Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

Method Continue(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:hl7-org:v3:QUQI_IN000003UV01_Continue", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Do ..SetAddressingOut($$$PDQv3ContinueResponseAction(1))
		Set tSC = ..SendRequestSync(..PDQv3ContinueTarget, pRequest, .pResponse)
		Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

Method Cancel(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:hl7-org:v3:QUQI_IN000003UV01_Cancel", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Do ..SetAddressingOut($$$PDQv3CancelResponseAction(1))
		Set tSC = ..SendRequestSync(..PDQv3CancelTarget, pRequest, .pResponse)
		Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

XData WSDL
{
<?xml version="1.0" encoding="UTF-8"?>
<definitions name="PDQSupplier" targetNamespace="urn:ihe:iti:pdqv3:2007"
xmlns:tns="urn:ihe:iti:pdqv3:2007" xmlns:wsoap11="http://schemas.xmlsoap.org/wsdl/soap/"
xmlns:wsoap12="http://schemas.xmlsoap.org/wsdl/soap12/" xmlns="http://schemas.xmlsoap.org/wsdl/"
xmlns:wsaw="http://www.w3.org/2006/05/addressing/wsdl"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:hl7="urn:hl7-org:v3">
<documentation>WSDL for PDQ Patient Demogrpahics Supplier</documentation>
<types>
<xsd:schema elementFormDefault="qualified" targetNamespace="urn:hl7-org:v3"
xmlns:hl7="urn:hl7-org:v3">
<!-- Include the message schema -->
<xsd:include schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/HL7V3/NE2008/multicacheschemas/PRPA_IN201305UV02.xsd"/>
</xsd:schema>
<xsd:schema elementFormDefault="qualified" targetNamespace="urn:hl7-org:v3"
xmlns:hl7="urn:hl7-org:v3">
<!-- Include the message schema -->
<xsd:include schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/HL7V3/NE2008/multicacheschemas/PRPA_IN201306UV02.xsd"/>
</xsd:schema>
<xsd:schema elementFormDefault="qualified" targetNamespace="urn:hl7-org:v3"
xmlns:hl7="urn:hl7-org:v3">
<!-- Include the message schema -->
<xsd:include schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/HL7V3/NE2008/multicacheschemas/QUQI_IN000003UV01.xsd"/>
</xsd:schema>
<xsd:schema elementFormDefault="qualified" targetNamespace="urn:hl7-org:v3"
xmlns:hl7="urn:hl7-org:v3">
<!-- Include the message schema -->
<xsd:include schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/HL7V3/NE2008/multicacheschemas/MCCI_IN000002UV01.xsd"/>
</xsd:schema>
</types>
<message name="PRPA_IN201305UV02_Message">
<part element="hl7:PRPA_IN201305UV02" name="Body"/>
</message>
<message name="PRPA_IN201306UV02_Message">
<part element="hl7:PRPA_IN201306UV02" name="Body"/>
</message>
<message name="QUQI_IN000003UV01_Message">
<part element="hl7:QUQI_IN000003UV01" name="Body"/>
</message>
<message name="QUQI_IN000003UV01_Cancel_Message">
<part element="hl7:QUQI_IN000003UV01_Cancel" name="Body"/>
</message>
<message name="MCCI_IN000002UV01_Message">
<part element="hl7:MCCI_IN000002UV01" name="Body"/>
</message>
<portType name="PDQSupplier_PortType">
<operation name="PDQSupplier_PRPA_IN201305UV02">
<input message="tns:PRPA_IN201305UV02_Message"
wsaw:Action="urn:hl7-org:v3:PRPA_IN201305UV02"/>
<output message="tns:PRPA_IN201306UV02_Message"
wsaw:Action="urn:hl7-org:v3:PRPA_IN201306UV02"/>
</operation>
<operation name="PDQSupplier_QUQI_IN000003UV01_Continue">
<input message="tns:QUQI_IN000003UV01_Message"
wsaw:Action="urn:hl7-org:v3:QUQI_IN000003UV01_Continue"/>
<output message="tns:PRPA_IN201306UV02_Message"
wsaw:Action="urn:hl7-org:v3:PRPA_IN201306UV02"/>
</operation>
<operation name="PDQSupplier_QUQI_IN000003UV01_Cancel">
<input message="tns:QUQI_IN000003UV01_Cancel_Message"
wsaw:Action="urn:hl7-org:v3:QUQI_IN000003UV01_Cancel"/>
<output message="tns:MCCI_IN000002UV01_Message"
wsaw:Action="urn:hl7-org:v3:MCCI_IN000002UV01"/>
</operation>
</portType>
<binding name="PDQSupplier_Binding_Soap12" type="tns:PDQSupplier_PortType">
<wsoap12:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>
<operation name="PDQSupplier_PRPA_IN201305UV02">
<wsoap12:operation soapAction="urn:hl7-org:v3:PRPA_IN201305UV02"/>
<input>
<wsoap12:body use="literal"/>
</input>
<output>
<wsoap12:body use="literal"/>
</output>
</operation>
<operation name="PDQSupplier_QUQI_IN000003UV01_Continue">
<wsoap12:operation soapAction="urn:hl7-org:v3:QUQI_IN000003UV01_Continue"/>
<input>
<wsoap12:body use="literal"/>
</input>
<output>
<wsoap12:body use="literal"/>
</output>
</operation>
<operation name="PDQSupplier_QUQI_IN000003UV01_Cancel">
<wsoap12:operation soapAction="urn:hl7-org:v3: QUQI_IN000003UV01_Cancel"/>
<input>
<wsoap12:body use="literal"/>
</input>
<output>
<wsoap12:body use="literal"/>
</output>
</operation>
</binding>
<service name="PDQSupplier_Service">
<port binding="tns:PDQSupplier_Binding_Soap12" name="PDQSupplier_Port_Soap12">
<wsoap12:address location="http://example.org/PDQSupplier_Soap12"/>
</port>
</service>
</definitions>
}

}
