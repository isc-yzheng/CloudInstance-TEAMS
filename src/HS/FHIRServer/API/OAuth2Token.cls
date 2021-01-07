/// API class for OAuth 2.0 access token handling.
Class HS.FHIRServer.API.OAuth2Token Extends %RegisteredObject
{

/// The access token string.
Property TokenString As %String(MAXLEN = 8192) [ Calculated ];

/// OAuth 2.0 Client name, as defined in System Administration > Security > OAuth 2.0 > Client.
Property OAuthClient As %String(MAXLEN = 256) [ Calculated ];

/// FHIR request BaseURL.
Property BaseURL As %String(MAXLEN = 1024) [ Calculated ];

/// FHIR request Basic Auth username.
Property Username As %String(MAXLEN = 256) [ Calculated ];

/// The access token JWT object. 
Property TokenObject As %Library.DynamicObject [ Calculated ];

/// $List of access token JWT scopes.
Property ScopesList As %List [ Calculated ];

/// @API<br>
/// Set or re-set the properties of the current token handler instance, based on the input parameters.<br>
/// @Input pTokenString The access token string.<br>
/// @Input pOAuthClient The OAuth 2.0 Client Name, as defined in the Management Portal at System Administration > Security > OAuth 2.0 > Client.
/// @Input pBaseURL The base URL, including scheme, host, port and path of the end point for the current FHIR interaction.
/// @Input pUserame The effective username for the current FHIR interaction.
Method SetInstance(pTokenString As %String = "", pOAuthClient As %String = "", pBaseURL As %String = "", pUsername As %String = "") [ Abstract ]
{
}

/// Verify that the access token allows the current interaction request based on the resource type,
/// resource id and required privilege. If not allowed, this method will Throw. Otherwise, it will
/// simply Return.
Method VerifyResourceIdRequest(pResourceType As %String, pResourceId As %String, pRequiredPrivilege As %String) [ Abstract ]
{
}

/// Verify that the access token allows the current interaction on the specified resource, based on
/// the content and required privilege. If not allowed, this method will Throw. Otherwise, it will
/// simply Return.
Method VerifyResourceContent(pResourceJson As %DynamicObject, pRequiredPrivilege As %String, pAllowSharedResource As %Boolean = 0) [ Abstract ]
{
}

/// Verify that the access token allows the history-instance request based on the contents of
/// the interaction response and required privilege. If not allowed, this method will Throw.
/// Otherwise, it will simply Return.
Method VerifyHistoryInstanceResponse(pResourceType As %String, pResourceJson As %DynamicObject, pRequiredPrivilege As %String) [ Abstract ]
{
}

/// Verify that the access token allows the delete request based on the specified resource type
/// and resource id. If not allowed, this method will Throw. Otherwise, it will simply Return.
Method VerifyDeleteRequest(pResourceType As %String, pResourceId As %String, pRequiredPrivilege As %String) [ Abstract ]
{
}

/// Verify that the access token allows the search request based on some or all of resource type,
/// resource id, compartment type, search parameters and required privilege. If not allowed, this
/// method will Throw. Otherwise, it will simply Return.
Method VerifySearchRequest(pResourceType As %String, pCompartmentResourceType As %String, pCompartmentResourceId As %String, pParameters As HS.FHIRServer.API.Data.QueryParameters, pRequiredPrivilege As %String) [ Abstract ]
{
}

/// Verify that the access token allows the system-level request. If not allowed, this method will
/// Throw. Otherwise, it will simply Return.
Method VerifySystemLevelRequest() [ Abstract ]
{
}

}
