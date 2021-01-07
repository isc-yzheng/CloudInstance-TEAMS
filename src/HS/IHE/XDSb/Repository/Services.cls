Include HS.IHE.XDSb

Class HS.IHE.XDSb.Repository.Services Extends (HS.IHE.Common.Services.SOAPServer.Base, HS.IHE.Common.Actor.Base) [ Inheritance = right ]
{

/// If extending this service change this parameter = 1 to inherit the methods of this class
Parameter SOAPMETHODINHERITANCE = 0;

/// This is the namespace used by the Service
Parameter NAMESPACE = "urn:ihe:iti:xds-b:2007";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "DocumentRepository_Service";

Parameter SETTINGS = "XDSbProvideAndRegisterTarget,XDSbRetrieveTarget,NotifyAndQueryTarget,DeleteProvideAndRegisterAttachments,DeleteRetrieveAttachments,RemoveDocumentsTarget";

Property XDSbProvideAndRegisterTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Repository.Process" ];

Property RemoveDocumentsTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Repository.Process" ];

Property XDSbRetrieveTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Repository.Process" ];

Property NotifyAndQueryTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.Gateway.XDSb.NotifyAndQuery.Operations" ];

Property DeleteProvideAndRegisterAttachments As %Boolean [ InitialExpression = 0 ];

Property DeleteRetrieveAttachments As %Boolean [ InitialExpression = 0 ];

Method OnProcessInput(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage = {$$$NULLOREF}) As %Status [ ServerOnly = 1 ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Set tAction = pRequest.AdditionalInfo.GetAt("SOAPAction")
		If ..isAsync Set pResponse = ##class(HS.Message.XMLMessage).%New()
		
		If (tAction = $$$XDSbProvideAndRegisterAction(1)) {
			Set pRequest.Name = $$$XDSbProvideAndRegisterRequest
			Do:(..DeleteProvideAndRegisterAttachments) pRequest.AdditionalInfo.SetAt(1,"DeleteAttachments")
			// Attachment will be deleted in HS.IHE.XDSb.Repository.Process after success is confirmed
			Set tSC = ..ProvideAndRegister(pRequest, .pResponse)
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		ElseIf (tAction = $$$XDSbRetrieveAction(1)) {
			Set pRequest.Name = $$$XDSbRetrieveRequest
			Do:(..DeleteRetrieveAttachments) pRequest.AdditionalInfo.SetAt(1,"DeleteAttachments")
			//Attachment will be deleted in HS.IHE.XDSb.Repository.Operations for async, or here for sync
			Set tSC = ..Retrieve(pRequest, .pResponse)
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
			If (('..isAsync)&&$IsObject($g(pResponse))&&pResponse.AdditionalInfo.GetAt("DeleteAttachments")&&$$$ISOK(##class(HS.IHE.XDSb.Util).ProcessResponse(pResponse))){
				Do ##class(HS.IHE.XDSb.Util).DeleteAttachments(.pResponse)
			}
		}
		ElseIf (tAction = $$$RMDAction(1)) {
			Set pRequest.Name = $$$RMDRequest
			Set tSC = ..RemoveDocuments(pRequest, .pResponse)
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		ElseIf (tAction = "NQNotification") {
			Set tSC = ..NQNotification(pRequest, .pResponse)
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		ElseIf (tAction = "NQNotificationReset") {
			Set tSC = ..NQNotification(pRequest, .pResponse)
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
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

/// ITI-41
Method ProvideAndRegister(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:iti:2007:ProvideAndRegisterDocumentSet-b", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		// At connectathon it's useful to be able to route to different registries based on the URL
		If (%request.Get("reg")'="") && ##class(HS.Registry.Config).GetKeyValue("\IHE\Connectathon",0) Do pRequest.AdditionalInfo.SetAt(%request.Get("reg"),"ServiceName")
		Do ..SetAddressingOut($$$XDSbProvideAndRegisterResponseAction(1))
		if ..isAsync {
			Set tSC = ..SendRequestAsync(..XDSbProvideAndRegisterTarget, pRequest)
		} Else {
			Set tSC = ..SendRequestSync(..XDSbProvideAndRegisterTarget, pRequest, .pResponse)
		}
		Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

/// ITI-43
Method Retrieve(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:iti:2007:RetrieveDocumentSet", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Do ..SetAddressingOut($$$XDSbRetrieveResponseAction(1))
		if ..isAsync {
			Set tSC = ..SendRequestAsync(..XDSbRetrieveTarget, pRequest)
		} Else {
			Set tSC = ..SendRequestSync(..XDSbRetrieveTarget, pRequest, .pResponse)
			Quit:$$$ISERR(tSC)
			If $IsObject(pResponse.StreamCollection) { 
				Set tSC = ..MoveAttachments(pResponse)
			}
		}
		Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)

	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

/// ITI-86 Remove documents
Method RemoveDocuments(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "urn:ihe:iti:2017:RemoveDocuments", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	Set tSC = $$$OK

	Try {
		Do ..SetAddressingOut($$$RMDResponseAction(1))
		if ..isAsync {
			Set tSC = ..SendRequestAsync(..RemoveDocumentsTarget, pRequest)
		} Else {
			Set tSC = ..SendRequestSync(..RemoveDocumentsTarget, pRequest, .pResponse)
		}
		Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)

	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

/// Internal transaction used for notification to a notify and query gateway
Method NQNotification(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = NQNotification, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		if ..isAsync {
			Set tSC = ..SendRequestAsync(..NotifyAndQueryTarget, pRequest)
		} Else {
			Set tSC = ..SendRequestSync(..NotifyAndQueryTarget, pRequest, .pResponse)
		}
		Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)

	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

Method NQNotificationReset(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = NQNotificationReset, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		if ..isAsync {
			Set tSC = ..SendRequestAsync(..NotifyAndQueryTarget, pRequest)
		} Else {
			Set tSC = ..SendRequestSync(..NotifyAndQueryTarget, pRequest, .pResponse)
		}
		Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)

	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

XData WSDL
{
<?xml version="1.0" encoding="utf-8"?>
<!-- edited with XMLSpy v2012 rel. 2 sp1 (x64) (http://www.altova.com) by Jim Elden (Accumedic) -->
<!-- This wsdl file is for an XDS.b Document Repository Actor -->
<definitions xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" xmlns="http://schemas.xmlsoap.org/wsdl/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ihe="urn:ihe:iti:xds-b:2007" xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0" xmlns:soap12="http://schemas.xmlsoap.org/wsdl/soap12/" xmlns:wsaw="http://www.w3.org/2006/05/addressing/wsdl" xmlns:ns="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0" xmlns:ns1="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" xmlns:ns2="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" name="DocumentRepository" targetNamespace="urn:ihe:iti:xds-b:2007">
<documentation>IHE XDS.b Document Repository</documentation>
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

}
