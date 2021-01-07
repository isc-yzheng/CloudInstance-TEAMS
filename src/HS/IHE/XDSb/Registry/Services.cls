Include (HS.IHE.PIX, HS.IHE.XDSb)

Class HS.IHE.XDSb.Registry.Services Extends (HS.IHE.Common.Services.SOAPServer.Base, HS.IHE.Common.Actor.Base) [ Inheritance = right ]
{

/// This is the namespace used by the Service
Parameter NAMESPACE = "urn:ihe:iti:xds-b:2007";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "DocumentRegistry_Service";

/// This is the namespace used for types by the Service
Parameter TYPENAMESPACE = "urn:hl7-org:v3";

Parameter SETTINGS = "XDSbQueryTarget,XDSbRegisterTarget,XDSbRegisterOnDemandTarget,XDSbUpdateDocumentSetTarget,XDSbDeleteDocumentSetTarget,PIXv3ManagerTarget,RMUDocumentSetTarget";

Property XDSbQueryTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Registry.Operations" ];

Property XDSbRegisterTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Registry.Operations" ];

Property XDSbRegisterOnDemandTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Registry.Operations" ];

/// Typically HS.IHE.XDSb.Registry.Operations
Property XDSbDeleteDocumentSetTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Registry.Operations" ];

/// Typically HS.IHE.XDSb.Registry.Operations
Property XDSbUpdateDocumentSetTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Registry.Operations" ];

/// Target to accept patient modification transactions add / revise / merge (PIX.Manager.Process)
Property PIXv3ManagerTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.PIX.Manager.Process" ];

/// Restrictd Metadata Update target, Typically HS.IHE.RMU.Process
Property RMUDocumentSetTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.HC.IHE.RMU.Process" ];

Method OnProcessInput(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage = {$$$NULLOREF}) As %Status [ ServerOnly = 1 ]
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		Set tAction = pRequest.AdditionalInfo.GetAt("SOAPAction")
		If ..isAsync Set pResponse = ##class(HS.Message.XMLMessage).%New()
		If (tAction = $$$XDSbRegisterAction(1)) {
			Set pRequest.Name = $$$XDSbRegisterRequest
			Set tStatus = ..Register(pRequest, .pResponse)
			Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
		}
		ElseIf (tAction = $$$XDSbQueryAction(1)) {
			Set pRequest.Name = $$$XDSbQueryRequest
			Set tStatus = ..Query(pRequest, .pResponse)
			Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
			Do ..ValidateMessage(pResponse,$$$XDSbQueryResponseAction(1),"Response")
		}
		ElseIf (tAction = $$$XDSbQueryMultiPatientAction(1)) {
			Set pRequest.Name = $$$XDSbQueryMultiPatientRequest
			Set tStatus = ..Query(pRequest, .pResponse)
			Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
		}
		ElseIf (tAction = $$$XDSbRegisterOnDemandAction(1)) {
			Set pRequest.Name = $$$XDSbRegisterOnDemandRequest
			Set tStatus = ..RegisterOnDemand(pRequest, .pResponse)
			Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
		} 
		ElseIf (tAction = $$$XDSbDeleteDocumentSetAction(1)) {
			Set pRequest.Name = $$$XDSbDeleteDocumentSetRequest
			Set tStatus = ..DeleteDocumentSet(pRequest, .pResponse)
			Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
		}
		ElseIf (tAction = $$$RMUDocumentSetAction(1)) {
			Set pRequest.Name = $$$RMUDocumentSetRequest
			Set tStatus = ..RestrictedUpdateDocumentSet(pRequest, .pResponse)
			Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
		}
		ElseIf (tAction = $$$XDSbUpdateDocumentSetAction(1)) {
			Set pRequest.Name = $$$XDSbUpdateDocumentSetRequest
			Set tStatus = ..UpdateDocumentSet(pRequest, .pResponse)
			Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
		}		
		ElseIf (tAction = $$$PIXv3AddAction(1)) {
			Set pRequest.Name = $$$PIXv3AddRequest
			Set tStatus = ..Add(pRequest, .pResponse)
			Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
		}
		ElseIf (tAction = $$$PIXv3ReviseAction(1)) {
			Set pRequest.Name = $$$PIXv3ReviseRequest
			Set tStatus = ..Revise(pRequest, .pResponse)
			Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
		}
		ElseIf (tAction = $$$PIXv3MergeAction(1)) {
			Set pRequest.Name = $$$PIXv3MergeRequest
			Set tStatus = ..Merge(pRequest, .pResponse)
			Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
		}Else {
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

/// RegisterDocumentSet-b [ITI-42]
Method Register(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:iti:2007:RegisterDocumentSet-b", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		if ..isAsync {
			Set tStatus = ..SendRequestAsync(..XDSbRegisterTarget, pRequest)
		} Else {
			Do ..SetAddressingOut($$$XDSbRegisterResponseAction(1))
			Set tStatus = ..SendRequestSync(..XDSbRegisterTarget, pRequest, .pResponse)
		}
		Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}

	Quit tStatus
}

/// Registry Stored Query [ITI-18]
Method Query(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:iti:2007:RegistryStoredQuery", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		if ..isAsync {
			Set tStatus = ..SendRequestAsync(..XDSbQueryTarget, pRequest, .pResponse)
		} Else {
			Do ..SetAddressingOut($$$XDSbQueryResponseAction(1))
			Set tStatus = ..SendRequestSync(..XDSbQueryTarget, pRequest, .pResponse)
		}
		Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}

	Quit tStatus
}

/// MultiPatient Stored Query [ITI-51]
Method QueryMultiPatient(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:iti:2009:MultiPatientStoredQuery", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		if ..isAsync {
			Set tStatus = ..SendRequestAsync(..XDSbQueryTarget, pRequest, .pResponse)
		} Else {
			Do ..SetAddressingOut($$$XDSbQueryMultiPatientResponseAction(1))
			Set tStatus = ..SendRequestSync(..XDSbQueryTarget, pRequest, .pResponse)
		}
		Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}

	Quit tStatus
}

/// Register OnDemand [ITI-61]
Method RegisterOnDemand(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:iti:2010:RegisterOnDemandDocumentEntry", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		if ..isAsync {
			Set tStatus = ..SendRequestAsync(..XDSbRegisterOnDemandTarget, pRequest)
		} Else {
			Do ..SetAddressingOut($$$XDSbRegisterOnDemandResponseAction(1))
			Set tStatus = ..SendRequestSync(..XDSbRegisterOnDemandTarget, pRequest, .pResponse)
		}
		Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}

	Quit tStatus
}

/// Patient Identity Feed HL7v3 [ITI-44]
Method Add(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:hl7-org:v3:PRPA_IN201301UV02", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		Do ..SetAddressingOut($$$PIXv3AddResponseAction(1))
		Set tStatus = ..SendRequestSync(..PIXv3ManagerTarget, pRequest, .pResponse)
		Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}

	Quit tStatus
}

Method Revise(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:hl7-org:v3:PRPA_IN201302UV02", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		Do ..SetAddressingOut($$$PIXv3ReviseResponseAction(1))
		Set tStatus = ..SendRequestSync(..PIXv3ManagerTarget, pRequest, .pResponse)
		Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}

	Quit tStatus
}

Method Merge(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:hl7-org:v3:PRPA_IN201304UV02", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		Do ..SetAddressingOut($$$PIXv3MergeResponseAction(1))
		Set tStatus = ..SendRequestSync(..PIXv3ManagerTarget, pRequest, .pResponse)
		Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}

	Quit tStatus
}

/// Delete Document Set ITI-62
Method DeleteDocumentSet(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:iti:2010:DeleteDocumentSet", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		if ..isAsync {
			Set tStatus = ..SendRequestAsync(..XDSbDeleteDocumentSetTarget, pRequest)
		} Else {
			Do ..SetAddressingOut($$$XDSbDeleteDocumentSetResponseAction(1))
			Set tStatus = ..SendRequestSync(..XDSbDeleteDocumentSetTarget, pRequest, .pResponse)
		}
		Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}

	Quit tStatus
}

/// Update Document Set ITI-57
Method UpdateDocumentSet(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:iti:2010:UpdateDocumentSet", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		if ..isAsync {
			Set tStatus = ..SendRequestAsync(..XDSbUpdateDocumentSetTarget, pRequest, .pResponse)
		} Else {
			Do ..SetAddressingOut($$$XDSbUpdateDocumentSetResponseAction(1))
			Set tStatus = ..SendRequestSync(..XDSbUpdateDocumentSetTarget, pRequest, .pResponse)
		}
		Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}

	Quit tStatus
}

/// Restricted Update Document Set ITI-92
Method RestrictedUpdateDocumentSet(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:iti:2018:RestrictedUpdateDocumentSet", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		if ..isAsync {
			Set tStatus = ..SendRequestAsync(..RMUDocumentSetTarget, pRequest, .pResponse)
		} Else {
			Do ..SetAddressingOut($$$RMUDocumentSetResponseAction(1))
			Set tStatus = ..SendRequestSync(..RMUDocumentSetTarget, pRequest, .pResponse)
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
<?xml version="1.0" encoding="utf-8"?>
<!-- This wsdl file is for an XDS.b Document Registry Actor -->
<definitions xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"
xmlns="http://schemas.xmlsoap.org/wsdl/" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:ihe="urn:ihe:iti:xds-b:2007" xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0"
xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0" xmlns:hl7="urn:hl7-org:v3"
xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0" targetNamespace="urn:ihe:iti:xds-b:2007"
xmlns:soap12="http://schemas.xmlsoap.org/wsdl/soap12/"
xmlns:wsaw="http://www.w3.org/2006/05/addressing/wsdl" name="DocumentRegistry">
<documentation>IHE XDS.b Document Registry</documentation>
<types>
<xsd:schema elementFormDefault="qualified" targetNamespace="urn:hl7-org:v3"
xmlns:hl7="urn:hl7-org:v3">
<!-- Include the message schema -->
<xsd:include
schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/HL7V3/NE2008/multicacheschemas/PRPA_IN201301UV02.xsd"/>
</xsd:schema>
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
schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/HL7V3/NE2008/multicacheschemas/PRPA_IN201304UV02.xsd"/>
</xsd:schema>
<xsd:schema elementFormDefault="qualified" targetNamespace="urn:hl7-org:v3"
xmlns:hl7="urn:hl7-org:v3">
<!-- Include the message schema -->
<xsd:include
schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/HL7V3/NE2008/multicacheschemas/MCCI_IN000002UV01.xsd"/>
</xsd:schema>
<xsd:schema elementFormDefault="qualified"
targetNamespace="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0"
xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0">
<!-- Include the message schema -->
<xsd:include schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/ebRS/query.xsd"/>
</xsd:schema>
<xsd:schema elementFormDefault="qualified"
targetNamespace="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0"
xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0">
<!-- Include the message schema -->
<xsd:include schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/ebRS/rs.xsd"/>
</xsd:schema>
<xsd:schema elementFormDefault="qualified"
targetNamespace="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0"
xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0">
<!-- Include the message schema -->
<xsd:include schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/ebRS/lcm.xsd"/>
</xsd:schema>
<!-- While no elements are directly used from this schema in the WSDL, it needs to be present here in order for
code generating toolkits to work properly -->
<xsd:schema elementFormDefault="qualified"
targetNamespace="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0"
xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
<!-- Include the message schema -->
<xsd:include schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/ebRS/rim.xsd"/>
</xsd:schema>
</types>
<message name="RegistryStoredQuery_Message">
<documentation>Registry Stored Query</documentation>
<part name="body" element="query:AdhocQueryRequest"/>
</message>
<message name="RegistryStoredQueryResponse_Message">
<documentation>Registry Stored Query Response</documentation>
<part name="body" element="query:AdhocQueryResponse"/>
</message>
<message name="RegisterDocumentSet-b_Message">
<documentation>Register Document Set - b</documentation>
<part name="body" element="lcm:SubmitObjectsRequest"/>
</message>
<message name="RegisterDocumentSet-bResponse_Message">
<documentation>Register Document Set - b Response</documentation>
<part name="body" element="rs:RegistryResponse"/>
</message>
<message name="PRPA_IN201301UV02_Message">
<part name="body" element="hl7:PRPA_IN201301UV02"/>
</message>
<message name="PRPA_IN201302UV02_Message">
<part name="body" element="hl7:PRPA_IN201302UV02"/>
</message>
<message name="PRPA_IN201304UV02_Message">
<part name="body" element="hl7:PRPA_IN201304UV02"/>
</message>
<message name="MCCI_IN000002UV01_Message">
<part name="body" element="hl7:MCCI_IN000002UV01"/>
</message>
<portType name="DocumentRegistry_PortType">
<operation name="DocumentRegistry_RegisterDocumentSet-b">
<input message="ihe:RegisterDocumentSet-b_Message"
wsaw:Action="urn:ihe:iti:2007:RegisterDocumentSet-b"/>
<output message="ihe:RegisterDocumentSet-bResponse_Message"
wsaw:Action="urn:ihe:iti:2007:RegisterDocumentSet-bResponse"/>
</operation>
<operation name="DocumentRegistry_RegistryStoredQuery">
<input message="ihe:RegistryStoredQuery_Message"
wsaw:Action="urn:ihe:iti:2007:RegistryStoredQuery"/>
<output message="ihe:RegistryStoredQueryResponse_Message"
wsaw:Action="urn:ihe:iti:2007:RegistryStoredQueryResponse"/>
</operation>
<operation name="DocumentRegistry_PRPA_IN201301UV02">
<input message="ihe:PRPA_IN201301UV02_Message"
wsaw:Action="urn:hl7-org:v3:PRPA_IN201301UV02"/>
<output message="ihe:MCCI_IN000002UV01_Message"
wsaw:Action="urn:hl7-org:v3:MCCI_IN000002UV01"/>
</operation>
<operation name="DocumentRegistry_PRPA_IN201302UV02">
<input message="ihe:PRPA_IN201302UV02_Message"
wsaw:Action="urn:hl7-org:v3:PRPA_IN201302UV02"/>
<output message="ihe:MCCI_IN000002UV01_Message"
wsaw:Action="urn:hl7-org:v3:MCCI_IN000002UV01"/>
</operation>
<operation name="DocumentRegistry_PRPA_IN201304UV02">
<input message="ihe:PRPA_IN201304UV02_Message"
wsaw:Action="urn:hl7-org:v3:PRPA_IN201304UV02"/>
<output message="ihe:MCCI_IN000002UV01_Message"
wsaw:Action="urn:hl7-org:v3:MCCI_IN000002UV01"/>
</operation>
</portType>
<binding name="DocumentRegistry_Binding_Soap12" type="ihe:DocumentRegistry_PortType">
<soap12:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>
<operation name="DocumentRegistry_RegisterDocumentSet-b">
<soap12:operation soapAction="urn:ihe:iti:2007:RegisterDocumentSet-b"/>
<input>
<soap12:body use="literal"/>
</input>
<output>
<soap12:body use="literal"/>
</output>
</operation>
<operation name="DocumentRegistry_RegistryStoredQuery">
<soap12:operation soapAction="urn:ihe:iti:2007:RegistryStoredQuery"/>
<input>
<soap12:body use="literal"/>
</input>
<output>
<soap12:body use="literal"/>
</output>
</operation>
<operation name="DocumentRegistry_PRPA_IN201301UV02">
<soap12:operation soapAction="urn:hl7-org:v3:PRPA_IN201301UV02"/>
<input>
<soap12:body use="literal"/>
</input>
<output>
<soap12:body use="literal"/>
</output>
</operation>
<operation name="DocumentRegistry_PRPA_IN201302UV02">
<soap12:operation soapAction="urn:hl7-org:v3:PRPA_IN201302UV02"/>
<input>
<soap12:body use="literal"/>
</input>
<output>
<soap12:body use="literal"/>
</output>
</operation>
<operation name="DocumentRegistry_PRPA_IN201304UV02">
<soap12:operation soapAction="urn:hl7-org:v3:PRPA_IN201304UV02"/>
<input>
<soap12:body use="literal"/>
</input>
<output>
<soap12:body use="literal"/>
</output>
</operation>
</binding>
<service name="DocumentRegistry_Service">
<port name="DocumentRegistry_Port_Soap12" binding="ihe:DocumentRegistry_Binding_Soap12">
<soap12:address location="http://servicelocation/DocumentRegistry_Service"/>
</port>
</service>
</definitions>
}

}
