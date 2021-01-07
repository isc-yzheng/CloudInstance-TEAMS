Include HS.IHE.XDSb

Class HS.IHE.XDR.Recipient.Services Extends (HS.IHE.Common.Services.SOAPServer.Base, HS.IHE.Common.Actor.Base) [ Inheritance = right ]
{

/// This is the namespace used by the Service
Parameter NAMESPACE = "urn:ihe:iti:2007";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "DocumentRecipient_Service";

Parameter SETTINGS = "ProvideAndRegisterTarget,ProvideAndRegisterResponseTarget";

Property ProvideAndRegisterTarget As Ens.DataType.ConfigName;

Property ProvideAndRegisterResponseTarget As Ens.DataType.ConfigName;

Method OnProcessInput(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage = {$$$NULLOREF}) As %Status [ ServerOnly = 1 ]
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		Set tAction = pRequest.AdditionalInfo.GetAt("SOAPAction")
		If ..isAsync Set pResponse = ##class(HS.Message.XMLMessage).%New()

		Set tHeader=..HeadersIn.GetAt("addressBlock")
		If $isObject(tHeader) {
			Do pRequest.AdditionalInfo.SetAt(tHeader.from,"Direct:FROM")
			Set tTo=""
			For tIdx=1:1:tHeader.to.Count() {
				Set tTo=tTo_";"_tHeader.to.GetAt(tIdx)
			}
			Do pRequest.AdditionalInfo.SetAt($e(tTo,2,*),"Direct:TO")
			; can set metadata-level here, but the value in the metadata-level header takes priority over this one
			Do pRequest.AdditionalInfo.SetAt(tHeader.Level,"Direct:METADATA-LEVEL")
		}
		Set tHeader=..HeadersIn.GetAt("metadata-level")
		If $isObject(tHeader) {
			if (tHeader.Level'=""){ ; takes priority over the value in addressBlock
				Do pRequest.AdditionalInfo.SetAt(tHeader.Level,"Direct:METADATA-LEVEL")
			}
		}
		
		If (tAction = $$$XDRProvideAndRegisterAction(1)) {
			Set pRequest.Name = $$$XDRProvideAndRegisterRequest
			Set tStatus = ..ProvideAndRegister(pRequest, .pResponse)
			Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
		}
		ElseIf (tAction = $$$XDRProvideAndRegisterResponseAction(1)) {
			Set pRequest.Name = $$$XDRProvideAndRegisterResponse
			Set tStatus = ..ProvideAndRegisterResponse(pRequest, .pResponse)
			Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
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

/// DOC_RECIPIENT - ITI-41 
Method ProvideAndRegister(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:iti:2007:ProvideAndRegisterDocumentSet-b", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		Do ..SetAddressingOut($$$XDSbProvideAndRegisterResponseAction(1))
		if ..isAsync {
			Set tStatus = ..SendRequestAsync(..ProvideAndRegisterTarget, pRequest)
		} Else {
			Set tStatus = ..SendRequestSync(..ProvideAndRegisterTarget, pRequest, .pResponse)
		}
		Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}

	Quit tStatus
}

Method ProvideAndRegisterResponse(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:iti:2007:ProvideAndRegisterDocumentSet-bResponse", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		if ..isAsync {
			Set tStatus = ..SendRequestAsync(..ProvideAndRegisterResponseTarget, pRequest)
		} Else {
			Set tStatus = ..SendRequestSync(..ProvideAndRegisterResponseTarget, pRequest, .pResponse)
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
<definitions xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" xmlns="http://schemas.xmlsoap.org/wsdl/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ihe="urn:ihe:iti:xds-b:2007" xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0" xmlns:soap12="http://schemas.xmlsoap.org/wsdl/soap12/" xmlns:wsaw="http://www.w3.org/2006/05/addressing/wsdl" xmlns:ns="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0" xmlns:ns1="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" xmlns:ns2="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" name="DocumentRepository" targetNamespace="urn:ihe:iti:xds-b:2007">
<documentation>IHE XDR Recipient</documentation>
<types>
<xsd:schema elementFormDefault="qualified" targetNamespace="urn:ihe:iti:xds-b:2007" xmlns:ihe="urn:ihe:iti:xds-b:2007">
<!-- Include the message schema -->
<xsd:include schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/IHE/XDS.b_DocumentRepository.xsd"/>
</xsd:schema>
<xsd:schema elementFormDefault="qualified" targetNamespace="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0" xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0">
<!-- Include the message schema -->
<xsd:include schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/ebRS/rs.xsd"/>
</xsd:schema>
<!-- While no elements are directly used from these schema in the WSDL, 
they need to be present here in order for
code generating toolkits to work properly -->
<xsd:schema elementFormDefault="qualified" targetNamespace="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0" xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0">
<!-- Include the message schema -->
<xsd:include schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/ebRS/lcm.xsd"/>
</xsd:schema>
<xsd:schema elementFormDefault="qualified" targetNamespace="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
<!-- Include the message schema -->
<xsd:include schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/ebRS/rim.xsd"/>
</xsd:schema>
<!--	Importing all schemas within one seems to confuse some parsers 
and code-generation tools (and may be invalid)	
<xsd:schema elementFormDefault="qualified">
<xsd:import namespace="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0"
schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/ebRS/rs.xsd"/>
<xsd:import namespace="urn:ihe:iti:xds-b:2007"
schemaLocation="http://www.intersystems.com:80/healthshare/ihe/schema/IHE/XDS.b_DocumentRepository.xsd"/>
</xsd:schema>
-->
</types>
<message name="RetrieveDocumentSet_Message">
<documentation>Retrieve Document Set</documentation>
<part name="body" element="ihe:RetrieveDocumentSetRequest"/>
</message>
<message name="RetrieveDocumentSetResponse_Message">
<documentation>Retrieve Document Set Response</documentation>
<part name="body" element="ihe:RetrieveDocumentSetResponse"/>
</message>
<message name="ProvideAndRegisterDocumentSet-b_Message">
<documentation>Provide and Register Document Set</documentation>
<part name="body" element="ihe:ProvideAndRegisterDocumentSetRequest"/>
</message>
<message name="ProvideAndRegisterDocumentSet-bResponse_Message">
<documentation>Provide And Register Document Set Response</documentation>
<part name="body" element="rs:RegistryResponse"/>
</message>
<portType name="DocumentRepository_PortType">
<operation name="DocumentRepository_RetrieveDocumentSet">
<input message="ihe:RetrieveDocumentSet_Message" wsaw:Action="urn:ihe:iti:2007:RetrieveDocumentSet"/>
<output message="ihe:RetrieveDocumentSetResponse_Message" wsaw:Action="urn:ihe:iti:2007:RetrieveDocumentSetResponse"/>
</operation>
<operation name="DocumentRepository_ProvideAndRegisterDocumentSet-b">
<input message="ihe:ProvideAndRegisterDocumentSet-b_Message" wsaw:Action="urn:ihe:iti:2007:ProvideAndRegisterDocumentSet-b"/>
<output message="ihe:ProvideAndRegisterDocumentSet-bResponse_Message" wsaw:Action="urn:ihe:iti:2007:ProvideAndRegisterDocumentSet-bResponse"/>
</operation>
</portType>
<binding name="DocumentRepository_Binding" type="ihe:DocumentRepository_PortType">
<soap12:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>
<operation name="DocumentRepository_ProvideAndRegisterDocumentSet-b">
<soap12:operation soapAction="urn:ihe:iti:2007:ProvideAndRegisterDocumentSet-b"/>
<input>
<soap12:body use="encoded"/>
</input>
<output>
<soap12:body use="literal"/>
</output>
</operation>
<operation name="DocumentRepository_RetrieveDocumentSet">
<soap12:operation soapAction="urn:ihe:iti:2007:RetrieveDocumentSet"/>
<input>
<soap12:body use="literal"/>
</input>
<output>
<soap12:body use="literal"/>
</output>
</operation>
</binding>
<service name="DocumentRepository_Service">
<port name="DocumentRepository_Port_Soap12" binding="ihe:DocumentRepository_Binding">
<soap12:address location="http://servicelocation/DocumentRepository_Service"/>
</port>
</service>
</definitions>
}

XData service
{
<parameters xmlns="http://www.intersystems.com/configuration">
<method name="ProvideAndRegister">
<request>
<header name="addressBlock" class="HS.IHE.XDSb.Types.AddressBlockHeader"/>
<header name="metadata-level" class="HS.IHE.XDSb.Types.MetadataLevelHeader"/>
</request>
</method>
</parameters>
}

}
