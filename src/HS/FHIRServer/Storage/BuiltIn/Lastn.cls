Include HS.FHIRServer

/// This class supports the $lastn operation: http://hl7.org/fhir/observation-operations.html#lastn
Class HS.FHIRServer.Storage.BuiltIn.Lastn Extends HS.FHIRServer.Util.Bundle
{

/// @API Enumerate the name and url of each Operation supported by this class
ClassMethod AddSupportedOperations(pMap As %DynamicObject)
{
	Do pMap.%Set("lastn", "http://hl7.org/fhir/OperationDefinition/Observation-lastn")
}

/// Implementation of $Lastn (Type scope - requires type, no id)
ClassMethod FHIRTypeOpLastn(pService As HS.FHIRServer.API.Service, pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
{
	Do ..processLastn(pService, pRequest, pResponse)
}

/// Support the $lastn operation: http://hl7.org/fhir/observation-operations.html#lastn
ClassMethod processLastn(pService As HS.FHIRServer.API.Service, pRequest As HS.FHIRServer.API.Data.Request, ByRef pResponse As HS.FHIRServer.API.Data.Response) [ Private ]
{
	// processLastn:
	// - Enforces $lastn-specific constraints and requirements on the query parameters.
	// - Ensures that the first two sort keys to apply are code and -date.
	// - Invokes the Search API method for the current strategy.
	// - Invokes the SearchIncludes API method for the current strategy, if any requested.
	// - Invokes the PostProcessSearch method for the current strategy.
	// - Parses the remaining undeleted result set rows to build a cross index that enables
	//    Observation code grouping per $lastn requirements.
	// - Parses the cross index to add resources to the searchset Bundle in the desired order.
	// - Adds any resources gleaned from include and revinclude.
	// - Returns the Bundle as part of the pResponse return parameter.
	
	Set requestResourceType = pRequest.Type
	Set baseURL = pRequest.BaseURL
	
	If requestResourceType'="Observation" {
		$$$ThrowFHIR($$$HSFHIRErrLastnInvalidResourceType, requestResourceType, $$$OutcomeInvalid(400))
	}
	
	// These are InterSystems-specific parameters to use for paging.
	Set queryId = pRequest.GetParameterValue(pService.#QUERYIDPARAM)
	Set currentPage = pRequest.GetParameterValue(pService.#QUERYPAGEPARAM)
	
	If queryId="" {
		Set currentPage = 1
		
		#dim resultSet As HS.FHIRServer.Util.SearchResult = ..LastnNew(pService, pRequest)
		
		Set queryUrl = pRequest.BaseURL_$Select($Extract(pRequest.BaseURL,*)="/":"",1:"/")_pRequest.RequestPath_"?"_pRequest.Parameters.AsString()
	
		Set pageCount = resultSet.Paginate( pService.GetQueryPageSize(pRequest) )
		If pageCount > 1 {
			Do resultSet.Save()	
		}

		If resultSet.TotalUndeleted > pService.ConfigData.MaxSearchResults {
			$$$ThrowFHIR($$$HSFHIRErrSearchTooCostly, pService.ConfigData.MaxSearchResults, $$$OutcomeIs(413, "error", "too-costly"))
		}
		// Handle the Summary Request Here
		If resultSet.PageSize=0 {
			// From http://hl7.org/fhir/STU3/search.html#count
			// if _count has the value 0, this shall be treated the same as _summary=count:
			// the server resturns a bundle that reports the total number of resources that
			// match in Bundle.total, but with no entries, and no prev/next/last links. Note
			// that the Bundle.total only include the total number of matching resources. It
			// does not count extra resources such as OperationOutcome or included resources
			// that may also be returned.
			Kill bundleUrls
			Set bundleUrls("self") = queryUrl
			Set bundle = ..CreateBundle("", "searchset", resultSet.MatchCount, .bundleUrls, pService.Schema)
			Set pResponse.Json = ..FinalizeBundle(bundle)
			Set pResponse.Status = 200
			Return
		}
		
	} Else {
		// Response from a page request to a previous $lastn query.
		set queryUrl = pService.GetFullRequestURL(pRequest)
		Set resultSet = ##class(HS.FHIRServer.Util.SearchResult).Restore(queryId)
		if $IsObject(resultSet)=0 {
			$$$ThrowFHIR($$$GeneralError, "Invalid queryId specified") 
		}
		
		if +currentPage=0 set currentPage = 1
	}
	Do resultSet.SetIteratorToPage(currentPage)
	
	// Get the page link(s), start the output Bundle.
	Do pService.GetPageLinks(pRequest, resultSet.QueryId, resultSet.TotalUndeleted, resultSet.PageSize, currentPage, baseURL, .bundleUrls)
	Set bundleUrls("self") = queryUrl
	Set bundle = ..CreateBundle("", "searchset", resultSet.MatchCount, .bundleUrls, pService.Schema)
	
	// Parameters can have errors at this point if Prefer handling=lenient, and
	// the errors are on parameters that do not have $lastn-specific requirements.
	// Add OperationOutcome first so that it is more noticeable.
	If $$$ISERR(pRequest.Parameters.status) {
		Set outcome = ##class(HS.FHIRServer.Util.Outcome).CreateFromStatus(pRequest.Parameters.status, .httpStatus)
		Do ..AddBundleEntry(bundle, "", outcome, "outcome")
	}

	For index = 1:1:resultSet.PageSize {
		If 'resultSet.NextUndeleted() {
			Quit
		}
		If '$isObject(resultSet.ResourceJson) {
			Set json = pService.interactions.Read(resultSet.ResourceType, resultSet.ResourceId)
		} Else {
			Set json = resultSet.ResourceJson
		}
		Set fullUrl = baseURL_"/"_json.resourceType_"/"_json.id
		Set bundleEntry = ..AddBundleEntry(bundle, fullUrl, json, resultSet.Mode)
	}
	
	Set pResponse.Json = ..FinalizeBundle(bundle)
	Set pResponse.Status = 200
	
	Return
}

/// Handle query for new $lastn request, as opposed to a continuation (paging) query.
ClassMethod LastnNew(pService As HS.FHIRServer.API.Service, pRequest As HS.FHIRServer.API.Data.Request) As HS.FHIRServer.Util.SearchResult [ Internal ]
{
	// Interim result set in this method, to hold retained rows with ResourceJson property value added.
	#dim tempResultSet As HS.FHIRServer.Util.SearchResult = ##class(HS.FHIRServer.Util.SearchResult).Create()
	
	// Final result set to return to the caller.
	#dim returnResultSet As HS.FHIRServer.Util.SearchResult = ##class(HS.FHIRServer.Util.SearchResult).Create()
	
	Set errList = $$$OK
	
	Set requestResourceType = pRequest.Type
	
	// space padding of code and system values for sorting.
	Set spacesLen = 30
	Set $Piece(spaces, " ", spacesLen-1) = ""
	
	// Validate the input parameters per $lastn constraints and requirements.
	// Return some derived values for later use. Validation of input parameters
	// per the Search logic for the current strategy will take place when that
	// Search logic is called. 
	Do ..ValidateRequestInputLastn(pService, pRequest, .hasCount0, .maxPerGroup, .sortKeys, .errList)
	
	// Check the _include related parameter info, even if we are going to error
	// on unrecognized search params that we found earlier.
	Do pRequest.Parameters.GetParameters("_include", .params)
	Do pService.BuildIncludeList(.params, requestResourceType, .errList, .tValidIncludesArr)
	
	// Check the _revinclude related parameter info, even if we are going to error
	// on unrecognized search params that we found earlier.
	Do pRequest.Parameters.GetParameters("_revinclude", .params)
	Do pService.BuildRevIncludeList(.params, requestResourceType, .errList, .tValidRevIncludesArr)
	
	// Parameters that fail $lastn requirements, and malformed _include or _revinclude params,
	// should always be an error with HTTP 400 Bad Request, regardless of Prefer handling.
	$$$ThrowOnError(errList)
	
	Do pService.interactions.oauth2TokenHandler.VerifySearchRequest(requestResourceType, "", "", pRequest.Parameters, "read")
	
	// Do the Search query for the current strategy, include the sort params.
	#dim resultSet As HS.FHIRServer.Util.SearchResult = pService.interactions.Search(requestResourceType, "", "", pRequest.Parameters, .sortKeys)
	
	// Add any includes (and reverse includes) to the result set, if requested.	
	If (tValidIncludesArr) || (tValidRevIncludesArr) {
		// context will be needed later if _include or _revinclude are part of the query.
		Set lastnContext("schema") = pService.Schema
		Do pService.interactions.SearchIncludes(resultSet, .tValidIncludesArr, .tValidRevIncludesArr)
	}
	
	// search parameters _include, _revinclude or _contained, could cause more than one
	// resource type to be represented in the result set. The following loop will set
	// resourceType to empty if multiple types are included
	If (tValidIncludesArr || tValidRevIncludesArr || (pRequest.Parameters.GetParameterCount("_contained"))) {
		Set postProcessorResourceType = ""
	} Else {
		Set postProcessorResourceType = requestResourceType
	}
	
	// Now apply post-processing to the set of resources to be returned
	Do pService.interactions.PostProcessSearch(resultSet, postProcessorResourceType)
	
	// HS.FHIRServer.Util.SearchResult MatchCount and TotalCount get updated
	// only upon Paginate() or Save(), which we don't want to do right now.
	Set matchCount = 0
	While resultSet.NextUndeleted() {
		If resultSet.Mode="match" {
			If $i(matchCount)
		}
	}
	Do resultSet.%SetIterator(0)
	
	// Handle _summary=count / _count=0 / no matches found / no matches remaining.
	If ('matchCount) || (hasCount0) {
		// From http://hl7.org/fhir/STU3/search.html#count
		// if _count has the value 0, this shall be treated the same as _summary=count:
		// the server returns a Bundle that reports the total number of resources that
		// match in Bundle.total, but with no entries, and no prev/next/last links. Note
		// that the Bundle.total only includes the total number of matching resources. It
		// does not count extra resources such as OperationOutcome or included resources
		// that may also be returned.
		Return resultSet
	}
	
	// Because we are building a cross-index for the $lastn grouping rules, we want
	// to loop through ALL resultSet rows in order to get the row number of each.
	// But, only process the match rows.
	//
	// groups("ByGroupNum", groupNum, rowNum) = "" // by rowNum because the result set is secondary sorted by date
	// groups("ByPrimaryCodeOrText", codeOrText) = groupNum
	// groups("ByCodeOrText", codeOrText) = groupNum
	//
	Set rowNum = 0
	While (resultSet.NextUndeleted()) {
		If $i(rowNum)
		If resultSet.Mode'="match" {
			Do tempResultSet.AddRow(resultSet.Key, resultSet.ResourceType, resultSet.ResourceId, resultSet.VersionId, resultSet.Mode, resultSet.Verb, resultSet.ResourceJson, resultSet.ReferredToBy)
		} Else {
			Do ..ProcessResultRow(pService.interactions, resultSet, tempResultSet, rowNum, spaces, .groups, .resourceObjs, .lastnContext)
		}
	}
	
	// Discard the original result set, and now use tempResultSet to find
	// the Observation resources to retain.
	Kill resultSet
	Do tempResultSet.%SetIterator(0)
	
	Set totalLastnMatchEntries = 0
	
	#dim resourceObj As %Library.DynamicObject
	
	Set primaryCodeOrText = ""
	For {
		Set primaryCodeOrText = $Order(groups("ByPrimaryCodeOrText", primaryCodeOrText), 1, groupNum)
		If primaryCodeOrText="" Quit
		Set groupCount = 0
		Set lastDateTime = ""
		Set rowNum = ""
		For {
			Set rowNum = $Order(groups("ByGroupNum", groupNum, rowNum))
			If rowNum="" Quit
			// Workaround for %SetIterator() not able to set directly to specified row.
			Do tempResultSet.%SetIterator(rowNum-1)
			Do tempResultSet.%Next()
			Set resultKey = tempResultSet.Key
			Set resourceObj = tempResultSet.ResourceJson
			Set obsDateTime = ..GetObsDateTimeFromResource(resourceObj)
			// If there are more than max rows for given group, and row max+1 has the
			// same dateTime as dateTime on row max, then continue adding rows until
			// dateTime value is different.
			If ($i(groupCount)'>maxPerGroup) || (obsDateTime=lastDateTime) {
				Do returnResultSet.AddRow(resultKey, tempResultSet.ResourceType, tempResultSet.ResourceId, tempResultSet.VersionId, tempResultSet.Mode, tempResultSet.Verb, resourceObj)
				If $i(totalLastnMatchEntries)
				Set lastDateTime = obsDateTime
				// Keep track of the rows that did NOT get trimmed by max.
				Set remainingMatchKeys(resultKey) = ""
				Do tempResultSet.MarkAsDeleted()
				Do tempResultSet.Save()
			}
		}
	}
	Do tempResultSet.%SetIterator(0)
	
	// Look at the includes and revincludes, and add to the Bundle those
	// that are referred to by any of the remaining match resources.
	If (tValidIncludesArr) || (tValidRevIncludesArr) {
		While (tempResultSet.NextUndeleted()) {
			If tempResultSet.Mode="match" Continue
			Set resultKey = tempResultSet.Key
			Set resourceType = tempResultSet.ResourceType
			Set resourceId = tempResultSet.ResourceId
			Set resourceVId = tempResultSet.VersionId
			Set referringKeys = ##class(HS.FHIRServer.Util.ReferenceVisitor).GetReferencingIds(resultKey, .lastnContext)
			If referringKeys="" Continue
			Set isReferred = 0
			For listIndex = 1:1:$ListLength(referringKeys) {
				Set referringKey = $ListGet(referringKeys, listIndex)
				If $Data(remainingMatchKeys(referringKey)) {
					Set isReferred = 1
					Quit
				}
			}
			If 'isReferred Continue
			Set resourceObj = pService.interactions.Read(resourceType, resourceId, resourceVId)
			Do returnResultSet.AddRow(resultKey, resourceType, resourceId, resourceVId, tempResultSet.Mode, tempResultSet.Verb, resourceObj)
		}
		Do tempResultSet.%SetIterator(0)
	}
	
	Do returnResultSet.%SetIterator(0)
	
	Return returnResultSet
}

/// Validate the input parameters per $lastn constraints and requirements. Return some
/// derived values for later use. Validation of input parameters per the Search logic
/// for the current strategy will take place when that Search logic is called. 
ClassMethod ValidateRequestInputLastn(pService As HS.FHIRServer.API.Service, pRequest As HS.FHIRServer.API.Data.Request, Output pHasCount0 As %Boolean, Output pMaxPerGroup As %Integer, ByRef pSortKeys, ByRef pErrList) [ Internal ]
{
	// $lastn-specific requirements for query parameters:
	// - Can have only one of either a patient parameter, or a subject search parameter that points to Patient.
	// - Search parameters chained to Patient resource type are not supported.
	// - For R4 and later, a category search parameter and/or a search parameter that contains a code element
	//    in its FHIRpath expression, is required.
	
	Set isSTU3 = (+pService.Schema.FHIRVersion=3)
	
	Set patientParamCount = 0
	Set pHasCount0 = 0
	Set pMaxPerGroup = ""
	Set sortParam = ""
	Set hasCategoryParam = 0
	Set hasCodeParam = 0
	
	// Invalid and unsupported parameters and parameter types are left to be caught
	// in the standard Search logic for the current strategy.
	For paramIndex = pRequest.Parameters.Count():-1:1 {
		#dim searchQueryParameter as HS.FHIRServer.API.SearchQueryParameter = pRequest.Parameters.GetAt(paramIndex)
		Set paramName = searchQueryParameter.name
		Set paramVal = searchQueryParameter.value
		If $IsObject(searchQueryParameter.nextInChain) {
			// Find and flag chained params that chain to Patient resource type.
			If searchQueryParameter.searchParam.target=$ListBuild("Patient") {
				// For example, patient.given=John - not supported
				$$$FHIRAddError(pErrList, $$$ERROR($$$HSFHIRErrLastnChainParamNotSupported, $$$OutcomeNotSupported(400)))
				// Increment patient param count to avoid logging confusing extra error on same param.
				If $i(patientParamCount)
			} ElseIf ($ListFind(searchQueryParameter.searchParam.target, "Patient")) && (searchQueryParameter.modifier="Patient") {
				// For example, subject:Patient.name=John - not supported
				$$$FHIRAddError(pErrList, $$$ERROR($$$HSFHIRErrLastnChainParamNotSupported, $$$OutcomeNotSupported(400)))
				// Increment patient param count to avoid logging confusing extra error on same param.
				If $i(patientParamCount)
			}
			
		} ElseIf (paramName="patient") || (paramName="subject") {
			// Log valid Patient reference param.
			If (paramName="patient") && (paramVal'["/") && (paramVal'="") {
				If $i(patientParamCount)
			} ElseIf ($Length(paramVal, "/")=2) && ($Piece(paramVal, "/", 1)="Patient") && ($Piece(paramVal, "/", 2)'="") {
				If $i(patientParamCount)
			}
		
		} ElseIf paramName="max" {
			// max is not a standard FHIR search param, is specific to $lastn.
			Set pMaxPerGroup = paramVal
			If (+pMaxPerGroup<1) || (pMaxPerGroup'?1N.N) {
				$$$FHIRAddError(pErrList, $$$ERROR($$$HSFHIRErrLastnInvalidMaxFormat, pMaxPerGroup, $$$OutcomeInvalid(400)))
			}
	
		} ElseIf paramName="_sort" {
			Set sortParam = paramVal
			If (sortParam'="") && ($Extract(sortParam,1,10)'="code,-date") {
				$$$FHIRAddError(pErrList, $$$ERROR($$$HSFHIRErrLastnInvalidSort, sortParam, $$$OutcomeInvalid(400)))
			}
			
		} ElseIf paramName="category" {
			Set hasCategoryParam = 1
			
		} ElseIf ((searchQueryParameter.searchParam.fhirPath [ "Observation.code") || (searchQueryParameter.searchParam.fhirPath [ "Observation.component.code")) {
			Set hasCodeParam = 1
			
		} ElseIf paramName="_summary" {
			If paramVal="count" {
				Set pHasCount0 = 1
			}
			
		} ElseIf paramName="_count" {
			If paramVal'="0" {
				// _count is ignored on $lastn when greater than 0.
				//Do pRequest.Parameters.RemoveAt(paramIndex)
			} Else {
				Set pHasCount0 = 1
			}
		}
	}
	
	If pMaxPerGroup="" Set pMaxPerGroup = 1
	
	If 'patientParamCount {
		$$$FHIRAddError(pErrList, $$$ERROR($$$HSFHIRErrLastnMissingPatientParam, $$$OutcomeInvalid(400)))
	} ElseIf patientParamCount>1 {
		$$$FHIRAddError(pErrList, $$$ERROR($$$HSFHIRErrLastnInvalidMultiPatient, $$$OutcomeInvalid(400)))
	} ElseIf ('isSTU3) && ('hasCategoryParam) && ('hasCodeParam) {
		$$$FHIRAddError(pErrList, $$$ERROR($$$HSFHIRErrLastnMissingCategoryOrCode, $$$OutcomeInvalid(400)))
	}
	
	If sortParam="" {
		// Provide default value for sort keys when not present.
		// Temp add a _sort parameter, use existing logic to generate the sortKeys array,
		// then remove _sort from the Parameters collection, so that it does not show up
		// in the self link.
		Set sortParamObj = ##class(HS.FHIRServer.API.SearchQueryParameter).%New("_sort", "code,-date")
		Do pRequest.Parameters.AddParameter(sortParamObj)
		Do pService.ValidateSortKeys(pRequest.Type, pRequest.Parameters, .pSortKeys)
		Do pRequest.Parameters.RemoveParameter(sortParamObj)
	} Else {
		Do pService.ValidateSortKeys(pRequest.Type, pRequest.Parameters, .pSortKeys)
	}
	
	Quit
}

/// Get the Observation dateTime from an Observation resource. Not exactly the same
/// as the Indexer logic. Using this for now, until we get a new Search API to allow
/// for custom SQL columns.
ClassMethod GetObsDateTimeFromResource(pResourceObj As %Library.DynamicObject) As %String [ Internal ]
{
	Set observationDateTime = ""
	
	If pResourceObj.effectiveDateTime'="" {
		Set thisDateTime = pResourceObj.effectiveDateTime
	} ElseIf pResourceObj.effectiveInstant'="" {
		Set thisDateTime = pResourceObj.effectiveInstant
	} ElseIf pResourceObj.effectivePeriod'="" {
		If pResourceObj.effectivePeriod.start'="" {
			Set thisDateTime = pResourceObj.effectivePeriod.start
		} ElseIf pResourceObj.effectivePeriod.end'="" {
			Set thisDateTime = pResourceObj.effectivePeriod.end
		}
	} ElseIf pResourceObj.effectiveTiming'="" {
		// Earliest of all events? Latest of all events?
		// TODO: As of 2020.3 this is problematic, as FHIRServer does not index
		// Observation date if effectiveTiming is the effective value. Therefore
		// resources with such data will be sorted last in the list - presuming
		// that absence of value sorts last.
		Set thisDateTime = ""
	} Else {
		Set thisDateTime = ""
	}
	
	If thisDateTime'="" {
		Set observationDateTime = ##class(HS.FHIRServer.Utils).ConvertToUTC(thisDateTime)
	}
	
	Return observationDateTime
}

/// Process an indiviual result set 'match' row from the initial Observation search result set.
/// Gather the row into an Observation group, as per the FHIR R4 $lastn spec.
ClassMethod ProcessResultRow(pInteractions As HS.FHIRServer.API.Interactions, pResultSet As HS.FHIRServer.Util.SearchResult, pTempResultSet As HS.FHIRServer.Util.SearchResult, pRowNum As %String, pIndexPad As %String, ByRef pGroups, ByRef pResourceObjs, ByRef pLastnContext) [ Internal ]
{
	// Group array gathered across result rows:
	//
	// pGroups("ByGroupNum", groupNum, rowNum) = "" // by rowNum because the result set is secondary sorted by date
	// pGroups("ByPrimaryCodeOrText", codeOrText) = groupNum
	// pGroups("ByCodeOrText", codeOrText) = groupNum
	//
	
	Set indexPadLen = $Length(pIndexPad)
	
	// Read the resource and use the content to get the complete Observation.code data.
	// Store the resource oref in a local array for later reference.
	#dim resourceObj As %Library.DynamicObject = pInteractions.Read(pResultSet.ResourceType, pResultSet.ResourceId)
	
	Set codeList = ..GetObsCode( , resourceObj.code)
	
	If codeList'="" {
		// Just get the first system|code / text.
		Set codeOrText = $ListGet(codeList, 2)
		Set codeOrText = $Piece(codeOrText, "|", 2)_"|"_$Piece(codeOrText, "|", 1)
	} Else {
		// Observation with no code or code text is silently skipped. Even if
		// such a resource was saved to the repo by design, code or code text
		// is required for inclusion in a $lastn query return.
		Return
	}
	
	Set groupNum = $Get(pGroups("ByCodeOrText", codeOrText))
	If groupNum="" {
		Set groupNum = ($Order(pGroups("ByGroupNum", ""), -1) + 1)
	}
	Set pGroups("ByCodeOrText", codeOrText) = groupNum
	Set pGroups("ByGroupNum", groupNum, pRowNum) = ""
	
	// Pad out the code and system so that they sort as desired.
	// For example, so that 787-2 sorts before 18943-3.
	Set p1 = $Piece(codeOrText, "|", 1)
	Set p2 = $Piece(codeOrText, "|", 2)
	set p1 = $Extract(pIndexPad, 1, indexPadLen-$Length(p1))_p1
	set p2 = $Extract(pIndexPad, 1, indexPadLen-$Length(p2))_p2
	Set pGroups("ByPrimaryCodeOrText", p1_"|"_p2) = groupNum
	
	Do pTempResultSet.AddRow(pResultSet.Key, pResultSet.ResourceType, pResultSet.ResourceId, pResultSet.VersionId, pResultSet.Mode, pResultSet.Verb, resourceObj, pResultSet.ReferredToBy)
	
	// *** Set pResourceObjs(pRowNum) = resourceObj
	
	If $Data(pLastnContext) {
		Do ##class(HS.FHIRServer.Util.ReferenceVisitor).VisitAll(resourceObj, .pLastnContext)
	}
	
	Quit
}

ClassMethod GetObsCode(pResultSet As HS.FHIRServer.Util.SearchResult, pCodeableConcept As %Library.DynamicObject) As %List [ Internal ]
{
	Set codes = ""
	
	If $IsObject($Get(pResultSet)) {
		Set codes = pResultSet.%Get("code")
		
	} ElseIf $IsObject($Get(pCodeableConcept)) {
		// Create a list that mimics what you would get if the SQL SELECT
		// statement for the $lastn included a 'code' column.
		
		#dim coding As %Library.DynamicArray
		
		Set codeText = pCodeableConcept.text
		Set coding = pCodeableConcept.coding
		If $IsObject(coding) {
			For codingIndex = 0:1:coding.%Size()-1 {
				Set codingCode = coding.%Get(codingIndex).code
				Set codingSystem = coding.%Get(codingIndex).system
				Set $List(codes, *+1) = codingCode
				Set $List(codes, *+1) = codingSystem_"|"_codingCode
			}
		}
		If (codes="") && (codeText'="") {
			Set codes = $ListBuild(codeText, "|"_codeText)
		}
	}
	
	Return codes
}

}
