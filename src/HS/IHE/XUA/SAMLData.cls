/// Base class for results from HS.IHE.XUA.Processor and its subclasses.
/// The results from this class should be used in the service to populate requests
/// sent to other components.
Class HS.IHE.XUA.SAMLData Extends (%SerialObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property UserName As %String(MAXLEN = "");

/// Comma delimited string of roles
Property HSRoles As %String(MAXLEN = "");

/// The name of the organization
Property Organization As %String(MAXLEN = 255);

/// OID from SAML assertion
Property OrganizationOID As %String(MAXLEN = 255);

/// OIDMap entry for User's RHIO
Property RHIO As %String(MAXLEN = 255);

/// National Provider Identifier
Property NPI As %String;

Property BreakTheGlass As %Boolean;

Property PurposeOfUse As HS.IHE.XUA.PurposeOfUse;

Property Token As %String(MAXLEN = "");

Property LoginDomain As %String(MAXLEN = 255);

/// Anything stored in the SAMLInfo array will be passed from message to message
Property SAMLInfo As array Of %String(MAXLEN = "");

/// Items stored in the working array are not carried forward, they are just temporary slots to hold information from method to method
Property Working As %String [ MultiDimensional ];

/// Australian specific properties
Property IDType As %String(MAXLEN = "", VALUELIST = ",HPII,PortalUserIdentifier,LocalSystemIdentifier");

/// Australian specific properties
Property UseRoleForAudit As %Boolean;

/// Australian specific properties
Property IHINumber As %String;

/// Australian specific properties
Property ClientSystemType As %String(MAXLEN = "", VALUELIST = ",CIS,CSP,CRP,HI,Medicare,CPP,CCP,Other");

/// Australian specific properties
/// US spelling which matches Organization inherited from HS.IHE.XUA.SAMLData (HPI-O)
Property OrganizationID As %String(MAXLEN = "");

/// Content of Issuer element in SAML Assertion
Property Issuer As %String(MAXLEN = "");

/// SPProvidedID attribute of Subject element in SAML Assertion, if it exists
Property SubjectSPProvidedID As %String(MAXLEN = "");

/// Content of Subject element in SAML Assertion
Property Subject As %String(MAXLEN = "");

/// no need to do this in the new version as we are passing the whole object
Method CopySAMLInfoToXMLMessage(ByRef pXMLMessage As HS.Message.XMLMessage = "", pPrefix As %String = "SAML:") As %Status
{
	Quit $$$OK
}

Storage Default
{
<Data name="SAMLDataState">
<Value name="1">
<Value>UserName</Value>
</Value>
<Value name="2">
<Value>IssuerFormat</Value>
</Value>
<Value name="3">
<Value>IssuerName</Value>
</Value>
<Value name="4">
<Value>IssuerInstant</Value>
</Value>
<Value name="5">
<Value>SAMLInfo</Value>
</Value>
<Value name="6">
<Value>HSRoles</Value>
</Value>
<Value name="7">
<Value>Role</Value>
</Value>
<Value name="8">
<Value>PurposeOfUse</Value>
</Value>
<Value name="9">
<Value>Organization</Value>
</Value>
<Value name="10">
<Value>RHIO</Value>
</Value>
<Value name="11">
<Value>Token</Value>
</Value>
<Value name="12">
<Value>BreakTheGlass</Value>
</Value>
<Value name="13">
<Value>NPI</Value>
</Value>
<Value name="14">
<Value>LoginDomain</Value>
</Value>
<Value name="15">
<Value>OrganizationOID</Value>
</Value>
<Value name="16">
<Value>Assertion</Value>
</Value>
<Value name="17">
<Value>IDType</Value>
</Value>
<Value name="18">
<Value>UseRoleForAudit</Value>
</Value>
<Value name="19">
<Value>IHINumber</Value>
</Value>
<Value name="20">
<Value>ClientSystemType</Value>
</Value>
<Value name="21">
<Value>OrganizationID</Value>
</Value>
<Value name="22">
<Value>Issuer</Value>
</Value>
<Value name="23">
<Value>SubjectSPProvidedID</Value>
</Value>
<Value name="24">
<Value>Subject</Value>
</Value>
</Data>
<State>SAMLDataState</State>
<StreamLocation>^HS.IHE.XUA.SAMLDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
