Include HS.HC

/// This class contains the logic for processing FHIR operation interactions for FHIR STU3.
Class HS.FHIR.vSTU3.Repository.OperationProcessor Extends %RegisteredObject
{

Parameter SchematronXSLTDir = "FHIR/vSTU3/Schematron";

/// ProcessOperation is the main entry point to this class. The caller of this class method is
/// expected to have already initialized the response object, validated and set the response
/// ContentType, validated any user session identification and formulated a session identifier,
/// and - if applicable - verified that the operation is allowed as per the end point's
/// CapabilityStatement.
ClassMethod ProcessOperation(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If $Extract(pRequest.Interaction)'="$" {
			Set tSC = $$$ERROR($$$GeneralError, "Interaction '"_pRequest.Interaction_"' is not a FHIR operation")
			Quit
		}
		
		#; Get the method for the operation.
		#; Remove $, remove dash, words first char upper.
		#; Examples: $validate = Validate, $process-message = ProcessMessage
		
		Set tMethod = ""
		For i = 2:1:$Length(pRequest.Interaction) {
			Set tC = $Extract(pRequest.Interaction, i)
			If tC="-" Continue
			If i=2 Set tC = $ZConvert(tC,"U")
			If $Extract(pRequest.Interaction,i-1)="-" Set tC = $ZConvert(tC,"U")
			Set tMethod = tMethod_tC
		}
		
		Set tNoMethod = 0
		
		Try {
			Set tSC = $ClassMethod($this, tMethod, pRequest, .pResponse)
		} Catch eException2 {
			If eException2.Name'="<METHOD DOES NOT EXIST>" $$$ThrowStatus(eException2.AsStatus())
			Set tNoMethod = 1
		}
		
		If tNoMethod=1 {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", "FHIR operation '"_pRequest.Interaction_"' not supported")
			Quit
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod Validate(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tResourceSchemaRoot = pRequest.AdditionalInfo.GetAt("operation_ResourceSchemaRoot")
		Set tXSLT2Transformer = pRequest.AdditionalInfo.GetAt("operation_XSLT2Transformer")
		Set tRequestStream = pRequest.AdditionalInfo.GetAt("operation_RequestStream")
		Set tResponseStream = pRequest.AdditionalInfo.GetAt("operation_ResponseStream")
		
		Set tSchematronXSLTDir = ..#SchematronXSLTDir
		
		Set tErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		Set tErrorText = ""
		
		// First check the things that we can see without parsing the request payload.
		// Non-null pRequest.Type is expected to have already been validated earlier
		// by the component that called the ProcessOperation() method of this class.
		If pRequest.Type="" {
			Set tErrorText = "$validate request URL FHIR resource type not specified"
		} ElseIf (pRequest.Id="")&&(tRequestStream.Size=0) {
			Set tErrorText = "No resource id or resource payload specified on $validate request"
		} ElseIf pRequest.GetParameterCount("profile")>0 {
			Set tErrorText = "$validate by profile not supported"
		} ElseIf (pRequest.Parameters.Count()>0)&&(pRequest.GetParameterCount("profile")=0) {
			Set tErrorText = "Invalid $validate URL parameters"
		}
		If tErrorText'="" {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", tErrorText)
			Quit
		}
		
		// The Payload (Content Body) may be omitted, or may be only a FHIR resource,
		// or may be a Parameters resource that may include mode and/or profile and/or
		// a resource.
		//
		// tPayloadResourceType   : FHIR resource type of the top level of the Payload.
		// tPayloadResourceObj    : %DynamicObject or %XML.Document object representation
		//                          of the FHIR resource encompassing the entire Payload.
		// tValidationResourceType: FHIR resource type of the resource to be validated.
		// tValidationResourceObj : %DynamicObject or %XML.Document object representation
		//                          of the FHIR resource to be validated.
		
		Set tMode = ""
		Set tProfile = ""
		Set tPayloadResourceType = ""
		Set tPayloadResourceObj = ""
		
		Set tProfile = pRequest.GetParameterValue("profile", 1)
		
		If tRequestStream.Size>0 {
			Set tSC = ##class(HS.FHIR.Utils).CreateResourceObject(pRequest.ContentType, tRequestStream, .tPayloadResourceObj)
			If $$$ISERR(tSC) Quit
			Set tProperties = ##class(%Library.ArrayOfDataTypes).%New()
			Do tProperties.SetAt("", "resourceType")
			Set tSC = ##class(HS.FHIR.Utils).GetResourceInfo(pRequest.ContentType, , tPayloadResourceObj, tResourceSchemaRoot, .tProperties)
			If $$$ISERR(tSC) Quit
			Set tPayloadResourceType = tProperties.GetAt("resourceType")
			Set tSC = ##class(HS.FHIR.Utils).ValidateResourceTypeFHIR(tPayloadResourceType, tResourceSchemaRoot, .tIsValid)
			If $$$ISERR(tSC) Quit
			If 'tIsValid {
				Set tSC = $$$ERROR($$$GeneralError, "Invalid or unsupported $validate payload resource type '"_tPayloadResourceType_"'")
				Quit
			}
			If $IsObject(tPayloadResourceObj) {
				If tPayloadResourceObj.%IsA("%Library.DynamicObject") {
					Do ..GetValidateInfoJSON(tPayloadResourceObj, tPayloadResourceType, .tMode, .tProfile, .tValidationResourceObj, .tValidationResourceType)
				} ElseIf tPayloadResourceObj.%IsA("%XML.Document") {
					Do ..GetValidateInfoXML(tPayloadResourceObj, tPayloadResourceType, .tMode, .tProfile, .tValidationResourceObj, .tValidationResourceType)
				}
			}
			If (tMode="create")||(tMode="update")||(tMode="delete") {
				Set tErrorText = "$validate mode '"_tMode_"' not supported"
			} ElseIf tMode'="" {
				Set tErrorText = "Invalid $validate mode '"_tMode_"' specified"
			} ElseIf tProfile'="" {
				Set tErrorText = "$validate by profile not supported"
			} ElseIf $IsObject($Get(tValidationResourceObj)){
				If tValidationResourceType="" {
					Set tErrorText = "Unable to find resource type of resource to be validated"
				} ElseIf tValidationResourceType'=pRequest.Type {
					Set tErrorText = "Type of resource in request Parameters resource ("_tValidationResourceType_") does not match named type in request ("_pRequest.Type_")"
				}
			}
			If tErrorText'="" {
				Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", tErrorText)
				Quit
			}
		}
		
		If $IsObject($Get(tValidationResourceObj)) {
			Set tResourceContentType = pRequest.ContentType
		} Else {
			If pRequest.Id'="" {
				Set tSC = ##class(HS.FHIR.vSTU3.Repository.Storage).GetStorageIdByTypeAndId(pRequest.Type, pRequest.Id, , , .tStorageId)
				If $$$ISERR(tSC) {
					Set pResponse.Status = 404
					Set tErrorText = "Resource not found: "_pRequest.Type_" ID="_pRequest.Id
	  				Set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tErrorText, .tResponseStream, pRequest.ContentType, "not-found", pRequest.FormatFHIROutput)
					Quit
				}
				Set tValidationResourceStream = ##class(%Stream.TmpCharacter).%New()
				Set tSC = ##class(HS.FHIR.vSTU3.Repository.Storage).GetStorageDataByStorageId(tStorageId, , , , , .tResourceContentType, , , .tValidationResourceStream)
				If $$$ISERR(tSC) Quit
				Set tResourceContentType = $ZConvert(tResourceContentType, "L")
				Set tSC = ##class(HS.FHIR.Utils).CreateResourceObject(tResourceContentType, tValidationResourceStream, .tValidationResourceObj)
				If $$$ISERR(tSC) Quit
			} Else {
				Set tErrorText = "No resource id or resource specified on $validate request"
				Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", tErrorText)
				Quit
			}
		}
		
		// If the resource to validate is a resource embedded within a Parameters resource
		// in a FHIR XML Payload, tValidationResourceObj will be represented by a %XML.Node
		// object. In this case, make a new %XML.Document object from it, and replace
		// tValidationResourceObj with the new object.
		If tValidationResourceObj.%IsA("%XML.Node") {
			Set tSC = ##class(HS.FHIR.Utils).SerializeXMLNode(tPayloadResourceObj, tValidationResourceObj, .tXMLStream)
			If $$$ISERR(tSC) Quit
			Kill tValidationResourceObj
			Set tSC = ##class(HS.FHIR.Utils).CreateResourceObject("xml", tXMLStream, .tValidationResourceObj)
			If $$$ISERR(tSC) Quit
		}
		
		// Do schema-based validation on the resource.
		Set tSC = ##class(HS.FHIR.Validation.ResourceValidator).ValidateResource(tResourceContentType, , tResourceSchemaRoot, tValidationResourceObj, .tErrors)
		If ($$$ISERR(tSC))&&($system.Status.GetErrorText(tSC)'["Resource failed schema validation") Quit
		
		// Schematron validation requires a transformer object that can execute XSLT 2.0.
		If $IsObject($Get(tXSLT2Transformer))&&(tXSLT2Transformer.UseXSLT2=1) {
			// Do schematron-based validation on the resource.
			Set tSC = ##class(HS.FHIR.Validation.ResourceValidator).ValidateBySchematron(tResourceContentType, , tValidationResourceObj, tResourceSchemaRoot, pRequest.Type, tXSLT2Transformer, tSchematronXSLTDir, .tErrors)
			If ($$$ISERR(tSC))&&($system.Status.GetErrorText(tSC)'["Resource failed schematron validation") Quit
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Set tErrorText = $system.Status.GetErrorText(tSC)
	
	If (($$$ISOK(tSC))||(tErrorText["Resource failed schema validation")||(tErrorText["Resource failed schematron validation"))&&(+pResponse.Status'=400)&&(+pResponse.Status'=404) {
		If tErrors.Errors.Count()=0 {
			// If no errors at all, FHIR $validate specifies that an OperationOutcome containing
			// an informational OK should be returned, along with an HTTP 200 OK.
			Set tOperationOutcome = ##class(HS.FHIR.vSTU3.Model.Resource.OperationOutcome).%New()
			Set tIssue = ##class(HS.FHIR.vSTU3.Model.Resource.OperationOutcome.Issue).%New()
			Set pResponse.Status = 200
			Set tSC = tIssue.SetSeverity("information")
			If $$$ISOK(tSC) Set tSC = tIssue.SetCode("informational")
			If $$$ISOK(tSC) Set tSC = tIssue.SetDetails(, , , "OK")
			If $$$ISOK(tSC) Set tSC = tIssue.SetDiagnostics("OK")
			If $$$ISOK(tSC) Set tSC = tOperationOutcome.issue.Insert(tIssue)
			Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(pRequest.ContentType, tOperationOutcome, .tResponseStream, pRequest.FormatFHIROutput)
		} Else {
			// If only validation errors are incurred, FHIR $validate specifies that an
			// OperationOutcome containing the error details be returned, along with an
			// HTTP 200 OK.
			Set tSC = tErrors.GenerateOperationOutcomeStream(pRequest.ContentType, pRequest.FormatFHIROutput, .tResponseStream)
			If $$$ISERR(tSC) Quit
			Set pResponse.ContentType = pRequest.ContentType
		}
	}
	
	Quit tSC
}

/// GetValidateInfoJSON parses the %DynamicObject for the $validate request Payload,
/// to find and return values for mode and/or profile and/or a FHIR resource.
ClassMethod GetValidateInfoJSON(pPayloadResourceObj As %Library.DynamicObject, pPayloadResourceType As %String, pMode As %String, pProfile As %String, pResourceObj As %Library.DynamicObject, ByRef pResourceType As %String)
{
	Set pMode = ""
	Set pProfile = ""
	Set pResourceObj = ""
	
	If pPayloadResourceType'="Parameters" {
		Set pResourceObj = pPayloadResourceObj
		Set pResourceType = pPayloadResourceType
		Quit
	}
	
	Set tIterator = pPayloadResourceObj.%GetIterator()
	Set tPropName = ""
	For {
		If 'tIterator.%GetNext(.tPropName, .tData) Quit
		If tPropName="" Quit
		If tPropName="parameter" {
			// The 'parameter' property is a %DynamicArray.
			Set tName = ""
			Set tValueCode = ""
			Set tValueUri = ""
			Set tValueResource = ""
			Set tPropName2 = ""
			Set tIterator2 = tData.%GetIterator()
			For {
				// This loops through each element in the parameter %DynamicArray.
				If 'tIterator2.%GetNext(.tPropName2, .tData2) Quit
				Set tIterator3 = tData2.%GetIterator()
				For {
					// This loops through each element on the current parameter.
					If 'tIterator3.%GetNext(.tPropName3, .tData3) Quit
					If tPropName3="name" {
						Set tName = tData3
					} ElseIf tPropName3="valueCode" {
						Set tValueCode = tData3
					} ElseIf tPropName3="valueUri" {
						Set tValueUri = tData3
					} ElseIf tPropName3="resource" {
						Set tValueResource = tData3
					}
				}
				If (tName="mode")&&(tValueCode'="") {
					Set pMode = tValueCode
				} ElseIf (tName="profile")&&(tValueUri'="") {
					If pProfile'="" Set tProfile = tValueUri
				} ElseIf (tName="resource")&&(tValueResource'="") {
					Set pResourceObj = tValueResource
					Set pResourceType = pResourceObj.resourceType
				}
			}
		}
	}
	
	Quit
}

/// GetValidateInfoXML parses the %XML.Document for the $validate request Payload,
/// to find and return values for mode and/or profile and/or a FHIR resource.
ClassMethod GetValidateInfoXML(pPayloadResourceObj As %XML.Document, pPayloadResourceType As %String, pMode As %String, pProfile As %String, pResourceObj As %XML.Node, ByRef pResourceType As %String)
{
	Set pMode = ""
	Set pProfile = ""
	Set pResourceObj = ""
	
	If pPayloadResourceType'="Parameters" {
		Set pResourceObj = pPayloadResourceObj
		Set pResourceType = pPayloadResourceType
		Quit
	}
	
	#dim tNode As %XML.Node
	
	Set tNode = pPayloadResourceObj.GetDocumentElement()
	
	Set tTopResourceName = tNode.LocalName
	
	If tTopResourceName'="Parameters" {
		Set pResourceObj = tNode
		Set pResourceType = tTopResourceName
		Quit
	}
	
	// Save the current node id so that we may re-set back to it before returning.
	Set tSaveNodeId = tNode.NodeId
	
	// Try to move to the first child node, quit if no child nodes.
	If 'tNode.MoveToFirstChild(1) Quit
	
	Set tResourceNodeId = ""
	
	For {
		Set tPropName = tNode.LocalName
		Set tSaveNodeId2 = tNode.NodeId
		If tPropName="parameter" {
			Set tName = ""
			Set tValueCode = ""
			Set tValueUri = ""
			If 'tNode.MoveToFirstChild(1) Quit
			For {
				Set tPropName2 = tNode.LocalName
				If tPropName2'="resource" {
					Set tData2 = tNode.GetAttributeValue("value")
					If tPropName2="name" {
						Set tName = tData2
					} ElseIf tPropName2="valueCode" {
						Set tValueCode = tData2
					} ElseIf tPropName2="valueUri" {
						Set tValueUri = tData2
					}
				} Else {
					// If we are on the <resource> element, look down to the
					// first child to get the NodeId of the actual resource.
					Set tSaveNodeId3 = tNode.NodeId
					If tNode.MoveToFirstChild(1)
					Set tResourceNodeId = tNode.NodeId
					Set tNode.NodeId = tSaveNodeId3
				}
				If 'tNode.MoveToNextSibling(1) Quit
			}
			If (tName="mode")&&(tValueCode'="") {
				Set pMode = tValueCode
			} ElseIf (tName="profile")&&(tValueUri'="") {
				If pProfile="" Set pProfile = tValueUri
			}
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid Parameters resource structure in $validate request")
			Quit
		}
		Set tNode.NodeId = tSaveNodeId2
		// Try to move to the next sibling on this level, quit if no more siblings.
		If 'tNode.MoveToNextSibling(1) Quit
	}
	
	If tResourceNodeId'="" {
		// pResourceObj has the NodeId of the resource. Use it to set the NodeId
		// on tNode, then set pResourceObj to the tNode object.
		Set tNode.NodeId = tResourceNodeId
		If tNode.MoveToFirstChild(1) Set pResourceType = tNode.LocalName
		Set tNode.NodeId = tResourceNodeId
		Set pResourceObj = tNode
	}
	
	Quit
}

ClassMethod Meta(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod MetaAdd(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod Apply(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod DataRequirements(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod Subset(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod Implements(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod Conforms(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod Subsumes(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod Compose(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod Document(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod Translate(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod Closure(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod Everything(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tStorageClass = pRequest.AdditionalInfo.GetAt("operation_StorageClass")
		Set tResourceSchemaRoot = pRequest.AdditionalInfo.GetAt("operation_ResourceSchemaRoot")
		Set tRepositoryUtilityClass = pRequest.AdditionalInfo.GetAt("operation_RepositoryUtilityClass")
		Set tSessionIdentifier = pRequest.AdditionalInfo.GetAt("operation_SessionIdentifier")
		Set tSearchPostProcessorClass = pRequest.AdditionalInfo.GetAt("operation_SearchPostProcessorClass")
		Set tLoadPatientClass = pRequest.AdditionalInfo.GetAt("operation_LoadPatientClass")
		Set tHost = pRequest.AdditionalInfo.GetAt("operation_Host")
		Set tXSLT1Transformer = pRequest.AdditionalInfo.GetAt("operation_XSLT1Transformer")
		Set tRequestStream = pRequest.AdditionalInfo.GetAt("operation_RequestStream")
		Set tResponseStream = pRequest.AdditionalInfo.GetAt("operation_ResponseStream")
		
		// ContentType is going to be used a lot in this method - simplify it.
		If $ZConvert(pRequest.ContentType,"L")["json" {
			Set tContentType = "json"
		} Else {
			Set tContentType = "xml"
		}
		
		Set tEverythings("Patient") = ""
		Set tEverythings("Encounter") = ""
		Set tEverythings("RelatedPerson") = ""
		Set tEverythings("Practitioner") = ""
		Set tEverythings("Device") = ""
		
		Set tErrorText = ""
		If pRequest.Type="" {
			Set tErrorText = "$everything request must have resource type specified"
		} ElseIf '$Data(tEverythings(pRequest.Type)) {
			Set tErrorText = "$everything request not supported for resource type "_pRequest.Type
		} ElseIf pRequest.Id="" {
			Set tErrorText = "$everything request must specify resource id in request URL"
		}
		If tErrorText'="" {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", tErrorText)
			Quit
		}
		
		// Formulate the full base url to apply to all returned Bundle entries (except OperationOutcome).
		Set tBase = ##class(HS.FHIR.Utils).GetURLBase(pRequest, .tSC) quit:$$$ISERR(tSC)
		Set tQueryURL = ##class(HS.FHIR.Utils).GetURLWithQuery(pRequest, .tSC) quit:$$$ISERR(tSC)
		
		// In the context of LoadPatientClass, we equate FHIR Patient resource id with HealthShare MPIID.
		If (pRequest.Type="Patient")&&(tLoadPatientClass'="") {
			Set tSC = $ClassMethod(tLoadPatientClass, "LoadPatient", tHost, pRequest.Id, pRequest.SessionApplication, pRequest.SessionId)
			If $$$ISERR(tSC) Quit
		}
		
		Set tIncludeSecondary = 1
		
		Set tStorageIdErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		#dim tResultSet As HS.Util.TransientTable
		
		Set tSC = ..GetEverythingStorageIds(pRequest.Type, pRequest.Id, tStorageClass, tSessionIdentifier, tIncludeSecondary, .tResultSet, .tStorageIdErrors)
		
		If $$$ISERR(tSC) {
			Set tErrorText = $system.Status.GetErrorText(tSC)
			If tErrorText["Resource not found:" {
				// If the resource doesn't exist (not even deleted), return status 404 Not Found
				Set pResponse.Status = 404
				Set tSC = $$$OK
			} ElseIf tErrorText["Resource previously deleted" {
				// If the resource does exist but is deleted, return status 410 Gone.
				// For a regular read, Version should be null, so the method will return the deleted status of the current version.
				Set pResponse.Status = 410
				Set tSC = $$$OK
			} Else {
				Set pResponse.Status = 500
		  		Set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tErrorText, .tResponseStream, pRequest.ContentType, "exception", pRequest.FormatFHIROutput)
			}
		  	Quit
		}
		
		// By this point, we know the result set row count is greater than 0.
		Set tTotalStorageIds = tResultSet.%ROWCOUNT
		
		// Get the column numbers, because %GetData() is far faster than %Get().
		Set tIDColumnNumber = tResultSet.%ColumnIndex("ID",.tSC)
		Set tDeletedColumnNumber = tResultSet.%ColumnIndex("Deleted",.tSC)
		Set tResourceTypeColumnNumber = tResultSet.%ColumnIndex("ResourceType",.tSC)
		Set tResourceIdColumnNumber = tResultSet.%ColumnIndex("ResourceId",.tSC)
		Set tModeColumnNumber = tResultSet.%ColumnIndex("Mode",.tSC)
		Set tRefersToColumnNumber = tResultSet.%ColumnIndex("RefersTo",.tSC)
		
		If tSearchPostProcessorClass'="" {
			Set tSC = $ClassMethod(tSearchPostProcessorClass, "PostProcessSearch", .tResultSet, pRequest.SessionApplication, pRequest.SessionId, "")
			If $$$ISERR(tSC) Quit
			
			// Best practice for a Search Post Processor would be to re-set the iterator
			// when done, but let's not count on it.
			Do tResultSet.%SetIterator(0)
			
			// Adjust the total count by checking for Deleted rows.
			Set tTotalStorageIds = 0
			While (tResultSet.%Next()) {
				If 'tResultSet.%GetData(tDeletedColumnNumber) {
					If $i(tTotalStorageIds)
				}
			}
			Do tResultSet.%SetIterator(0)
		}
		If $$$ISERR(tSC) Quit
		
		Set tSC = ##class(HS.FHIR.Utils).StartBundleStream(tContentType, .tResponseStream, , "searchset", tTotalStorageIds, , , tQueryURL)
		If $$$ISERR(tSC) Quit
		
		Set tStorageIdErrorCount = tStorageIdErrors.Errors.Count()
		
		Set tRowCount = 0
		
		Set tSearch("mode") = "match"
		
		If tTotalStorageIds>0 {
			While tResultSet.%Next() {
				If 'tResultSet.%GetData(tDeletedColumnNumber) {
					// The mode value for the Bundle entries differs from the Mode value in the result set.
					If $i(tRowCount)>1 Set tSearch("mode") = "include"
					Set tStorageId = tResultSet.%GetData(tIDColumnNumber)
					Set tFullUrl = tBase_"/"_tResultSet.%GetData(tResourceTypeColumnNumber)_"/"_tResultSet.%GetData(tResourceIdColumnNumber)
					Set tTempStream = ##class(%Stream.TmpCharacter).%New()
					Set tSC = ##class(HS.FHIR.vSTU3.Repository.Storage).ReadByStorageId(tContentType, tResourceSchemaRoot, tStorageId, , , .tTempStream, , .tErrors, 1)
					If $$$ISERR(tSC) Quit
					Set tSC = ##class(HS.FHIR.Utils).AddBundleEntryToStream(tContentType, .tResponseStream, tFullUrl, tTempStream, .tSearch, , , , (tRowCount=1), (((tTotalStorageIds>1)&&(tRowCount<tTotalStorageIds))||(tStorageIdErrorCount>0)), ((tRowCount=tTotalStorageIds)&&(tStorageIdErrorCount=0)))
					If $$$ISERR(tSC) Quit
				}
			}
			If $$$ISERR(tSC) Quit
		}
		
		If tStorageIdErrorCount {
			// OperationOutcome entry does not count toward the "total" property value.
			Set tTempStream = ##class(%Stream.TmpCharacter).%New()
			Set tSC = tStorageIdErrors.GenerateOperationOutcomeStream(tContentType, , .tTempStream)
			If $$$ISERR(tSC) Quit
			Set tFullUrl = "OperationOutcome/"_$ZConvert($SYSTEM.Util.CreateGUID(),"L")
			Set tSC = ##class(HS.FHIR.Utils).AddBundleEntryToStream(tContentType, .tResponseStream, tFullUrl, tTempStream, , , , , (tTotalStorageIds=0), 0, 1)
			If $$$ISERR(tSC) Quit
		}
		
		Set tSC = ##class(HS.FHIR.Utils).EndBundleStream(tContentType, .tResponseStream)
		If $$$ISERR(tSC) Quit
		
		If pRequest.FormatFHIROutput {
			Set tTempStream = ##class(%Stream.TmpCharacter).%New()
			Set tSC = ##class(HS.FHIR.Utils).FormatFHIR(tContentType, tResponseStream, .tTempStream, $Char(32,32), $Char(13,10), tXSLT1Transformer, 2)
			If $$$ISERR(tSC) Quit
			if tResponseStream.%IsA("HS.SDA3.QuickStream") {
				do tResponseStream.Clear(0)
			} else {
				do tResponseStream.Clear()
			}
			do tResponseStream.CopyFrom(tTempStream)
		}
		
		Set pResponse.Status = 200
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// GetEverythingStorageIds gathers and returns the storage ids that should be included in the
/// specified $everything interaction.<br>
/// Inputs:<br>
/// <li>pResourceType      : (required) FHIR resource type. For STU3, valid resource types for $everything
///                          are Patient, Encounter, RelatedPerson, Practitioner, Device.
/// <li>pResourceId        : (required) FHIR resource id.
/// <li>pStorageClass      : (required) Storage logic class for this method call. Example is:
///                          "HS.FHIR.vSTU3.Repository.Storage".
/// <li>pSessionIdentifier : User session identifier.
/// <li>pIncludeSecondary  : 0 = Do not include resources that are referenced by the resources that
///                          refer to the specified target of the $everything interaction.
///                          1 = Include resources that are referenced by the resources that refer to
///                          the specified target of the $everything interaction.
/// <br>Outputs:<br>
/// <li>pResultSet         : HS.Util.TransientTable result set object. Each row represents a single
///                          FHIR resource. Result set columns are:
///                          ID          : Physical storage id.
///                          Deleted     : Initialized here as blank, may be used by post processor to
///                                        mark a row as "Deleted".
///                          ResourceType: FHIR resource type.
///                          ResourceId  : FHIR resource id
///                          Mode        : "match" means this is a matched resource, "include" means
///                                        this row was pulled in due to being referred to by a
///                                        matched resource.
///                          RefersTo    : Comma-delimited list of storage ids to which the resource
///                                        points to.
/// <li>pErrors            : HS.Types.FHIR.Errors object that includes a collection of error information.
///                          See <class>HS.Types.FHIR.Errors</class> for more details.<br>
ClassMethod GetEverythingStorageIds(pResourceType As %String, pResourceId As %String, pStorageClass As %String, pSessionIdentifier As %String, pIncludeSecondary As %Boolean = 1, ByRef pResultSet As HS.Util.TransientTable, ByRef pErrors As HS.Types.FHIR.Errors) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pErrors)) Set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		If '$IsObject($Get(pResultSet)) {
			Set pResultSet = ##class(HS.Util.TransientTable).%New()
			Set tDeletedColNum = pResultSet.%AddColumn("Deleted", "%String")
			Set tIDColNum = pResultSet.%AddColumn("ID", "%String")
			Set tResourceTypeColNum = pResultSet.%AddColumn("ResourceType", "%String")
			Set tResourceIdColNum = pResultSet.%AddColumn("ResourceId", "%String")
			Set tModeColNum = pResultSet.%AddColumn("Mode", "%String")
			Set tRefersToColNum = pResultSet.%AddColumn("RefersTo", "%String")
		}
		
		Set tSC = ##class(HS.FHIR.vSTU3.Repository.Storage).GetStorageIdByTypeAndId(.pResourceType, .pResourceId, , .pSessionIdentifier, .tStorageId)
		If $$$ISERR(tSC) Quit
		
		Set tRootReference = pResourceType_"/"_pResourceId
		
		Set tStorageIdsIndex = 0
		
		// The first storage id is for the primary resource (Patient, Encounter, RelatedPerson,
		// Practitioner, or Device).
		If $i(tStorageIdsIndex) {
			Set tStorageIds("ByStorageId", tStorageId) = tStorageIdsIndex
			Set tStorageIds = tStorageIdsIndex
			Do pResultSet.%NewRow()
			Do pResultSet.%SetData(tDeletedColNum, "")
			Do pResultSet.%SetData(tIDColNum, tStorageId)
			Do pResultSet.%SetData(tResourceTypeColNum, pResourceType)
			Do pResultSet.%SetData(tResourceIdColNum, pResourceId)
			Do pResultSet.%SetData(tModeColNum, "match")
			Set tSC = pResultSet.%SaveRow()
			If $$$ISERR(tSC) Quit
			Set tReferencesDone(tRootReference) = ""
			Set tReferenceToStorageId(tRootReference) = tStorageId
		}
		
		// For gathering the storage ids, we don't have the need to do a full "Read" on the
		// resource, so just get data straight from the storage object, since we already
		// know that the storage id is ok.
		Set tResourceStream = ""
		Set tSC = ##class(HS.FHIR.vSTU3.Repository.Storage).GetStorageDataByStorageId(tStorageId, , , , , .tStoredFormat, , , .tResourceStream)
		If $$$ISERR(tSC) Quit
		
		// Gather the references from the primary resource into the tReferences array. For
		// the purposes of this method, just use the resource content in its stored format.
		Set tRefCount = +$Get(tReferences)
		If tStoredFormat="JSON" {
			Set tSC = ..GetReferencesJSON(tResourceStream, pResourceType, pResourceId, .tReferences)
		} Else {
			Set tSC = ..GetReferencesXML(tResourceStream, pResourceType, pResourceId, .tReferences)
		}
		If $$$ISERR(tSC) Quit
		If +$Get(tReferences)>tRefCount {
			For i = (tRefCount+1):1:tReferences {
				Set tRefersTo(tStorageId,tReferences(i,"ReferenceValue")) = ""
			}
		}
		
		#dim tSearchRelatedResultSet As HS.Util.TransientTable
		
		Set tSC = ##class(HS.FHIR.vSTU3.Repository.Storage).SearchRelated(pResourceType, pResourceId, pSessionIdentifier, .tSearchRelatedResultSet)
		If $$$ISERR(tSC) Quit
		
		Set tStorageIdColumnNumber = tSearchRelatedResultSet.%ColumnIndex("ID",.tSC)
		
		// This loop gathers the storage ids for the resources that refer to the primary resource.
		While tSearchRelatedResultSet.%Next() {
			Set tStorageId = tSearchRelatedResultSet.%GetData(tStorageIdColumnNumber)
			If '$Data(tStorageIds("ByStorageId", tStorageId)) {
				// For gathering the storage ids, we don't have the need to do a full "Read" on the
				// resource, so just get data straight from the storage object, since we already
				// know that the storage id is ok.
				Set tResourceStream = ""
				Set tSC = ##class(HS.FHIR.vSTU3.Repository.Storage).GetStorageDataByStorageId(tStorageId, .tResourceType, .tResourceId , , , .tStoredFormat, , , .tResourceStream)
				If $$$ISERR(tSC) Quit
				If $i(tStorageIdsIndex) {
					Set tStorageIds("ByStorageId", tStorageId) = tStorageIdsIndex
					Set tStorageIds = tStorageIdsIndex
					Do pResultSet.%NewRow()
					Do pResultSet.%SetData(tDeletedColNum, "")
					Do pResultSet.%SetData(tIDColNum, tStorageId)
					Do pResultSet.%SetData(tResourceTypeColNum, tResourceType)
					Do pResultSet.%SetData(tResourceIdColNum, tResourceId)
					Do pResultSet.%SetData(tModeColNum, "match")
					Set tSC = pResultSet.%SaveRow()
					If $$$ISERR(tSC) Quit
					Set tReferencesDone(tResourceType_"/"_tResourceId) = ""
					Set tReferenceToStorageId(tResourceType_"/"_tResourceId) = tStorageId
				}
				// Gather the references from this resource into the tReferences array. For the
				// purposes of this method, just use the resource content in its stored format.
				Set tRefCount = +$Get(tReferences)
				If tStoredFormat="JSON" {
					Set tSC = ..GetReferencesJSON(tResourceStream, tResourceType, tResourceId, .tReferences)
				} Else {
					Set tSC = ..GetReferencesXML(tResourceStream, tResourceType, tResourceId, .tReferences)
				}
				If $$$ISERR(tSC) Quit
				If +$Get(tReferences)>tRefCount {
					For i = (tRefCount+1):1:tReferences {
						Set tRefersTo(tStorageId,tReferences(i,"ReferenceValue")) = ""
					}
				}
			}
		}
		If $$$ISERR(tSC) Quit
		
		// This loop gathers the storage ids for the resources that each of the previously gathered
		// resources refers to.
		If pIncludeSecondary {
			Set tIndex = ""
			For {
				Set tIndex = $Order(tReferences(tIndex))
				If tIndex="" Quit
				Set tRefValue = tReferences(tIndex, "ReferenceValue")
				If $Data(tReferencesDone(tRefValue)) Continue
				Set tContainingResourceType = tReferences(tIndex, "ResourceType")
				Set tContainingResourceId = tReferences(tIndex, "ResourceId")
				// Skip references to contained resources.
				If $Extract(tRefValue)="#" Continue
				// Skip the primary resource.
				If tRefValue=tRootReference Continue
				// Skip absolute URLs.
				If $Extract(tRefValue,1,4)="http" Continue
				If tRefValue'["/" {
					Set tText = "Reference contains no type, will not be included in response Bundle. Found in: Resource Type="_tContainingResourceType_", Resource Id="_tContainingResourceId_", Reference value="_tRefValue
					If '$Data(tLoggedText(tText)) {
						Do pErrors.logError("required", "warning", tText, , , , tText)
						Set tLoggedText(tText) = ""
					}
					Continue
				}
				// Alert for unrecognized format
				If $Length(tRefValue, "/")'=2 {
					Set tText = "Unrecognized reference format, will not be included in response Bundle. Found in: Resource Type="_tContainingResourceType_", Resource Id="_tContainingResourceId_", Reference value="_tRefValue
					If '$Data(tLoggedText(tText)) {
						Do pErrors.logError("invalid", "warning", tText, , , , tText)
						Set tLoggedText(tText) = ""
					}
					Continue
				}
				Set tType = $Piece(tRefValue, "/", 1)
				Set tResourceId = $Piece(tRefValue, "/", 2)
				// Do not include referenced patients, for example if they belong to a group that is related to the identified patient,
				// as this would give away potentially confidential information about the referenced patients as well.
				If tType="Patient" {
					Set tText = "For confidentiality reasons, referenced patients are not included in the response Bundle. Found in: Resource Type="_tContainingResourceType_", Resource Id="_tContainingResourceId_", Reference value="_tRefValue
					If '$Data(tLoggedText(tText)) {
						Do pErrors.logError("suppressed", "warning", tText, , , , tText)
						Set tLoggedText(tText) = ""
					}
					Continue
				}
				If (tType="")||(tResourceId="")  {
					Set tText = "Invalid reference value, will not be included in response Bundle. Found in: Resource Type="_tContainingResourceType_", Resource Id="_tContainingResourceId_", Reference value="_tRefValue
					If '$Data(tLoggedText(tText)) {
						Do pErrors.logError("invalid", "warning", tText, , , , tText)
						Set tLoggedText(tText) = ""
					}
					Continue
				}
				If $Data(tReferenceToStorageId(tRefValue)) {
					Set tStorageId = tReferenceToStorageId(tRefValue)
				} Else {
					Set tSC = ##class(HS.FHIR.vSTU3.Repository.Storage).GetStorageIdByTypeAndId(tType, tResourceId, , pSessionIdentifier, .tStorageId)
					If $$$ISERR(tSC) {
						If $system.Status.GetErrorText(tSC)["Resource previously deleted" {
							Set tText = "Resource previously deleted, will not be included in response Bundle. Found in: Resource Type="_tContainingResourceType_", Resource Id="_tContainingResourceId_", Reference value="_tRefValue
							Set tSC = $$$OK
							If '$Data(tLoggedText(tText)) {
								Do pErrors.logError("invalid", "warning", tText, , , , tText)
								Set tLoggedText(tText) = ""
							}
							Continue
						} Else {
							// Warn on error trying to get this resource, don't make it fatal
							// to the whole $everything.
							Set tText = $system.Status.GetErrorText(tSC)
							Set tSC = $$$OK
							If '$Data(tLoggedText(tText)) {
								Do pErrors.logError($Select($ZConvert(tText,"L")["not found":"not-found",1:"invalid"), "warning", tText, , , , tText)
								Set tLoggedText(tText) = ""
							}
							Continue
						}
					}
					Set tReferenceToStorageId(tRefValue) = tStorageId
				}
				If '$Data(tStorageIds("ByStorageId", tStorageId)) {
					// For gathering the storage ids, we don't have the need to do a full "Read" on the
					// resource, so just get data straight from the storage object, since we already
					// know that the storage id is ok.
					Set tResourceStream = ""
					Set tSC = ##class(HS.FHIR.vSTU3.Repository.Storage).GetStorageDataByStorageId(tStorageId, .tResourceType, .tResourceId , , , .tStoredFormat, , , .tResourceStream)
					If $$$ISERR(tSC) Quit
					If $i(tStorageIdsIndex) {
						Set tStorageIds("ByStorageId", tStorageId) = tStorageIdsIndex
						Set tStorageIds = tStorageIdsIndex
						Do pResultSet.%NewRow()
						Do pResultSet.%SetData(tDeletedColNum, "")
						Do pResultSet.%SetData(tIDColNum, tStorageId)
						Do pResultSet.%SetData(tResourceTypeColNum, tResourceType)
						Do pResultSet.%SetData(tResourceIdColNum, tResourceId)
						Do pResultSet.%SetData(tModeColNum, "include")
						Set tSC = pResultSet.%SaveRow()
						If $$$ISERR(tSC) Quit
						Set tReferencesDone(tResourceType_"/"_tResourceId) = ""
						Set tReferenceToStorageId(tResourceType_"/"_tResourceId) = tStorageId
					}
				}
			}
		}
		If $$$ISERR(tSC) quit
		
		// Go back through the result set rows and update the RefersTo column as needed.
		If $IsObject($Get(pResultSet)) {
			Do pResultSet.%SetIterator(0)
			While pResultSet.%Next() {
				Set tStorageId = pResultSet.%GetData(tIDColNum)
				Set tString = ""
				Set tReference = ""
				For {
					Set tReference = $Order(tRefersTo(tStorageId,tReference))
					If tReference="" Quit
					Set tOtherStorageId = $Get(tReferenceToStorageId(tReference))
					If tOtherStorageId'="" {
						If tString'="" Set tString = tString_","
						Set tString = tString_tOtherStorageId
					}
				}
				If tString'="" {
					Do pResultSet.%SetData(tRefersToColNum,tString)
					Set tSC = pResultSet.%SaveRow()
					If $$$ISERR(tSC) Quit
				}
			}
			Do pResultSet.%SetIterator(0)
		}
			
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// GetReferencesXML parses a FHIR XML resource string or stream and collects all reference
/// values found. This method assumes that all reference values are found in the reference
/// property of a Reference-typed property object, and are not from that object's identifier
/// value.
ClassMethod GetReferencesXML(pXMLStringOrStream, pResourceType As %String, pResourceId As %String, ByRef pReferences As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tQuote = """"
		
		Set tBuffer = ""
		Set tInReference = 0
		Set tReferenceValue = ""
		
		Set tIsString = '$IsObject($Get(pXMLStringOrStream))
		
		For {
			If tIsString {
				Set tString = pXMLStringOrStream
			} Else {
				Set tString = pXMLStringOrStream.Read(32000, .tSC)
				If $$$ISERR(tSC) Quit
			}
			For tPosition = 1:1:$Length(tString) {
				Set tChar = $Extract(tString, tPosition)
				
				Set tBuffer = tBuffer_tChar
				
				If $Length(tBuffer)>18 Set tBuffer = $Extract(tBuffer,2,*)
				
				If tInReference=0 {
					If tBuffer="<reference value=""" Set tInReference = 1
				} Else {
					If tChar=tQuote {
						If tReferenceValue'="" {
							If $i(pReferences)
							Set pReferences(pReferences, "ReferenceValue") = tReferenceValue
							Set pReferences(pReferences, "ResourceType") = pResourceType
							Set pReferences(pReferences, "ResourceId") = pResourceId
						}
						Set tReferenceValue = ""
						Set tInReference = 0
					} Else {
						Set tReferenceValue = tReferenceValue_tChar
					}
				}
			}
			If tIsString Quit
			If pXMLStringOrStream.AtEnd Quit
		}

	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// GetReferencesJSON parses a FHIR JSON resource string or stream and collects all reference
/// values found. This method assumes that all reference values are found in the reference
/// property of a Reference-typed property object, and are not from that object's identifier
/// value.
ClassMethod GetReferencesJSON(pJSONStringOrStream, pResourceType As %String, pResourceId As %String, ByRef pReferences As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSpace = $Char(32)
		Set tTab = $Char(9)
		Set tLF = $Char(10)
		Set tCR = $Char(13)
		Set tWhitespace = tSpace_tTab_tLF_tCR
		
		Set tQuote = """"
		
		Set tBuffer = ""
		Set tInReference = 0
		Set tReferenceValue = ""
		
		Set tIsString = '$IsObject($Get(pJSONStringOrStream))
		
		For {
			If tIsString {
				Set tString = pJSONStringOrStream
			} Else {
				Set tString = pJSONStringOrStream.Read(32000, .tSC)
				If $$$ISERR(tSC) Quit
			}
			For tPosition = 1:1:$Length(tString) {
				Set tChar = $Extract(tString, tPosition)
				If tWhitespace[tChar Continue
				
				Set tBuffer = tBuffer_tChar
				
				If $Length(tBuffer)>13 Set tBuffer = $Extract(tBuffer,2,*)
				
				If tInReference=0 {
					If tBuffer="""reference"":""" Set tInReference = 1
				} Else {
					If tChar=tQuote {
						If tReferenceValue'="" {
							If $i(pReferences)
							Set pReferences(pReferences, "ReferenceValue") = tReferenceValue
							Set pReferences(pReferences, "ResourceType") = pResourceType
							Set pReferences(pReferences, "ResourceId") = pResourceId
						}
						Set tReferenceValue = ""
						Set tInReference = 0
					} Else {
						Set tReferenceValue = tReferenceValue_tChar
					}
				}
			}
			If tIsString Quit
			If pJSONStringOrStream.AtEnd Quit
		}

	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod Find(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod EvaluateMeasure(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod ProcessMessage(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod Stats(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

/// Support the $lastn operation: http://hl7.org/fhir/STU3/observation-operations.html#lastn
ClassMethod Lastn(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tRepositoryUtilityClass = pRequest.AdditionalInfo.GetAt("operation_RepositoryUtilityClass")
		
		Set tErrorText = ""
		
		If pRequest.Type="" {
			Set tErrorText = "Resource type missing from $lastn interaction - must be Observation"
		} ElseIf pRequest.Type'="Observation" {
			Set tErrorText = "Invalid resource type "_pRequest.Type_" on $lastn interaction - must be Observation"
		}
		If tErrorText'="" {
			Set tSC = $ClassMethod(tRepositoryUtilityClass, "BadRequest", pRequest, .pResponse, "invalid", tErrorText)
			Quit
		}
		
		// Can have only one of either patient parameter, or a subject search parameter that points
		// to Patient. Search parameters chained to Patient resource type are not allowed.
		
		Set tPatParamCount = 0
		Set tPatParam = ""
		Set tHasPatChain = 0
		Set tCount0 = 0
		Set tMax = 1
		Set tSortParam = ""
		
		Set tWholeParam = ""
		For {
			Set tParamVals = pRequest.Parameters.GetNext(.tWholeParam)
			If tWholeParam="" Quit
			If (($Extract(tWholeParam,1,8)="patient.")||($Extract(tWholeParam,1,8)="patient:")||($Extract(tWholeParam,1,16)="subject:Patient.")||($Extract(tWholeParam,1,8)="subject.")) {
				Set tHasPatChain = 1
			} ElseIf tWholeParam="patient" {
				Set tPatParamCount = tPatParamCount + $ListLength(tParamVals)
				Set tPatParam = $ListGet(tParamVals)
			} ElseIf $Extract(tWholeParam,1,7)="subject" {
				// Do not prevent subject chained to non-Patient resource type.
				If $Extract(tWholeParam,1,8)'="subject:" {
					For tListIndex = 1:1:$ListLength(tParamVals) {
						If $Piece($ListGet(tParamVals, tListIndex), "/", *-1)="Patient" {
							If $i(tPatParamCount)
							Set tPatParam = $ListGet(tParamVals)
						}
					}
				}
			} ElseIf tWholeParam="_summary" {
				If $ListGet(tParamVals)="count" Set tCount0 = 1
			} ElseIf tWholeParam="_count" {
				If $ListGet(tParamVals)'="0" {
					Do pRequest.Parameters.RemoveAt(tWholeParam)
				} Else {
					Set tCount0 = 1
				}
			} ElseIf tWholeParam="max" {
				Set tMax = $ListGet(tParamVals)
				Do pRequest.Parameters.RemoveAt(tWholeParam)
			} ElseIf tWholeParam="_sort" {
				Set tSortParam = $ListGet(tParamVals)
			}
		}
		
		If tHasPatChain {
			Set tErrorText = "Chained patient search parameter not allowed on $lastn interaction"
		} ElseIf tPatParamCount=0 {
			Set tErrorText = "No patient or subject search parameter included on $lastn interaction"
		} ElseIf tPatParamCount>1 {
			Set tErrorText = "Invalid multiple patient and/or subject search parameter values on $lastn interaction"
		} ElseIf (+tMax<1)||(tMax'?1N.N) {
			Set tErrorText = "Invalid format for max parameter on $lastn interaction - must be positive integer"
		}
		If tErrorText'="" {
			Set tSC = $ClassMethod(tRepositoryUtilityClass, "BadRequest", pRequest, .pResponse, "invalid", tErrorText)
			Quit
		}
		
		// If necessary, re-build _sort parameter value, starting with
		// "code,-date", and then add on any remaining keys.
		If tSortParam="" {
			Do pRequest.SetParameter("_sort", "code,-date")
		} ElseIf $Extract(tSortParam,1,10)'="code,-date" {
			Set tNewSortParam = "code,-date"
			For i = 1:1:$Length(tSortParam,",") {
				Set tKey = $Piece(tSortParam, ",", i)
				If '((tKey="code")||(tKey="-date")||(tKey="-code")||(tKey="date")) {
					Set tNewSortParam = tNewSortParam_","_tKey
				}
			}
			Do pRequest.SetParameter("_sort", tNewSortParam)
		}
		
		Set tStorageClass = pRequest.AdditionalInfo.GetAt("operation_StorageClass")
		Set tResourceSchemaRoot = pRequest.AdditionalInfo.GetAt("operation_ResourceSchemaRoot")
		Set tSessionIdentifier = pRequest.AdditionalInfo.GetAt("operation_SessionIdentifier")
		Set tSearchPostProcessorClass = pRequest.AdditionalInfo.GetAt("operation_SearchPostProcessorClass")
		Set tLoadPatientClass = pRequest.AdditionalInfo.GetAt("operation_LoadPatientClass")
		Set tHost = pRequest.AdditionalInfo.GetAt("operation_Host")
		Set tXSLT1Transformer = pRequest.AdditionalInfo.GetAt("operation_XSLT1Transformer")
		Set tRequestStream = pRequest.AdditionalInfo.GetAt("operation_RequestStream")
		Set tResponseStream = pRequest.AdditionalInfo.GetAt("operation_ResponseStream")
		Set tMaxSearchResults = pRequest.AdditionalInfo.GetAt("operation_MaxSearchResults")
		
		// Formulate the full base url to apply to all returned Bundle entries (except OperationOutcome).
		Set tBaseURL = $ClassMethod(tRepositoryUtilityClass, "GetURLBase", pRequest, .tSC)
		$$$ThrowOnError(tSC)
		Set tQueryURL = $ClassMethod(tRepositoryUtilityClass, "GetURLWithQuery", pRequest, .tSC)
		$$$ThrowOnError(tSC)
		
		// In the context of LoadPatientClass, we equate FHIR Patient resource id with HealthShare MPIID.
		If tLoadPatientClass'="" {
			Set tMPIID = $Piece(tPatParam, "/", *)
			Set tSC = $ClassMethod(tLoadPatientClass, "LoadPatient", tHost, tMPIID, pRequest.SessionApplication, pRequest.SessionId)
			$$$ThrowOnError(tSC)
		}
		
		Set tSearchErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		Set tSC = $ClassMethod(tStorageClass, "Lastn", pRequest.Parameters, tMax, tSessionIdentifier, .tResultSet, .tSearchErrors, , tSearchPostProcessorClass, pRequest.SessionApplication, pRequest.SessionId)
		If $$$ISERR(tSC) {
			// Check for various error conditions that really should returned as
			// something other than 500 Internal Server Error.
			Set tErrorText = $system.Status.GetOneErrorText(tSC)
			Set tCode = ""
			If (tErrorText [ "Unsupported modifier on param") {
				Set tCode = "not-supported"
			} ElseIf (tErrorText [ "Specifying system value on token-type search parameter") {
				Set tCode = "not-supported"
			} ElseIf (tErrorText [ "Resource type must be Observation") {
				Set tCode = "invalid"
			} ElseIf (tErrorText [ "Neither patient nor subject search parameter specified") {
				Set tCode = "invalid"
			} ElseIf (tErrorText [ "Cannot specify both patient and subject search parameter") {
				Set tCode = "invalid"
			} ElseIf (tErrorText [ "First two _sort keys must be code,-date") {
				Set tCode = "invalid"
			} ElseIf (tErrorText [ "Use of 'above' or 'below' modifier") {
				Set tCode = "invalid"
			} ElseIf (tErrorText [ "Invalid search parameters found") {
				Set tSC = tSearchErrors.GenerateOperationOutcomeStream(pRequest.ContentType, pRequest.FormatFHIROutput, .tResponseStream)
				Set pResponse.Status = 400
			} ElseIf ($ZConvert(tErrorText,"L") [ "sort") {
				Set tCode = "invalid"
			}
			If tCode'="" {
				// This should set tSC back to $$$OK
				Set tSC = $ClassMethod(tRepositoryUtilityClass, "BadRequest", pRequest, .pResponse, tCode, tErrorText)
			}
			Quit
		}
		If '$IsObject($Get(tResultSet)) {
			Set tSC = $$$ERROR($$$GeneralError, "Unknown search error, resultset object not found")
			Quit
		}
		If tResultSet.%ROWCOUNT > tMaxSearchResults {
			Set tErrorText = "Search selects more than maximum allowed number of results: "_tMaxSearchResults
			Set tSC = $ClassMethod(tRepositoryUtilityClass, "BadRequest", pRequest, .pResponse, "too-costly", tErrorText)
			Quit
		}
		
		Do ..ResultSetToBundleNoPaging(pRequest, tResponseStream, tResultSet, tCount0, tBaseURL, tQueryURL, tSearchErrors, tRepositoryUtilityClass, tStorageClass, tXSLT1Transformer, tResourceSchemaRoot)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod ResultSetToBundleNoPaging(pRequest, pResponseStream, pResultSet As HS.Util.TransientTable, pCount0, pBaseURL, pQueryURL, pWarnings, pRepositoryUtilityClass, pRepositoryStorageClass, pTransformer, pResourceSchema)
{
	// ContentType is going to be used a lot in this method - simplify it.
	If $ZConvert(pRequest.ContentType,"L")["json" {
		Set tContentType = "json"
	} Else {
		Set tContentType = "xml"
	}
	
	// Get the resultset column numbers so that we can use %GetData() instead of %Get().
	Set tDelim = ","
	Set tCoreColumns = "Deleted"_tDelim_"ID"_tDelim_"ResourceType"_tDelim_"ResourceId"_tDelim_"Mode"_tDelim_"RefersTo"
	Set tAdditionalColumns = ""
	Set tAllColumns = tCoreColumns_tAdditionalColumns
	For i = 1:1:$Length(tAllColumns, tDelim) {
		Set tColumnName = $Piece(tAllColumns, tDelim, i)
		If tColumnName'="" {
			Set tColNums(tColumnName) = pResultSet.%ColumnIndex(tColumnName, .tSC)
			If 'tSC $$$ThrowStatus($$$ERROR($$$GeneralError, "Error retrieving result set column number for "_tColumnName))
		}
	}
	
	// We need the match result count for Bundle.total up front, so make a separate
	// pass through the result set to get the count.
	Set tResultCount = 0
	While (pResultSet.%Next()) {
		If ('pResultSet.%GetData(tColNums("Deleted")))&&(pResultSet.%GetData(tColNums("Mode"))="match") {
			If $i(tResultCount)
		}
	}
	Do pResultSet.%SetIterator(0)
	
	// To maximize performance this method constructs the Bundle using streams only.
	
	Set tSC = $ClassMethod(pRepositoryUtilityClass, "StartBundleStream", tContentType, .pResponseStream, , "searchset", tResultCount, , , pQueryURL)
	$$$ThrowOnError(tSC)
	
	// pCount0 will be true when URL parameter _count=0 or _summary=count.
	//
	// From http://hl7.org/fhir/STU3/search.html#count
	// if _count has the value 0, this shall be treated the same as _summary=count:
	// the server resturns a bundle that reports the total number of resources that
	// match in Bundle.total, but with no entries, and no prev/next/last links. Note
	// that the Bundle.total only include the total number of matching resources. It
	// does not count extra resources such as OperationOutcome or included resources
	// that may also be returned.
	// If there were warnings during the validation of the search parameters,
	// add them to the end of the Bundle as an OperationOutcome resource entry.
	// This entry does not count toward the Bundle "total" value.
	
	Set tRowWriteIndex = 0
	
	If 'pCount0 {
		While (pResultSet.%Next()) {
			If pResultSet.%GetData(tColNums("Deleted")) Continue
			if $i(tRowWriteIndex)
			Set tStreamletId = pResultSet.%GetData(tColNums("ID"))
			Set tMode = pResultSet.%GetData(tColNums("Mode"))
			
			If (pRequest.Interaction = "search-all") {
				Set tSC = $ClassMethod(pRepositoryStorageClass, "GetStorageObjectByStorageId", tStreamletId, .tStreamlet, .tStorageClass)
				$$$ThrowOnError(tSC)
				Set tType = $P(tStorageClass, ".", *)
			} Else {
				Set tSC = $ClassMethod(pRepositoryStorageClass, "GetStorageObjectByStorageId", tStreamletId, .tStreamlet, .tStorageClass)
				$$$ThrowOnError(tSC)
			}
			
			Set tResourceStream = ##class(%Stream.TmpCharacter).%New()
			Do tStreamlet.GetResourceAsStream(.tResourceStream)
			
			Set tFullUrl = pBaseURL_"/"_tStreamlet.ResourceType_"/"_tStreamlet.ResourceId
			
			If '(((tContentType="xml")&&(tStreamlet.Format="XML"))||((tContentType="json")&&(tStreamlet.Format="JSON"))) {
				Set tTempStream = ##class(%Stream.TmpCharacter).%New()
				If tStreamlet.Format="JSON" {
					Set tSC = $ClassMethod(pRepositoryUtilityClass, "JSONToXML", tResourceStream, .tTempStream, pResourceSchema)
				} Else {
					Set tSC = $ClassMethod(pRepositoryUtilityClass, "XMLToJSON", tResourceStream, .tTempStream, pResourceSchema)
				}
				$$$ThrowOnError(tSC)
				Kill tResourceStream
				Set tResourceStream = tTempStream
			}
			
			// Add the entry.
			Kill tSearch
			Set tSearch("mode") = tMode
			// The logic of this nested loop prevents any of the AddBundleEntryToStream calls to know
			// if they are the last call to be made for the Bundle. Therefore the pWriteComma and
			// pIsLastEntry input parameters are hard-set to 0, and a comma is written here for all
			// but the first entry.
			If (tRowWriteIndex>1)&&(tContentType="json") do pResponseStream.Write(",")
			Set tSC = $ClassMethod(pRepositoryUtilityClass, "AddBundleEntryToStream", tContentType, .pResponseStream, tFullUrl, tResourceStream, .tSearch, , , , (tRowWriteIndex=1), 0, 0)
			$$$ThrowOnError(tSC)
		}
	}
	
	// If there are warnings to report, add them to the end of the Bundle as an
	// OperationOutcome resource entry. This entry does not count toward the
	// Bundle "total" value.
	If pWarnings.Errors.Count()>0 {
		Set tSC = pWarnings.GenerateOperationOutcomeStream(tContentType, 0, .tOperationOutcomeStream)
		$$$ThrowOnError(tSC)
		If (tContentType="json")&&(tRowWriteIndex>0) Do pResponseStream.Write(",")
		Kill tSearch
		Set tSearch("mode") = "outcome"
		Set tSC = $ClassMethod(pRepositoryUtilityClass, "AddBundleEntryToStream", tContentType, .pResponseStream, , tOperationOutcomeStream, .tSearch, , , , (tRowWriteIndex=0), 0, 1)
		$$$ThrowOnError(tSC)
	} ElseIf tRowWriteIndex>0 {
		// If regular entries were written out but not an OperationOutcome entry,
		// we have not yet written out the closing to the collection of entries
		// for JSON. Do it here now.
		If tContentType="json" Do pResponseStream.Write("]")
	}
	
	Set tSC = $ClassMethod(pRepositoryUtilityClass, "EndBundleStream", tContentType, .pResponseStream)
	$$$ThrowOnError(tSC)
	
	If pRequest.FormatFHIROutput {
		Set tTempStream = ##class(%Stream.TmpCharacter).%New()
		Set tSC = $ClassMethod(pRepositoryUtilityClass, "FormatFHIR", tContentType, pResponseStream, .tTempStream, $Char(32,32), $Char(13,10), pTransformer, 2)
		$$$ThrowOnError(tSC)
		If pResponseStream.%IsA("HS.SDA3.QuickStream") {
			Do pResponseStream.Clear(0)
		} else {
			Do pResponseStream.Clear()
		}
		Do pResponseStream.CopyFrom(tTempStream)
	}
	
	Quit
}

ClassMethod Match(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod Populate(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod Populatehtml(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod Populatelink(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod Questionnaire(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod Expand(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod Lookup(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod ValidateCode(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

ClassMethod IhePix(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Quit $$$ERROR($$$GeneralError, "FHIR operation "_pRequest.Interaction_" not supported")
}

}
