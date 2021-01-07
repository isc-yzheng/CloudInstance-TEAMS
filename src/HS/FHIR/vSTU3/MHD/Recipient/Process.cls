Class HS.FHIR.vSTU3.MHD.Recipient.Process Extends (Ens.BusinessProcess, HS.HC.Util.Trace.Helper, HS.FHIR.vSTU3.MHD.Common, HS.Util.BaseHost) [ ClassType = persistent, Inheritance = right ]
{

Parameter HSDEPLOY = 1;

Parameter SETTINGS = "ProvideTarget,CustomProcessor";

Parameter RESTOPERATION = "HS.FHIR.REST.Operation";

Property ProvideTarget As Ens.DataType.ConfigName;

Property Errors As HS.Types.FHIR.Errors;

Property RepositoryOID As %String(MAXLEN = 64);

/// Defaults to \IHE\AffinityDomain [##class(HS.IHE.Util).GetAffinityDomain()]
/// if "" any patient will be accepted (versus turning off patient id validation) the AA in the request is sent to the 
Property AffinityDomain As %String [ InitialExpression = {##class(HS.IHE.Util).GetAffinityDomain()} ];

/// Class package that is the root of all resource schemas for the desired data model.
Property ResourceSchemaRoot As %String(MAXLEN = 256) [ InitialExpression = "HS.FHIR.vSTU3.Model.Resource" ];

Method OnRequest(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set ..Errors = ##class(HS.Types.FHIR.Errors).%New()
		Set ..RepositoryOID = ##class(HS.Data.OIDMap).GetOIDForCode($namespace,"")
		If pRequest.%IsA("HS.Message.FHIR.Request") {
			If pRequest.Interaction'="capabilities" {
				Set tSC = ..ProcessMHDMessage(pRequest, .pResponse)
			} Else {
				Set tSC = ..ProcessMetadataRequest(pRequest, .pResponse)
			}
		} Else {
			Set tText = "Message class "_pRequest.%ClassName(1)_" not handled by MHD responder"
			Do ..Errors.logError("invalid", "error", tText, , , , tText) 
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	
	If ..Errors.Errors.Count() {
		Set tSC = ..FHIRMHDErrorResponse(pRequest, .pResponse)
	} ElseIf $$$ISERR(tSC) {
		Set tSC = ##class(HS.FHIR.Utils).OperationOutcomeFromStatus(tSC, pRequest.ContentType, .pResponse, pRequest.FormatFHIROutput)
		Set pResponse.Status = 500
	}
	
	Quit tSC
}

Method ProcessMHDMessage(pRequest As HS.Message.FHIR.Request, Output pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		// If invalid ContentType per STU3 then change it to a valid ContentType.
		Set pRequest.ContentType = ##class(HS.FHIR.Utils).EnsureContentType(pRequest.ContentType, "STU3")
		
		Set tHSFHIRObj = ""
		
		If ..CustomProcessor'="" {
			// The payload content, if any, for this request message will be held
			// in either the Payload property or in a QuickStream. The developer
			// of the CustomProcessor will need to use the request message instance
			// method GetPayloadOref() to obtain the pointer to the object that
			// holds the payload content, if any.
			$$$OnPre(.tStop, pRequest, .tNewRequest)
			If $Get(tStop) Quit
			If $$$ISERR(tSC) Quit
			#; If success but no returned object, assume that it is because the
			#; pre processing method does not exist, i.e., CustomProcessor is
			#; defined, but it is used only for post processing.
			If $IsObject($Get(tNewRequest)) {
				Kill pRequest
				Set pRequest = tNewRequest
			}
			If $$$HSTRACING {
				If pRequest.QuickStreamId'="" {
					Set tQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(pRequest.QuickStreamId)
					$$$HSTRACE("Request after pre-processing", "pRequest,tQuickStream", pRequest.%ConstructClone(1), tQuickStream)
				} Else {
					$$$HSTRACE("Request after pre-processing", "pRequest", pRequest.%ConstructClone(1))
				}
			}
		}
		
		Set tSC = ..ProcessMHDProvide(pRequest, .tResponse)
		If $$$ISERR(tSC) Quit
		If (..Errors.Errors.Count())&&(..Errors.HighestError="error") Quit
		
		Set tSC = ..ProcessFHIRResponse(tResponse, .pResponse)
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If ..Errors.Errors.Count() {
		Set tSC = ..FHIRMHDErrorResponse(pRequest, .pResponse)
	} ElseIf $$$ISERR(tSC) {
		Set tSC = ##class(HS.FHIR.Utils).OperationOutcomeFromStatus(tSC, pRequest.ContentType, .pResponse, pRequest.FormatFHIROutput)
		Set pResponse.Status = 500
	}
	
	If $$$HSTRACING {
		If pResponse.QuickStreamId'="" {
			Set tQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(pResponse.QuickStreamId)
			$$$HSTRACE("FHIR response message to be returned", "pResponse,tQuickStream", pResponse, tQuickStream)
		} Else {
			$$$HSTRACE("FHIR response message to be returned", "pResponse", pResponse)
		}
	}
	
	Quit tSC
}

Method ProcessMHDProvide(pMHDRequest As HS.Message.FHIR.Request, Output pMHDResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		// Validate the properties of the HS FHIR request message, as per MHD Provide Document Bundle.
		Set tSC = ..ValidateMHDProvideMessage(pMHDRequest, .pMHDResponse)
		If $$$ISERR(tSC) Quit
		If (..Errors.Errors.Count())&&(..Errors.HighestError="error") Quit
		If ($IsObject($Get(pMHDResponse)))&&('##class(HS.FHIR.Helper).HttpSuccess(pMHDResponse.Status)) Quit
		
		// Validate the basics of the FHIR Bundle itself, as per MHD Provide Document Bundle.
		Set tSC = ..ValidateMHDProvideBundle(pMHDRequest, .tBundle, .tBundleIndex, .pMHDResponse)
		If $$$ISERR(tSC) Quit
		If (..Errors.Errors.Count())&&(..Errors.HighestError="error") Quit
		If ($IsObject($Get(pMHDResponse)))&&('##class(HS.FHIR.Helper).HttpSuccess(pMHDResponse.Status)) Quit
		
		// Do a detailed validate of the resources in the FHIR Bundle, as per MHD Provide Document Bundle.
		Set tPatientId = ""
		Set tSourcePatientId = ""
		Set tSC = ..ValidateMHDProvideResources(pMHDRequest, .tBundle, .tBundleIndex, .tPatientId, .tSourcePatientId)
		If $$$ISERR(tSC) Quit
		If (..Errors.Errors.Count())&&(..Errors.HighestError="error") Quit
		
		// Generate an XDSb Provide and Register request from the MHD Provide Document Bundle.
		Set tSC = ..RequestToProvideAndRegister(pMHDRequest, tBundle, .tBundleIndex, .tPatientId, .tSourcePatientId, .tProvideAndRegisterRequest)
		If $$$ISERR(tSC) Quit
		If (..Errors.Errors.Count())&&(..Errors.HighestError="error") Quit
		
		// Send the XDSb request to a target that will forward the request to XDSb services.
		Set tSC = ..SendRequestSync(..ProvideTarget, tProvideAndRegisterRequest, .tProvideAndRegisterResponse)
		If $$$ISERR(tSC) Quit
		
		// Transform the XDSb Provide and Register response to an MHD response and return it.
		Set tSC = ..PnRResponseToMHDResponse(pMHDRequest, tProvideAndRegisterResponse, tSC, .pMHDResponse)
		If $$$ISERR(tSC) Quit
		If (..Errors.Errors.Count())&&(..Errors.HighestError="error") Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Validate the HS FHIR request message - except for the Payload - per MHD requirements.
Method ValidateMHDProvideMessage(pMHDRequest As HS.Message.FHIR.Request, Output pMHDResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If pMHDRequest.Type'="" {
			Set tCode = "not-supported"
			Set tText = "Resource type not allowed on request URL for Provide Document Bundle"
			Do ..Errors.logError(tCode, "error", tText, , , , tText)
			Quit
		}
		
		If pMHDRequest.Interaction'="transaction" {
			Set tCode = "invalid"
			Set tText = "FHIR interaction "_pMHDRequest.Interaction_" not handled by MHD Recipient - must be transaction"
			Do ..Errors.logError(tCode, "error", tText, , , , tText)
			Quit
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Validate the FHIR Provide Document Bundle payload per MHD requirements.  This
/// method validates the basics of the Bundle, things that are apparent without
/// delving into the individual resource entries.  If valid, this method returns
/// the Bundle object, plus an index of Bundle entries for use by the remainder
/// of the Bundle processing.  If a validation failure occurs here, then this
/// this method simply builds the 400 Bad Request response and payload and returns
/// it.  Does not need to log it to ..Errors or send through FHIRMHDErrorResponse.
Method ValidateMHDProvideBundle(pMHDRequest As HS.Message.FHIR.Request, Output pBundle, Output pBundleIndex As %String, Output pMHDResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tRequestStream = pMHDRequest.GetPayloadOref()
		
		If tRequestStream.Size=0 {
			Set tCode = "invalid"
			Set tText = "Provide Document Bundle request FHIR payload missing"
			Do ..Errors.logError(tCode, "error", tText, , , , tText)
			Quit
		}
		
		// Retrieve the resource type, resource id, and the resource meta object from the Payload.
		Set tProperties = ##class(%Library.ArrayOfDataTypes).%New()
		Do tProperties.SetAt("", "resourceType")
		Do tProperties.SetAt("", "meta")
		Set tSC = ##class(HS.FHIR.Utils).GetResourceInfo(pMHDRequest.ContentType, tRequestStream, .tResourceObject, ..ResourceSchemaRoot, .tProperties)
		If $$$ISERR(tSC) Quit
		
		// If Payload is not a Bundle then no point in continuing validation.
		If tProperties.GetAt("resourceType")'="Bundle" {
			Set tCode = "invalid"
			Set tText = "Unexpected FHIR payload type '"_pBundle.%ClassName(0)_"' for Provide Document Bundle request"
			Do ..Errors.logError(tCode, "error", tText, , , , tText)
			Quit
		}
		
		Set tFoundMeta = 0
		If ($IsObject(tProperties.GetAt("meta")))&&($IsObject(tProperties.GetAt("meta").profile))&&(tProperties.GetAt("meta").profile.Count()>0) {
			For i = 1:1:tProperties.GetAt("meta").profile.Count() {
				Set tVal = tProperties.GetAt("meta").profile.GetAt(i).value
				If (tVal'="")&&($Extract(tVal,*)="/") Set tVal = $Extract(tVal,1,*-1)
				If tVal="http://ihe.net/fhir/tag/iti-65" Set tFoundMeta = 1 Quit
			}
		}
		If tFoundMeta=0 {
			Set tCode = "invalid"
			Set tText = "Bundle.meta.profile for iti-65 missing from Provide Document Bundle request"
			Do ..Errors.logError(tCode, "error", tText, , , , tText)
		}
		
		#dim tErrors As HS.Types.FHIR.Errors
		#dim tError As HS.Types.FHIR.Error
		
		Set tSC = ##class(HS.FHIR.Validation.ResourceValidator).ValidateResource( , , ..ResourceSchemaRoot, tResourceObject, .tErrors)
		If $$$ISERR(tSC) {
			// There is overlap in some validation items between ValidateResource and
			// ValidateBundle. If ValidateResource finds errors then stop and return
			// now in order to avoid duplicated validation issues being returned.
			If tErrors.Errors.Count()>0 {
				For i = 1:1:tErrors.Errors.Count() {
					Set tError = tErrors.Errors.GetAt(i)
					Do ..Errors.logError(tError.Code, tError.Severity, tError.DetailsText, tError.Location, tError.DetailsCode, tError.DetailsDescription, tError.Diagnostics, tError.Expression)
				}
				Set tSC = $$$OK
			}
			Quit
		}
		
		Set tSC = ##class(HS.FHIR.vSTU3.Repository.BundleValidator).ValidateBundle(tResourceObject, .tErrors)
		If $$$ISERR(tSC) {
			// Move the errors from ValidateResource into ..Errors and continue
			// with the other validations, in order to capture as many problems
			// as possible in one FHIR request.
			If tErrors.Errors.Count()>0 {
				For i = 1:1:tErrors.Errors.Count() {
					Set tError = tErrors.Errors.GetAt(i)
					Do ..Errors.logError(tError.Code, tError.Severity, tError.DetailsText, tError.Location, tError.DetailsCode, tError.DetailsDescription, tError.Diagnostics, tError.Expression)
				}
				Do tErrors.Errors.Clear()
				Set tSC = $$$OK
			} Else {
				Quit
			}
		}
		
		// We just got done with validation, this should not fail.
		Set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR(pMHDRequest.ContentType, tRequestStream, .pBundle, ..ResourceSchemaRoot)
		If $$$ISERR(tSC) Quit
		
		// Create an index of the Bundle entries, to allow for quick reference by id or type.
		Do ##class(HS.FHIR.Utils).IndexBundle(pBundle, .pBundleIndex)
		
		// Check for invalid/unsupported Bundle conditions.
		If +$Get(pBundleIndex("TypeCount", "DocumentManifest"))=0 {
			Set tCode = "invalid"
			Set tText = "Provide Document Bundle missing DocumentManifest resource"
			Do ..Errors.logError(tCode, "error", tText, , , , tText)
		}
		If +$Get(pBundleIndex("TypeCount", "DocumentReference"))=0 {
			Set tCode = "invalid"
			Set tText = "Provide Document Bundle missing DocumentReference resource"
			Do ..Errors.logError(tCode, "error", tText, , , , tText)
		}
		If +$Get(pBundleIndex("TypeCount", "DocumentManifest"))>1 {
			Set tCode = "invalid"
			Set tText = "Provide Document Bundle includes multiple DocumentManifest resources"
			Do ..Errors.logError(tCode, "error", tText, , , , tText)
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method ValidateMHDProvideResources(pMHDRequest As HS.Message.FHIR.Request, ByRef pBundle, ByRef pBundleIndex As %String, ByRef pPatientId As %String, ByRef pSourcePatientId As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSourceOID = ""
		
		Set tEntryIndex = $Order(pBundleIndex("TypeIndexByEntry","DocumentManifest",""))
		Set tDocumentManifest = pBundle.entry.GetAt(tEntryIndex).resource.DocumentManifest
		
		Set tSC = ..ValidateDocumentManifest(.pBundle, .pBundleIndex, tDocumentManifest, .pPatientId, .pSourcePatientId, .tSourceOID, tEntryIndex)
		If $$$ISERR(tSC) Quit
		// Quit only on a hard exception, otherwise continue in order to gather
		// and return as many validation failures as possible.
		
		// FHIR Bundle resource specification, details about Transaction/Batch:
		// "If there is no request element, then there SHALL be a resource and the server must
		// infer whether this is a create or an update from the resource identity supplied."
		If '$IsObject(pBundle.entry.GetAt(tEntryIndex).request) {
			Set pBundle.entry.GetAt(tEntryIndex).request = $ClassMethod(..ResourceSchemaRoot_".Bundle.Request", "%New")
		}
		// For MHD, assume that the interaction is always create (POST).
		If pBundle.entry.GetAt(tEntryIndex).request.method.value="" {
			Do pBundle.entry.GetAt(tEntryIndex).request.SetMethod("POST")
		}
		If pBundle.entry.GetAt(tEntryIndex).request.url.value="" {
			Do pBundle.entry.GetAt(tEntryIndex).request.SetUrl(pBundle.entry.GetAt(tEntryIndex).fullUrl.value)
		}
		
		Set tEntryIndex = ""
		For {
			Set tEntryIndex = $Order(pBundleIndex("TypeIndexByEntry", "DocumentReference", tEntryIndex))
			If tEntryIndex="" Quit
			
			Set tDocumentReference = pBundle.entry.GetAt(tEntryIndex).resource.DocumentReference
			
			Set tSC = ..ValidateDocumentReference(.pBundle, .pBundleIndex, tDocumentReference, .pPatientId, .pSourcePatientId, .tSourceOID, tEntryIndex)
			If $$$ISERR(tSC) Quit
			// Quit only on a hard exception, otherwise continue in order to gather
			// and return as many validation failures as possible.
			
			// FHIR Bundle resource specification, details about Transaction/Batch:
			// "If there is no request element, then there SHALL be a resource and the server must
			// infer whether this is a create or an update from the resource identity supplied."
			If '$IsObject(pBundle.entry.GetAt(tEntryIndex).request) {
				Set pBundle.entry.GetAt(tEntryIndex).request = $ClassMethod(..ResourceSchemaRoot_".Bundle.Request", "%New")
			}
			// For MHD, assume that the interaction is always create (POST).
			If pBundle.entry.GetAt(tEntryIndex).request.method.value="" {
				Do pBundle.entry.GetAt(tEntryIndex).request.SetMethod("POST")
			}
			If pBundle.entry.GetAt(tEntryIndex).request.url.value="" {
				Do pBundle.entry.GetAt(tEntryIndex).request.SetUrl(pBundle.entry.GetAt(tEntryIndex).fullUrl.value)
			}
		}
		If $$$ISERR(tSC) Quit
		// Quit only on a hard exception, otherwise continue in order to gather
		// and return as many validation failures as possible.
		
		// MHD Revision 2.3 says that the Document Recipient may opt to not process a
		// List resource entry but must process the rest of the Bundle, and return a
		// warning regarding the non-processing of the List resource. 
		Set tEntryIndex = ""
		For {
			Set tEntryIndex = $Order(pBundleIndex("TypeIndexByEntry", "List", tEntryIndex))
			If tEntryIndex="" Quit
			
			Set tList = pBundle.entry.GetAt(tEntryIndex).resource.List
			
			Set tSC = ..ValidateList(.pBundle, .pBundleIndex, tList, .pPatientId, .pSourcePatientId, .tSourceOID, tEntryIndex)
			If $$$ISERR(tSC) Quit
		}
		
		If pSourcePatientId="" Set pSourcePatientId = pPatientId
		
		If pPatientId="" {
			Set tText = "Provide Document Bundle missing PatientId"
			Do ..Errors.logError("required", "error", tText, , , , tText)
			Quit
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method ValidateDocumentManifest(ByRef pBundle, ByRef pBundleIndex As %String, pDocumentManifest As HS.FHIR.vSTU3.Model.Resource.DocumentManifest, ByRef pPatientId As %String, ByRef pSourcePatientId As %String, ByRef pSourceOID As %String, pEntryIndex As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		// MHD Revision 2.4 Table 4.5.1.2-1 (FHIR DocumentManifest mapping to SubmissionSet), CP-ITI-1079.
		If pDocumentManifest.masterIdentifier.value="" {
			Set tText = "Provide Document Bundle DocumentManifest masterIdentifier missing"
			Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		
		// MHD maps masterIdentifier to XDSb Submission Set UniqueId.
		// Per http://hl7.org/fhir/datatypes.html#identifier, "If the identifier value itself
		// is naturally a globally unique URI (e.g. an OID, a UUID, or a URI with no trailing
		// local part), then the system SHALL be "urn:ietf:rfc:3986", and the URI is in the
		// value (OIDs and UUIDs using urn:oid: and urn:uuid: - see examples)."
		If ($IsObject(pDocumentManifest.masterIdentifier))&&(pDocumentManifest.masterIdentifier.value.value'="")&&(pDocumentManifest.masterIdentifier.system.value'="urn:ietf:rfc:3986") {
			Set tText = "Provide Document Bundle DocumentManifest masterIdentifier missing required system value urn:ietf:rfc:3986"
			Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		
		// MHD maps identifier to EntryUUID.  If there is an identifier whose value
		// starts with "urn:uuid:" then assume it is for EntryUUID.  It must include
		// the system value for urn:ietf:rfc:3986.
		Set tEntryUUID = ""
		For i = 1:1:pDocumentManifest.identifier.Count() {
			Set tVal = pDocumentManifest.identifier.GetAt(i).value.value
			If $Extract(tVal,1,9)="urn:uuid:" {
				If pDocumentManifest.identifier.GetAt(i).system.value="urn:ietf:rfc:3986" {
					Set tEntryUUID = tVal
				} Else {
					Set tText = "Provide Document Bundle Document Manifest identifier for entryUUID missing required system value urn:ietf:rfc:3986"
					Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
					Quit					
				}
			}
		}
		
		// MHD Revision 2.3 Table 4.5.1.2-1 (FHIR DocumentManifest mapping to SubmissionSet)
		// states that subject is "Not a contained resource. URL Points to an existing Patient
		// resource representing Affinity Domain Patient". Therefore, when present, it must be
		// a fully qualified URL pointing to a FHIR Patient resource. Just check for value and
		// format here, patient data will be retrieved later.
		// With MHD Revision 2.3, DocumentManifest subject is now optional ([0..1]). We take
		// this to mean that either DocumentManifest or DocumentReference must have subject,
		// but it is not required that both have it. Therefore we will use the first found of
		// DocumentManifest subject or DocumentReference subject as the basis of PatientId.
		Set tIsValid = 0
		Set tVal = ""
		If ($IsObject(pDocumentManifest.subject))&&($IsObject(pDocumentManifest.subject.reference)) {
			Set tVal = pDocumentManifest.subject.reference.value
			If $Extract(tVal, *)="/" Set tVal = $Extract(tVal, 1, *-1)
			Set tL = $Length(tVal, "/")
			If (($Extract(tVal,1,7)="http://")||(($Extract(tVal,1,8)="https://"))) {
				If (($Piece(tVal,"/",tL-1)="Patient")&&($Piece(tVal,"/",tL)'=""))||(($Piece(tVal,"/",tL-3)="Patient")&&($Piece(tVal,"/",tL-1)="_history")) {
					Set tIsValid = 1
				}
			}
		} Else {
			// subject is optional for DocumentManifest, so is valid if the property object is absent.
			Set tIsValid = 1
		}
		If tIsValid=0 {
			Set tText = "Provide Document Bundle DocumentManifest subject Patient resource reference is invalid"
			Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		
		// The presence of status should have already been confirmed by ValidateResource.
		If pDocumentManifest.status.value="" {
			Set tText = "Provide Document Bundle DocumentManifest status missing"
			Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		
		// The presence of content should have already been confirmed by ValidateResource.
		If pDocumentManifest.content.Count()=0 {
			Set tText = "Provide Document Bundle DocumentManifest content missing"
			Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		
		// MHD Revision 2.4 Table 4.5.1.2-1 (FHIR DocumentManifest mapping to SubmissionSet), CP-ITI-1079.
		If pDocumentManifest.created.value="" {
			Set tText = "Provide Document Bundle DocumentManifest created missing"
			Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		
		// MHD Revision 2.4 Table 4.5.1.2-1 (FHIR DocumentManifest mapping to SubmissionSet), CP-ITI-1079.
		If pDocumentManifest.source.value="" {
			Set tText = "Provide Document Bundle DocumentManifest source missing"
			Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		
		// MHD Revision 2.3 Table 4.5.1.2-1 (FHIR DocumentManifest mapping to SubmissionSet)
		// states that content objects must have a reference, and not an attachment.
		For i = 1:1:pDocumentManifest.content.Count() {
			Set tContent = pDocumentManifest.content.GetAt(i)
			If $IsObject(tContent.pAttachment)&&((tContent.pAttachment.data.value'="")||(tContent.pAttachment.url.value'="")) {
				Set tText = "Provide Document Bundle DocumentManifest content pAttachment is not allowed"
				Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
			}
			If '$IsObject(tContent.pReference) {
				Set tText = "Provide Document Bundle DocumentManifest content missing DocumentReference reference"
				Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
			}
			If tContent.pReference.reference.value="" {
				Set tText = "Provide Document Bundle DocumentManifest content missing DocumentReference reference"
				Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
			}
		}
		
		// MHD Revision 2.3 Table 4.5.1.2-1 (FHIR DocumentManifest mapping to SubmissionSet)
		// states that related is not allowed.
		If (pDocumentManifest.related)&&(pDocumentManifest.related.Count()>0) {
			Set tText = "Provide Document Bundle DocumentManifest related property is not allowed"
			Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
			Quit
		}
		
		// MHD Revision 2.3 Table 4.5.1.2-1 (FHIR DocumentManifest mapping to SubmissionSet)
		// states that DocumentManifest author shall be a contained Practitioner resource.
		// author XDS DS metadata optionality is R2 which essentially means optional.
		For i = 1:1:pDocumentManifest.author.Count() {
			Set tReference = pDocumentManifest.author.GetAt(i)
			Set tResource = ""
			If tReference.reference.value="" {
				Set tText = "DocumentManifest author missing reference value"
				Do ..Errors.logError("value", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
				Quit
			} Else {
				If $Extract(tReference.reference.value)="#" {
					Set tSC = ##class(HS.FHIR.Utils).GetContainedResource(pDocumentManifest, tReference.reference.value, "", .tResource)
					If $$$ISERR(tSC) {
						Set tText = "Invalid DocumentManifest author reference value - contained resource not found"
						Do ..Errors.logError("value", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
						Set tSC = $$$OK
						Quit
					} ElseIf (tResource.%ClassName(0)'="Practitioner")&&(tResource.%ClassName(0)'="Organization") {
						Set tText = "Invalid DocumentManifest author reference value - contained resource must be Practitioner or Organization"
						Do ..Errors.logError("value", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
						Quit
					}
				} Else {
					Set tText = "Invalid DocumentManifest author reference value - must be a contained resource"
					Do ..Errors.logError("value", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
					Quit
				}
			}
			If $$$ISERR(tSC) Quit
		}
		
		// This method assumes one patient per Provide Document Bundle.
		If ($IsObject(pDocumentManifest.subject))&&($IsObject(pDocumentManifest.subject.reference)) {
			Set tSC = ..GetPatientIdFromReference(pBundle, pDocumentManifest, .pBundleIndex, .pPatientId)
			If ($$$ISERR(tSC))||(..Errors.Errors.Count()) Quit
		}
		
		// Convert the source URI to an OID in order to use it with XDSb.
		// pSourceOID is generated here and returned so that the value can
		// be used in the DocumentReference call to GetPatIdentifierFromResource.
		Set pSourceOID = ""
		Set tSourceSystem = pDocumentManifest.source.value
		If $Extract(tSourceSystem,1,8)="urn:oid:" {
			Set pSourceOID = $Extract(tSourceSystem,9,*)
		} ElseIf ##class(HS.HC.Util).IsOID(tSourceSystem) {
			Set pSourceOID = tSourceSystem
		} ElseIf $Extract(tSourceSystem,1,4)="http" {
			Set pSourceOID = ##class(HS.Data.OIDMap).GetOIDForURL(tSourceSystem)
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method ValidateDocumentReference(ByRef pBundle As HS.FHIR.vSTU3.Model.Resource.Bundle, ByRef pBundleIndex As %String, pDocumentReference As HS.FHIR.vSTU3.Model.Resource.DocumentReference, ByRef pPatientId As %String, ByRef pSourcePatientId As %String, pSourceOID As %String, pEntryIndex As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		// MHD Revision 2.4 Table 4.5.1.1-1 (FHIR DocumentReference mapping to DocumentEntry), CP-ITI-1079.
		If (pDocumentReference.masterIdentifier.value="") {
			Set tText = "Provide Document Bundle DocumentReference masterIdentifier missing"
			Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		
		If ('$IsObject(pDocumentReference.type.coding))||(pDocumentReference.type.coding.Count()=0)||(pDocumentReference.type.coding.GetAt(1).code.value="") {
			Set tText = "Provide Document Bundle DocumentReference type missing"
			Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		If (pDocumentReference.indexed.value="") {
			Set tText = "Provide Document Bundle DocumentReference indexed missing"
			Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		If (pDocumentReference.status.value="") {
			Set tText = "Provide Document Bundle DocumentReference status missing"
			Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		If (pDocumentReference.content.Count()=0) {
			Set tText = "Provide Document Bundle DocumentReference content missing"
			Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		
		// Items not allowed for MHD.
		If ($IsObject(pDocumentReference.custodian.reference))&&(pDocumentReference.custodian.reference.value'="") {
			Set tText = "DocumentReference custodian in Provide Document Bundle is not allowed"
			Do ..Errors.logError("invalid", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		If pDocumentReference.created.value'="" {
			Set tText = "DocumentReference created in Provide Document Bundle is not allowed"
			Do ..Errors.logError("invalid", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		If ($IsObject(pDocumentReference.docStatus.coding))&&(pDocumentReference.docStatus.coding.Count()>0)&&(pDocumentReference.docStatus.coding.GetAt(1).code.value'="") {
			Set tText = "DocumentReference docStatus in Provide Document Bundle is not allowed"
			Do ..Errors.logError("invalid", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		
		// MHD Revision 2.3 Table 4.5.1.1-1 (FHIR DocumentReference mapping to DocumentEntry)
		// states that subject is "Not a contained resource. URL Points to an existing Patient
		// resource representing Affinity Domain Patient". Therefore, when present, it must be
		// a fully qualified URL pointing to a FHIR Patient resource. Just check for value and
		// format here, patient data will be retrieved later.
		// With MHD Revision 2.3, DocumentReference subject is now optional ([0..1]). We take
		// this to mean that either DocumentManifest or DocumentReference must have subject,
		// but it is not required that both have it. Therefore we will use the first found of
		// DocumentManifest subject or DocumentReference subject as the basis of PatientId.
		Set tIsValid = 0
		Set tVal = ""
		If ($IsObject(pDocumentReference.subject))&&($IsObject(pDocumentReference.subject.reference)) {
			Set tVal = pDocumentReference.subject.reference.value
			If $Extract(tVal, *)="/" Set tVal = $Extract(tVal, 1, *-1)
			Set tL = $Length(tVal, "/")
			If (($Extract(tVal,1,7)="http://")||(($Extract(tVal,1,8)="https://"))) {
				If (($Piece(tVal,"/",tL-1)="Patient")&&($Piece(tVal,"/",tL)'=""))||(($Piece(tVal,"/",tL-3)="Patient")&&($Piece(tVal,"/",tL-1)="_history")) {
					Set tIsValid = 1
				}
			}
		} Else {
			// subject is optional for DocumentReference, so is valid if the property object is absent.
			Set tIsValid = 1
		}
		If tIsValid=0 {
			Set tText = "Provide Document Bundle DocumentReference subject Patient resource reference is invalid"
			Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		
		// MHD maps DocumentReference masterIdentifier to XDSb Document Entry UniqueId.
		// Per IHE Appendix on HL7 FHIR for HL7 FHIR STU3, Rev 1.2, Section Z.9.1.1,
		// Document Entry UniqueId can be an OID or OID^extension. If UniqueId is
		// just OID, then the OID goes into masterIdentfier.value and "urn:ietf:rfc:3986"
		// goes into masterIdentifier.system. Otherwise if UniqueId is OID^extension,
		// then the OID goes into masterIdentifier.system and the extension goes into
		// masterIdentifier.value.
		If $IsObject(pDocumentReference.masterIdentifier) {
			If pDocumentReference.masterIdentifier.system.value="" {
				// system must always be present.
				Set tText = "Provide Document Bundle DocumentReference masterIdentifier missing system value"
				Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
			} ElseIf pDocumentReference.masterIdentifier.system.value="" {
				// value must always be present.
				Set tText = "Provide Document Bundle DocumentReference masterIdentifier missing value value"
				Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
			} ElseIf ((##class(HS.HC.Util).IsOID(pDocumentReference.masterIdentifier.value.value))||(##class(HS.HC.Util).IsUUID(pDocumentReference.masterIdentifier.value.value))) {
				// If the value is a URI then system must be urn:ietf:rfc:3986.
				If pDocumentReference.masterIdentifier.system.value'="urn:ietf:rfc:3986" {
					Set tText = "Provide Document Bundle DocumentReference masterIdentifier missing required system value urn:ietf:rfc:3986"
					Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
				}
			} Else {
				// If the value is not a URI the system must be a URI.
				If '((##class(HS.HC.Util).IsOID(pDocumentReference.masterIdentifier.system.value))||(##class(HS.HC.Util).IsUUID(pDocumentReference.masterIdentifier.system.value))) {
					Set tText = "Provide Document Bundle DocumentReference masterIdentifier system value must be a URI if value is not a URI"
					Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
				}
			}
		}
		
		// If PatientId was already derived from DocumentManifest or
		// from a document earlier in the document list, go ahead and
		// use it, since we're assuming only one patient per submission.
		// Otherwise, get it by following the DocumentReference subject
		// reference property.
		// MHD Revision 2.3 Table 4.5.1.1-1 (FHIR DocumentReference mapping to DocumentEntry)
		// states that subject is "Not a contained resource. URL Points to an existing Patient
		// resource representing Affinity Domain Patient". Therefore, when present, it must be
		// a fully qualified URL pointing to a FHIR Patient resource. Just check for value and
		// format here, patient data will be retrieved later.
		// With MHD Revision 2.3, DocumentReference subject is now optional ([0..1]). We take
		// this to mean that either DocumentManifest or DocumentReference must have subject,
		// but it is not required that both have it. Therefore we will use the first found of
		// DocumentManifest subject or DocumentReference subject as the basis of PatientId.
		If pPatientId = "" {
			If ($IsObject(pDocumentReference.subject))&&($IsObject(pDocumentReference.subject.reference)) {
				Set tSC = ..GetPatientIdFromReference(pBundle, pDocumentReference, .pBundleIndex, .pPatientId)
				If ($$$ISERR(tSC))||(..Errors.Errors.Count()) Quit
			}
		}
		
		// MHD Revision 2.3 Table 4.5.1.1-1 (FHIR DocumentReference mapping to DocumentEntry)
		// states that DocumentReference author shall be a contained Practitioner resource.
		// author XDS DS metadata optionality is R2 which essentially means optional.
		For i = 1:1:pDocumentReference.author.Count() {
			Set tReference = pDocumentReference.author.GetAt(i)
			Set tResource = ""
			If tReference.reference.value="" {
				Set tText = "DocumentReference author missing reference value"
				Do ..Errors.logError("value", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
				Quit
			} Else {
				If $Extract(tReference.reference.value)="#" {
					Set tSC = ##class(HS.FHIR.Utils).GetContainedResource(pDocumentReference, tReference.reference.value, "", .tResource)
					If $$$ISERR(tSC) {
						Set tText = "Invalid DocumentReference author reference value - contained resource not found"
						Do ..Errors.logError("value", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
						Set tSC = $$$OK
						Quit
					} ElseIf (tResource.%ClassName(0)'="Practitioner")&&(tResource.%ClassName(0)'="Organization") {
						Set tText = "Invalid DocumentReference author reference value - contained resource must be Practitioner or Organization"
						Do ..Errors.logError("value", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
						Quit
					}
				} Else {
					Set tText = "Invalid DocumentReference author reference value - must be a contained resource"
					Do ..Errors.logError("value", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
					Quit
				}
			}
			If $$$ISERR(tSC) Quit
		}
		
		// If SourcePatientId was already derived from a document earlier
		// in the document list, go ahead and use it, since we're assuming
		// only one patient per submission.  Otherwise, get it by following
		// the DocumentReference context/sourcePatientInfo reference property.
		// MHD STU3 section 3.65.4.1.2.2 says:
		// "When sourcePatientInfo is provided, the DocumentReference.context.sourcePatientInfo
		// shall be a reference to a contained Patient Resource."
		// Therefore fail the request if it is not a reference to a contained resource.
		If pSourcePatientId="" {
			If ($IsObject(pDocumentReference.context))&&($IsObject(pDocumentReference.context.sourcePatientInfo)) {
				Set tReference = pDocumentReference.context.sourcePatientInfo
				If (tReference.reference.value="")&&(tReference.display.value'="") {
					If tReference.display.value?1E.E1"^^^"1E.E1"&ISO" Set pSourcePatientId = tReference.display.value
				} ElseIf tReference.reference.value?1"#"1E.E {
					Set tSC = ##class(HS.FHIR.Utils).GetContainedResource(pDocumentReference, tReference.reference.value, "Patient", .tPatientResource)
					If $$$ISOK(tSC) {
						Set pSourcePatientId = ..GetPatIdentifierFromResource(tPatientResource, pSourceOID)
					} Else {
						Set tText = "Invalid DocumentReference sourcePatientInfo reference value"
						Do ..Errors.logError("value", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
					}
				} Else {
					Set tText = "Invalid DocumentReference sourcePatientInfo reference value - is not a reference to a contained resource"
					Do ..Errors.logError("value", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
				}
			}
		}

		If $IsObject(pDocumentReference.content.GetAt(1).attachment) {
			Set tAttachment = pDocumentReference.content.GetAt(1).attachment
			If (tAttachment.url.value'="")&&(tAttachment.data.value="") {
				Set tEntryIndex = $Get(pBundleIndex("EntryIndexByFullUrl", tAttachment.url.value))
				If tEntryIndex="" {
					Set tText = "Provide Document Bundle DocumentReference Binary resource reference does not point a resource in the Bundle"
					Do ..Errors.logError("value", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
				}
			}
			// MHD Revision 2.4 Table 4.5.1.1-1 (FHIR DocumentReference mapping to DocumentEntry), CP-ITI-1079.
			If tAttachment.contentType.value="" {
				Set tText = "Provide Document Bundle DocumentReference attachment.contentType is missing"
				Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
			}
			// MHD Revision 2.4 Table 4.5.1.1-1 (FHIR DocumentReference mapping to DocumentEntry), CP-ITI-1079.
			If tAttachment.creation.value'="" {
				Set tText = "Provide Document Bundle DocumentReference attachment.creation is not allowed"
				Do ..Errors.logError("value", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
			}
		}
		
		If ($IsObject(pDocumentReference.relatesTo))&&(pDocumentReference.relatesTo.Count()>0) {
			For i = 1:1:pDocumentReference.relatesTo.Count() {
				If pDocumentReference.relatesTo.GetAt(i).code.value="replaces" {
					Set tText = "PartialReplaceContentNotProcessed"
					Do ..Errors.logError("not-supported", "warning", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
				} ElseIf pDocumentReference.relatesTo.GetAt(i).code.value="transforms" {
					Set tText = "PartialTransformContentNotProcessed"
					Do ..Errors.logError("not-supported", "warning", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
				} ElseIf pDocumentReference.relatesTo.GetAt(i).code.value="appends" {
					Set tText = "PartialAppendContentNotProcessed"
					Do ..Errors.logError("not-supported", "warning", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
				}
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method ValidateList(ByRef pBundle As HS.FHIR.vSTU3.Model.Resource.Bundle, ByRef pBundleIndex As %String, pList As HS.FHIR.vSTU3.Model.Resource.List, ByRef pPatientId As %String, ByRef pSourcePatientId As %String, pSourceOID As %String, pEntryIndex As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		// List resource - mapped to XDSb Folders.
		
		// MHD Revision 2.4 Table 4.5.1.3-1 (FHIR List mapping to Folder metadata), CP-ITI-1079.
		If pList.identifier.Count()'=2 {
			Set tText = "Provide Document Bundle List must have two identifiers"
			Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		
		// MHD Revision 2.3 Table 4.5.1.3-1 (FHIR List mapping to Folder metadata)
		// states that subject is optional (cardinaity [0..1]) and "Not a contained resource.
		// URL Points to an existing Patient resource representing Affinity Domain Patient".
		// Therefore, if present on the List resource, it must be a fully qualified URL pointing
		// to a FHIR Patient resource. Just check for value and format here, patient data will
		// be retrieved later.
		Set tIsValid = 0
		Set tVal = ""
		If ($IsObject(pList.subject))&&($IsObject(pList.subject.reference)) {
			Set tVal = pList.subject.reference.value
			If $Extract(tVal, *)="/" Set tVal = $Extract(tVal, 1, *-1)
			Set tL = $Length(tVal, "/")
			If (($Extract(tVal,1,7)="http://")||(($Extract(tVal,1,8)="https://"))) {
				If (($Piece(tVal,"/",tL-1)="Patient")&&($Piece(tVal,"/",tL)'=""))||(($Piece(tVal,"/",tL-3)="Patient")&&($Piece(tVal,"/",tL-1)="_history")) {
					Set tIsValid = 1
				}
			}
		} Else {
			// subject is optional for List, so is valid if the property object is absent.
			Set tIsValid = 1
		}
		If tIsValid=0 {
			If tVal="" {
				Set tText = "Provide Document Bundle List subject missing"
				Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
			} Else {
				Set tText = "Provide Document Bundle List subject Patient resource reference is invalid"
				Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
			}
		}
		
		If ($IsObject(pList.source))&&((pList.source.display.value'="")||(pList.source.reference.value'="")) {
			Set tText = "Provide Document Bundle List source is not allowed"
			Do ..Errors.logError("invalid", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		If ($IsObject(pList.encounter))&&((pList.encounter.display.value'="")||(pList.encounter.reference.value'="")) {
			Set tText = "Provide Document Bundle List encounter is not allowed"
			Do ..Errors.logError("invalid", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		If ($IsObject(pList.orderedBy))&&((pList.orderedBy.text.value'="")||(pList.orderedBy.coding.Count()>0)) {
			Set tText = "Provide Document Bundle List orderedBy is not allowed"
			Do ..Errors.logError("invalid", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
	
		// The presence of status should have already been confirmed by ValidateResource.
		If pList.status.value="" {
			Set tText = "Provide Document Bundle List status missing"
			Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		
		// MHD Revision 2.3 Table 4.5.1.3-1 (FHIR List mapping to Folder metadata) states
		// that mode must be present and must be "working".
		If pList.mode.value'="working" {
			Set tText = "Provide Document Bundle List mode value must be 'working'"
			Do ..Errors.logError("required", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		
		If ($IsObject(pList.emptyReason))&&((pList.emptyReason.value'="")) {
			Set tText = "Provide Document Bundle List emptyReason is not allowed"
			Do ..Errors.logError("invalid", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		
		#dim tEntry As HS.FHIR.vSTU3.Model.Resource.List.Entry
		
		Set tHasItem = 0
		Set tInvalidItem = 0
		For i = 1:1:pList.entry.Count() {
			Set tEntry = pList.entry.GetAt(i)
			If ($IsObject(tEntry.flag))&&(($IsObject(tEntry.flag.coding))||(tEntry.flag.text.value'="")) {
				Set tText = "Provide Document Bundle List flag is not allowed"
				Do ..Errors.logError("invalid", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
			}
			If ($IsObject(tEntry.deleted))&&((tEntry.deleted.value'="")) {
				Set tText = "Provide Document Bundle List deleted is not allowed"
				Do ..Errors.logError("invalid", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
			}
			If ($IsObject(tEntry.date))&&((tEntry.date.value'="")) {
				Set tText = "Provide Document Bundle List date is not allowed"
				Do ..Errors.logError("invalid", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
			}
			If $IsObject(tEntry.item) {
				If $IsObject(tEntry.item.identifier) {
					If (tEntry.item.identifier.use.value="official")&&(tEntry.item.identifier.value.value'="") {
						Set tHasItem = 1
					} Else {
						Set tInvalidItem = 1
						Set tText = "Provide Document Bundle List item identifier must have use='official' and value must have a value"
					}
				}
				If $IsObject(tEntry.item.reference) {
					Set tRefVal = tEntry.item.reference.value
					If tRefVal'="" {
						If (($Length(tRefVal,"/")=2)&&($Piece(tRefVal,"/",1)="DocumentReference")||(##class(HS.HC.Util).IsUUID(tRefVal))) {
							Set tHasItem = 1
						} Else {
							Set tInvalidItem = 1
							Set tText = "Provide Document Bundle List item reference must have DocumentReference reference"
						}
					}
				}
				If ('tHasItem)&&(tEntry.item.display'="") Set tHasItem = 1
			}
		}
		If tInvalidItem {
			Do ..Errors.logError("invalid", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		} ElseIf 'tHasItem {
			Set tText = "Provide Document Bundle List item missing"
			Do ..Errors.logError("invalid", "error", tText, "/f:Bundle/f:entry["_pEntryIndex_"]", , , tText)
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method RequestToProvideAndRegister(pMHDRequest As HS.Message.FHIR.Request, pBundle As HS.FHIR.vSTU3.Model.Resource.Bundle, ByRef pBundleIndex As %String, pPatientId As %String, pSourcePatientId As %String, ByRef pUpdatedTarget As HS.Message.IHE.XDSb.ProvideAndRegisterRequest) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#dim tDocumentManifest As HS.FHIR.vSTU3.Model.Resource.DocumentManifest
		#dim tDocumentReference As HS.FHIR.vSTU3.Model.Resource.DocumentReference
		
		// Put together a ProviderAndRegisterRequest
		Set tTarget = ##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
		
		If pMHDRequest.AdditionalInfo.GetAt("USER:UserID")'="" {
			Set tTarget.RequestingUser = pMHDRequest.AdditionalInfo.GetAt("USER:UserID")
			Set tTarget.SAMLData.UserName = pMHDRequest.AdditionalInfo.GetAt("USER:UserID")
		}
		If pMHDRequest.AdditionalInfo.GetAt("USER:Roles")'="" {
			Set tTarget.RequestingUserRoles = pMHDRequest.AdditionalInfo.GetAt("USER:Roles")
			Set tTarget.SAMLData.HSRoles = pMHDRequest.AdditionalInfo.GetAt("USER:Roles")
		}
		
		// Examine the DocumentManifest resource to get the Source OID and ContentTypeCode.
		Set tEntryIndex = $Order(pBundleIndex("TypeIndexByEntry","DocumentManifest",""))
		Set tDocumentManifest = pBundle.entry.GetAt(tEntryIndex).resource.DocumentManifest
		
		// Convert the source URI to an OID in order to use it with XDSb.
		Set tSourceSystemOID = ""
		Set tSourceSystem = tDocumentManifest.source.value
		If $Extract(tSourceSystem,1,8)="urn:oid:" {
			Set tSourceSystemOID = $Extract(tSourceSystem,9,*)
		} ElseIf ##class(HS.HC.Util).IsOID(tSourceSystem) {
			Set tSourceSystemOID = tSourceSystem
		} ElseIf $Extract(tSourceSystem,1,4)="http" {
			Set tSourceSystemOID = ##class(HS.Data.OIDMap).GetOIDForURL(tSourceSystem)
		}
		
		// Convert the masterIdentifier URI, if any, to an OID in order to use it with XDSb.
		Set tSubmissionUniqueId = ""
		If ($IsObject(tDocumentManifest.masterIdentifier))&&(tDocumentManifest.masterIdentifier.value.value'="") {
			Set tSubmissionUniqueId = tDocumentManifest.masterIdentifier.value.value
			If $Extract(tSubmissionUniqueId,1,8)="urn:oid:" {
				Set tSubmissionUniqueId = $Extract(tSubmissionUniqueId,9,*)
			} ElseIf $Extract(tSubmissionUniqueId,1,9)="urn:uuid:" {
				Set tSubmissionUniqueId = "2.25."_$system.Util.HexToDecimal($Translate($Extract(tSubmissionUniqueId,10,*),"-"))
			} ElseIf ##class(HS.HC.Util).IsUUID(tSubmissionUniqueId) {
				Set tSubmissionUniqueId = "2.25."_$system.Util.HexToDecimal($Translate(tSubmissionUniqueId,"-"))
			}
		} Else {
			Set tSubmissionUniqueId = "2.25."_$system.Util.CreateDecimalGUID()
		}
		
		Set tTarget.UniqueId = tSubmissionUniqueId
		
		// MHD maps identifier to EntryUUID.  If there is an identifier whose value
		// starts with "urn:uuid:" then assume it is for EntryUUID.  It must include
		// the system value for urn:ietf:rfc:3986.
		Set tEntryUUID = ""
		For i = 1:1:tDocumentManifest.identifier.Count() {
			Set tVal = tDocumentManifest.identifier.GetAt(i).value.value
			If $Extract(tVal,1,9)="urn:uuid:" {
				If tDocumentManifest.identifier.GetAt(i).system.value="urn:ietf:rfc:3986" {
					Set tEntryUUID = tVal
				}
			}
		}
		If tEntryUUID="" Set tEntryUUID = "urn:uuid:"_$ZConvert($system.Util.CreateGUID(),"L")
		
		Set tTarget.EntryUUID = tEntryUUID
		
		If $IsObject(tDocumentManifest.type) {
			Set tCodeableConcept = tDocumentManifest.type
			If tCodeableConcept.coding.Count()>0 {
				Set tCode = tCodeableConcept.coding.GetAt(1).code.value
				Set tDescription = tCodeableConcept.coding.GetAt(1).display.value
				Set tSystem = tCodeableConcept.coding.GetAt(1).system.value
				Set tScheme = ..GetCodingScheme("contentTypeCode", tCode, tSystem, tSystem)
				If $Extract(tScheme,1,8)="urn:oid:" Set tScheme = $Extract(tScheme,9,*)
				Set tCodedValue = ##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode, tScheme, tDescription)
				Set tTarget.ContentTypeCode = tCodedValue
			}
		}
		
		Set tTarget.Title = tDocumentManifest.description.value
		
		// FHIR DocumentReference resources map to XDSb Documents.
		Set tEntryIndex = ""
		For {
			Set tEntryIndex = $Order(pBundleIndex("TypeIndexByEntry", "DocumentReference", tEntryIndex))
			If tEntryIndex="" Quit
			
			Set tDocumentReference = pBundle.entry.GetAt(tEntryIndex).resource.DocumentReference
			
			Set tSC = ..DocReferenceToXDSbDocument(pBundle, .pBundleIndex, tDocumentReference, pPatientId, pSourcePatientId, .tDocument)
			If $$$ISERR(tSC) Quit
			If (..Errors.Errors.Count())&&(..Errors.HighestError="error") Quit
			
			Do tTarget.Documents.Insert(tDocument)
		}
		If $$$ISERR(tSC) Quit
		If (..Errors.Errors.Count())&&(..Errors.HighestError="error") Quit
		
		// FHIR List resources map to XDSb Folders.
		Set tEntryIndex = ""
		For {
			Set tEntryIndex = $Order(pBundleIndex("TypeIndexByEntry", "List", tEntryIndex))
			If tEntryIndex="" Quit
			
			Set tList = pBundle.entry.GetAt(tEntryIndex).resource.List
			
			Set tSC = ..ListToXDSbFolder(pBundle, tList, pPatientId, .tFolder, .tAssociations)
			If $$$ISERR(tSC) Quit
			If (..Errors.Errors.Count())&&(..Errors.HighestError="error") Quit
			
			Do tTarget.Folders.Insert(tFolder)
			
			If $IsObject($Get(tAssociations)) {
				For i = 1:1:tAssociations.Count() {
					Do tTarget.Associations.Insert(tAssociations.GetAt(i))
				}
			}
		}
		If $$$ISERR(tSC) Quit
		If (..Errors.Errors.Count())&&(..Errors.HighestError="error") Quit
		
		// If the Bundle does not include the source property,
		// derive the source system OID from the Patient Id.
		If tSourceSystemOID="" Set tSourceSystemOID = $Piece($Piece(pPatientId,"^",4),"&",2)
		
		Set tTarget.PatientId = pPatientId
		Set tTarget.SourceId = tSourceSystemOID
		
		Set tSC = ..GetAuthorNameFromReference(pBundle, .pBundleIndex, tDocumentManifest, .tAuthorName)
		If $$$ISERR(tSC) Quit
		If (..Errors.Errors.Count())&&(..Errors.HighestError="error") Quit
		Set tAuthor = ##class(HS.IHE.XDSb.Types.Author).%New()
		If tAuthorName'="" {
			Set tAuthor.AuthorPerson = tAuthorName
		} Else {
			Set tAuthor.AuthorPerson = "^Smitty^Gerald^^^"
		}
		Do tTarget.Author.Insert(tAuthor)
		
		Set tSC = ..GetAuthorSpecialtySlotFromRef(pBundle, .pBundleIndex, tDocumentManifest, .tSpecialtySlot)
		If $$$ISERR(tSC) Quit
		If (..Errors.Errors.Count())&&(..Errors.HighestError="error") Quit
		If $IsObject($Get(tSpecialtySlot)) Do tTarget.SubmissionSlots.Insert(tSpecialtySlot)
		
		Set tSC = ..GetAuthorInstitutionSlotFromRef(pBundle, .pBundleIndex, tDocumentManifest, .tInstitutionSlot)
		If $$$ISERR(tSC) Quit
		If (..Errors.Errors.Count())&&(..Errors.HighestError="error") Quit
		If $IsObject($Get(tInstitutionSlot)) Do tTarget.SubmissionSlots.Insert(tInstitutionSlot)
		
		Set tSC = ..GetAuthorTelecomSlotFromRef(pBundle, .pBundleIndex, tDocumentManifest, .tTelecomSlot)
		If $$$ISERR(tSC) Quit
		If (..Errors.Errors.Count())&&(..Errors.HighestError="error") Quit
		If $IsObject($Get(tTelecomSlot)) Do tTarget.SubmissionSlots.Insert(tTelecomSlot)
		
		$$$HSTRACE("ProvideAndRegisterRequest from FHIR Bundle before update", "tTarget", tTarget)
		
		// Calling GetUpdatedProvideRequest here seems redundant to its subsequent
		// use in DocumentSourceOperations.  However, for the STU3 version of MHD
		// we need to get any missing required XDSb metadata from the document
		// itself and/or provide a way to specify default values, as MHD takes
		// nearly all of its cues for cardinality from the core FHIR spec, which
		// does not match that of XDSb.
		Set tSC = ..GetUpdatedProvideRequest(tTarget, .pUpdatedTarget)
		If $$$ISERR(tSC) Quit
		
		// If after the call to GetUpdatedProvideRequest there are still required
		// metadata fields missing values, then use Configuration Registry-defined
		// defaults to fill them in.
		#dim tXDSbDocument As HS.Message.IHE.XDSb.Document
		If ('$IsObject(pUpdatedTarget.ContentTypeCode))||(pUpdatedTarget.ContentTypeCode.Code="") {
			Set tSC = ..GetCodedEntryDefaultValue("ContentTypeCode", .tCodedValue)
			If $$$ISERR(tSC) Quit
			If $IsObject(tCodedValue) Set pUpdatedTarget.ContentTypeCode = tCodedValue
		}
		For i = 1:1:pUpdatedTarget.Documents.Count() {
			Set tXDSbDocument = pUpdatedTarget.Documents.GetAt(i)
			If ('$IsObject(tXDSbDocument.ClassCode))||(tXDSbDocument.ClassCode.Code="") {
				Set tSC = ..GetCodedEntryDefaultValue("ClassCode", .tCodedValue)
				If $$$ISERR(tSC) Quit
				If $IsObject(tCodedValue) Set tXDSbDocument.ClassCode = tCodedValue
			}
			If tXDSbDocument.ConfidentialityCode.Count()=0 {
				Set tSC = ..GetCodedEntryDefaultValue("ConfidentialityCode", .tCodedValue)
				If $$$ISERR(tSC) Quit
				If $IsObject(tCodedValue) Do tXDSbDocument.ConfidentialityCode.Insert(tCodedValue)
			}
			If ('$IsObject(tXDSbDocument.FormatCode))||(tXDSbDocument.FormatCode.Code="") {
				Set tSC = ..GetCodedEntryDefaultValue("FormatCode", .tCodedValue)
				If $$$ISERR(tSC) Quit
				If $IsObject(tCodedValue) Set tXDSbDocument.FormatCode = tCodedValue
			}
			If ('$IsObject(tXDSbDocument.HealthcareFacilityTypeCode))||(tXDSbDocument.HealthcareFacilityTypeCode.Code="") {
				Set tSC = ..GetCodedEntryDefaultValue("HealthcareFacilityTypeCode", .tCodedValue)
				If $$$ISERR(tSC) Quit
				If $IsObject(tCodedValue) Set tXDSbDocument.HealthcareFacilityTypeCode = tCodedValue
			}
			If ('$IsObject(tXDSbDocument.PracticeSettingCode))||(tXDSbDocument.PracticeSettingCode.Code="") {
				Set tSC = ..GetCodedEntryDefaultValue("PracticeSettingCode", .tCodedValue)
				If $$$ISERR(tSC) Quit
				If $IsObject(tCodedValue) Set tXDSbDocument.PracticeSettingCode = tCodedValue
			}
		}
		
		$$$HSTRACE("ProvideAndRegisterRequest from FHIR Bundle after update", "pUpdatedTarget", pUpdatedTarget)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod GetCodingScheme(pCodeType As %String, pCode As %String, pSystem As %String, pDefault As %String = "") As %String
{
	Set tScheme = ""
	
	Set tOrigForm = ""
	
	If ##class(HS.HC.Util).IsOID(.pSystem,0) {
		// pSystem is an OID. See if there is a row in the Coded Entry table that matches
		// that OID+codetype+code. NOTE that in the cases where the same codetype+code has
		// two rows in the Coded Entry table, the OID version of the Scheme will be used.
		Set tOrigForm = "OID"
		Set tOID = pSystem
		If $Extract(tOID,1,8)="urn:oid:" Set tOID = $Extract(tOID,9,*)
		Set tObject = ##class(HS.IHE.CodedEntry).UniqueIndexOpen(pCodeType, tOID, pCode)
		If $IsObject($Get(tObject)) {
			Set tScheme = tObject.CodingScheme
		} Else {
			// If no row with OID+codetype+code is found, then try to get Scheme from the OID Registry.
			Set tScheme = ##class(HS.Data.OIDMap).GetCodeForOID(tOID,"")
			Set tScheme = $Case(tScheme, "LN":"LOINC", "SCT":"SNOMED", :tScheme)
		}
	} ElseIf ##class(HS.HC.Util).IsURL(.pSystem) {
		// pSystem is a URL. Try to find an OID in the OID Registry for that URL.
		Set tOrigForm = "URL"
		Set tOID = ##class(HS.Data.OIDMap).GetOIDForURL(pSystem)
		If tOID'=pSystem {
			// Found an OID in the OID Registry. See if there is a row in the Coded Entry
			// table that matches that OID. NOTE that in the cases where the same code
			// has two rows in the Coded Entry table, the OID version of the Scheme will
			// be used.
			Set tObject = ##class(HS.IHE.CodedEntry).UniqueIndexOpen(pCodeType, tOID, pCode)
			If $IsObject($Get(tObject)) {
				Set tScheme = tObject.CodingScheme
			} Else {
				// If no row with OID+codetype+code is found, then try to get Scheme from the OID Registry.
				Set tScheme = ##class(HS.Data.OIDMap).GetCodeForOID(tOID,"")
				Set tScheme = $Case(tScheme, "LN":"LOINC", "SCT":"SNOMED", :tScheme)
			}
		} Else {
			// Did not find OID in the OID Registry for this URL. For now we are assuming
			// that every row in the OID Registry has an OID.
			Set tScheme = ""
		}
	} ElseIf ##class(HS.HC.Util).IsUUID(.pSystem,0) {
		// Unlikely we'll get pSystem as a UUID, but providing for it anyway.
		Set tOrigForm = "UUID"
		Set tSystem = pSystem
		If $Extract(tSystem,1,9)="urn:uuid:" Set tScheme = $Extract(tSystem,10,*)
	}
	
	If tScheme="" {
		If (pSystem="http://connectathon.ihe")||(pSystem="urn:oid:1.3.6.1.4.1.21367.2017.3") {
			Set tScheme = "Connect-a-thon "_pCodeType_"s"
		} ElseIf pSystem="urn:oid:1.3.6.1.4.1.19376.1.2.3" {
			For tText = "IHE PCC", "IHE BPPC", "IHE-PCC", "IHE-LAB" {
				Set tObject = ##class(HS.IHE.CodedEntry).UniqueIndexOpen(pCodeType, tText, pCode)
				If $IsObject($Get(tObject)) {
					Set tScheme = tObject.CodingScheme
					Quit
				}
			}
		} ElseIf (pSystem="http://snomed.info/sct")||(pSystem="urn:oid:2.16.840.1.113883.6.96") {
			For tText = "2.16.840.1.113883.6.96", "SNOMED", "SRT", "SNM3" {
				Set tObject = ##class(HS.IHE.CodedEntry).UniqueIndexOpen(pCodeType, tText, pCode)
				If $IsObject($Get(tObject)) {
					Set tScheme = tObject.CodingScheme
					Quit
				}
			}
		} ElseIf pSystem="http://hl7.org/fhir/v3/Confidentiality" {
			Set tScheme = "2.16.840.1.113883.5.25"
		} ElseIf pSystem="http://dicom.nema.org/resources/ontology/DCM" {
			For tText = "1.2.840.10008.2.6.1", "DCM" {
				Set tObject = ##class(HS.IHE.CodedEntry).UniqueIndexOpen(pCodeType, tText, pCode)
				If $IsObject($Get(tObject)) {
					Set tScheme = tObject.CodingScheme
					Quit
				}
			}
		} ElseIf pSystem="urn:oid:2.16.840.1.113883.3.88" {
			For tText = "2.16.840.1.113883.3.88", "HITSP" {
				Set tObject = ##class(HS.IHE.CodedEntry).UniqueIndexOpen(pCodeType, tText, pCode)
				If $IsObject($Get(tObject)) {
					Set tScheme = tObject.CodingScheme
					Quit
				}
			}
		}
	}
	
	If tScheme="" Set tScheme = pDefault
	
	Quit tScheme
}

Method GetPatientIdFromReference(pBundle As HS.FHIR.vSTU3.Model.Resource.Bundle, pDocResource As HS.FHIR.vSTU3.Model.Base.DomainResource, ByRef pBundleIndex, ByRef pPatientId As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tRefValue = pDocResource.subject.reference.value
		Set tRefDisplay = pDocResource.subject.display.value
		Set tDocResourceType = pDocResource.%ClassName(0)
		If (tRefValue="")&&(tRefDisplay'="") {
			// If there is no reference and the display value is an ISO-formatted Patient Id then use the display value.
			If tRefDisplay?1E.E1"^^^"1E.E1"&ISO" Set pPatientId = tRefDisplay
		} ElseIf tRefValue'="" {
			If $Extract(tRefValue)="#" {
				// This is a reference to a contained Patient resource.
				Set tSC = ##class(HS.FHIR.Utils).GetContainedResource(pDocResource, tRefValue, "Patient", .tPatientResource)
				If $$$ISERR(tSC) {
					Set tText = "Invalid "_tDocResourceType_" subject reference value - contained resource not found"
					Do ..Errors.logError("value", "error", tText, , , , tText)
					Set tSC = $$$OK
					Quit
				}
			} ElseIf $Extract(tRefValue,1,4)'="http" {
				// This is a reference to a Patient resource that is in another entry in this Bundle.
				Set tEntryNum = $Get(pBundleIndex("EntryIndexById", tRefValue))
				If tEntryNum="" Set tEntryNum = $Get(pBundleIndex("EntryIndexByFullUrl", tRefValue))
				If tEntryNum'="" {
					Set tPatientResource = pBundle.entry.GetAt(tEntryNum).resource.Patient
				} Else {
					Set tText = "Invalid "_tDocResourceType_" subject reference value - specified resource not found in Bundle"
					Do ..Errors.logError("value", "error", tText, , , , tText)
					Set tSC = $$$OK
					Quit
				}
			} Else {
				// This is a fully qualified reference to a Patient resource on this server or another server.
				Set tL = $Length(tRefValue,"/")
				If (($Piece(tRefValue,"/",tL-1)="Patient")&&($Piece(tRefValue,"/",tL)'=""))||(($Piece(tRefValue,"/",tL-3)="Patient")&&($Piece(tRefValue,"/",tL-1)="_history")) {
					Set tFHIRRequest = ##class(HS.Message.FHIR.Request).%New()
					Set tFHIRRequest.Type = "Patient"
					Set tFHIRRequest.ContentType = "application/fhir+xml"
					Do tFHIRRequest.AdditionalInfo.SetAt(tRefValue, "GetURL")
					// Attempt to derive an existing Service Registry entry that represents
					// the host port and base url indicated in the reference.  We would like
					// to get a Service Registry entry if we can, so that if the end point
					// needs user credentials and/or an SSL config then that can be wrapped
					// up in the Service Registry definition.  If no Service Registry entry
					// is found then the HTTP request will be attempted without it.
					Set tId = ""
					If ($Piece(tRefValue,"/",tL-1)="Patient")&&($Piece(tRefValue,"/",tL)'="") {
						Set tId = $Piece(tRefValue,"/",tL)
						Set tFHIRRequest.Interaction = "read"
					} Else {
						Set tId = $Piece(tRefValue,"/",tL-2)
						Set tFHIRRequest.Interaction = "vread"
						Set tFHIRRequest.VId = $Piece(tRefValue,"/",tL)
					}
					If tId="" {
						Set tText = "Invalid "_tDocResourceType_" subject reference value - Patient resource id missing from fully qualified reference"
						Do ..Errors.logError("value", "error", tText, , , , tText)
						Quit
					}
					Set tFHIRRequest.Id = tId
					
					// The base url of the Patient reference must have a service defined for
					// it in the Service Registry, in order to be able to derive credentials
					// and SSL config.
					Set tBaseURL = $Piece(tRefValue,"/Patient",1,$L(tRefValue,"/Patient")-1)
					Set tServiceObj = ##class(HS.Registry.Service.HTTP).EndPointForURL(tBaseURL)
					If $IsObject($Get(tServiceObj)) {
						Do tFHIRRequest.AdditionalInfo.SetAt(tServiceObj.Name,"ServiceName")
						Kill tServiceObj
					} Else {
						Set tText = "Unable to retrieve Patient resource referenced by "_tDocResourceType_" subject - base url of Patient reference not defined in Service Registry"
						Do ..Errors.logError("exception", "error", tText, , , , tText)
						Set tSC = $$$OK
						Quit
					}
					
					Set tSC = ..SendRequestSync(..#RESTOPERATION, tFHIRRequest, .tFHIRResponse)
					
					// If a fail was incurred - expressed either as a failure return status
					// or as an unsuccessful HTTP status - formulate an error log entry so
					// that a helpful OperationOutcome regarding this Patient retrieve
					// request can be returned to the MHD client that originated the
					// Provide Document Bundle request.
					If $$$ISERR(tSC) {
						Set tText = "Unable to retrieve Patient resource referenced by "_tDocResourceType_" subject - "_$system.Status.GetErrorText(tSC)
						Do ..Errors.logError("exception", "error", tText, , , , tText)
						Set tSC = $$$OK
						Quit
					} ElseIf (+tFHIRResponse.Status>399)&&(+tFHIRResponse.Status<501) {
						If +tFHIRResponse.Status=404 {
							// Intentionally using invalid instead of not-found.
							Set tCode = "invalid"
						} ElseIf +tFHIRResponse.Status=400 {
							Set tCode = "invalid"
						} ElseIf +tFHIRResponse.Status=500 {
							Set tCode = "exception"
						} ElseIf +tFHIRResponse.Status=401 {
							Set tCode = "security"
						} ElseIf +tFHIRResponse.Status=403 {
							Set tCode = "security"
						} Else {
							Set tCode = "invalid"
						}
						Set tText = "Unable to retrieve Patient resource referenced by "_tDocResourceType_" subject - "_tFHIRResponse.Status
						Do ..Errors.logError(tCode, "error", tText, , , , tText)
						Set tSC = $$$OK
						Quit
					}
					
					// Verify the returned content type.
					Do tFHIRResponse.Payload.Rewind()
					Set tTempContentType = ""
					For {
						Set tChar = tFHIRResponse.Payload.Read(1,.tSC)
						If tChar="<" {
							Set tTempContentType = "xml"
							Quit
						} ElseIf tChar="{" {
							Set tTempContentType = "json"
							Quit
						}
					}
					Do tFHIRResponse.Payload.Rewind()
					
					Set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR(tTempContentType, tFHIRResponse.Payload, .tPatientResource, ..ResourceSchemaRoot)
					If $$$ISERR(tSC) {
						Set tText = "Unable to retrieve Patient resource referenced by "_tDocResourceType_" subject - "_$system.Status.GetErrorText(tSC)
						Do ..Errors.logError("exception", "error", tText, , , , tText)
						Quit
					}
					If '$IsObject($Get(tPatientResource)) {
						Set tText = "Unable to retrieve Patient resource referenced by "_tDocResourceType_" subject"
						Do ..Errors.logError("exception", "error", tText, , , , tText)
						Quit
					}
					If tPatientResource.%ClassName(0)="OperationOutcome" {
						Set tErrorMsg = "(error text not found)"
						If tPatientResource.issue.Count()>0 {
							Set tErrorMsg = tPatientResource.issue.GetAt(1).diagnostics.value
							If tErrorMsg="" Set tErrorMsg = tPatientResource.issue.GetAt(1).details.text.value
							If tErrorMsg="" Set tErrorMsg = "(error text not found)"
						}
						Set tText = "Error returned by retrieve of "_tDocResourceType_" subject - "_tErrorMsg
						Do ..Errors.logError("exception", "error", tText, , , , tText)
						Quit
					}
					If tPatientResource.%ClassName(0)'="Patient" {
						Set tText = "Unexpected resource type returned by retrieve of "_tDocResourceType_" subject"
						Do ..Errors.logError("exception", "error", tText, , , , tText)
						Set tPatientResource = ""
						Quit
					}
				}
			}
			If $IsObject($Get(tPatientResource)) Set pPatientId = ..GetPatIdentifierFromResource(tPatientResource)
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// if the request is CDA we may need to extract values from the document and update the request
/// for this reason tUdpatedRequest is used so that the original transaction is not updated
/// *** THIS METHOD IS COPIED FROM HS.IHE.XDSb.DocumentSource.Abstract, because
/// that class extends a class that includes several properties and settings that
/// are not applicable to this class, and because the DocumentSource version of
/// this method is an instance method.  The use of this method here assumes that
/// the ProvideAndRegisterRequest has already been verified to include PatientId,
/// and so ..GetUpdatedPatientId should never be called.
Method GetUpdatedProvideRequest(pRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest, Output pUpdatedRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest) As %Status
{
	#define CloneObject Set tDocument=pUpdatedRequest.Documents.GetAt(tIdx)
	try {
		Set pUpdatedRequest=pRequest.%ConstructClone(1) 
		Set tSC=$$$OK
		$$$HSTRACE("patientid","patientid",pRequest.PatientId)
		If pRequest.PatientId="" Set tSC = ..GetUpdatedPatientId(pRequest,.pUpdatedRequest) Quit:$$$ISERR(tSC)

		For tIdx=1:1:pUpdatedRequest.Documents.Count() {
			#dim tDocument as HS.Message.IHE.XDSb.Document = pUpdatedRequest.Documents.GetAt(tIdx)
			Set tDocObject=""
			Set:tDocument.PatientId="" tDocument.PatientId=$S($isObject(pUpdatedRequest):pUpdatedRequest.PatientId,1:pRequest.PatientId)
			#; locate document to replace
			$$$HSTRACE("ReplacmentContext "_tDocument.ReplacementContext.Count())
			If tDocument.ReplacementContext.Count() $$$CloneObject Set tSC=..GetReplacementId(tDocument,pUpdatedRequest.PatientId) Quit:$$$ISERR(tSC)

			#; if it is binary we will not extract values
			If 'tDocument.BodyCharacter.Size Continue
			#; if the document is not a CDA document, or not even XML, then do not try to parse
			If tDocument.MimeType'="text/xml" Continue
			Do tDocument.BodyCharacter.Rewind()
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:typeId","@root",.tValue,.tDocObject)
			/// if there is no value for the typeId it is not CDA
			If $$$ISERR(tSC) || (tValue="") Continue
			If tDocument.CreationTime="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:effectiveTime","@value",.tValue,.tDocObject)
				#; if there is a value, it probably has an offset, we need to drop the offset for creation time
				If $$$ISOK(tSC) && (tValue]"") $$$CloneObject Set tDocument.CreationTime=##class(HS.Util.XSLTHelper).xmltimestampToUTC(tValue)
			}
			/*
				A= "/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/@value"
				B= "/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:low/@value"
				C= "/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:high/@value"
				D= "/cda:ClinicalDocument/cda:effectiveTime/@value"
 
				The UTC date we will use is the first one that has a value.
 
					serviceStartTime = B,A,D (only going to get A or B, never both, defaulting back to D which is mandatory)
					serviceEndTime   = C,A,D (only going to get A or C, never both, defaulting back to D which is mandatory)
			*/
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:componentOf/hl7:encompassingEncounter/hl7:effectiveTime","@value",.tA,.tDocObject)
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:componentOf/hl7:encompassingEncounter/hl7:effectiveTime/hl7:low","@value",.tB,.tDocObject)
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:componentOf/hl7:encompassingEncounter/hl7:effectiveTime/hl7:high","@value",.tC,.tDocObject)
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:effectiveTime","@value",.tD,.tDocObject)
			If tDocument.ServiceStartTime="" {
				Set tTime=$S($G(tB)]"":tB,$G(tA)]"":tA,1:$g(tD))
				Set tDocument.ServiceStartTime=##class(HS.Util.XSLTHelper).xmltimestampToUTC(tTime)
			}
			If tDocument.ServiceStopTime="" {
				Set tTime=$S($G(tC)]"":tB,$G(tA)]"":tA,1:$g(tD))
				Set tDocument.ServiceStopTime=##class(HS.Util.XSLTHelper).xmltimestampToUTC(tTime)
			}

			If tDocument.LanguageCode="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:languageCode","@code",.tValue,.tDocObject)
				If $$$ISOK(tSC) && (tValue]"") $$$CloneObject Set tDocument.LanguageCode=tValue
			}
			If tDocument.SourcePatientId="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:id","@root",.tValueRoot,.tDocObject)
				Set tSC2 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:id","@extension",.tValueExtension,.tDocObject)
				If $$$ISOK(tSC) && $$$ISOK(tSC2) && (((tValueExtension="") && (tValueRoot="")) || ((tValueExtension="") && ($Length(tValueRoot,"-")>3) && ($Translate(tValueRoot,"-")?1LN.LN))) {
					// If this is a AU CDA document, patientRole id will be just a UUID in @root. Look down in ext:asEntityIdentifier for an MRN.
					Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[ext:code/@code='MR']/ext:id","@root",.tValueRoot,.tDocObject)
					Set tSC2 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[ext:code/@code='MR']/ext:id","@extension",.tValueExtension,.tDocObject)
					If $$$ISOK(tSC) && $$$ISOK(tSC2) && (tValueExtension="") && (tValueRoot="") {
						// If MRN not found in AU document, look down in ext:asEntityIdentifier for an IHI.
						Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[ext:id/@assigningAuthorityName='IHI']/ext:id","@root",.tValueRoot,.tDocObject)
						Set tSC2 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[ext:id/@assigningAuthorityName='IHI']/ext:id","@extension",.tValueExtension,.tDocObject)
						If $Extract(tValueRoot,1,27)="1.2.36.1.2001.1003.0.800360",tValueExtension="" Set tValueExtension=$Extract(tValueRoot,22,*),tValueRoot="1.2.36.1.2001.1003.0"
					}
				}
				If $$$ISOK(tSC) && $$$ISOK(tSC2) && (tValueExtension]"") && (tValueRoot]"") $$$CloneObject Set tDocument.SourcePatientId=tValueExtension_"^^^&"_tValueRoot_"&ISO"
			}
			If tDocument.ServiceStartTime="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:documentationOf/hl7:serviceEvent/hl7:effectiveTime/hl7:low","@value",.tValue,.tDocObject)
				If $$$ISOK(tSC) && (tValue]"") $$$CloneObject Set tDocument.ServiceStartTime=tValue
			}
			If tDocument.ServiceStopTime="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:documentationOf/hl7:serviceEvent/hl7:effectiveTime/hl7:high","@value",.tValue,.tDocObject)
				If $$$ISOK(tSC) && (tValue]"") $$$CloneObject Set tDocument.ServiceStopTime=tValue
			}
			If tDocument.Title="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:title","text()",.tValue,.tDocObject)
				If $$$ISOK(tSC) && (tValue]"") $$$CloneObject Set tDocument.Title=tValue
			
			}
			If tDocument.ConfidentialityCode.Count()=0 {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:confidentialityCode","@code",.tCode,.tDocObject)
				Set tSC2 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:confidentialityCode","@codeSystem",.tScheme,.tDocObject)
				Set tSC3 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:confidentialityCode","@displayName",.tDescription,.tDocObject)
				// Document-level confidentialityCode could be nullFlavor.  If so, default in N for Normal.
				If $$$ISOK(tSC),$$$ISOK(tSC2),$$$ISOK(tSC3),tCode="",tScheme="" Set tCode="N",tScheme="2.16.840.1.113883.5.25",tDescription="Normal"
				If $$$ISOK(tSC) && $$$ISOK(tSC2) && $$$ISOK(tSC3) $$$CloneObject Do tDocument.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create(tCode,tScheme,tDescription))
			}
			If tDocument.SourcePatientInfo.Count()=0 {
				$$$CloneObject
				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-3|"_tDocument.SourcePatientId))
				#; patient name
				Set tPID="PID-5|"
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name/hl7:family","text()",.tValue,.tDocObject)
				Set tPID=tPID_tValue_"^"
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name/hl7:given[1]","text()",.tValue,.tDocObject)
				Set tPID=tPID_tValue_"^"
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name/hl7:given[2]","text()",.tValue,.tDocObject)
				Set tPID=tPID_tValue
				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New(tPID))
				#; BirthDate
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthTime","@value",.tValue,.tDocObject)
				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-7|"_tValue))
				#; Gender
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode","@code",.tValue,.tDocObject)
				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-8|"_tValue))
				#; Address

				Set tStreet=""				
				Set tSC = tDocObject.EvaluateExpression("/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:streetAddressLine", "text()", .tResults)
				For tIdx=1:1:tResults.Count() { Set tStreet=tStreet_";"_tResults.GetAt(tIdx).Value}
				Set tPID=$e(tStreet,2,*)
				
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:additionalLocator","text()",.tValue,.tDocObject)
				Set tPID=tPID_"^"_tValue
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:city","text()",.tValue,.tDocObject)
				Set tPID=tPID_"^"_tValue
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:state","text()",.tValue,.tDocObject)
				Set tPID=tPID_"^"_tValue
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:postalCode","text()",.tValue,.tDocObject)
				Set tPID=tPID_"^"_tValue

				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-11|"_tPID))

			}
			
			If tDocument.Author.Count()=0 {
				///cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:assignedPerson/ext:asEntityIdentifier/ext:id[@assigningAuthorityName='HPI-I']/@root
				///cda:ClinicalDocument/cda:author/cda:assignedAuthor/ cda:assignedPerson/cda:name
				Set tAuthor = ##class(HS.IHE.XDSb.Types.Author).%New(),tFound=0
				Set (tFirstName,tMiddleName,tLastName,tPrefix,tSuffix)=""
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:given[1]","text()",.tFirstName,.tDocObject)
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:given[2]","text()",.tMiddleName,.tDocObject)
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:family","text()",.tLastName,.tDocObject)
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:prefix","text()",.tPrefix,.tDocObject)
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:suffix","text()",.tSuffix,.tDocObject)
				If tFirstName'=""!(tLastName'="") {
					// As suggested by ITI TF-3 2012 section 4.2.3.1.4 example, the format is identifier^last^first^middle^suffix^prefix.
					Set tValue=""
					Set $Piece(tValue,"^",2)=tLastName
					Set $Piece(tValue,"^",3)=tFirstName
					Set $Piece(tValue,"^",4)=tMiddleName
					Set $Piece(tValue,"^",5)=tSuffix
					Set $Piece(tValue,"^",6)=tPrefix
					Set tAuthor.AuthorPerson=tValue
					Set tFound=1
				}
				If tFound=0 {
					Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name","text()",.tValue,.tDocObject)
					Set tValue=$Translate(tValue,$Char(10))
					Set tAuthor.AuthorPerson=tValue Set:tValue]"" tFound=1
				}
				Set tSC2 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:representedOrganization/hl7:name","text()",.tValue,.tDocObject)
				If tValue]"" Do tAuthor.AuthorInstitution.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New(tValue)) Set tFound=1

				/// need role and specialty
				If $$$ISOK(tSC) && $$$ISOK(tSC2) && tFound {
					Do tDocument.Author.Insert(tAuthor)					
				}
								
			}
			
		
			If tDocument.FormatCode.Code="" {
				Set tSQL = "SELECT ID,Code,CodingScheme,Description FROM HS_IHE.CodedEntry WHERE CodeType='formatCode'"
				Set tStatement = ##class(%SQL.Statement).%New()
				Set tStatement.%SelectMode = 2
				Set tStatus = tStatement.%Prepare(tSQL)
				Set tResultSet = tStatement.%Execute()
				While tResultSet.%Next() {
					// If there's duplicate entries (different CodingSchemes) then we end up with the last one only.
					Set tFormatCodes(tResultSet.Code)=tResultSet.CodingScheme_"|"_tResultSet.Description
				}
				Kill tResultSet
				Kill tStatement
				
				// There can be several document-level templateIds.  Loop until
				// the end or until you find one that matches a valid formatCode.
				For jj = 1:1 {
					Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:templateId["_jj_"]","@root",.tValue,.tDocObject)
					If $$$ISERR(tSC)!(tValue="") Quit
					If $Data(tFormatCodes(tValue))#10 Set tDocument.FormatCode = ##class(HS.IHE.XDSb.Types.CodedValue).Create(tValue,$Piece(tFormatCodes(tValue),"|",1),$Piece(tFormatCodes(tValue),"|",2)) Quit
				}
				Kill tFormatCodes
			}
			
			If tDocument.TypeCode.Code="" {
				// A valid CDA document has an OID for document level code/@codeSystem, so assume it's an OID.
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@code",.tDocCode,.tDocObject)
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@codeSystem",.tDocCodeSystem,.tDocObject)
				Set tDocCodeSystemName = ##class(HS.Data.OIDMap).GetCodeForOID(tDocCodeSystem)
				Set tDocCodeSystemNameUp = $ZCVT(tDocCodeSystemName,"U")
				
				// First look for the Code with the OID as the CodingScheme.
				// If not found then look for the Code with the OID's IdentityCode (case-insensitive) as the CodingScheme.
				If tDocCode'="",tDocCodeSystem'="" {
					Set tSQL = "SELECT ID,Code,CodingScheme,Description FROM HS_IHE.CodedEntry WHERE CodeType='typeCode' AND Code=?"
					Set tStatement = ##class(%SQL.Statement).%New()
					Set tStatement.%SelectMode = 2
					Set tStatus = tStatement.%Prepare(tSQL)
					Set tResultSet = tStatement.%Execute(tDocCode)
					While tResultSet.%Next() {
						Set tCodeSchemes($ZCVT(tResultSet.CodingScheme,"U"))=tResultSet.CodingScheme_"|"_tResultSet.Description
					}
					Kill tResultSet
					Kill tStatement
					If $Data(tCodeSchemes(tDocCodeSystem))#10 {
						Set tDocument.TypeCode = ##class(HS.IHE.XDSb.Types.CodedValue).Create(tDocCode,$Piece(tCodeSchemes(tDocCodeSystem),"|",1),$Piece(tCodeSchemes(tDocCodeSystem),"|",2))
					} Else {
						If $Data(tCodeSchemes(tDocCodeSystemNameUp))#10 Set tDocument.TypeCode = ##class(HS.IHE.XDSb.Types.CodedValue).Create(tDocCode,$Piece(tCodeSchemes(tDocCodeSystemNameUp),"|",1),$Piece(tCodeSchemes(tDocCodeSystemNameUp),"|",2))
					}
					Kill tCodeSchemes
				}
			}
			
			If tDocument.ClassCode.Code="" {
				If $Get(tDocCode)="" {
					// A valid CDA document has an OID for document level code/@codeSystem, so assume it's an OID.
					Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@code",.tDocCode,.tDocObject)
					Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@codeSystem",.tDocCodeSystem,.tDocObject)
					Set tDocCodeSystemName = ##class(HS.Data.OIDMap).GetCodeForOID(tDocCodeSystem)
					Set tDocCodeSystemNameUp = $ZCVT(tDocCodeSystemName,"U")
				}
				
				// First look for the Code with the OID as the CodingScheme.
				// If not found then look for the Code with the OID's IdentityCode (case-insensitive) as the CodingScheme.
				If tDocCode'="",tDocCodeSystem'="" {
					Set tSQL = "SELECT ID,Code,CodingScheme,Description FROM HS_IHE.CodedEntry WHERE CodeType='classCode' AND Code=?"
					Set tStatement = ##class(%SQL.Statement).%New()
					Set tStatement.%SelectMode = 2
					Set tStatus = tStatement.%Prepare(tSQL)
					Set tResultSet = tStatement.%Execute(tDocCode)
					While tResultSet.%Next() {
						Set tCodeSchemes($ZCVT(tResultSet.CodingScheme,"U"))=tResultSet.CodingScheme_"|"_tResultSet.Description
					}
					Kill tResultSet
					Kill tStatement
					If $Data(tCodeSchemes(tDocCodeSystem))#10 {
						Set tDocument.ClassCode = ##class(HS.IHE.XDSb.Types.CodedValue).Create(tDocCode,$Piece(tCodeSchemes(tDocCodeSystem),"|",1),$Piece(tCodeSchemes(tDocCodeSystem),"|",2))
					} Else {
						If $Data(tCodeSchemes(tDocCodeSystemNameUp))#10 Set tDocument.ClassCode = ##class(HS.IHE.XDSb.Types.CodedValue).Create(tDocCode,$Piece(tCodeSchemes(tDocCodeSystemNameUp),"|",1),$Piece(tCodeSchemes(tDocCodeSystemNameUp),"|",2))
					}
					Kill tCodeSchemes
				}
			}
		}
		Quit:$$$ISERR(tSC)		
		$$$HSTRACE("About to call update associations"_pUpdatedRequest.Associations.Count())
		Set tSC=..UpdateAssociations(pUpdatedRequest)
	} catch ex {
		Set tSC = ex.AsStatus()
		$$$HSTRACE("Error","tSC",tSC)
	}
	Quit tSC
}

/// This short method is included only to allow for copying GetUpdatedProvideRequest
/// from HS.IHE.XDSb.DocumentSource.Abstract as is.  This class assumes that
/// GetUpdatedPatientId will never be needed, and so it is reduced to a single line.
Method GetUpdatedPatientId(pRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest, Output pUpdatedRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest) As %Status [ Internal ]
{
	Quit $$$OK
}

/// This short method is included only to allow for copying GetUpdatedProvideRequest
/// from HS.IHE.XDSb.DocumentSource.Abstract as is.  This class assumes that
/// GetReplacementId will never be needed, and so it is reduced to a single line.
Method GetReplacementId(pDocument As HS.Message.IHE.XDSb.Document, pPatientId) As %Status [ Internal ]
{
	Quit $$$OK
}

/// *** THIS METHOD IS COPIED FROM HS.IHE.XDSb.DocumentSource.Abstract, because
/// that class extends a class that includes several properties and settings that
/// are not applicable to this class, and because the DocumentSource version of
/// this method is an instance method.
Method UpdateAssociations(pRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest) As %Status
{
	Set tSC=$$$OK
	try {
		#; user may have already created associations track which items and don't create them again
		Set tAssociations=""
		For tIdx =1:1:pRequest.Associations.Count() {
			Set tAssociation = pRequest.Associations.GetAt(tIdx)
			If tAssociation.Type="HasMember",tAssociation.ChildUUID]"" Set tAssociations(tAssociation.ChildUUID,tAssociation.ParentUUID)=""
		}
		For tIdx=1:1:pRequest.Documents.Count() {
			Set tDocument = pRequest.Documents.GetAt(tIdx)
			#; don't add the association if it is already in there
			If $D(tAssociations(tDocument.EntryUUID,pRequest.EntryUUID)) Continue
			Set tAssociation = ##class(HS.Message.IHE.XDSb.Association).Create("HasMember",pRequest.EntryUUID,tDocument.EntryUUID)
			If tDocument.Version]"" Set tAssociation.PreviousVersion=tDocument.Version
			Set tAssociation.SubmissionSetStatus="Original"
			Do pRequest.Associations.Insert(tAssociation)
			If tDocument.ReplaceSource]"" {
				Set tReplaceSource=tDocument.ReplaceSource
				If $E(tReplaceSource,1,3)="urn" Set tReplaceSource=$p(tReplaceSource,"urn:uuid:",2)
				Set tAssociation = ##class(HS.Message.IHE.XDSb.Association).Create("Replaces",tDocument.EntryUUID,tReplaceSource)
				Do pRequest.Associations.Insert(tAssociation)
			}
		}
		For tIdx=1:1:pRequest.Folders.Count() {
			Set tFolder=pRequest.Folders.GetAt(tIdx)
			#; don't add the association if it is already in there

			If $D(tAssociations(tFolder.EntryUUID,pRequest.EntryUUID)) Continue
			Set tAssociation = ##class(HS.Message.IHE.XDSb.Association).Create("HasMember",pRequest.EntryUUID,tFolder.EntryUUID)
			Do pRequest.Associations.Insert(tAssociation)
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Take a FHIR DocumentReference resource that is from a Provide Document
/// Bundle and create a Document to add to the XDSb ProvideAndRegisterRequest.
Method DocReferenceToXDSbDocument(pBundle As HS.FHIR.vSTU3.Model.Resource.Bundle, ByRef pBundleIndex As %String, pDocumentReference As HS.FHIR.vSTU3.Model.Resource.DocumentReference, ByRef pPatientId As %String, ByRef pSourcePatientId As %String, Output pXDSbDocument As HS.Message.IHE.XDSb.Document) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set pXDSbDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
		
		Set tSC = ..GetAuthorNameFromReference(pBundle, .pBundleIndex, pDocumentReference, .tAuthorName)
		If $$$ISERR(tSC) Quit
		If (..Errors.Errors.Count())&&(..Errors.HighestError="error") Quit
		Set tAuthor = ##class(HS.IHE.XDSb.Types.Author).%New()
		If tAuthorName'="" {
			Set tAuthor.AuthorPerson = tAuthorName
		} Else {
			Set tAuthor.AuthorPerson = "^Smitty^Gerald^^^"
		}
		Do pXDSbDocument.Author.Insert(tAuthor)
		
		Set pXDSbDocument.PatientId = pPatientId
		Set pXDSbDocument.SourcePatientId = pSourcePatientId
		Set:pXDSbDocument.SourcePatientId="" pXDSbDocument.SourcePatientId = pPatientId
		
		If $IsObject(pDocumentReference.class) {
			Set tCodeableConcept = pDocumentReference.class
			If tCodeableConcept.coding.Count()>0 {
				Set tCode = tCodeableConcept.coding.GetAt(1).code.value
				Set tDescription = tCodeableConcept.coding.GetAt(1).display.value
				Set tSystem = tCodeableConcept.coding.GetAt(1).system.value
				Set tScheme = ..GetCodingScheme("classCode", tCode, tSystem, tSystem)
				Set tCodedValue = ##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode, tScheme, tDescription)
				Set pXDSbDocument.ClassCode = tCodedValue
			}
		}
		
		// Since indexed made it through the FHIRToHSFHIR okay, assume it is a valid FHIR instant.
		Set tCreationTime = pDocumentReference.indexed.value
		// Convert the FHIR instant to HL7 DTM format, which is YYYYMMDDHHMMSS in UTC
		Set tCreationTime = ##class(HS.FHIR.Utils).ConvertToUTC(tCreationTime)
		Set tCreationTime = $Translate(tCreationTime,"TZ-:.")
		Set tCreationTime = $Extract(tCreationTime,1,14)
		Set pXDSbDocument.CreationTime = tCreationTime
		
		Set pXDSbDocument.Title = pDocumentReference.description.value
		
		If $IsObject(pDocumentReference.securityLabel) {
			For i = 1:1:pDocumentReference.securityLabel.Count() {
				Set tCodeableConcept = pDocumentReference.securityLabel.GetAt(i)
				If tCodeableConcept.coding.Count()>0 {
					Set tCode = tCodeableConcept.coding.GetAt(1).code.value
					Set tDescription = tCodeableConcept.coding.GetAt(1).display.value
					Set tSystem = tCodeableConcept.coding.GetAt(1).system.value
					Set tScheme = ..GetCodingScheme("confidentialityCode", tCode, tSystem, tSystem)
					Set tCodedValue = ##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode, tScheme, tDescription)
					Do pXDSbDocument.ConfidentialityCode.Insert(tCodedValue)
				}
			}
		}
		
		If $IsObject(pDocumentReference.type) {
			Set tCodeableConcept = pDocumentReference.type
			If tCodeableConcept.coding.Count()>0 {
				Set tCode = tCodeableConcept.coding.GetAt(1).code.value
				Set tDescription = tCodeableConcept.coding.GetAt(1).display.value
				Set tSystem = tCodeableConcept.coding.GetAt(1).system.value
				Set tScheme = ..GetCodingScheme("typeCode", tCode, tSystem, tSystem)
				Set tCodedValue = ##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode, tScheme, tDescription)
				Set pXDSbDocument.TypeCode = tCodedValue
			}
		}
		
		If $IsObject(pDocumentReference.content.GetAt(1).format) {
			If $IsObject(pDocumentReference.content.GetAt(1).format) {
				Set tCoding = pDocumentReference.content.GetAt(1).format
				Set tCode = tCoding.code.value
				Set tDescription = tCoding.display.value
				Set tSystem = tCoding.system.value
				Set tScheme = ..GetCodingScheme("formatCode", tCode, tSystem, tSystem)
				Set tCodedValue = ##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode, tScheme, tDescription)
				Set pXDSbDocument.FormatCode = tCodedValue
			}
		}
		
		If $IsObject(pDocumentReference.context) {
			For i = 1:1:pDocumentReference.context.event.Count() {
				Set tCodeableConcept = pDocumentReference.context.event.GetAt(i)
				If tCodeableConcept.coding.Count()>0 {
					Set tCode = tCodeableConcept.coding.GetAt(1).code.value
					Set tDescription = tCodeableConcept.coding.GetAt(1).display.value
					Set tSystem = tCodeableConcept.coding.GetAt(1).system.value
					Set tScheme = ..GetCodingScheme("eventCodeList", tCode, tSystem, tSystem)
					Set tCodedValue = ##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode, tScheme, tDescription)
					Do pXDSbDocument.EventCodeList.Insert(tCodedValue)
				}
			}
			
			If $IsObject(pDocumentReference.context.facilityType) {
				Set tCodeableConcept = pDocumentReference.context.facilityType
				If tCodeableConcept.coding.Count()>0 {
					Set tCode = tCodeableConcept.coding.GetAt(1).code.value
					Set tDescription = tCodeableConcept.coding.GetAt(1).display.value
					Set tSystem = tCodeableConcept.coding.GetAt(1).system.value
					Set tScheme = ..GetCodingScheme("healthcareFacilityTypeCode", tCode, tSystem, tSystem)
					Set tCodedValue = ##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode, tScheme, tDescription)
					Set pXDSbDocument.HealthcareFacilityTypeCode = tCodedValue
				}
			}
			
			If $IsObject(pDocumentReference.context.related) {
				If pDocumentReference.context.related.Count()>0 {
					Set tSlot = ""
					For i = 1:1:pDocumentReference.context.related.Count() {
						Set tRelated = pDocumentReference.context.related.GetAt(i)
						If ($IsObject(tRelated.identifier))&&($IsObject(tRelated.identifier.type))&&($IsObject(tRelated.identifier.type.coding)) {
							Set tSlotValueValue = tRelated.identifier.value.value
							Set tSlotSystem = tRelated.identifier.system.value
							If $Extract(tSlotSystem,1,8)="urn:oid:" {
								Set tSlotSystem = $Extract(tSlotSystem,9,*)
							} ElseIf $Extract(tSlotSystem,1,9)="urn:uuid:" {
								Set tSlotSystem = $Extract(tSlotSystem,10,*)
							}
							Set tSlotTypeCode = tRelated.identifier.type.coding.GetAt(1).code.value
							If (tSlotValueValue'="")&&(tSlotSystem'="")&&(tSlotTypeCode'="") {
								If '$IsObject(tSlot) {
									Set tSlot = ##class(HS.IHE.XDSb.Types.Slot).%New()
									Set tSlot.Name = "urn:ihe:iti:xds:2013:referenceIdList"
								}
								Set tSlotValue = ##class(HS.IHE.XDSb.Types.SlotValue).%New()
								Set tSlotValue.Value = tSlotValueValue_"^^^&"_tSlotSystem_"&ISO^"_tSlotTypeCode
								Do tSlot.ValueList.Insert(tSlotValue)
							}
						}
					}
					If $IsObject(tSlot) Do pXDSbDocument.DocumentSlots.Insert(tSlot)
				}
			}
			
			If $IsObject(pDocumentReference.context.practiceSetting) {
				Set tCodeableConcept = pDocumentReference.context.practiceSetting
				If tCodeableConcept.coding.Count()>0 {
					Set tCode = tCodeableConcept.coding.GetAt(1).code.value
					Set tDescription = tCodeableConcept.coding.GetAt(1).display.value
					Set tSystem = tCodeableConcept.coding.GetAt(1).system.value
					Set tScheme = ..GetCodingScheme("practiceSettingCode", tCode, tSystem, tSystem)
					Set tCodedValue = ##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode, tScheme, tDescription)
					Set pXDSbDocument.PracticeSettingCode = tCodedValue
				}
			}
		}
		
		Set pXDSbDocument.LanguageCode = "en-US"
		
		Set pXDSbDocument.Availability = 1
		
		// MHD maps DocumentReference masterIdentifier to XDSb Document Entry UniqueId.
		// Per http://hl7.org/fhir/datatypes.html#identifier, "If the identifier value itself
		// is naturally a globally unique URI (e.g. an OID, a UUID, or a URI with no trailing
		// local part), then the system SHALL be "urn:ietf:rfc:3986", and the URI is in the
		// value (OIDs and UUIDs using urn:oid: and urn:uuid: - see examples)". Per MHD STU3
		// CP-ITI-943-01-ballot42, if the uniqueId *does* have a trailing part, presumably for
		// an extension value (e.g., for OID^extension), then the URI will be placed in the
		// masterIdentifier system property and the extension will be placed in the masterIdentifier
		// value property.
		If ($IsObject(pDocumentReference.masterIdentifier))&&(pDocumentReference.masterIdentifier.value.value'="") {
			// Since the DocumentReference has already been through validation, assume
			// that if masterIdentifier is present then it has both system and value
			// and that system is a valid value.
			Set tValue = pDocumentReference.masterIdentifier.value.value
			Set tSystem = pDocumentReference.masterIdentifier.system.value
			If (##class(HS.HC.Util).IsOID(tValue))||(##class(HS.HC.Util).IsUUID(tValue)) {
				If $Extract(tValue,1,8)="urn:oid:" {
					Set tUniqueId = $Extract(tValue,9,*)
				} ElseIf $Extract(tValue,1,9)="urn:uuid:" {
					Set tUniqueId = "2.25."_$system.Util.HexToDecimal($Translate($Extract(tValue,10,*),"-"))
				} ElseIf ##class(HS.HC.Util).IsUUID(tValue) {
					Set tUniqueId = "2.25."_$system.Util.HexToDecimal($Translate(tValue,"-"))
				} Else {
					Set tUniqueId = tValue
				}
			} Else {
				If $Extract(tSystem,1,8)="urn:oid:" Set tSystem = $Extract(tSystem,9,*)
				Set tUniqueId = tSystem_"^"_tValue
			}
		} Else {
			Set tUniqueId = "2.25."_$system.Util.CreateDecimalGUID()
		}
		
		Set pXDSbDocument.UniqueId = tUniqueId
		
		Set tEntryUUID = ""
		For i = 1:1:pDocumentReference.identifier.Count() {
			Set tIdentifier = pDocumentReference.identifier.GetAt(i)
			Set tValue = tIdentifier.value.value
			If (##class(HS.HC.Util).IsUUID(tValue)) {
				If tIdentifier.use.value="official" {
					Set tEntryUUID = tValue
					Quit
				}
			}
		}
		If tEntryUUID="" Set tEntryUUID = $ZConvert($system.Util.CreateGUID(),"L")
		
		If $Extract(tEntryUUID,1,9)'="urn:uuid:" {
			Set tEntryUUID = "urn:uuid"_tEntryUUID
		}
		
		Set pXDSbDocument.EntryUUID = tEntryUUID
		
		// FHIR Attachment.data.value and Binary.content.value are always Base64
		// encoded as per the FHIR spec for those properties. Therefore they must
		// always be decoded when read.
		
		If $IsObject(pDocumentReference.content.GetAt(1).attachment) {
			Set tAttachment = pDocumentReference.content.GetAt(1).attachment
			Set pXDSbDocument.Comments = tAttachment.title.value
			If (tAttachment.url.value'="")&&(tAttachment.data.value="") {
				Set tEntryIndex = $Get(pBundleIndex("EntryIndexByFullUrl", tAttachment.url.value))
				If tEntryIndex="" {
					Do ..Errors.logError("value", "error", "Provide Document Bundle DocumentReference Binary resource reference does not point a resource in the Bundle")
					Quit
				}
				
				Set tBinaryResource = pBundle.entry.GetAt(tEntryIndex).resource.Binary
				
				// Verify that the provided FHIR SHA-1 hash (base64encoded) is correct.
				If tAttachment.hash.value'="" {
					Set tFHIRHash = $system.Encryption.Base64Encode($system.Encryption.SHA1Hash($system.Encryption.Base64Decode(tBinaryResource.content.value)))
					// Reject the Provide Document Bundle if the provided FHIR hash does not verify.
					If tAttachment.hash.value'=tFHIRHash {
						Do ..Errors.logError("value", "error", "Specified hash '"_tAttachment.hash.value_"' does not match calculated hash '"_tFHIRHash_"'")
						Quit
					}
				}
				
				// XDSb requires hexbinary hash. Generate that hash now.
				Set pXDSbDocument.Hash = ##class(HS.IHE.XDSb.Util).StreamHash(tBinaryResource.content.value)
				
				If tBinaryResource.contentType.value="text/xml" {
					Do pXDSbDocument.BodyCharacter.Write($system.Encryption.Base64Decode(tBinaryResource.content.value))
					Do pXDSbDocument.BodyCharacter.Rewind()
					Set pXDSbDocument.Hash = ##class(HS.IHE.XDSb.Util).StreamHash(pXDSbDocument.BodyCharacter)
				} Else {
					Do pXDSbDocument.Body.Write($system.Encryption.Base64Decode(tBinaryResource.content.value))
					Do pXDSbDocument.Body.Rewind()
					Set pXDSbDocument.Hash = ##class(HS.IHE.XDSb.Util).StreamHash(pXDSbDocument.Body)
				}
				Set pXDSbDocument.MimeType = tBinaryResource.contentType.value
			} Else {
				If tAttachment.contentType.value="text/xml" {
					Do pXDSbDocument.BodyCharacter.Write($system.Encryption.Base64Decode(tAttachment.data.value))
					Do pXDSbDocument.BodyCharacter.Rewind()
					Set pXDSbDocument.Hash = ##class(HS.IHE.XDSb.Util).StreamHash(pXDSbDocument.BodyCharacter)
				} Else {
					Do pXDSbDocument.Body.Write($system.Encryption.Base64Decode(tAttachment.data.value))
					Do pXDSbDocument.Body.Rewind()
					Set pXDSbDocument.Hash = ##class(HS.IHE.XDSb.Util).StreamHash(pXDSbDocument.Body)
				}
				Set pXDSbDocument.MimeType = tAttachment.contentType.value
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method ListToXDSbFolder(pBundle As HS.FHIR.vSTU3.Model.Resource.Bundle, pList As HS.FHIR.vSTU3.Model.Resource.List, ByRef pPatientId As %String, Output pXDSbFolder As HS.Message.IHE.XDSb.Folder, Output pAssociations As %Library.ListOfDataTypes) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set pXDSbFolder = ##class(HS.Message.IHE.XDSb.Folder).%New()
		
		Set pAssociations = ##class(%Library.ListOfDataTypes).%New()
		
		Set tFolderEntryUUID = ""
		Set tFolderUniqueId = ""
		
		#dim tIdentifier As HS.FHIR.vSTU3.Model.Base.Identifier
		
		For i = 1:1:pList.identifier.Count() {
			Set tIdentifier = pList.identifier.GetAt(i)
			Set tVal = tIdentifier.value.value
			If (##class(HS.HC.Util).IsUUID(tVal)) {
				If tIdentifier.use.value="official" {
					Set tFolderEntryUUID = tVal
				} ElseIf tIdentifier.use.value="usual" {
					Set tFolderUniqueId = tVal
				}
			}
		}
		// If no EntryUUID found, then create one ourselves.
		If tFolderEntryUUID="" Set tFolderEntryUUID = $ZConvert($system.Util.CreateGUID(),"L")
		// If no UniqueId found, then create one ourselves.
		If tFolderUniqueId="" Set tFolderUniqueId = "2.25."_$system.Util.CreateDecimalGUID()
		
		If $Extract(tFolderEntryUUID,1,9)'="urn:uuid:" {
			Set tFolderEntryUUID = "urn:uuid"_tFolderEntryUUID
		}
		
		Set pXDSbFolder.EntryUUID = tFolderEntryUUID
		
		Set pXDSbFolder.UniqueId = tFolderUniqueId
		
		Set pXDSbFolder.Title = pList.title.value
		
		#dim tCoding As HS.FHIR.vSTU3.Model.Base.Coding
		
		If $IsObject(pList.code) {
			For i = 1:1:pList.code.coding.Count() {
				Set tCoding = pList.code.coding.GetAt(i)
				If (tCoding.system.value'="")&&((tCoding.code.value'="")||(tCoding.display.value'="")) {
					Set tCode = $Select(tCoding.code.value'="":tCoding.code.value,1:tCoding.display.value)
					Set tDescription = $Select(tCoding.display.value'="":tCoding.display.value,1:tCoding.code.value)
					Set tSystem = tCoding.system.value
					Set tScheme = ..GetCodingScheme("folderCodeList", tCode, tSystem, tSystem)
					Set tCodedValue = ##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription)
					Do pXDSbFolder.CodeList.Insert(tCodedValue)
				}
			}
		}
		
		Set pXDSbFolder.PatientId = pPatientId
		
		If pList.status.value="current" {
			Set pXDSbFolder.AvailabilityStatus = "Approved"
		} Else {
			Set pXDSbFolder.AvailabilityStatus = "Deprecated"
		}
		
		Set tLastUpdateTime = pList.date.value
		If tLastUpdateTime'="" {
			// Convert the FHIR dateTime to HL7 DTM format, which is YYYYMMDDHHMMSS in UTC
			Set tLastUpdateTime = ##class(HS.FHIR.Utils).ConvertToUTC(tLastUpdateTime)
			Set tLastUpdateTime = $Translate(tLastUpdateTime,"TZ-:.")
			Set tLastUpdateTime = $Extract(tLastUpdateTime,1,14)
			Set pXDSbFolder.LastUpdateTime = tLastUpdateTime
		}
		
		If pList.note.Count() {
			Set pXDSbFolder.Comments = pList.note.GetAt(1).text.value
		}
		
		#dim tItem As HS.FHIR.vSTU3.Model.Base.Reference
		#dim tBundleEntry As HS.FHIR.vSTU3.Model.Resource.Bundle.Entry
		
		For i = 1:1:pList.entry.Count() {
			// item is a reference to a DocumentReference in this submission.
			// item must provide the means to derive a DocumentEntryUUID value.
			// 1. If item.identifier is present and use=official, then that is the DocumentEntryUUID.
			// 2. If item.reference is present, then it is assumed to be a reference to a
			//    DocumentReference in this Provide Bundle. Scan the Bundle to find the
			//    entry with the fullUrl that matches this reference, then in that entry
			//    find the identifier that has use=official, and the value of that identifier
			//    is the DocumentEntryUUID.
			// 3. Otherwise if neither of the above is present and item.display is present
			//    and is a UUID, then use item.display as the DocumentEntryUUID.
			Set tItem = pList.entry.GetAt(i).item
			Set tDocumentEntryUUID = ""
			If ($IsObject(tItem.identifier))&&(tItem.identifier.use.value="official")&&(##class(HS.HC.Util).IsUUID(tItem.identifier.value.value)) {
				Set tDocumentEntryUUID = tItem.identifier.value.value
				If $Extract(tDocumentEntryUUID,1,9)'="urn:uuid:" {
					Set tDocumentEntryUUID = "urn:uuid:"_tDocumentEntryUUID
				}
			} ElseIf (($IsObject(tItem.reference))&&(tItem.reference.value'="")) {
				Set tLen = $Length(tItem.reference.value,"/")
				Set tDocumentReferenceReference = $Piece(tItem.reference.value,"/",tLen-1,tLen)
				For j = 1:1:pBundle.entry.Count() {
					Set tBundleEntry = pBundle.entry.GetAt(j)
					Set tFullUrl = tBundleEntry.fullUrl.value
					Set tLen = $Length(tFullUrl, "/")
					If $Piece(tFullUrl, "/", tLen-1, tLen)=tDocumentReferenceReference {
						For k = 1:1:tBundleEntry.resource.DocumentReference.identifier.Count() {
							Set tIdentifier = tBundleEntry.resource.DocumentReference.identifier.GetAt(k)
							If (tIdentifier.use.value="official")&&(##class(HS.HC.Util).IsUUID(tIdentifier.value.value)) {
								Set tDocumentEntryUUID = tIdentifier.value.value
								If $Extract(tDocumentEntryUUID,1,9)'="urn:uuid:" {
									Set tDocumentEntryUUID = "urn:uuid:"_tDocumentEntryUUID
								}
							}
						}
					}
				}
			} ElseIf ##class(HS.HC.Util).IsUUID(tItem.display.value) {
				Set tDocumentEntryUUID = tItem.display.value
				If $Extract(tDocumentEntryUUID,1,9)'="urn:uuid:" {
					Set tDocumentEntryUUID = "urn:uuid:"_tDocumentEntryUUID
				}
			}
			
			If tDocumentEntryUUID'="" {
				Set tAssociation = ##class(HS.Message.IHE.XDSb.Association).%New()
				Set tAssociation.Type = "HasMember"
				Set tAssociation.ParentUUID = tFolderEntryUUID
				Set tAssociation.ChildUUID = tDocumentEntryUUID
				Set tSC = pAssociations.Insert(tAssociation)
				If $$$ISERR(tSC) Quit
			}			
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// GetPatIdentifierFromResource returns a PatientId or SourcePatientId
/// from the the specified Patient resource.
Method GetPatIdentifierFromResource(pPatientResource As HS.FHIR.vSTU3.Model.Resource.Patient, pSourceOID As %String = "") As %String
{
	// pSourceOID blank implies get PatientId
	// pSourceOID not blank implies get SourcePatientId
	
	Set tReturnIdentifier = ""
	
	Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(..AffinityDomain, "")
	
	For i = 1:1:pPatientResource.identifier.Count() {
		Set tIdentifier = pPatientResource.identifier.GetAt(i)
		Set tSystem = tIdentifier.system.value
		Set tSystemOID = ""
		If $Extract(tSystem,1,8)="urn:oid:" {
			Set tSystemOID = $Extract(tSystem,9,*)
		} ElseIf ##class(HS.HC.Util).IsOID(tSystem) {
			Set tSystemOID = tSystem
		} ElseIf $Extract(tSystem,1,4)="http" {
			Set tSystemOID = ##class(HS.Data.OIDMap).GetOIDForURL(tSystem)
		}
		If pPatientResource.identifier.Count()=1 {
			Set tReturnIdentifier = tIdentifier.value.value_"^^^&"_tSystemOID_"&ISO"
			Quit
		}
		If (pSourceOID="")&&(tSystemOID=tAffinityDomainOID) {
			Set tReturnIdentifier = tIdentifier.value.value_"^^^&"_tSystemOID_"&ISO"
			Quit
		} ElseIf (pSourceOID'="")&&(tSystemOID=pSourceOID) {
			Set tReturnIdentifier = tIdentifier.value.value_"^^^&"_tSystemOID_"&ISO"
			Quit
		} Else {
			If $i(tIdentifiers) Set tIdentifiers(tIdentifiers) = tIdentifier.value.value_"^^^&"_tSystemOID_"&ISO"
		}
	}
	
	If (tReturnIdentifier="")&&($Data(tIdentifiers(1))) Set tReturnIdentifier = tIdentifiers(1)
	
	Quit tReturnIdentifier
}

Method GetAuthorNameFromReference(pBundle As HS.FHIR.vSTU3.Model.Resource.Bundle, ByRef pBundleIndex As %String, pResource As HS.FHIR.vSTU3.Model.Base.DomainResource, ByRef pName As %String) As %Status
{
	Set tSC = $$$OK
	
	// The name, if returned, is in format ^LastName^FirstName^^^
	Set pName = ""
	
	Try {
		$$$HSTRACE("Resource type with author property", "pResource.%ClassName(0)", pResource.%ClassName(0))
		
		If '$IsObject(pResource.author) Quit
		
		If pResource.author.Count()=0 Quit
		
		Set tReference = pResource.author.GetAt(1)
		
		Set tResource = ""
		
		If (tReference.reference.value="")&&(tReference.display.value'="") {
			If $Length(tReference.display.value,"^")=6 Set pName = tReference.display.value
		} ElseIf tReference.reference.value'="" {
			If $Extract(tReference.reference.value)="#" {
				Set tSC = ##class(HS.FHIR.Utils).GetContainedResource(pResource, tReference.reference.value, "", .tResource)
				If $$$ISERR(tSC) {
					Do ..Errors.logError("value", "error", "Invalid "_pResource.%ClassName(0)_" author reference value - contained resource not found")
					Set tSC = $$$OK
					Quit
				}
			} ElseIf $Data(pBundleIndex("EntryIndexById", tReference.reference.value)) {
				Set tEntry = pBundle.entry.GetAt(pBundleIndex("EntryIndexById", tReference.reference.value))
				Set tSC = ##class(HS.FHIR.Utils).GetResourceFromContainer(tEntry.resource, .tResource)
			}
		}
		If $$$ISERR(tSC) Quit
		
		If $IsObject(tResource) {
			If tResource.%ClassName(0)="RelatedPerson" {
				If $IsObject(tResource.name) {
					Set pName = "^^^^^"
					If tResource.name.family.value'="" Set $Piece(pName,"^",2) = tResource.name.family.value
					If tResource.name.given.Count()>0 Set $Piece(pName,"^",3) = tResource.name.given.GetAt(1).value
				}
			} ElseIf (tResource.%ClassName(0)="Patient")||(tResource.%ClassName(0)="Practitioner") {
				If $IsObject(tResource.name)&&(tResource.name.Count()>0) {
					Set pName = "^^^^^"
					If tResource.name.GetAt(1).family.value'="" Set $Piece(pName,"^",2) = tResource.name.GetAt(1).family.value
					If tResource.name.GetAt(1).given.Count()>0 Set $Piece(pName,"^",3) = tResource.name.GetAt(1).given.GetAt(1).value
				}
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method GetAuthorSpecialtySlotFromRef(pBundle As HS.FHIR.vSTU3.Model.Resource.Bundle, ByRef pBundleIndex As %String, pResource As HS.FHIR.vSTU3.Model.Base.DomainResource, ByRef pSlot As HS.Types.IHE.XDSb.Slot) As %Status
{
	Set tSC = $$$OK
	
	Set pSlot = ""
	
	Try {
		$$$HSTRACE("Resource type with author property", "pResource.%ClassName(0)", pResource.%ClassName(0))
		
		If '$IsObject(pResource.author) Quit
		
		If pResource.author.Count()=0 Quit
		
		For i = 1:1:pResource.author.Count() {
		
			Set tReference = pResource.author.GetAt(i)
			
			Set tResource = ""
			
			If (tReference.reference.value="")&&(tReference.display.value'="") {
				If tReference.display.value'="" {
					If '$IsObject(pSlot) {
						Set pSlot = ##class(HS.Types.IHE.XDSb.Slot).%New()
						Set pSlot.Name = "authorSpecialty"
					}
					Set tSlotValue = ##class(HS.Types.IHE.XDSb.SlotValue).%New()
					Set tSlotValue.Value = tReference.display.value
					Do pSlot.ValueList.Insert(tSlotValue)
				}
			} ElseIf tReference.reference.value'="" {
				If $Extract(tReference.reference.value)="#" {
					Set tSC = ##class(HS.FHIR.Utils).GetContainedResource(pResource, tReference.reference.value, "", .tResource)
					If $$$ISERR(tSC) {
						Do ..Errors.logError("value", "error", "Invalid "_pResource.%ClassName(0)_" author reference value - contained resource not found")
						Set tSC = $$$OK
						Quit
					}
				} ElseIf $Data(pBundleIndex("EntryIndexById", tReference.reference.value)) {
					Set tEntry = pBundle.entry.GetAt(pBundleIndex("EntryIndexById", tReference.reference.value))
					Set tSC = ##class(HS.FHIR.Utils).GetResourceFromContainer(tEntry.resource, .tResource)
				}
			}
			If $$$ISERR(tSC) Quit
			
			If $IsObject(tResource) {
				If tResource.%ClassName(0)="Practitioner" {
					If $IsObject(tResource.qualification)&&(tResource.qualification.Count()>0) {
						For j = 1:1:tResource.qualification.Count() {
							Set tQual = tResource.qualification.GetAt(j)
							If $IsObject(tQual.code) {
								Set tText = tQual.code.text.value
								Set tCodingCount = tQual.code.coding.Count()
								For k = 1:1:tCodingCount {
									Set tSlotText = ""
									If tQual.code.coding.GetAt(k).display.value'="" {
										Set tSlotText = tQual.code.coding.GetAt(k).display.value
									} ElseIf (tCodingCount=1)&&(tText'="") {
										Set tSlotText = tText
									}
									If tSlotText'="" {
										If '$IsObject(pSlot) {
											Set pSlot = ##class(HS.Types.IHE.XDSb.Slot).%New()
											Set pSlot.Name = "authorSpecialty"
										}
										Set tSlotValue = ##class(HS.Types.IHE.XDSb.SlotValue).%New()
										Set tSlotValue.Value = tSlotText
										Do pSlot.ValueList.Insert(tSlotValue)
									}
								}
							}
						}
					}
				}
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method GetAuthorInstitutionSlotFromRef(pBundle As HS.FHIR.vSTU3.Model.Resource.Bundle, ByRef pBundleIndex As %String, pResource As HS.FHIR.vSTU3.Model.Base.DomainResource, ByRef pSlot As HS.Types.IHE.XDSb.Slot) As %Status
{
	Set tSC = $$$OK
	
	// Institution format is XON: Name^^^^^AssigningAuthority^^^^Identifier
	Set pSlot = ""
	
	Try {
		$$$HSTRACE("Resource type with author property", "pResource.%ClassName(0)", pResource.%ClassName(0))
		
		If '$IsObject(pResource.author) Quit
		
		If pResource.author.Count()=0 Quit
		
		For i = 1:1:pResource.author.Count() {
		
			Set tReference = pResource.author.GetAt(i)
			
			Set tResource = ""
			
			If (tReference.reference.value="")&&(tReference.display.value'="") {
				If $Length(tReference.display.value,"^")=10 {
					If '$IsObject(pSlot) {
						Set pSlot = ##class(HS.Types.IHE.XDSb.Slot).%New()
						Set pSlot.Name = "authorInstitution"
					}
					Set tSlotValue = ##class(HS.Types.IHE.XDSb.SlotValue).%New()
					Set tSlotValue.Value = tReference.display.value
					Do pSlot.ValueList.Insert(tSlotValue)
				}
			} ElseIf tReference.reference.value'="" {
				If $Extract(tReference.reference.value)="#" {
					Set tSC = ##class(HS.FHIR.Utils).GetContainedResource(pResource, tReference.reference.value, "", .tResource)
					If $$$ISERR(tSC) {
						Do ..Errors.logError("value", "error", "Invalid "_pResource.%ClassName(0)_" author reference value - contained resource not found")
						Set tSC = $$$OK
						Quit
					}
				} ElseIf $Data(pBundleIndex("EntryIndexById", tReference.reference.value)) {
					Set tEntry = pBundle.entry.GetAt(pBundleIndex("EntryIndexById", tReference.reference.value))
					Set tSC = ##class(HS.FHIR.Utils).GetResourceFromContainer(tEntry.resource, .tResource)
				}
			}
			If $$$ISERR(tSC) Quit
			
			If $IsObject(tResource) {
				If tResource.%ClassName(0)="Organization" {
					If tResource.name.value'="" {
						Set tIdentifierValue = ""
						Set tIdentifierAA = ""
						If $IsObject(tResource.identifier)&&(tResource.identifier.Count()>0) {
							Set tIdentifier = tResource.identifier.GetAt(1)
							If ##class(HS.HC.Util).IsOID(tIdentifier.value) {
								Set tIdentifierValue = tIdentifier.value.value
							} Else {
								If tIdentifier.system.value'="" {
									Set tIdentifierAA = "&"_tIdentifier.system.value_"&ISO"
									Set tIdentifierValue = tIdentifier.value.value
								}
							}
						}
						If '$IsObject(pSlot) {
							Set pSlot = ##class(HS.Types.IHE.XDSb.Slot).%New()
							Set pSlot.Name = "authorInstitution"
						}
						Set tSlotValue = ##class(HS.Types.IHE.XDSb.SlotValue).%New()
						Set tSlotValue.Value = tResource.name.value_"^^^^^"_tIdentifierAA_"^^^^"_tIdentifierValue
						Do pSlot.ValueList.Insert(tSlotValue)
					}
				}
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method GetAuthorTelecomSlotFromRef(pBundle As HS.FHIR.vSTU3.Model.Resource.Bundle, ByRef pBundleIndex As %String, pResource As HS.FHIR.vSTU3.Model.Base.DomainResource, ByRef pSlot As HS.Types.IHE.XDSb.Slot) As %Status
{
	Set tSC = $$$OK
	
	// Telecommunications format is XTN.
	Set pSlot = ""
	
	Try {
		$$$HSTRACE("Resource type with author property", "pResource.%ClassName(0)", pResource.%ClassName(0))
		
		If '$IsObject(pResource.author) Quit
		
		If pResource.author.Count()=0 Quit
		
		For i = 1:1:pResource.author.Count() {
			
			Set tReference = pResource.author.GetAt(i)
			
			Set tResource = ""
			
			If (tReference.reference.value="")&&(tReference.display.value'="") {
				If $Length(tReference.display.value,"^")>2 {
					If '$IsObject(pSlot) {
						Set pSlot = ##class(HS.Types.IHE.XDSb.Slot).%New()
						Set pSlot.Name = "authorTelecommunication"
					}
					Set tSlotValue = ##class(HS.Types.IHE.XDSb.SlotValue).%New()
					Set tSlotValue.Value = tReference.display.value
					Do pSlot.ValueList.Insert(tSlotValue)
				}
			} ElseIf tReference.reference.value'="" {
				If $Extract(tReference.reference.value)="#" {
					Set tSC = ##class(HS.FHIR.Utils).GetContainedResource(pResource, tReference.reference.value, "", .tResource)
					If $$$ISERR(tSC) {
						Do ..Errors.logError("value", "error", "Invalid "_pResource.%ClassName(0)_" author reference value - contained resource not found")
						Set tSC = $$$OK
						Quit
					}
				} ElseIf $Data(pBundleIndex("EntryIndexById", tReference.reference.value)) {
					Set tEntry = pBundle.entry.GetAt(pBundleIndex("EntryIndexById", tReference.reference.value))
					Set tSC = ##class(HS.FHIR.Utils).GetResourceFromContainer(tEntry.resource, .tResource)
				}
			}
			If $$$ISERR(tSC) Quit
			
			If $IsObject(tResource) {
				If tResource.%ClassName(0)="Practitioner" {
					For j = 1:1:tResource.telecom.Count() {
						Set tText = ""
						Set tSystem = tResource.telecom.GetAt(j).system.value
						If (tSystem="phone")||(tSystem="fax")||(tSystem="pager") {
							If tResource.telecom.GetAt(i).use.value'="" Set $Piece(tText,"^",2) = tResource.telecom.GetAt(i).use.value
							Set $Piece(tText,"^",3) = tSystem
							Set $Piece(tText,"^",7) = tResource.telecom.GetAt(i).value.value
						} ElseIf tSystem="email" {
							Set $Piece(tText,"^",3) = "Internet"
							Set $Piece(tText,"^",4) = tResource.telecom.GetAt(i).value.value
						}
						If tText'="" {
							If '$IsObject(pSlot) {
								Set pSlot = ##class(HS.Types.IHE.XDSb.Slot).%New()
								Set pSlot.Name = "authorTelecommunication"
							}
							Set tSlotValue = ##class(HS.Types.IHE.XDSb.SlotValue).%New()
							Set tSlotValue.Value = tText
							Do pSlot.ValueList.Insert(tSlotValue)
						}
					}
				}
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// This method takes a coded entry type (e.g., "TypeCode", "FormatCode", etc)
/// as input and returns a default CodedValue object for MHD for the type.
/// The default value is stored in the Configuration Registry.  The key name
/// is "\IHE\MHD\Default\" plus the coded type.  The value is expected to be
/// the default Code and the default Scheme, separated by caret (^).
Method GetCodedEntryDefaultValue(pCodeType As %String, ByRef pCodedValue As HS.IHE.CodedEntry) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set pCodedValue = ""
		Set tKey = "\IHE\MHD\Default\"_pCodeType
		Set tValue = ##class(HS.Registry.Config).GetKeyValue(tKey)
		If tValue'="" {
			Set tCode = $Piece(tValue, "^", 1)
			Set tScheme = $Piece(tValue, "^", 2)
			Set tDescription = $Piece(tValue, "^", 3)
			Set tStatement = ##class(%SQL.Statement).%New()
			Set tStatement.%SelectMode=2
			Set tQuery = "SELECT Description FROM HS_IHE.CodedEntry WHERE CodeType=? AND Code=? AND CodingScheme=?"
			Set tStatus = tStatement.%Prepare(tQuery)
			Set tResultSet = tStatement.%Execute(pCodeType, tCode, tScheme)
			While tResultSet.%Next() {
				Set tDescription = tResultSet.Description
			}
			Set pCodedValue = ##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode, tScheme, tDescription)
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
		
	Quit tSC
}

Method PnRResponseToMHDResponse(pOriginalRequest As HS.Message.FHIR.Request, pProvideAndRegisterResponse As HS.Message.XMLMessage, pSC As %Status, Output pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set pResponse = ##class(HS.Message.FHIR.Response).%New()
		Set pResponse.Type = "Bundle"
		Set pResponse.ContentType = pOriginalRequest.ContentType
		
		// Unconditionally create a QuickStream for the response message to use for
		// the response payload content.
		Set tResponseStream = ##class(HS.SDA3.QuickStream).%New()
		Set pResponse.QuickStreamId = tResponseStream.%Id()
		
		Set tResponseBundle = ##class(HS.FHIR.vSTU3.Model.Resource.Bundle).%New()
		Do tResponseBundle.SetType("transaction-response")
		
		#dim tRequestBundle As HS.FHIR.vSTU3.Model.Resource.Bundle
		
		Set tOriginalStream = pOriginalRequest.GetPayloadOref()
		
		Do tOriginalStream.Rewind()
		Set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR(pOriginalRequest.ContentType, tOriginalStream, .tRequestBundle, ..ResourceSchemaRoot)
		If $$$ISERR(tSC) Quit
		
		// status
		// urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success
		// urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure
		
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pProvideAndRegisterResponse.ContentStream,"//rs:RegistryResponse","@status",.tStatus,.tDocObject)
		
		If $Piece($Get(tStatus),":",$Length(tStatus,":"))="Failure" {
			For i = 1:1 {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(pProvideAndRegisterResponse.ContentStream,"//rs:RegistryResponse/rs:RegistryErrorList/rs:RegistryError["_i_"]","@codeContext",.tCodeContext,.tDocObject)
				If $$$ISERR(tSC) Set tSC = $$$OK Quit
				If $Get(tCodeContext)="" Quit
				Do ..Errors.logError("invalid", "error", tCodeContext, , , , tCodeContext)
			}
			Quit
		}
		
		// After this point, we can assume that the XDSb Provide and Register was successfull.
		
		Set tIssueSuccess = ##class(HS.FHIR.vSTU3.Model.Resource.OperationOutcome.Issue).%New()
		Do tIssueSuccess.SetSeverity("information")
		Do tIssueSuccess.SetCode("informational")
		Do tIssueSuccess.SetDetails( , "Create was successful", , "Create was successful")
		
		// Either the whole thing succeeded or it didn't.
		If ..Errors.Errors.Count()=0 {
			// MHD Revision 2.3 section 3.65.4.2.2 Message Semantics wants response outcome
			// populated with OperationOutcome for ALL response objects, even when transaction
			// success.
			For i = 1:1:tRequestBundle.entry.Count() {
				Set tRequestEntry = tRequestBundle.entry.GetAt(i)
				Set tResponseEntry = ##class(HS.FHIR.vSTU3.Model.Resource.Bundle.Entry).%New()
				Set tResponseResponse = ##class(HS.FHIR.vSTU3.Model.Resource.Bundle.Response).%New()
				Set tHttpStatusString = ""
				Set tSC = ##class(HS.FHIR.Helper).LookupHTTPStatusText(201, .tHttpStatusString)
				If tHttpStatusString'="" Set tHttpStatusString = " "_tHttpStatusString
				Do tResponseResponse.SetStatus("201"_tHttpStatusString)
				Set tOperationOutcomeObj = ##class(HS.FHIR.vSTU3.Model.Resource.OperationOutcome).%New()
				Do tOperationOutcomeObj.issue.Insert(tIssueSuccess)
				
				Do tResponseResponse.SetOutcome(tOperationOutcomeObj)
				Set tResponseEntry.response = tResponseResponse
				Do tResponseBundle.entry.Insert(tResponseEntry)
			}
			Set pResponse.Status = 200
		} Else {
			Set tFHIRErrors = ##class(HS.Types.FHIR.Errors).%New()
			For i = 1:1:..Errors.Errors.Count() {
				Set tLocation = ""
				If ..Errors.Errors.GetAt(i).Location'="" Set tLocation = "/f:Bundle/f:entry["_..Errors.Errors.GetAt(i).Location_"]"
				Do tFHIRErrors.logError(..Errors.Errors.GetAt(i).Code, $ZConvert(..Errors.Errors.GetAt(i).Severity,"L"), ..Errors.Errors.GetAt(i).Description, tLocation)
			}
			If ..Errors.HighestError'="error" {
				Set pResponse.Status = 200
				// Map errors to entries
				For i = 1:1:..Errors.Errors.Count() {
					If ..Errors.Errors.GetAt(i).Location?1N.N {
						// tLocationIndex(BundleEntryIndex) = ErrorEntryIndex
						Set tLocationIndex(..Errors.Errors.GetAt(i).Location)=i
					}
				}
				// Since ..Errors is populated but none is Error then assume that they are all warnings.
				For i = 1:1:tRequestBundle.entry.Count() {
					Set tRequestEntry = tRequestBundle.entry.GetAt(i)
					Set tResponseEntry = ##class(HS.FHIR.vSTU3.Model.Resource.Bundle.Entry).%New()
					Set tResponseResponse = ##class(HS.FHIR.vSTU3.Model.Resource.Bundle.Response).%New()
					Set tHttpStatusString = ""
					Set tSC = ##class(HS.FHIR.Helper).LookupHTTPStatusText(201, .tHttpStatusString)
					If tHttpStatusString'="" Set tHttpStatusString = " "_tHttpStatusString
					Do tResponseResponse.SetStatus("201"_tHttpStatusString)
					Set tOperationOutcomeObj = ##class(HS.FHIR.vSTU3.Model.Resource.OperationOutcome).%New()
					
					If $Data(tLocationIndex(i)) {
						Set tIssue = ##class(HS.FHIR.vSTU3.Model.Resource.OperationOutcome.Issue).%New()
						Do tIssue.SetSeverity($ZConvert(..Errors.Errors.GetAt(tLocationIndex(i)).Severity,"L"))
						Do tIssue.SetCode($ZConvert(..Errors.Errors.GetAt(tLocationIndex(i)).Code,"L"))
						Set tDesc = ..Errors.Errors.GetAt(tLocationIndex(i)).Description
						Set tDetailsCode = ""
						If tDesc="PartialFolderContentNotProcessed" {
							Set tHttpStatusString = ""
							Set tSC = ##class(HS.FHIR.Helper).LookupHTTPStatusText(200, .tHttpStatusString)
							If tHttpStatusString'="" Set tHttpStatusString = " "_tHttpStatusString
							Do tResponseResponse.SetStatus("200"_tHttpStatusString)
						} ElseIf ($Extract(tDesc,1,7)="Partial")&&($Extract(tDesc,*-18,*)="ContentNotProcessed") {
							Do tOperationOutcomeObj.issue.Insert(tIssueSuccess)
							Set tDetailsCode = tDesc
						}
						Do tIssue.SetDetails(tDetailsCode, tDesc, , tDesc)
						Do tOperationOutcomeObj.issue.Insert(tIssue)
					} Else {
						Do tOperationOutcomeObj.issue.Insert(tIssueSuccess)
					}
					Do tResponseResponse.SetOutcome(tOperationOutcomeObj)
					Set tResponseEntry.response = tResponseResponse
					Do tResponseBundle.entry.Insert(tResponseEntry)
				}
			} Else {
				Set tSC = tFHIRErrors.GenerateOperationOutcomeObj(..ResourceSchemaRoot,.tResponseBundle)
				If $$$ISERR(tSC) Quit
				If 'tException {
					Set tHttpStatusString = ""
					Set tSC = ##class(HS.FHIR.Helper).LookupHTTPStatusText(400, .tHttpStatusString)
					If tHttpStatusString'="" Set tHttpStatusString = " "_tHttpStatusString
					Set pResponse.Status = "400"_tHttpStatusString
				} Else {
					Set tHttpStatusString = ""
					Set tSC = ##class(HS.FHIR.Helper).LookupHTTPStatusText(500, .tHttpStatusString)
					If tHttpStatusString'="" Set tHttpStatusString = " "_tHttpStatusString
					Set pResponse.Status = "500"_tHttpStatusString
				}
			}
		}
		
		Do ..Errors.Errors.Clear()
		
		Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(pOriginalRequest.ContentType, tResponseBundle, .tResponseStream, pOriginalRequest.FormatFHIROutput)
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method ProcessFHIRResponse(pFHIRResponseIn As HS.Message.FHIR.Response, Output pFHIRResponseOut As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If ..CustomProcessor="" {
			Set pFHIRResponseOut = pFHIRResponseIn.%ConstructClone(1)
			Quit
		}
		
		$$$OnPost(pFHIRResponseIn, .pFHIRResponseOut)
		If $$$ISERR(tSC) Quit
		
		If '$IsObject($Get(pFHIRResponseOut)) {
			Set pFHIRResponseOut = pFHIRResponseIn.%ConstructClone(1)
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

Method ProcessMetadataRequest(pRequest As HS.Message.FHIR.Request, pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tResourceId = pRequest.AdditionalInfo.GetAt("CapabilityStatementId")
		If tResourceId="" {
			Set tSC = $$$ERROR($$$GeneralError, "CapabilityStatement resource id not specified")
			Quit
		}
		Set tXDataName = "ISCMHDDocumentRecipient"
		
		Set tSC = pRequest.NewResponse(.pResponse)
		If $$$ISERR(tSC) Quit
		
		Set pResponse.ContentType = pRequest.ContentType
		
		// Unconditionally create a QuickStream for the response message to use for
		// the response payload content.
		Set tResponseStream = ##class(HS.SDA3.QuickStream).%New()
		Set pResponse.QuickStreamId = tResponseStream.%Id()
		
		Set tSC = ##class(HS.FHIR.Utils).GetCapabilityStatementFromXData(pRequest.ContentType, tXDataName, ..%ClassName(1), ..ResourceSchemaRoot, tResourceId, pRequest.BaseURL, pRequest.AdditionalInfo.GetAt("OAuthClient"), ('pRequest.AdditionalInfo.GetAt("DisableCORS")=1), pRequest.FormatFHIROutput, .tResponseStream)
		If $$$ISERR(tSC) Quit
		
		If $$$HSTRACING {
			If pResponse.QuickStreamId'="" {
				Set tQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(pResponse.QuickStreamId)
				$$$HSTRACE("FHIR response message to be returned", "pResponse,tQuickStream", pResponse, tQuickStream)
			} Else {
				$$$HSTRACE("FHIR response message to be returned", "pResponse", pResponse)
			}
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

XData ISCMHDDocumentRecipient
{
<CapabilityStatement xmlns="http://hl7.org/fhir">
  <placeholder>resource_id</placeholder>
  <text>
    <status value="additional" />
    <div xmlns="http://www.w3.org/1999/xhtml">
	InterSystems instance of CapabilityStatement for Document Recipient Actor in the 
    IHE IT Infrastructure Technical Framework Supplement <a href="http://wiki.ihe.net/index.php/Mobile_access_to_Health_Documents_(MHD)">Mobile access to Health Documents (MHD) Rev. 2.3</a></div>
  </text>
  <placeholder>url</placeholder>
  <name value="ISC.MHD.DocumentRecipient" />
  <title value="IHE ITI Mobile access to Health Documents (MHD) - InterSystems Document Recipient" />
  <status value="draft" />
  <experimental value="false" />
  <date value="2018-03-19" />
  <publisher value="InterSystems Corporation" />
  <description value="see http://wiki.ihe.net/index.php/Mobile_access_to_Health_Documents_(MHD)" />
  <jurisdiction>
    <coding>
      <system value="http://unstats.un.org/unsd/methods/m49/m49.htm" />
      <code value="001" />
    </coding>
  </jurisdiction>
  <kind value="instance" />
  <instantiates value="https://simplifier.net/IHEPatientDemographi/IHEMHDDocumentRecipient" />
  <placeholder>software</placeholder>
  <implementation>
    <description value="InterSystems MHD Document Recipient"/>
    <placeholder>implementation_url</placeholder>
  </implementation>
  <fhirVersion value="3.0.1" />
  <acceptUnknown value="no" />
  <format value="xml" />
  <format value="application/fhir+xml" />
  <format value="json" />
  <format value="application/fhir+json" />
  <rest>
    <mode value="server" />
    <security>
      <placeholder>security_oauth_uris_extension</placeholder>
      <placeholder>security_cors</placeholder>
      <placeholder>security_service</placeholder>
    </security>
    <resource>
      <type value="CapabilityStatement" />
      <interaction>
        <code value="read" />
      </interaction>
    </resource>
    <interaction>
      <code value="transaction" />
      <documentation value="http://ihe.net/fhir/StructureDefinition/IHE.MHD.ProvideDocumentBundle.Comprehensive" />
    </interaction>
  </rest>
</CapabilityStatement>
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>CustomProcessor</Value>
</Value>
<Value name="2">
<Value>CustomProcessorIsValid</Value>
</Value>
<Value name="3">
<Value>Errors</Value>
</Value>
<Value name="4">
<Value>RepositoryOID</Value>
</Value>
<Value name="5">
<Value>AffinityDomain</Value>
</Value>
<Value name="6">
<Value>ResourceSchemaRoot</Value>
</Value>
<Value name="7">
<Value>ProvideTarget</Value>
</Value>
<Value name="8">
<Value>TraceOperations</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
