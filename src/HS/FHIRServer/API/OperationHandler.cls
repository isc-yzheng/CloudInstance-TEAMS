Include HS.FHIRServer

/// This is a base class for the implementation of FHIR $Operation support.  A programmer
/// May add operations to a FHIR endpoint by subclassing this class and implementing an appropriately
/// named ClassMethod for each supported $Operation.  To add a handler for an $Operation, add a ClassMethod to
/// a subclass of this class with a 3-argument signature:
/// <br>(pService As HS.FHIRServer.API.Service, pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
/// and a specialized method name as follows:
/// <br>The Handler Method Name must be of the form: "FHIR[Scope]Op[OperationName] where [Scope] is:
/// <br>   [Scope] "System" to handle "/$operation" REST requests
/// <br>   [Scope] "Type" to handle "/type/$operation" REST requests
/// <br>   [Scope] "Instance" to handle "/type/id/$operation" REST requests
/// <br>and [OperationName] is the name of the operation specified in the request URL, but with the '$' removed and the first letter capitalized.
/// <br> for example:  The request "/Patient/1234/$everything" will be dispatch to a method named "FHIRInstanceOpEverything"
Class HS.FHIRServer.API.OperationHandler [ Abstract ]
{

/// @API Enumerate the name and url of each Operation supported by this class
ClassMethod AddSupportedOperations(pMap As %DynamicObject)
{
}

/// @API
/// This is the entry point, called from the FHIR Service instance. The default processing
/// will further dispatch the request to a ClassMethod in this class to process the requested
/// $Operation (see class documentation for details)
/// <br> Note, This method may be overridden if the programmer would rather not use the provided
/// dispatch mechanism.
ClassMethod ProcessOperation(pService As HS.FHIRServer.API.Service, pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
{
	Set operationName = pRequest.OperationName
	Set operationScope = pRequest.OperationScope
	
	$$$FSLog("Name: "_operationName_", scope: "_operationScope)
	// The processing methodName must begin with "FHIR<Scope>Op".  This avoids injection attacks where the operation
	// name could be used to attempt to execute an arbitrary method.  It also ensures that the operation is requested in the
	// appropriate scope (System, Type, or Instance)
	//  We also normalize the name by removing dashes and capitalizing the character following a dash
	Set rawName = "FHIR" _ operationScope _ "Op-" _ operationName
	Set tMethod = ##class(HS.FHIRServer.Util.FHIRQueryUtils).NormalizeParamName(rawName)
	// Find the Handler Class
	Set compMethod = ##class(%Dictionary.CompiledMethod).%OpenId($classname() _ "||" _ tMethod)
	if compMethod = "" {
		$$$ThrowFHIR($$$HSFHIRErrOperationNotSupported, operationName, operationScope, $$$OutcomeNotSupported(400))
	}
	kill compMethod
	$$$FSLog("Dispatching to method: "_tMethod)
	Do $ClassMethod($classname(), tMethod, pService, pRequest, .pResponse)
	Return $$$OK
}

}
