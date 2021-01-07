/// This class provides a base implementation of the API methods specified in <class>HS.FHIRServer.API.RestClient</class>.
Class HS.FHIRServer.RestClient.Base Extends HS.FHIRServer.API.RestClient [ Abstract ]
{

Property %ServiceName As %String(MAXLEN = 255) [ Private ];

/// Indicator for the format of response payloads. May be changed between requests if desired.
Property %ResponseFormat As %String(MAXLEN = 255) [ Private ];

/// Indicator for the format of request payloads. May be changed between requests if desired.
Property %RequestFormat As %String(MAXLEN = 255) [ Private ];

/// Prefer header value to apply to requests.
Property %Prefer As %String(MAXLEN = 128) [ Private ];

/// Session id, typically a CSP session id. Used in conjunction with OAuthClientName
/// for retrieving an established OAuth 2.0 access token to add to the request.
Property %SessionId As %String(MAXLEN = 2048) [ Private ];

/// OAuth 2.0 client name. Used in conjunction with SessionId for retrieving an
/// OAuth 2.0 access token to add to the request.
Property %OAuthClientName As %String(MAXLEN = 128) [ Private ];

/// OAuth 2.0 access token, provided directly as opposed to retrieving via SessionId+OAuthClientName.
/// If OAuthToken is specified then OAuthClientName must also be specified.
Property %OAuthToken As %String(MAXLEN = "") [ Private ];

Method ServiceNameGet() As %String [ CodeMode = expression ]
{
..%ServiceName
}

Method ResponseFormatGet() As %String [ CodeMode = expression ]
{
..%ResponseFormat
}

Method RequestFormatGet() As %String [ CodeMode = expression ]
{
..%RequestFormat
}

Method PreferGet() As %String [ CodeMode = expression ]
{
..%Prefer
}

Method SessionIdGet() As %String [ CodeMode = expression ]
{
..%SessionId
}

Method OAuthClientNameGet() As %String [ CodeMode = expression ]
{
..%OAuthClientName
}

Method OAuthTokenGet() As %String [ CodeMode = expression ]
{
..%OAuthToken
}

/// Common object creation tasks.
ClassMethod CreateInstanceCommon(pServiceName As %String, pPrefer As %String, pSessionId As %String, pOAuthClientName As %String, pOAuthToken) As %RegisteredObject [ Internal ]
{
	Set namespaceConfigItem = ##class(HS.Util.Installer.ConfigItem).%OpenId($Namespace)
	If '$IsObject($Get(namespaceConfigItem)) {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrInvalidNamespace, $Namespace))
	}
	
	If $Get(pServiceName)="" {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrServiceNameNotSpecified))
	}
	
	Set obj = ..%New()
	
	Set obj.%ServiceName = pServiceName
	
	Set obj.%Prefer = pPrefer
	
	Set obj.%SessionId = pSessionId
	
	Set obj.%OAuthClientName = pOAuthClientName
	
	Set obj.%OAuthToken = pOAuthToken
	
	Return obj
}

/// @API<br>
/// Handle a FHIR create interaction request.<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pResource (required) FHIR resource content. May be a stream or string.<br>
/// @Input pQueryString Query string for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#create
Method Create(pResourceType As %String, pResource, pQueryString As %String = "") As HS.FHIRServer.API.Data.RestClient.Response
{
	Return ..CreateCommon(.pResourceType, .pResource, "", pQueryString)
}

/// @API<br>
/// Handle a FHIR conditional create (create request with If-None-Exist value included) interaction request.<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pResource (required) FHIR resource content. May be a stream or string.<br>
/// @Input pIfNoneExist (required) Search parameters in URL query string format.<br>
/// @Input pQueryString Query string for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#ccreate
Method ConditionalCreate(pResourceType As %String, pResource, pIfNoneExist As %String, pQueryString As %String = "") As HS.FHIRServer.API.Data.RestClient.Response
{
	If $Get(pIfNoneExist)="" {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrIfNoneExistNotSpecified))
	}
	
	Return ..CreateCommon(.pResourceType, .pResource, pIfNoneExist, pQueryString)
}

Method CreateCommon(pResourceType As %String, pResource, pIfNoneExist As %String, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Internal ]
{
	Set interaction = "create"
	
	If $Get(pResourceType)="" {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrResourceTypeNotSpecified))
	}
	
	// Input payload is required.
	Do ..VerifyPayloadContent(.pResource, 1)
	
	Set requestPath = ..GetRequestPath(interaction, pResourceType)
	
	If pIfNoneExist'="" {
		Set headers("If-None-Exist") = pIfNoneExist
	}
	
	Return ..MakeRequestAndInvoke("POST", pResource, requestPath, pQueryString, .headers)
}

/// @API<br>
/// Handle a FHIR update interaction request.<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pResourceId (required) FHIR resource id.<br>
/// @Input pResource (required) FHIR resource content. Supported type(s) of this input is implementation-specific.<br>
/// @Input pIfMatch ETag-style value, for example W/"23".<br>
/// @Input pQueryString Query string for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#update, http://hl7.org/fhir/http.html#concurrency
Method Update(pResourceType As %String, pResourceId As %String, pResource, pIfMatch As %String = "", pQueryString As %String = "") As HS.FHIRServer.API.Data.RestClient.Response
{
	Set interaction = "update"
	
	If $Get(pResourceId)="" {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrResourceIdNotSpecified))
	}
	
	Return ..UpdateCommon(.pResourceType, pResourceId, .pResource, pIfMatch, pQueryString)
}

/// @API<br>
/// Handle a FHIR conditional update (update request with search parameters included) interaction request.<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pResource (required) FHIR resource content. Supported type(s) of this input is implementation-specific.<br>
/// @Input pQueryString (required) Query parameters string, for conditional update search parameters and _format parameter.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#cond-update
Method ConditionalUpdate(pResourceType As %String, pResource, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response
{
	// VerifyQueryForConditional will Throw if query string not verified per requirement.
	Do ..VerifyQueryForConditional("conditional update", .pQueryString)
	
	Return ..UpdateCommon(.pResourceType, "", .pResource, "", pQueryString)
}

Method UpdateCommon(pResourceType As %String, pResourceId As %String, pResource, pIfMatch As %String, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Internal ]
{
	Set interaction = "update"
	
	If $Get(pResourceType)="" {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrResourceTypeNotSpecified))
	}
	
	// Input payload is required.
	Do ..VerifyPayloadContent(.pResource, 1)
	
	Set requestPath = ..GetRequestPath(interaction, pResourceType, pResourceId)
	
	If pIfMatch'="" {
		Set headers("If-Match") = pIfMatch
	}
	
	Return ..MakeRequestAndInvoke("PUT", pResource, requestPath, pQueryString, .headers)
}

/// @API<br>
/// Handle a FHIR read interaction request.<br>
/// @Input pRequestMethod (required) HTTP verb, must be "HEAD" or "GET".<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pResourceId (required) FHIR resource id.<br>
/// @Input pQueryString Query string for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#read
Method Read(pRequestMethod As %String, pResourceType As %String, pResourceId As %String, pQueryString As %String = "") As HS.FHIRServer.API.Data.RestClient.Response
{
	Return ..ReadCommon(.pRequestMethod, .pResourceType, .pResourceId, "", "", pQueryString)
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
Method ConditionalRead(pRequestMethod As %String, pResourceType As %String, pResourceId As %String, pIfNoneMatch As %String, pIfModifiedSince As %String, pQueryString As %String = "") As HS.FHIRServer.API.Data.RestClient.Response
{
	If ($Get(pIfNoneMatch)="") && ($Get(pIfModifiedSince)="") {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrConditionalReadParamsNotSpecified))
	}
	
	Return ..ReadCommon(.pRequestMethod, .pResourceType, .pResourceId, $Get(pIfNoneMatch), $Get(pIfModifiedSince), pQueryString)
}

Method ReadCommon(pRequestMethod As %String, pResourceType As %String, pResourceId As %String, pIfNoneMatch As %String, pIfModifiedSince As %String, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Internal ]
{
	Set interaction = "read"
	
	Do ..VerifyRequestMethod(.pRequestMethod, "HEAD,GET")
	
	If $Get(pResourceType)="" {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrResourceTypeNotSpecified))
	} ElseIf $Get(pResourceId)="" {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrResourceIdNotSpecified))
	}
	
	Set requestPath = ..GetRequestPath(interaction, pResourceType, pResourceId)
	
	If pIfNoneMatch'="" {
		Set headers("If-None-Match") = pIfNoneMatch
	}
	
	If pIfModifiedSince'="" {
		Set headers("If-Modified-Since") = pIfModifiedSince
	}
	
	Return ..MakeRequestAndInvoke(pRequestMethod, "", requestPath, pQueryString, .headers)
}

/// @API<br>
/// Handle a FHIR vread (read request with a resource version id included) interaction request.<br>
/// @Input pRequestMethod (required) HTTP verb, must be "HEAD" or "GET".<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pResourceId (required) FHIR resource id.<br>
/// @Input pResourceVId (required) FHIR resource version id.<br>
/// @Input pQueryString Query string for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#vread
Method VRead(pRequestMethod As %String, pResourceType As %String, pResourceId As %String, pResourceVId As %String, pQueryString As %String = "") As HS.FHIRServer.API.Data.RestClient.Response
{
	Set interaction = "vread"
	
	Do ..VerifyRequestMethod(.pRequestMethod, "HEAD,GET")
	
	If $Get(pResourceType)="" {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrResourceTypeNotSpecified))
	} ElseIf $Get(pResourceId)="" {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrResourceIdNotSpecified))
	} ElseIf $Get(pResourceVId)="" {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrResourceVersionIdNotSpecified))
	}
	
	Set requestPath = ..GetRequestPath(interaction, pResourceType, pResourceId, pResourceVId)
	
	Return ..MakeRequestAndInvoke(pRequestMethod, "", requestPath, pQueryString, .headers)
}

/// @API<br>
/// Handle a FHIR search interaction request.<br>
/// @Input pRequestMethod (required) HTTP verb, must be "HEAD" or "GET" or "POST".<br>
/// @Input pResourceType FHIR resource type.<br>
/// @Input pCompartment Compartment name for compartment-based search.<br>
/// @Input pResourceId FHIR resource id.<br>
/// @Input pQueryString Query parameters string.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#search, http://hl7.org/fhir/search.html
Method Search(pRequestMethod As %String, pResourceType As %String = "", pCompartment As %String = "", pResourceId As %String = "", pQueryString As %String = "") As HS.FHIRServer.API.Data.RestClient.Response
{
	Set interaction = "search"
	
	Do ..VerifyRequestMethod(.pRequestMethod, "HEAD,GET,POST")
	
	If (pRequestMethod="POST") && (pCompartment'="") {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrPOSTNotForCompartmentSearch))
	}
	
	Set requestPath = ..GetRequestPath($Select(pRequestMethod="POST":"_search",1:interaction), pResourceType, pResourceId, , pCompartment)
	
	// If method is POST, move the query string to the form encoded content body.
	If pRequestMethod="POST" {
		Set payload = pQueryString
		Set queryString = ""
	} Else {
		Set payload = ""
		Set queryString = pQueryString
	}
	
	Return ..MakeRequestAndInvoke(pRequestMethod, payload, requestPath, queryString, .headers)
}

/// @API<br>
/// Handle a FHIR delete interaction request.<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pResourceId (required) FHIR resource id.<br>
/// @Input pQueryString Query string for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#delete
Method Delete(pResourceType As %String, pResourceId As %String, pQueryString As %String = "") As HS.FHIRServer.API.Data.RestClient.Response
{
	Set interaction = "delete"
	
	If $Get(pResourceId)="" {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrResourceIdNotSpecified))
	}
	
	Return ..DeleteCommon(.pResourceType, pResourceId, pQueryString)
}

/// @API<br>
/// Handle a FHIR conditional delete (delete request with search parameters included) interaction request.<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pQueryString (required) Query parameters string, for required search parameters, and also for _format parameter.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#delete
Method ConditionalDelete(pResourceType As %String, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response
{
	// VerifyQueryForConditional will Throw if query string not verified per requirement.
	Do ..VerifyQueryForConditional("conditional delete", .pQueryString)
	
	Return ..DeleteCommon(.pResourceType, "", pQueryString)
}

Method DeleteCommon(pResourceType As %String, pResourceId As %String, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Internal ]
{
	Set interaction = "delete"
	
	If $Get(pResourceType)="" {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrResourceTypeNotSpecified))
	}
	
	Set requestPath = ..GetRequestPath(interaction, pResourceType, pResourceId)
	
	Return ..MakeRequestAndInvoke("DELETE", "", requestPath, pQueryString, .headers)
}

/// @API<br>
/// Handle a FHIR history interaction request.<br>
/// @Input pRequestMethod (required) HTTP verb, must be "HEAD" or "GET".<br>
/// @Input pResourceType FHIR resource type.<br>
/// @Input pResourceId FHIR resource id.<br>
/// @Input pSince The instant value for the _since URL parameter.
/// @Input pAt The date-time value for the _at URL parameter.
/// @Input pList The value for the _list URL parameter.
/// @Input pQueryString Query string for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#history
Method History(pRequestMethod As %String, pResourceType As %String = "", pResourceId As %String = "", pSince As %String = "", pAt As %String = "", pList As %String = "", pQueryString As %String = "") As HS.FHIRServer.API.Data.RestClient.Response
{
	Set interaction = "history"
	
	Do ..VerifyRequestMethod(.pRequestMethod, "HEAD,GET")
	
	Set requestPath = ..GetRequestPath(interaction, pResourceType, pResourceId)
	
	For paramName = "pSince", "pAt", "pList" {
		Set value = $Get(@paramName)
		If value'="" {
			If pQueryString'="" {
				Set pQueryString = pQueryString_"&"
			}
			Set pQueryString = pQueryString _ value
		}
	}
	
	Return ..MakeRequestAndInvoke(pRequestMethod, "", requestPath, pQueryString, .headers)
}

/// @API<br>
/// Handle a FHIR patch interaction request.<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pResourceId (required) FHIR resource id.<br>
/// @Input pPatchStream (required) Stream of XML Patch or JSON Patch or FHIRPath Patch operations.<br>
/// @Input pIfMatch ETag-style value, for example W/"23".<br>
/// @Input pQueryString Query string for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#patch, http://hl7.org/fhir/http.html#concurrency
Method Patch(pResourceType As %String, pResourceId As %String, pPatchStream As %Stream.Object, pIfMatch As %String = "", pQueryString As %String = "") As HS.FHIRServer.API.Data.RestClient.Response
{
	Set interaction = "patch"
	
	If $Get(pResourceId)="" {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrResourceIdNotSpecified))
	}
	
	Return ..PatchCommon(.pResourceType, pResourceId, .pPatchStream, .pIfMatch, pQueryString)
}

/// @API<br>
/// Handle a FHIR conditional patch (patch request with search query parameters included) interaction request.<br>
/// @Input pResourceType (required) FHIR resource type.<br>
/// @Input pPatchStream (required) Stream of XML Patch or JSON Patch or FHIRPath Patch operations.<br>
/// @Input pQueryString (required) Query parameters string, for specifying required search parameters and/or _format parameter.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#patch
Method ConditionalPatch(pResourceType As %String, pPatchStream As %Stream.Object, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response
{
	// VerifyQueryForConditional will Throw if query string not verified per requirement.
	Do ..VerifyQueryForConditional("conditional patch", .pQueryString)
	
	Return ..PatchCommon(.pResourceType, "", .pPatchStream, "", pQueryString)
}

Method PatchCommon(pResourceType As %String, pResourceId As %String, pPatchStream As %Stream.Object, pIfMatch As %String, pQueryString As %String) As HS.FHIRServer.API.Data.RestClient.Response [ Internal ]
{
	Set interaction = "patch"
	
	If $Get(pResourceType)="" {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrResourceTypeNotSpecified))
	}
	
	// Input payload is required.
	Do ..VerifyPayloadContent(.pPatchStream, 1)
	
	Set requestPath = ..GetRequestPath(interaction, pResourceType, pResourceId)
	
	If pIfMatch'="" {
		Set headers("If-Match") = pIfMatch
	}
	
	Return ..MakeRequestAndInvoke("PATCH", pPatchStream, requestPath, pQueryString, .headers)
}

/// @API<br>
/// Handle a FHIR capabilities (aka metdata) interaction request.<br>
/// @Input pQueryString Query string for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#capabilities.
Method Metadata(pQueryString As %String = "") As HS.FHIRServer.API.Data.RestClient.Response
{
	Set interaction = "capabilities"
	
	Set requestPath = ..GetRequestPath(interaction)
	
	Return ..MakeRequestAndInvoke("GET", "", requestPath, pQueryString, .headers)
}

/// @API<br>
/// Handle a FHIR batch / transaction interaction request.<br>
/// @Input pResource (required) FHIR resource content. Supported type(s) of this input is implementation-specific.<br>
/// @Input pQueryString Query string for the common query parameters _format, _pretty, _summary, _elements.<br>
/// FHIR specification: http://hl7.org/fhir/http.html#transaction, http://hl7.org/fhir/bundle.html#transaction
Method Batch(pResource, pQueryString As %String = "") As HS.FHIRServer.API.Data.RestClient.Response
{
	Set interaction = "batch"
	
	// Input payload is required.
	Do ..VerifyPayloadContent(.pResource, 1)
	
	Set requestPath = ..GetRequestPath(interaction)
	
	Return ..MakeRequestAndInvoke("POST", pResource, requestPath, pQueryString, .headers)
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
Method Operation(pRequestMethod As %String, pOperationName As %String, pResourceType As %String = "", pResourceId As %String = "", pResource = "", pQueryString As %String = "") As HS.FHIRServer.API.Data.RestClient.Response
{
	If $Get(pOperationName)="" {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrOperationNameNotSpecified))
	} ElseIf $Extract(pOperationName)="$" {
		Set interaction = pOperationName
	} Else {
		Set interaction = $Extract(pOperationName, 2, *)
	}
	
	Do ..VerifyRequestMethod(.pRequestMethod, "HEAD,GET,POST")
	
	// Input payload is not required.
	Do ..VerifyPayloadContent(.pResource, 0)
	
	Set requestPath = ..GetRequestPath(interaction, pResourceType, pResourceId, , , pOperationName)
	
	Return ..MakeRequestAndInvoke(pRequestMethod, .pResource, requestPath, pQueryString, .headers)
}

Method MakeRequestAndInvoke(pRequestMethod As %String, pPayload, pRequestPath As %String, pQueryString As %String, ByRef pHeaders) As HS.FHIRServer.API.Data.RestClient.Response [ Internal ]
{
	Set request = ..MakeRequest(pRequestMethod, pPayload, pRequestPath, pQueryString, .pHeaders)
	
	Set response = ..InvokeRequest(request, pRequestMethod, pRequestPath, pQueryString)
	
	Set clientResponse = ..MakeClientResponseFromResponse(response)
	
	Return clientResponse
}

/// @API.Overridable<br>
/// Use the specified user input to create a request message.
Method MakeRequest(pRequestMethod As %String, pPayload, pRequestPath As %String, pQueryString As %String, ByRef pHeaders) As %RegisteredObject [ Abstract ]
{
}

/// @API.Overridable<br>
/// "Invoke" the specified request and supplementary data to a handling entity.
Method InvokeRequest(pRequest As %RegisteredObject, pRequestMethod As %String, pRequestPath As %String, pQueryString As %String) As %RegisteredObject [ Abstract ]
{
}

/// @API.Overridable<br>
/// Use the response object from the request invocation to create a RestClient response, and return it.
Method MakeClientResponseFromResponse(pResponse As %RegisteredObject) As HS.FHIRServer.API.Data.RestClient.Response [ Abstract ]
{
}

/// Verify whether the presence or absence of content in the specified payload
/// complies with the requirements of the current client implementation for the
/// current interaction.
ClassMethod VerifyPayloadContent(ByRef pPayload, pIsRequired As %Boolean) [ Internal ]
{
	If ('..PayloadHasContent(.pPayload)) && (pIsRequired) {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrInputPayloadNotSpecified))
	}
	
	Quit
}

/// Return an indicator of whether the specified payload exists and has content,
/// as per the requirements of the current client implementation.
ClassMethod PayloadHasContent(pPayload) As %Boolean [ Abstract, Internal ]
{
}

/// Verify that the specified query string for a given "conditional" interaction
/// actually includes at least one search parameter. If not verified, then this
/// method will Throw an appropriate error.
ClassMethod VerifyQueryForConditional(pInteraction As %String, pQueryString As %String) As %Boolean [ Internal ]
{
	If $Get(pQueryString)="" {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrConditionalRequestMissingURLParams, pInteraction))
		
	} Else {
		Set nonSearchKeys = "_sort,_count,_since,_at,_include,_revinclude,_summary,_elements,_contained,_containedType,_format,debug,_pretty,page,queryId,max"
		For index = 1:1:$Length(nonSearchKeys, ",") {
			Set paramName = $Piece(nonSearchKeys, ",", index)
			If paramName'="" Set nonSearchKeys(paramName) = ""
		}
		If $Extract(pQueryString)="?" {
			Set queryString = $Extract(queryString, 2, *)
		} Else {
			Set queryString = pQueryString
		}
		Set foundSearch = 0
		For i = 1:1:$Length(queryString, "&") {
			Set paramName = $Piece($Piece($Piece(queryString, "&", i), "=", 1), ":", 1)
			If (paramName'="") && ('$Data(nonSearchKeys(paramName))) {
				Set foundSearch = 1
				Quit
			}
		}
		If 'foundSearch {
			$$$ThrowStatus($$$ERROR($$$HSFHIRErrConditionalRequestMissingSearchParams, pInteraction))
		}
	}
	
	Quit
}

ClassMethod VerifyRequestMethod(pRequestMethod As %String, pValidMethods As %String) [ Internal ]
{
	If $Get(pRequestMethod)="" {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrRequestMethodNotSpecified, pValidMethods))
	} ElseIf ((","_pValidMethods_",")'[(","_pRequestMethod_",")) {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrInvalidRequestMethodSpecified, pValidMethods))
	}
	Quit
}

/// Given the specified inputs, generate a FHIR request path (i.e., the part of
/// the request URL that follows the Base URL and precedes the query string).
ClassMethod GetRequestPath(pInteraction = "", pResourceType = "", pResourceId = "", pResourceVId = "", pCompartment = "", pOperation = "") As %String [ Internal ]
{
	Set path = ""
	
	If (pOperation'="")&&($Extract(pOperation)'="$") {
		Set pOperation = "$" _ pOperation
	}
	
	If pInteraction="capabilities" {
		Set path = "/metadata"
		
	} ElseIf pCompartment'="" {
		Set path = "/"_ pCompartment _"/" _ pResourceId _ "/" _ pResourceType
		
	} ElseIf (pInteraction="batch") || (pInteraction="transaction") {
		Set path = ""
		
	} Else {
		// Note that this is adding things on in reverse order.
		If pOperation'="" {
			Set path = "/" _ pOperation
		}
		If (pResourceVId'="") && (pInteraction="vread") {
			Set path = "/" _ pResourceVId _ path
		}
		If (pInteraction="vread") || (pInteraction="history") {
			Set path = "/_history" _ path
		}
		If pInteraction="_search" {
			Set path = "/_search" _ path
		}
		If (pResourceId'="") && ('((pInteraction="search")&&(pCompartment=""))) && (pInteraction'="_search") {
			Set path = "/" _ pResourceId _ path
		}
		If pResourceType'="" {
			Set path = "/"_ pResourceType _ path
		}
	}

	Return path
}

}
