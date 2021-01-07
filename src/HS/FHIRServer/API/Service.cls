Include HS.FHIRServer

Class HS.FHIRServer.API.Service Extends %ZHSLIB.Context.NamedInstanceBase
{

/// The Configuration Data controlling this service
Property ConfigData As HS.FHIRServer.API.ConfigData [ Calculated ];

/// The 'schema' node of the SchemaMetadata
Property Schema As HS.FHIRServer.Schema [ Calculated ];

/// The 'interactions' implementation for the service.
Property interactions As HS.FHIRServer.API.Interactions [ Calculated ];

/// The 'StorageStrategy' implementation for the service.
Property strategy As HS.FHIRServer.API.InteractionsStrategy [ Calculated ];

/// Override to accept either a CSP endpoint path or an instance id as input here
ClassMethod EnsureInstance(pKey As %String) As %ZHSLIB.Context.NamedInstanceBase
{
	Set serviceInstanceId = pKey
	if $E(pKey,1) = "/" {
		// This is a csp path, convert it into a service instance Id
		Set serviceInstanceId = ##class(HS.FHIRServer.ServiceAdmin).GetInstanceIdForEndpoint(pKey)
	}
	return ##super(serviceInstanceId)
}

/// @API.Overrideable
/// Factory Method to return an instance of an implementation of this service
ClassMethod CreateInstance(pKey As %String) As HS.FHIRServer.API.Service
{
	
	$$$FSLog("Creating FHIR Service Instance #"_pKey_" in Job "_$Job)
	Set fhirService = ..%New(pKey)
	Set serviceInstance = ##class(HS.FHIRServer.ServiceInstance).GetById(pKey)
	Do fhirService.Configure(serviceInstance)
	return fhirService
}

/// @API
/// This is the primary dispatch for FHIR requests.  The method does not throw and does not return a status.
/// @Input pRequest The request message being processed.  The key fields are Json, Type, Id, Vid, and Compartment which are derived
/// from the REST request.
/// @Output pResponse An object containing the result of the FHIR processing.  The key fields are: Json and Status which indicate whether
/// the request was successful, and provides Json for the FHIR resource response.  On an error, the Json will most likely be an
/// OperationOutcome resource.
Method DispatchRequest(pRequest As HS.FHIRServer.API.Data.Request, Output pResponse As HS.FHIRServer.API.Data.Response) [ Abstract ]
{
}

/// @API
/// StreamToJSON is a helper method intended for use by callers of the service
/// to convert an input stream to a JSON object.  The conversion is performed in accordance with
/// the FHIRVersion supported by the service instance.
/// @Input pStream The data stream to be converted.  It may be in XML or JSON format (as specified by pContentCode)
/// from the REST request.
/// @Input pContentCode The content code that describes the format of the input stream. Possible values are the macros:<br>
/// $$$FHIRContentCodeJSON and $$$FHIRContentCodeXML.
/// @Return A %DynamicObject (JSON) representation of the FHIR resource in the input stream.  This method is used by invokers of the
/// FHIRService (such as a RESTHandler or Ensemble Operation) which use this method to create Json field of the request from an input
/// Stream.
Method StreamToJSON(pStream As %Stream.Object, pContentCode As %String) As %DynamicObject [ Abstract ]
{
}

}
