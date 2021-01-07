/// Domains scope logins in HealthShare
Class HS.Registry.AuthDomain Extends (HS.Types.AuthDomainInfo, %Persistent, %XML.Adaptor, HS.Sync.BaseClass) [ ClassType = persistent, Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter SYNCORDER = 50;

Index DomainIndex On DomainCode [ IdKey, Unique ];

/// API Method: Load domain info into an object
/// Returns 1 if OK, 0 if domain not found
ClassMethod LoadAuthDomain(pDomainCode As %String, Output pDomainInfo As HS.Types.AuthDomainInfo) As %Boolean
{
	Set tDomainInfo=..%OpenId(pDomainCode) Quit:'$IsObject(tDomainInfo) 0
	Do ##class(HS.Types.AuthDomainInfo).CopyFrom(tDomainInfo,.pDomainInfo)
	Quit 1
}

/// API Method: Do add/update save of domain info
ClassMethod SaveAuthDomain(pDomainInfo As HS.Types.AuthDomainInfo) As %Status
{
	#dim tSC as %Status = $$$OK
	Try {
		Do:pDomainInfo.DefaultFlag ..SetDefaultFlag()
		Set tDomain=..%OpenId(pDomainInfo.DomainCode)
		Set:'$IsObject(tDomain) tDomain=..%New()
		Do tDomain.CopyFrom(pDomainInfo,tDomain)
		Set tSC=tDomain.%Save()
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// API Method: Delete a domain
/// Simple wrapper around %DeleteId
ClassMethod DeleteAuthDomain(pDomainCode As %String) As %Status
{
	Quit ..%DeleteId(pDomainCode)
}

Query Domains() As %SQLQuery(CONTAINID = 1)
{
SELECT DomainCode, Description, DefaultFlag, FacilityCode, AuthenticationServiceName, AuthorizationServiceName, CallbackClass FROM HS_Registry.AuthDomain
 ORDER BY DomainCode
}

/// called by HS.UI.Hub.Domain
ClassMethod SetDefaultFlag() As %Status
{
	&SQL(Update HS_Registry.AuthDomain Set DefaultFlag=0)
	Quit $$$OK
}

/// API Method: Get the default domain code
ClassMethod GetDefaultDomain(pReturnHSDefaultDomain As %Boolean = 1) As %String
{
	&SQL(SELECT DomainCode INTO :tDomain FROM HS_Registry.AuthDomain WHERE DefaultFlag=1)
	If (SQLCODE = 0) {
		Quit tDomain
	}
	ElseIf (pReturnHSDefaultDomain) {
		Quit "%HS_Default"
	}
	Else {
		Quit ""
	}
}

Storage Default
{
<Data name="AuthDomainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Roles</Value>
</Value>
<Value name="4">
<Value>DefaultFlag</Value>
</Value>
<Value name="5">
<Value>AuthenticationServiceName</Value>
</Value>
<Value name="6">
<Value>AuthorizationServiceName</Value>
</Value>
<Value name="7">
<Value>FacilityCode</Value>
</Value>
<Value name="8">
<Value>CallbackClass</Value>
</Value>
<Value name="9">
<Value>UseTwoFactor</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.AuthDomainD</DataLocation>
<DefaultData>AuthDomainDefaultData</DefaultData>
<IdLocation>^HS.Registry.AuthDomainD</IdLocation>
<IndexLocation>^HS.Registry.AuthDomainI</IndexLocation>
<StreamLocation>^HS.Registry.AuthDomainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
