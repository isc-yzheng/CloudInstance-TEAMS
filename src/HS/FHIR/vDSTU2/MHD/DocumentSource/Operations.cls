/// IHE MHD Document Source Actor
/// This business operation takes a HealthShare ProvideAndRegisterRequest
/// message as input, creates a FHIR based IHE MHD Provide Document Bundle
/// request, and forwards it to HS.FHIR.REST.Operation.
Class HS.FHIR.vDSTU2.MHD.DocumentSource.Operations Extends (HS.FHIR.REST.Operation, HS.HC.Util.Trace.Helper) [ Inheritance = right, ProcedureBlock ]
{

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "ServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItemsByParam?Type=HTTP},FHIRFormat,FormatFHIROutput";

/// The service name found in HS.Registry.Service.*
Property ServiceName As %String(MAXLEN = 512);

/// Caches Service Registry information for the currently selected service.<br>
/// Format:<br>
/// <li>$List position 1  : Service Name
/// <li>$List position 2  : Service %Id
/// <li>$List position 3  : Device OID
/// <li>$List position 4  : Assigning Authority
/// <li>$List position 5  : Receiving Application
/// <li>$List position 6  : Receiving Facility
/// <li>$List position 7  : Host
/// <li>$List position 8  : Port
/// <li>$List position 9  : StayConnected
/// <li>$List position 10 : SSL Config
/// <li>$List position 11 : URL
Property RegistryService As %String;

/// The FHIR format to use for the request ContentType and Accept headers.
/// This setting may be overridden on a per-request basis by adding an
/// AdditionalInfoItem named "_format" to the PatientSearchRequest.  Valid
/// values for _format item are: "xml", "json", "application/xml+fhir",
/// "application/json+fhir", "application/fhir+xml" and "application/fhir+json".
Property FHIRFormat As %String(DISPLAYLIST = ",XML,JSON", VALUELIST = ",XML,JSON") [ InitialExpression = "XML" ];

/// Value of true for this setting causes any created FHIR payload
/// to include indentation and line feed characters to enhance
/// readability of the raw content.
Property FormatFHIROutput As %Boolean [ InitialExpression = 0 ];

Property ResourceIdIndex As %Integer [ InitialExpression = 0 ];

XData MessageMap
{
<MapItems>
  <MapItem MessageType="HS.Message.IHE.XDSb.ProvideAndRegisterRequest">
  	<Method>MHDProvideDocumentBundle</Method>
  </MapItem>
</MapItems>
}

Method OnMessage(pRequest As HS.Message.FHIR.Request, Output pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If pRequest.%IsA("HS.Message.FHIR.Request") {
			$$$HSTRACE("FHIR Request", "pRequest", pRequest)
			If (pRequest.Interaction = "transaction") {
				Set tSC = ..FHIRRequest(pRequest, .pResponse)
			} Else {
				Set tSC = $$$ERROR($$$GeneralError, "Request type not handled:  " _ pRequest.Type) Quit
			}
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Message class "_pRequest.%ClassName(1)_" not handled")
		}
		
		If $IsObject($Get(pResponse)) $$$HSTRACE("FHIR Response", "pResponse", pResponse)
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

Method MHDProvideDocumentBundle(pRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest, ByRef pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#dim tMHDPnRRequest As HS.Message.FHIR.Request
		#dim tMHDPnRResponse As HS.Message.FHIR.Response
		
		Set ..ResourceIdIndex = 0
		
		Set tSC = ..XDSbPnRRequestToMHDRequest(pRequest, .tMHDQueryRequest)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..OnMessage(tMHDQueryRequest, .tMHDQueryResponse)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..MHDPnRResponseToXMLMessage(tMHDQueryResponse, .pResponse)
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method XDSbPnRRequestToMHDRequest(pXDSbRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest, ByRef pMHDRequest As HS.Message.FHIR.Request) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Update the cached service entry data If needed.
		Set tServiceName = pXDSbRequest.AdditionalInfo.GetAt("ServiceName")
		Set:tServiceName="" tServiceName = ..ServiceName
		Do ..UpdateRegistryService(tServiceName)
		
		Set tBaseURLHttp = $Select($ListGet(..RegistryService,10)'="":"https://",1:"http://")
		Set tBaseURLPort = $Select($ListGet(..RegistryService,8)'="":":"_$ListGet(..RegistryService,8),1:"")
		Set tBaseURL = tBaseURLHttp_$ListGet(..RegistryService,7)_tBaseURLPort_$ListGet(..RegistryService,11)
		
		#; For MHD DocumentSource the Patient Id must be explicity specified,
		#; we are not going to try to figure it out from the attached document.
		Set:pXDSbRequest.SourcePatientId="" pXDSbRequest.SourcePatientId=pXDSbRequest.PatientId
		If pXDSbRequest.PatientId="" Set tSC=$$$ERROR($$$GeneralError,"Unknown patient ID") Quit
		
		#dim tUpdatedRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest
		
		Set tSC =..GetUpdatedProvideRequest(pXDSbRequest, .tUpdatedRequest)
		$$$HSTRACE("patientid and tsc", "patientid,tSC,", pXDSbRequest.PatientId, tSC)
		Quit:$$$ISERR(tSC)
		
		Set tPatientResourceUrl = tUpdatedRequest.AdditionalInfo.GetAt("ResourceUrl")
		If $Extract(tPatientResourceUrl, *)="/" Set tPatientResourceUrl = $Extract(tPatientResourceUrl, 1, *-1)
		Set tPatientResourceId = $Piece(tPatientResourceUrl,"/",$Length(tPatientResourceUrl,"/"))
		
		#; convert message to MHD FHIR Provide Document Bundle
		
		Set pMHDRequest = ##class(HS.Message.FHIR.Request).%New()
		
		Do pMHDRequest.AdditionalInfo.SetAt(tServiceName, "ServiceName")
		
		Set pMHDRequest.BaseURL = tBaseURL
		
		Set tFormat = $ZConvert(pXDSbRequest.AdditionalInfo.GetAt("_format"),"L")
		If tFormat="xml" {
			Do pMHDRequest.SetParameter("_format", tFormat)
			Set pMHDRequest.ContentType = "application/xml+fhir"
		} ElseIf tFormat="json" {
			Do pMHDRequest.SetParameter("_format", tFormat)
			Set pMHDRequest.ContentType = "application/json+fhir"
		} ElseIf tFormat'="" {
			Do ##class(HS.FHIR.Utils).GetValidFormats("Parameter", .tFormats)
			If '$Data(tFormats(tFormat)) Set tSC = $$$ERROR($$$GeneralError, "Invalid _format value "_tFormat_" specified") $$$ThrowOnError(tSC)
			Do pMHDRequest.SetParameter("_format", tFormat)
			Set pMHDRequest.ContentType = tFormat
		} Else {
			Do ##class(HS.FHIR.Utils).GetValidFormats("Accept", .tFormats)
			If $ZConvert(..FHIRFormat, "L")="xml" {
				Set pMHDRequest.ContentType = "application/xml+fhir"
			} Else {
				Set pMHDRequest.ContentType = "application/json+fhir"
			}
		}
		
		Set pMHDRequest.Interaction = "transaction"
		
		Set tNowDH = $Horolog
		Set tNowInstant = $ZDateTime(tNowDH, 3, 5)
		
		Set tPracticionerCount = 0
		
		Set tBundle = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle).%New()
		Do tBundle.SetType("transaction")
		
		#; Construct a Patient resource.  It will be used as the contained Patient for
		#; sourcePatientInfo.  It may also be used for a Bundle entry Patient resource,
		#; if we want to have DocumentManifest.subject and DocumentReference.subject
		#; pointing to a Bundle entry, as opposed to a Patient on a server.
		Set tPatient = ##class(HS.FHIR.vDSTU2.Model.Resource.Patient).%New()
		
		Set tMPIID = $Piece(tUpdatedRequest.PatientId,"^",1)
		Set tSC = tPatient.SetId(tPatientResourceId)
		
		Set tSystemOID = $Piece($Piece(tUpdatedRequest.PatientId,"^",4),"&",2)
		Set tSystemURL = ##class(HS.Data.OIDMap).GetURLForOID(tSystemOID)
		If (tSystemURL'="")&&(tSystemURL'=tSystemOID) {
			Set tSystem = tSystemURL
		} Else {
			Set tSystem = "urn:oid:"_tSystemOID
		}
		Set tSC = tPatient.SetIdentifier(tMPIID, tSystem, "official", , , , "MPIID")
		
		Set tMRN = $Piece(tUpdatedRequest.Documents.GetAt(1).SourcePatientId,"^",1)
		Set tSystemOID = $Piece($Piece(tUpdatedRequest.Documents.GetAt(1).SourcePatientId,"^",4),"&",2)
		Set tSystemURL = ##class(HS.Data.OIDMap).GetURLForOID(tSystemOID)
		If (tSystemURL'="")&&(tSystemURL'=tSystemOID) {
			Set tSystem = tSystemURL
		} Else {
			Set tSystem = "urn:oid:"_tSystemOID
		}
		Set tSC = tPatient.SetIdentifier(tMRN, tSystem, "usual", , , , "MR")
		#; END constructing Patient
		
		#; Add the Bundle entry for Patient only if the specified Patient
		#; resource URL indicates a reference within the Bundle.
		If $Extract(tPatientResourceUrl,1,8)="Patient/" {
			Set tEntryRequest = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Request).%New()
			Do tEntryRequest.SetMethod("POST")
			Do tEntryRequest.SetUrl("Patient")
			Set tBundleEntry = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Entry).%New()
			Set tSC = tBundleEntry.SetFullUrl(tPatientResourceUrl) Quit:$$$ISERR(tSC)
			Set tSC = tBundleEntry.SetResource(tPatient) Quit:$$$ISERR(tSC)
			Set tBundleEntry.request = tEntryRequest
			Do tBundle.entry.Insert(tBundleEntry)
		}
		
		Set tMeta = ##class(HS.FHIR.vDSTU2.Model.Base.Meta).%New()
		Set tSC = tMeta.SetProfile("http://ihe.net/fhir/tag/iti-65") Quit:$$$ISERR(tSC)
		Set tBundle.meta = tMeta
		
		Set tDocumentManifest = ##class(HS.FHIR.vDSTU2.Model.Resource.DocumentManifest).%New()
		Set tDocumentManifestUrl = ..GetTransactionFullUrl("DocumentManifest")
		Set tSC = tDocumentManifest.SetMasterIdentifier("urn:oid:"_tUpdatedRequest.UniqueId, "urn:ietf:rfc:3986") Quit:$$$ISERR(tSC)
		Set tSC = tDocumentManifest.SetIdentifier("urn:uuid:"_tUpdatedRequest.EntryUUID, "urn:ietf:rfc:3986", "official", , , , "EntryUUID") Quit:$$$ISERR(tSC)
		
		Set tSC = tDocumentManifest.SetSubject(tPatientResourceUrl) Quit:$$$ISERR(tSC)
		
		Set tSystem = ..GetCodeSystem("contentTypeCode", tUpdatedRequest.ContentTypeCode.Scheme, tUpdatedRequest.ContentTypeCode.Code)
		Set tSC = tDocumentManifest.SetType(tUpdatedRequest.ContentTypeCode.Code, tUpdatedRequest.ContentTypeCode.Description, tSystem, tUpdatedRequest.ContentTypeCode.Description) Quit:$$$ISERR(tSC)
		
		Set tPractitioner = ##class(HS.FHIR.vDSTU2.Model.Resource.Practitioner).%New()
		Set tSC = tPractitioner.SetName($Piece(tUpdatedRequest.Author.GetAt(1).AuthorPerson,"^",2),$Piece(tUpdatedRequest.Author.GetAt(1).AuthorPerson,"^",3),$Piece(tUpdatedRequest.Author.GetAt(1).AuthorPerson,"^",4))
		Set ..ResourceIdIndex = ..ResourceIdIndex + 1
		Set tSC = tPractitioner.SetId("practitioner-"_..ResourceIdIndex) Quit:$$$ISERR(tSC)
		Set tSC = tDocumentManifest.SetContained(tPractitioner) Quit:$$$ISERR(tSC)
		Set tSC = tDocumentManifest.SetAuthor("#practitioner-"_..ResourceIdIndex, tUpdatedRequest.Author.GetAt(1).AuthorPerson) Quit:$$$ISERR(tSC)
		
		Set tCreated = tNowInstant
		Set tSC = tDocumentManifest.SetCreated(tCreated) Quit:$$$ISERR(tSC)
		If $Extract($ZConvert(tUpdatedRequest.SourceId,"L"),1,8)'="urn:oid:" {
			Set tSC = tDocumentManifest.SetSource("urn:oid:"_tUpdatedRequest.SourceId) Quit:$$$ISERR(tSC)
		} Else {
			Set tSC = tDocumentManifest.SetSource(tUpdatedRequest.SourceId) Quit:$$$ISERR(tSC)
		}
		Set tSC = tDocumentManifest.SetStatus("current")
		Set tSC = tDocumentManifest.SetDescription(tUpdatedRequest.Title) Quit:$$$ISERR(tSC)
		
		Set tEntryRequest = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Request).%New()
		Do tEntryRequest.SetMethod("POST")
		Do tEntryRequest.SetUrl("DocumentManifest")
		Set tBundleEntry = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Entry).%New()
		Set tSC = tBundleEntry.SetFullUrl(tDocumentManifestUrl) Quit:$$$ISERR(tSC)
		Set tSC = tBundleEntry.SetResource(tDocumentManifest) Quit:$$$ISERR(tSC)
		Set tBundleEntry.request = tEntryRequest
		Do tBundle.entry.Insert(tBundleEntry)
		
		#dim tDocument As HS.Message.IHE.XDSb.Document
		For i = 1:1:tUpdatedRequest.Documents.Count() {
			Set tDocument = tUpdatedRequest.Documents.GetAt(i)
			Set tDocumentReference = ##class(HS.FHIR.vDSTU2.Model.Resource.DocumentReference).%New()
			If tDocument.EntryUUID="" Set tDocument.EntryUUID="urn:uuid:"_$ZConvert($system.Util.CreateGUID(),"L")
			Set tSC = tDocumentReference.SetIdentifier(tDocument.EntryUUID,"urn:ietf:rfc:3986","official",,,,"EntryUUID") Quit:$$$ISERR(tSC)
			Set tDocumentReferenceUrl = ..GetTransactionFullUrl("DocumentReference")
			Set tContent = ##class(HS.FHIR.vDSTU2.Model.Resource.DocumentManifest.Content).%New()
			Set tSC = tContent.SetPReference(tDocumentReferenceUrl)
			Set tSC = tDocumentReference.SetDescription(tDocument.Title)
			Do tDocumentManifest.content.Insert(tContent)
			Set tPractitioner = ##class(HS.FHIR.vDSTU2.Model.Resource.Practitioner).%New()
			Set ..ResourceIdIndex = ..ResourceIdIndex + 1
			Set tSC = tPractitioner.SetId("practitioner-"_..ResourceIdIndex) Quit:$$$ISERR(tSC)
			Set tSC = tPractitioner.SetName($Piece(tDocument.Author.GetAt(1).AuthorPerson,"^",2),$Piece(tDocument.Author.GetAt(1).AuthorPerson,"^",3),$Piece(tDocument.Author.GetAt(1).AuthorPerson,"^",4)) Quit:$$$ISERR(tSC)
			Set tSC = tDocumentReference.SetContained(tPractitioner) Quit:$$$ISERR(tSC)
			Set tSC = tDocumentReference.SetAuthor("#practitioner-"_..ResourceIdIndex, tDocument.Author.GetAt(1).AuthorPerson) Quit:$$$ISERR(tSC)
			Set tSC = tDocumentReference.SetMasterIdentifier("urn:oid:"_tDocument.UniqueId, "urn:ietf:rfc:3986") Quit:$$$ISERR(tSC)
			
			Set tCode = tDocument.TypeCode.Code
			Set tDescription = tDocument.TypeCode.Description
			Set tScheme = tDocument.TypeCode.Scheme
			Set tSystem = ..GetCodeSystem("typeCode", tScheme, tCode, tScheme)
			Set tSC = tDocumentReference.SetType(tCode, tDescription, tSystem, tDescription) Quit:$$$ISERR(tSC)
			
			Set tCode = tDocument.ClassCode.Code
			Set tDescription = tDocument.ClassCode.Description
			Set tScheme = tDocument.ClassCode.Scheme
			Set tSystem = ..GetCodeSystem("classCode", tScheme, tCode, tScheme)
			Set tSC = tDocumentReference.SetClass(tCode, tDescription, tSystem, tDescription) Quit:$$$ISERR(tSC)
			
			#; tDocument.CreationTime is expected to be an HL7 DTM format YYYYMMDDHHMMSS, in UTC.
			Set tCreationTime = tDocument.CreationTime
			If tCreationTime'="" {
				#; Convert to FHIR instant format, in the local time zone.
				Set tCreationTime = ##class(HS.FHIR.Utils).V2ToFHIRInstant(tCreationTime,1,1)
				Set tSC = tDocumentReference.SetIndexed(tCreationTime) Quit:$$$ISERR(tSC)
			} Else {
				Set tSC = tDocumentReference.SetIndexed(tNowInstant) Quit:$$$ISERR(tSC)
			}
			Set tSC = tDocumentReference.SetStatus($Case(tDocument.AvailabilityStatus, "Approved":"current", "Deprecated":"superseded", :"current")) Quit:$$$ISERR(tSC)
			
			Set tContext = ##class(HS.FHIR.vDSTU2.Model.Resource.DocumentReference.Context).%New()
			
			Set tCode = tDocument.HealthcareFacilityTypeCode.Code
			Set tDescription = tDocument.HealthcareFacilityTypeCode.Description
			Set tScheme = tDocument.HealthcareFacilityTypeCode.Scheme
			Set tSystem = ..GetCodeSystem("healthcareFacilityTypeCode", tScheme, tCode, tScheme)
			Set tSC = tContext.SetFacilityType(tCode, tDescription, tSystem, tDescription) Quit:$$$ISERR(tSC)
			
			Set tCode = tDocument.PracticeSettingCode.Code
			Set tDescription = tDocument.PracticeSettingCode.Description
			Set tScheme = tDocument.PracticeSettingCode.Scheme
			Set tSystem = ..GetCodeSystem("practiceSettingCode", tScheme, tCode, tScheme)
			Set tSC = tContext.SetPracticeSetting(tCode, tDescription, tSystem, tDescription) Quit:$$$ISERR(tSC)
			
			#; MHD requires sourcePatientInfo to refer to a contained Patient resource.
			Set tContainedPatient = tPatient.%ConstructClone(1)
			Set ..ResourceIdIndex = ..ResourceIdIndex + 1
			Set tSC = tContainedPatient.SetId("patient-"_..ResourceIdIndex)
			Set tSC = tContext.SetSourcePatientInfo("#patient-"_..ResourceIdIndex)
			Set tSC = tDocumentReference.SetSubject(tPatientResourceUrl) Quit:$$$ISERR(tSC)
			Set tSC = tDocumentReference.SetContained(tContainedPatient)
			#dim tSlot As HS.IHE.XDSb.Types.Slot
			If tDocument.DocumentSlots.Count()>0 {
				Set tHasRefIdList = 0
				For j = 1:1:tDocument.DocumentSlots.Count() {
					If tDocument.DocumentSlots.GetAt(j).Name="urn:ihe:iti:xds:2013:referenceIdList" {
						Set tHasRefIdList = 1
						Quit
					}
				}
				If tHasRefIdList {
					For j = 1:1:tDocument.DocumentSlots.Count() {
						Set tSlot = tDocument.DocumentSlots.GetAt(j)
						If tSlot.Name="urn:ihe:iti:xds:2013:referenceIdList" {
							For m = 1:1:tSlot.ValueList.Count() {
								Set tRelated = ##class(HS.FHIR.vDSTU2.Model.Resource.DocumentReference.Related).%New()
								Set tSlotValue = tSlot.ValueList.GetAt(m).Value
								Set tSlotType = $Piece(tSlotValue,"^",5)
								Set tIdentifier = ##class(HS.FHIR.vDSTU2.Model.Base.Identifier).%New()
								If tSlotType'="" {
									Set tIdentifierType = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New()
									Do tIdentifierType.SetCoding(tSlotType, , "urn:ietf:rfc:3986")
									Set tIdentifier.type = tIdentifierType
								}
								Set tSlotValueValue = $Piece(tSlotValue,"^",1)
								Set tSlotValueSystem = $Piece($Piece(tSlotValue,"^",4),"&",2)
								If tSlotValueValue'="" Do tIdentifier.SetValue(tSlotValueValue)
								If tSlotValueSystem'="" Do tIdentifier.SetSystem(tSlotValueSystem)
								Set tRelated.identifier = tIdentifier
								Do tContext.related.Insert(tRelated)
							}
						}
					}
				}
			}
			
			For j = 1:1:tDocument.ConfidentialityCode.Count() {
				Set tConfidentiality = tDocument.ConfidentialityCode.GetAt(j)
				Set tCode = tConfidentiality.Code
				Set tDescription = tConfidentiality.Description
				Set tScheme = tConfidentiality.Scheme
				Set tSystem = ..GetCodeSystem("confidentialityCode", tScheme, tCode, tScheme)
				Set tSC = tDocumentReference.SetSecurityLabel(tCode, tDescription, tSystem, tDescription) Quit:$$$ISERR(tSC)
				Quit:$$$ISERR(tSC)
			}
			
			Set tContent = ##class(HS.FHIR.vDSTU2.Model.Resource.DocumentReference.Content).%New()
			Set tAttachment = ##class(HS.FHIR.vDSTU2.Model.Base.Attachment).%New()
			Set tSC = tAttachment.SetContentType(tDocument.MimeType)
			If tDocument.LanguageCode'="" {
				Set tSC = tAttachment.SetLanguage(tDocument.LanguageCode)
			} Else {
				Do tAttachment.SetLanguage("en-US")
			}
			Set tBinaryResourceUrl = ..GetTransactionFullUrl("Binary")
			Set tSC = tAttachment.SetUrl(tBinaryResourceUrl)
			Set tSC = tAttachment.SetSize(tDocument.Size)
			
			// Verify that the provided XDSb hexbinary hash is correct.
			If tDocument.Hash'="" {
				If ($IsObject(tDocument.BodyCharacter))&&(tDocument.BodyCharacter.Size>0) {
					Set tStreamHash = ##class(HS.IHE.XDSb.Util).StreamHash(tDocument.BodyCharacter)
				} ElseIf ($IsObject(tDocument.Body))&&(tDocument.Body.Size>0) {
					Set tStreamHash = ##class(HS.IHE.XDSb.Util).StreamHash(tDocument.Body)
				} Else {
					Set tStreamHash = ""
				}
				// Reject the PnR if the provided XDSb hash does not verify.
				If tStreamHash'=tDocument.Hash {
					Set tSC = $$$ERROR($$$GeneralError, "Specified hash '"_tDocument.Hash_"' does not match calculated hash '"_tStreamHash_"'")
					Quit
				}
			}
			
			// FHIR requires SHA-1 hash, base64encoded. Generate that hash now.
			If ($IsObject(tDocument.BodyCharacter))&&(tDocument.BodyCharacter.Size>0) {
				Do tDocument.BodyCharacter.Rewind()
				Set tSC = tAttachment.SetHash($system.Encryption.SHA1Hash(tDocument.BodyCharacter.Read($$$MaxLocalLength)))
			} ElseIf ($IsObject(tDocument.Body))&&(tDocument.Body.Size>0) {
				Do tDocument.Body.Rewind()
				Set tSC = tAttachment.SetHash($system.Encryption.SHA1Hash(tDocument.Body.Read($$$MaxLocalLength)))
			}
			
			Set tSC = tAttachment.SetTitle(tDocument.Comments) Quit:$$$ISERR(tSC)
			
			#; tDocument.CreationTime is expected to be an HL7 DTM format YYYYMMDDHHMMSS, in UTC.
			Set tCreationTime = tDocument.CreationTime
			If tCreationTime'="" {
				#; Convert to FHIR DateTime format, in the local time zone.
				Set tCreationTime = ##class(HS.FHIR.Utils).V2ToFHIRDateTime(tCreationTime,1,1)
				Set tSC = tAttachment.SetCreation(tCreationTime) Quit:$$$ISERR(tSC)
			}
			Set tContent.attachment = tAttachment
			
			Set tCode = tDocument.FormatCode.Code
			Set tDescription = tDocument.FormatCode.Description
			Set tScheme = tDocument.FormatCode.Scheme
			Set tSystem = ..GetCodeSystem("formatCode", tScheme, tCode, tScheme)
			Set tSC = tContent.SetFormat(tCode, tDescription, tSystem) Quit:$$$ISERR(tSC)
			
			Set tSC = tDocumentReference.content.Insert(tContent)
			
			Set tDocumentReference.context = tContext
			
			Set tEntryRequest = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Request).%New()
			Do tEntryRequest.SetMethod("POST")
			Do tEntryRequest.SetUrl("DocumentReference")
			Set tBundleEntry = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Entry).%New()
			Set tSC = tBundleEntry.SetFullUrl(tDocumentReferenceUrl) Quit:$$$ISERR(tSC)
			Set tDocumentFullUrlsByEntryUUID(tDocument.EntryUUID) = tDocumentReferenceUrl
			Set tSC = tBundleEntry.SetResource(tDocumentReference) Quit:$$$ISERR(tSC)
			Set tBundleEntry.request = tEntryRequest
			Do tBundle.entry.Insert(tBundleEntry)
			
			Set tBinary = ##class(HS.FHIR.vDSTU2.Model.Resource.Binary).%New()
			Set tSC = tBinary.SetContentType(tDocument.MimeType)
			Do tDocument.BodyCharacter.Rewind()
			Do tDocument.Body.Rewind()
			If tDocument.BodyCharacter.Size>0 {
				Set tSC = tBinary.SetContent(tDocument.BodyCharacter.Read($$$MaxLocalLength))
			} ElseIf tDocument.Body.Size>0 {
				Set tSC = tBinary.SetContent(tDocument.Body.Read($$$MaxLocalLength))
			}
			
			Set tEntryRequest = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Request).%New()
			Do tEntryRequest.SetMethod("POST")
			Do tEntryRequest.SetUrl("Binary")
			Set tBundleEntry = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Entry).%New()
			Set tSC = tBundleEntry.SetFullUrl(tBinaryResourceUrl)
			Set tSC = tBundleEntry.SetResource(tBinary) Quit:$$$ISERR(tSC)
			Set tBundleEntry.request = tEntryRequest
			Do tBundle.entry.Insert(tBundleEntry)
		}
		If $$$ISERR(tSC) Quit
		
		#dim tFolder As HS.Message.IHE.XDSb.Folder
		
		For i = 1:1:tUpdatedRequest.Folders.Count() {
			Set tFolder = tUpdatedRequest.Folders.GetAt(i)
			Set tListResource = ##class(HS.FHIR.vDSTU2.Model.Resource.List).%New()
			If tFolder.EntryUUID'="" {
				Set tSC = tListResource.SetIdentifier(tFolder.EntryUUID, , "official", , , , "EntryUUID")
				If $$$ISERR(tSC) Quit
			}
			If tFolder.UniqueId'="" {
				Set tSC = tListResource.SetIdentifier(tFolder.UniqueId, , "usual", , , , "UniqueId")
				If $$$ISERR(tSC) Quit
			}
			If tFolder.Title'="" Do tListResource.SetTitle(tFolder.Title)
			
			#dim tCodedValue As HS.IHE.XDSb.Types.CodedValue
			
			If tFolder.CodeList.Count() {
				Set tListCode = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New()
				For j = 1:1:tFolder.CodeList.Count() {
					Set tSC = tListCode.SetCoding(tFolder.CodeList.GetAt(j).Code, tFolder.CodeList.GetAt(j).Description, tFolder.CodeList.GetAt(j).Scheme)
					If $$$ISERR(tSC) Quit
				}
				If $$$ISERR(tSC) Quit
				Set tListResource.code = tListCode
			}
			
			Set tSC = tListResource.SetSubject(tPatientResourceUrl)
			If $$$ISERR(tSC) Quit
			
			Set tSC = tListResource.SetStatus($Case(tFolder.AvailabilityStatus, "Approved":"current", "Deprecated":"retired", :"current"))
			If $$$ISERR(tSC) Quit
			
			#; tDocument.CreationTime is expected to be an HL7 DTM format YYYYMMDDHHMMSS, in UTC.
			Set tLastUpdateTime = tFolder.LastUpdateTime
			If tLastUpdateTime'="" {
				#; Convert to FHIR instant format, in the local time zone.
				Set tLastUpdateTime = ##class(HS.FHIR.Utils).V2ToFHIRInstant(tLastUpdateTime,1,1)
				Set tSC = tListResource.SetDate(tLastUpdateTime)
				If $$$ISERR(tSC) Quit
			} Else {
				Set tSC = tListResource.SetDate(tNowInstant)
				If $$$ISERR(tSC) Quit
			}
			
			Set tSC = tListResource.SetMode("working")
			If $$$ISERR(tSC) Quit
			
			If tFolder.Comments'="" {
				Set tSC = tListResource.SetNote(tFolder.Comments)
				If $$$ISERR(tSC) Quit
			}
			
			#dim tAssociation As HS.Message.IHE.XDSb.Association
			#dim tListEntry As HS.FHIR.vDSTU2.Model.Resource.List.Entry
			
			For j = 1:1:pXDSbRequest.Associations.Count() {
				Set tAssociation = pXDSbRequest.Associations.GetAt(j)
				If (tAssociation.Type="HasMember")&&(tAssociation.ParentUUID=tFolder.EntryUUID) {
					Set tListEntry = ##class(HS.FHIR.vDSTU2.Model.Resource.List.Entry).%New()
					Set tItem = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New()
					Set tSC = tItem.SetReference(tDocumentFullUrlsByEntryUUID(tAssociation.ChildUUID))
					If $$$ISERR(tSC) Quit
					Set tListEntry.item = tItem
					Set tSC = tListResource.entry.Insert(tListEntry)
					If $$$ISERR(tSC) Quit
				}
			}
			If $$$ISERR(tSC) Quit
			
			Set tEntryRequest = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Request).%New()
			Do tEntryRequest.SetMethod("POST")
			Set tFolderEntryUUID = tFolder.EntryUUID
			If $Extract(tFolderEntryUUID,1,9)="urn:uuid:" {
				Set tFolderEntryUUID = $Extract(tFolderEntryUUID, 10, *)
			}
			Do tEntryRequest.SetUrl("List")
			Set tBundleEntry = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Entry).%New()
			Set tSC = tBundleEntry.SetFullUrl("List/"_tFolderEntryUUID)
			Set tSC = tBundleEntry.SetResource(tListResource) Quit:$$$ISERR(tSC)
			Set tBundleEntry.request = tEntryRequest
			Do tBundle.entry.Insert(tBundleEntry)
		}
		
		$$$HSTRACE("Provide Document Bundle", "tBundle", tBundle)
		
		Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(pMHDRequest.ContentType, tBundle, .tFHIRStream, ..FormatFHIROutput)
		If $$$ISERR(tSC) Quit
		
		Set tSC = pMHDRequest.Payload.CopyFrom(tFHIRStream)
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod GetCodeSystem(pCodeType As %String, pScheme As %String, pCode As %String, pDefault As %String = "") As %String
{
	Set tSystem = ""
	
	If ##class(HS.HC.Util).IsOID(pScheme) {
		// It's an OID. Look in the OID Registry for a corresponding URL.
		// If no URL found then use the OID.
		Set tURL = ##class(HS.Data.OIDMap).GetURLForOID(pScheme)
		If tURL'=pScheme {
			Set tSystem = tURL
		} Else {
			Set tSystem = pScheme
			If $Extract(tSystem,1,8)'="urn:oid:" Set tSystem = "urn:oid:"_tSystem
		}
	} ElseIf ##class(HS.HC.Util).IsURL(pScheme) {
		// Unlikely we'll get scheme as a URL, but if we do, just use it.
		Set tSystem = pScheme
	} ElseIf ##class(HS.HC.Util).IsUUID(pScheme) {
		// Unlikely we'll get scheme as a UUID, but if we do, just use it.
		Set tSystem = pScheme
		If $Extract(tSystem,1,9)'="urn:uuid:" Set tSystem = "urn:uuid:"_tSystem
	} Else {
		// Otherwise, it's text.
		If pScheme["Connect-a-thon " {
			Set tSystem = "http://connectathon.ihe"
		} ElseIf (pScheme="2.16.840.1.113883.6.96")||(pScheme="SNOMED")||(pScheme="SRT")||(pScheme="SNM3") {
			Set tSystem = "http://snomed.info/sct"
		} ElseIf (pScheme="2.16.840.1.113883.6.1")||($ZConvert(pScheme,"U")="LOINC") {
			Set tSystem = "http://loinc.org"
		} ElseIf (pScheme="1.2.840.10008.2.6.1")||(pScheme="DCM") {
			Set tSystem = "http://dicom.nema.org/resources/ontology/DCM"
		} ElseIf pScheme="2.16.840.1.113883.3.86" {
			Set tSystem = "http://www.intersystems.com"
		} ElseIf pScheme="2.16.840.1.113883.5.25" {
			Set tSystem = "http://hl7.org/fhir/v3/Confidentiality"
		} ElseIf (pScheme="2.16.840.1.113883.3.88")||(pScheme="HITSP") {
			Set tSystem = "urn:oid:2.16.840.1.113883.3.88"
		} ElseIf (pScheme="1.3.6.1.4.1.19376.1.2.3")||($Extract(pScheme,1,4)="IHE ")||($Extract(pScheme,1,4)="IHE-") {
			Set tSystem = "urn:oid:1.3.6.1.4.1.19376.1.2.3"
		} ElseIf pScheme="MPQ Testing" {
			Set tSystem = "http://connectathon.ihe"
		} ElseIf $Extract(pScheme,1,8)="RSNA2008" {
			Set tSystem = "http://connectathon.ihe"
		}
	}
	
	If tSystem="" Set tSystem = pDefault
	
	Quit tSystem
}

ClassMethod GetTransactionFullUrl(pResourceType As %String) As %String [ Internal ]
{
	Set tId = $ZConvert($system.Util.CreateGUID(),"L")
	Set tUrl = "urn:uuid:"_tId
	Quit tUrl
}

Method MHDPnRResponseToXMLMessage(pMHDResponse As HS.Message.FHIR.Response, ByRef pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		
		Set tIssueCount = 0
		
		If pMHDResponse.Payload.Size>0 {
			Set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR(pMHDResponse.ContentType, pMHDResponse.Payload, .tHSFHIRObj, "HS.FHIR.vDSTU2.Model.Resource")
			If $$$ISOK(tSC) {
				If tHSFHIRObj.%ClassName(0)="OperationOutcome" Set tIssueCount = tHSFHIRObj.issue.Count()
			}
		}
		
		If (+pMHDResponse.Status=200)||(+pMHDResponse.Status=201) {
			Do pResponse.ContentStream.WriteLine("<RegistryResponse xmlns=""urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0"" status=""urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success""/>")
			Do pResponse.ContentStream.Rewind()
		} ElseIf (+pMHDResponse.Status>399)&&(+pMHDResponse.Status<501)&&(tIssueCount=0) {
			Do pResponse.ContentStream.WriteLine("<RegistryResponse xmlns=""urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0"" status=""urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure"">")
			Do pResponse.ContentStream.WriteLine("<RegistryErrorList highestSeverity=""urn:oasis:names:tc:ebxml-regrep:ErrorSeverityType:Error"">")
			Do pResponse.ContentStream.WriteLine("<RegistryError codeContext="""_pMHDResponse.Status_""" errorCode=""XDSRegistryMetadataError"" location="""" severity=""urn:oasis:names:tc:ebxml-regrep:ErrorSeverityType:Error""/>")
			Do pResponse.ContentStream.WriteLine("</RegistryErrorList>")
			Do pResponse.ContentStream.WriteLine("</RegistryResponse>")
			Do pResponse.ContentStream.Rewind()
		} ElseIf (+pMHDResponse.Status>399)&&(+pMHDResponse.Status<501) {
			Do pResponse.ContentStream.WriteLine("<RegistryResponse xmlns=""urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0"" status=""urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure"">")
			Do pResponse.ContentStream.WriteLine("<RegistryErrorList highestSeverity=""urn:oasis:names:tc:ebxml-regrep:ErrorSeverityType:Error"">")
			For i = 1:1:tHSFHIRObj.issue.Count() {
				Set tIssue = tHSFHIRObj.issue.GetAt(i)
				Set tDescription = tIssue.diagnostics.value
				If tDescription="" {
					Set tDescription = tIssue.details.text.value
					If (tDescription="")&&($IsObject(tIssue.details.coding))&&(tIssue.details.coding.Count()>0) {
						Set tDescription = tIssue.details.coding.GetAt(1).display.value
						If tDescription="" Set tDescription = tIssue.details.coding.GetAt(1).code.value
					}
				}
				If tDescription="" Set tDescription = pMHDResponse.Status
				Set tDescription = $ZConvert(tDescription, "O", "XML")
				Do pResponse.ContentStream.WriteLine("<RegistryError codeContext="""_tDescription_""" errorCode=""XDSRegistryMetadataError"" location="""" severity=""urn:oasis:names:tc:ebxml-regrep:ErrorSeverityType:Error""/>")
			}
			Do pResponse.ContentStream.WriteLine("</RegistryErrorList>")
			Do pResponse.ContentStream.WriteLine("</RegistryResponse>")
			Do pResponse.ContentStream.Rewind()
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

/// UpdateRegistryService updates - If needed - the info in the RegistryService
/// property.  Update is based on pService, the ServiceName setting, and the
/// info currently in RegistryService.  The ServiceName setting is the default
/// service name to use, and may be overridden by pRequest.AdditionalInfo.GetAt("ServiceName").
/// If RegistryService is updated, then the properties on this BO's TCP adapter
/// are also updated.
/// If Service Registry settings on a TCP service are changed, then this BO
/// should be restarted to guarantee that the changes are effective at run time.
Method UpdateRegistryService(pService)
{
	Set:pService="" pService=..ServiceName
	If $lg(..RegistryService)'=pService,pService'="" {
		Set tRegistryService = ##class(HS.Registry.Service.HTTP).EndPointForNameType(pService,"HTTP")
		If $IsObject(tRegistryService) {
			Set tDeviceOID=##class(HS.Data.OIDMap).OIDForType(tRegistryService.OIDMapCode.GetAt("Device"),"Device")
			Set ..RegistryService = $lb(tRegistryService.Name,tRegistryService.%Id(),tDeviceOID,,tRegistryService.OIDMapCode.GetAt("ReceivingApplication"),tRegistryService.OIDMapCode.GetAt("ReceivingFacility"),tRegistryService.Host,tRegistryService.Port,,tRegistryService.SSLConfig,tRegistryService.URL)
		}
	}
}

}
