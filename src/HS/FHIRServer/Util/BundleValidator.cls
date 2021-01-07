Include HS.FHIRServer

Class HS.FHIRServer.Util.BundleValidator [ Abstract ]
{

ClassMethod ValidateBundle(pResourceObject As %Library.DynamicObject, pFHIRVersion As %String)
{
	// Get the FHIR major version value to handle minor differences in validation
	Set majorVersion = + $E(pFHIRVersion)
	
	// Note: Schema is not needed at this point, all versions have the same validate for bundles.
	Set tSC = $$$OK
	
	
	// Must be a Bundle.
	If pResourceObject.resourceType'="Bundle" {
		Do pErrors.logError("invalid", "error", "Resource type is '"_pResourceObject.resourceType_"', must be Bundle", "/f:"_pResourceObject.resourceType)
		Quit
	}
	
	Set tType = pResourceObject.type
	
	// If the type is invalid or missing then that makes it impossible to correctly
	// validate the rest of the Bundle-level items that we want to validate.
	If (tType="") || '(",document,message,transaction,transaction-response,batch,batch-response,history,searchset,collection,"[(","_tType_",")) {
		$$$ThrowFHIR($$$HSFHIRErrMissingOrInvalidBundleType, tType, $$$OutcomeInvalid(400))
	}
	
	// bdl-1: total only when a search or history.
	Set tTotal = pResourceObject.total
	If tTotal'="" {
		If '((tType="searchset")||(tType="history")) {
			$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrInvalidBundleTotal,tType, $$$OutcomeInvalid(400)))
		}
	} Else {
		If ((tType="searchset")||(tType="history")) {
			$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrMissingBundleTotal,tType, $$$OutcomeInvalid(400)))
		}
	}
	
	if majorVersion >= 3 {
		// !! Not applicable for DSTU2 !!
		// bdl-9: A document must have an identifier with a system and a value
		If tType="document" {
			Set ident = pResourceObject.identifier
			set sys = $Select(ident="":"", 1:ident.system)
			set val = $Select(ident="":"", 1:ident.value)
			If (sys="") || (val="") {
				$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrInvalidBundleIdentifier,sys,val, $$$OutcomeInvalid(400)))
			}
		}
	}
	
	#dim tEntryArray As %DynamicArray
	#dim tEntryIterator As %Iterator.Array
	#dim tEntry As %DynamicObject
	Set tEntryArray = pResourceObject.entry
	Set tEntryIterator = tEntryArray.%GetIterator()
	
	While tEntryIterator.%GetNext(.tArrayIndex, .tEntry) {
		Set tEntryNum = tArrayIndex+1
		
		// bdl-2: entry.search only when a search.
		If $IsObject(tEntry.search) {
			If tType'="searchset" {
				$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrInvalidBundleEntryProperty,tArrayIndex,tType,"search", $$$OutcomeInvalid(400)))
			}
		}
		
		// bdl-3: entry.request when (and only when) a transaction or batch or history.
		Set tRequestMethod = ""
		If $IsObject(tEntry.request) {
			If '((tType="transaction")||(tType="batch")||(tType="history")) {
				$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrInvalidBundleEntryProperty,tArrayIndex,tType,"request", $$$OutcomeInvalid(400)))
			} Else {
				Set tRequestMethod = tEntry.request.method
				If tRequestMethod="" {
					$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrMissingBundleEntryProperty,tArrayIndex,"request.method", $$$OutcomeInvalid(400)))
				} ElseIf '((tRequestMethod="PUT")||(tRequestMethod="POST")||(tRequestMethod="DELETE")||(tRequestMethod="GET")) {
					$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrInvalidBundleEntryPropertyValue,tArrayIndex,tRequestMethod,"request.method", $$$OutcomeInvalid(400)))
				}
				Set tRequestUrl = tEntry.request.url
				If tRequestUrl="" {
					$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrMissingBundleEntryProperty,tArrayIndex,"request.url", $$$OutcomeInvalid(400)))
				} Else {
					Set tIsOK = ##class(HS.HC.Util).IsUUID(tRequestUrl, 1)
					If 'tIsOK Set tIsOK = ##class(HS.HC.Util).IsURL(tRequestUrl, 1)
					If 'tIsOK Set tIsOK = $Extract(tRequestUrl) '= "/"
					// TODO: This pattern is not valid.  First, it does not allow a single element URL (like "Patient").
					// Second, the match on 'P' includes matching slashes, so the pattern is ambiguous.  We should use a RegEx here.
					//If 'tIsOK Set tIsOK = ((tRequestUrl?1ANP.ANP1"/"1ANP.ANP)||(tRequestUrl?1"/"1ANP.ANP))
					If 'tIsOK {
						$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrMissingBundleEntryUrl,tArrayIndex,tRequestUrl, $$$OutcomeInvalid(400)))
					}
				}
			}
			// FHIR Bundle resource specification, details about Transaction/Batch:
			// "If there is no request element, then there SHALL be a resource and the server must
			// infer whether this is a create or an update from the resource identity supplied."
			// Therefore, no action needed here if request property is not present.
		}
		
		// bdl-4: entry.response when (and only when) a transaction-response or batch-response.
		If $IsObject(tEntry.response) {
			If '((tType="transaction-response")||(tType="batch-response")) {
				$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrInvalidBundleEntryProperty,tArrayIndex,tType,"response", $$$OutcomeInvalid(400)))
			}
		} Else {
			If ((tType="transaction-response")||(tType="batch-response")) {
				$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrMissingBundleEntryProperty,tArrayIndex,"response", $$$OutcomeInvalid(400)))
			}
		}
		
		Set tFullUrl = tEntry.fullUrl
		
		// bdl-7: FullUrl must be unique in a bundle, or else entries with the same fullUrl must have different meta.versionId.
		If (tFullUrl'="")&&($Data(tFullUrls(tFullUrl))) {
			$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrDuplicateBundleEntryUrl,tArrayIndex,tFullUrls(tFullUrl), $$$OutcomeInvalid(400)))
		} ElseIf tFullUrl'="" {
			Set tFullUrls(tFullUrl) = tArrayIndex
		}
		
		Set tHasResource = ($IsObject(tEntry.resource))
		If ((tRequestMethod="")||(tRequestMethod="PUT")||(tRequestMethod="POST"))&&('tHasResource) {
			$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrMissingBundleEntryResource,tArrayIndex,tRequestMethod, $$$OutcomeInvalid(400)))
		} ElseIf ((tRequestMethod="GET")||(tRequestMethod="DELETE"))&&(tHasResource) {
			$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrInvalidBundleEntryResource,tArrayIndex,tRequestMethod, $$$OutcomeInvalid(400)))
		}
		
		if majorVersion >= 3 {
			// !! Not applicable for DSTU2 !!
			// bdl-8: On Bundle.entry: fullUrl cannot be a version specific reference
			If tFullUrl["/_history/" {
				$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrInvalidBundleEntryUrl,tArrayIndex,tFullUrl, $$$OutcomeInvalid(400)))
			}
		} else { 
			// !! Applicable for DSTU2 Only!!
			If tHasResource {
				if tFullUrl="" {
					$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrMissingBundleEntryProperty,tArrayIndex,"fullUrl", $$$OutcomeInvalid(400)))
				}	
			} elseif tFullUrl'="" {
				$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrBundleEntryUrlWithoutResource,tArrayIndex, $$$OutcomeInvalid(400)))
			}	

		
		}
		
	
	$$$ThrowOnError( tSC )
}
}

}
