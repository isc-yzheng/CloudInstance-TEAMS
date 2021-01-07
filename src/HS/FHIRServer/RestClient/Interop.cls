Include HS.HC

/// This class provides API methods for creating and submitting FHIR REST API calls to an Interoperability business operation.<br>
/// <br>
/// <class>HS.FHIRServer.RestClient.Base</class> holds the primary implementation of all of the
/// interaction-specific instance methods and properties.<br>
/// <br>
/// Behavior specific to this class:<br>
/// - The %ServiceName property refers to the name of a Service Registry HTTP entry.<br>
/// - The %TargetConfigName property is specific to this class.<br>
/// - The %HostObject property is specific to this class.<br>
/// - All input content body (payloads) must be stream or string, already formatted in the desired format.<br>
/// - If %HostObject has a value, then that host is used for sending the request message to
///   %TargetConfigName. Otherwise, requests are invoked via HS.HC.Util.BusinessService, which
///   sends it to %TargetConfigName.<br>
/// <br>
/// Production setup:<br>
/// - Add an instance of HS.FHIRServer.Interop.HTTPOperation (or a class extended from it) to your
///   local production. Specify that production item name in the pTargetConfigName parameter
///   when you call CreateInstance() for this class.<br>
/// - If you intend to invoke the client object without having provided a business host object to
///   it (pHostObj parameter on CreateInstance()), add business service HS.HC.Util.BusinessService
///   to your local production.<br>
/// <br>
/// Example usage from standalone IRIS application:<br>
/// Set clientObj = ##class(HS.FHIRServer.RestClient.Interop).CreateInstance("MyFHIR.HTTP.Service", , , , , , , "HS.FHIRServer.Interop.HTTPOperation")<br>
/// Do clientObj.SetResponseFormat("JSON")<br>
/// Set clientResponseObj = clientObj.Read("GET", "Patient", "123")<br>
/// <br>
/// Example usage from within business host:<br>
/// Set clientObj = ##class(HS.FHIRServer.RestClient.Interop).CreateInstance("MyFHIR.HTTP.Service", , , , , , , "HS.FHIRServer.Interop.HTTPOperation", $this)<br>
/// Do clientObj.SetResponseFormat("JSON")<br>
/// Set clientResponseObj = clientObj.Read("GET", "Patient", "123")<br>
/// <br>
Class HS.FHIRServer.RestClient.Interop Extends HS.FHIRServer.RestClient.Base
{

/// OAuth 2.0 send type (header, body, query) to determine where in an HTTP request to place an OAuth 2.0 access token.
Property %OAuthSendType As %String [ Private ];

/// Name of business operation to handle the outgoing request. Must be the name of a config item that
/// uses class name HS.FHIRServer.Interop.HTTPOperation, or a class that extends that class.
Property %TargetConfigName As Ens.DataType.ConfigName [ Private ];

/// Business host object to use for sending request to %TargetConfigName.
Property %HostObject As Ens.Host [ Private ];

/// %Id() of a QuickStream created by the invocation of an interaction method of this class.
Property %QuickStreamId As %String [ Private ];

/// @API<br>
/// Create and return an object instance of this class. All of the input values constitute inputs/parameters that
/// will be constant for all interactions invoked by the returned object instance.<br>
/// @Input pServiceName (required) Name of a FHIRServer Service, which is the URL end point of the Service.<br>
/// @Input pPrefer Prefer header value.<br>
/// @Input pSessionId Typically a CSP session id. Used in conjunction with pOAuthClientName for retrieving an
///    established OAuth 2.0 access token to add to a request.<br>
/// @Input pOAuthClientName Used in conjunction with SessionId for retrieving an OAuth 2.0 access token to add to a request.<br>
/// @Input pOAuthToken OAuth 2.0 access token, provided directly as opposed to retrieving via SessionId+OAuthClientName.<br>
/// @Input pTargetConfigName (required) Name of business operation to handle the outgoing request.
/// @Input pHostObj Instance of business host object to use for sending request to pTargetConfigName.
ClassMethod CreateInstance(pServiceName As %String, pPrefer As %String = "", pSessionId As %String = "", pOAuthClientName As %String = "", pOAuthToken = "", pOAuthSendType As %String = "header", pTargetConfigName As %String, pHostObj As Ens.Host = "") As HS.FHIRServer.RestClient.FHIRService
{
	If $Get(pTargetConfigName)="" {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrTargetConfigNameNotSpecified))
	}
	
	Set obj = ..CreateInstanceCommon(pServiceName, pPrefer, pSessionId, pOAuthClientName, pOAuthToken)
	
	If pOAuthSendType="" {
		Set obj.%OAuthSendType = "header"
	} Else {
		Set obj.%OAuthSendType = pOAuthSendType
	}
	
	// Verify that pTargetConfigName is in the current production, and is or extends a required class.
	
	Set productionClass = ##class(HS.Util.Installer.ConfigItem).ProductionGetStored($Namespace)
	Set productionObj = ##class(Ens.Config.Production).%OpenId(productionClass)
	Set found = 0
	Set valid = 0
	For itemIndex = 1:1:productionObj.Items.Count() {
		Set productionItem = productionObj.Items.GetAt(itemIndex)
		If productionItem.Name = pTargetConfigName {
			Set found = 1
			For requiredOperationClass = "HS.FHIRServer.Interop.HTTPOperation" {
				Set valid = $ClassMethod(productionItem.ClassName, "%IsA", requiredOperationClass)
				If valid Quit
			}
			Quit
		}
	}
	If 'found {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrTargetConfigNameNotFound, pTargetConfigName))
	} ElseIf 'valid {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrInvalidTargetConfigName, pTargetConfigName))
	}
	
	Set obj.%TargetConfigName = pTargetConfigName
	
	If $IsObject(pHostObj) {
		Set obj.%HostObject = pHostObj
	}
	
	$$$ThrowOnError(obj.%ValidateObject())
	
	Return obj
}

Method OAuthSendTypeGet() As %String [ CodeMode = expression ]
{
..%OAuthSendType
}

Method TargetConfigNameGet() As Ens.DataType.ConfigName [ CodeMode = expression ]
{
..%TargetConfigName
}

Method HostObjectGet() As Ens.Host [ CodeMode = expression ]
{
..%HostObject
}

Method QuickStreamIdGet() As %String [ CodeMode = expression ]
{
..%QuickStreamId
}

/// This implementation of MakeRequestAndInvoke() ensures that any QuickStream
/// created by the MakeRequest() method of this class gets cleaned up.
Method MakeRequestAndInvoke(pRequestMethod As %String, pPayload, pRequestPath As %String, pQueryString As %String, ByRef pHeaders) As HS.FHIRServer.API.Data.RestClient.Response [ Final, Internal ]
{
	#define cleanQS If ..%QuickStreamId'="" Set qs=##class(HS.SDA3.QuickStream).%OpenId(..%QuickStreamId) Do:$IsObject(qs) qs.Clear() Set ..%QuickStreamId=""
	
	Try {
		Set clientResponse = ##super(pRequestMethod, pPayload, pRequestPath, pQueryString, .pHeaders)
		
	} Catch eException {
		$$$cleanQS
		Throw eException
	}
	
	$$$cleanQS
	
	Return clientResponse
}

/// @API.Overridable<br>
/// MakeRequest creates a <class>HS.FHIRServer.Interop.Request</class> object from the user input
/// that was derived from the interaction-specific method that received it, and returns that object.<br>
/// @Input pRequestMethod HTTP verb.<br>
/// @Input pPayload Input payload content, can be stream or string, already formatted in the desired format.<br>
/// @Input pRequestPath Request path, as derived by the invoked interaction-specific method.<br>
/// @Input pQueryString Query string, as derived by the invoked interaction-specific method.<br>
/// @Input pHeaders Headers array (pHeaders(headerName)=value), as derived by the invoked interaction-specific method.
Method MakeRequest(pRequestMethod As %String, pPayload, pRequestPath As %String, pQueryString As %String, ByRef pHeaders) As %RegisteredObject
{
	Set ..%QuickStreamId = ""
	
	Set interopRequest = ##class(HS.FHIRServer.Interop.Request).%New()
	
	Set apiRequest = ##class(HS.FHIRServer.API.Data.Request).%New()
	
	Do apiRequest.AdditionalInfo.SetAt(..%ServiceName, "ServiceName")
	
	Set apiRequest.RequestMethod = pRequestMethod
	
	If ..PayloadHasContent(.pPayload) {
		If ..%RequestFormat="" {
			// Unknown if this is bound for sending over HTTP,
			// so unconditionally require the format.
			$$$ThrowStatus($$$ERROR($$$HSFHIRErrRequestFormatNotSpecified))
		}
		If $IsObject(pPayload) {
			If pPayload.%IsA("HS.SDA3.QuickStream") {
				Set quickStreamId = pPayload.%Id()
			} Else {
				Set quickStream = ##class(HS.SDA3.QuickStream).%New()
				Set quickStreamId = quickStream.%Id()
				// Set ..%QuickStreamId only for QuickStream created by this method.
				Set ..%QuickStreamId = quickStreamId
				$$$ThrowOnError(quickStream.CopyFrom(pPayload))
			}
		} Else {
			Set quickStream = ##class(HS.SDA3.QuickStream).%New()
			Set quickStreamId = quickStream.%Id()
			// Set ..%QuickStreamId only for QuickStream created by this method.
			Set ..%QuickStreamId = quickStreamId
			$$$ThrowOnError(quickStream.Write(pPayload))
			Do quickStream.Rewind()
		}
		Set apiRequest.RequestFormatCode = ..%RequestFormat
		Set interopRequest.QuickStreamId = quickStreamId
	}
	
	Set apiRequest.RequestPath = pRequestPath
	
	Set apiRequest.QueryString = pQueryString
	
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
				$$$ThrowStatus($$$ERROR($$$GeneralError, "Unknown error while retrieving access token"))
			}
			
		} ElseIf $Get(accessToken)'="" {
			Do apiRequest.AdditionalInfo.SetAt(accessToken, "USER:OAuthToken")
			Do apiRequest.AdditionalInfo.SetAt(..%OAuthClientName, "USER:OAuthClient")
			Do apiRequest.AdditionalInfo.SetAt(..%OAuthSendType, "OAuthSendType")
		}
		
	} ElseIf ..OAuthToken'="" {
		Do apiRequest.AdditionalInfo.SetAt(..%OAuthToken, "USER:OAuthToken")
		Do apiRequest.AdditionalInfo.SetAt(..%OAuthSendType, "OAuthSendType")
		If ..%OAuthClientName'="" {
			Do apiRequest.AdditionalInfo.SetAt(..%OAuthClientName, "USER:OAuthClient")
		}
	}
	
	Set interopRequest.Request = apiRequest
	
	Return interopRequest
}

/// @API.Overridable<br>
/// InvokeRequest takes the <class>HS.FHIRServer.Interop.Request</class> object - passed in as pRequest here -
/// sends the request to %TargetConfigName, either via HS.HC.Util.BusinessService or via ..%HostObject. It
/// then returns the <class>HS.FHIRServer.Interop.Response</class> object that was returned.<br>
/// @Input pRequest HS.FHIRServer.Interop.Request.<br>
/// @Input pRequestMethod (not used)<br>
/// @Input pRequestPath (not used)<br>
/// @Input pQueryString (not used)
Method InvokeRequest(pRequest As %RegisteredObject, pRequestMethod As %String, pRequestPath As %String, pQueryString As %String) As %RegisteredObject
{
	// For future reference, if we want to add these as client object properties.
	Set sessionId = ""
	Set timeout = -1
	
	If $IsObject(..%HostObject) {
		$$$ThrowOnError(..%HostObject.SendRequestSync(..%TargetConfigName, pRequest, .response, timeout, ""))
	} Else {
		$$$ThrowOnError(##class(HS.HC.Util.BusinessService).SendSync(..%TargetConfigName, pRequest, .response, timeout, "", .sessionId))
	}
	
	Return response
}

/// @API.Overridable<br>
/// MakeClientResponseFromResponse takes the <class>HS.FHIRServer.Interop.Response</class> response object,
/// creates a <class>HS.FHIRServer.API.Data.RestClient.Response</class> object from it, and returns
/// that object.<br>
/// The content payload of the client response, when present, will always be a stream in the Payload property.<br>
/// @Input pResponse HS.FHIRServer.Interop.Response.
Method MakeClientResponseFromResponse(pResponse As %RegisteredObject) As HS.FHIRServer.API.Data.RestClient.Response
{
	Set clientResponse = ##class(HS.FHIRServer.API.Data.RestClient.Response).%New()
	
	For propName = "Status", "ETag", "Location", "LastModified", "Id", "VId", "IsPrettyOut" {
		Set value = $Property(pResponse.Response, propName)
		If value'="" {
			Set $Property(clientResponse, propName) = value
		}
	}
	
	Set clientResponse.ResponseFormat = pResponse.ContentType
	
	Set quickStreamId = pResponse.QuickStreamId
	If quickStreamId'="" {
		Set quickStream = ##class(HS.SDA3.QuickStream).%OpenId(quickStreamId)
		If ($IsObject(quickStream)) && (quickStream.Size) {
			If '$IsObject(clientResponse.Payload) {
				Set clientResponse.Payload = ##class(%Stream.TmpCharacter).%New()
			}
			$$$ThrowOnError(clientResponse.Payload.CopyFrom(quickStream))
			Do quickStream.Clear()
		}
	}
	
	Return clientResponse
}

/// Return an indicator of whether the specified payload exists and has content,
/// as per the requirements of the current client implementation.
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

}
