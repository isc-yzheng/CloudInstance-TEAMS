/// HS.Registry.RESTCSPConfig defines settings that control some REST CSP application behaviors
/// that otherwise are only configurable via %CSP.REST class parameter overrides and/or method
/// overrides. These generally apply to FHIR APIs, but may be used for other REST services as well.
/// In non-FHIR cases, the callback class is more relevant than the other settings.
Class HS.Util.RESTCSPConfig Extends (%Persistent, %XML.Adaptor) [ Inheritance = right, StorageStrategy = "" ]
{

/// URL of the REST end point, should represent the name of an existing CSP application.
Property URL As %String(MAXLEN = 1024) [ Required ];

/// Callback class for ZAUTHENTICATE-related entry points. <br />
/// Expected to implement HS.Util.IAuthenticate. <br />
/// Commonly: <class>HS.Util.RESTHandlerBase</class> for OAuth 2.0 bearer token authentication; <class>HSMOD.SAML.SP.AuthCallback</class> for SAML responses.
Property CallbackClass As %Dictionary.Classname [ InitialExpression = "HS.Util.RESTHandlerBase" ];

/// Config item name of the FHIR business service to which to dispatch all incoming requests.
Property ServiceConfigName As %String(MAXLEN = 512);

/// Class name of the FHIR business service to which to dispatch all incoming requests.
Property ServiceClassName As %String(MAXLEN = 512);

/// When using OAuth 2.0, this is OAuth 2.0 Client name to be used by the resource server.
Property OAuthClientName As %String(MAXLEN = 512);

/// Indicates whether to accept requests with no user authentication.  If false, then
/// any request without an HTTP Authorization header is rejected with HTTP 401)
Property AllowUnauthenticatedAccess As %Boolean [ InitialExpression = 0 ];

/// Disable any handling of CORS headers for this URL.  By default, FHIR end points have CORS processing ON.
Property DisableCORS As %Boolean [ InitialExpression = 0 ];

/// Property Bag for Application-Specific properties.
Property AppData As array Of %String;

/// Namespace in which this instance was created
Property InitialNamespace As %String [ InitialExpression = {$Namespace}, Transient ];

Index URLIndex On URL [ Unique ];

/// This callback method is invoked by the <METHOD>%Open</METHOD> method to 
/// provide notification that the object specified by <VAR>oid</VAR> is being opened.
/// 
/// <P>If this method returns an error then the object will not be opened.
Method %OnOpen() As %Status [ Private, ServerOnly = 1 ]
{
	Set ..InitialNamespace = $Namespace
	If (..CallbackClass = "") {
		Set ..CallbackClass = "HS.Util.RESTHandlerBase"
	}
	Quit $$$OK
}

/// Gets the correct instance of HS.Util.RESTCSPConfig for the current <var>%request</var> context. <br />
/// Returns $$$NULLOREF if there is no REST configuration for the current context.
ClassMethod GetConfigForContext() As HS.Util.RESTCSPConfig
{
	// Use % variable if defined
	If $Data(%hsrestconfig,tRESTConfig)#2 {
		Quit tRESTConfig
	}
	
	If '$IsObject($Get(%request)) {
		Quit $$$NULLOREF
	}
	
	// Get Application with no trailing slash
	Set tApplication = %request.Application
	If ($Extract(tApplication, *) = "/") {
		Set tApplication = $Extract(tApplication, 1, *-1)
	}
	
	// Check for a prefix
	Set tPrefix = %request.URLPrefix
	
	// If there is a prefix, remove it from the Application (is this a bug that it is there?)
	If tPrefix'="" {
		Set tPrefix = $Select($Extract(tPrefix)="/":tPrefix, 1:("/"_tPrefix))_"/"
		If tPrefix = $Extract(tApplication,1,$Length(tPrefix)) {
			Set tApplication = $Extract(tApplication, $Length(tPrefix), *)
		}				
	}
	
	//In a HealthShare namespace, we want to initialize the REST config no matter what the callback returns
	Set tConfig = $$$NULLOREF
	If ..URLIndexExists(tApplication,.tID) {
		Set tConfig = ..%OpenId(tID,,.tSC)
		$$$ThrowOnError(tSC)
	}
	Quit tConfig
}

Storage Default
{
<Data name="AppData">
<Attribute>AppData</Attribute>
<Structure>subnode</Structure>
<Subscript>"AppData"</Subscript>
</Data>
<Data name="RESTCSPConfigDefaultData">
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
<Value>OAuthClientName</Value>
</Value>
<Value name="6">
<Value>AllowUnauthenticatedAccess</Value>
</Value>
<Value name="7">
<Value>DisableCORS</Value>
</Value>
<Value name="8">
<Value>CallbackClass</Value>
</Value>
</Data>
<DataLocation>^HS.Util.RESTCSPConfigD</DataLocation>
<DefaultData>RESTCSPConfigDefaultData</DefaultData>
<IdLocation>^HS.Util.RESTCSPConfigD</IdLocation>
<IndexLocation>^HS.Util.RESTCSPConfigI</IndexLocation>
<StreamLocation>^HS.Util.RESTCSPConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
