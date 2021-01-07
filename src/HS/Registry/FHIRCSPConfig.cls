/// HS.Registry.FHIRCSPConfig defines settings that control some FHIR CSP application behaviors
/// that otherwise are only configurable via %CSP.REST class parameter overrides and/or method
/// overrides.
Class HS.Registry.FHIRCSPConfig Extends (%Persistent, %XML.Adaptor, HS.Sync.BaseClass) [ Inheritance = right ]
{

/// URL of the FHIR end point, should represent the name of an existing CSP application.
Property URL As %String(MAXLEN = 1024) [ Required ];

/// The Version of FHIR that this CSP Application supports
Property FHIRVersion As %String(MAXLEN = 1024) [ Required ];

/// Config item name of the FHIR business service to which to dispatch all incoming requests.
Property ServiceConfigName As %String(MAXLEN = 512) [ Required ];

/// Class name of the FHIR business service to which to dispatch all incoming requests.
Property ServiceClassName As %String(MAXLEN = 512) [ Required ];

/// Resource id of the FHIR Conformance resource that defines the FHIR server capabilities supported by this URL.
Property ConformanceId As %String(MAXLEN = 64) [ Required ];

/// Disable any handling of CORS headers for this URL.  By default, FHIR end points have CORS processing ON.
Property DisableCORS As %Boolean [ InitialExpression = 0 ];

/// Require OAuth 2.0 and/or OpenID Connect processing on all incoming requests.
Property UseOAuth As %Boolean [ InitialExpression = 0 ];

/// When using OAuth 2.0, this is OAuth 2.0 Client name to be used by the resource server.
Property ResourceServerOAuthClient As %String(MAXLEN = 512);

Index URLIndex On URL [ Unique ];

/// This callback method is invoked by the <METHOD>%Open</METHOD> method to 
/// provide notification that the object specified by <VAR>oid</VAR> is being opened.
/// 
/// <P>If this method returns an error then the object will not be opened.
Method %OnOpen() As %Status [ Private, ServerOnly = 1 ]
{
	Set tSC = $$$OK
	
	Try {
		// FHIRVersion will be blank after upgrade to 2018.1 from an earlier
		// release, when the only valid value for this property - had it
		// existed - would have been DSTU2. FHIRVersion will never be blank
		// here for instances created new in 2018.1.
		If ..FHIRVersion="" Set ..FHIRVersion = "DSTU2"
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Query FHIRCSPConfigItems(pType As %Integer = "") As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,URL,ServiceConfigName,ServiceClassName,ConformanceId,FHIRVersion,DisableCORS,UseOAuth,ResourceServerOAuthClient
FROM FHIRCSPConfig
ORDER BY URL
}

Storage Default
{
<Data name="FHIRCSPConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>URL</Value>
</Value>
<Value name="3">
<Value>ServiceConfigName</Value>
</Value>
<Value name="4">
<Value>ServiceClassName</Value>
</Value>
<Value name="5">
<Value>ConformanceId</Value>
</Value>
<Value name="6">
<Value>DisableCORS</Value>
</Value>
<Value name="7">
<Value>UseOAuth</Value>
</Value>
<Value name="8">
<Value>ResourceServerOAuthClient</Value>
</Value>
<Value name="9">
<Value>FHIRVersion</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.FHIRCSPConfigD</DataLocation>
<DefaultData>FHIRCSPConfigDefaultData</DefaultData>
<IdLocation>^HS.Registry.FHIRCSPConfigD</IdLocation>
<IndexLocation>^HS.Registry.FHIRCSPConfigI</IndexLocation>
<StreamLocation>^HS.Registry.FHIRCSPConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
