Include HS.FHIRServer

/// This class is the API spec for a FHIR REST client object. API properties are those that
/// have very little to no expectation to change during the life of an instance of this class.
/// All interaction methods return an HS.FHIRServer.API.Data.RestClient.Response object.
Class HS.FHIRServer.API.RestClient Extends %RegisteredObject [ Abstract ]
{

Parameter FHIRMimeTypeJSON = "application/fhir+json";

Parameter FHIRMimeTypeXML = "application/fhir+xml";

Parameter MimeTypeForm = "application/x-www-form-urlencoded";

Parameter MimeTypeXPatch = "application/xml-patch+xml";

Parameter MimeTypeJPatch = "application/json-patch+json";

/// Name of service (e.g., HTTP service, FHIRServer service) to which to send requests.
Property ServiceName As %String [ Calculated ];

/// Indicator for the format of response payloads.
Property ResponseFormat As %String(MAXLEN = 255) [ Calculated ];

/// Indicator for the format of request payloads.
Property RequestFormat As %String(MAXLEN = 255) [ Calculated ];

/// Prefer header value to apply to requests.
Property Prefer As %String(MAXLEN = 128) [ Calculated ];

/// Session id, typically a CSP session id. Used in conjunction with OAuthClientName
/// for retrieving an established OAuth 2.0 access token to add to the request.
Property SessionId As %String(MAXLEN = 2048) [ Calculated ];

/// OAuth 2.0 client name. Used in conjunction with SessionId for retrieving an
/// OAuth 2.0 access token to add to the request.
Property OAuthClientName As %String(MAXLEN = 128) [ Calculated ];

/// OAuth 2.0 access token, provided directly as opposed to retrieving via SessionId+OAuthClientName.
/// If OAuthToken is specified then OAuthClientName must also be specified.
Property OAuthToken As %String(MAXLEN = "") [ Calculated ];

/// @API<br>
/// Handle a FHIR create interaction request.<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pResource (required) FHIR resource content. Supported type(s) of this input is implementation-specific.<br>
/// @Input pQueryString Query string for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#create
Method Create(pResourceType As %String, pResource, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Abstract ]
{
}

/// @API<br>
/// Handle a FHIR conditional create (create request with If-None-Exist value included) interaction request.<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pResource (required) FHIR resource content. Supported type(s) of this input is implementation-specific.<br>
/// @Input pIfNoneExist (required) Search parameters in URL query string format.<br>
/// @Input pQueryString Query string for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#ccreate
Method ConditionalCreate(pResourceType As %String, pResource, pIfNoneExist As %String, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Abstract ]
{
}

/// @API<br>
/// Handle a FHIR update interaction request.<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pResourceId (required) FHIR resource id.<br>
/// @Input pResource (required) FHIR resource content. Supported type(s) of this input is implementation-specific.<br>
/// @Input pIfMatch ETag-style value, for example W/"23".<br>
/// @Input pQueryString Query string for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#update, http://hl7.org/fhir/http.html#concurrency
Method Update(pResourceType As %String, pResourceId As %String, pResource, pIfMatch As %String, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Abstract ]
{
}

/// @API<br>
/// Handle a FHIR conditional update (update request with search parameters included) interaction request.<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pResource (required) FHIR resource content. Supported type(s) of this input is implementation-specific.<br>
/// @Input pQueryString (required) Query parameters string, for conditional update search parameters and the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#cond-update
Method ConditionalUpdate(pResourceType As %String, pResource, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Abstract ]
{
}

/// @API<br>
/// Handle a FHIR read interaction request.<br>
/// @Input pRequestMethod (required) HTTP verb, must be "HEAD" or "GET".<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pResourceId (required) FHIR resource id.<br>
/// @Input pQueryString Query string for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#read
Method Read(pRequestMethod As %String, pResourceType As %String, pResourceId As %String, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Abstract ]
{
}

/// @API<br>
/// Handle a FHIR conditional read interaction request.<br>
/// @Input pRequestMethod (required) HTTP verb, must be "HEAD" or "GET".<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pResourceId (required) FHIR resource id.<br>
/// @Input pIfNoneMatch (required if pIfModifiedSince not specified) Search parameters in URL query string format.<br>
/// @Input pIfModifiedSince (required if pIfNoneMatch not specified) DateTime value.<br>
/// @Input pQueryString Query string for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#cread
Method ConditionalRead(pRequestMethod As %String, pResourceType As %String, pResourceId As %String, pIfNoneMatch As %String, pIfModifiedSince As %String, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Abstract ]
{
}

/// @API<br>
/// Handle a FHIR vread (read request with a resource version id included) interaction request.<br>
/// @Input pRequestMethod (required) HTTP verb, must be "HEAD" or "GET".<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pResourceId (required) FHIR resource id.<br>
/// @Input pResourceVId (required) FHIR resource version id.<br>
/// @Input pQueryString Query string for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#vread
Method VRead(pRequestMethod As %String, pResourceType As %String, pResourceId As %String, pResourceVId As %String, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Abstract ]
{
}

/// @API<br>
/// Handle a FHIR search interaction request.<br>
/// @Input pRequestMethod (required) HTTP verb, must be "HEAD" or "GET" or "POST".<br>
/// @Input pResourceType FHIR resource type.<br>
/// @Input pCompartment Compartment name for compartment-based search.<br>
/// @Input pResourceId FHIR resource id.<br>
/// @Input pQueryString Query parameters string.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#search, http://hl7.org/fhir/search.html
Method Search(pRequestMethod As %String, pResourceType As %String, pCompartment As %String, pResourceId As %String, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Abstract ]
{
}

/// @API<br>
/// Handle a FHIR delete interaction request.<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pResourceId (required) FHIR resource id.<br>
/// @Input pQueryString Query string for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#delete
Method Delete(pResourceType As %String, pResourceId As %String, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Abstract ]
{
}

/// @API<br>
/// Handle a FHIR conditional delete (delete request with search parameters included) interaction request.<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pQueryString (required) Query parameters string, for required search parameters, and for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#delete
Method ConditionalDelete(pResourceType As %String, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Abstract ]
{
}

/// @API<br>
/// Handle a FHIR history interaction request.<br>
/// @Input pRequestMethod (required) HTTP verb, must be "HEAD" or "GET".<br>
/// @Input pResourceType FHIR resource type.<br>
/// @Input pResourceId FHIR resource id.<br>
/// @Input pSince The instant value for the _since URL parameter.
/// @Input pAt The date-time value for the _at URL parameter.
/// @Input pList The value for the _list URL parameter.
/// @Input pQueryString Query parameters string, for specifying non-history-specific parameters like _summary, _elements, _count, _format, etc. parameters.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#history
Method History(pRequestMethod As %String, pResourceType As %String, pResourceId As %String, pSince As %String, pAt As %String, pList As %String, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Abstract ]
{
}

/// @API<br>
/// Handle a FHIR patch interaction request.<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pResourceId (required) FHIR resource id.<br>
/// @Input pPatchStream (required) Stream of XML Patch or JSON Patch or FHIRPath Patch operations.<br>
/// @Input pIfMatch ETag-style value, for example W/"23".<br>
/// @Input pQueryString Query string for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#patch, http://hl7.org/fhir/http.html#concurrency
Method Patch(pResourceType As %String, pResourceId As %String, pPatchStream As %Stream.Object, pIfMatch As %String, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Abstract ]
{
}

/// @API<br>
/// Handle a FHIR conditional patch (patch request with search query parameters included) interaction request.<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pPatchStream (required) Stream of XML Patch or JSON Patch or FHIRPath Patch operations.<br>
/// @Input pQueryString (required) Query parameters string, for specifying required search parameters and/or the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#patch
Method ConditionalPatch(pResourceType As %String, pPatchStream As %Stream.Object, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Abstract ]
{
}

/// @API<br>
/// Handle a FHIR capabilities (aka metdata) interaction request.<br>
/// @Input pQueryString Query parameters string, for specifying mode, _format, _summary, _elements, etc.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#capabilities.
Method Metadata(pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Abstract ]
{
}

/// @API<br>
/// Handle a FHIR batch / transaction interaction request.<br>
/// @Input pResource (required) FHIR resource content. Supported type(s) of this input is implementation-specific.<br>
/// @Input pQueryString Query string for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#transaction, http://hl7.org/fhir/bundle.html#transaction
Method Batch(pResource, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Abstract ]
{
}

/// @API<br>
/// Handle a FHIR operation interaction request.<br>
/// @Input pRequestMethod (required) HTTP verb, can be "HEAD" or "GET" or "POST", depending on the operation.<br>
/// @Input pOperationName (required) Operation name.<br>
/// @Input pResourceType FHIR resource type.<br>
/// @Input pResourceId FHIR resource id.<br>
/// @Input pResource FHIR resource content. Supported type(s) of this input is implementation-specific.<br>
/// @Input pQueryString Query parameters string.<br>
/// FHIR specification: http://hl7.org/fhir/operations.html
Method Operation(pRequestMethod As %String, pOperationName As %String, pResourceType As %String, pResourceId As %String, pResource, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Abstract ]
{
}

}
