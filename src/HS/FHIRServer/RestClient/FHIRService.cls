Include HS.HC

/// This class provides API methods for creating and submitting FHIR REST API calls to a local FHIRServer Service.
/// <br>
/// <class>HS.FHIRServer.RestClient.Base</class> holds the primary implementation of all of the
/// interaction-specific instance methods and properties.<br>
/// Behavior specific to this class:<br>
/// - The %ServiceName property refers to the name of a FHIRServer Service, which is the URL end point of the Service.<br>
/// - The %BaseURL property is specific to this class.<br>
/// - Input content body (payloads) can be stream or string (already formatted in the desired format), or can be %DynamicObject or FHIRObject.<br>
/// - Internally, requests are invoked via a FHIRServer Service instance.<br>
/// <br>
/// Example usage:<br>
/// Set clientObj = ##class(HS.FHIRServer.RestClient.FHIRService).CreateInstance("/csp/healthshare/fhirserver/fhir/r4")<br>
/// Do clientObj.SetResponseFormat("JSON")<br>
/// Set clientResponseObj = clientObj.Read("GET", "Patient", "123")<br>
/// <br>
/// See <class>HS.FHIRServer.API.Data.RestClient.Response</class> for details on the contents of the client response object (clientResponseObj in the above example).
/// <br>
Class HS.FHIRServer.RestClient.FHIRService Extends HS.FHIRServer.RestClient.Base
{

/// BaseURL for the FHIRService Service end point, including the scheme, host and port.
/// Used for formulating returned fullUrls and Location values.
Property %BaseURL As %String(MAXLEN = 2048) [ Private ];

/// Instance of HS.FHIRServer.API.Service ("FHIRServer Service") object.
Property %FHIRService As HS.FHIRServer.API.Service [ Private ];

/// @API<br>
/// Create and return an object instance of this class. All of the input values constitute inputs/parameters that
/// will be constant for all interactions invoked by the returned object instance.<br>
/// @Input pServiceName Name of a FHIRServer Service, which is the URL end point of the Service.<br>
/// @Input pPrefer Prefer header value.<br>
/// @Input pSessionId Typically a CSP session id. Used in conjunction with pOAuthClientName for retrieving an
///    established OAuth 2.0 access token to add to a request.<br>
/// @Input pOAuthClientName Used in conjunction with SessionId for retrieving an OAuth 2.0 access token to add to a request.<br>
/// @Input pOAuthToken OAuth 2.0 access token, provided directly as opposed to retrieving via SessionId+OAuthClientName.<br>
/// @Input pBaseURL BaseURL to use for formulating returned fullUrls and Location values. If not specified, then a value is
///    derived using the current host name and default IRIS instance web server port plus the FHIRServer Service end point URL.
ClassMethod CreateInstance(pServiceName As %String, pPrefer As %String = "", pSessionId As %String = "", pOAuthClientName As %String = "", pOAuthToken = "", pBaseURL As %String = "") As HS.FHIRServer.RestClient.FHIRService
{
	Set obj = ..CreateInstanceCommon(pServiceName, pPrefer, pSessionId, pOAuthClientName, pOAuthToken)
	
	#dim fhirService As HS.FHIRServer.API.Service = ##class(HS.FHIRServer.Service).EnsureInstance(pServiceName)
	
	// EnsureInstance will Throw upon fail, but checking here anyway.
	If '$IsObject(fhirService) {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrInvalidFHIRServiceSpecified, pServiceName))
	}
	
	Set obj.%FHIRService = fhirService
	
	If pBaseURL'="" {
		Set obj.%BaseURL = pBaseURL
	} Else {
		Set host = $ZConvert($$$HSNetworkHostName, "L")
		$$$ThrowOnError(##class(%RoutineMgr).GetWebServerPort(.port))
		Set obj.%BaseURL = "http://" _ host _ $Select(port'="":":",1:"") _ port _ pServiceName
	}
	
	$$$ThrowOnError(obj.%ValidateObject())
	
	Return obj
}

Method BaseURLGet() As %String [ CodeMode = expression ]
{
..%BaseURL
}

/// @API<br>
/// Handle a FHIRServer search interaction request. This override does not move the query string to the payload upon POST.<br>
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
	
	Return ..MakeRequestAndInvoke(pRequestMethod, "", requestPath, pQueryString, .headers)
}

/// @API.Overridable<br>
/// MakeRequest creates a <class>HS.FHIRServer.API.Data.Request</class> object from the user input
/// that was derived from the interaction-specific method that received it, and returns that object.<br>
/// @Input pRequestMethod HTTP verb.<br>
/// @Input pPayload Input payload content, can be stream or string (already formatted in the desired format), or can be %DynamicObject or FHIRObject.<br>
/// @Input pRequestPath Request path, as derived by the invoked interaction-specific method.<br>
/// @Input pQueryString Query string, as derived by the invoked interaction-specific method.<br>
/// @Input pHeaders Headers array (pHeaders(headerName)=value), as derived by the invoked interaction-specific method.
Method MakeRequest(pRequestMethod As %String, pPayload, pRequestPath As %String, pQueryString As %String, ByRef pHeaders) As %RegisteredObject
{
	Set apiRequest = ##class(HS.FHIRServer.API.Data.Request).%New()
	
	Set apiRequest.RequestMethod = pRequestMethod
	
	// Ensure that any input payload is %DynamicObject before storing in apiRequest.Json.
	If ..PayloadHasContent(.pPayload) {
		If $IsObject(pPayload) {
			If pPayload.%IsA("%Stream.Object") {
				If (..%RequestFormat=$$$FHIRContentCodeJSON) || (..%RequestFormat=$$$FHIRContentCodeJPatch) {
					Set apiRequest.Json = ##class(%Library.DynamicObject).%FromJSON(pPayload)
				} ElseIf (..%RequestFormat=$$$FHIRContentCodeXML) {
					Set apiRequest.Json = ##class(HS.FHIRServer.Util.XMLToJSON).XMLToJSON(pPayload, ..%FHIRService.Schema)
				} ElseIf ..%RequestFormat="" {
					$$$ThrowStatus($$$ERROR($$$HSFHIRErrRequestFormatNotSpecified))
				}
			} ElseIf (pPayload.%IsA("%Library.DynamicObject")) || (pPayload.%IsA("%Library.DynamicArray")) {
				Set apiRequest.Json = pPayload
			} ElseIf (pPayload.%IsA("HS.FHIRObject.Object")) || (pPayload.%IsA("HS.FHIRObject.Array")) {
				Set apiRequest.Json = pPayload.JSONGet()
			}
		} Else {
			// Is a string.
			Set apiRequest.Json = ##class(%Library.DynamicObject).%FromJSON(pPayload)
		}
		Set apiRequest.RequestFormatCode = ..%RequestFormat
	}
	
	Set apiRequest.RequestPath = $Select($Extract(pRequestPath)="/":$Extract(pRequestPath,2,*), 1:pRequestPath)
	
	Set apiRequest.QueryString = pQueryString
	
	Set apiRequest.BaseURL = ..%BaseURL
	
	Set apiRequest.ResponseFormatCode = ..%ResponseFormat
	
	Set apiRequest.Prefer = ..%Prefer
	
	Set headerName = ""
	For {
		Set headerName = $Order(pHeaders(headerName))
		If headerName="" Quit
		If pHeaders(headerName)'="" {
			Set $Property(apiRequest, $Translate(headerName, "-")) = pHeaders(headerName)
		}
	}
	
	// Add an OAuth token to the HTTP request. Note that this code uses the SSL Config from the
	// Service Registry HTTP service, rather than the SSL Config defined for the OAuth client.
	If (..%SessionId'="") && (..%OAuthClientName'="") && (..%OAuthToken="") {
		Set boolean = ##class(%SYS.OAuth2.AccessToken).IsAuthorized(..%OAuthClientName, ..%SessionId, , .accessToken, .IDToken, , .error)
		
		If 'boolean {
			If $Data(error) {
				$$$ThrowStatus($$$ERROR($$$GeneralError, error.AsString()))
			} Else {
				$$$ThrowStatus($$$ERROR($$$HSFHIRErrUnknownErrRetrievingToken))
			}
			
		} ElseIf $Get(accessToken)'="" {
			Do apiRequest.AdditionalInfo.SetAt(accessToken, "USER:OAuthToken")
			Do apiRequest.AdditionalInfo.SetAt(..%OAuthClientName, "USER:OAuthClient")
		}
		
	} ElseIf ..OAuthToken'="" {
		Do apiRequest.AdditionalInfo.SetAt(..%OAuthToken, "USER:OAuthToken")
		If ..%OAuthClientName'="" {
			Do apiRequest.AdditionalInfo.SetAt(..%OAuthClientName, "USER:OAuthClient")
		}
	}
	
	Return apiRequest
}

/// @API.Overridable<br>
/// InvokeRequest takes the <class>HS.FHIRServer.API.Data.Request</class> object - passed in as pRequest here -
/// and invokes the FHIRServer Service, passing in the request object. It then returns the
/// <class>HS.FHIRServer.API.Data.Response</class> object that was returned by the FHIRServer Service.<br>
/// @Input pRequest HS.FHIRServer.API.Data.Request object.<br>
/// @Input pRequestMethod (not used)<br>
/// @Input pRequestPath (not used)<br>
/// @Input pQueryString (not used)
Method InvokeRequest(pRequest As %RegisteredObject, pRequestMethod As %String, pRequestPath As %String, pQueryString As %String) As %RegisteredObject
{
	Do ..%FHIRService.DispatchRequest(pRequest, .response)
	
	Return response
}

/// @API.Overridable<br>
/// MakeClientResponseFromResponse takes the <class>HS.FHIRServer.API.Data.Response</class> response object,
/// creates a <class>HS.FHIRServer.API.Data.RestClient.Response</class> object from it, and returns
/// that object.<br>
/// The content payload of the client response, when present, will always be a %DynamicObject, held in the
/// 'Json' property. A helper instance method 'MakeStreamFromJSON' is provided on this class to faciliate
/// serializing the %DynamicObject.<br>
/// @Input pResponse HS.FHIRServer.API.Data.Response object.
Method MakeClientResponseFromResponse(pResponse As %RegisteredObject) As HS.FHIRServer.API.Data.RestClient.Response
{
	Set clientResponse = ##class(HS.FHIRServer.API.Data.RestClient.Response).%New()
	
	For propName = "Json", "Status", "ETag", "LastModified", "Location", "Id", "VId", "IsPrettyOut" {
		Set value = $Property(pResponse, propName)
		If value'="" {
			Set $Property(clientResponse, propName) = value
		}
	}
	
	Set clientResponse.ResponseFormat = pResponse.ResponseFormatCode
	
	Return clientResponse
}

/// Return an indicator of whether the specified payload exists and has content.
/// The payload can be a string, or a stream object, or a %DynamicObject/Array, or a FHIRObject/Array.
ClassMethod PayloadHasContent(pPayload) As %Boolean [ Final, Internal ]
{
	// pPayload must be a stream or string.
	If $IsObject($Get(pPayload)) {
		If pPayload.%IsA("%Stream.Object") {
			Set hasContent = pPayload.Size
		} ElseIf (pPayload.%IsA("%Library.DynamicObject")) || (pPayload.%IsA("%Library.DynamicArray")) {
			Set hasContent = pPayload.%Size()
		} ElseIf (pPayload.%IsA("HS.FHIRObject.Object")) || (pPayload.%IsA("HS.FHIRObject.Array")) {
			Set hasContent = ('pPayload.IsEmpty)
		} Else {
			$$$ThrowStatus($$$ERROR($$$HSFHIRErrUnsupportedInputPayloadSpecified, pPayload))
		}
	} ElseIf $Get(pPayload)'="" {
		// Is a string.
		Set hasContent = 1
	} Else {
		Set hasContent = 0
	}
	
	Return hasContent
}

/// @API<br>
/// Set the RequestFormatCode value for the request.<br>
/// @Input pFHIRFormatCode Code indicating the requested mime type. Valid values are blank, JSON, XML, Form, JPatch, and XPatch.
Method SetRequestFormat(pFHIRFormatCode As %String = "")
{
	If pFHIRFormatCode="" {
		// Blank out RequestFormat.
		Set contentType = ""
		
	} ElseIf '((pFHIRFormatCode=$$$FHIRContentCodeJSON) || (pFHIRFormatCode=$$$FHIRContentCodeXML) || (pFHIRFormatCode=$$$FHIRContentCodeForm) || (pFHIRFormatCode=$$$FHIRContentCodeXPatch) || (pFHIRFormatCode=$$$FHIRContentCodeJPatch)) {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrInvalidRequestFormatCode, pFHIRFormatCode))
		
	} Else {
		Set contentType = pFHIRFormatCode
	}
	
	Set ..%RequestFormat = contentType
	
	Quit
}

/// @API<br>
/// Set the ResponseFormatCode value for the request.<br>
/// @Input pFHIRFormatCode Code indicating the requested mime type. Valid values are blank, JSON, and XML.
Method SetResponseFormat(pFHIRFormatCode As %String = "")
{
	If pFHIRFormatCode="" {
		// Blank out ResponseFormat.
		Set accept = ""
		
	} ElseIf '((pFHIRFormatCode=$$$FHIRContentCodeJSON) || (pFHIRFormatCode=$$$FHIRContentCodeXML)) {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrInvalidResponseFormatCode, pFHIRFormatCode))
		
	} Else {
		Set accept = pFHIRFormatCode
	}
	
	Set ..%ResponseFormat = accept
	
	Quit
}

/// @API<br>
/// Utility method to facilitate creating a stream from the client response Json (%DynamicObject)
/// content, using the current property values of the current REST client object. The client
/// response object includes a property 'IsPrettyOut' that may be passed in as the 'pretty' input
/// parameter here. This method will honor the Private %ResponseFormat property of this class.
Method MakeStreamFromJson(Json As %Library.DynamicObject, pretty As %Boolean = 0) As %Stream.Object
{
	Set stream = ##class(%Stream.TmpCharacter).%New()
	
	If 'pretty {
		Set indentChars = ""
		Set lineTerminator = ""
	} Else {
		Set indentChars = $Char(32,32)
		Set lineTerminator = $Char(13,10)
	}
	
	If ..%ResponseFormat=$$$FHIRContentCodeJSON {
		If 'pretty {
			Do Json.%ToJSON(stream)
		} Else {
			Set formatter = ##class(%JSON.Formatter).%New()
			Set formatter.Indent = 1
			Set formatter.IndentChars = indentChars
			Set formatter.LineTerminator = lineTerminator
			$$$ThrowOnError(formatter.FormatToStream(Json, stream))
		}
	} ElseIf ..%ResponseFormat=$$$FHIRContentCodeXML {
		Do ##class(HS.FHIRServer.Util.JSONToXML).JSONToXML(Json, stream, ..%FHIRService.Schema, indentChars, lineTerminator)
	}
	
	Return stream
}

}
