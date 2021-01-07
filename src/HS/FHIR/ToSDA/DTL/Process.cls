/// HS.FHIR.ToSDA.DTL.Process takes FHIR resource or Bundle as input, converts
/// the FHIR data into an SDA Container, forwards the Container to a specified
/// business host, receives the response from the business host, and returns a
/// FHIR response based the return from the business host.
Class HS.FHIR.ToSDA.DTL.Process Extends (Ens.BusinessProcess, HS.HC.Util.Trace.Helper) [ ClassType = persistent, Inheritance = right ]
{

Parameter HSDEPLOY = 1;

Parameter SETTINGS = "CustomDTLPackage,TargetConfigName:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

/// Specifies the DTL class package that has the custom versions of
/// the DTLs that are called by this business process. If this
/// setting has a value, and a custom version of a DTL is found in
/// the package, then the DTL from that package is used instead of
/// the standard version.
Property CustomDTLPackage As %String(MAXLEN = 128);

/// Specifies the business host to which to forward the HS.Message.XMLMessage
/// message (which includes the SDA Container) after it is built by the
/// DTL transformation.
Property TargetConfigName As Ens.DataType.ConfigName;

Parameter STANDARDPACKAGE = "HS.FHIR.DTL.ToSDA";

Parameter OutputToQuickStream = 0;

Method OnRequest(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC=$$$OK
		
		If ..CustomDTLPackage=..#STANDARDPACKAGE Set tSC = $$$ERROR($$$GeneralError, "CustomDTLPackage cannot equal the standard DTL package name - input message rejected") Quit
		If ..TargetConfigName="" Set tSC = $$$ERROR($$$GeneralError, "No TargetConfigName configured for SDA request message - input message rejected") Quit
		
		If pRequest.%IsA("HS.Message.FHIR.Request") {
			Set tSC = ..ProcessFHIRRequest(pRequest, .pResponse)
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Request type not handled:  " _ pRequest.%ClassName(1)) Quit
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method ProcessFHIRRequest(pFHIRRequest As HS.Message.FHIR.Request, Output pFHIRResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Method Overview:
		#;
		#; Input is an HS FHIR request.
		#; FHIR request Payload must be a single Patient resource or a Bundle of resources.
		#; If the Payload is a Bundle, then the first entry must be a Patient resource.
		#; The FHIR request must be transformed to an SDA Container, using DTL.
		#; Place the SDA Container into the ContentStream of an HS.Message.XMLMessage object.
		#; Route the XMLMessage to TargetConfigName.
		#; Receive the response message from TargetConfigName.
		#; Transform the response into an HS FHIR response, and return it.
		
		#dim tSDAContainer As HS.SDA3.Container
		#dim tSDAXMLRequest As HS.Message.XMLMessage
		#dim tSDAXMLResponse As HS.Message.XMLMessage
		
		Set tQStream = pFHIRRequest.GetPayloadOref()
		
		#; Make an object from the FHIR Payload.
		Set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR(pFHIRRequest.ContentType, tQStream, .tHSFHIRObj)
		If $$$ISERR(tSC) Quit
		If (tHSFHIRObj.%ClassName(0)'="Bundle")&&(tHSFHIRObj.%ClassName(0)'="Patient") Set tSC = $$$ERROR($$$GeneralError, "Unexpected FHIR resource type in request") Quit
		
		Set tSC = pFHIRRequest.NewResponse(.pFHIRResponse)
		If $$$ISERR(tSC) Quit
		Set pFHIRResponse.ContentType = pFHIRRequest.ContentType
		
		If tHSFHIRObj.%ClassName(0)="Bundle" {
			Set tSC = ..UpdateInputBundle(.tHSFHIRObj, .tEntriesToSkip, .tEncounters)
			If $$$ISERR(tSC) Quit
			$$$HSTRACEMIN("FHIR object after UpdateInputBundle", "tHSFHIRObj", tHSFHIRObj)
		}
		
		#; Store the cross-reference of Encounters resource ids to
		#; EncounterNumbers in the auxiliary data array to be passed
		#; into the FHIR to SDA transforms.
		Set tResourceId = ""
		For {
			Set tResourceId = $Order(tEncounters(tResourceId))
			If tResourceId="" Quit
			Set tAux("EncounterNumbers",tResourceId) = tEncounters(tResourceId)
		}
		
		#; FHIR DiagnosticOrder and DiagnosticReport do not have a
		#; property that corresponds to HL7v2 ORC-29 (OrderType).
		#; Build a table to map FHIR DiagnosticReport category
		#; (corresponds to HL7v2 OBR-24) to SDA LabOrder, RadOrder,
		#; or OtherOrder.
		Set tSC = ..GetOrderTypeMapping(.tOrderType)
		If $$$ISERR(tSC) Quit
		
		Set tSendingFacilityCode = ""
		Set tSDAContainer = ##class(HS.SDA3.Container).%New()
		If tHSFHIRObj.%ClassName(0)="Patient" {
			Set tSC = ..ExecuteDTL("Patient", tHSFHIRObj, .tSDAContainer, .tNoDTLClass, .tAux)
			If $$$ISERR(tSC) Quit
			Set tSC = ..GetSendingFacilityCode(tHSFHIRObj, .tSendingFacilityCode)
			If $$$ISERR(tSC) Quit
		} Else {
			For i = 1:1:tHSFHIRObj.entry.Count() {
				If $Data(tEntriesToSkip(i)) Continue
				Set tSC = ##class(HS.FHIR.Utils).GetResourceFromContainer(tHSFHIRObj.entry.GetAt(i).resource, .tResource)
				If $$$ISERR(tSC) Quit
				Set tResourceType = tResource.%ClassName(0)
				Set tDTLClass = tResourceType
				If tResourceType="Condition" {
					Set tIsDiagnosis = 0
					If $IsObject(tResource.category) {
						For j = 1:1:tResource.category.coding.Count() {
							Set tCoding = tResource.category.coding.GetAt(j)
							If (tCoding.code.value="diagnosis")&&(tCoding.system.value="http://hl7.org/fhir/condition-category") {
								Set tIsDiagnosis = 1
								Quit
							}
							If (tCoding.code.value="439401001")&&((tCoding.system.value="http://snomed.info/sct")||(tCoding.system.value="urn:oid:2.16.840.1.113883.6.96")||(tCoding.system.value="2.16.840.1.113883.6.96")) {
								Set tIsDiagnosis = 1
								Quit
							}
						}
					}
					If tIsDiagnosis=0 {
						Set tDTLClass = "ConditionProblem"
					} Else {
						Set tDTLClass = "ConditionDiagnosis"
					}
				} ElseIf tResourceType="Observation" {
					#; FHIR Observation Bundle entries intended for DiagnosticReport
					#; have already been pulled into DiagnosticReport Bundle entries
					#; and will be skipped.  For the remaining Observation entries,
					#; determine if they should be transformed into SDA SocialHistory
					#; or SDA PhysicalExam.  Those remaining that are not intended
					#; for DiagnosticReport or SocialHistory or PhysicalExam will
					#; be transformed into SDA Observation.
					Set tCodingValue = ""
					If $IsObject(tResource.category) {
						For j =1:1:tResource.category.coding.Count() {
							Set tCoding = tResource.category.coding.GetAt(j)
							If (tCoding.code.value="social-history")||(tCoding.display.value="social-history") {
								Set tCodingValue = "social-history"
								Quit
							}
							If (tCoding.code.value="exam")||(tCoding.display.value="exam") {
								Set tCodingValue = "exam"
								Quit
							}
						}
					}
					If (tCodingValue="social-history")||(tResource.category.text.value="social-history") Set tDTLClass = "ObservationSocialHistory"
					If (tCodingValue="exam")||(tResource.category.text.value="exam") Set tDTLClass = "ObservationPhysicalExam"
				} ElseIf tResourceType="DiagnosticReport" {
					#; Derive SDA order type from FHIR DiagnosticReport category.
					Set tOrderCategory = ""
					If $IsObject(tResource.category) {
						Set tOrderCategory = tResource.category.text.value
						If tResource.category.coding.Count()>0 {
							If tResource.category.coding.GetAt(1).display.value'="" Set tOrderCategory = tResource.category.coding.GetAt(1).display.value
							If tResource.category.coding.GetAt(1).code.value'="" Set tOrderCategory = tResource.category.coding.GetAt(1).code.value
						}
					}
					If tOrderCategory="" Set tOrderCategory = "LAB"
					Set tOrderCategory = $ZConvert(tOrderCategory, "U")
					If $Data(tOrderType(tOrderCategory)) {
						Set tOrderType = tOrderType(tOrderCategory)
					} Else {
						Set tOrderType = "LAB"
					}
					Set tDTLClass = "DiagnosticReport"_$Select(tOrderType="LAB":"LabOrder",tOrderType="RAD":"RadOrder",1:"OtherOrder")
				}
				
				Set tSC = ..ExecuteDTL(tDTLClass, tResource, .tSDAContainer, .tNoDTLClass, .tAux)
				If $$$ISERR(tSC) Set tSC = $$$ERROR($$$GeneralError, "ExecuteDTL - "_$system.Status.GetOneErrorText(tSC)) Quit
				
				If tResourceType="Patient" {
					Set tSC = ..GetSendingFacilityCode(tResource, .tSendingFacilityCode)
					If $$$ISERR(tSC) Quit
				}
			}
			If $$$ISERR(tSC) Quit
		}
		
		Set tDTLClass = ""
		For {
			Set tDTLClass = $Order(tNoDTLClass(tDTLClass))
			If tDTLClass="" Quit
			Set tFHIRType = $Piece(tDTLClass,".",$Length(tDTLClass,"."))
			Set tEntryText = $Select(tNoDTLClass(tDTLClass)>1:"entries",1:"entry")
			$$$LOGWARNING(tNoDTLClass(tDTLClass)_" FHIR "_tFHIRType_" Bundle "_tEntryText_" not processed due to transform not supported")
		}
		
		Set tSDAContainer.Action = "AddOrUpdate"
		Set tSDAContainer.EventDescription = "SDAFromFHIR"
		Set tSDAContainer.SendingFacility = tSendingFacilityCode
		Set tQuickStreamId = ""
		Set tSDAXMLRequest = ##class(HS.Message.XMLMessage).%New()
		If ..#OutputToQuickStream=1 {
			Set tQuickStream = ##class(HS.SDA3.QuickStream).%New()
			Set tQuickStreamId = tQuickStream.%Id()
			Do tSDAXMLRequest.AdditionalInfo.SetAt(tQuickStreamId, "QuickStreamId")
			Set tStreamRef = tQuickStream
		} Else {
			Set tStreamRef = tSDAXMLRequest.ContentStream
		}
		
		Do tStreamRef.Rewind()
		
		Set tSC = tSDAContainer.ToQuickXMLStream(.tStreamRef)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..SendRequestSync(..TargetConfigName, tSDAXMLRequest, .tSDAXMLResponse)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..ProcessSDAResponse(pFHIRRequest, tSDAXMLResponse, tSC, .pFHIRResponse)
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If ($Get(tQuickStreamId)'="")&&($IsObject($Get(tQuickStream))) Do tQuickStream.Clear()
	
	Quit tSC
}

/// UpdateInputBundle modifies the FHIR Bundle that was sent as input, and
/// gathers data needed for the data transformations.<br>
/// - For Bundle entry resources that are referred to by other Bundle entry
///   resources, copies those resources into contained resources within the
///   resources that refer to them.<br>
/// - Makes a note (array pBundleEntiesToSkip) of the Bundle entry resources
///   that were copied into contained resources, so that those Bundle entry 
///   resources are skipped during DTL processing.  Their data will be
///   transformed when the containing resource is transformed.<br>
/// - Makes a note of Encounter resources and creates a cross-reference
///   (array pEncounterNumbers) of Encounter resource ids and EncounterNumbers.
Method UpdateInputBundle(ByRef pBundle As HS.FHIR.vDSTU2.Model.Resource.Bundle, ByRef pBundleEntriesToSkip As %String, ByRef pEncounters As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; tSourceBundleEntry is the Bundle entry resource from which
		#; the resource will be copied.
		#; tTargetBundleEntry is the Bundle entry resource that will
		#; have a contained resource inserted, and have the existing
		#; reference to the Bundle resource updated to point to
		#; the new contained resource.
		
		#dim tEntry As HS.FHIR.vDSTU2.Model.Resource.Bundle.Entry
		#dim tSourceBundleEntry As HS.FHIR.vDSTU2.Model.Resource.Bundle.Entry
		#dim tTargetBundleEntry As HS.FHIR.vDSTU2.Model.Resource.Bundle.Entry
		#dim tSourceResource As HS.FHIR.vDSTU2.Model.Base.DomainResource
		#dim tTargetResource As HS.FHIR.vDSTU2.Model.Base.DomainResource
		
		Set tContainedResourceIndex = 10000
		
		#; Build an index of the Bundle entries, by fullUrl.  This method
		#; currently assumes all fullUrl and reference values are only
		#; resource type and resource id, delimited by slash.
		#;
		#; tEntryIndex("ByFullUrl", resourceType/resourceid) = entryNumber
		#;
		#; For example: tEntryIndex("ByFullUrl", "Practitioner/123") = 34
		#;
		For i = 1:1:pBundle.entry.Count() {
			Set tFullUrl = pBundle.entry.GetAt(i).fullUrl.value
			Set tLen = $Length(tFullUrl,"/")
			If (tLen<2)||($Piece(tFullUrl,"/",tLen-1)="")||($Piece(tFullUrl,"/",tLen)="") Continue
			Set tReference = $Piece(tFullUrl,"/",tLen-1)_"/"_$Piece(tFullUrl,"/",tLen)
			Set tEntryIndex("ByFullUrl", tReference) = i
			Set tSC = ##class(HS.FHIR.Utils).GetResourceFromContainer(pBundle.entry.GetAt(i).resource, .tResource)
			If $$$ISERR(tSC) Quit
			Set tResourceType = tResource.%ClassName(0)
			If tResourceType="Encounter" {
				If (tResource.identifier.Count()>0)&&(tResource.identifier.GetAt(1).value.value'="") {
					Set pEncounters($Piece(tReference,"/",2))= tResource.identifier.GetAt(1).value.value
				}
			#; The Medications-related resource types need special handling because
			#; of the more-than-two-layered references involved in these resources.
			#; Make a note of the resources, and set them to be skipped so that they
			#; do not get moved into contained resources by the logic that is applied
			#; to all other resource types when moving resources to contained.
			} ElseIf tResourceType="MedicationOrder" {
				Set tMedications("MedicationOrderByEntry",i) = tFullUrl
				Set tRef = tResource.medicationReference.reference.value
				If tRef'="" {
					Set tMedications("MedicationOrderMedicationRefByEntry",i) = tRef
				}
				Set tRef = tResource.prescriber.reference.value
				If tRef'="" {
					Set tMedications("MedicationOrderPrescriberRefByEntry",i) = tRef
				}
			} ElseIf tResourceType="Medication" {
				Set pBundleEntriesToSkip(i) = ""
				Set tMedications("MedicationByEntry",i) = tFullUrl
				Set tMedications("MedicationByFullUrl",tFullUrl) = i
			} Elseif tResourceType="MedicationDispense" {
				Set pBundleEntriesToSkip(i) = ""
				Set tMedications("MedicationDispenseByEntry",i) = tFullUrl
				Set tMedications("MedicationDispenseByFullUrl",tFullUrl) = i
				Set tRef = tResource.medicationReference.reference.value
				If tRef'="" {
					Set tMedications("MedicationDispenseMedicationRefByEntry",i) = tRef
				}
				If tResource.authorizingPrescription.Count()>0 {
					Set tRef = tResource.authorizingPrescription.GetAt(1).reference.value
					If tRef'="" {
						Set tMedications("MedicationDispenseMedicationOrderRefByFullUrl",tRef) = i
					}
				}
			} Elseif tResourceType="MedicationAdministration" {
				Set pBundleEntriesToSkip(i) = ""
				Set tRef = tResource.prescription.reference.value
				If tRef'="" {
					Set tMedications("MedicationAdministrationMedicationOrderRefByEntry",i) = tRef
					Set tMedications("MedicationAdministrationMedicationOrderRefByFullUrl",tRef) = i
				}
				Set tRef = tResource.practitioner.reference.value
				If tRef'="" {
					Set tMedications("MedicationAdministrationPractitionerRefByEntry",i) = tRef
					Set tMedications("MedicationAdministrationPractitionerRefByFullUrl",tRef) = i
				}
			}
		}
		
		#; Build an array that maps referring entry resources to the entry
		#; resources to which they refer.  A given resource could be both
		#; a referrer and a referree.  For example a DiagnosticOrder could
		#; be referred to by a DiagnosticReport, and also itself refer to
		#; a Practitioner.
		#;
		#; For this array, "target" means the resource to which a contained
		#; resource will be added, and "source" means the resource whose
		#; contents is the source for the contained resource.
		#;
		#; tReferenceMap(targetEntryNumber, sourceEntryNumber) = referenceValue
		#;
		For i = 1:1:pBundle.entry.Count() {
			Set tSC = ##class(HS.FHIR.Utils).GetResourceFromContainer(pBundle.entry.GetAt(i).resource, .tResource)
			If $$$ISERR(tSC) Quit
			Set tSC = tResource.GetReferenceMap(.tEntryIndex, i, .tReferenceMap)
			If $$$ISERR(tSC) Quit
		}
		If $$$ISERR(tSC) Quit
		
		#; Parse the reference map and create a new array that sorts the
		#; entries such that the deepest referred resources are placed
		#; first.  For example, if a DiagnosticReport refers to a
		#; DiagnosticOrder and that DiagnosticOrder refers to a Practitioner,
		#; the Practitioner should be copied into the DiagnosticOrder
		#; first, and then the DiagnosticOrder should be copied into the
		#; DiagnosticReport.
		#;
		#; tReferenceMapSorted(index) = targetEntryNumber|sourceEntryNumber|referenceValue
		#;
		Set tIndex = 0
		Set tTargetEntryNumber = ""
		For {
			Set tTargetEntryNumber = $Order(tReferenceMap(tTargetEntryNumber))
			If tTargetEntryNumber="" Quit
			Set tSourceEntryNumber = ""
			For {
				Set tSourceEntryNumber = $Order(tReferenceMap(tTargetEntryNumber, tSourceEntryNumber))
				If tSourceEntryNumber="" Quit
				If $Data(tReferenceMap(tSourceEntryNumber)) {
					Set tT1 = tSourceEntryNumber, tS1 = ""
					For {
						Set tS1 = $Order(tReferenceMap(tT1,tS1)) Quit:tS1=""
						If $Data(tReferenceMap(tS1)) {
							Set tT2 = tS1 , tS2 = ""
							Set tS2 = $Order(tReferenceMap(tT2,tS2)) Quit:tS2=""
							If $Data(tReferenceMap(tS2)) {
								Set tT3 = tS2, tS3 = ""
								Set tS3 = $Order(tReferenceMap(tT3,tS3)) Quit:tS3=""
								If $Data(tReferenceMap(tS3)) {
									Set tT4 = tS3, tS4 = ""
									Set tS4 = $Order(tReferenceMap(tT4,tS4)) Quit:tS4=""
									If $i(tIndex) {
										Set tReferenceMapSorted(tIndex)=tT4_"|"_tS4_"|"_tReferenceMap(tT4,tS4)
										Kill tReferenceMap(tT4,tS4)
									}
								}
								If $i(tIndex) {
									Set tReferenceMapSorted(tIndex)=tT3_"|"_tS3_"|"_tReferenceMap(tT3,tS3)
									Kill tReferenceMap(tT3,tS3)
								}
							}
							If $i(tIndex) {
								Set tReferenceMapSorted(tIndex)=tT2_"|"_tS2_"|"_tReferenceMap(tT2,tS2)
								Kill tReferenceMap(tT2,tS2)
							}
						}
						If $i(tIndex) {
							Set tReferenceMapSorted(tIndex)=tT1_"|"_tS1_"|"_tReferenceMap(tT1,tS1)
							Kill tReferenceMap(tT1,tS1)
						}
					}
				}
			}
		}
		#; Put all the leftover reference map items into the sorted array last.
		Set tTargetEntryNumber = ""
		For {
			Set tTargetEntryNumber = $Order(tReferenceMap(tTargetEntryNumber))
			If tTargetEntryNumber="" Quit
			Set tSourceEntryNumber = ""
			For {
				Set tSourceEntryNumber = $Order(tReferenceMap(tTargetEntryNumber, tSourceEntryNumber))
				If tSourceEntryNumber="" Quit
				If $i(tIndex) {
					Set tReferenceMapSorted(tIndex)=tTargetEntryNumber_"|"_tSourceEntryNumber_"|"_tReferenceMap(tTargetEntryNumber,tSourceEntryNumber)
					Kill tReferenceMap(tTargetEntryNumber,tSourceEntryNumber)
				}
			}
		}
		
		#; Now parse through the sorted map and move the resources.
		Set tIndex = ""
		For {
			Set tIndex = $Order(tReferenceMapSorted(tIndex))
			If tIndex="" Quit
			Set tTargetEntryNumber = $Piece(tReferenceMapSorted(tIndex),"|",1)
			Set tSourceEntryNumber = $Piece(tReferenceMapSorted(tIndex),"|",2)
			#; Skip the Medications-related entries that we already marked earlier.
			If ($Data(pBundleEntriesToSkip(tSourceEntryNumber)))||($Data(tMedications("MedicationOrderByEntry",tTargetEntryNumber)))||($Data(tMedications("MedicationOrderByEntry",tSourceEntryNumber))) Continue
			Set tReferenceValue = $Piece(tReferenceMapSorted(tIndex),"|",3,99)
			Set tSC = ..MoveResourceToContained(pBundle, tReferenceValue, tTargetEntryNumber, tSourceEntryNumber, .pBundleEntriesToSkip, .tContainedResourceIndex)
			If $$$ISERR(tSC) Quit
		}
		
		#; Specialized "move to contained" logic for Medication-related resources.
		#;
		#; When done, each MedicationOrder can contain:
		#;   Medication
		#;   Practitioner
		#;   MedicationDispense, which contains Medication
		#;   MedicationAdministrations
		
		#; First, pull Medication resources into MedicationDispense resources.
		Set tEntryIndex = ""
		For {
			Set tEntryIndex = $Order(tMedications("MedicationDispenseByEntry",tEntryIndex))
			If tEntryIndex="" Quit
			Set tMDRef = tMedications("MedicationDispenseByEntry",tEntryIndex)
			Set tMMRef = $Get(tMedications("MedicationDispenseMedicationRefByEntry",tEntryIndex))
			If tMMRef'="" {
				Set tMMEntryIndex = $Get(tMedications("MedicationByFullUrl",tMMRef))
				If tMMEntryIndex'="" {
					Set tSC = ..MoveResourceToContained(pBundle, tMMRef, tEntryIndex, tMMEntryIndex, .pBundleEntriesToSkip, .tContainedResourceIndex)
					If $$$ISERR(tSC) Quit
				}
			}
		}
		#; Next, pull Medication, MedicationDispense, MedicationAdministration,
		#; and Practitioner resources into MedicationOrder resources.
		Set tEntryIndex = ""
		For {
			Set tEntryIndex = $Order(tMedications("MedicationOrderByEntry",tEntryIndex))
			If tEntryIndex="" Quit
			Set tMORef = tMedications("MedicationOrderByEntry",tEntryIndex)
			#; Pull in Medication.
			Set tMMRef = $Get(tMedications("MedicationOrderMedicationRefByEntry",tEntryIndex))
			If tMMRef'="" {
				Set tMMEntryIndex = $Get(tMedications("MedicationByFullUrl",tMMRef))
				If tMMEntryIndex'="" {
					Set tSC = ..MoveResourceToContained(pBundle, tMMRef, tEntryIndex, tMMEntryIndex, .pBundleEntriesToSkip, .tContainedResourceIndex)
					If $$$ISERR(tSC) Quit
				}
			}
			#; Pull in Practitioner.
			Set tPRRef = $Get(tMedications("MedicationOrderPrescriberRefByEntry",tEntryIndex))
			If tPRRef'="" {
				Set tPREntryIndex = $Get(tEntryIndex("ByFullUrl", tPRRef))
				If tPREntryIndex'="" {
					Set tSC = ..MoveResourceToContained(pBundle, tPRRef, tEntryIndex, tPREntryIndex, .pBundleEntriesToSkip, .tContainedResourceIndex)
					If $$$ISERR(tSC) Quit
				}
			}
			#; Pull in MedicationDispense.
			Set tMDEntryIndex = $Get(tMedications("MedicationDispenseMedicationOrderRefByFullUrl",tMORef))
			If tMDEntryIndex'="" {
				Set tSC = ..MoveResourceToContained(pBundle, tMORef, tEntryIndex, tMDEntryIndex, .pBundleEntriesToSkip, .tContainedResourceIndex)
				If $$$ISERR(tSC) Quit
			}
			#; Pull in MedicationAdministrations.
			Set tMAEntryIndex = ""
			For {
				Set tMAEntryIndex = $Order(tMedications("MedicationAdministrationMedicationOrderRefByEntry",tMAEntryIndex))
				If tMAEntryIndex="" Quit
				If tMedications("MedicationAdministrationMedicationOrderRefByEntry",tMAEntryIndex)=tMORef {
					Set tSC = ..MoveResourceToContained(pBundle, tMORef, tEntryIndex, tMAEntryIndex, .pBundleEntriesToSkip, .tContainedResourceIndex)
					If $$$ISERR(tSC) Quit
				}
			}
		}
		
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Copy the resource in Bundle entry pSourceEntryNumber into a contained
/// resource within the resource in Bundle entry pTargetEntryNumber.  When
/// looping through all the Bundle entries for main DTL processing, the
/// Bundle entry at pSourceEntryNumber will be skipped.
Method MoveResourceToContained(pBundle As HS.FHIR.vDSTU2.Model.Resource.Bundle, pReferenceValue As %String, pTargetEntryNumber As %String, pSourceEntryNumber As %String, ByRef pBundleEntriesToSkip As %String, ByRef pContainedResourceIndex As %Integer) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSourceBundleEntry = pBundle.entry.GetAt(pSourceEntryNumber)
		Set tSC = ##class(HS.FHIR.Utils).GetResourceTypeFromContainer(tSourceBundleEntry.resource, .tSourceResourceType)
		If $$$ISERR(tSC) Quit
		#; GetReferenceMap ignores properties named "patient", "subject"
		#; and "encounter", but doesn't ignore reference properties that
		#; could be Patient or Encounter *in addition to* other possible
		#; resource types (e.g., Appointment actor).  Catch the remaining
		#; Patient and Encounter references here, and ignore.
		If (tSourceResourceType="Patient")||(tSourceResourceType="Encounter") Quit
		Set tSourceResource = $Property(tSourceBundleEntry.resource, tSourceResourceType).%ConstructClone(1)
		Set tTargetBundleEntry = pBundle.entry.GetAt(pTargetEntryNumber)
		Set tSC = ##class(HS.FHIR.Utils).GetResourceFromContainer(tTargetBundleEntry.resource, .tTargetResource)
		If $$$ISERR(tSC) Quit
		Set tTargetResourceType = tTargetResource.%ClassName(0)
		#; FHIR spec: Contained resources SHALL NOT contain additional contained resources.
		#; Despite that spec, this module will possibly cause contained resources to have
		#; contained resources.  This is being allowed because the re-factored Bundle
		#; will be used for nothing other than input to the FHIR to SDA3 DTL transform.
		Set tNewId = "contained"_$i(pContainedResourceIndex)
		Set tReferencesToUpdate(pReferenceValue, 0) = "#"_tNewId
		Set tSC = tSourceResource.SetId(tNewId)
		If $$$ISERR(tSC) Quit
		#; FHIR spec: Contained resources SHALL NOT contain any narrative.
		Set tSourceResource.text = ""
		Set tSC = tTargetResource.SetContained(tSourceResource)
		If $$$ISERR(tSC) Quit
		Set tSC = tTargetResource.UpdateReferences(.tReferencesToUpdate, 0)
		If $$$ISERR(tSC) Quit
		Set pBundleEntriesToSkip(pSourceEntryNumber) = ""
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// GetSendingFacilityCode derives a SendingFacilityCode
/// from a FHIR Patient resource.
Method GetSendingFacilityCode(pHSFHIRObj As HS.FHIR.vDSTU2.Model.Resource.Patient, ByRef pSendingFacilityCode As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pSendingFacilityCode = ""
	
	Try {
		#; Derive a SendingFacility code from a FHIR Patient resource.
		
		If pHSFHIRObj.%ClassName(0)'="Patient" Set tSC = $$$ERROR($$$GeneralError, "SendingFacility requires Patient resource") Quit
		
		#; If managingOrganization has only a display value, then use that.
		If (pHSFHIRObj.managingOrganization.display.value'="")&&(pHSFHIRObj.managingOrganization.reference.value="") Set pSendingFacilityCode = pHSFHIRObj.managingOrganization.display.value Quit
		
		If pHSFHIRObj.managingOrganization.reference.value'="" {
			#; If managingOrganization has a reference to a contained Organization
			#; resource, then find the contained resource and use the first found
			#; of name or identifier value in the contained resource.
			If $Extract(pHSFHIRObj.managingOrganization.reference.value)="#" {
				Set tSC = ##class(HS.FHIR.Utils).GetContainedResource(pHSFHIRObj, pHSFHIRObj.managingOrganization.reference.value, "Organization", .tResource)
				If $$$ISERR(tSC) Quit
				For i = 1:1:tResource.identifier.Count() {
					Set pSendingFacilityCode = tResource.identifier.GetAt(i).value.value
					If pSendingFacilityCode'="" Quit
				}
				If (pSendingFacilityCode="")&&(tResource.name.value'="") Set pSendingFacilityCode = tResource.name.value Quit
			}
		}
		If pSendingFacilityCode'="" Quit
		
		If pHSFHIRObj.identifier.Count()=1 {
			#; If the Patient resource has one and only one identifier, then use the
			#; system value of the identifier as the basis for SendingFacility code.
			Set tIdentifier = pHSFHIRObj.identifier.GetAt(1)
			Set tAssigner = tIdentifier.assigner.display.value
			If tAssigner'="" {
				Set pSendingFacilityCode = ##class(HS.Data.OIDMap).GetCodeForURI(tAssigner, tAssigner)
			} Else {
				Set tSystem = tIdentifier.system.value
				If tSystem'="" Set pSendingFacilityCode = ##class(HS.Data.OIDMap).GetCodeForURI(tSystem, tSystem)
			}
		} Else {
			#; Otherwise look for an identifier that looks like an MRN.
			For i = 1:1:pHSFHIRObj.identifier.Count() {
				Set tIdentifier = pHSFHIRObj.identifier.GetAt(i)
				If ($IsObject(tIdentifier.type))&&($IsObject(tIdentifier.type.coding))&&(tIdentifier.type.coding.Count()>0)&&(tIdentifier.type.coding.GetAt(1).code.value="MR") {
					Set tAssigner = tIdentifier.assigner.display.value
					If tAssigner'="" {
						Set pSendingFacilityCode = ##class(HS.Data.OIDMap).GetCodeForURI(tAssigner, tAssigner)
					} Else {
						Set tSystem = tIdentifier.system.value
						If tSystem'="" Set pSendingFacilityCode = ##class(HS.Data.OIDMap).GetCodeForURI(tSystem, tSystem)
					}
				}
				If pSendingFacilityCode'="" Quit
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// ExecuteDTL executes the specified DTL and adds the output
/// SDA entry to the SDA Container that is being constructed
/// from the FHIR request.
Method ExecuteDTL(pDTLClass As %String, pFHIRResource As HS.FHIR.vDSTU2.Model.Base.DomainResource, pSDAContainer As HS.SDA3.Container, ByRef pNoDTLClass As %String, ByRef pAux As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		$$$HSTRACE("Resource input to DTL", "pFHIRResource", pFHIRResource)
		
		#; If pDTLClass is an existing class, then use it for the
		#; transform.  Otherwise, log a warning and return success.
		Set tTargetDTL = ..GetDTLPackageAndClass(pDTLClass)
		If tTargetDTL="" {
			If $i(pNoDTLClass(pDTLClass))
			Quit
		}
		
		Set tSC = $ClassMethod(tTargetDTL, "Transform", pFHIRResource, .tSDAEntry, .pAux)
		If $$$ISERR(tSC) Quit
		
		$$$HSTRACE("SDA entry from DTL", tSDAEntry.%ClassName(0), tSDAEntry)
		
		If tSDAEntry.%ClassName(0)="Patient" {
			Set $Property(pSDAContainer, "Patient") = tSDAEntry
		} Else {
			Set tCollectionName = $ClassMethod(tSDAEntry.%ClassName(1), "StartXMLList")
			Set tCollectionName = $Extract(tCollectionName,2,*-1)
			Set tCollection = $Property(pSDAContainer, tCollectionName)
			Set tSC = tCollection.Insert(tSDAEntry)
			Set $Property(pSDAContainer, tCollectionName) = tCollection
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// GetDTLPackageAndClass searches the Custom package (if any) first
/// for the specified DTL class, and if not found there then searches
/// the standard package for the specified DTL class.
Method GetDTLPackageAndClass(pDTLClass As %String) As %String
{
	If (..CustomDTLPackage'="")&&(##class(%Dictionary.ClassDefinition).%ExistsId(..CustomDTLPackage_"."_pDTLClass)) {
		Quit ..CustomDTLPackage_"."_pDTLClass
	} ElseIf ##class(%Dictionary.ClassDefinition).%ExistsId(..#STANDARDPACKAGE_"."_pDTLClass) {
		Quit ..#STANDARDPACKAGE_"."_pDTLClass
	} Else {
		Quit ""
	}
}

Method GetOrderTypeMapping(ByRef pOrderType As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; FHIR DiagnosticOrder and DiagnosticReport do not have a
		#; property that corresponds to HL7v2 ORC-29 (OrderType).
		#; Build a table to map FHIR DiagnosticReport category
		#; (corresponds to HL7v2 OBR-24) to SDA LabOrder, RadOrder,
		#; or OtherOrder.  This table is based on value set
		#; http://hl7.org/fhir/ValueSet/diagnostic-service-sections.
		Set pOrderType("AU") = "OTH"
		Set pOrderType("AUDIOLOGY") = "OTH"
		Set pOrderType("BG") = "LAB"
		Set pOrderType("BLOOD GASES") = "LAB"
		Set pOrderType("BLB") = "OTH"
		Set pOrderType("BLOOD BANK") = "OTH"
		Set pOrderType("CG") = "OTH"
		Set pOrderType("CYTOGENETICS") = "OTH"
		Set pOrderType("CH") = "LAB"
		Set pOrderType("CHEMISTRY") = "LAB"
		Set pOrderType("CP") = "OTH"
		Set pOrderType("CYTOPATHOLOGY") = "OTH"
		Set pOrderType("CT") = "RAD"
		Set pOrderType("CAT SCAN") = "RAD"
		Set pOrderType("CTH") = "LAB"
		Set pOrderType("CARDIAC CATHETERIZATION") = "LAB"
		Set pOrderType("CUS") = "LAB"
		Set pOrderType("CARDIAC ULTRASOUND") = "LAB"
		Set pOrderType("EC") = "LAB"
		Set pOrderType("ELECTROCARDIAC") = "LAB"
		Set pOrderType("EN") = "LAB"
		Set pOrderType("ELECTRONEURO") = "LAB"
		Set pOrderType("GE") = "OTH"
		Set pOrderType("GENETICS") = "OTH"
		Set pOrderType("HM") = "LAB"
		Set pOrderType("HEMATOLOGY") = "LAB"
		Set pOrderType("ICU") = "OTH"
		Set pOrderType("BEDSIDE ICU MONITORING") = "OTH"
		Set pOrderType("IMM") = "LAB"
		Set pOrderType("IMMUNOLOGY") = "LAB"
		Set pOrderType("LAB") = "LAB"
		Set pOrderType("LABORATORY") = "LAB"
		Set pOrderType("MB") = "LAB"
		Set pOrderType("MICROBIOLOGY") = "LAB"
		Set pOrderType("MCB") = "LAB"
		Set pOrderType("MYCOBACTERIOLOGY") = "LAB"
		Set pOrderType("MYC") = "OTH"
		Set pOrderType("MYCOLOGY") = "OTH"
		Set pOrderType("NMR") = "RAD"
		Set pOrderType("NUCLEAR MAGNETIC RESONANCE") = "RAD"
		Set pOrderType("NMS") = "OTH"
		Set pOrderType("NUCLEAR MEDICINE SCAN") = "OTH"
		Set pOrderType("NRS") = "OTH"
		Set pOrderType("NURSING SERVICE MEASURES") = "OTH"
		Set pOrderType("OSL") = "LAB"
		Set pOrderType("OUTSIDE LAB") = "LAB"
		Set pOrderType("OT") = "LAB"
		Set pOrderType("OCCUPATIONAL THERAPY") = "LAB"
		Set pOrderType("OTH") = "OTH"
		Set pOrderType("OTHER") = "OTH"
		Set pOrderType("OUS") = "OTH"
		Set pOrderType("OB ULTRASOUND") = "OTH"
		Set pOrderType("PF") = "LAB"
		Set pOrderType("PULMONARY FUNCTION") = "LAB"
		Set pOrderType("PHR") = "OTH"
		Set pOrderType("PHARMACY") = "OTH"
		Set pOrderType("PHY") = "OTH"
		Set pOrderType("PHYSICIAN") = "OTH"
		Set pOrderType("PT") = "OTH"
		Set pOrderType("PHYSICAL THERAPY") = "OTH"
		Set pOrderType("RAD") = "RAD"
		Set pOrderType("RADIOLOGY") = "RAD"
		Set pOrderType("RC") = "LAB"
		Set pOrderType("RESPIRATORY CARE") = "LAB"
		Set pOrderType("RT") = "OTH"
		Set pOrderType("RADIATION THERAPY") = "OTH"
		Set pOrderType("RUS") = "RAD"
		Set pOrderType("RADIOLOGY ULTRASOUND") = "RAD"
		Set pOrderType("RX") = "LAB"
		Set pOrderType("RADIOGRAPH") = "LAB"
		Set pOrderType("SP") = "OTH"
		Set pOrderType("SURGICAL PATHOLOGY") = "OTH"
		Set pOrderType("SR") = "LAB"
		Set pOrderType("SEROLOGY") = "LAB"
		Set pOrderType("TX") = "LAB"
		Set pOrderType("TOXICOLOGY") = "LAB"
		Set pOrderType("VR") = "LAB"
		Set pOrderType("VIROLOGY") = "LAB"
		Set pOrderType("VUS") = "OTH"
		Set pOrderType("VASCULAR ULTRASOUND") = "OTH"
		Set pOrderType("XRC") = "OTH"
		Set pOrderType("CINERADIOGRAPH") = "OTH"
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// ProcessSDAResponse evaluates the SDA response message
/// and formulates a FHIR response message.
Method ProcessSDAResponse(pFHIRRequest As HS.Message.FHIR.Request, pSDAXMLResponse As HS.Message.XMLMessage, pSC As %Status, ByRef pFHIRResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	If '$IsObject($Get(pFHIRResponse)) Set pFHIRResponse = ##class(HS.Message.FHIR.Response).%New()
	
	Try {
		#; For now, we're not using the info contained in the pSDAXMLResponse.
		
		Set pFHIRResponse.ContentType = pFHIRRequest.ContentType
		
		If $$$ISOK(pSC) Set pFHIRResponse.Status = 200 Quit
		
		Set tFHIRStream = ##class(%Stream.TmpCharacter).%New()
		Set tText = $system.Status.GetErrorText(pSC)
		Set tSC = ##class(HS.FHIR.Utils).CreateOutcomeSingleIssueStream(pFHIRRequest.ContentType, .tFHIRStream, "error", "exception", tText, , , tText, , , pFHIRRequest.FormatFHIROutput)
		If $$$ISERR(tSC) Quit
		
		Set tSC = pFHIRResponse.Payload.CopyFrom(tFHIRStream)
		If $$$ISERR(tSC) Quit
		
		Set pFHIRResponse.Status = 500
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>TraceOperations</Value>
</Value>
<Value name="2">
<Value>CustomDTLPackage</Value>
</Value>
<Value name="3">
<Value>TargetConfigName</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
