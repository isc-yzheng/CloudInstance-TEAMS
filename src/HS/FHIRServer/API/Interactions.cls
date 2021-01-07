Include HS.FHIRServer

Class HS.FHIRServer.API.Interactions Extends %RegisteredObject [ Abstract ]
{

/// @API An object to support OAuth authorization.
/// NOTE: The Implementor of the Interactions subclass must provide a "oauth2TokenHandlerGet" method to provide the handler object
Property oauth2TokenHandler As HS.FHIRServer.API.OAuth2Token [ Calculated ];

/// @API
/// Declares the name of the class that will be invoked to handle a FHIR Operation request.
Parameter OperationHandlerClass As %String = "HS.FHIRServer.API.OperationHandler";

/// @API
/// Declares the name of the class that will be invoked to handle a FHIR batch or transaction request.
Parameter BatchHandlerClass As %String = "HS.FHIRServer.DefaultBundleProcessor";

/// @API
/// Declares the name of the class that will be used to validate FHIR resources.
Parameter ResourceValidatorClass As %String = "HS.FHIRServer.Util.ResourceValidator";

/// @API
/// Declares the name of the class that will handle validation of FHIR interactions against OAuth 2.0 tokens.
Parameter OAuth2TokenHandlerClass As %String = "HS.FHIRServer.API.OAuth2Token";

/// @API Sets the active CapabilityStatement to be used by the service.  This is typically
/// called by an installer when the service is being configured or updated.
/// @Input metadata A Json representation of a CapabilityStatement resource that will be
/// returned on a GET request to "/metadata"
Method SetMetadata(metadata As %DynamicObject) [ Abstract ]
{
}

/// @API Gets the active CapabilityStatement for the service.  
/// @Return A %DynamicObject Json representation of a CapabilityStatement that the service
/// is supporting.
Method LoadMetadata() As %DynamicObject [ Abstract ]
{
}

/// @API Notification that a request in about to be dispatched.  The Interactions object
/// may use this to manage any session information or other bookkeeping.  By default, no processing
/// is performed.
/// @Input pFHIRService  The instance of HS.FHIRServer.Service that invoked this method
/// @Input pFHIRRequest  The request about to be processed
/// @Input pTimeout      The maximum number of sessions between requests that session data remains valid
Method OnBeforeRequest(pFHIRService As HS.FHIRServer.API.Service, pFHIRRequest As HS.FHIRServer.API.Data.Request, pTimeout As %Integer)
{
}

/// @API Notification that a request in about to be dispatched.  The Interactions object
/// may use this to manage any session information or other bookkeeping.  By default, no processing
/// is performed.
/// @Input pFHIRService  The instance of HS.FHIRServer.Service that invoked this method
/// @Input pFHIRRequest  The request about to be processed
/// @Input pFHIRResponse The response about to be returned
Method OnAfterRequest(pFHIRService As HS.FHIRServer.API.Service, pFHIRRequest As HS.FHIRServer.API.Data.Request, pFHIRResponse As HS.FHIRServer.API.Data.Response)
{
}

/// @API Returns a %List of metadata about a specified resource or "" if none.
/// @Input pResourceType The requested ResourceType (required)
/// @Input pResourceId   The requested 'id' property (required)
/// @Input pVersionId    The requested 'meta.versionId' property (optional).  If missing or "", it is
/// a request for the "current" version (the return will provide the actual version number).
/// @Return A %List of 6 properties of the resource, or "" if the resource is not found.  The form of the list is:
///  	$ListBuild(rsrcKey, versionId, isDeleted, isCurrentVersion, lastUpdated, verb)
///  where:
///    rsrcKey:   The unique identifier of the current version in the form <type>/<id>
///    versionId: The version number of the found resource
///    isDeleted: A %Boolean indicating whether this version of the resource is deleted.
///    isCurrentVersion: A %Boolean indicating whether this is the current version of the resource
///    lastModified: The value of the 'meta.lastUpdated' property of the resource
///    verb:         The HTTP Verb used to create or update this resource (PUT, POST, or PATCH)
Method FindResourceMeta(pResourceType As %String, pResourceId As %String, pVersionId As %String = "") As %List [ Abstract ]
{
}

/// @API Returns a %List of metadata about a specified resource or Throws "not found" if none
/// @Input pResourceType The requested ResourceType (required)
/// @Input pResourceId The requested 'id' property (required)
/// @Input pResourceType The requested 'meta.versionId' property (optional).  If missing or "", it is
/// a request for the "current" version (the return will provide the actual version number).
/// @Return A %List of 6 properties of the resource, or "" if the resource is not found.  The form of the list is:
///  	$ListBuild(rsrcKey, versionId, isDeleted, isCurrentVersion, lastUpdated, verb)
///  where:
///    rsrcKey:   The unique identifier of the current version in the form <type>/<id>
///    versionId: The version number of the found resource
///    isDeleted: A %Boolean indicating whether this version of the resource is deleted.
///    isCurrentVersion: A %Boolean indicating whether this is the current version of the resource
///    lastModified: The value of the 'meta.lastUpdated' property of the resource
/// @Throws $$$HSFHIRErrResourceNotFound if current version is not found, or
///         $$$HSFHIRErrResourceVersionNotFound if the requested version is specified and not found
Method GetResourceMeta(pResourceType As %String, pResourceId As %String, pVersionId As %String = "") As %List [ Final ]
{
	Set metaList = ..FindResourceMeta(pResourceType, pResourceId, pVersionId)
	// If the resource doesn't exist (not even deleted), return not-found.
	if (metaList = "") {
		if (pVersionId = "") {
			$$$ThrowFHIR($$$HSFHIRErrResourceNotFound, pResourceType, pResourceId,$$$OutcomeNotFound)
		} else {
			$$$ThrowFHIR($$$HSFHIRErrResourceVersionNotFound, pResourceType , pResourceId , pVersionId, $$$HttpOnlyResponse(404))
		}
	}
	Quit metaList
}

/// @API Returns a %List of version Id's for the specified resource Id.
/// @Input pResourceType The requested ResourceType (required)
/// @Input pResourceId The requested 'id' property (required)
/// @Output pCurrentVersionId The resource version id of the current version, or "" if the current version has been HardDelete'd
/// @Return A %List of version Id's stored for the specified resource type and id. (including the current version).  May be an empty list.
Method GetVersionList(pResourceType As %String, pResourceId As %String, Output pCurrentVersionId) As %List [ Abstract ]
{
}

/// @API Returns the %DynamicObject representing the requested resource.
/// @Input pResourceType The requested ResourceType (required)
/// @Input pResourceId The requested 'id' property (required)
/// @Input pVersionId The requested resource version (optional).  If missing, this is
/// a request for the "current" version
/// @Return A %List of 6 properties of the resource, or "" if the resource is not found.  The form of the list is:
///  	$ListBuild(rsrcKey, versionId, isDeleted, isCurrentVersion, lastUpdated, verb)
///  where:
///    rsrcKey:   The unique identifier of the current version in the form <type>/<id>
///    versionId: The version number of the found resource
///    isDeleted: A %Boolean indicating whether this version of the resource is deleted.
///    isCurrentVersion: A %Boolean indicating whether this is the current version of the resource
///    lastModified: The value of the 'meta.lastUpdated' property of the resource
/// @Throws The implementation must report errors via $$$ThrowStatus.  Common exceptions are
/// $$$HSFHIRErrResourceNotFound and $$$HSFHIRErrResourceVersionNotFound.
/// 
Method Read(pResourceType As %String, pResourceId As %String, pVersionId As %String = "") As %DynamicObject [ Abstract ]
{
}

/// @API
/// A method to evalate the result of a potentially successful read to determine if the read is allowed based
/// on consent or other custom processing rules.
/// The inputs to this class method:
/// <br>@Input pResourceObject - A %DynamicObject representing the requested resource
/// <br>
/// @Return A boolean value; True if the resource should be returned, false if not.  If false is returned,
/// the service will reply with a 404 Not Found.
/// <br>
/// @Throws The implementation must report errors via $$$ThrowStatus.
Method PostProcessRead(pResourceObject As %DynamicObject) As %Boolean
{
	// Optional method to implement, returns "keep this" by default
	return 1
}

/// @API
/// This method will add a resource to the collection managed by this service, returning the ID value of the
/// newly added resource.
/// @Input pResourceObj  A A %DynamicObject representing the resource to be added.  If the resource has an ID value, it will
/// be ignored.
/// @Input pResourceIdToAssign If "", then an ID will be assigned to the new resource.  If present, 
/// the specified ID must be assigned to the new resource.  If the requested id cannot be assigned, an appropriate
/// error is thrown.
/// @Input pHttpMethod The Http method that is resulting in this Add request.  (POST for a Create or
/// PUT for Conditional Create)
/// @Return The ID of the newly added resource
/// @Throws The implementation must report errors via $$$ThrowStatus.
Method Add(pResourceObj As %DynamicObject, pResourceIdToAssign As %String = "", pHttpMethod = "POST") As %String [ Abstract ]
{
}

/// @API
/// This method will mark a resource as deleted, returning the Version Id of the
/// deleted resource.
/// @Input pResourceType  The 'resourceType' of the resource to be deleted.
/// @Input pResourceId The ID of the resource to be deleted.
/// @Return The version ID of the deleted resource
/// @Throws The implementation must report errors via $$$ThrowStatus.
Method Delete(pResourceType As %String, pResourceId As %String) As %String [ Abstract ]
{
}

/// @API
/// This method will remove the resource and all versions from the database
/// @Input pResourceType  The 'resourceType' of the resource to be deleted.
/// @Input pResourceId The ID of the resource to be deleted.
/// @Input pVersions (Optional) Specification of which versions to delete as follows:
/// <br> "" - The current version only
/// <br> "*" - All Versions (default)
/// <br> $LB(vid, ...) - A list of version Id's to delete
/// @Throws The implementation must report errors via $$$ThrowStatus.
Method HardDelete(pResourceType As %String, pResourceId As %String, pVersions As %String = "*") [ Abstract ]
{
}

/// @API
/// This method will take the provided resource as an update to an existing resource.
/// @Input pResourceObj  A %DynamicObject representing the resource to be deleted.
/// @Return The ID of the updated resource
/// @Throws The implementation must report errors via $$$ThrowStatus.
Method Update(pResourceObj As %DynamicObject) As %String [ Abstract ]
{
}

/// @API
/// This method will apply the specified JSON Patch operations to the specified resource object.
/// It does NOT apply the updated FHIR content to the repo.<br>
/// @Input pPatchOperations %DynamicArray of JSON Patch operations.<br>
/// @Input pResourceObj %DynamicObject representation of the resource to be patched.<br>
/// @Return Boolean value indicating whether the resource object content was updated by the patch.<br>
/// @Throws The implementation must report errors via $$$ThrowStatus.
Method JSONPatch(pPatchOperations As %DynamicArray, pResourceObj As %DynamicObject) As %Boolean [ Abstract ]
{
}

/// @API
/// This method returns the version history of a specified resource
/// @Input pResourceType  The 'resourceType' of the resource to be described
/// @Input pResourceId The ID of the resource to be described
/// @Input pSince The instant value provided in the _since search parameter.  Only versions created after this instant
/// will be included 
/// @Input pAt The the date-time value of the _at search parameter.  Only include resource versions that were current at some point
/// during the time period specified in the date-time value
/// @Return A HS.FHIRServer.Util.SearchResult object containing one row for each version sorted with the latest 
/// version first.
/// @Throws The implementation must report errors via $$$ThrowStatus.
Method History(pResourceType As %String, pResourceId As %String, pSince As %String, pAt As %String) As HS.FHIRServer.Util.SearchResult [ Abstract ]
{
}

/// @API
/// This method performs the requested search for resources and returns a HS.FHIRServer.Util.SearchResult
/// with the selected resource information.  If the query specifies _include or _revinclude parameters, then
/// resources of type other than 'pResourceType' will be part of the result set.  Included resources will
/// be denoted in the result set 'Mode' column with the value 'include'
/// @Input pResourceType  The 'resourceType' of the resource to be searched
/// @Input pCompartmentType If not "", indicates a compartment search of the specified Compartment Type and Id
/// @Input pCompartmentId The ID of the resource comartment being searched
/// @Input pParameters A HS.FHIRServer.API.Data.QueryParameters describing the query parameters specified for the search
/// @Input pSortKeys (ByRef) A multi-dimensional structure describing any sorting to be performed on the result set.   The
/// structure of pSortKeys is an array of sort keys indexed 1-n:
///   pSortKeys(n) = 1 for ascending, 0 for descending
///   pSortKeys(n, "SearchParam") = An HS.FHIRServer.SearchParam object whose value is used to sort.
/// @Return A HS.FHIRServer.Util.SearchResult object containing one row for each selected resource.  
/// @Throws The implementation must report errors via $$$ThrowStatus.
Method Search(pResourceType As %String, pCompartmentType As %String, pCompartmentId As %String, pParameters As HS.FHIRServer.API.Data.QueryParameters, ByRef pSortKeys) [ Abstract ]
{
}

/// @API
/// A method to evalate the result of a potentially successful search to filter the set of results to be returned
/// based on consent or other custom processing rules.  The results are provided in a HS.Util.TransientTable subclass
/// (HS.FHIRServer.Util.SearchResult).  This method may enumerate each result row and upon analysis set the 'Deleted'
/// column of the row to 1 if the row should be filtered out from the result set.  Available columns in the pResultSet
/// are: <br>
/// - - Key               : A unique key for the resource<br>
/// - - Deleted           : Initialized as blank for all rows. Provides a means to mark rows for
///                         exclusion from the returned Bundle of resources. The search and $everything
///                         logic subsequent to the return from PostProcessSearch will ignore result
///                         set rows that have the Deleted column set to 1.<br>
/// - - ResourceType      : Resource type.<br>
/// - - ResourceId        : Resource id.<br>
/// - - Mode              : "match" means the resource matched by the search criteria. "include" means
///                         the resource is present only because a "match" resource has a reference to
///                         it.<br>
/// <br> Inputs:
/// <br>@Input pResultSet - An OREF to the search results contained in a HS.Util.TransientTable subclass
/// (HS.FHIRServer.Util.SearchResult).
/// <br> pResourceType The type of resource enumerated by pResultSet.  If the result set contains mixed types,
/// then pResource will be empty ("").
/// @Throws The implementation must report errors via $$$ThrowStatus.
Method PostProcessSearch(pResultSet As HS.FHIRServer.Util.SearchResult, pResourceType As %String)
{
	// Optional method to implement
}

/// @API
/// This method is called during Search processing, after the primary resource search is complete.  It is
/// responsible for finding and adding any included resources to the result set
/// @Input pResultSet The result of the primary resource search to be enhanced with included resources
/// @Input pIncludeArr A multidimensional structure describing the requested includes. The structure is
///  pIncludeArr = # of entries
///  pIncludeArr(n)  An OREF of the 'reference' type SearchParam whose references will be included
///  pIncludeArr(n, "targetType")  The specific resource type to be included (if any, otherwise all referenced
///  resources will be included) 
/// @Input pRevIncludeArr A multidimensional structure describing the requested reverse includes
///  pRevIncludeArr = # of entries
///  pRevIncludeArr(n)  An OREF of the 'reference' type SearchParam that is referencing a primary resource
Method SearchIncludes(pResultSet As HS.FHIRServer.Util.SearchResult, ByRef pIncludeArr, ByRef pRevIncludeArr) [ Abstract ]
{
}

Method Operation(pService As HS.FHIRServer.API.Service, pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
{
	Do $ClassMethod(..#OperationHandlerClass, "ProcessOperation", pService, pRequest, pResponse)
}

Method Batch(pService As HS.FHIRServer.API.Service, pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
{
	Do $ClassMethod(..#BatchHandlerClass, "ProcessBundle", pService, pRequest, pResponse)
}

}
