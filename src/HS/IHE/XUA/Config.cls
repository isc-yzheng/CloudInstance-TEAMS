Include HS.HC

Class HS.IHE.XUA.Config Extends (%Persistent, %XML.Adaptor, HS.Sync.BaseClass) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter SYNCORDER = 80;

/// Configuration name MyRHIO, or A_RHIO_to_connect
Property Name As %String [ Required ];

/// The organization identified on an inbound message (could be an OID, could be a URL)
Property OrganizationOID As HS.Data.OIDMap;

/// If the organization-id is a URL
Property OrganizationURL As %String(MAXLEN = 255);

/// When defined it will be the class used to create the SAML assertion
Property SAMLCreatorClass As %String(MAXLEN = 255);

/// The organization OID or organization URL will be used to locate the configuration entry and thus the Processor Class
/// This is a class which extends HS.IHE.XUA.Creator or the older form of HS.CHIxP.SAML.SAMLProcessor
Property SAMLProcessorClass As %String(MAXLEN = 255);

Index NameIndex On Name;

Index OrganizationOIDIndex On OrganizationOID [ Unique ];

/// String to use for the SAML Issuer's name.
/// Either SAMLIssuer should be set to a string containing the
/// distinguished name of the RHIO's certificate, OR SAMLIssuerX509 should
/// contain the alias of an X.509 certificate which references the RHIO's certificate.
/// If both are set to "", an error will be reported when creating new tokens.
/// SAMLIssuer takes precedence over SAMLIssuerX509.
Property Issuer As %String(MAXLEN = 255);

/// Alias for an X.509 certificate object which will be used for the SAML Issuer,
/// and for signing the created token if the SignCreatedAssertion parameter is true.
/// Either SAMLIssuer should be set to a string containing the
/// distinguished name of the RHIO's certificate, OR SAMLIssuerX509 should
/// contain the alias of an X509 certificate which references the RHIO's certificate.
/// If both are set to "", an error will be reported when creating new tokens.
Property IssuerX509 As %String;

/// Controls whether created Assertions will be signed. This requires the
/// SAMLIssuerX509 parameter to refer to a valid set of X.509 credentials,
/// and that SAMLIssuer = "", as SAMLIssuer takes precedence over SAMLIssuerX509.
Property SignCreatedAssertion As %Boolean [ InitialExpression = 0 ];

/// Processor default security domain
Property DefaultSecurityDomain As %String;

/// Processor<br>
/// Optional: A prefix to append to the security domain name. Use this to use "internal"
/// HealthShare security domains which allow assigning roles/groups to a user
Property DomainPrefix As %String [ InitialExpression = "%HS " ];

Property RequireSignature As %Boolean;

/// Creator<br>
/// Controls whether created Assertions will be signed with the WSSecuritySignature
/// or the Signature.  Signing still requires SignCreatedAssertion to be set to true, and the
/// IssuerX509 parameter to refer to a valid set of X.509 credentials.
Property UseWSSSignature As %Boolean [ InitialExpression = 1 ];

/// Processor<br>
/// If this property is true and RequireSignature is true, inspect the KeyInfo on the signature
/// as part of the signature validation.  The assertion will only pass validation if it is
/// possible to identify the signer from the KeyInfo and the signer's credentials are trusted.<br>
/// If this setting is false, a signature which includes a reference to an X.509 certificate
/// will still have the certificate checked against Cache's list of trusted certificates, but
/// signatures which are signed with only an RSA public key, or with symmetric encryption,
/// will pass validation without attempting to identify the signer.<br>
/// It is strongly recommended to set CheckSignerIdentity to true if RequireSignature is set to true.
Property CheckSignerIdentity As %Boolean [ InitialExpression = 1 ];

ClassMethod FindConfiguration(pOrganizationID = "") As HS.IHE.XUA.Config
{
	Set SQLCODE=100
	If pOrganizationID]"" {
		If $zcvt($e(pOrganizationID,1,8),"l")="urn:oid:" {
			Set pOrganizationID=$e(pOrganizationID,9,*)
		} 
		&sql(select ID into :ID from Config where OrganizationOID->OID = :pOrganizationID)
		If SQLCODE {
			&sql(select ID into :ID from Config where OrganizationURL = :pOrganizationID)	
		}
	}
	If 'SQLCODE {
		Quit ..%OpenId(ID)
	}
	Quit ""
}

ClassMethod GetProcessor(pOrganizationID) As HS.IHE.XUA.Processor
{
	try {
		Set tXUAConfig = ##class(HS.IHE.XUA.Config).FindConfiguration(pOrganizationID)
		If $IsObject(tXUAConfig) && (tXUAConfig.SAMLProcessorClass]"") {
			If $classmethod(tXUAConfig.SAMLProcessorClass, "%Extends", "HS.CHIxP.SAML.SAMLProcessor") {
				Set tProcessor=$classMethod(tXUAConfig.SAMLProcessorClass,"%New")
				Quit
			}
			Set tProcessor=$classMethod(tXUAConfig.SAMLProcessorClass,"GetProcessor",tXUAConfig)
		}
	} catch ex {
		$$$LOGERROR(ex.AsStatus())
	}
	Quit $g(tProcessor)
}

/// Add SAML Assertions to the outgoing Security header based on the value of SendSAMLAssertions,
/// SAMLIssuer.
Method AddSAMLAssertions(pRequest As HS.Message.XMLMessage, pWebRequest As %SOAP.WebRequest, pSendSAMLAssertion As %Integer = 0) As %Status
{
	Set tSC = $$$OK
	Set tOptionCreate = 0
	
	Set (tCreatedAssertion, tForwardedAssertion) = $$$NULLOREF
	// Create first
	Set tCreator = $classMethod(..SAMLCreatorClass,"%New")
	If tCreator.%Extends("HS.HC.IHE.XUA.Creator") {
		For tI="Issuer","IssuerX509","SignCreatedAssertion","UseWSSSignature" {
			Set tVal=$property(##this,tI)
			Set:tVal]"" $property(tCreator,tI)=tVal
		}
	}
	If $case(pSendSAMLAssertion, 2: 1, 3: 1, : 0) {
		Set tSC = $method(tCreator, "CreateSAML", pRequest, .tCreatedAssertion)
		If $$$ISERR(tSC) Quit tSC
	}
	// Forward
	If $case(pSendSAMLAssertion, 1: 1, 3: 1, 4:1, 5: 1, : 0) {
		If pRequest.SAMLData.Token="" { Set tOptionCreate=1,tSC=$$$OK}
		Else {
			Set tForwardedAssertion = ##class(HS.IHE.XUA.SecurityElement).%New()
			Set tForwardedAssertion.Content = pRequest.SAMLData.Token
			Set tSC=$$$OK
		}
	}
	// Create second
	If $case(pSendSAMLAssertion, 4: 1, 5: tOptionCreate, : 0) {
		Set tSC = $method(tCreator,"CreateSAML", pRequest, .tCreatedAssertion)
		If $$$ISERR(tSC) Quit tSC
	}
	
	// Need to add assertions in reverse order, due to behaviour of security header output
	If $case(pSendSAMLAssertion, 2: 1, 4: 1, 5: tOptionCreate, : 0) {
		Do:$IsObject(tCreatedAssertion) pWebRequest.SecurityOut.AddToken(tCreatedAssertion)
		If pSendSAMLAssertion = 4 {
			Do:$IsObject(tForwardedAssertion) pWebRequest.SecurityOut.AddToken(tForwardedAssertion)
		}
	}
	If $case(pSendSAMLAssertion, 1: 1, 3: 1, 5: ('tOptionCreate), : 0) {
		Do:$IsObject(tForwardedAssertion) pWebRequest.SecurityOut.AddToken(tForwardedAssertion)
		If pSendSAMLAssertion = 3 {
			Do:$IsObject(tCreatedAssertion) pWebRequest.SecurityOut.AddToken(tCreatedAssertion)
		}
	}
	Quit tSC
}

Query Items() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Name, OrganizationOID->IdentityCode as Organization,SAMLCreatorClass as CreatorClass, SAMLProcessorClass as ProcessorClass FROM Config
 ORDER BY Name
}

Query ConfigurationInUseCount(pConfigID) As %SQLQuery(CONTAINID = 0)
{
	SELECT Count(*) from HS_Registry_Service.SOAP where XUAConfiguration = :pConfigID
}

Storage Default
{
<Data name="ConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ConfigurationName</Value>
</Value>
<Value name="3">
<Value>OrganizationOID</Value>
</Value>
<Value name="4">
<Value>SAMLCreatorClass</Value>
</Value>
<Value name="5">
<Value>SAMLProcessorClass</Value>
</Value>
<Value name="6">
<Value>Host</Value>
</Value>
<Value name="7">
<Value>Port</Value>
</Value>
<Value name="8">
<Value>RHIOName</Value>
</Value>
<Value name="9">
<Value>SAMLIssuer</Value>
</Value>
<Value name="10">
<Value>SAMLIssuerX509</Value>
</Value>
<Value name="11">
<Value>SignCreatedAssertion</Value>
</Value>
<Value name="12">
<Value>SAMLSpecification</Value>
</Value>
<Value name="13">
<Value>SendSAMLAssertion</Value>
</Value>
<Value name="14">
<Value>Name</Value>
</Value>
<Value name="15">
<Value>DefaultSecurityDomain</Value>
</Value>
<Value name="16">
<Value>DomainPrefix</Value>
</Value>
<Value name="17">
<Value>ValidationSpecification</Value>
</Value>
<Value name="18">
<Value>Issuer</Value>
</Value>
<Value name="19">
<Value>IssuerX509</Value>
</Value>
<Value name="20">
<Value>Specification</Value>
</Value>
<Value name="21">
<Value>SendingHost</Value>
</Value>
<Value name="22">
<Value>OrganizationURL</Value>
</Value>
<Value name="23">
<Value>RequireSignature</Value>
</Value>
<Value name="24">
<Value>CheckSignerIdentity</Value>
</Value>
<Value name="25">
<Value>UseWSSSignature</Value>
</Value>
</Data>
<DataLocation>^HS.IHE.XUA.ConfigD</DataLocation>
<DefaultData>ConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.IHE.XUA.ConfigD</IdLocation>
<IndexLocation>^HS.IHE.XUA.ConfigI</IndexLocation>
<StreamLocation>^HS.IHE.XUA.ConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
