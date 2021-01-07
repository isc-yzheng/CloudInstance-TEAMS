Include HS.FHIRServer

Class HS.FHIRServer.DefaultBundleProcessor Extends HS.FHIRServer.Util.Bundle
{

/// Class that provides the FHIR Bundle resource validation logic for this Bundle processing
/// class. The class is intended to handle Bundle-specific validation, i.e., the rules
/// applying to transaction, batch, document, and message Bundles.
Parameter BundleValidatorClass As %String = "HS.FHIRServer.Util.BundleValidator";

/// Context layout
/// ctx("entry")                   : Count of entries
/// ctx("entry", n)                : The n-th input bundle entry
/// ctx("entry", n, "response")    : The response bundle entry for the n-th input bundle entry
/// ctx("entry", n, "fullUrl")      : The temporary id (used only for POST entries) to allow references from other
///                                :  resources in the bundle. Used only for transaction interactions
/// ctx("ByFullUrl", fullUrl)        : The actual id associated with the refkey.  Used to resolve references to this resource.
/// ctx("ByFullUrl", fullUrl, "entry") : The entry Index associated with the refkey.
///                                :  resources in the bundle. Used only for transaction interactions
/// ctx("ByFullUrl", fullUrl, "from", iEntry) : EntryId of a resource referencing the fullUrl
/// ctx("ByFullUrl", fullUrl, "refObj") : Count of References to fullUrl within the bundle
/// ctx("ByFullUrl", fullUrl, "refObj", n) : n-th Reference Object referring to fullUrl
/// ctx("ByMethod", method)        : The count of operations to execute for the specified method
/// ctx("ByMethod", method, n)     : The entry Index of the n-th operation to execute for the specified method
/// ctx("Depends", entryId, postedId) : Present if the specified entry requires the posted entry to be processed first.
/// ctx("Posted", entryId )           : Present when a POST entry has been processed (used for circular reference management)
/// ctx("Circular", entryId )         : Present when a POST entry has been processed but a prerequisite has not.  It will be updated at the end
ClassMethod ProcessBundle(pService As HS.FHIRServer.API.Service, pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
{
	// Transaction Processing:
	//	1. Map 'fullUrl' -> entry# for each POST entry
	//	2. Visit all references, capture:
	//		References that are "search urls"
	//		References the target one of the 'POST' entry fullUrl values
	//	3. Resolve the search urls to resource references
	//  4. Resolve references for each POST result
	//	5. execute other operations and return result.
	Set tSC = $$$OK

	#dim bundle as %DynamicObject = pRequest.Json
	
	if bundle="" {
		$$$ThrowFHIR($$$HSFHIRErrAPIContractViolation, "request.Json")
	}
	
	// Validate the bundle and throw on error
	Do $classmethod(..#BundleValidatorClass, "ValidateBundle", bundle, pService.Schema.FHIRVersion)
	
	// Extract the bundle type
	Set tBundleType = bundle.type
	If (tBundleType="transaction") {
		Set isTransaction = 1
	} elseif (tBundleType="batch") {
		Set isTransaction = 0
	} else {
		$$$ThrowFHIR($$$HSFHIRErrInvalidBundleTypeForTransaction, tBundleType, $$$OutcomeIs(400, "error", "invalid"))
	}


	// Populate the Context object with the entries
	Set visitContext("entry") = 0
	Set iter = bundle.entry.%GetIterator()
	while iter.%GetNext(.subscr, .entryObj) {
		// Append to the Entry List
		Set iEntry = $I(visitContext("entry"))
		Set visitContext("entry", iEntry) = entryObj
		Set reqObj = entryObj.request
		Set rsrcObj = entryObj.resource
		
		// Append to the ByMethod list
		Set methodIndex = $I(visitContext("ByMethod", reqObj.method))
		Set visitContext("ByMethod", reqObj.method, methodIndex) = iEntry

		// If the entry is a POST and has a fullUrl, capture the fullUrl for reference resolution
		// after the entry is created, we will replace the fullUrl value with the actual resource ID
		if isTransaction && (reqObj.method  = "POST") {
			// Grab the UUID if the fullUrl is specified
			Set fullUrl = ..ExtractUUID(entryObj.fullUrl)
			if fullUrl '= "" {
				// Save the reference Key with the entry, so we can resolve during POST
				Set visitContext("entry", iEntry, "fullUrl") = fullUrl
				// This will become the resolved id when the POST is executed
				Set visitContext("ByFullUrl", fullUrl) = iEntry
				// Save which entry the referenceKey refers to
				//Set visitContext("ByFullUrl", fullUrl, "resolve") = ""
				//w "Key for ",iEntry,": ", entryObj.fullUrl," is ",fullUrl,!
			}
		}
	}
	
	// Now for each resource in the bundle, collect the internal references and ensure they are present
	// (meaning there was a fullUrl declaration on a POSTed resource within the bundle)
	
	// Prepare Visit Context for reference walking
	Set visitContext("schema") = pService.Schema
	Set visitContext("callbackClass") = $classname()
	Set visitContext("callbackMethod") = "BuildDependencyCallback"
	
	// Check every reference field in every entry that provides a resource.  If the
	// reference contains an intra-bundle reference, capture the OREF to the Reference object
	// so we can resolve it when the referenced resource is POST'ed.
	set entryId = ""
	for {
		Set entryId = $Order(visitContext("entry", entryId))
		Quit:(entryId="")

		Set entryObj = visitContext("entry", entryId)
		Set visitContext("visiting") = entryId
		if entryObj.resource {
			Do ##class(HS.FHIRServer.Util.ReferenceVisitor).VisitAll(entryObj.resource, .visitContext)
		}
	}
	
	// Now build the POST order based on the dependencies .... Error if circular references exist
	set postIndex = ""
	Set postContext("list") = 0
	Set count = 0
	for {
		Set postIndex = $Order(visitContext("ByMethod", "POST", postIndex), 1, entryId)
		Quit:(postIndex="")
		
		Do ..AddToPostOrder(entryId, .visitContext, .postContext)
		Set count = count + 1
	}
	
	// Update the POST requests to follow the order derived based on dependencies
	kill visitContext("ByMethod", "POST")
	Merge visitContext("ByMethod", "POST") = postContext("list")
	kill postContext


	// More to do
	If (tBundleType="transaction") || (tBundleType="batch") {
		Do ..ExecuteBundle(pService, pRequest, pResponse, tBundleType, .visitContext)
	} else {
		$$$ThrowFHIR($$$HSFHIRErrInvalidBundleTypeForTransaction, tBundleType, $$$OutcomeIs(400, "error", "invalid"))
	}
}

/// This method is a callback from the VisitAll method.  It is called for each Reference object
/// in the resource.  If the reference is bundle-internal, we capture it.
ClassMethod BuildDependencyCallback(ByRef visitContext, pRefObj As %DynamicObject)
{
	// This is called for each reference FROM a resource to be POST'ed.
	Set referencingId = visitContext("visiting")
	// Get the reference and check to see if it is a UUID
	Set tRefReference = pRefObj.reference
	Set fullUrl = ..ExtractUUID(tRefReference)
	if (fullUrl '= "") {
		// This is a reference to a UUID-style URL, a bundle-internal reference	
		if '$D(visitContext("ByFullUrl", fullUrl)) {
			// We didn't find this fullUrl in the bundle
			Set rsrc = visitContext("entry", referencingId)
			if '$D(visitContext("entry", referencingId, "fullUrl"), sourceRefKey) {
				Set sourceRefKey = rsrc.resourceType _ "/" _ rsrc.id
			}
			$$$ThrowFHIR($$$HSFHIRErrUnresolvedBundlePlaceholder, fullUrl, referencingId, sourceRefKey, $$$OutcomeInvalid(400))
		}
		// This is a reference to another resource in this bundle
		Set visitContext("ByFullUrl", fullUrl, "refObj", $I(visitContext("ByFullUrl", fullUrl, "refObj"))) = pRefObj
		Set visitContext("Depends", referencingId, visitContext("ByFullUrl", fullUrl)) = ""
	}
}

/// This is a function that recurses on all entries that the specified entry needs to have POST'd, then it adds
/// itself to the list. NOTE: This tries to minimize updates of newly posted resources.  If a circular reference is detected, then
/// reposting may be necessary and is handled later.
ClassMethod AddToPostOrder(entryId As %String, ByRef visitContext, ByRef postContext, path As %CacheString = "")
{
	if $D(postContext("ordered", entryId)) {
		// This entry has already been ordered
		return 
	}
	
	if '$ListFind(path, entryId) {
		// If we haven't gone in a circle yet ...
		Set nextPath = path _ $LB(entryId)
		Set postedId = ""
		for {
			// First make sure any resources referenced from this resource have been POSTed
			Set postedId = $Order(visitContext("Depends", entryId, postedId))
			Quit:(postedId="")
			// Put our prerequisites in the list first.
			Do ..AddToPostOrder(postedId, .visitContext, .postContext, nextPath)		
		}
		
	}
	// Add to the list and flag as already ordered
	Set postContext("list", $I(postContext("list"))) = entryId
	Set postContext("ordered", entryId) = ""
}

/// Resolves all intra-bundle references to a specific fullUrl with a
/// specified Id (in the form of <resourceType>/<resourceId>)
ClassMethod ResolveFullUrl(ByRef visitContext, fullUrl As %String, resolvedId As %String) [ Private ]
{
	Set entryId = visitContext("ByFullUrl", fullUrl)
	Set entryObj = visitContext("entry", entryId)
	Set entryKey = entryObj.resource.resourceType _ "/" _ resolvedId

	// Update the resolution of the full URL (even though we won't need it again after this method).
	Set visitContext("ByFullUrl", fullUrl, "resolve") = entryKey

	
	// Now loop through all previously found references to the fullUrl.
	set ix = ""
	for {
		set ix = $Order(visitContext("ByFullUrl", fullUrl, "refObj", ix), 1, refObj)
		Quit:ix=""
		
		Set refObj.reference = entryKey
	}
}

/// API
/// IsUUID returns the UUID-portion of the input string if the specified string is a UUID, returns 0 if not. 
/// Requirement for the presence of the "urn:uuid:" prefix is determined by the pPrefixRequired input parameter.
/// Once prefix is verified per the requirement, the remainder of validation takes place
/// with the prefix stripped.
ClassMethod ExtractUUID(pString As %String, pPrefixRequired As %Boolean = 0) As %String
{
	Set tString = pString
	If $Extract(tString,1,9)="urn:uuid:" {
		Set tString = $Extract(tString,10,*)
	} Else {
		If pPrefixRequired=1 {
			Return 0
		}
	}
	// If we get here, tString is unprefixed.  Now check its form
	if $Match(tString,"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}") {
		Return tString
	}
	Return ""
}

/// ExecuteBundle processes a batch or transaction Bundle according to the FHIR specification at:<br>
/// http://hl7.org/fhir/DSTU2/http.html#transaction<br>
/// http://hl7.org/fhir/STU3/http.html#transaction<br>
/// <br>Inputs:<br>
/// <li>pService              : The FHIR Service instance that invoked this processor
/// <li>pRequest              : FHIR request message.
/// <li>pResponse             : FHIR response object to receive the result
/// <li>pBundleType           : String specifying the bundle type ("batch" or "transaction")
/// <li>visitContext          : The context object that is controlling this operation
ClassMethod ExecuteBundle(pService As HS.FHIRServer.API.Service, pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response, pBundleType As %String, ByRef visitContext)
{
	
	#dim fhirRequest  As HS.FHIRServer.API.Data.Request
	#dim fhirResponse As HS.FHIRServer.API.Data.Response

	If pBundleType="transaction" {
		TSTART
	}
	
	// Create the transaction-response or batch-response Bundle
	// No Total property for response bundles
	Set bundleTotal = ""
	Set bundle = ..CreateBundle("", pBundleType_"-response", bundleTotal, .bundleUrls, pService.Schema)


	// For transaction, if an interaction fails then quit, perform TROLLBACK,
	// and return a single return status and OperationOutcome.  Otherwise if
	// successful then return a Bundle of response entries.
	For tMethod = "DELETE", "POST", "PUT", "GET" {
		Set methodIndex = ""
		For {
			Set methodIndex = $Order(visitContext("ByMethod", tMethod, methodIndex), 1, entryId)
			Quit:methodIndex=""
			Set entryObj = visitContext("entry", entryId)
			Set reqObj = entryObj.request

			Set fhirRequest = ..prepareRequest(pService, pRequest, .visitContext, entryObj)
			Do pService.DispatchRequest( fhirRequest, .fhirResponse )
			//w "status: ",fhirResponse.Status," for ",reqObj.url,", loc: ",fhirResponse.Location,!
			
			if (pBundleType = "transaction") {
				Set httpStatus = +fhirResponse.Status
				Set tHTTPSuccess = (httpStatus >=200) && (httpStatus <= 299)
				if 'tHTTPSuccess {
					// Abort the transaction and return an Operation Outcome
					Set pResponse.Json = fhirResponse.Json
					Set pResponse.Status = httpStatus
					TROLLBACK
					Return
				} else {
					if tMethod = "POST" {
						// A successful interaction POST either grab the new id, or resolve pointer
						Set fullUrl = $Get( visitContext("entry", entryId, "fullUrl") )
						if fullUrl '= "" {
							// Resolve all references if this resource had a fullUrl
							Set rsrcId = fhirResponse.Id
							Do ..ResolveFullUrl(.visitContext, fullUrl, rsrcId)
						}
						Set visitContext("Posted", entryId) = ""
						
						// Check if this entry needs a redo (circular reference)
						set postedId = ""
						for {
							Set postedId = $Order(visitContext("Depends", entryId, postedId))
							Quit:postedId=""
							
							// If one of the entries we need to resolve has not been processed, 
							// flag this as circular.
							if '$D(visitContext("Posted", postedId)) {
								Set visitContext("Circular", entryId) = ""
								// TODO: Post process the resources marked "circular" as they are now fully resolved
								// and can be re-saved.
								$$$ThrowFHIR($$$GeneralError, "Circular reference chain found in bundle entry " _ entryId)	
								Quit
							}
						}
					}
				}
			}
			
			// Build the Bundle Entry for the response			
			#dim bundleEntry As %DynamicObject = $$$NewJSONObject
			Set bundleEntry.fullUrl = entryObj.fullUrl
			
			#dim respObj as %DynamicObject = $$$NewJSONObject
			Set bundleEntry.response = respObj
			// Return the resource if present
			if fhirResponse.Json '= "" {
				Set bundleEntry.resource = fhirResponse.Json
			}
			Set respObj.status = fhirResponse.Status
			Set visitContext("entry", entryId, "response") = bundleEntry

			// If success, set the response property of the response entry to
			// include the interaction status, and add any FHIR payload that
			// may have been returned from the interaction.
			If (tHTTPSuccess)||(((fhirRequest.Interaction="read")||(fhirRequest.Interaction="vread"))&&(+fhirResponse.Status=404)) {
				Set tLocation = fhirResponse.Location
				If tLocation'="" {
					//w tLocation,!
					If tLocation["/_history/" {
						Set tLocation = $Piece(tLocation,"/_history/",1)
					}
					Set pathCount = $Length(tLocation, "/")
					Set rsrcId = $Select(pathCount<2:"", 1:$piece(tLocation, "/", pathCount-1, pathCount))
					Set respObj.location = tLocation
					//w "rid: ",rsrcId,", loc: ",tLocation,!
				}
				
				Set etag = fhirResponse.ETag
				If etag '= "" {
					Set respObj.etag = etag
				}
				If fhirResponse.LastModified '= "" {
					// Last-Modified is in format "Fri, 13 Jul 2018 01:28:55 GMT".
					// Convert it back to format "2018-07-13T01:28:55Z".
					Set tLastModified = $Piece(fhirResponse.LastModified,",",2)
					Set tLastModified = $ZStrip(tLastModified,"<>W")
					Set tLastModified = $Extract(tLastModified,1,*-4)
					Set tLastModified = $ZDateTimeH(tLastModified,2)
					Set tLastModified = $ZDateTime(tLastModified,3)
					Set tLastModified = $Translate(tLastModified," ","T")_"Z"
					Set respObj.lastModified = tLastModified
				}
			} 
		}
	}
	
	// Now re-order the responses in the result bundle
	Set entryCount = visitContext("entry")
	Set bundle.entry = $$$NewJSONArray
	For entryId=1:1:entryCount {
		#dim entryObj As %DynamicObject = visitContext("entry", entryId, "response")
		Do bundle.entry.%Push(entryObj)
	}
	
	
	// Processing all succeeded, go ahead and TCOMMIT now.
	If pBundleType="transaction" {
		TCOMMIT
	}
	Set pResponse.Json = ..FinalizeBundle(bundle)
	Set pResponse.Status = 200
}

ClassMethod prepareRequest(pService As HS.FHIRServer.API.Service, pTransRequest As HS.FHIRServer.API.Data.Request, ByRef visitContext, entryObj As %DynamicObject)
{
	#dim tRequest As HS.FHIRServer.API.Data.Request = ##class(HS.FHIRServer.API.Data.Request).%New()
	// Indicate that this is a recursive request back into the service
	Set tRequest.IsRecursive = 1

	Set reqObj = entryObj.request
	
	Set tUrl = reqObj.url
	Set tQuery = $Piece(tUrl,"?",2,*)
	Set tUrl = $Piece(tUrl,"?",1)
	// Translate if the request URL is a placeholder
	Set uuid = ..ExtractUUID(tUrl)
	if (uuid '= "") && $D(visitContext("ByFullUrl", uuid, "resolve"), tUrl) '= 0 {
		Set entryId = visitContext("ByFullUrl", uuid)
		Set targetEntry = visitContext("entry", entryId)
	}
	
	if 0 {
		// TODO: Should this NOT be an error??
		// The request url should not include the base url.
		// Compensate in case it is included.
		Set tBaseUrl = pTransRequest.BaseURL
		If (tFullBaseUrl'="")&&($Extract(tUrl,1,$Length(tFullBaseUrl))=tFullBaseUrl) Set tUrl = $Extract(tUrl,$Length(tFullBaseUrl)+2,*)
		If (tBaseUrl'="")&&($Extract(tUrl,1,$Length(tBaseUrl))=tBaseUrl) Set tUrl = $Extract(tUrl,$Length(tBaseUrl)+2,*)
	}
	
	//
	Set tRequest.RequestPath = tUrl
	Set tRequest.QueryString = tQuery
	Set tRequest.RequestMethod = reqObj.method
	Set tRequest.IfMatch = reqObj.IfMatch
	Set tRequest.IfModifiedSince = reqObj.IfModifiedSince
	Set tRequest.IfNoneExist = reqObj.IfNoneExist
	Set tRequest.IfNoneMatch = reqObj.IfNoneMatch
	if entryObj.resource '= "" {
		Set tRequest.Json = entryObj.resource
		Set tRequest.RequestFormatCode = $$$FHIRContentCodeJSON
	}

	Set tRequest.ResponseFormatCode = pTransRequest.ResponseFormatCode
	Set tRequest.BaseURL = pTransRequest.BaseURL
	Set tRequest.SessionApplication = pTransRequest.SessionApplication
	Set tRequest.Prefer = pTransRequest.Prefer

	return tRequest
}

}
