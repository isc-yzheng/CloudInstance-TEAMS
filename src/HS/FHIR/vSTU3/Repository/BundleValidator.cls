Class HS.FHIR.vSTU3.Repository.BundleValidator Extends %RegisteredObject
{

/// API
/// ValidateBundleStream validates a Bundle resource stream. It only validates the Bundle and Bundle
/// entry-specific properties against some FHIR STU3 schema-based requirements and other STU3
/// Bundle-specific rules. It does not validate the resources contained within the Bundle entries.
/// This method performs the validation without requiring the actual use of a schema spec or XSLT2.<br>
/// Input:<br>
/// <li>pContentType    : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pBundleStream   : (required) FHIR Bundle resource stream object.
/// <br>Output:<br>
/// <li>pResourceObject : %DynamicObject or %XML.Document representation of a Bundle resource.
/// <li>pErrors         : HS.Types.FHIR.Errors object that includes a collection of error information.
///                       See <class>HS.Types.FHIR.Errors</class> for more details.<br>
ClassMethod ValidateBundleStream(pContentType As %String, pBundleStream As %Stream.Object, Output pResourceObject, Output pErrors As HS.Types.FHIR.Errors) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pBundleStream))||('pBundleStream.%IsA("%Stream.Object")) {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid Bundle stream input - must be a Stream object")
			Quit
		}
		
		If '$IsObject($Get(pErrors)) Set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		If $ZConvert(pContentType,"L")["json" {
			Set pResourceObject = ##class(%Library.DynamicObject).%FromJSON(pBundleStream)
			If '$IsObject(pResourceObject) {
				Set tSC = $$$ERROR($$$GeneralError, "Unable to create %DynamicObject from JSON stream input")
			}
		} Else {
			Set tSC = ##class(%XML.Document).GetDocumentFromStream(pBundleStream, .pResourceObject)
		}
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..ValidateBundle(pResourceObject, .pErrors)

	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// ValidateBundle validates a Bundle resource %DynamicObject or %XML.Document object. It only
/// validates the Bundle and Bundle entry-specific properties against some FHIR STU3 schema-based
/// requirements and other STU3 Bundle-specific rules. It does not validate the resources contained
/// within the Bundle entries. This method performs the validation without requiring the actual
/// use of a schema spec or XSLT2.<br>
/// Input:<br>
/// <li>pResourceObject : (required) %DynamicObject or %XML.Document representation of a Bundle resource.
/// <br>Output:<br>
/// <li>pErrors         : HS.Types.FHIR.Errors object that includes a collection of error information.
///                       See <class>HS.Types.FHIR.Errors</class> for more details.<br>
ClassMethod ValidateBundle(pResourceObject, Output pErrors As HS.Types.FHIR.Errors) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pErrors)) Set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		// Bundle validation might get called consecutively after some other validation
		// that has already begun populating the pErrors collection. Note the initial error
		// count and check the count again at method end.
		Set tInitialErrorCount = pErrors.Errors.Count()
		
		If pResourceObject.%IsA("%Library.DynamicObject") {
			Set tSC = ..ValidateBundleDynamicObj(pResourceObject, .pErrors)
		} ElseIf pResourceObject.%IsA("%XML.Document") {
			Set tSC = ..ValidateBundleXMLDocument(pResourceObject, .pErrors)
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid FHIR resource object type "_pResourceObject.%ClassName(1))
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If ($$$ISOK(tSC))&&(pErrors.Errors.Count()>tInitialErrorCount) {
		Set tSC = $$$ERROR($$$GeneralError, "Bundle resource failed Bundle validation")
	}
	
	Quit tSC
}

ClassMethod ValidateBundleDynamicObj(pResourceObject As %Library.DynamicObject, Output pErrors As HS.Types.FHIR.Errors) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pErrors)) Set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		// Must be a Bundle.
		If pResourceObject.resourceType'="Bundle" {
			Do pErrors.logError("invalid", "error", "Resource type is '"_pResourceObject.resourceType_"', must be Bundle", "/f:"_pResourceObject.resourceType)
			Quit
		}
		
		Set tType = pResourceObject.type
		
		// If the type is invalid or missing then that makes it impossible to correctly
		// validate the rest of the Bundle-level items that we want to validate.
		If tType="" {
			Do pErrors.logError("required", "error", "Required Bundle type property missing", "/f:Bundle")
			Quit
		} Else {
			If '(",document,message,transaction,transaction-response,batch,batch-response,history,searchset,collection,"[(","_tType_",")) {
				Do pErrors.logError("value", "error", "Invalid Bundle type '"_tType_"'", "/f:Bundle/f:type")
				Quit
			}
		}
		
		// bdl-1: total only when a search or history.
		Set tTotal = pResourceObject.total
		If tTotal'="" {
			If '((tType="searchset")||(tType="history")) {
				Do pErrors.logError("value", "error", tType_" Bundle cannot include total property", "/f:Bundle/f:total")
			}
		} Else {
			If ((tType="searchset")||(tType="history")) {
				Do pErrors.logError("required", "error", "Required "_tType_" Bundle total property missing", "/f:Bundle/f:total")
			}
		}
		
		// bdl-9: A document must have an identifier with a system and a value
		If tType="document" {
			If $IsObject(pResourceObject.identifier) {
				If (pResourceObject.identifier.system="")||(pResourceObject.identifier.value="") {
					Do pErrors.logError("invalid", "error", tType_" Bundle must have identifier with a system and a value", "/f:Bundle/f:identifier")
				}
			} Else {
				Do pErrors.logError("invalid", "error", tType_" Bundle must have identifier with a system and a value", "/f:Bundle/f:identifier")
			}
		}
		
		#dim tEntryArray As %Library.DynamicArray
		#dim tEntryIterator As %Iterator.Array
		#dim tEntry As %Library.DynamicObject
		Set tEntryArray = pResourceObject.entry
		Set tEntryIterator = tEntryArray.%GetIterator()
		
		For {
			Set tBoolean = tEntryIterator.%GetNext(.tArrayIndex, .tEntry)
			If 'tBoolean Quit
			If tArrayIndex="" Quit
			Set tEntryNum = tArrayIndex+1
			
			// bdl-2: entry.search only when a search.
			Set tHasSearch = ($IsObject(tEntry.search))
			If tHasSearch {
				If tType'="searchset" {
					Do pErrors.logError("invalid", "error", tType_" Bundle entry "_tEntryNum_" cannot include search property", "/f:Bundle/f:entry["_tEntryNum_"]")
				}
			}
			
			// bdl-3: entry.request when (and only when) a transaction or batch or history.
			Set tHasRequest = ($IsObject(tEntry.request))
			Set tRequestMethod = ""
			If tHasRequest {
				If '((tType="transaction")||(tType="batch")||(tType="history")) {
					Do pErrors.logError("structure", "error", tType_" Bundle entry cannot include request property", "/f:Bundle/f:entry["_tEntryNum_"]")
				} Else {
					Set tRequestMethod = tEntry.request.method
					If tRequestMethod="" {
						Do pErrors.logError("required", "error", "Required Bundle entry "_tEntryNum_" request method property missing", "/f:Bundle/f:entry["_tEntryNum_"]/f:request")
					} ElseIf '((tRequestMethod="PUT")||(tRequestMethod="POST")||(tRequestMethod="DELETE")||(tRequestMethod="GET")) {
						Do pErrors.logError("value", "error", "Bundle entry "_tEntryNum_" request method invalid value '"_tRequestMethod_"'", "/f:Bundle/f:entry["_tEntryNum_"]/f:request/f:method")
					}
					Set tRequestUrl = tEntry.request.url
					If tRequestUrl="" {
						Do pErrors.logError("required", "error", "Required Bundle entry "_tEntryNum_" request url property missing", "/f:Bundle/f:entry["_tEntryNum_"]/f:request")
					} Else {
						If '..IsValidRequestUrl(tRequestUrl) {
							Do pErrors.logError("value", "error", "Bundle entry "_tEntryNum_" request invalid url value", "/f:Bundle/f:entry["_tEntryNum_"]/f:request/f:url")
						}
					}
				}
				// FHIR Bundle resource specification, details about Transaction/Batch:
				// "If there is no request element, then there SHALL be a resource and the server must
				// infer whether this is a create or an update from the resource identity supplied."
				// Therefore, no action needed here if request property is not present.
			}
			
			// bdl-4: entry.response when (and only when) a transaction-response or batch-response.
			Set tHasResponse = ($IsObject(tEntry.response))
			If tHasResponse {
				If '((tType="transaction-response")||(tType="batch-response")) {
					Do pErrors.logError("invalid", "error", tType_" Bundle entry "_tEntryNum_" cannot include response property", "/f:Bundle/f:entry["_tEntryNum_"]/f:response")
				}
			} Else {
				If ((tType="transaction-response")||(tType="batch-response")) {
					Do pErrors.logError("required", "error", "Required "_tType_" Bundle entry "_tEntryNum_" response property missing", "/f:Bundle/f:entry["_tEntryNum_"]")
				}
			}
			
			Set tFullUrl = tEntry.fullUrl
			
			// bdl-7: FullUrl must be unique in a bundle, or else entries with the same fullUrl must have different meta.versionId.
			If (tFullUrl'="")&&($Data(tFullUrls(tFullUrl))) {
				Do pErrors.logError("invalid", "error", "fullUrl value duplicated between Bundle entries "_(tFullUrls(tFullUrl)+1)_" and "_tEntryNum, "/f:Bundle/f:entry["_tEntryNum_"]/f:fullUrl")
			} ElseIf tFullUrl'="" {
				Set tFullUrls(tFullUrl) = tArrayIndex
			}
			
			Set tHasResource = ($IsObject(tEntry.resource))
			If ((tRequestMethod="PUT")||(tRequestMethod="POST"))&&('tHasResource) {
				Do pErrors.logError("required", "error", "Bundle entry "_tEntryNum_" method is '"_tRequestMethod_"' but is missing required resource property", "/f:Bundle/f:entry["_tEntryNum_"]/f:resource")
			} ElseIf ((tRequestMethod="GET")||(tRequestMethod="DELETE"))&&(tHasResource) {
				Do pErrors.logError("invalid", "error", "Bundle entry "_tEntryNum_" method is '"_tRequestMethod_"' and has resource", "/f:Bundle/f:entry["_tEntryNum_"]/f:resource")
			} ElseIf (tRequestMethod="")&&('tHasResource) {
				// bdl-5: On Bundle.entry: must be a resource unless there's a request or response
				// FHIR Bundle resource specification, details about Transaction/Batch:
				// "If there is no request element, then there SHALL be a resource and the server must
				// infer whether this is a create or an update from the resource identity supplied."
				Do pErrors.logError("invalid", "error", "Bundle entry "_tEntryNum_" has no resource and has no request method", "/f:Bundle/f:entry["_tEntryNum_"]/f:request")
			}
			
			// bdl-8: On Bundle.entry: fullUrl cannot be a version specific reference
			If tFullUrl["/_history/" {
				Do pErrors.logError("invalid", "error", "Bundle entry "_tEntryNum_" fullUrl is version-specific", "/f:Bundle/f:entry["_tEntryNum_"]/f:fullUrl")
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod ValidateBundleXMLDocument(pResourceObject As %XML.Document, Output pErrors As HS.Types.FHIR.Errors) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pErrors)) Set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		#dim tNode As %XML.Node
		
		Set tNode = pResourceObject.GetDocumentElement()
		
		Set tResourceType = tNode.LocalName
		
		// Must be a Bundle.
		If tResourceType'="Bundle" {
			Do pErrors.logError("invalid", "error", "Resource type is '"_tResourceType_"', must be Bundle", "/f:"_tResourceType)
			Quit
		}
		
		If tNode.Namespace'="http://hl7.org/fhir" {
			Do pErrors.logError("structure", "error", "FHIR namespace not found on resource", "/f:"_tResourceType)
			Quit
		}
		
		Set tType = ""
		Set tTotal = ""
		Set tEntryNodes = 0
		Set tIdentifierNode = ""
		
		Set tBoolean = tNode.MoveToFirstChild(1)
		If tBoolean=0 Quit
		
		For {
			Set tPropName = tNode.LocalName
			If tPropName="type" {
				Set tType = tNode.GetAttributeValue("value")
			} ElseIf tPropName="total" {
				Set tTotal = tNode.GetAttributeValue("value")
			} ElseIf tPropName="entry" {
				Set tEntryNodes($i(tEntryNodes)) = tNode.NodeId
			} ElseIf tPropName="identifier" {
				Set tIdentifierNode = tNode.NodeId
			}
			Set tBoolean = tNode.MoveToNextSibling(1)
			If tBoolean=0 Quit
		}
		
		// If the type is invalid or missing then that makes it impossible to correctly
		// validate the rest of the Bundle-level items that we want to validate.
		If tType="" {
			Do pErrors.logError("required", "error", "Required Bundle type property missing", "/f:Bundle")
			Quit
		} Else {
			If '(",document,message,transaction,transaction-response,batch,batch-response,history,searchset,collection,"[(","_tType_",")) {
				Do pErrors.logError("value", "error", "Invalid Bundle type '"_tType_"'", "/f:Bundle/f:type")
				Quit
			}
		}
		
		// bdl-1: total only when a search or history.
		If tTotal'="" {
			If '((tType="searchset")||(tType="history")) {
				Do pErrors.logError("value", "error", tType_" Bundle cannot include total property", "/f:Bundle/f:total")
			}
		} Else {
			If ((tType="searchset")||(tType="history")) {
				Do pErrors.logError("required", "error", "Required "_tType_" Bundle total property missing", "/f:Bundle/f:total")
			}
		}
		
		// bdl-9: A document must have an identifier with a system and a value
		If tType="document" {
			If tIdentifierNode'="" {
				Set tNode.NodeId = tIdentifierNode
				Set tSystem = ""
				Set tValue = ""
				Set tBoolean = tNode.MoveToFirstChild(1)
				If tBoolean=0 Quit
				For {
					Set tPropName = tNode.LocalName
					If tPropName="system" {
						Set tSystem = tNode.GetAttributeValue("value")
					} ElseIf tPropName="value" {
						Set tValue = tNode.GetAttributeValue("value")
					}
					If (tSystem'="")&&(tValue'="") Quit
					Set tBoolean = tNode.MoveToNextSibling(1)
					If tBoolean=0 Quit
				}
				If (tSystem="")||(tValue="") {
					Do pErrors.logError("invalid", "error", tType_" Bundle must have identifier with a system and a value", "/f:Bundle/f:identifier")
				}
			} Else {
				Do pErrors.logError("invalid", "error", tType_" Bundle must have identifier with a system and a value", "/f:Bundle/f:identifier")
			}
		}
		
		For tEntryNum = 1:1:tEntryNodes {
			Set tNode.NodeId = tEntryNodes(tEntryNum)
			Set tSearch = ""
			Set tRequest = ""
			Set tRequestMethod = ""
			Set tRequestUrl = ""
			Set tResponse = ""
			Set tFullUrl = ""
			Set tResource = ""
			
			Set tBoolean = tNode.MoveToFirstChild(1)
			If tBoolean=0 Quit
			
			For {
				Set tPropName = tNode.LocalName
				If tPropName="search" {
					Set tSearch = tNode
				} ElseIf tPropName="request" {
					Set tRequest = tNode
				} ElseIf tPropName="response" {
					Set tResponse = tNode
				} ElseIf tPropName="fullUrl" {
					Set tFullUrl = tNode.GetAttributeValue("value")
				} ElseIf tPropName="resource" {
					Set tResource = tNode
				}
				Set tBoolean = tNode.MoveToNextSibling(1)
				If tBoolean=0 Quit
			}
			
			If $IsObject(tRequest) {
				Set tNode = tRequest
				Set tBoolean = tNode.MoveToFirstChild(1)
				If tBoolean=0 Quit
				For {
					Set tPropName = tNode.LocalName
					If tPropName="method" {
						Set tRequestMethod = tNode.GetAttributeValue("value")
					} ElseIf tPropName="url" {
						Set tRequestUrl = tNode.GetAttributeValue("value")
					}
					Set tBoolean = tNode.MoveToNextSibling(1)
					If tBoolean=0 Quit
				}
			}
			
			// bdl-2: entry.search only when a search.
			Set tHasSearch = ($IsObject(tSearch))
			If tHasSearch {
				If tType'="searchset" {
					Do pErrors.logError("invalid", "error", tType_" Bundle entry "_tEntryNum_" cannot include search property", "/f:Bundle/f:entry["_tEntryNum_"]")
				}
			}
			
			// bdl-3: entry.request when (and only when) a transaction or batch or history.
			Set tHasRequest = ($IsObject(tRequest))
			If tHasRequest {
				If '((tType="transaction")||(tType="batch")||(tType="history")) {
					Do pErrors.logError("structure", "error", tType_" Bundle entry cannot include request property", "/f:Bundle/f:entry["_tEntryNum_"]")
				} Else {
					If tRequestMethod="" {
						Do pErrors.logError("required", "error", "Required Bundle entry "_tEntryNum_" request method property missing", "/f:Bundle/f:entry["_tEntryNum_"]/f:request")
					} ElseIf '((tRequestMethod="PUT")||(tRequestMethod="POST")||(tRequestMethod="DELETE")||(tRequestMethod="GET")) {
						Do pErrors.logError("value", "error", "Bundle entry "_tEntryNum_" request method invalid value '"_tRequestMethod_"'", "/f:Bundle/f:entry["_tEntryNum_"]/f:request/f:method")
					}
					If tRequestUrl="" {
						Do pErrors.logError("required", "error", "Required Bundle entry "_tEntryNum_" request url property missing", "/f:Bundle/f:entry["_tEntryNum_"]/f:request")
					} Else {
						If '..IsValidRequestUrl(tRequestUrl) {
							Do pErrors.logError("value", "error", "Bundle entry "_tEntryNum_" request invalid url value", "/f:Bundle/f:entry["_tEntryNum_"]/f:request/f:url")
						}
					}
				}
				// FHIR Bundle resource specification, details about Transaction/Batch:
				// "If there is no request element, then there SHALL be a resource and the server must
				// infer whether this is a create or an update from the resource identity supplied."
				// Therefore, no action needed here if request property is not present.
			}
			
			// bdl-4: entry.response when (and only when) a transaction-response or batch-response.
			Set tHasResponse = ($IsObject(tResponse))
			If tHasResponse {
				If '((tType="transaction-response")||(tType="batch-response")) {
					Do pErrors.logError("invalid", "error", tType_" Bundle entry "_tEntryNum_" cannot include response property", "/f:Bundle/f:entry["_tEntryNum_"]/f:response")
				}
			} Else {
				If ((tType="transaction-response")||(tType="batch-response")) {
					Do pErrors.logError("required", "error", "Required "_tType_" Bundle entry "_tEntryNum_" response property missing", "/f:Bundle/f:entry["_tEntryNum_"]")
				}
			}
			
			// bdl-7: FullUrl must be unique in a bundle, or else entries with the same fullUrl must have different meta.versionId.
			If (tFullUrl'="")&&($Data(tFullUrls(tFullUrl))) {
				Do pErrors.logError("invalid", "error", "fullUrl value duplicated between Bundle entries "_tFullUrls(tFullUrl)_" and "_tEntryNum, "/f:Bundle/f:entry["_tEntryNum_"]/f:fullUrl")
			} ElseIf tFullUrl'="" {
				Set tFullUrls(tFullUrl) = tEntryNum
			}
			
			Set tHasResource = ($IsObject(tResource))
			If ((tRequestMethod="PUT")||(tRequestMethod="POST"))&&('tHasResource) {
				Do pErrors.logError("required", "error", "Bundle entry "_tEntryNum_" method is '"_tRequestMethod_"' but is missing required resource property", "/f:Bundle/f:entry["_tEntryNum_"]/f:resource")
			} ElseIf ((tRequestMethod="GET")||(tRequestMethod="DELETE"))&&(tHasResource) {
				Do pErrors.logError("invalid", "error", "Bundle entry "_tEntryNum_" method is '"_tRequestMethod_"' and has resource", "/f:Bundle/f:entry["_tEntryNum_"]/f:resource")
			} ElseIf (tRequestMethod="")&&('tHasResource) {
				// bdl-5: On Bundle.entry: must be a resource unless there's a request or response
				// FHIR Bundle resource specification, details about Transaction/Batch:
				// "If there is no request element, then there SHALL be a resource and the server must
				// infer whether this is a create or an update from the resource identity supplied."
				Do pErrors.logError("invalid", "error", "Bundle entry "_tEntryNum_" has no resource and has no request method", "/f:Bundle/f:entry["_tEntryNum_"]/f:request")
			}
			
			// bdl-8: On Bundle.entry: fullUrl cannot be a version specific reference
			If tFullUrl["/_history/" {
				Do pErrors.logError("invalid", "error", "Bundle entry "_tEntryNum_" fullUrl is version-specific", "/f:Bundle/f:entry["_tEntryNum_"]/f:fullUrl")
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// ValidateBundleInternal is for internal use only. It takes the Bundle information input
/// via a specified global structure. This is done to minimize memory usage while processing
/// potentially very large Bundles.
ClassMethod ValidateBundleInternal(pGlobalName As %String, ByRef pErrors As HS.Types.FHIR.Errors) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pErrors)) Set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		// The Bundle-level info is minimal. Pull it into a local array.
		Merge tBundleInfo = @pGlobalName@("BundleInfo")
		
		Set tBundleInfo("resourceType") = $Get(tBundleInfo("resourceType"))
		Set tBundleInfo("type") = $Get(tBundleInfo("type"))
		Set tBundleInfo("total") = $Get(tBundleInfo("total"))
		Set tBundleInfo("identifier.system") = $Get(tBundleInfo("identifier.system"))
		Set tBundleInfo("identifier.value") = $Get(tBundleInfo("identifier.value"))
		
		// Must be a Bundle.
		If tBundleInfo("resourceType")'="Bundle" {
			Do pErrors.logError("invalid", "error", "Resource type is '"_tBundleInfo("resourceType")_"', must be Bundle", "/f:"_tBundleInfo("resourceType"))
			Quit
		}
		
		Set tType = tBundleInfo("type")
		
		// If the type is invalid or missing then that makes it impossible to correctly
		// validate the rest of the Bundle-level items that we want to validate.
		If tType="" {
			Do pErrors.logError("required", "error", "Required Bundle type property missing", "/f:Bundle")
			Quit
		} Else {
			If '(",document,message,transaction,transaction-response,batch,batch-response,history,searchset,collection,"[(","_tType_",")) {
				Do pErrors.logError("value", "error", "Invalid Bundle type '"_tType_"'", "/f:Bundle/f:type")
				Quit
			}
		}
		
		// bdl-1: total only when a search or history.
		Set tTotal = tBundleInfo("total")
		If tTotal'="" {
			If '((tType="searchset")||(tType="history")) {
				Do pErrors.logError("value", "error", tType_" Bundle cannot include total property", "/f:Bundle/f:total")
			}
		} Else {
			If ((tType="searchset")||(tType="history")) {
				Do pErrors.logError("required", "error", "Required "_tType_" Bundle total property missing", "/f:Bundle/f:total")
			}
		}
		
		// bdl-9: A document must have an identifier with a system and a value
		If tType="document" {
			If (tBundleInfo("identifier.system")'="")||(tBundleInfo("identifier.value")'="") {
				If (tBundleInfo("identifier.system")="")||(tBundleInfo("identifier.value")="") {
					Do pErrors.logError("invalid", "error", tType_" Bundle must have identifier with a system and a value", "/f:Bundle/f:identifier")
				}
			} Else {
				Do pErrors.logError("invalid", "error", tType_" Bundle must have identifier with a system and a value", "/f:Bundle/f:identifier")
			}
		}
		
		Set tEntryNum = ""
		
		For {
			Set tEntryNum = $Order(@pGlobalName@("EntryInfo",tEntryNum))
			If tEntryNum="" Quit
			
			// Bundle entry-level info is populated into a local array only one entry at a time.
			Merge tEntryInfo(tEntryNum) = @pGlobalName@("EntryInfo",tEntryNum)
			
			Set tEntryInfo(tEntryNum, "request.ResourceStreamId") = $Get(tEntryInfo(tEntryNum, "request.ResourceStreamId"))
			Set tEntryInfo(tEntryNum, "request", "method") = $Get(tEntryInfo(tEntryNum, "request", "method"))
			Set tEntryInfo(tEntryNum, "request", "url") = $Get(tEntryInfo(tEntryNum, "request", "url"))
			Set tEntryInfo(tEntryNum, "fullUrl") = $Get(tEntryInfo(tEntryNum, "fullUrl"))
			Set tEntryInfo(tEntryNum, "search") = $Get(tEntryInfo(tEntryNum, "search"))
			Merge tEntryInfo(tEntryNum, "response") = tEntryInfo(tEntryNum, "response")
			Set tEntryInfo(tEntryNum, "response.ResourceStreamId") = $Get(tEntryInfo(tEntryNum, "response.ResourceStreamId"))
			
			// bdl-2: entry.search only when a search.
			Set tHasSearch = (tEntryInfo(tEntryNum, "search")'="")
			If tHasSearch {
				If tType'="searchset" {
					Do pErrors.logError("invalid", "error", tType_" Bundle entry "_tEntryNum_" cannot include search property", "/f:Bundle/f:entry["_tEntryNum_"]")
				}
			}
			
			// bdl-3: entry.request when (and only when) a transaction or batch or history.
			Set tHasRequest = ((tEntryInfo(tEntryNum,"request","method")'="")||(tEntryInfo(tEntryNum,"request","url")'=""))
			Set tRequestMethod = ""
			If tHasRequest {
				If '((tType="transaction")||(tType="batch")||(tType="history")) {
					Do pErrors.logError("structure", "error", tType_" Bundle entry cannot include request property", "/f:Bundle/f:entry["_tEntryNum_"]")
				} Else {
					Set tRequestMethod = tEntryInfo(tEntryNum,"request","method")
					If tRequestMethod="" {
						Do pErrors.logError("required", "error", "Required Bundle entry "_tEntryNum_" request method property missing", "/f:Bundle/f:entry["_tEntryNum_"]/f:request")
					} ElseIf '((tRequestMethod="PUT")||(tRequestMethod="POST")||(tRequestMethod="DELETE")||(tRequestMethod="GET")) {
						Do pErrors.logError("value", "error", "Bundle entry "_tEntryNum_" request method invalid value '"_tRequestMethod_"'", "/f:Bundle/f:entry["_tEntryNum_"]/f:request/f:method")
					}
					Set tRequestUrl = tEntryInfo(tEntryNum,"request","url")
					If tRequestUrl="" {
						Do pErrors.logError("required", "error", "Required Bundle entry "_tEntryNum_" request url property missing", "/f:Bundle/f:entry["_tEntryNum_"]/f:request")
					} Else {
						If '..IsValidRequestUrl(tRequestUrl) {
							Do pErrors.logError("value", "error", "Bundle entry "_tEntryNum_" request invalid url value", "/f:Bundle/f:entry["_tEntryNum_"]/f:request/f:url")
						}
					}
				}
				// FHIR Bundle resource specification, details about Transaction/Batch:
				// "If there is no request element, then there SHALL be a resource and the server must
				// infer whether this is a create or an update from the resource identity supplied."
				// Therefore, no action needed here if request property is not present.
			}
			
			// bdl-4: entry.response when (and only when) a transaction-response or batch-response.
			Set tHasResponse = $Data(tEntryInfo(tEntryNum, "response"))
			If tHasResponse {
				If '((tType="transaction-response")||(tType="batch-response")) {
					Do pErrors.logError("invalid", "error", tType_" Bundle entry "_tEntryNum_" cannot include response property", "/f:Bundle/f:entry["_tEntryNum_"]/f:response")
				}
			} Else {
				If ((tType="transaction-response")||(tType="batch-response")) {
					Do pErrors.logError("required", "error", "Required "_tType_" Bundle entry "_tEntryNum_" response property missing", "/f:Bundle/f:entry["_tEntryNum_"]")
				}
			}
			
			Set tFullUrl = tEntryInfo(tEntryNum, "fullUrl")
			
			// bdl-7: FullUrl must be unique in a bundle, or else entries with the same fullUrl must have different meta.versionId.
			If (tFullUrl'="")&&($Data(tFullUrls(tFullUrl))) {
				Do pErrors.logError("invalid", "error", "fullUrl value duplicated between Bundle entries "_tFullUrls(tFullUrl)_" and "_tEntryNum, "/f:Bundle/f:entry["_tEntryNum_"]/f:fullUrl")
			} ElseIf tFullUrl'="" {
				Set tFullUrls(tFullUrl) = tEntryNum
			}
			
			Set tHasResource = (tEntryInfo(tEntryNum, "request.ResourceStreamId")'="")
			If ((tRequestMethod="PUT")||(tRequestMethod="POST"))&&('tHasResource) {
				Do pErrors.logError("required", "error", "Bundle entry "_tEntryNum_" method is '"_tRequestMethod_"' but is missing required resource property", "/f:Bundle/f:entry["_tEntryNum_"]/f:resource")
			} ElseIf ((tRequestMethod="GET")||(tRequestMethod="DELETE"))&&(tHasResource) {
				Do pErrors.logError("invalid", "error", "Bundle entry "_tEntryNum_" method is '"_tRequestMethod_"' and has resource", "/f:Bundle/f:entry["_tEntryNum_"]/f:resource")
			} ElseIf (tRequestMethod="")&&('tHasResource) {
				// bdl-5: On Bundle.entry: must be a resource unless there's a request or response
				// FHIR Bundle resource specification, details about Transaction/Batch:
				// "If there is no request element, then there SHALL be a resource and the server must
				// infer whether this is a create or an update from the resource identity supplied."
				Do pErrors.logError("invalid", "error", "Bundle entry "_tEntryNum_" has no resource and has no request method", "/f:Bundle/f:entry["_tEntryNum_"]/f:request")
			}
			
			// bdl-8: On Bundle.entry: fullUrl cannot be a version specific reference
			If tFullUrl["/_history/" {
				Do pErrors.logError("invalid", "error", "Bundle entry "_tEntryNum_" fullUrl is version-specific", "/f:Bundle/f:entry["_tEntryNum_"]/f:fullUrl")
			}
			
			Kill tEntryInfo(tEntryNum)
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Common logic for validating Bundle request url. It should be
/// a valid UUID, or a full URL, or just a resource type, or a
/// resource type plus identifier.
ClassMethod IsValidRequestUrl(pString As %String) As %Boolean
{
	// Passing pString by reference for performance gain.
	If pString="" Quit 0
	If $Extract(pString,1,9)="urn:uuid:" Quit ##class(HS.HC.Util).IsUUID(.pString)
	If $Extract(pString,1,4)="urn:" Quit 0
	If ##class(HS.HC.Util).IsURL(.pString) Quit 1
	If $Length(pString,"/")=1 {
		Set tResourceType = pString
	} Else {
		Set tResourceType = $Piece(pString, "/", *-1)
	}
	Set tSC = ##class(HS.FHIR.Utils).ValidateResourceTypeFHIR(tResourceType, "HS.FHIR.vSTU3.Model.Resource", .tIsValid)
	If $$$ISERR(tSC) Quit 0
	Quit tIsValid
}

}
