Include (Ensemble, HSMOD.REST)

/// 
/// Base class for REST APIs in applications and modules
/// @API.Extensible
/// @Modifier Availability InterSystems
Class HSMOD.REST.Base Extends %CSP.REST
{

/// Domain used for localization.
Parameter DOMAIN = "HSMOD";

Parameter CONVERTINPUTSTREAM = 1;

Parameter CHARSET = "UTF-8";

Parameter CONTENTTYPEJSON As %String = "application/json";

Parameter CONTENTTYPETEXT As %String = "text/plain";

Parameter HTTPAUTHENTICATIONMECHANISM As %String = "None";

/// Enable CSP Sessions for REST
Parameter UseSession As %Integer = 1;

/// This parameter influences the CORS support. The default is an empty string meaning 'not specified'.
/// If set to true (1) then CORS processing is ON. If set to false (0) then CORS processing is OFF.
/// If left unset "" then the decision to process CORS is delegated to the setting on the URL map route.
Parameter HandleCorsRequest As %Integer = 1;

Parameter REQUESTGROUP As %String;

Parameter JSONFORMATFLAGS = "2aelnos";

Parameter CSRFTOKEN = "X-CSRF-TOKEN";

/// override this parameter to provide a default value for the argument "pAPIClassName" in <method>SimpleRESTRequestResponse</method>
Parameter SIMPLEAPICLASSNAME;

/// Internal projection for handling validation of subclasses. <br />
Projection Validation As HSMOD.REST.BaseProjection [ Internal ];

XData StatusCodesInfo
{
<root>
	<!-- 
	A note on the use of status codes & HTTP status codes. %CSP.REST has a variety of common HTTP status codes 
	defined as class parameters. The HSMOD.REST module has a localized error list with names like HTTPStatus200OK. These 
	are NOT HTTP status values, they're localized error codes with %1 arguments, suitable for constructing %Status values. 
	They should not be used to populate %response.Status; that should be done using the class parameter strings. 
	
	However, HSMOD.REST.inc has a variety of macros for converting between the two worlds. 
	-->
	</root>
}

/// Given a <class>%Library.Status</class> value (the argument <var>pStatus</var>), this method looks through its contents to see whether are HTTP 500 internal 
/// server error messages. If it finds one, it returns that error string; otherwise, the output 
/// argument will be empty (undefined). 
ClassMethod ExtractServerError(pTestStatus As %Status, Output pServerErrorContent As %String) As %Status
{
	// some other methods in this class have special output behavior for server errors, although this seems a bit too specific. 
	// Regardless, the current method allows us to extract them from the regular %Status object rather than having the module 
	// API return the server error message in special output arguments. 
	set tRetVal = $$$OK
	
	try {
		kill pServerErrorContent
		do $system.Status.DecomposeStatus(pTestStatus,.errlist)
		
		set tErrorLoop = ""
		while 1 {
			set tErrorLoop = $o(errlist(tErrorLoop))
			if tErrorLoop = "" quit
			
			if $find(errlist(tErrorLoop), $$$HTTPStatus500InternalServerError) > 0 {
				set pServerErrorContent = errlist(tErrorLoop)
				quit
			}		
		}
	}
	catch tException {
		set tRetVal = tException.AsStatus()
	}
	
	quit tRetVal
}

/// given a <class>%Library.Status</class> value (the argument <var>pStatusToExamine</var>, 
/// this method calls <method>ExtractServerError</method> to see whether it contains 
/// any HTTP 500 internal server errors. If it finds one, it extracts that value and serializes it into 
/// the current HTTP response as JSON content. It also outputs a boolean flag value to indicate whether 
/// such an error was found. 
ClassMethod OutputServerErrorToJSON(pStatusToExamine As %Status, Output pServerErrorFound As %Boolean) As %Status
{
	set tRetVal = $$$OK
	set pServerErrorFound = 0
	try {
		set tExtractionStatus = ..ExtractServerError(pStatusToExamine, .tRegistryError)
		if (tExtractionStatus = $$$OK) && (tRegistryError '= "") {	
			set pServerErrorFound = 1
			set tReturnData = ##class(%ZEN.proxyObject).%New()
			set tReturnData.summary = tRegistryError
			set tSC = tReturnData.%ToJSON(,..#JSONFORMATFLAGS)
			$$$ThrowOnError(tSC)
		}
	}
	catch tAnyException {
		set tRetVal = tAnyException.AsStatus()
	}
	
	quit tRetVal
}

/// Verify the current user has at least one of the specified permissions. Returns OK if true, otherwise an error status code naming
/// the reason the permissions were needed and the current user identity (given by $Username). The <var>pPermissions</var> argument 
/// is assumed to be a $list of expressions of the form $lb(a,b) where "a" is the resource and "b" is the 
/// required permission. For example: $lb($lb("%HS_UserAdmin_Resource_Users","W"),$lb("%HS_Module2_Resource_Whatever","W")), 
ClassMethod checkPermissions(pPermissions As %List, pReasonText As %String) As %Status
{
	for tItemLoop = 1:1:$listlength(pPermissions) 
	{ 
		set tItem = $listget(pPermissions, tItemLoop)		
		set tResource   = $listget(tItem,1)
		set tAccessReqd = $listget(tItem,2)
		if $system.Security.Check(tResource,tAccessReqd) {
			// If we have access, we're done and OK
			return $$$OK
		}
	}
	// If we get here, then there were no permissions available
	quit $$$ERROR($$$HTTPStatus403Forbidden,$Username_" "_pReasonText)
}

/// wrapper for <method>checkPermissions</method>, for checking permissions for the current user against a single 
/// resource and permission string (e.g. "W"). For multiple resources, use checkPermissions. 
ClassMethod CheckSinglePermission(pResource As %String, pPermission As %String, pReasonText As %String) As %Status
{
	quit ..checkPermissions($lb($lb(pResource, pPermission)), pReasonText)
}

/// Convenience method for implementing _ping type routes
/// Returns: 200 OK; Payload is the text "pong"
ClassMethod %Ping() As %Status
{
	#dim tSC As %Status = $$$OK
	try {
		#dim %response As %CSP.Response
		set %response.ContentType = "text/plain"
		write "pong",!
	} 
	catch (tException) {
		set tSC = tException.AsStatus()
	}
    quit tSC
}

/// Convenience method for implementing _version
/// Returns: 200 OK; Payload is the Ensemble system version
ClassMethod %Version() As %Status
{
	#dim tSC As %Status = $$$OK
	try {
		#dim %response As %CSP.Response
		set %response.ContentType = "text/plain"
		write $ZV,!
	} 
	catch (tException) {
		set tSC = tException.AsStatus()
	}
    quit tSC
}

/// Convenience method for determining the current login
/// Returns: 200 OK; Payload is the identity username
ClassMethod %Identity() As %Status
{
	#dim tSC As %Status = $$$OK
	try {
		#dim %response As %CSP.Response
		set %response.ContentType = "text/plain"
		// We use Cache' security (or some variant of) so $Username should be set
		write $Username,!
	} 
	catch (tException) {
		set tSC = tException.AsStatus()
	}
    quit tSC
}

/// Convenience method for determining the current namespace
/// Returns: 200 OK; Payload is the namespace
ClassMethod %Namespace() As %Status
{
	#dim tSC As %Status = $$$OK
	try {
		#dim %response As %CSP.Response
		set %response.ContentType = "text/plain"
		write $Namespace,!
	} catch (tException) {
		set tSC = tException.AsStatus()
	}
    quit tSC
}

/// validates session cookie; returns $$$OK or a 401 error 
ClassMethod VerifySession() As %Status
{
	set tSC = $$$OK
	
	try {
		set tSessionToken = %session.Data(..#CSRFTOKEN)
		if tSessionToken = "" {
			$$$ThrowStatus($$$ERROR($$$HTTPStatus401Unauthorized,"No valid CSRF token found in session data"))
		}
		
		set tHeader = $get(%request.CgiEnvs("HTTP_" _ ..#CSRFTOKEN))
		if tHeader = "" {
			$$$ThrowStatus($$$ERROR($$$HTTPStatus401Unauthorized,"No CSRF token specified in request headers"))
		}
			
		if tHeader '= tSessionToken {
			$$$ThrowStatus($$$ERROR($$$HTTPStatus401Unauthorized,"Invalid session"))
			// if this error comes up during login requests, your application needs to 
			// adjust its config data in HSMOD.REST.ApplicationConfig, or else override ManageSessionVerification()
			// or OnPreDispatch() for whatever your logic should be. To turn off the feature 
			// completely, override OnPreDispatch() to return $$$OK or otherwise dispense with 
			// the checking. 
		}
	}
	catch tException {
		set tSC = tException.AsStatus()
	}
	
	quit tSC
}

/// generates a guid and places it in the session data. 
ClassMethod GenerateCsrfSessionToken() As %Status
{
	if %session.Data(..#CSRFTOKEN) '= "" {
		// should we just overwrite instead? 
		quit $$$ERROR($$$HTTPStatus400BadRequest, "Attempt to create double validation information")
	}
	
	set tSessionToken = $system.Encryption.GenCryptRand(20) // $system.Util.CreateGUID()
	set %session.Data(..#CSRFTOKEN) = tSessionToken
	
	/* now place it into a cookie; not specifying expiration, path, domain, "secure" or httpOnlyFlag. 
	Path & domain are implicitly defined via the CSP application. The "secure" value is implicitly 
	specified by the transport mechanism of the incoming request. The default value for httpOnlyFlag is false (0), 
	which we want because the UI is expected to read this value and send it back to us in headers. 
	The token should be valid for this session as long as the session is active, so we don't specify 
	an expiration time. If the session is ended then a UI sending the token would be harmless because it 
	won't be matched to any existing sessions. 
	*/
	do %response.SetCookie(..#CSRFTOKEN, tSessionToken)
	
	quit $$$OK
}

/// may be overridden by subclasses. This method is called by <method>OnPreDispatch</method> and must decide 
/// whether to call <method>VerifySession</method>, <method>GenerateVisibleSessionToken</method> or neither (if no 
/// verification is being enforced). The default behavior is to check <class>HSMOD.REST.ApplicationConfig</class> 
/// for configuration information; if configuration info is found then we generate a session token in login 
/// cases and verify it otherwise. If no configuration info is found then nothing is enforced and this method 
/// quits. We do not use the <var>pUrl</var> argument (we use the request contents instead) but we pass it in 
/// case overrides want it. <var>pMethod</var> is used for matching the login config cases. 
ClassMethod ManageSessionVerification(pRESTPath As %String, pHTTPMethod As %String, pRequest As %CSP.Request) As %Status
{
	// pUrl should be (urlprefix _ application _ path), where the (path) consists of a page prefix & path
	// but we ignore pUrl and use the request URL instead
	
	set tUrl = pRequest.URL
	set tPrefix = pRequest.URLPrefix
	set tApp = pRequest.Application
	set tSC = $$$OK
	
	#dim tConfigItem as HSMOD.REST.ApplicationConfig
	#dim tPathItem as HSMOD.REST.ConfigPathItem
	if ##class(HSMOD.REST.ApplicationConfig).ApplicationIndexExists(tApp,.tConfigId) {	
		if $extract(tUrl, 1, $length(tPrefix) + $length(tApp)) '= (tPrefix _ tApp) { 
			// note we don't bother this this check if there's no application config data
			quit $$$ERROR($$$HTTPStatus400BadRequest, "unexpected url composition") 
		}
		
		set tConfigItem = ##class(HSMOD.REST.ApplicationConfig).%OpenId(tConfigId, , .tSC)
		// we got tConfigId from an Exists call so we expect to be able to open it, but just in case, we check tSC and skip failures
		if tSC = $$$OK {		
			if tConfigItem.XCSRFTokenChecking = 1 {
				set tMatchFound = 0
				set tPathItemCount = tConfigItem.XCSRFLoginPaths.Count()
				set tPath = $extract(tUrl, $length(tPrefix) + $length(tApp) + 1, *)
				for tItemLoop = 1:1:tPathItemCount {
					set tPathItem = tConfigItem.XCSRFLoginPaths.GetAt(tItemLoop)
					if ((tPathItem.Path = tPath) && (tPathItem.HTTPMethod = pHTTPMethod)) {
						set tSC = ..GenerateCsrfSessionToken()
						set tMatchFound = 1
						quit
					}
				}
				
				if tMatchFound =  0 {
					// none of the configured "login paths" matched; verify!
					set tSC = ..VerifySession()
				}
			}
		}
	}
	
	quit tSC
}

/// called on every URL dispatch request. Default implementation is to call <method>ManageSessionVerification</method>. If 
/// a REST API overrides this method it should also ensure that session verification is addressed. 
ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
	quit ..ManageSessionVerification(pUrl, pMethod, %request)
}

/// 
/// Called for a REST page in the event of a login being required, in the sense that the CSP server failed to 
/// authenticate the user, and we need to notify them that they need to log in. This is really a "post-login-failure" callback. 
/// 
ClassMethod Login(skipheader As %Boolean = 1) As %Status
{
	#; Don't want the session token
	set %response.OutputSessionToken = 0
	#; set the Http Status
	set %response.Status = $$$HTTPStatus("401Unauthorized")
	#; Send the authentication scheme defined in ..#HTTPAUTHENTICATIONMECHANISM, which defaults to "None"
	do %response.SetHeader("WWW-Authenticate",..#HTTPAUTHENTICATIONMECHANISM)
	#; Write out the header
	do %response.WriteHTTPHeader()
	#; Done
	quit $$$OK
}

/// Given a %Status object, assign an appropriate HTTP status into %response.Status.  Also write a JSON representation of status errors to the current output device.
/// If the %Status object contains a $$$HTTPStatus... code, this is used to assign the corresponding HTTP status. Otherwise, certain Ensemble system errors
/// will be assigned a 400,404,502 or 503 status, and all other errors will be assigned a 500 Internal Server Error status.
ClassMethod httpStatusResponse(pSC As %Status) As %Boolean
{
	set tSCDecompose = $system.Status.DecomposeStatus(pSC,.errlist)
	if $$$ISERR(tSCDecompose) {
		set %response.Status = $$$HTTPStatus("500InternalServerError","DecomposeStatus("_pSC_")")
		quit
	}
	set tHTTPStatus = "", tHadErr = 0
	
	// if pSC is $$$OK then errlist is empty and we don't loop. 
	for i = +$get(errlist):-1:1 {  
		set code = $get(errlist(i,"code"))
		if "<HTTPStatus>" = $extract(code,1,$length("<HTTPStatus>")) {
			// just use that code, but trim out whitespace
			set tHTTPStatus = $ZStrip($system.Status.GetOneStatusText(pSC,i),"<>W")
		} else {
			// Decorate %Status code with a reasonably representative HTTP status code.
			set tHadErr = 1
			set tHTTPError = $case(code,
												 // Gateway issues
					$$$EnsErrProductionNotRunning:$$$ERROR($$$HTTPStatus503ServiceUnavailable,": ProductionNotRunning"),
					      $$$EnsErrConfigDisabled:$$$ERROR($$$HTTPStatus503ServiceUnavailable,": ConfigDisabled"),
					  $$$EnsErrConfigItemNotFound:$$$ERROR($$$HTTPStatus502BadGateway,": ConfigItemNotFound"),
	   $$$EnsErrBusinessDispatchNameNotRegistered:$$$ERROR($$$HTTPStatus502BadGateway,": BusinessDispatchNameNotRegistered"),
					  $$$EnsErrTargetNotSpecified:$$$ERROR($$$HTTPStatus502BadGateway,": TargetNotSpecified"),
					   $$$EnsErrRequestNotHandled:$$$ERROR($$$HTTPStatus502BadGateway,": RequestNotHandled"),
					         $$$ClassDoesNotExist:$$$ERROR($$$HTTPStatus502BadGateway,": ClassDoesNotExist"),
					        $$$MethodDoesNotExist:$$$ERROR($$$HTTPStatus502BadGateway,": MethodDoesNotExist"),
					      $$$EnsErrFailureTimeout:$$$ERROR($$$HTTPStatus504GatewayTimeout,": FailureTimeout"),
					      						 // Resource Not Found errors
					        $$$LoadObjectNotFound:$$$ERROR($$$HTTPStatus404NotFound,": LoadObjectNotFound"),
					      $$$DeleteObjectNotFound:$$$ERROR($$$HTTPStatus404NotFound,": DeleteObjectNotFound"),
					      $$$KeyValueNotFoundOpen:$$$ERROR($$$HTTPStatus404NotFound,": KeyValueNotFoundOpen"),
					    $$$KeyValueNotFoundDelete:$$$ERROR($$$HTTPStatus404NotFound,": KeyValueNotFoundDelete"),
					    		   $$$KeyNotFound:$$$ERROR($$$HTTPStatus404NotFound,": KeyNotFound"),
							$$$NotAnInstanceError:$$$ERROR($$$HTTPStatus404NotFound,": NotAnInstance"),
							 $$$QueryDoesNotExist:$$$ERROR($$$HTTPStatus404NotFound,": QueryDoesNotExist"),
					      						 // Validation (e.g. bad request) issues
					      	   $$$InvalidArgument:$$$ERROR($$$HTTPStatus400BadRequest,": InvalidArgument"),
					  $$$DatatypeValidationFailed:$$$ERROR($$$HTTPStatus400BadRequest,": DatatypeValidationFailed"),
					  			   $$$DTValueList:$$$ERROR($$$HTTPStatus400BadRequest,": DTValueList"),
					          $$$PropertyRequired:$$$ERROR($$$HTTPStatus400BadRequest,": PropertyRequired"),
					            $$$IDKeyNotUnique:$$$ERROR($$$HTTPStatus400BadRequest,": IDKeyNotUnique"),
					              $$$KeyNotUnique:$$$ERROR($$$HTTPStatus400BadRequest,": KeyNotUnique"),
				 								 // Authorization
				 		   //$$$HSPDErrAccessDenied:$$$ERROR($$$HTTPStatus403Forbidden),
							              		 // No mapping ...
					                             :$$$OK)
			if $$$ISERR(tHTTPError) { 
				// we found an error status in the sieve; use it. (if not, we will continue looping)
				set tHTTPStatus = $$$HTTPERRStatus(tHTTPError)
			}
		}
		if $length(tHTTPStatus) { 
			quit
		}
	}
	
	// if we found an HTTP status error or a recognizable common error, then tHTTPStatus contains an error DESCRIPTION string. 
	// otherwise it's still "". So we set the response status as follows: 
	// if tHTTPStatus is nonempty, use that. (HTTPStatus or common Ensemble/CSP/Cache problems, but we also want this for module-specific replacements)
	// otherwise, if the loop executed because there was an error of some kind (tHadErr), we clobber it with a 500 internal for the http response, 
	// and we want to stuff a JSON representation of the real error into the output. 
	// Otherwise (no error) we set the response status to 200 OK. 
	 
	set %response.Status = $select((tHTTPStatus'=""):tHTTPStatus
							, tHadErr:$$$HTTPStatus("500InternalServerError")
							, 1:$$$HTTPStatus("200OK"))
	if tHadErr&&$$$ISOK(..StatusToProxyObject(pSC,.tSCDetailObj)) 
	{
		do tSCDetailObj.%ToJSON(,..#JSONFORMATFLAGS)
	}
	quit tHadErr
}

/// <p>Callback method that is called whenever a problem arises in the validation steps 
/// of <method>SimpleRESTRequestResponse</method>. It is passed a (custom) %Status code that indicates 
/// what went wrong, as well as an HTTP response string that seems appropriate. We also pass in the 
/// names of the specified API class and method, to provide context.</p>
/// <p>Return value is a 
/// %Status value that will be used as the return value of <method>SimpleRESTRequestResponse</method>.</p>
/// <p>This method, or its overrides, must return a value for the helper method to use as its return value, 
/// and also populate %response.Status.</p>
/// <p>Default implementation is to:
/// <ol><li>log the %Status argument to the Ensemble event log</li>
/// <li>populate the %status.Response value with the provided HTTP response string value</li>
/// <li>return $$$OK</li></ol>
/// Extensions may override this method to customize behavior, but if the override does not populate %status.Response 
/// it will be populated with "500" (internal server error), and the helper method will return 
/// the validation-generated status error value. </p>
ClassMethod HandleRESTRequestResponseProblem(pAPIClassName As %Dictionary.Classname, pAPIMethodName As %String, pValidationError As %Status, pIntendedHTTPResponse As %String = {..#HTTP500INTERNALSERVERERROR}) As %Status
{
	set %response.Status = pIntendedHTTPResponse
	
	if $$$ISERR(pValidationError) {
		$$$LOGSTATUS(pValidationError)
	}
	else {
		// this case should not happen; we should not call this method without passing an error status
		quit $$$ERROR($$$GeneralError, "Internal error in REST request/response validation")
	}
	
	// default output for SimpleRESTRequestResponse to return 
	quit $$$OK
}

/// simple boilerplate helper method for API methods that have a single JSON request object and return 
/// a single JSON response object from a single worker method somewhere else. This allows REST classes to 
/// implement endpoints with just a wrapper method that calls this method, which handles common validation 
/// and REST handling (JSON read/write, and so on). 
/// <ol><li>
/// pAPIClassName: the name of the class containing the method we should call to do the work. If omitted, we use the 
/// value of <parameter>SIMPLEAPICLASSNAME</parameter> instead. If both are empty, we assume it's the current class name. 
/// </li><li>
/// pAPIMethodName: the name of the method in the "report class" we will call. Assumed to have a signature 
/// consisting solely of the request object and an output argument for the response object, and to return a %Status. 
/// </li><li>
/// pRequestClassName: the name of the class we expect to find in the %request object. If omitted, we validate 
/// the class using the method signature. 
/// </li><li>
/// pResponseClassName: the name of the expected response class. If omitted, we validate the class using the 
/// method signature. 
/// </li><li>
/// pDisableMethodSignatureValidation: if set to 1, this turns off our validation of the method signature. Use at your own risk!
/// </li><li>
/// pHandledValidationError: if a validation error occurred (either with the method signature or with one of the objects), the 
/// relevant status code is returned here in case the caller code wants to interrogate it. Normally this is not necessary, 
/// because we have already logged it and set the %response.Status accordingly, but it is provided here for transparency. Most 
/// REST endpoint methods calling this helper method will not need to examine it, and can omit it from the call. 
/// </li></ol>
/// <p>This method validates that the specified API class method exists and has the expected signature (one request object in, 
/// one request object out). It also validates the request object as an instance of the expected request object type, 
/// and likewise it validates the response object. If a problem is detected in this area, the method returns 
/// a custom internal error code and sets the %response.Status to "400" or "500". Extension classes can also customize the 
/// handling of validation errors by overriding <method>HandleRESTRequestResponseProblem</method>.</p>
/// <p>If an error occurred during the 
/// call to the specified code API method, an error status will be returned and the %response.Status will be 500. </p>
ClassMethod SimpleRESTRequestResponse(pAPIClassName As %Dictionary.Classname = "", pAPIMethodName As %String, pRequestClassName As %Dictionary.Classname = "", pResponseClassName As %Dictionary.Classname = "", pDisableMethodSignatureValidation As %Boolean = 0, Output pHandledValidationError As %Status) As %Status
{
	kill pHandledValidationError
    
	set tSC = $$$OK
	set %response.Status = ..#HTTP200OK
        
    try
    {
	    set tSuggestedHTTPResponse = ..#HTTP400BADREQUEST
        set tSC = ##class(HS.JSON.Reader).%ReadJSON(%request.Content,.tRequest)
        $$$ThrowOnError(tSC)
        
        if pAPIClassName = "" {
	        set pAPIClassName = $select(..#SIMPLEAPICLASSNAME '= "":..#SIMPLEAPICLASSNAME,1:$classname())
        }
        
        if 'pDisableMethodSignatureValidation {
	        set tSuggestedHTTPResponse = ..#HTTP500INTERNALSERVERERROR
	        // this will throw an exception if the specified method has an unexpected signature; validate method doesn't have a return value
	        do ##class(HSMOD.REST.Utils).ValidateAPIMethodSignature(pAPIClassName, pAPIMethodName, .tExpectedRequestClassName, .tExpectedResponseClassName)
	        
	        // validate the request object; if something is wrong, the validate method will throw an exception that we will catch. 
		    set tSuggestedHTTPResponse = ..#HTTP400BADREQUEST
	        do ##class(HSMOD.REST.Utils).ValidateRESTRequestObject(pAPIClassName, pAPIMethodName, tRequest, pRequestClassName, tExpectedRequestClassName)
        }
        
        // call the method. For this we deviate from our "handler" approach to dealing with problems. 
        try 
        {	        
	        set tSC = $classmethod(pAPIClassName, pAPIMethodName, tRequest, .tResponse)
	        $$$ThrowOnError(tSC)
        }
        catch tAPIException {
	        // we want to to pass back the problem as the real return value. Set %response.Status and bail; the outer "catch" will not be involved
	        set %response.Status = ..#HTTP500INTERNALSERVERERROR
	        return tAPIException.AsStatus()
        }
        
        // validate the response object; if something is wrong, the validate method will throw an exception. 
        if 'pDisableMethodSignatureValidation {
	        set tSuggestedHTTPResponse = ..#HTTP500INTERNALSERVERERROR
	        do ##class(HSMOD.REST.Utils).ValidateRESTResponseObject(pAPIClassName, pAPIMethodName, tResponse, pResponseClassName, tExpectedResponseClassName) 
        }
        
        /// output JSON. If it fails, note that the suggested HTTP response is still 500 (internal server error)
        set tSC = ##class(HS.JSON.Writer).%WriteJSON(tResponse)
        $$$ThrowOnError(tSC) 
    }
    catch(tException)
    {
	    set pHandledValidationError = tException.AsStatus()
	    // call the callback. Note that if we pass "" in the second argument, it will default to Internal Server Error. 
	    // The handler is expected to:
	    // -- POPULATE %response.Status (default behavior: uses tSuggestedHTTPResponse)
	    // and to:  
	    // -- RETURN a value for this method to use as its return value. (default: $$$OK, but it will log the exception status we pass in)
	    // 
	    // Also note that the default implementation of the handler method will always return $$$OK as its return value, but 
	    // overrides might want to do something else.
	    try {
	    	set tSC = ..HandleRESTRequestResponseProblem(pAPIClassName, pAPIMethodName, pHandledValidationError, tSuggestedHTTPResponse) 
	    }
	    catch tHandlerException {
		    // if the handler threw an exception then things are really messed up. Wrap it up and return as much info as we can. 
		    set %response.Status = $$$HTTPStatus500InternalServerError
		    return $$$EMBEDSC(tHandlerException.AsStatus(), pHandledValidationError)
	    }
	    
	    // now we check that the callback populated the response status. If it's empty, we populate with 500 because something's gone wrong with the callback. 
	    if %response.Status = "" {
		    set %response.Status = $$$HTTPStatus500InternalServerError
	    }
	    
	    // also check that we got a status in response. We don't actually validate whether it's a valid status expression, just that we got something. 	    
	    if $data(tSC)#2 = 0 {
		    // unpopulated; the handler failed. We return the original value so it doesn't get lost. 
		    set tSC = pHandledValidationError
	    }
    }
    quit tSC
}

}
