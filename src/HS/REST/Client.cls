Include HS.HC

/// Defines a REST client.
/// @API.Extensible
Class HS.REST.Client Extends %RegisteredObject [ Abstract ]
{

Parameter CONTENTTYPETEXT = "text/plain";

Parameter CONTENTTYPEJSON = "application/json";

Parameter CHARSETJSON = "utf-8";

/// Name of an SSL Configuration to use for https requests.
Parameter SSLConfigName As STRING;

/// Description of SSL Configuration
Parameter SSLConfigDescription As STRING = "SSL Configuration to use for REST Client";

Property SessionCookie As %String [ Private ];

/// Name of class to be used to create requests for the client to send.
/// The class MUST be a subclass of <class>%Net.HttpRequest</class>.
Property RequestClass As %Dictionary.Classname [ InitialExpression = "%Net.HttpRequest", Private ];

/// Any subclasses that override this method must call ##super(). <br />
/// @Argument	pRequestClass		Request class name to use for the REST client.
Method %OnNew(pRequestClass As %String = "") As %Status [ Private, ServerOnly = 1 ]
{
	If (pRequestClass '= "") {
		If $ClassMethod(pRequestClass, "%Extends", "%Net.HttpRequest") {
			Set ..RequestClass = pRequestClass
		} Else {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Request class must be a subclass of %Net.HttpRequest"))
		}
	}
	Quit $$$OK
}

/// Method to generate installer classes for subclasses.
/// Any module that contains a subclass of this class, must either use this installer class or
/// create its own and call <method>CreateSSLConfig</method> in the installer class's method
/// <method>OnInstallComponent</method>
ClassMethod GenerateInstallerClass() [ CodeMode = objectgenerator, ForceGenerate ]
{
	If %class.Abstract {
		Quit $$$OK
	}
	// Create class
	Set tClassname = %class.Name
	Set tInstallerClassname = $Piece(tClassname, ".", 1, *-1) _ ".Installer"
	Set tClassDefinition = ##class(%Dictionary.ClassDefinition).%New(tInstallerClassname)
	Set tClassDefinition.Super = "%ZHSLIB.AbstractInstaller"
	
	// Create parameter
	Set tParameter = ##class(%Dictionary.ParameterDefinition).%New()
	Set tParameter.Name = "Version"
	Do tClassDefinition.Parameters.Insert(tParameter)
	
	// Create method OnInstallComponent
	Set tMethodDefinition = ##class(%Dictionary.MethodDefinition).%New()
	Set tMethodDefinition.Name = "OnInstallComponent"
	Set tMethodDefinition.ClassMethod = 1
	Set tFormalSpec = $ListBuild("pDatabase:%String", "pVerbose:%Boolean=0", "pDevMode:%Boolean=0", "pIsUpgrade:%Boolean=0")
	Set tMethodDefinition.FormalSpec = $ListToString(tFormalSpec, ",")
	Set tMethodDefinition.ReturnType = "%Status"
	// Implementation of method
	#define Tab	$Char(9)
	#define WriteLine(%line) Do tImplementation.WriteLine($$$Tab_%line)
	Set tImplementation = ##class(%Stream.TmpCharacter).%New()
	$$$WriteLine("Set tSC = $$$OK")
	$$$WriteLine("Try {")
	$$$WriteLine("	Do ##class("_tClassname_").CreateSSLConfig()")
	$$$WriteLine("} Catch ex {")
	$$$WriteLine("	Set tSC = ex.AsStatus()")
	$$$WriteLine("}")
	$$$WriteLine("Quit tSC")
	Set tMethodDefinition.Implementation = tImplementation
	// Insert method into class
	Do tClassDefinition.Methods.Insert(tMethodDefinition)
	
	// Save class
	$$$ThrowOnError(tClassDefinition.%Save())
	
	// Compile class
	$$$ThrowOnError($System.OBJ.Compile(tInstallerClassname, "/compile=1/displaylog=0"))
}

/// Creates an SSL Config to be used for https requests. <br />
ClassMethod CreateSSLConfig() [ Final ]
{
	If ..#SSLConfigName '= "" {
		// Create new SSL Config
		Kill tProps
		Set tProps("Description") = ..#SSLConfigDescription
		Set tSC = ##class(HS.Util.SystemAPI).Invoke("CreateSSLConfig", , ..#SSLConfigName, $$$NVPairToList(tProps))
		$$$ThrowOnError(tSC)
	}
}

/*
 * #### Methods that can be implemented/overrriden in subclasses ####
 */
/// This method can be overriden to provide any authorization logic for when a 401 Unauthorized status code is returned. <br />
/// Returns 1 if the user is authorized, else 0 <br />
/// @API.Overrideable
Method OnUnauthorized() As %Boolean
{
	Quit 0
}

/// Allows customization of headers (etc.) for each request - for example, adding authorization. <br />
/// @API.Overrideable
/// @Argument	pRequest		The HTTP request object to be configured
Method OnBuildRequest(pRequest As %Net.HttpRequest)
{
}

/*
 * #### Standard http request functions that return the request (and response embedded in the request object) ####
 */
/// Does a GET http request as a wrapper around <method>BuildAndSendRequest</method>. <br />
/// @API.Method
/// @Argument	pRequestURL		URL for the request. <br />
/// @Argument	pQuery			Optional subscripted array with key-value pairs corresponding to URL parameter key-value pairs (i.e. parameters after ? in the URL). <br />
/// @Argument	pHeaders		Optional subscripted array with key-value pairs corresponding to headers of the request (e.g. ContentType, Authorization, etc.)
Method Get(pRequestURL As %String, ByRef pQuery, ByRef pHeaders) As %Net.HttpRequest [ Final ]
{
	Quit ..BuildAndSendRequest("GET", pRequestURL, .pQuery, .pHeaders)
}

/// Does a PUT http request as a wrapper around <method>BuildAndSendRequest</method>. <br />
/// @API.Method
/// @Argument	pRequestURL		URL for the request. <br />
/// @Argument	pQuery			Optional subscripted array with key-value pairs corresponding to URL parameter key-value pairs (i.e. parameters after ? in the URL). <br />
/// @Argument	pHeaders		Optional subscripted array with key-value pairs corresponding to headers of the request (e.g. ContentType, Authorization, etc.)
/// @Argument	pFormData		Optional form data as a subscripted array of key-value pairs for the body of the request. <br />	
/// @Argument	pRawData		Optional raw data as a <class>%String</class> for the body of the request. <br />
Method Put(pRequestURL As %String, ByRef pQuery, ByRef pHeaders, ByRef pFormData, ByRef pRawData As %String) As %Net.HttpRequest [ Final ]
{
	Quit ..BuildAndSendRequest("PUT", pRequestURL, .pQuery, .pHeaders, .pFormData, .pRawData)
}

/// Does a POST http request as a wrapper around <method>BuildAndSendRequest</method>. <br />
/// @API.Method
/// @Argument	pRequestURL		URL for the request. <br />
/// @Argument	pQuery			Optional subscripted array with key-value pairs corresponding to URL parameter key-value pairs (i.e. parameters after ? in the URL). <br />
/// @Argument	pHeaders		Optional subscripted array with key-value pairs corresponding to headers of the request (e.g. ContentType, Authorization, etc.)
/// @Argument	pFormData		Optional form data as a subscripted array of key-value pairs for the body of the request. <br />	
/// @Argument	pRawData		Optional raw data as a <class>%String</class> for the body of the request. <br />
Method Post(pRequestURL As %String, ByRef pQuery, ByRef pHeaders, ByRef pFormData, ByRef pRawData As %String) As %Net.HttpRequest [ Final ]
{
	Quit ..BuildAndSendRequest("POST", pRequestURL, .pQuery, .pHeaders, .pFormData, .pRawData)
}

/// Does a DELETE http request as a wrapper around <method>BuildAndSendRequest</method>. <br />
/// @API.Method
/// @Argument	pRequestURL		URL for the request. <br />
/// @Argument	pQuery			Optional subscripted array with key-value pairs corresponding to URL parameter key-value pairs (i.e. parameters after ? in the URL). <br />
/// @Argument	pHeaders		Optional subscripted array with key-value pairs corresponding to headers of the request (e.g. ContentType, Authorization, etc.)
/// @Argument	pFormData		Optional form data as a subscripted array of key-value pairs for the body of the request. <br />	
/// @Argument	pRawData		Optional raw data as a <class>%String</class> for the body of the request. <br />
Method Delete(pRequestURL As %String, ByRef pQuery, ByRef pHeaders, ByRef pFormData, ByRef pRawData As %String) As %Net.HttpRequest [ Final ]
{
	Quit ..BuildAndSendRequest("DELETE", pRequestURL, .pQuery, .pHeaders, .pFormData, .pRawData)
}

/*
 * #### Standard http request functions that return the body of the http response as a JSON object ####
 */
/// Does a GET http request as a wrapper around <method>BuildAndSendJSONRequest</method>. <br />
/// @API.Method
/// @Argument	pRequestURL		URL for the request. <br />
/// @Argument	pQuery			Optional subscripted array with key-value pairs corresponding to URL parameter key-value pairs (i.e. parameters after ? in the URL). <br />
/// @Argument	pHeaders		Optional subscripted array with key-value pairs corresponding to headers of the request (e.g. ContentType, Authorization, etc.)
Method GetJSON(pRequestURL As %String, ByRef pQuery, ByRef pHeaders) As %DynamicAbstractObject [ Final ]
{
	Quit ..BuildAndSendJSONRequest("GET", pRequestURL, .pQuery, .pHeaders)
}

/// Does a PUT http request as a wrapper around <method>BuildAndSendJSONRequest</method>. <br />
/// @API.Method
/// @Argument	pRequestURL		URL for the request. <br />
/// @Argument	pQuery			Optional subscripted array with key-value pairs corresponding to URL parameter key-value pairs (i.e. parameters after ? in the URL). <br />
/// @Argument	pHeaders		Optional subscripted array with key-value pairs corresponding to headers of the request (e.g. ContentType, Authorization, etc.)
/// @Argument	pFormData		Optional form data as a subscripted array of key-value pairs for the body of the request. <br />	
/// @Argument	pRawData		Optional raw data as a <class>%String</class> or <class>%DynamicAbstractObject</class> for the body of the request. <br />
Method PutJSON(pRequestURL As %String, ByRef pQuery, ByRef pHeaders, ByRef pFormData, ByRef pRawData) As %DynamicAbstractObject [ Final ]
{
	Quit ..BuildAndSendJSONRequest("PUT", pRequestURL, .pQuery, .pHeaders, .pFormData, .pRawData)
}

/// Does a POST http request as a wrapper around <method>BuildAndSendJSONRequest</method>. <br />
/// @API.Method
/// @Argument	pRequestURL		URL for the request. <br />
/// @Argument	pQuery			Optional subscripted array with key-value pairs corresponding to URL parameter key-value pairs (i.e. parameters after ? in the URL). <br />
/// @Argument	pHeaders		Optional subscripted array with key-value pairs corresponding to headers of the request (e.g. ContentType, Authorization, etc.)
/// @Argument	pFormData		Optional form data as a subscripted array of key-value pairs for the body of the request. <br />	
/// @Argument	pRawData		Optional raw data as a <class>%String</class> or <class>%DynamicAbstractObject</class> for the body of the request. <br />
Method PostJSON(pRequestURL As %String, ByRef pQuery, ByRef pHeaders, ByRef pFormData, ByRef pRawData) As %DynamicAbstractObject [ Final ]
{
	Quit ..BuildAndSendJSONRequest("POST", pRequestURL, .pQuery, .pHeaders, .pFormData, .pRawData)
}

/// Does a DELETE http request as a wrapper around <method>BuildAndSendJSONRequest</method>. <br />
/// @API.Method
/// @Argument	pRequestURL		URL for the request. <br />
/// @Argument	pQuery			Optional subscripted array with key-value pairs corresponding to URL parameter key-value pairs (i.e. parameters after ? in the URL). <br />
/// @Argument	pHeaders		Optional subscripted array with key-value pairs corresponding to headers of the request (e.g. ContentType, Authorization, etc.)
/// @Argument	pFormData		Optional form data as a subscripted array of key-value pairs for the body of the request. <br />	
/// @Argument	pRawData		Optional raw data as a <class>%String</class> or <class>%DynamicAbstractObject</class> for the body of the request. <br />
Method DeleteJSON(pRequestURL As %String, ByRef pQuery, ByRef pHeaders, ByRef pFormData, ByRef pRawData) As %DynamicAbstractObject [ Final ]
{
	Quit ..BuildAndSendJSONRequest("DELETE", pRequestURL, .pQuery, .pHeaders, .pFormData, .pRawData)
}

/*
 * #### Generic http request preparation functions. API method wrappers to be created using these. ####
 */

// #### Build and Send composite functions ####

/// Builds and sends an http request of type <var>pMethod</var> to URL <var>pRequestURL</var> with optional 
/// URL parameters in <var>pQuery</var>, optional headers in <var>pHeaders</var> and optional body content 
/// in <var>pFormData</var> and <var>pRawData</var>. <br />
/// Returns the http request that was built, with the resulting http response embedded in it. <br />
/// @Argument	pMethod			Type of the request (e.g. GET, PUT, etc.). <br />
/// @Argument	pRequestURL		URL for the request. <br />
/// @Argument	pQuery			Optional subscripted array with key-value pairs corresponding to URL parameter key-value pairs (i.e. parameters after ? in the URL). <br />
/// @Argument	pHeaders		Optional subscripted array with key-value pairs corresponding to headers of the request (e.g. ContentType, Authorization, etc.)
/// @Argument	pFormData		Optional form data as a subscripted array of key-value pairs for the body of the request. <br />	
/// @Argument	pRawData		Optional raw data as a <class>%String</class> for the body of the request. <br />
Method BuildAndSendRequest(pMethod As %String, pRequestURL As %String, ByRef pQuery, ByRef pHeaders, ByRef pFormData, ByRef pRawData As %String) As %Net.HttpRequest [ Final ]
{
	#dim tHttpRequest As %Net.HttpRequest = ..BuildRequest(.pQuery, .pHeaders)
	Do ..SendRequest(tHttpRequest, pMethod, pRequestURL, .pFormData, .pRawData)
	// If unauthorized then call OnUnauthorised, which can be implemented to do additional credential checking
	// If login is successful with credentials then build and send the request again
	If tHttpRequest.HttpResponse.StatusCode = 401 && ..OnUnauthorized() {
		Set tHttpRequest = ..BuildRequest(.pQuery, .pHeaders)
		Do ..SendRequest(tHttpRequest, pMethod, pRequestURL, .pFormData, .pRawData)
	}
	Quit tHttpRequest
}

/// Builds and sends an http request of type <var>pMethod</var> to URL <var>pRequestURL</var> with optional 
/// URL parameters in <var>pQuery</var>, optional headers in <var>pHeaders</var> and optional body content 
/// in <var>pFormData</var> and <var>pRawData</var>. <br />
/// Returns the body of the http response as a <class>%DynamicAbstractObject</class> object. <br />
/// @Argument	pMethod			Type of the request (e.g. GET, PUT, etc.). <br />
/// @Argument	pRequestURL		URL for the request. <br />
/// @Argument	pQuery			Optional subscripted array with key-value pairs corresponding to URL parameter key-value pairs (i.e. parameters after ? in the URL). <br />
/// @Argument	pHeaders		Optional subscripted array with key-value pairs corresponding to headers of the request (e.g. ContentType, Authorization, etc.)
/// @Argument	pFormData		Optional form data as a subscripted array of key-value pairs for the body of the request. <br />	
/// @Argument	pRawData		Optional raw data as a <class>%String</class> or <class>%DynamicAbstractObject</class> for the body of the request. <br />
Method BuildAndSendJSONRequest(pMethod As %String, pRequestURL As %String, ByRef pQuery, ByRef pHeaders, ByRef pFormData, ByRef pRawData) As %DynamicAbstractObject [ Final ]
{
	#dim tHttpRequest As %Net.HttpRequest = ..BuildRequest(.pQuery, .pHeaders)
	Set tJson = ..SendJSONRequest(tHttpRequest, pMethod, pRequestURL, .pFormData, .pRawData)
	// If unauthorized then call OnUnauthorised, which can be implemented to do additional credential checking
	// If login is successful with credentials then build and send the request again
	If tHttpRequest.HttpResponse.StatusCode = 401 && ..OnUnauthorized() {
		Set tHttpRequest = ..BuildRequest(.pQuery, .pHeaders)
		Set tJson = ..SendJSONRequest(tHttpRequest, pMethod, pRequestURL, .pFormData, .pRawData)
	}
	Quit tJson
}

/*
 * #### Internal functions only to be used in this class ####
 */

// #### Only Build functions ####

/// Builds an http request, setting URL parameters using <var>pQuery</var> and headers using <var>pHeaders</var>. <br />
/// Returns the http request object built using <var>pQuery</var> and <var>pHeaders</var>. <br />
/// @Argument	pQuery		Optional subscripted array with key-value pairs corresponding to URL parameter key-value pairs (i.e. parameters after ? in the URL). <br />
/// @Argument	pHeaders	Optional subscripted array with key-value pairs corresponding to headers of the request (e.g. ContentType, Authorization, etc.)
Method BuildRequest(ByRef pQuery, ByRef pHeaders) As %Net.HttpRequest [ Final, Internal ]
{
	#dim tHttpRequest As %Net.HttpRequest = $ClassMethod(..RequestClass, "%New")
	// Set cookie, if present
	If ..SessionCookie '= "" {
		Do tHttpRequest.SetHeader("Cookie", ..SessionCookie)
	}
	// Set query parameters
	Set tKey = ""
	While 1 {
		Set tKey = $Order(pQuery(tKey), 1, tValue)
		Quit:(tKey = "")
		Do tHttpRequest.SetParam(tKey, tValue)	
	}
	// Set header values
	Set tKey = ""
	While 1 {
		Set tKey = $Order(pHeaders(tKey), 1, tValue)
		Quit:(tKey = "")
		Do tHttpRequest.SetHeader(tKey, tValue)	
	}
	Do ..OnBuildRequest(tHttpRequest)
	Quit tHttpRequest
}

// #### Only Send functions ####

/// Sends an http request using <var>pHttpRequest</var> of type <var>pMethod</var> to URL <var>pURL</var> 
/// along with an optional body content in <var>pFormData</var> and <var>pRawData</var>. <br />
/// Throws errors. <br />
/// @Argument	pHttpRequest	Http request object to be used to send the request. <br />
/// @Argument	pMethod			Type of the request (e.g. GET, PUT, etc.). <br />
/// @Argument	pURL			URL for the request. <br />
/// @Argument	pFormData		Optional form data as a subscripted array of key-value pairs for the body of the request. <br />	
/// @Argument	pRawData		Optional raw data as a <class>%String</class> for the body of the request. <br />
Method SendRequest(pHttpRequest As %Net.HttpRequest, pMethod As %String, pURL As %String, ByRef pFormData, ByRef pRawData As %String) [ Final, Internal ]
{
	// Prerequisite for GET requests ... no body.
	Set tMethod = $ZConvert(pMethod, "U")
	If (tMethod = "GET") && ($Data(pRawData) || $Data(pFormData)) {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Body contents are not allowed for a GET request"))	
	}
	// Add form data to request
	Set tKey = ""
	While 1 {
		Set tKey = $Order(pFormData(tKey), 1, tValue)
		Quit:(tKey = "")
		Do pHttpRequest.InsertFormData(tKey, tValue)	
	}
	// Add body to request
	If $Data(pRawData)#2 {
		Do pHttpRequest.EntityBody.Write(pRawData)
	}
	// Send the request
	$$$ThrowOnError(pHttpRequest.Send(pMethod, pURL))
	// Set session cookie
	Set ..SessionCookie = pHttpRequest.HttpResponse.GetHeader("Set-Cookie")
}

/// Sends an http request using <var>pHttpRequest</var> of type <var>pMethod</var> to URL <var>pURL</var> 
/// along with an optional body content in <var>pFormData</var> and <var>pRawData</var>. <br />
/// Returns the body of the http response as a <class>%DynamicAbstractObject</class>. <br />
/// Returns a null oref if no body found in the http response. <br />
/// Throws errors. <br />
/// @Argument	pHttpRequest	Http request object to be used to send the request. <br />
/// @Argument	pMethod			Type of the request (e.g. GET, PUT, etc.). <br />
/// @Argument	pURL			URL for the request. <br />
/// @Argument	pFormData		Optional form data as a subscripted array of key-value pairs for the body of the request. <br />	
/// @Argument	pRawData		Optional raw data as a <class>%String</class> or <class>%DynamicAbstractObject</class> for the body of the request. <br />
Method SendJSONRequest(pHttpRequest As %Net.HttpRequest, pMethod As %String, pURL As %String, ByRef pFormData, ByRef pRawData) As %DynamicAbstractObject [ Final, Internal ]
{
	#dim tHttpResponse As %Net.HttpResponse
	// Create raw data as string if provided
	If $Data(pRawData)#2 {
		If $IsObject(pRawData) {
			If pRawData.%IsA("%DynamicAbstractObject") {
				Set tBodyString = pRawData.%ToJSON()
				set pHttpRequest.ContentType = ..#CONTENTTYPEJSON
				set pHttpRequest.ContentCharset = ..#CHARSETJSON
			} Else {
				$$$ThrowStatus($$$ERROR($$$GeneralError, "Unsupported type for raw data: "_$Classname(pRawData)))
			}
			// Accept JSON in the response
			Do pHttpRequest.SetHeader("Accept", ..#CONTENTTYPEJSON)
		} Else {
			Set tBodyString = pRawData
		}
	}
	// Send the Request
	Do ..SendRequest(pHttpRequest, pMethod, pURL, .pFormData, .tBodyString)
	Set tHttpResponse = pHttpRequest.HttpResponse
	Set tHttpResponseStatus = tHttpResponse.StatusCode
	// Handle unauthorized seperately 
	If tHttpResponseStatus = 401 {
		Quit ""
	}
	// Handle error codes
	If tHttpResponseStatus > 299 {
		Do ..ThrowResponseError(tHttpResponse, pMethod, pURL)
	}
	// Handle the response for a JSON request
	Set tJson = $$$NULLOREF
	If tHttpResponseStatus '= 204 {
		If tHttpResponse.Data '= "" {
			Set tJson = ##class(%DynamicObject).%FromJSON(pHttpRequest.HttpResponse.Data)
		}
	}
	Quit tJson
}

/// Throws the error in <var>pHttpResponse</var> where the request was of type <var>pMethod</var> to url <var>pURL</var> <br />
/// Throws a status exception built from the data in <var>pHttpResponse</var> and <var>pMessage</var> <br />
/// @Argument	pHttpResponse			The http request object to be used to sent request
/// @Argument	pMethod					The type of the request (e.g. GET, PUT, etc.)
/// @Argument	pURL					The URL for the request
/// @Argument	pMessage				Optional error message 
ClassMethod ThrowResponseError(pHttpResponse As %Net.HttpResponse, pMethod As %String, pURL As %String, pMessage As %String = "") [ Final, Internal ]
{
	Set tPayload = ""
	If $IsObject(pHttpResponse.Data) {
		Set tPayload = ##class(HS.Util.StreamUtils).EnsureString(pHttpResponse.Data)
	}
	Set tDescription = $Select((pMessage '= ""): pMessage, 1: pHttpResponse.ReasonPhrase)
	Set tError =  "Http Error Response ["_pHttpResponse.StatusCode_"]: ("_tDescription_") for "_pMethod_" on "_pURL_$Select((tPayload '= ""): $Char(13,10)_tPayload, 1: "")
	$$$ThrowStatus($$$ERROR($$$GeneralError, tError))
}

}
