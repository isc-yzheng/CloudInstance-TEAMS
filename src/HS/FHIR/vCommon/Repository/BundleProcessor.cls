Include HS.HC

Class HS.FHIR.vCommon.Repository.BundleProcessor [ Abstract ]
{

/// Class that provides the FHIR Bundle resource validation logic for this Bundle processing
/// class. The class is intended to handle Bundle-specific validation, i.e., the rules
/// applying to transaction, batch, document, and message Bundles.
Parameter BundleValidatorClass As %String [ Abstract ];

/// The class to use for handling direct interaction with the desired data and storage model.
Parameter StorageClass As %String [ Abstract ];

ClassMethod ProcessBundle(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response, pRepositoryOperations) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		Set tBundleStream = pRequest.GetPayloadOref()
		
		If tBundleStream.Size=0 {
			Set tText = "FHIR transaction request missing payload"
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", "FHIR transaction request missing payload")
			Quit
		}
		
		Set tResponseStream = pResponse.GetPayloadOref()
		
		If pRequest.ContentType["json" {
			Set tContentType = "json"
		} Else {
			Set tContentType = "xml"
		}
		
		// A prime goal of the FHIR Bundle processing design is to be able to scale to
		// very large Bundles of input. Speed of processing should be maximized but more
		// importantly the processing should take as little process memory as possible.
		//
		// For speed, stream parsing is used to obtain important metadata about the Bundle
		// and about the entries in the Bundle. Due to complexities in parsing entry-level
		// information from JSON, %DynamicObject is used to obtain JSON entry-level info.
		//
		// For reducing memory usage, all metadata about the Bundle and its entries, and
		// the entry resource streams themselves, are held in Temp globals and QuickStreams,
		// and passed around among the methods whose name ends in "Internal".
		//
		// The name of the Temp global is a variable that is determined by this method.
		// The global name is passed to all Bundle-handling methods that this method calls.
		// Structure of the global:
		// @tGlobalName@("BundleInfo","resourceType")
		// @tGlobalName@("BundleInfo","type")
		// @tGlobalName@("BundleInfo","total")
		// @tGlobalName@("BundleInfo","identifier.system")
		// @tGlobalName@("BundleInfo","identifier.value")
		// 
		// @tGlobalName@("EntryInfo",entrynumber,"request.ResourceStreamId")
		// @tGlobalName@("EntryInfo",entrynumber,"fullUrl")
		// @tGlobalName@("EntryInfo",entrynumber,"request","method")
		// @tGlobalName@("EntryInfo",entrynumber,"request","url")
		// @tGlobalName@("EntryInfo",entrynumber,"request","ifNoneMatch")
		// @tGlobalName@("EntryInfo",entrynumber,"request","ifModifiedSince")
		// @tGlobalName@("EntryInfo",entrynumber,"request","ifMatch")
		// @tGlobalName@("EntryInfo",entrynumber,"request","ifNoneExist")
		// @tGlobalName@("EntryInfo",entrynumber,"resource.id")
		// @tGlobalName@("EntryInfo",entrynumber,"resource.id_old")
		// @tGlobalName@("EntryInfo",entrynumber,"resource.resourceType")
		// @tGlobalName@("EntryInfo",entrynumber,"response","location")
		// @tGlobalName@("EntryInfo",entrynumber,"response","etag")
		// @tGlobalName@("EntryInfo",entrynumber,"response","status")
		// @tGlobalName@("EntryInfo",entrynumber,"response","lastModified")
		// @tGlobalName@("EntryInfo",entrynumber,"response.ResourceStreamId")
		// 
		// @tGlobalName@("ReferencesByReference",oldreferencevalue) = newreferencevalue
		// @tGlobalName@("ReferencesByEntry",entrynumber,oldreferencevalue) = ""
		
		Set tGlobalName = "^CacheTemp.FHIR"
		If $i(@tGlobalName)
		Set tGlobalName = tGlobalName_"("_@tGlobalName_")"
		Kill @tGlobalName
		
		// Extract Bundle and entry metadata into the temp global, validate the Bundle
		// specific requirements, and for transaction Bundles update the resource ids
		// and references as needed.
		If tContentType="json" {
			Set tSC = ..PrepareBundleJSON(pRequest, .pResponse, .tErrors, tGlobalName)
		} Else {
			Set tSC = ..PrepareBundleXML(pRequest, .pResponse, .tErrors, tGlobalName)
		}
		If $$$ISERR(tSC) Quit
		
		If tErrors.Errors.Count() {
			Set tSC = tErrors.GenerateOperationOutcomeStream(pRequest.ContentType, pRequest.FormatFHIROutput, .tResponseStream)
			If $$$ISOK(tSC) {
				Set pResponse.Status = 400
				Set pResponse.Type = "OperationOutcome"
			}
			Quit
		}
		
		Set tBundleType = @tGlobalName@("BundleInfo","type")
		
		If tBundleType="transaction" {
			Set tSC = ..ProcessTransactionBundle(pRequest, .pResponse, pRepositoryOperations, tGlobalName)
		} ElseIf tBundleType="batch" {
			Set tSC = ..ProcessBatchBundle(pRequest, .pResponse, pRepositoryOperations, tGlobalName)
		} ElseIf tBundleType="document" {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", "Invalid Bundle type "_$Select(tBundleType'="":tBundleType,1:"(blank)")_" on transaction")
		} ElseIf tBundleType="message" {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", "Invalid Bundle type "_$Select(tBundleType'="":tBundleType,1:"(blank)")_" on transaction")
		} Else {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", "Invalid Bundle type "_$Select(tBundleType'="":tBundleType,1:"(blank)")_" on transaction")
		}
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If $Get(tGlobalName)'="" Kill @tGlobalName
	
	Quit tSC
}

/// PrepareBundleJSON extracts information about the Bundle and its entries from the JSON
/// Bundle stream, validates Bundle-specific requirements, and for transaction Bundles
/// updates resource references and resource ids as needed.
ClassMethod PrepareBundleJSON(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response, ByRef pErrors As HS.Types.FHIR.Errors, pGlobalName As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pErrors)) Set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		Set tBundleStream = pRequest.GetPayloadOref()
		
		Set tSC = ..GetBundleInfoJSON(tBundleStream, pGlobalName)
		If $$$ISERR(tSC) Quit
		
		// With the JSON streams, we have not yet extracted the entry-level information.
		// Also with JSON streams, the QuickStreams start out with the entire entry, as
		// opposed to just the resource (if any). After extracting the data we need,
		// reduce the QuickStream to just the resource.
		If $Get(@pGlobalName@("EntryInfo"))>0 {
			For i = 1:1:@pGlobalName@("EntryInfo") {
				If $Get(@pGlobalName@("EntryInfo",i,"request.ResourceStreamId"))'="" {
					Set tQStream = ##class(HS.SDA3.QuickStream).%OpenId(@pGlobalName@("EntryInfo",i,"request.ResourceStreamId"))
					Set tJSONObject = ##class(%Library.DynamicObject).%FromJSON(tQStream)
					Set @pGlobalName@("EntryInfo",i,"fullUrl") = tJSONObject.fullUrl
					Set @pGlobalName@("EntryInfo",i,"request","method") = tJSONObject.request.method
					Set @pGlobalName@("EntryInfo",i,"request","url") = tJSONObject.request.url
					Set @pGlobalName@("EntryInfo",i,"request","ifNoneMatch") = tJSONObject.request.ifNoneMatch
					Set @pGlobalName@("EntryInfo",i,"request","ifModifiedSince") = tJSONObject.request.ifModifiedSince
					Set @pGlobalName@("EntryInfo",i,"request","ifMatch") = tJSONObject.request.ifMatch
					Set @pGlobalName@("EntryInfo",i,"request","ifNoneExist") = tJSONObject.request.ifNoneExist
					If $IsObject(tJSONObject.resource) {
						Set @pGlobalName@("EntryInfo",i,"resource.id") = tJSONObject.resource.id
						Set @pGlobalName@("EntryInfo",i,"resource.id_old") = tJSONObject.resource.id
						Set @pGlobalName@("EntryInfo",i,"resource.resourceType") = tJSONObject.resource.resourceType
						Do tQStream.Clear(0)
						Do tJSONObject.resource.%ToJSON(.tQStream)
						Do tQStream.Rewind()
						// If no resource, then get rid of the QuickStream and the pointer to it.
						If tQStream.Size=0 {
							Do tQStream.Clear()
							Set @pGlobalName@("EntryInfo",i,"request.ResourceStreamId")=""
						}
					} Else {
						// If no resource, then get rid of the QuickStream and the pointer to it.
						Set @pGlobalName@("EntryInfo",i,"resource.id") = ""
						Set @pGlobalName@("EntryInfo",i,"resource.id_old") = ""
						Set @pGlobalName@("EntryInfo",i,"resource.resourceType") = ""
						Do tQStream.Clear()
						Set @pGlobalName@("EntryInfo",i,"request.ResourceStreamId")=""
					}
					Kill tJSONObject
				}
			}
		}
		
		// Validate the Bundle according to the FHIR rules for Bundles.  Use the
		// pGlobalName-stored data as the basis for the validation.
		Set tSC = $ClassMethod(..#BundleValidatorClass, "ValidateBundleInternal", pGlobalName, .pErrors)
		If ($$$ISERR(tSC))||(pErrors.Errors.Count()) Quit
		
		Set tBundleType = @pGlobalName@("BundleInfo","type")
		
		If tBundleType="transaction" {
			Set tSC = ..UpdateReferences(pRequest, .pResponse, .pErrors, pGlobalName)
			If $$$ISERR(tSC) Quit
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod UpdateReferences(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response, ByRef pErrors As HS.Types.FHIR.Errors, pGlobalName As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Try {
		// If no references found in any resources, then no need for this.
		If $Data(@pGlobalName@("ReferencesByReference"))'>9 Quit
		
		Set tSC = ..ConvertReferences(pRequest, .pResponse, .pErrors, pGlobalName)
		If ($$$ISERR(tSC))||(pErrors.Errors.Count()) Quit
		
		// Remove references that will not get updated.
		Set tRef = ""
		For {
			Set tRef = $Order(@pGlobalName@("ReferencesByReference",tRef))
			If tRef="" Quit
			If @pGlobalName@("ReferencesByReference",tRef)="" {
				Kill @pGlobalName@("ReferencesByReference",tRef)
			}
		}
		
		// For entries that have a resource payload that includes references
		// that need to be updated, call UpdateRefsAndIdInPayload to update the
		// references now.
		For i = 1:1:@pGlobalName@("EntryInfo") {
			If $Get(@pGlobalName@("EntryInfo",i,"request.ResourceStreamId"))'="" {
				Set tResourceType = $Get(@pGlobalName@("EntryInfo",i,"resource.resourceType"))
				Set tOldResourceId = $Get(@pGlobalName@("EntryInfo",i,"resource.id_old"))
				Set tNewResourceId = $Get(@pGlobalName@("EntryInfo",i,"resource.id"))
				Set tNeedsUpdate = (tOldResourceId'=tNewResourceId)
				
				If 'tNeedsUpdate {
					Set tRef = ""
					For {
						Set tRef = $Order(@pGlobalName@("ReferencesByEntry",i,tRef))
						If tRef="" Quit
						If $Get(@pGlobalName@("ReferencesByReference",tRef))="" {
							Kill @pGlobalName@("ReferencesByEntry",i,tRef)
							Continue
						} Else {
							Set tNeedsUpdate = 1 Quit
						}
					}
				}
				
				If tNeedsUpdate {
					// Parse the resource stream and replace the reference values and
					// resource id as needed, producing a new stream.
					Set tQStream = ##class(HS.SDA3.QuickStream).%OpenId(@pGlobalName@("EntryInfo",i,"request.ResourceStreamId"))
					Set tQStream2 = ##class(HS.SDA3.QuickStream).%New()
					Set @pGlobalName@("EntryInfo",i,"request.ResourceStreamId") = tQStream2.%Id()
					Set tSC = ..UpdateRefsAndIdInPayload(pRequest.ContentType, tResourceType, tQStream, tOldResourceId, tNewResourceId, tQStream2, pGlobalName)
					If $$$ISERR(tSC) Quit
					Do tQStream.Clear()
					Kill tQStream
					Do tQStream2.Rewind()
				}
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// GetBundleInfoJSON parses the specified FHIR Bundle stream and stores information
/// about it in a global, whose name is indicated by the pGlobalName input variable.
ClassMethod GetBundleInfoJSON(pBundleStream As %Stream.Object, pGlobalName As %String)
{
	Set tSC = $$$OK
	
	Try {
		Set tResourceType = ""
		Set tBundleType = ""
		Set tBundleTotal = ""
		Set tIdentifierSystem = ""
		Set tIdentifierValue = ""
		
		Set @pGlobalName@("BundleInfo","resourceType") = ""
		Set @pGlobalName@("BundleInfo","type") = ""
		Set @pGlobalName@("BundleInfo","total") = ""
		Set @pGlobalName@("BundleInfo","identifier.system") = ""
		Set @pGlobalName@("BundleInfo","identifier.value") = ""
		
		Set tTab = $Char(9)
		Set tLF = $Char(10)
		Set tCR = $Char(13)
		
		Set tWhitespace(" ") = ""
		Set tWhitespace(tTab) = ""
		Set tWhitespace(tLF) = ""
		Set tWhitespace(tCR) = ""
		
		Set tEntryNum = 0
		
		Set tInEntries = 0
		
		Set tInFullUrl = 0
		Set tInResource = 0
		Set tInResourceType = 0
		Set tInBundleType = 0
		Set tInBundleTotal = 0
		Set tInResourceId = 0
		Set tInIdentifier = 0
		Set tInIdentifierSystem = 0
		Set tInIdentifierValue = 0
		Set tInRequest = 0
		Set tInRequestMethod = 0
		Set tInRequestUrl = 0
		
		Set tMaxBuf = $$$MaxLocalLength

		Set tPropName = ""
		Set tPropVal = ""
		
		Set tInEntry = 0
		
		Set tLeftCurlyBraceCount = 0
		Set tIdentifierSquareBracketCount = 0
		
		Set tInPropName = 0
		Set tInPropVal = 0
		Set tIndentLevel = 0
		Set tReadBuffer = ""
		Set tWriteBuffer = ""
		Set tTab = $Char(9)
		Set tLF = $Char(10)
		Set tCR = $Char(13)
		Set tChar = ""
		Set tPrevChar = ""
		Set tPrevPrevChar = ""
		Set tPrevNonWSChar = ""
		Set tInCollection = 0
		
		// tJSONChars have special meaning when outside of
		// a property/object name and property value.
		Set tJSONChars(tTab)=""
		Set tJSONChars(tLF)=""
		Set tJSONChars(tCR)=""
		Set tJSONChars(" ")=""
		Set tJSONChars("[")=""
		Set tJSONChars("]")=""
		Set tJSONChars("{")=""
		Set tJSONChars("}")=""
		Set tJSONChars(",")=""
		Set tJSONChars("""")=""
		
		Set tInReference = 0
		Set tReferenceBuffer = ""
		
		Set tChar = pBundleStream.Read(1,.tSC)
		If $$$ISERR(tSC) Quit
		
		Set tPrevChar = tChar
		
		For {
			Set tString = pBundleStream.Read( , .tSC)
			If $$$ISERR(tSC) Quit
			For tPosition = 1:1:$Length(tString) {
				Set tPrevPrevChar = tPrevChar
				Set tPrevChar = tChar
				If '$Data(tWhitespace(tPrevChar)) Set tPrevNonWSChar = tPrevChar
				Set tChar = $Extract(tString,tPosition)
				
				If tInEntries {
					// If we have not yet hit the start of an entry object, or we are
					// currently between entry objects, then a right square bracket
					// means we are done with all entries. Otherwise, anything else
					// except a left curly brace is to be ignored.
					If tLeftCurlyBraceCount=0 {
						If tChar="]" Set tInEntries = 0 Set tReadBuffer = "" Continue
						If tChar'="{" Continue
						// We've found a left curly brace, start gathering data for a new entry.
						Set tLeftCurlyBraceCount = tLeftCurlyBraceCount + 1
						Set tEntryNum = tEntryNum + 1
						Set tCurrentQuickStream = ##class(HS.SDA3.QuickStream).%New()
						Set @pGlobalName@("EntryInfo") = tEntryNum
						Set @pGlobalName@("EntryInfo",tEntryNum,"request.ResourceStreamId") = tCurrentQuickStream.%Id()
						Set tAddChars = tChar Do Write
						Continue
					}
					
					// This is not a character that needs any special processing.
					If $Data(tJSONChars(tChar))=0 {
						Set tAddChars = tChar Do Write
						Set tReferenceBuffer = tReferenceBuffer_tChar
						If 'tInReference {
							If $Length(tReferenceBuffer)>13 Set tReferenceBuffer = $Extract(tReferenceBuffer,2,*)
							If tReferenceBuffer="""reference"":""" {
								Set tReferenceBuffer = ""
								Set tInReference = 1
							}
						}
						Continue
					}
					
					// Handle the escape character (backslash).
					If (tInPropVal)&&((tChar'="""")||((tPrevChar="\")&&(tPrevPrevChar'="\"))) {
						Set tAddChars = tChar Do Write
						Set tReferenceBuffer = tReferenceBuffer_tChar
						If $Length(tReferenceBuffer)>13 Set tReferenceBuffer = $Extract(tReferenceBuffer,2,*)
						If tReferenceBuffer="""reference"":""" {
							Set tReferenceBuffer = ""
							Set tInReference = 1
						}
						Continue
					}
					
					// Write out space or tab or line feed or carriage return only when we
					// are inside a property value.
					If $Data(tWhitespace(tChar)) {
						If tInPropVal {
							Set tAddChars = tChar Do Write
						}
						Continue
					}
					
					// A quote here can signal either start or end of a property name
					// or the start or end of a property value.
					If tChar="""" {
						If ('tInPropVal)&&(tPrevNonWSChar=":") {
							Set tInPropVal=1
						} ElseIf tInPropName {
							Set tInPropName=0
						} ElseIf tInPropVal {
							Set tInPropVal=0
						} ElseIf ((tPrevNonWSChar=",")&&(tInCollection))||(tPrevNonWSChar="[") {
							Set tInPropVal = 1
						} Else {
							Set tInPropName=1
						}
						Set tAddChars = tChar Do Write
						If tInReference {
							Set @pGlobalName@("ReferencesByReference",tReferenceBuffer) = ""
							Set @pGlobalName@("ReferencesByEntry",tEntryNum,tReferenceBuffer) = ""
							Set tReferenceBuffer = ""
							Set tInReference = 0
						} Else {
							Set tReferenceBuffer = tReferenceBuffer_tChar
							If $Length(tReferenceBuffer)>13 Set tReferenceBuffer = $Extract(tReferenceBuffer,2,*)
							If tReferenceBuffer="""reference"":""" {
								Set tReferenceBuffer = ""
								Set tInReference = 1
							}
						}
						Continue
					}
					
					// A comma inside a property value is just text, otherwise it
					// is a delimiter before the next property or property value.
					If tChar="," {
						Set tAddChars = tChar Do Write
						Continue
					}
					
					If tChar="{" {
						If ('tInPropName)&&('tInPropVal) Set tLeftCurlyBraceCount = tLeftCurlyBraceCount + 1
						If tLeftCurlyBraceCount=1 {
							Set tEntryNum = tEntryNum + 1
							Set tCurrentQuickStream = ##class(HS.SDA3.QuickStream).%New()
							Set @pGlobalName@("EntryInfo") = tEntryNum
							Set @pGlobalName@("EntryInfo",tEntryNum,"request.ResourceStreamId") = tCurrentQuickStream.%Id()
						}
						Set tAddChars = tChar Do Write
						Continue
					}
					
					If tChar="[" {
						Set tInCollection = 1
						Set tAddChars = tChar Do Write
						Continue
					}
					
					If ('tInPropVal)&&((tChar=tLF)||(tChar=tCR)) Continue
					
					If tChar="]"!(tChar="}") {
						Set tAddChars = tChar Do Write
						If tChar="]" Set tInCollection = 0
						If tChar="}" {
							If ('tInPropName)&&('tInPropVal) Set tLeftCurlyBraceCount = tLeftCurlyBraceCount - 1
							If (tLeftCurlyBraceCount=0)&&(tWriteBuffer'="") {
								Do tCurrentQuickStream.Write(tWriteBuffer)
								Do tCurrentQuickStream.Rewind()
								Set tWriteBuffer = ""
							}
						}
						Continue
					}
					
				} Else { // Not In Entries
					If '$Data(tWhitespace(tChar)) {
						Set tReadBuffer = tReadBuffer_tChar
						If $Length(tReadBuffer)>20 Set tReadBuffer = $Extract(tReadBuffer,2,*)
						If $Extract(tReadBuffer,*-8,*)="""entry"":[" {
							Set tInEntries = 1
							Set tReadBuffer = ""
						} ElseIf tInResourceType {
							If tChar'="""" {
								Set tResourceType = tResourceType_tChar
							} Else {
								Set tInResourceType = 0
							}
						} ElseIf tInBundleType {
							If tChar'="""" {
								Set tBundleType = tBundleType_tChar
							} Else {
								Set tInBundleType = 0
							}
						} ElseIf tInBundleTotal {
							If tChar?1N {
								Set tBundleTotal = tBundleTotal_tChar
							} Else {
								Set tInBundleTotal = 0
							}
						} ElseIf $Extract(tReadBuffer,*-15,*)="""resourceType"":""" {
							Set tInResourceType = 1
						} ElseIf $Extract(tReadBuffer,*-7,*)="""type"":""" {
							Set tInBundleType = 1
						} ElseIf $Extract(tReadBuffer,*-7,*)="""total"":" {
							Set tInBundleTotal = 1
						} ElseIf tInIdentifier {
							If tChar="]" {
								Set tIdentifierSquareBracketCount = tIdentifierSquareBracketCount - 1
							} ElseIf tChar="[" {
								Set tIdentifierSquareBracketCount = tIdentifierSquareBracketCount + 1
							}
							If tIdentifierSquareBracketCount=0 {
								Set tInIdentifier = 0
							} Else {
								If tInIdentifierSystem {
									If tChar'="""" {
										Set tIdentifierSystem = tIdentifierSystem_tChar
									} Else {
										Set tInIdentifierSystem = 0
									}
								} ElseIf tInIdentifierValue {
									If tChar'="""" {
										Set tIdentifierValue = tIdentifierValue_tChar
									} Else {
										Set tInIdentifierValue = 0
									}
								} ElseIf $Extract(tReadBuffer,*-9,*)="""system"":""" {
									Set tInIdentifierSystem = 1
								} ElseIf $Extract(tReadBuffer,*-8,*)="""value"":""" {
									Set tInIdentifierValue = 1
								}
							}
						} ElseIf $Extract(tReadBuffer,*-13,*)="""identifier"":[" {
							If (tIdentifierSystem="")&&(tIdentifierValue="") {
								Set tInIdentifier = 1
								Set tIdentifierSquareBracketCount = 1
							}
						}		
					}
				}
			}
			
			If pBundleStream.AtEnd Quit
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Set @pGlobalName@("BundleInfo","resourceType") = tResourceType
	Set @pGlobalName@("BundleInfo","type") = tBundleType
	Set @pGlobalName@("BundleInfo","total") = tBundleTotal
	Set @pGlobalName@("BundleInfo","identifier.system") = tIdentifierSystem
	Set @pGlobalName@("BundleInfo","identifier.value") = tIdentifierValue
	
	Quit tSC
	
Write
	If ($Length(tWriteBuffer)+$Length(tAddChars))>tMaxBuf Do tCurrentQuickStream.Write(tWriteBuffer) Set tWriteBuffer = ""
	Set tWriteBuffer = tWriteBuffer_tAddChars
	Quit
}

/// PrepareBundleJSON extracts information about the Bundle and its entries from the XML
/// Bundle stream, validates Bundle-specific requirements, and for transaction Bundles
/// updates resource references and resource ids as needed.
ClassMethod PrepareBundleXML(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response, ByRef pErrors As HS.Types.FHIR.Errors, pGlobalName As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pErrors)) Set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		Set tBundleStream = pRequest.GetPayloadOref()
		
		Set tSC = ..GetBundleInfoXML(tBundleStream, pGlobalName)
		If $$$ISERR(tSC) Quit
		
		If $Get(@pGlobalName@("EntryInfo"))>0 {
			For i = 1:1:@pGlobalName@("EntryInfo") {
				Set @pGlobalName@("EntryInfo",i,"resource.id_old") = $Get(@pGlobalName@("EntryInfo",i,"resource.id"))
				Set tURL = $Piece($Get(@pGlobalName@("EntryInfo",i,"fullUrl")),"/",*)
				If tURL="" Set tURL = $Get(@pGlobalName@("EntryInfo",i,"resource.id"))
				If tURL="" Set tURL = $Piece($Get(@pGlobalName@("EntryInfo",i,"request","url")),"/",*)
				Set tIsUUID = ##class(HS.HC.Util).IsUUID(tURL,0)
			}
		}
		
		// Validate the Bundle according to the FHIR rules for Bundles.  Use the
		// pGlobalName-stored data as the basis for the validation.
		Set tSC = $ClassMethod(..#BundleValidatorClass, "ValidateBundleInternal", pGlobalName, .pErrors)
		If ($$$ISERR(tSC))||(pErrors.Errors.Count()) Quit
		
		Set tBundleType = @pGlobalName@("BundleInfo","type")
		
		If tBundleType="transaction" {
			Set tSC = ..UpdateReferences(pRequest, .pResponse, .pErrors, pGlobalName)
			If $$$ISERR(tSC) Quit
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// GetBundleInfoXML parses the specified FHIR Bundle stream and stores information
/// about it in a global, whose name is indicated by the pGlobalName input variable.
ClassMethod GetBundleInfoXML(pBundleStream As %Stream.Object, pGlobalName As %String)
{
	Set tSC = $$$OK
	
	Try {
		Set tResourceType = ""
		Set tBundleType = ""
		Set tBundleTotal = ""
		Set tIdentifierSystem = ""
		Set tIdentifierValue = ""
		
		Set @pGlobalName@("BundleInfo","resourceType") = ""
		Set @pGlobalName@("BundleInfo","type") = ""
		Set @pGlobalName@("BundleInfo","total") = ""
		Set @pGlobalName@("BundleInfo","identifier.system") = ""
		Set @pGlobalName@("BundleInfo","identifier.value") = ""
		
		Set tFullUrl = ""
		Set tResourceId = ""
		Set tRequestMethod = ""
		Set tRequestUrl = ""
		Set tRequestIfNoneExist = ""
		Set tRequestIfMatch = ""
		Set tRequestIfNoneMatch = ""
		Set tCurrentReference = ""
		
		Set tEntryDepth = 0
		Set tEntryNum = 0
		Set tResourceDepth = 0
		
		Set tInFullUrl = 0
		Set tInResource = 0
		Set tInBundleType = 0
		Set tInBundleTotal = 0
		Set tInResourceId = 0
		Set tInIdentifier = 0
		Set tInIdentifierSystem = 0
		Set tInIdentifierValue = 0
		Set tInRequest = 0
		Set tInRequestMethod = 0
		Set tInRequestUrl = 0
		Set tInRequestIfNoneExist = 0
		Set tInRequestIfMatch = 0
		Set tInRequestIfNoneMatch = 0
		Set tInReference = 0
		
		Set tReadBuffer = ""
		Set tWriteBuffer = ""
		Set tResourceBuffer = ""
		
		Set tXmlns = " xmlns=""http://hl7.org/fhir"""
		
		// First get the resource type, which is always at the top.
		Set tHadProlog = 0
		Set tInProlog = 0
		Set tInResourceType = 0
		For {
			Set tChar = pBundleStream.Read(1,.tSC)
			If $$$ISERR(tSC) Quit
			If tChar="<" {
				If tHadProlog {
					Set tInResourceType = 1
				} Else {
					Set tChar2 = pBundleStream.Read(1,.tSC)
					If $$$ISERR(tSC) Quit
					If tChar2="?" {
						Set tInProlog = 1
					} Else {
						Set tInResourceType = 1
						Set tResourceType = tResourceType_tChar2
					}
				}
			} ElseIf tChar=">" {
				If tInProlog {
					Set tInProlog = 0
					Set tHadProlog = 1
				} Else {
					Quit
				}
			} ElseIf (tChar=" ")&&(tInResourceType) {
				Quit
			} ElseIf tChar?1AN {
				If tInResourceType Set tResourceType = tResourceType_tChar
			}
		}
		If $$$ISERR(tSC) Quit
		
		Set @pGlobalName@("BundleInfo","resourceType") = tResourceType
		
		For {
			Set tString = pBundleStream.Read()
			For i = 1:1:$Length(tString) {
				Set tChar = $Extract(tString, i)
				Set tReadBuffer = tReadBuffer_tChar
				If $Length(tReadBuffer)>200 Set tReadBuffer = $Extract(tReadBuffer,*-199,*)
				
				If tInReference {
					If tChar'="""" {
						Set tCurrentReference = tCurrentReference_tChar
					} Else {
						Set tInReference = 0
						Set @pGlobalName@("ReferencesByReference",tCurrentReference) = ""
						Set @pGlobalName@("ReferencesByEntry",tEntryNum,tCurrentReference) = ""
						Set tCurrentReference = ""
					}
				} ElseIf $Extract(tReadBuffer,*-17,*)="<reference value=""" {
					Set tInReference = 1
					Set tCurrentReference = ""
				}
				
				If tEntryDepth>0 {
					If $Extract(tReadBuffer,*-6,*)="<entry>" {
						Set tEntryDepth = tEntryDepth + 1
						Set tResourceBuffer = tResourceBuffer_tChar
						If ($Length(tResourceBuffer)>10) {
							Set tWriteBuffer = tWriteBuffer_$Extract(tResourceBuffer)
							Set tResourceBuffer = $Extract(tResourceBuffer,2,*)
						}
						
					} ElseIf $Extract(tReadBuffer,*-7,*)="</entry>" {
						Set tEntryDepth = tEntryDepth - 1
						If tEntryDepth>0 {
							Set tResourceBuffer = tResourceBuffer_tChar
							If ($Length(tResourceBuffer)>10) {
								Set tWriteBuffer = tWriteBuffer_$Extract(tResourceBuffer)
								Set tResourceBuffer = $Extract(tResourceBuffer,2,*)
							}
						}
					
					} ElseIf tResourceDepth>0 {
						If ($Extract(tReadBuffer,*-10,*)="</resource>")||($Extract(tReadBuffer,*-11,*)="</contained>") {
							Set tResourceDepth = tResourceDepth - 1
							If tResourceDepth=0 {
								Set tQStream = ##class(HS.SDA3.QuickStream).%New()
								Set @pGlobalName@("EntryInfo",tEntryNum,"request.ResourceStreamId") = tQStream.%Id()
								// Parse the start of the resource, and add the FHIR xmlns to
								// the top element if it is not there already.
								Set tGotXmlns = 0
								Set tTopBuffer = ""
								For {
									Set tChar = $Extract(tWriteBuffer)
									Set tTopBuffer = tTopBuffer_tChar
									If $Extract(tTopBuffer,*-($Length(tXmlns)-1),*)=tXmlns {
										Set tGotXmlns=1
									}
									If (tChar=">")&&('tGotXmlns) {
										Do tQStream.Write(tXmlns)
										Set tGotXmlns = 1
									}
									Do tQStream.Write(tChar)
									Set tWriteBuffer = $Extract(tWriteBuffer,2,*)
									If tGotXmlns Quit
								}
								// Now write the rest of the resource.
								Do tQStream.Write(tWriteBuffer)
								Set tWriteBuffer = ""
								Set tResourceBuffer = ""
								Do tQStream.Rewind()
								Set tResourceType = ""
								Set tInResourceType = 0
								For {
									Set tChar = tQStream.Read(1)
									If tInResourceType {
										If '((tChar=" ")||(tChar=">")) {
											Set tResourceType = tResourceType_tChar
										} Else {
											Quit
										}
									} Else {
										If tChar="<" Set tInResourceType = 1
									}
								}
								Do tQStream.Rewind()
								Set @pGlobalName@("EntryInfo",tEntryNum,"resource.resourceType") = tResourceType
								Continue // done with resource
							} Else {
								Set tResourceBuffer = tResourceBuffer_tChar
								If ($Length(tResourceBuffer)>10) {
									Set tWriteBuffer = tWriteBuffer_$Extract(tResourceBuffer)
									Set tResourceBuffer = $Extract(tResourceBuffer,2,*)
								}
							}
						} ElseIf ($Extract(tReadBuffer,*-9,*)="<resource>")||($Extract(tReadBuffer,*-10,*)="<contained>") {
							Set tResourceDepth = tResourceDepth + 1
							Set tResourceBuffer = tResourceBuffer_tChar
							If ($Length(tResourceBuffer)>10) {
								Set tWriteBuffer = tWriteBuffer_$Extract(tResourceBuffer)
								Set tResourceBuffer = $Extract(tResourceBuffer,2,*)
							}
						} Else {
							Set tResourceBuffer = tResourceBuffer_tChar
							If ($Length(tResourceBuffer)>10) {
								Set tWriteBuffer = tWriteBuffer_$Extract(tResourceBuffer)
								Set tResourceBuffer = $Extract(tResourceBuffer,2,*)
							}
							If tInResourceId {
								If tChar'="""" {
									Set tResourceId = tResourceId_tChar
								} Else {
									Set @pGlobalName@("EntryInfo",tEntryNum,"resource.id") = tResourceId
									Set tResourceId = ""
									Set tInResourceId = 0
								}							
							} ElseIf ('tInResourceId)&&($Extract(tReadBuffer,*-10,*)="<id value=""")&&(tResourceDepth=1) {
								Set tInResourceId = 1
							}
						}
						
					} ElseIf ($Extract(tReadBuffer,*-9,*)="<resource>")||($Extract(tReadBuffer,*-10,*)="<contained>") {
						Set tResourceDepth = tResourceDepth + 1
						
					} ElseIf tInFullUrl {
						If tChar'="""" {
							Set tFullUrl = tFullUrl_tChar
						} Else {
							Set @pGlobalName@("EntryInfo",tEntryNum,"fullUrl") = tFullUrl
							Set tFullUrl = ""
							Set tInFullUrl=0
						}
						
					} ElseIf $Extract(tReadBuffer,*-15,*)="<fullUrl value=""" {
						Set tInFullUrl = 1
						
					} ElseIf tInRequest {
						If tInRequestMethod {
							If tChar'="""" {
								Set tRequestMethod = tRequestMethod_tChar
							} Else {
								Set @pGlobalName@("EntryInfo",tEntryNum,"request","method") = tRequestMethod
								Set tRequestMethod = ""
								Set tInRequestMethod = 0
							}
							
						} ElseIf $Extract(tReadBuffer,*-14,*)="<method value=""" {
							Set tInRequestMethod = 1
							
						} ElseIf tInRequestUrl {
							If tChar'="""" {
								Set tRequestUrl = tRequestUrl_tChar
							} Else {
								Set @pGlobalName@("EntryInfo",tEntryNum,"request","url") = tRequestUrl
								Set tRequestUrl = ""
								Set tInRequestUrl = 0
							}
						} ElseIf $Extract(tReadBuffer,*-11,*)="<url value=""" {
							Set tInRequestUrl = 1
							
						} ElseIf tInRequestIfNoneExist {
							If tChar'="""" {
								Set tRequestIfNoneExist = tRequestIfNoneExist_tChar
							} Else {
								Set @pGlobalName@("EntryInfo",tEntryNum,"request","ifNoneExist") = tRequestIfNoneExist
								Set tRequestIfNoneExist = ""
								Set tInRequestIfNoneExist = 0
							}
						} ElseIf $Extract(tReadBuffer,*-19,*)="<ifNoneExist value=""" {
							Set tInRequestIfNoneExist = 1
							
						} ElseIf tInRequestIfMatch {
							If tChar'="""" {
								Set tRequestIfMatch = tRequestIfMatch_tChar
							} Else {
								Set @pGlobalName@("EntryInfo",tEntryNum,"request","ifMatch") = tRequestIfMatch
								Set tRequestIfMatch = ""
								Set tInRequestIfMatch = 0
							}
						} ElseIf $Extract(tReadBuffer,*-15,*)="<ifMatch value=""" {
							Set tInRequestIfMatch = 1
							
						} ElseIf tInRequestIfNoneMatch {
							If tChar'="""" {
								Set tRequestIfNoneMatch = tRequestIfNoneMatch_tChar
							} Else {
								Set @pGlobalName@("EntryInfo",tEntryNum,"request","ifNoneMatch") = tRequestIfNoneMatch
								Set tRequestIfNoneMatch = ""
								Set tInRequestIfNoneMatch = 0
							}
						} ElseIf $Extract(tReadBuffer,*-19,*)="<ifNoneMatch value=""" {
							Set tInRequestIfNoneMatch = 1
							
						} ElseIf $Extract(tReadBuffer,*-9,*)="</request>" {
							Set tInRequest = 0
						}
						
					} ElseIf $Extract(tReadBuffer,*-8,*)="<request>" {
						Set tInRequest = 1
					}
					
				} Else { // tEntryDepth=0
					If $Extract(tReadBuffer,*-6,*)="<entry>" {
						Set tEntryDepth = tEntryDepth + 1
						If tEntryDepth=1 {
							Set tEntryNum = tEntryNum + 1
							Set @pGlobalName@("EntryInfo") = tEntryNum
						}
					} ElseIf tInBundleType {
						If tChar'="""" {
							Set tBundleType = tBundleType_tChar
						} Else {
							Set tInBundleType = 0
						}
					} ElseIf tInBundleTotal {
						If tChar'="""" {
							Set tBundleTotal = tBundleTotal_tChar
						} Else {
							Set tInBundleTotal = 0
						}
					} ElseIf $Extract(tReadBuffer,*-12,*)="<type value=""" {
						Set tInBundleType = 1
					} ElseIf $Extract(tReadBuffer,*-13,*)="<total value=""" {
						Set tInBundleTotal = 1
					} ElseIf tInIdentifier {
						If $Extract(tReadBuffer,*-12,*)="</identifier>" {
							Set tInIdentifier = 0
						} Else {
							If tInIdentifierSystem {
								If tChar'="""" {
									Set tIdentifierSystem = tIdentifierSystem_tChar
								} Else {
									Set tInIdentifierSystem = 0
								}
							} ElseIf tInIdentifierValue {
								If tChar'="""" {
									Set tIdentifierValue = tIdentifierValue_tChar
								} Else {
									Set tInIdentifierValue = 0
								}
							} ElseIf $Extract(tReadBuffer,*-14,*)="<system value=""" {
								Set tInIdentifierSystem = 1
							} ElseIf $Extract(tReadBuffer,*-13,*)="<value value=""" {
								Set tInIdentifierValue = 1
							}
						}
					} ElseIf $Extract(tReadBuffer,*-11,*)="<identifier>" {
						If (tIdentifierSystem="")&&(tIdentifierValue="") Set tInIdentifier = 1
					}
				}
			}
			If pBundleStream.AtEnd Quit
		}
		
		Set @pGlobalName@("BundleInfo","type") = tBundleType
		Set @pGlobalName@("BundleInfo","total") = tBundleTotal
		Set @pGlobalName@("BundleInfo","identifier.system") = tIdentifierSystem
		Set @pGlobalName@("BundleInfo","identifier.value") = tIdentifierValue
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// ConvertReferences is meant to be called only for transaction Bundles (not for batch
/// Bundles). The default implementation of this method finds fullUrls or resource ids
/// that are UUIDs and for each of those generates a server-assigned resource id and
/// updates the Bundle entry metadata.
ClassMethod ConvertReferences(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response, ByRef pErrors As HS.Types.FHIR.Errors, pGlobalName As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Try {
		For i = 1:1:@pGlobalName@("EntryInfo") {
			Set tResourceType = $Get(@pGlobalName@("EntryInfo",i,"resource.resourceType"))
			If tResourceType="" Continue
			Set tFullUrl = $Get(@pGlobalName@("EntryInfo",i,"fullUrl"))
			Set tResourceId = $Get(@pGlobalName@("EntryInfo",i,"resource.id"))
			Set tEntryMethod = $Get(@pGlobalName@("EntryInfo",i,"request","method"))
			Set tEntryUrl = $Get(@pGlobalName@("EntryInfo",i,"request","url"))
			
			Set tReferenceToUpdate = ..GetReferenceToUpdate(.tResourceType, .tResourceId, .tFullUrl, .tEntryMethod, .tEntryUrl)
			
			If tReferenceToUpdate'="" {
				Set tNewResourceId = ..GenerateResourceIdForTrans(tResourceType, @pGlobalName@("EntryInfo",i,"request.ResourceStreamId"))
				Set tNewReference = tResourceType_"/"_tNewResourceId
				Set @pGlobalName@("EntryInfo",i,"fullUrl") = tNewReference
				Set @pGlobalName@("EntryInfo",i,"resource.id") = tNewResourceId
				Set @pGlobalName@("EntryInfo",i,"request","url") = tNewReference
				Set @pGlobalName@("EntryInfo",i,"request","method") = "PUT"
				Set @pGlobalName@("ReferencesByReference",tReferenceToUpdate) = tNewReference
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit $$$OK
}

/// GetReferenceToUpdate checks the Bundle entry fullUrl, resource id, and entry request url
/// to see if any indicate a UUID, which implies that the url or id is a placeholder, and
/// needs to be updated to a resource id managed by this repository server. The default
/// logic is to use the first found of:
/// 1. fullUrl that is a UUID with the "urn:uuid:" prefix (e.g., "urn:uuid:e12edae2-8892-11e8-bce1-7831c1b7edac").
/// 2. fullUrl that is the resource type plus a UUID without the prefix (e.g., "Encounter/e12edae2-8892-11e8-bce1-7831c1b7edac").
/// 3. resource id that is a UUID without the prefix (e.g., "e12edae2-8892-11e8-bce1-7831c1b7edac").
/// 4. entry request url that is a UUID with the prefix (e.g., "urn:uuid:e12edae2-8892-11e8-bce1-7831c1b7edac").
/// 5. entry request url that is the resource type plus a UUID without the prefix (e.g., "Encounter/e12edae2-8892-11e8-bce1-7831c1b7edac").
ClassMethod GetReferenceToUpdate(pResourceType As %String, pResourceId As %String, pFullUrl As %String, pEntryMethod As %String, pEntryUrl As %String) As %String
{
	Set tReferenceToUpdate = ""
	
	If (pFullUrl'="")&&($Length(pFullUrl,"/")=1)&&(##class(HS.HC.Util).IsUUID(pFullUrl,1)) {
		Set tReferenceToUpdate = pFullUrl
	} ElseIf ($Length(pFullUrl,"/")=2)&&($Piece(pFullUrl,"/",1)=pResourceType)&&(##class(HS.HC.Util).IsUUID($Piece(pFullUrl,"/",2),0)) {
		Set tReferenceToUpdate = pFullUrl
	} ElseIf (pResourceId'="")&&(##class(HS.HC.Util).IsUUID(pResourceId,0)) {
		Set tReferenceToUpdate = pResourceType_"/"_pResourceId
	} ElseIf (pEntryUrl'="")&&($Length(pEntryUrl,"/")=1)&&(##class(HS.HC.Util).IsUUID(pEntryUrl,1)) {
		Set tReferenceToUpdate = pEntryUrl
	} ElseIf ($Length(pEntryUrl,"/")=2)&&($Piece(pEntryUrl,"/",1)=pResourceType)&&(##class(HS.HC.Util).IsUUID($Piece(pEntryUrl,"/",2),0)) {
		Set tReferenceToUpdate = pEntryUrl
	}
	
	Quit tReferenceToUpdate
}

/// GenerateResourceIdForTrans returns a resource id, or a comma-delimited list of resource
/// ids, by first checking for existing resources that match the current one, and if none,
/// then generating a new resource id.
ClassMethod GenerateResourceIdForTrans(pResourceType As %String, pResourceStreamId As %String, pSession As %String = "") As %String
{
	Set tResourceId = ""
	
	Set tResourceId = $ClassMethod(..#StorageClass, "FindMatchingResourceIds", .pResourceType, .pResourceStreamId, pSession)
	
	If tResourceId="" {
		Set tResourceId = $ClassMethod(..#StorageClass, "GenerateResourceId", .pResourceType, .pSession)
	}
	
	Quit tResourceId
}

/// UpdateRefsAndIdInPayload parses a FHIR resource stream, producing a new resource stream
/// with resource reference values and the resource id updated as indicated by the pOldResourceId
/// and pNewResourceId, and the information stored in the "ReferencesByReference" sub-node of
/// the global structure specified by pGlobalName.
ClassMethod UpdateRefsAndIdInPayload(pContentType As %String, pResourceType As %String, pStreamIn As %Stream.Object, pOldResourceId As %String, pNewResourceId As %String, pStreamOut As %Stream.Object, pGlobalName As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If pContentType["json" {
			If pOldResourceId'="" {
				Set tOldResourceIdStr = """id"":"""_pOldResourceId_""""
			} Else {
				Set tOldResourceIdStr = ""
			}
			If pNewResourceId'="" {
				Set tNewResourceIdStr = """id"":"""_pNewResourceId_""""
			} Else {
				Set tNewResourceIdStr = ""
			}
			Set tReferenceStr = """reference"":"""
			Set tContentType = "json"
		} Else {
			If pOldResourceId'="" {
				Set tOldResourceIdStr = "<id value="""_pOldResourceId_""""
			} Else {
				Set tOldResourceIdStr = ""
			}
			If pNewResourceId'="" {
				Set tNewResourceIdStr = "<id value="""_pNewResourceId_""""
			} Else {
				Set tNewResourceIdStr = ""
			}
			Set tReferenceStr = "<reference value="""
			Set tContentType = "xml"
		}
		
		// For resource id update:
		// - If the old resource id equals the new resource id, then no change needed.
		// - If the old resource id is blank, then insert the new resource id at top of the resource.
		// - If the old resource id and new resource id are both not blank and not equal to each
		//   other then replace the old resource id in place with the new resource id.
		
		Set tOldResourceIdStrLen = $Length(tOldResourceIdStr)
		Set tNewResourceIdStrLen = $Length(tNewResourceIdStr)
		Set tReferenceStrLen = $Length(tReferenceStr)
		Set tXMLResourceTypeStr1 = "<"_pResourceType_">"
		Set tXMLResourceTypeStr1Len = $Length(tXMLResourceTypeStr1)
		Set tXMLResourceTypeStr2 = "<"_pResourceType_" xmlns=""http://hl7.org/fhir"">"
		Set tXMLResourceTypeStr2Len = $Length(tXMLResourceTypeStr2)
		
		// pNewResourceId will never be blank if pOldResourceId is not blank.
		Set tAddResourceId = ((pOldResourceId="")&&(pNewResourceId'=""))
		Set tUpdateResourceId = ((pOldResourceId'="")&&(pOldResourceId'=pNewResourceId))
		
		Set tQuote = """"
		
		Set tMaxBuf = $$$MaxLocalLength
		
		If '$IsObject($Get(pStreamOut)) Set pStreamOut = ##class(%Stream.TmpCharacter).%New()
		
		Set tWriteBuffer = ""
		Set tInReference = 0
		Set tReferenceValue = ""
		Set tReferenceBuffer = ""
		Set tGeneralBuffer = ""
		Set tResourceIdUpdated = 0
		Set tPastResourceStart = 0
		Set tInResourceTopLevel = 1
		
		For {
			Set tString = pStreamIn.Read( , .tSC)
			Set tPosition = 0
			For {
				If $i(tPosition)
				If tPosition>$Length(tString) Quit
				
				Set tChar = $Extract(tString, tPosition)
				
				Set tReferenceBuffer = tReferenceBuffer_tChar
				
				If $Length(tReferenceBuffer)>tReferenceStrLen Set tReferenceBuffer = $Extract(tReferenceBuffer,2,*)
				
				// If we are not yet past the start of the resource object - in JSON
				// it is the first left curly brace, in XML it is <resourceType> or
				// <resourceType xmlns="http://hl7.org/fhir"> - then keep track of
				// when we finally do get past it. If we are adding a resource id
				// (as opposed to updating an existing one) then add it immediately
				// after the start of the resource object.
				If 'tPastResourceStart {
					If tContentType="json" {
						If tChar="{" {
							Set tPastResourceStart = 1
							If tAddResourceId {
								Set tAddChars = tChar_tNewResourceIdStr_","
							} Else {
								Set tAddChars = tChar
							}
							Do Write
							Continue
						}
					} Else {
						Set tGeneralBuffer = tGeneralBuffer_tChar
						If ($Extract(tGeneralBuffer,*-(tXMLResourceTypeStr1Len-1),*)=tXMLResourceTypeStr1)||($Extract(tGeneralBuffer,*-(tXMLResourceTypeStr2Len-1),*)=tXMLResourceTypeStr2) {
							Set tPastResourceStart = 1
							If tAddResourceId {
								Set tAddChars = tChar_tNewResourceIdStr
							} Else {
								Set tAddChars = tChar
							}
							Do Write
							Set tGeneralBuffer = ""
							Continue
						}
					}
				}
				
				// If the resource id needs to be replaced (not just added) and it has 
				// not been replaced yet, look ahead in the string to see if it is now
				// upon us. If so, replace with the new resource id string, and advance
				// the string position pointer.
				If (tUpdateResourceId)&&('tResourceIdUpdated) {
					If tInResourceTopLevel {
						// For replacing an existing resource id, we have to look ahead
						// in the resource that we are parsing.
						If $Extract(tString,tPosition,tPosition+(tOldResourceIdStrLen-1))=tOldResourceIdStr {
							Set tAddChars = tNewResourceIdStr
							Do Write
							Set tResourceIdUpdated = 1
							Set tPosition = tPosition+(tOldResourceIdStrLen-1)
							Continue
						}
					}
				}
				
				If tInReference=0 {
					Set tAddChars = tChar Do Write
					If tReferenceBuffer=tReferenceStr Set tInReference = 1
				} Else {
					If tChar=tQuote {
						If tReferenceValue'="" {
							If $Get(@pGlobalName@("ReferencesByReference",tReferenceValue))'="" {
								Set tAddChars = @pGlobalName@("ReferencesByReference",tReferenceValue)_tChar
							} Else {
								Set tAddChars = tReferenceValue_tChar
							}
						} Else {
							Set tAddChars = tChar
						}
						Do Write
						Set tReferenceBuffer = ""
						Set tReferenceValue = ""
						Set tInReference = 0
					} Else {
						Set tReferenceValue = tReferenceValue_tChar
					}
				}
			}
			
			If pStreamIn.AtEnd Quit
		}

		If tWriteBuffer'="" Do pStreamOut.Write(tWriteBuffer) Set tWriteBuffer = ""
		
		Do pStreamOut.Rewind()
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
	
Write
	If ($Length(tWriteBuffer)+$Length(tAddChars))>tMaxBuf Do pStreamOut.Write(tWriteBuffer) Set tWriteBuffer = ""
	Set tWriteBuffer = tWriteBuffer_tAddChars
	Quit
}

/// ProcessTransactionBundle processes a transaction Bundle according to the FHIR specification at:<br>
/// http://hl7.org/fhir/DSTU2/http.html#transaction<br>
/// http://hl7.org/fhir/STU3/http.html#transaction<br>
/// <br>Inputs:<br>
/// <li>pRequest              : FHIR request message.
/// <li>pRepositoryOperations : This method calls back to the resource repository business
///                             operation that called this method. pRepositoryOperations is
///                             the ORef to the business operation.
/// <li>pGlobalName           : If the calling method has stored Bundle metadata in a global
///                             (the default implementation of this class), then this is the
///                             name of that global.
/// <br>Output:<br>
/// <li>pResponse             : FHIR response message.
ClassMethod ProcessTransactionBundle(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response, pRepositoryOperations, pGlobalName As %String) As %Status
{
	Quit ..ProcessTransBundleCommon(pRequest, .pResponse, "transaction", pRepositoryOperations, pGlobalName)
}

/// ProcessBatchBundle processes a batch Bundle according to the FHIR specification at:<br>
/// http://hl7.org/fhir/DSTU2/http.html#transaction<br>
/// http://hl7.org/fhir/STU3/http.html#transaction<br>
/// <br>Inputs:<br>
/// <li>pRequest              : FHIR request message.
/// <li>pRepositoryOperations : This method calls back to the resource repository business
///                             operation that called this method. pRepositoryOperations is
///                             the ORef to the business operation.
/// <li>pGlobalName           : If the calling method has stored Bundle metadata in a global
///                             (the default implementation of this class), then this is the
///                             name of that global.
/// <br>Output:<br>
/// <li>pResponse             : FHIR response message.
ClassMethod ProcessBatchBundle(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response, pRepositoryOperations, pGlobalName As %String) As %Status
{
	Quit ..ProcessTransBundleCommon(pRequest, .pResponse, "batch", pRepositoryOperations, pGlobalName)
}

ClassMethod ProcessTransBundleCommon(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response, pBundleType As %String, pRepositoryOperations, pGlobalName As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If pRequest.ContentType["json" {
			Set tContentType = "json"
		} Else {
			Set tContentType = "xml"
		}
		
		Set tResponseStream = pResponse.GetPayloadOref()
		
		Set tEntryCount = @pGlobalName@("EntryInfo")
		
		// Maintain local string variables for response Status and OperationOutcome
		// so that they survive TROLLBACK.
		Set tFHIRResponseStatus = ""
		Set tOutcomeString = ""
		
		Set tBaseUrl = pRequest.BaseURL
		If tBaseUrl'="" {
			If $Extract(tBaseUrl,*)="/" Set tBaseUrl = $Extract(tBaseUrl,1,*-1)
			Set tFullBaseUrl = ##class(HS.FHIR.Utils).GetHttpHostPort(pRequest)_pRequest.BaseURL
		} Else {
			Set tFullBaseUrl = ""
		}
		
		If pRequest.FHIRVersion="DSTU2" {
			Set tConformanceCapabilityId = pRequest.AdditionalInfo.GetAt("ConformanceId")
		} Else {
			Set tConformanceCapabilityId = pRequest.AdditionalInfo.GetAt("CapabilityStatementId")
		}
		If tConformanceCapabilityId="" {
			If pRequest.BaseURL'="" {
				Set tConfigObj = ##class(HS.Registry.FHIRCSPConfig).URLIndexOpen(pRequest.BaseURL)
				If $IsObject(tConfigObj) {
					Set tConformanceCapabilityId = tConfigObj.ConformanceId
				}
				Kill tConfigObj
			}
		}
		
		// For both transaction and batch, FHIR wants the entries processed in an order
		// dictated by HTTP method: DELETE first, POST next, then PUT, then GET.
		// Reference: http://hl7.org/fhir/DSTU2/http.html#transaction
		// Reference: http://hl7.org/fhir/STU3/http.html#transaction
		//
		// Go through the Bundle entries and create an array to provide the order of
		// processing based on method.
		
		For tEntryNum = 1:1:@pGlobalName@("EntryInfo") {
			Set tMethod = $Get(@pGlobalName@("EntryInfo",tEntryNum,"request","method"))
			If tMethod="" {
				If ($Get(@pGlobalName@("EntryInfo",tEntryNum,"request.ResourceStreamId"))'="") {
					If ($Get(@pGlobalName@("EntryInfo",tEntryNum,"resource.id"))'="") {
						Set tMethod = "PUT"
					} Else {
						Set tMethod = "POST"
					}
				} Else {
					Set tMethod = "GET"
				}
			}
			Set @pGlobalName@( "ProcessingOrder", tMethod, tEntryNum) = ""
		}
		
		#dim tRequest As HS.Message.FHIR.Request
		
		// Create a re-usable FHIR request message object tRequest to use for the individual
		// interactions. tRequest will always retain the original value of these properties:
		// ContentType, SessionApplication, SessionId, BaseURL, AdditionalInfo.
		Set tRequest = pRequest.%ConstructClone(1)
		
		If tConformanceCapabilityId'="" {
			If pRequest.FHIRVersion="DSTU2" {
				Do tRequest.AdditionalInfo.SetAt(tConformanceCapabilityId, "ConformanceId")
			} Else {
				Do tRequest.AdditionalInfo.SetAt(tConformanceCapabilityId, "CapabilityStatementId")
			}
		}
		
		Set tRequest.SessionApplication = pRequest.SessionApplication
		Set tRequest.SessionId = pRequest.SessionId
		
		// Leave FormatFHIROutput at 0 for the individual interactions during transaction
		// processing. If needed, the return payload will be formatted after transaction
		// processing is done.
		Set tRequest.FormatFHIROutput = 0
		
		If pBundleType="transaction" TSTART
		
		// For transaction, if an interaction fails then quit, perform TROLLBACK,
		// and return a single return status and OperationOutcome.  Otherwise if
		// successful then return a Bundle of response entries.
		For tMethod = "DELETE", "POST", "PUT", "GET" {
			Set tEntryNum = ""
			For {
				Set tEntryNum = $Order(@pGlobalName@("ProcessingOrder", tMethod, tEntryNum))
				If tEntryNum="" Quit
				
				// Clear out the properties of the re-usable FHIR request that need
				// to change from entry to entry.
				Set tRequest.Interaction = ""
				Do tRequest.Parameters.Clear()
				Set tRequest.Compartment = ""
				Set tRequest.TimestampUTC = $ZDateTime($ZTimeStamp,3)
				Set tRequest.Type = ""
				Set tRequest.Id = ""
				Set tRequest.VId = ""
				Do tRequest.Payload.Clear()
				Do tRequest.Headers.Clear()
				If pRequest.Headers.GetAt("HOST")'="" {
					Do tRequest.Headers.SetAt(pRequest.Headers.GetAt("HOST"),"HOST")
				}
				Set tRequest.QuickStreamId = ""
				Set tParameters = ""
				Kill tParametersArray
				
				// The request url should not include the base url.
				// Compensate in case it is included.
				Set tUrl = $Get(@pGlobalName@("EntryInfo",tEntryNum,"request","url"))
				If (tFullBaseUrl'="")&&($Extract(tUrl,1,$Length(tFullBaseUrl))=tFullBaseUrl) Set tUrl = $Extract(tUrl,$Length(tFullBaseUrl)+2,*)
				If (tBaseUrl'="")&&($Extract(tUrl,1,$Length(tBaseUrl))=tBaseUrl) Set tUrl = $Extract(tUrl,$Length(tBaseUrl)+2,*)
				
				Set tUrlWOParams = $Piece(tUrl, "?", 1)
				If $Extract(tUrlWOParams)="/" Set tUrlWOParams = $Extract(tUrlWOParams, 2, *)
				If $Extract(tUrlWOParams, *)="/" Set tUrlWOParams = $Extract(tUrlWOParams, 1, *-1)
				Set tSlashLen = $Length(tUrlWOParams, "/")
				Set tUrlP1 = $Piece(tUrlWOParams, "/", 1)
				Set tUrlP2 = $Piece(tUrlWOParams, "/", 2)
				Set tUrlP3 = $Piece(tUrlWOParams, "/", 3)
				Set tUrlP4 = $Piece(tUrlWOParams, "/", 4)
				Set tParameters = $Piece(tUrl, "?", 2, 999)
				
				// Build the individual interaction FHIR request based on the
				// information in the Bundle entry request and resource objects.
				If tMethod="PUT" {
					Set tRequest.Interaction = "update"
					Set tRequest.Type = tUrlP1
					Set tRequest.Id = tUrlP2
					Set tRequest.QuickStreamId = @pGlobalName@("EntryInfo",tEntryNum,"request.ResourceStreamId")
					If $Get(@pGlobalName@("EntryInfo",tEntryNum,"request","ifMatch"))'="" {
						Do tRequest.Headers.SetAt(@pGlobalName@("EntryInfo",tEntryNum,"request","ifMatch"),"IF_MATCH")
					}
					If pRequest.Headers.GetAt("PREFER")["return=representation" {
						Do tRequest.Headers.SetAt("return=representation", "PREFER")
					}
				} ElseIf tMethod="POST" {
					If (tSlashLen=1)&&(tUrlP1'="") {
						// According to REST Handler, the possibilities for POST with only
						// one piece to URL are: Mailbox, Document, _search, whole system
						// operation, and create.
						// Whole system operation and create are the only ones we support,
						// assume that those are the only choices.
						If $Extract(tUrlP1)'="$" {
							Set tRequest.Interaction = "create"
							Set tRequest.Type = tUrlP1
						} Else {
							Set tRequest.Interaction = tUrlP1
						}
					} ElseIf tSlashLen=2 {
						// It is unclear if POST with two items in the url is used for
						// anything other than FHIR operation. This logic currently
						// assumes that POST with two items in the url is an operation.
						If $Extract(tUrlP2)'="$" {
							Set tRequest.Interaction = "create"
							Set tRequest.Type = tUrlP1
						} Else {
							Set tRequest.Interaction = tUrlP2
							Set tRequest.Type = tUrlP1
						}
					} ElseIf tSlashLen=3 {
						// It is unclear if POST with three items in the url is used for
						// anything other than FHIR operation. This logic currently
						// assumes that POST with three items in the url is an operation.
						If $Extract(tUrlP3)'="$" {
							Set tRequest.Interaction = "create"
							Set tRequest.Type = tUrlP1
							Set tRequest.Id = tUrlP2
						} Else {
							Set tRequest.Interaction = tUrlP3
							Set tRequest.Type = tUrlP1
							Set tRequest.Id = tUrlP2
						}
					} Else {
						Set tSC = $$$ERROR($$$GeneralError, "Unsupported url format for POST method")
						Quit
					}
					If $Get(@pGlobalName@("EntryInfo",tEntryNum,"request","ifNoneExist"))'="" {
						Do tRequest.Headers.SetAt(@pGlobalName@("EntryInfo",tEntryNum,"request","ifNoneExist"),"IF_NONE_EXIST")
					}
					If pRequest.Headers.GetAt("PREFER")["return=representation" {
						Do tRequest.Headers.SetAt("return=representation", "PREFER")
					}
					Set tRequest.QuickStreamId = $Get(@pGlobalName@("EntryInfo",tEntryNum,"request.ResourceStreamId"))
				} ElseIf tMethod="GET" {
					If tUrlWOParams="_history" {
						Set tRequest.Interaction = "history-all"
					} ElseIf tUrlWOParams="metadata" {
						Set tRequest.Interaction = "conformance"
					} ElseIf (tSlashLen=2)&&(tUrlP2="_history") {
						Set tRequest.Interaction = "history-type"
						Set tRequest.Type = tUrlP1
					} ElseIf (tSlashLen=4)&&(tUrlP3="_history") {
						Set tRequest.Interaction = "vread"
						Set tRequest.Type = tUrlP1
						Set tRequest.Id = tUrlP2
						Set tRequest.VId = tUrlP4
					} ElseIf (tSlashLen=3)&&(tUrlP3="_history") {
						Set tRequest.Interaction = "history"
						Set tRequest.Type = tUrlP1
						Set tRequest.Id = tUrlP2
					} ElseIf tSlashLen=2 {
						Set tRequest.Type = tUrlP1
						// Provide for invoking operations via GET.
						If $Extract(tUrlP2)'="$" {
							Set tRequest.Interaction = "read"
							Set tRequest.Id = tUrlP2
						} Else {
							Set tRequest.Interaction = tUrlP2
						}
						If $Get(@pGlobalName@("EntryInfo",tEntryNum,"request","ifNoneMatch"))'="" {
							Do tRequest.Headers.SetAt(@pGlobalName@("EntryInfo",tEntryNum,"request","ifNoneMatch"),"IF_NONE_MATCH")
						}
						If $Get(@pGlobalName@("EntryInfo",tEntryNum,"request","ifModifiedSince"))'="" {
							Do tRequest.Headers.SetAt(@pGlobalName@("EntryInfo",tEntryNum,"request","ifModifiedSince"),"IF_MODIFIED_SINCE")
						}
					} ElseIf tSlashLen=1 {
						// Provide for invoking operations via GET.
						If $Extract(tUrlP1)'="$" {
							Set tRequest.Interaction = "search"
							Set tRequest.Type = tUrlP1
							If pRequest.Headers.GetAt("PREFER")["handling=strict" {
								Do tRequest.Headers.SetAt("handling=strict", "PREFER")
							}
							If pRequest.Headers.GetAt("PREFER")["handling=lenient" {
								Do tRequest.Headers.SetAt("handling=lenient", "PREFER")
							}
						} Else {
							Set tRequest.Interaction = tUrlP1
						}
					} ElseIf tSlashLen=3 {
						// Provide for invoking operations via GET.
						If $Extract(tUrlP3)'="$" {
							Set tRequest.Interaction = "search-compartment"
							Set tRequest.Compartment = tUrlP1
							Set tRequest.Id = tUrlP2
							Set tRequest.Type = tUrlP3
							If pRequest.Headers.GetAt("PREFER")["handling=strict" {
								Do tRequest.Headers.SetAt("handling=strict", "PREFER")
							}
							If pRequest.Headers.GetAt("PREFER")["handling=lenient" {
								Do tRequest.Headers.SetAt("handling=lenient", "PREFER")
							}
						} Else {
							Set tRequest.Interaction = tUrlP3
							Set tRequest.Type = tUrlP1
							Set tRequest.Id = tUrlP2
						}
					}
				} ElseIf tMethod="DELETE" {
					Set tRequest.Interaction = "delete"
					Set tRequest.Type = tUrlP1
					Set tRequest.Id = tUrlP2
				}
				
				If tParameters'="" {
					Set tSC = ##class(HS.FHIR.Utils).URLParamStringToArray(tParameters, .tParametersArray)
					If $$$ISERR(tSC) Quit
					Set tRequest.Parameters = tParametersArray
				}
				
				#dim tFHIRResponse As HS.Message.FHIR.Response
				
				Kill tFHIRResponse
				
				If tRequest.Interaction="create" {
					Set tSC = pRepositoryOperations.Create(tRequest, .tFHIRResponse)
				} ElseIf tRequest.Interaction="update" {
					Set tSC = pRepositoryOperations.Update(tRequest, .tFHIRResponse)
				} ElseIf tRequest.Interaction="read" {
					Set tSC = pRepositoryOperations.Read(tRequest, .tFHIRResponse)
				} ElseIf tRequest.Interaction="vread" {
					Set tSC = pRepositoryOperations.Read(tRequest, .tFHIRResponse)
				} ElseIf tRequest.Interaction="search" {
					Set tSC = pRepositoryOperations.Search(tRequest, .tFHIRResponse)
				} ElseIf tRequest.Interaction="search-compartment" {
					Set tSC = pRepositoryOperations.Search(tRequest, .tFHIRResponse)
				} ElseIf tRequest.Interaction="history" {
					Set tSC = pRepositoryOperations.History(tRequest, .tFHIRResponse)
				} ElseIf tRequest.Interaction="history-all" {
					Set tSC = pRepositoryOperations.History(tRequest, .tFHIRResponse)
				} ElseIf tRequest.Interaction="delete" {
					Set tSC = pRepositoryOperations.Delete(tRequest, .tFHIRResponse)
				} ElseIf $Extract(tRequest.Interaction)="$" {
					Set tSC = pRepositoryOperations.Operation(tRequest, .tFHIRResponse)
				}
				If $$$ISERR(tSC) Quit
				
				// If success, set the response property of the response entry to
				// include the interaction status, and add any FHIR payload that
				// may have been returned from the interaction.
				Set tHTTPSuccess = ##class(HS.FHIR.Helper).HttpSuccess(tFHIRResponse.Status)
				If (tHTTPSuccess)||(pBundleType'="transaction")||(((tRequest.Interaction="read")||(tRequest.Interaction="vread"))&&(+tFHIRResponse.Status=404)) {
					Set tLocation = tFHIRResponse.Headers.GetAt("Location")
					If tLocation'="" {
						If tLocation["/_history/" Set tLocation = $Piece(tLocation,"/_history/",1)
						Set @pGlobalName@("EntryInfo",tEntryNum,"response","location") = tLocation
					}
					
					Set @pGlobalName@("EntryInfo",tEntryNum,"response.ResourceStreamId") = tFHIRResponse.QuickStreamId
					Set tFHIRResponsePayload = tFHIRResponse.GetPayloadOref()
					If tFHIRResponsePayload.Size>0 Do tFHIRResponsePayload.Rewind()

					Set tStatus = tFHIRResponse.Status
					If tStatus?1N.N {
						Do ##class(HS.FHIR.Helper).LookupHTTPStatusText(tStatus, .tStatusText)
						Set tStatus = tStatus_" "_tStatusText
					}
					Set @pGlobalName@("EntryInfo",tEntryNum,"response","status") = tStatus
					
					If tFHIRResponse.Headers.GetAt("ETag")'="" {
						Set @pGlobalName@("EntryInfo",tEntryNum,"response","etag") = tFHIRResponse.Headers.GetAt("ETag")
					}
					If tFHIRResponse.Headers.GetAt("Last-Modified")'="" {
						// Last-Modified is in format "Fri, 13 Jul 2018 01:28:55 GMT".
						// Convert it back to format "2018-07-13T01:28:55Z".
						Set tLastModified = $Piece(tFHIRResponse.Headers.GetAt("Last-Modified"),",",2)
						Set tLastModified = $ZStrip(tLastModified,"<>W")
						Set tLastModified = $Extract(tLastModified,1,*-4)
						Set tLastModified = $ZDateTimeH(tLastModified,2)
						Set tLastModified = $ZDateTime(tLastModified,3)
						Set tLastModified = $Translate(tLastModified," ","T")_"Z"
						Set @pGlobalName@("EntryInfo",tEntryNum,"response","lastModified") = tLastModified
					}
				} Else {
					// For transaction, upon error or other fail, set the FHIR response
					// message status to the status received from the interaction, and
					// add any OperationOutcome resource that may have been received
					// from the interaction, and Quit.
					Set tFHIRResponseStatus = tFHIRResponse.Status
					Set tFHIRResponsePayload = tFHIRResponse.GetPayloadOref()
					If ($IsObject($Get(tFHIRResponsePayload)))&&(tFHIRResponsePayload.Size>0) {
						Do tFHIRResponsePayload.Rewind()
						Set tOutcomeString = tFHIRResponsePayload.Read($$$MaxLocalLength)
					}
					Quit
				}
				If ($$$ISERR(tSC))||(tFHIRResponseStatus'="") Quit
			}
			If ($$$ISERR(tSC))||(tFHIRResponseStatus'="") Quit
		}
		If ($$$ISERR(tSC))||(tFHIRResponseStatus'="") Quit
		
		// Processing all succeeded, go ahead and TCOMMIT now.
		If pBundleType="transaction" TCOMMIT
		
		Set tSC = ##class(HS.FHIR.Utils).StartBundleStream(tContentType, .tResponseStream, , pBundleType_"-response")
		If $$$ISERR(tSC) Quit
		
		// Add the transaction-response or batch-response entries to the Bundle in
		// the order that corresponds to that in the original transaction Bundle.
		Set tEntryWriteCount = 0
		Set tEntryNum = ""
		For {
			Set tEntryNum = $Order(@pGlobalName@("EntryInfo",tEntryNum))
			If tEntryNum="" Quit
			Kill tEntryResponseInfo
			Merge tEntryResponseInfo = @pGlobalName@("EntryInfo",tEntryNum,"response")
			Set tQStreamId = $Get(@pGlobalName@("EntryInfo",tEntryNum,"response.ResourceStreamId"))
			If tQStreamId'="" {
				Set tQStream = ##class(HS.SDA3.QuickStream).%OpenId(tQStreamId)
			} Else {
				Set tQStream = ""
			}
			Set tEntryWriteCount = tEntryWriteCount + 1
			Set tIsFirstEntry = (tEntryWriteCount=1)
			Set tIsLastEntry = (tEntryWriteCount=tEntryCount)
			Set tWriteComma = ((tEntryCount'=1)&&(tEntryWriteCount<tEntryCount))
			Set tSC = ##class(HS.FHIR.Utils).AddBundleEntryToStream(tContentType, .tResponseStream, $Get(@pGlobalName@("EntryInfo",tEntryNum,"response","location")), tQStream, , , .tEntryResponseInfo, , tIsFirstEntry, tWriteComma, tIsLastEntry)
			If $$$ISERR(tSC) Quit
		}
		
		Set tSC = ##class(HS.FHIR.Utils).EndBundleStream(tContentType, .tResponseStream)
		If $$$ISERR(tSC) Quit
		
		Set pResponse.Status = 200
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	If tFHIRResponseStatus'="" {
		If pBundleType="transaction" TROLLBACK
		Set pResponse.Status = tFHIRResponseStatus
		If tOutcomeString'="" {
			Do tResponseStream.Clear(0)
			Do tResponseStream.Write(tOutcomeString)
			Do tResponseStream.Rewind()
			#dim tOutcomeObj As HS.FHIR.vSTU3.Model.Resource.OperationOutcome
			#dim tIssue As HS.FHIR.vSTU3.Model.Resource.OperationOutcome.Issue
			Set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR(tContentType, tResponseStream, .tOutcomeObj, "HS.FHIR.vSTU3.Model.Resource")
			If $$$ISOK(tSC) {
				For i = 1:1:tOutcomeObj.issue.Count() {
					Set tIssue = tOutcomeObj.issue.GetAt(i)
					If ($IsObject(tIssue.details))&&(tIssue.details.text.value'="") {
						Do tIssue.details.SetText("Error incurred by Bundle entry "_tEntryNum_": "_tIssue.details.text.value)
					}
					If ($IsObject(tIssue.location))&&(tIssue.location.Count())&&(tIssue.location.GetAt(1).value'="") {
						Set tIssue.location.GetAt(1).value = "Error incurred by Bundle entry "_tEntryNum_": "_tIssue.location.GetAt(1).value
					}
				}
				Do tResponseStream.Clear(0)
				Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(tContentType, tOutcomeObj, tResponseStream, pRequest.FormatFHIROutput)
				Do tResponseStream.Rewind()
			}
			If $$$ISERR(tSC) {
				Do tResponseStream.Clear(0)
				Do tResponseStream.Write(tOutcomeString)
				Do tResponseStream.Rewind()
			}
		}
	} ElseIf $$$ISERR(tSC) {
		If pBundleType="transaction" TROLLBACK
	} Else {
		// Already TCOMMITed earlier.
	}
	
	// QuickStream cleanup is deferred until now so that cleanup happens regardless of transaction success.
	Set tEntryNum = ""
	For {
		Set tEntryNum = $Order(@pGlobalName@("EntryInfo",tEntryNum))
		If tEntryNum="" Quit
		// Clear the stream for the response resource, if any.
		Set tQStreamId = $Get(@pGlobalName@("EntryInfo",tEntryNum,"response.ResourceStreamId"))
		If tQStreamId'="" {
			Set tQStream = ##class(HS.SDA3.QuickStream).%OpenId(tQStreamId)
		} Else {
			Set tQStream = ""
		}
		If $IsObject(tQStream) Do tQStream.Clear()
		// Clear the QuickStream for the request resource.
		Set tQStream2Id = $Get(@pGlobalName@("EntryInfo",tEntryNum,"request.ResourceStreamId"))
		If tQStream2Id'="" {
			Set tQStream2 = ##class(HS.SDA3.QuickStream).%OpenId(tQStream2Id)
		} Else {
			Set tQStream2 = ""
		}
		If $IsObject(tQStream2) Do tQStream2.Clear()
	}
	
	Quit tSC
}

}
