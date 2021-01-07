Include HS.FHIRServer

Class HS.FHIRServer.Storage.BuiltIn.Everything Extends (%RegisteredObject, HS.FHIRServer.Util.Bundle, HS.FHIRServer.Util.FHIRQueryUtils)
{

Property schema As HS.FHIRServer.Schema;

Property interactions As HS.FHIRServer.API.Interactions;

Property allResources [ MultiDimensional ];

/// @API Enumerate the name and url of each Operation supported by this class
ClassMethod AddSupportedOperations(pMap As %DynamicObject)
{
	Do pMap.%Set("everything", "http://hl7.org/fhir/OperationDefinition/Patient-everything")
}

/// Implementation of $Everything (Instance scope - requires type and id)
ClassMethod FHIRInstanceOpEverything(pService As HS.FHIRServer.API.Service, pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
{
	Set inst = ##class(HS.FHIRServer.Storage.BuiltIn.Everything).%New()
	Do inst.processEverything(pService, pRequest, pResponse)
}

Method processEverything(pService As HS.FHIRServer.API.Service, pRequest As HS.FHIRServer.API.Data.Request, ByRef pResponse As HS.FHIRServer.API.Data.Response) [ Private ]
{
	Set tSC = $$$OK
	
	Set ..schema = pService.Schema
	Set ..interactions = pService.interactions
	
	#dim serviceconfigData as HS.FHIRServer.API.ConfigData = pService.ConfigData
	#dim rsrcTableName as %String = pService.strategy.GetResourceTable(pRequest.Type)
	
	// Only supported for resource types that have compartments	
	If '$$$IsCompartment(..schema, $$$CompartmentName(pRequest.Type)) {
		$$$ThrowFHIR($$$HSFHIRErrUnsupportedTypeForEverything, pRequest.Type, $$$OutcomeInvalid(400))
	}
	
	// If an OAuth 2.0 access token was provided with this request, verify
	// that the request info does not indicate that the interaction is not
	// allowed per the token. This will Throw if the read is not allowed.
	Do ..interactions.oauth2TokenHandler.VerifyResourceIdRequest(pRequest.Type, pRequest.Id, "read")
	
	// Get the primary resource for the compartment (or throw if not present)
	#dim primaryResourceKey = pRequest.Type _ "/" _ pRequest.Id
	#dim primaryResource as %DynamicObject = ..interactions.Read(pRequest.Type, pRequest.Id)
	
	// If an OAuth 2.0 access token was provided with this request, verify
	// that the contents of the initial retrieved resource satisfy the scope(s)
	// and context of the token. This will Throw if the read was not allowed.
	// For $everything with an access token that specifies a patient context,
	// if the contents of the initial retrieved resource indicates that that
	// resource is in the patient context compartment, then it is assumed that
	// all resources to be retrieved by this $everything also are applicable
	// to that patient.
	Do ..interactions.oauth2TokenHandler.VerifyEverythingRequest(pRequest.Type, pRequest.Id, primaryResource)
	
	// Check to see if the consent processor eliminates the primary.  If so, throw a not-found error.
	if ' ..interactions.PostProcessRead(primaryResource) {
		$$$ThrowFHIR($$$HSFHIRErrResourceNotFound, pRequest.Type, pRequest.Id,$$$OutcomeNotFound)
	}
	
	
	// Prepare context for reference walking
	// Pre-set known references
	Set visitContext("callbackInstance") = $this
	Set visitContext("callbackMethod") = "OnReference"
	Set visitContext("schema") = ..schema
	#dim resultSet as HS.FHIRServer.Util.SearchResult = ##class(HS.FHIRServer.Util.SearchResult).Create()
	Set visitContext("resultSet") = resultSet
	
	if $I(visitContext("visited")) {
		Do ..addResult(.visitContext, primaryResourceKey, primaryResource, "match")
		Set visitContext("visited", primaryResourceKey) = primaryResource
		// Recursively find all references from each of the matched resources
		Do ##class(HS.FHIRServer.Util.ReferenceVisitor).VisitAll(primaryResource, .visitContext)
	}
	// Get all resources in the compartment
	Set tSQL = "Select ResourceType, ResourceId from " _ rsrcTableName _ " where Deleted=0 AND FOR SOME %ELEMENT(Compartments) (%VALUE=?)"
	Set tSQLParams = 0
	Set tSQLParams($I(tSQLParams)) = primaryResourceKey
	#dim result as %SQL.StatementResult = ..runQuery(tSQL, .tSQLParams)
	Set refList = ""
	while result.%Next() {
		Set type = result.%GetData(1)
		Set rsrcId = result.%GetData(2)
		Set key = type_"/"_rsrcId
		Continue:$D(visitContext("visited", key))

		
		// Read each resource
		Set visitedRsrc = ..interactions.Read(type, rsrcId)
		// If it passes consent (post-processing), then add it to our list
		if $I(visitContext("visited")) {
			Do ..addResult(.visitContext, key, visitedRsrc, "include")
			Set visitContext("visited", key) = visitedRsrc
		}
		Set $List(refList, *+1) = key
	}
	// Subsequent references are "included", the bundle 'count' property should be only the
	// count of 'match' items.
	set matchCount = visitContext("visited")
	
	set ptr = 0
	while $ListNext(refList, ptr, ref) {
		// Recursively find all references from each of the matched resources
		Do ##class(HS.FHIRServer.Util.ReferenceVisitor).VisitAll(visitContext("visited", ref), .visitContext)
	}
	
	// adjust back references to only be non-Shared resources
	Do ##class(HS.FHIRServer.Util.ReferenceVisitor).adjustCrossReference(..schema, .visitContext)
	
	// Now apply post-processing to the set of resources to be returned
	Do resultSet.%SetIterator(0)
	While (resultSet.NextUndeleted()) {		
		// Set the RefersTo list for each row
		Set backRefsList = ##class(HS.FHIRServer.Util.ReferenceVisitor).GetReferencingIds(resultSet.Key, .visitContext)
		if backRefsList '= "" {
			Do resultSet.SetReferredToBy(backRefsList)
		}
	}
	
	Do resultSet.%SetIterator(0)	
	Do ..interactions.PostProcessSearch(resultSet, "")
	Do resultSet.%SetIterator(0)
	set total = 0
	While (resultSet.NextUndeleted()) {
		i $i(total)
	}
	Do resultSet.%SetIterator(0)
	set tQueryURL = pRequest.BaseURL_"/"_pRequest.RequestPath
	Set bundleUrls("self") = tQueryURL
	Set bundle = ..CreateBundle("", "searchset", total, .bundleUrls, ..schema)
	
	Do resultSet.%SetIterator(0)
	While (resultSet.NextUndeleted()) {
		Set fullUrl = pRequest.BaseURL _ "/" _ resultSet.ResourceType _ "/" _ resultSet.ResourceId
		Do ..AddBundleEntry(bundle, fullUrl, resultSet.ResourceJson, resultSet.Mode)
	}
	
	Set pResponse.Json = ..FinalizeBundle(bundle)
	Set pResponse.Status = 200
	Return
}

ClassMethod addResult(ByRef context, key As %String, rsrcObj As %DynamicObject, mode As %String)
{
	Set resultSet = context("resultSet")
	Do resultSet.AddRow(key, rsrcObj.resourceType, rsrcObj.id, "", mode, "", rsrcObj)
}

/// Add any newly detected reference value to our set and recurse searching for references
/// from that referenced object.  
Method OnReference(ByRef context, pRefObj As %DynamicObject)
{
	// Per schema, both reference reference and reference identifier may be present.
	// Per HL7 FHIR comments, reference reference takes precedence.
	Set tRefReference = pRefObj.reference
	Set tRefIdentifier = pRefObj.identifier
	if tRefReference '= "" {
		If $D(context("visited", tRefReference))=0 {
			// We have not seen this resource yet.
			Set tTargetType = $Piece(tRefReference, "/", 1)
			Set tTargetId = $Piece(tRefReference, "/", 2)
			Set rsrcObj = ..interactions.FindResourceObject(tTargetType, tTargetId)
			if rsrcObj '= "" {
				if $I(context("visited")) {
					Do ..addResult(.context, tRefReference, rsrcObj, "include")
					Set context("visited", tRefReference) = rsrcObj
				}
				Do ##class(HS.FHIRServer.Util.ReferenceVisitor).VisitAll(rsrcObj, .context)
			} else {
				// TODO:  Should we do something if there is a reference to a non-existent resource?
			}
		}
	} ElseIf tRefIdentifier '= "" {
		// TODO:  How / if to resolve reference identifier?
	}
}

}
