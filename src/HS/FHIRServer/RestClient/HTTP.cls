/// This class provides API methods for creating and submitting FHIR REST API calls directly over HTTP.<br>
/// <br>
/// <class>HS.FHIRServer.RestClient.Base</class> holds the primary implementation of all of the
/// interaction-specific instance methods and properties.<br>
/// Behavior specific to this class:<br>
/// - The %ServiceName property refers to the name of a Service Registry HTTP entry.<br>
/// - The %OAuthSendType property is specific to this class.<br>
/// - All input content body (payloads) must be stream or string, already formatted in the desired format.<br>
/// - Internally, requests are invoked via %Net.HttpRequest.<br>
/// <br>
/// Example usage:<br>
/// Set clientObj = ##class(HS.FHIRServer.RestClient.HTTP).CreateInstance("MyFHIR.HTTP.Service")<br>
/// Do clientObj.SetResponseFormat("JSON")<br>
/// Set clientResponseObj = clientObj.Read("GET", "Patient", "123")<br>
/// <br>
/// See <class>HS.FHIRServer.API.Data.RestClient.Response</class> for details on the contents of the client response object (clientResponseObj in the above example).
/// <br>
Class HS.FHIRServer.RestClient.HTTP Extends HS.FHIRServer.RestClient.Base
{

/// OAuth 2.0 send type (header, body, query) to determine where in an HTTP request to place an OAuth 2.0 access token.
Property OAuthSendType As %String [ Calculated ];

/// OAuth 2.0 send type (header, body, query) to determine where in an HTTP request to place an OAuth 2.0 access token.
Property %OAuthSendType As %String [ Private ];

/// Service Registry entry object, buffered as a property to avoid instantiating upon every request.
Property %HttpService As HS.Registry.Service.HTTP [ Private ];

/// HTTP request object, buffered as a property to avoid instantiating on every request.
/// Is Reset before each HTTP request.
Property %HttpRequest As %Net.HttpRequest [ Private ];

/// @API<br>
/// All of the input values constitute inputs/parameters that will be constant for all interactions invoked by this object instance.<br>
/// @Input pServiceName Name of Service Registry HTTP entry.<br>
/// @Input pPrefer Prefer header value.<br>
/// @Input pSessionId Typically a CSP session id. Used in conjunction with OAuthClientName for retrieving an
///    established OAuth 2.0 access token to add to the request.<br>
/// @Input pOAuthClientName Used in conjunction with SessionId for retrieving an OAuth 2.0 access token to add to the request.<br>
/// @Input pOAuthToken OAuth 2.0 access token, provided directly as opposed to retrieving via SessionId+OAuthClientName.<br>
/// @Input pOAuthSendType OAuth 2.0 send type (header, body, query) to determine where in an HTTP request to place an OAuth 2.0 access token.
ClassMethod CreateInstance(pServiceName As %String, pPrefer As %String = "", pSessionId As %String = "", pOAuthClientName As %String = "", pOAuthToken = "", pOAuthSendType As %String = "header") As HS.FHIRServer.RestClient.HTTP
{
	Set obj = ..CreateInstanceCommon(pServiceName, pPrefer, pSessionId, pOAuthClientName, pOAuthToken)
	
	Set httpService = ##class(HS.Registry.Service.Abstract).EndPointForNameType(pServiceName, "HTTP")
	If '$IsObject(httpService) {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrInvalidHTTPServiceSpecified, pServiceName))
	}
	
	Set obj.%HttpService = httpService
	
	If pOAuthSendType="" {
		Set obj.%OAuthSendType = "header"
	} Else {
		Set obj.%OAuthSendType = pOAuthSendType
	}
	
	Set obj.%HttpRequest = ##class(%Net.HttpRequest).%New()
	
	$$$ThrowOnError(obj.%ValidateObject())
	
	Return obj
}

Method OAuthSendTypeGet() As %String [ CodeMode = expression ]
{
..%OAuthSendType
}

/// @API.Overridable<br>
/// MakeRequest creates a %Net.HttpRequest object from the user input that was derived from
/// the interaction-specific method that received it, holds the HTTP request object as the
/// Private class property ..%HttpRequest, and returns a reference to that object.<br>
/// @Input pRequestMethod HTTP verb.<br>
/// @Input pPayload Input payload content, can be FHIR resource content or Patch content.<br>
/// @Input pRequestPath Request path, as derived by the invoked interaction-specific method.<br>
/// @Input pQueryString Query string, as derived by the invoked interaction-specific method.<br>
/// @Input pHeaders Headers array (pHeaders(headerName)=value), as derived by the invoked interaction-specific method.
Method MakeRequest(pRequestMethod As %String, pPayload, pRequestPath As %String, pQueryString As %String, ByRef pHeaders) As %RegisteredObject
{
	$$$ThrowOnError(..%HttpRequest.Reset())
	
	Do ..HttpRequestFromServiceInfo(..%HttpService, ..%HttpRequest)
	
	If ..PayloadHasContent(.pPayload) {
		If ..%RequestFormat="" {
			// Content-Type is required for HTTP request content body.
			$$$ThrowStatus($$$ERROR($$$HSFHIRErrRequestFormatNotSpecified))
		}
		If $IsObject(pPayload) {
			Set payloadStream = pPayload
		} Else {
			Set payloadStream = ##class(%Stream.TmpCharacter).%New()
			Do payloadStream.Write(pPayload)
			Do payloadStream.Rewind()
		}
		Set ..%HttpRequest.ContentType = ..%RequestFormat
		// Per the spec (http://www.hl7.org/fhir/http.html#mime-type), the request body must be
		// UTF-8 encoded, and this must be explicitly stated using the charset parameter of the
		// Content-Type header. Setting ContentCharset will do both.
		Set ..%HttpRequest.ContentCharset = "UTF-8"
		Do ..%HttpRequest.EntityBody.CopyFrom(payloadStream)
		Do ..%HttpRequest.EntityBody.Rewind()
	}
	
	// Allow Accept to be blank, as the user may opt to specify Accept via the _format URL parameter.
	If ..%ResponseFormat'="" {
		Do ..%HttpRequest.SetHeader("Accept", ..%ResponseFormat)
	}
	
	If ..%Prefer'="" {
		Do ..%HttpRequest.SetHeader("Prefer", ..%Prefer)
	}
	
	Set headerName = ""
	For {
		Set headerName = $Order(pHeaders(headerName))
		If headerName="" Quit
		If pHeaders(headerName)'="" {
			Do ..%HttpRequest.SetHeader(headerName, pHeaders(headerName))
		}
	}
	
	// Add an OAuth token to the HTTP request. Note that this code uses the SSL Config from the
	// Service Registry HTTP service, rather than the SSL Config defined for the OAuth client.
	If (..%SessionId'="") && (..%OAuthClientName'="") {
		$$$ThrowOnError(##class(%SYS.OAuth2.AccessToken).AddAccessToken(..%HttpRequest, ..%OAuthSendType, ..%HttpRequest.SSLConfiguration, ..%OAuthClientName, ..%SessionId))
	} ElseIf ..OAuthToken'="" {
		$$$ThrowOnError(##class(%SYS.OAuth2.AccessToken).AuthorizeWithAccessToken(..%HttpRequest, ..%OAuthSendType, ..%HttpRequest.SSLConfiguration, ..%OAuthClientName, ..%OAuthToken))
	}
	
	Return ..%HttpRequest
}

/// Use applicable Service Registry entry information to populate some HTTP request properties.
ClassMethod HttpRequestFromServiceInfo(pServiceObj As HS.Registry.Service.HTTP, pHttpRequest As %Net.HttpRequest) [ Internal ]
{
	Set pHttpRequest.SSLConfiguration = pServiceObj.SSLConfig
	Set pHttpRequest.Https = (pServiceObj.SSLConfig'="")
	Set pHttpRequest.Server = pServiceObj.Host
	// Do not provide a default here if pServiceObj.Port="". See %Net.HttpRequest PortGet().
	Set pHttpRequest.Port = pServiceObj.Port
	Set pHttpRequest.Timeout=$Select(pServiceObj.Timeout="":30,pServiceObj.Timeout=-1:2123456789,1:pServiceObj.Timeout)
	If pServiceObj.HTTPCredentialsConfig'="" {
		Set tCredentialsObj = ##class(Ens.Config.Credentials).%OpenId(pServiceObj.HTTPCredentialsConfig)
		If '$IsObject($Get(tCredentialsObj)) {
			$$$ThrowStatus($$$ERROR($$$HSFHIRErrInvalidServiceCredentials, pServiceObj.Name))
		}
		Set pHttpRequest.Username = tCredentialsObj.Username
		Set pHttpRequest.Password = tCredentialsObj.Password
	}
	
	Set pHttpRequest.SSLCheckServerIdentity = pServiceObj.SSLCheckServerIdentity
	
	Set pHttpRequest.ProxyHTTPS = pServiceObj.ProxyHTTPS
	Set pHttpRequest.ProxyServer = pServiceObj.ProxyHost
	Set pHttpRequest.ProxyPort = pServiceObj.ProxyPort
	Set pHttpRequest.ProxyTunnel = pServiceObj.ProxyHTTPTunnel
	
	Quit
}

/// @API.Overridable<br>
/// InvokeRequest takes the Private %HttpRequest object - passed in as pRequest here -
/// and invokes the request. The HTTP response is stored as the HttpResponse property
/// of the HTTP request object. This method returns a reference to that property.<br>
/// @Input pRequest %Net.HttpRequest object.<br>
/// @Input pRequestMethod HTTP verb.<br>
/// @Input pPayload Input payload content, can be FHIR resource content or Patch content.<br>
/// @Input pRequestPath Request path, as derived by the invoked interaction-specific method.<br>
/// @Input pQueryString Query string, as derived by the invoked interaction-specific method.
Method InvokeRequest(pRequest As %RegisteredObject, pRequestMethod As %String, pRequestPath As %String, pQueryString As %String) As %RegisteredObject
{
	Set methodMixedCase = $Extract(pRequestMethod) _ $ZConvert($Extract(pRequestMethod, 2, *), "L")
	
	Set url = ..%HttpService.URL
	
	If $Extract(url, *)'="/" {
		Set url = url _ "/"
	}
	
	If $Extract(pRequestPath)="/" {
		Set requestPath = $Extract(pRequestPath, 2, *)
	} Else {
		Set requestPath = pRequestPath
	}
	
	If (pQueryString="") || ($Extract(pQueryString)="?") {
		Set queryString = pQueryString
	} Else {
		Set queryString = "?" _ pQueryString
	}
	
	Set pathAndQuery = url _ requestPath _ queryString
	
	If (methodMixedCase'="Delete")&&(methodMixedCase'="Patch") {
		Set tSC = $Method(..%HttpRequest, methodMixedCase, pathAndQuery)
	} Else {
		Set tSC = $Method(..%HttpRequest, "Send", pRequestMethod, pathAndQuery)
	}
	$$$ThrowOnError(tSC)
	
	Return ..%HttpRequest.HttpResponse
}

/// @API.Overridable<br>
/// MakeClientResponseFromResponse takes the HTTP response object, creates a
/// HS.FHIRServer.API.Data.RestClient.Response object from it, and returns
/// that object.<br>
/// @Input pResponse %Net.HttpRequest.HttpResponse object.
Method MakeClientResponseFromResponse(pResponse As %RegisteredObject) As HS.FHIRServer.API.Data.RestClient.Response
{
	Set clientResponse = ##class(HS.FHIRServer.API.Data.RestClient.Response).%New()
	
	Set clientResponse.Status = ..%HttpRequest.HttpResponse.StatusCode _ " " _ ..%HttpRequest.HttpResponse.ReasonPhrase
	
	Set key = ""
	For {
		Set key = ..%HttpRequest.HttpResponse.GetNextHeader(key)
		If key="" Quit
		Set value = ..%HttpRequest.HttpResponse.GetHeader(key)
		Set keyU = $ZConvert(key, "U")
		If keyU="ETAG" {
			Set clientResponse.ETag = value
			Set clientResponse.VId = $Extract($Piece(value, "/", 2), 2, *-1)
		} ElseIf keyU="LAST-MODIFIED" {
			Set clientResponse.LastModified = value
		} ElseIf keyU="LOCATION" {
			Set clientResponse.Location = value
			Set xvalue = $Select($Extract(value, *)="/":$Extract(value, 1, *-1), 1:value)
			Set clientResponse.Id = $Piece(xvalue, "/", *-2)
		} ElseIf keyU="CONTENT-TYPE" {
			Set clientResponse.ResponseFormat = value
		} Else {
			Do clientResponse.OtherHeaders.SetAt(value, key)
		}
	}
	
	Set clientResponse.Payload = ..HttpResponseDataToStream()
	
	Return clientResponse
}

/// Copy an HTTP response Data property content to a specified stream object.
/// The target stream object must already be instantiated by the caller.
Method HttpResponseDataToStream() As %Stream.Object [ Internal ]
{
	If $IsObject(..%HttpRequest.HttpResponse.Data) {
		If ..%HttpRequest.HttpResponse.Data.Size {
			Set responsePayload = ##class(%Stream.TmpCharacter).%New()
			$$$ThrowOnError(responsePayload.CopyFrom(..%HttpRequest.HttpResponse.Data))
			$$$ThrowOnError(..%HttpRequest.HttpResponse.Data.Rewind())
			$$$ThrowOnError(responsePayload.Rewind())
		} Else {
			Set responsePayload = ""
		}
		
	} ElseIf $Length(..%HttpRequest.HttpResponse.Data) {
		Set responsePayload = ##class(%Stream.TmpCharacter).%New()
		$$$ThrowOnError(responsePayload.Write(..%HttpRequest.HttpResponse.Data))
		$$$ThrowOnError(responsePayload.Rewind())
		
	} Else {
		Set responsePayload = ""
	}
	
	Return responsePayload
}

/// Return an indicator of whether the specified payload exists and has content.
/// It must be a stream object or a string.
ClassMethod PayloadHasContent(pPayload) As %Boolean [ Final, Internal ]
{
	// pPayload must be a stream or string.
	If $IsObject($Get(pPayload)) {
		If pPayload.%IsA("%Stream.Object") {
			Set hasContent = pPayload.Size
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
/// Set the Content-Type header value for the request.<br>
/// @Input pFHIRFormatCode Code indicating the requested mime type. Valid values are blank, JSON, XML, Form, JPatch, and XPatch.<br>
/// @Input pCharset charset parameter value for Content-Type header. May be suppressed by explicitly specifying blank string.<br>
/// @Input pFHIRVersion fhirVersion parameter value for Content-Type header. May be a release code (e.g., R4) or version number (e.g. 4.0).
Method SetRequestFormat(pFHIRFormatCode As %String = "", pCharset As %String = "UTF-8", pFHIRVersion As %String = "")
{
	If pFHIRFormatCode="" {
		// Blank out RequestFormat.
		Set contentType = ""
		
	} ElseIf '((pFHIRFormatCode=$$$FHIRContentCodeJSON) || (pFHIRFormatCode=$$$FHIRContentCodeXML) || (pFHIRFormatCode=$$$FHIRContentCodeForm) || (pFHIRFormatCode=$$$FHIRContentCodeXPatch) || (pFHIRFormatCode=$$$FHIRContentCodeJPatch)) {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrInvalidRequestFormatCode, pFHIRFormatCode))
		
	} Else {
		If pFHIRFormatCode=$$$FHIRContentCodeJSON {
			Set mimeType = ..#FHIRMimeTypeJSON
		} ElseIf pFHIRFormatCode=$$$FHIRContentCodeXML {
			Set mimeType = ..#FHIRMimeTypeXML
		} ElseIf pFHIRFormatCode=$$$FHIRContentCodeForm {
			Set mimeType = ..#MimeTypeForm
		} ElseIf pFHIRFormatCode=$$$FHIRContentCodeXPatch {
			Set mimeType = ..#MimeTypeXPatch
		} ElseIf pFHIRFormatCode=$$$FHIRContentCodeJPatch {
			Set mimeType = ..#MimeTypeJPatch
		}
		Set contentType = mimeType
		If pCharset'="" {
			Set contentType = contentType_"; "_pCharset
		}
		Set fhirVersion = ..NormalizeFHIRVersion(pFHIRVersion)
		If fhirVersion'="" {
			Set contentType = contentType_"; "_fhirVersion
		}
	}

	Set ..%RequestFormat = contentType
	
	Quit
}

/// @API<br>
/// Set the Accept header value for the request.<br>
/// @Input pFHIRFormatCode Code indicating the requested mime type. Valid values are blank, JSON, and XML.<br>
/// @Input pCharset charset parameter value for Accept header. May be suppressed by explicitly specifying blank string.<br>
/// @Input pFHIRVersion fhirVersion parameter value for Accept header. May be a release code (e.g., R4) or version number (e.g. 4.0).<br>
Method SetResponseFormat(pFHIRFormatCode As %String = "", pCharset As %String = "UTF-8", pFHIRVersion As %String = "")
{
	If pFHIRFormatCode="" {
		// Blank out ResponseFormat.
		Set accept = ""
		
	} ElseIf '((pFHIRFormatCode=$$$FHIRContentCodeJSON) || (pFHIRFormatCode=$$$FHIRContentCodeXML)) {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrInvalidResponseFormatCode, pFHIRFormatCode))
		
	} Else {
		If pFHIRFormatCode=$$$FHIRContentCodeJSON {
			Set mimeType = ..#FHIRMimeTypeJSON
		} ElseIf pFHIRFormatCode=$$$FHIRContentCodeXML {
			Set mimeType = ..#FHIRMimeTypeXML
		}
		Set accept = mimeType
		If pCharset'="" {
			Set accept = accept_"; "_pCharset
		}
		Set fhirVersion = ..NormalizeFHIRVersion(pFHIRVersion)
		If fhirVersion'="" {
			Set accept = accept_"; "_fhirVersion
		}
	}
	
	Set ..%ResponseFormat = accept
	
	Quit
}

/// Get a fhirVersion string that can be used in the HTTP headers.
ClassMethod NormalizeFHIRVersion(pFHIRVersionIn As %String) As %String [ Internal ]
{
	If (pFHIRVersionIn="STU3") || (pFHIRVersionIn="R3") {
		Set fhirVersion = "fhirVersion=3.0"
	} ElseIf (pFHIRVersionIn="R4") {
		Set fhirVersion = "fhirVersion=4.0"
	} ElseIf pFHIRVersionIn?1N.N1"."1N.N {
		Set fhirVersion = "fhirVersion="_pFHIRVersionIn
	} Else {
		Set fhirVersion = ""
	}
	Return fhirVersion
}

}
