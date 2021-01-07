Include HS.HC

/// HS.FHIR.FromSDA.DTL.Base provides the common logic for invoking
/// the SDA-to-FHIR DTL transformation with the FHIR DSTU2 DTL
/// framework. This class is intended to act as a base class for a
/// business host that invokes this logic.
Class HS.FHIR.FromSDA.DTL.Base Extends HS.HC.Util.Trace.Helper [ DependsOn = HS.SDA3.Vaccination, Inheritance = right ]
{

Parameter HSDEPLOY = 1;

Parameter SETTINGS = "CustomDTLPackage,FHIRFormat,FormatFHIROutput";

/// Specifies the DTL class package that has the custom versions of
/// the DTLs that are called by this business process. If this
/// setting has a value, and a custom version of a DTL is found in
/// the package, then the DTL from that package is used instead of
/// the standard version.
Property CustomDTLPackage As %String(MAXLEN = 128);

/// The FHIR format to use for FHIR request message payload.
Property FHIRFormat As %String(DISPLAYLIST = ",XML,JSON", VALUELIST = ",XML,JSON") [ InitialExpression = "XML" ];

/// Value of true for this setting causes any created FHIR payload
/// to include indentation and line feed characters to enhance
/// readability of the raw content.
Property FormatFHIROutput As %Boolean [ InitialExpression = 0 ];

Parameter STANDARDPACKAGE = "HS.FHIR.DTL.FromSDA";

Method InitializeMessage(ByRef pFHIRRequest As HS.Message.FHIR.Request, pFHIRFormat As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Initialize an HS FHIR request message with Interaction=transaction.
		#; tFHIRRequest will be sent only when ..TransmissionMode=transaction
		#; or ..TransmissionMode=batch.  When ..TransmissionMode=individual,
		#; tFHIRRequest is used as a template for the individual HS FHIR
		#; requests that are sent for each resource.
		Set pFHIRRequest = ##class(HS.Message.FHIR.Request).%New()
		Set pFHIRRequest.Interaction="transaction"
		Set pFHIRRequest.Type="Bundle"
		#; The logic in this class is currently all DSTU2-specific.
		#; Therefore use the DSTU2 formal mime types.
		If $ZConvert(pFHIRFormat,"U")["JSON" {
			Set pFHIRRequest.ContentType="application/json+fhir"
		} ElseIf $ZConvert(pFHIRFormat,"U")["XML" {
			Set pFHIRRequest.ContentType="application/xml+fhir"
		}
		Set pFHIRRequest.FHIRVersion = "DSTU2"
		
		#; Allow the opportunity to use DTL to modify properties of the
		#; HS FHIR request message itself, except for the Payload.
		#; Do not warn if no DTL found.
		Set tTargetDTL = ..GetDTLPackageAndClass("FHIRRequest")
		If tTargetDTL'="" {
			Set tSC = $ClassMethod(tTargetDTL, "Transform", pFHIRRequest, .tNewRequest)
			If $$$ISERR(tSC) Quit
			Kill pFHIRRequest
			Set pFHIRRequest = tNewRequest.%ConstructClone(1)
			Kill tNewRequest
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method InitializeBundle(ByRef pBundle As HS.FHIR.vDSTU2.Model.Resource.Bundle, pTransmissionMode As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Initialize the Bundle.
		Set pBundle = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle).%New()
		If (pTransmissionMode="batch")||(pTransmissionMode="transaction")||(pTransmissionMode="document") {
			Set tSC = pBundle.SetType(pTransmissionMode)
		} Else {
			Set tSC = pBundle.SetType("collection")
		}
		If $$$ISERR(tSC) Quit
		
		#; Allow the opportunity to use DTL to modify properties of
		#; the FHIR Bundle, except for the Bundle entries themselves.
		#; Do not warn if no DTL found.
		Set tTargetDTL = ..GetDTLPackageAndClass("FHIRBundle")
		If tTargetDTL'="" {
			Set tSC = $ClassMethod(tTargetDTL, "Transform", pBundle, .tNewBundle)
			If $$$ISERR(tSC) Quit
			Kill pBundle
			Set pBundle = tNewBundle.%ConstructClone(1)
			Kill tNewBundle
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method TransformSDAContainer(pSDAContainer As HS.SDA3.Container, pPatientResourceId As %String = "", pTransmissionMode As %String = "", ByRef pBundle As HS.FHIR.vDSTU2.Model.Resource.Bundle, ByRef pFHIRStream As %Stream.GlobalCharacter) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pBundle)) {
			Set pBundle = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle).%New()
		}
		
		#; This loop assumes that if there is a Patient object in the
		#; SDA Container, then it is the first object in the Container.
		#; It also assumes that if there are any Encounters in the
		#; Container, then they immediately follow the Patient object,
		#; if there is one, and precede all other object types in the
		#; Container.
		Set tAux("PatientResourceId") = pPatientResourceId
		While pSDAContainer.GetNextSDA(.tSDAType, .tSDA, .tSC) {
			If $$$ISERR(tSC) Quit
			Set tSC = ..TransformSDAEntry(tSDAType, tSDA, pPatientResourceId, pTransmissionMode, .pBundle, .tNoDTLClass, .tAux, .tCTDResourceIds)
			If $$$ISERR(tSC) Quit
		}
		If $$$ISERR(tSC) Quit
		
		If pBundle.entry.Count()=0 {
			Set tSC = $$$ERROR($$$GeneralError, "No applicable DTL found for SDA Container")
			Quit
		}
		
		Set tDTLClass = ""
		For {
			Set tDTLClass = $Order(tNoDTLClass(tDTLClass))
			If tDTLClass="" Quit
			Set tSDAType = $Piece(tDTLClass,".",$Length(tDTLClass,"."))
			Set tEntryText = $Select(tNoDTLClass(tDTLClass)>1:"entries",1:"entry")
			$$$LOGWARNING(tNoDTLClass(tDTLClass)_" SDA "_tSDAType_" "_tEntryText_" not processed due to transform not supported")
		}
		
		#; transaction mode is the only mode where the entries in the
		#; Bundle are allowed to refer to one another, because the
		#; Bundle is considered one atomic transaction.  batch and
		#; individual modes consider the entries to be totally separate
		#; interactions, and we cannot assume interdependence between
		#; them, and so should not move the contained resources out
		#; to separate entry resources.
		If pTransmissionMode="transaction" {
			Set tSC = ..MoveContainedResources(.pBundle, ..FHIRFormat, ..FormatFHIROutput)
			If $$$ISERR(tSC) Quit
		}
		
		Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(..FHIRFormat, pBundle, .pFHIRStream, ..FormatFHIROutput)
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method TransformSDAEntry(pSDAType As %String, pSDA As HS.SDA3.SuperClass, pPatientResourceId As %String = "", pTransmissionMode As %String = "", ByRef pBundle As HS.FHIR.vDSTU2.Model.Resource.Bundle, ByRef pNoDTLClass As %String, ByRef pAux As %String, ByRef pCTDResourceIds As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Clear out the auxiliary data array, except for the Patient
		#; resource id and Encounter resources ids, which are needed
		#; across all transforms for the current Container.
		Set tSub = ""
		For {
			Set tSub = $Order(pAux(tSub))
			If tSub="" Quit
			If (tSub="PatientResourceId")||(tSub="EncounterResourceIds") Continue
			Kill pAux(tSub)
		}
		
		#; Medications need specialized processing due to the complexity of the SDA to FHIR mapping.
		If pSDAType="Medication" {
			Set tSC = ..ProcessSDAMedication(pSDA, pTransmissionMode, .pBundle, .pAux, .pCTDResourceIds)
			Quit
		}
		
		Set tDTLClass = pSDAType
		
		#; With the standard functionality, the resource ids that are
		#; assigned to each resource are unique per resource type within
		#; the Bundle, and the resource ids have not been used by the
		#; local resource repository.  The business host that receives
		#; the Bundle has the option of using the resource ids unchanged,
		#; or of applying its own logic to change them.
		
		#; If a LabOrder has no Results then the *DiagnosticOrder transform
		#; is used.  Otherwise, the *DiagnosticReport transform is used.
		If (pSDAType="LabOrder")||(pSDAType="RadOrder") {
			If 'pSDA.IsDefined("Result") {
				Set tDTLClass = pSDAType_"DiagnosticOrder"
			} ElseIf (pSDA.Result.ResultItems.Count()=0)&&(pSDA.Result.ResultText="")&&(pSDA.Result.Stream.Size=0) {
				Set tDTLClass = pSDAType_"DiagnosticOrder"
			} ElseIf pSDA.Result.ResultItems.Count()>0 {
				Set tDTLClass = pSDAType_"DiagnosticReport"
				Set tSC = ..AddResultItemIds(pSDAType, .pSDA, .pAux)
				If $$$ISERR(tSC) Quit
				Set tSC = ..AddDiagnosticOrderId(pSDAType, .pSDA, .pAux)
				If $$$ISERR(tSC) Quit
			} ElseIf (pSDA.Result.ResultText'="")||(pSDA.Result.Stream.Size>0) {
				Set tDTLClass = pSDAType_"DiagnosticReport"
				Set tSC = ..AddResultId(pSDAType, .pSDA, .pAux)
				If $$$ISERR(tSC) Quit
				Set tSC = ..AddDiagnosticOrderId(pSDAType, .pSDA, .pAux)
				If $$$ISERR(tSC) Quit
			}
		}
		
		Set tTargetDTL = ..GetDTLPackageAndClass(tDTLClass)
		If tTargetDTL="" {
			If $i(pNoDTLClass(tDTLClass))
			Quit
		}
		
		Set tTargetType = $ClassMethod(tTargetDTL, "GetTargetType")
		Set tTargetResourceType = $Piece(tTargetType, ".", $Length(tTargetType,"."))
		
		Set tResourceId = ..GetResourceId(pSDA)
		
		#; pAux("PatientResourceId") may already be populated with an explicit
		#; value that was passed in with the input message.  If that is the
		#; case, then do not override that value.  Otherwise, if that pAux
		#; value is blank, then it can only be populated with the Patient
		#; resource id that was generated in this method. 
		If pSDAType="Patient" {
			If pAux("PatientResourceId")="" Set pAux("PatientResourceId") = tResourceId
		}
		
		If (pSDAType="Encounter")&&(pSDA.EncounterNumber'="") {
			Set pAux("EncounterResourceIds", pSDA.EncounterNumber) = tResourceId
		}
		
		Set pAux("ResourceId") = tResourceId
		
		Set tSC = ..AddContainedIds(pSDAType, .pSDA, .pCTDResourceIds)
		If $$$ISERR(tSC) Quit
		
		$$$HSTRACE("SDA Property After Modify", pSDAType, pSDA)
		
		Set tSC = $ClassMethod(tTargetDTL, "Transform", pSDA, .tFHIRResource, .pAux)
		If $$$ISERR(tSC) Quit
		
		Kill pSDA
		
		$$$HSTRACE("FHIR Resource from DTL", "DTLName,"_tFHIRResource.%ClassName(0)_" resource", tTargetDTL, tFHIRResource)
		
		Set tSC = ..AddBundleEntry(.pBundle, pTransmissionMode, tFHIRResource)
		If $$$ISERR(tSC) Quit
		
		Kill tFHIRResource
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method MoveContainedResources(ByRef pBundle As HS.FHIR.vDSTU2.Model.Resource.Bundle, pFHIRFormat As %String, pFormatFHIROutput As %Boolean) As %Status
{
	Set tSC = $$$OK
	
	Try {
		$$$HSTRACE("Bundle before moving resources", "pBundle", pBundle)
		
		#; The logic is repeated until no more new entries are added to the Bundle.
		
		Set tUpdated = 0
		Set tOldBundleCount = 0
		For {
			#; Move contained resources to be Bundle entry resources instead.
			Set tBundleCount = pBundle.entry.Count()
			Set tMovedCount = 0
			For i = tOldBundleCount+1:1:tBundleCount {
				Set tSC = ##class(HS.FHIR.Utils).GetResourceFromContainer(pBundle.entry.GetAt(i).resource, .tEntryResource)
				If $$$ISERR(tSC) Quit
				If tEntryResource.contained.Count()=0 Continue
				Kill tReferencesToContained
				For j = tEntryResource.contained.Count():-1:1 {
					Set tSC = ##class(HS.FHIR.Utils).GetResourceFromContainer(tEntryResource.contained.GetAt(j), .tContainedResource)
					If $$$ISERR(tSC) Quit
					Set tContainedResourceType = tContainedResource.%ClassName(0)
					If tContainedResourceType="Specimen" Continue
					Set tContainedId = tContainedResource.id.value
					Set tUrl = tContainedResourceType_"/"_tContainedId
					Set tReferencesToContained("#"_tContainedId, i) = tUrl
					#; It is possible that the transforms themselves will create
					#; redundant resources (resources with the same type and id)
					#; so check for them here and omit if redundant.
					If '$Data(tUrls(tUrl)) {
						#; Build a new Bundle entry and insert into the Bundle.
						Set tSC = ..AddPUTRequestAndEntry(.pBundle, tContainedResource)
						If $$$ISERR(tSC) Quit
						Set tUrls(tUrl) = ""
					}
					Do tEntryResource.contained.RemoveAt(j)
					If $i(tMovedCount) Set tUpdated = 1
				}
				#; Because the previously-contained resources were referred-to only
				#; from within the current entry resource, call UpdateReferences
				#; for the current entry resource now.
				Set tSC = tEntryResource.UpdateReferences(.tReferencesToContained, i)
				If $$$ISERR(tSC) Quit
				Kill tReferencesToContained
			}
			If tMovedCount=0 Quit
			Set tOldBundleCount = tBundleCount
		}
		
		If tUpdated {
			$$$HSTRACE("Bundle after moving resources", "pBundle", pBundle)
		} Else {
			$$$HSTRACE("Bundle had no contained resources to move")
		}

	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Transform an SDA3 Medication object into FHIR MedicationOrder, Medication(s),
/// MedicationDispense and MedicationAdminstration(s).
Method ProcessSDAMedication(pSDA As HS.SDA3.Medication, pTransmissionMode As %String, ByRef pBundle As HS.FHIR.vDSTU2.Model.Resource.Bundle, ByRef pAux As %String, ByRef pCTDResourceIds As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; A single SDA Medication object is used as the source for one or two
		#; FHIR Medication resources, one MedicationOrder resource, zero or one
		#; MedicationDispense resource, and zero to N MedicationAdministration
		#; resources.
		
		#; Create a Medication resource, which will be referenced by the MedicationOrder resource.
		Set tTargetDTL = ..GetDTLPackageAndClass("MedicationFromOrdered")
		If tTargetDTL="" $$$LOGWARNING("DTL class MedicationFromOrdered not found") Quit
		Set pAux("ResourceId") = ..GetResourceId(pSDA)
		Set pAux("MedicationResourceId") = pAux("ResourceId")
		Set tSC = $ClassMethod(tTargetDTL, "Transform", pSDA, .tFHIRResource, .pAux)
		If $$$ISERR(tSC) Quit
		$$$HSTRACE("FHIR Resource from DTL", "DTLName,"_tFHIRResource.%ClassName(0)_" resource", tTargetDTL, tFHIRResource)
		Set tSC = ..AddBundleEntry(.pBundle, pTransmissionMode, tFHIRResource)
		If $$$ISERR(tSC) Quit
		
		#; Create the MedicationOrder resource.
		Set tTargetDTL = ..GetDTLPackageAndClass("MedicationOrder")
		If tTargetDTL="" $$$LOGWARNING("DTL class MedicationOrder not found") Quit
		Set pAux("ResourceId") = ..GetResourceId(pSDA)
		Set pAux("MedicationOrderResourceId") = pAux("ResourceId")
		Set tSC = ..AddContainedIds("Medication", .pSDA, .pCTDResourceIds)
		If $$$ISERR(tSC) Quit
		Set tSC = $ClassMethod(tTargetDTL, "Transform", pSDA, .tFHIRResource, .pAux)
		If $$$ISERR(tSC) Quit
		$$$HSTRACE("FHIR Resource from DTL", "DTLName,"_tFHIRResource.%ClassName(0)_" resource", tTargetDTL, tFHIRResource)
		Set tSC = ..AddBundleEntry(.pBundle, pTransmissionMode, tFHIRResource)
		If $$$ISERR(tSC) Quit
		
		#; If no DrugProduct, then quit.
		If ('pSDA.IsDefined("DrugProduct"))||((pSDA.DrugProduct.Code="")&&(pSDA.DrugProduct.Description="")) Quit
		
		#; Create a Medication resource, which will be referenced by the MedicationDispense resource.
		Set tTargetDTL = ..GetDTLPackageAndClass("MedicationFromDrugProduct")
		If tTargetDTL="" $$$LOGWARNING("DTL class MedicationFromDrugProduct not found") Quit
		Set pAux("ResourceId") = ..GetResourceId(pSDA)
		Set pAux("MedicationResourceId") = pAux("ResourceId")
		Set tSC = $ClassMethod(tTargetDTL, "Transform", pSDA.DrugProduct, .tFHIRResource, .pAux)
		If $$$ISERR(tSC) Quit
		$$$HSTRACE("FHIR Resource from DTL", "DTLName,"_tFHIRResource.%ClassName(0)_" resource", tTargetDTL, tFHIRResource)
		Set tSC = ..AddBundleEntry(.pBundle, pTransmissionMode, tFHIRResource)
		If $$$ISERR(tSC) Quit
		
		#; Create the MedicationDispense resource.
		Set tTargetDTL = ..GetDTLPackageAndClass("MedicationDispense")
		If tTargetDTL="" $$$LOGWARNING("DTL class MedicationDispense not found") Quit
		Set pAux("ResourceId") = ..GetResourceId()
		Set tSC = $ClassMethod(tTargetDTL, "Transform", pSDA, .tFHIRResource, .pAux)
		If $$$ISERR(tSC) Quit
		$$$HSTRACE("FHIR Resource from DTL", "DTLName,"_tFHIRResource.%ClassName(0)_" resource", tTargetDTL, tFHIRResource)
		Set tSC = ..AddBundleEntry(.pBundle, pTransmissionMode, tFHIRResource)
		If $$$ISERR(tSC) Quit
		
		If pSDA.Administrations.Count()>0 {
			Set tTargetDTL = ..GetDTLPackageAndClass("MedicationAdministration")
			If tTargetDTL="" $$$LOGWARNING("DTL class MedicationAdministration not found") Quit
			For i = 1:1:pSDA.Administrations.Count() {
				#; The MedicationAdministration DTL transforms one SDA3 Administration
				#; object into one FHIR MedicationAdministration resource.
				Set pAux("MedicationAdministrationPosition") = i
				Set tObj = pSDA.Administrations.GetAt(i)
				Set tSC = ..AddContainedIds("Administration", .tObj, .pCTDResourceIds)
				If $$$ISERR(tSC) Quit
				Set tSC = $ClassMethod(tTargetDTL, "Transform", pSDA, .tFHIRResource, .pAux)
				If $$$ISERR(tSC) Quit
				$$$HSTRACE("FHIR Resource from DTL", "DTLName,"_tFHIRResource.%ClassName(0)_" resource", tTargetDTL, tFHIRResource)
				Set tSC = ..AddBundleEntry(.pBundle, pTransmissionMode, tFHIRResource)
				If $$$ISERR(tSC) Quit
			}
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

/// Generated method to add generated FHIR resource ids to the
/// CodeTableDetail-typed properties of the current SDA3 object.
/// pCTDResourceIds is an array of resource ids already assigned
/// for given Code/Description/SDACodingStandard combinations.
/// It is needed to help consolidate all the references to a
/// given CodeTableDetail entry to a single reference.
Method AddContainedIds(pSDAType As %String, ByRef pSDA, ByRef pCTDResourceIds As %String) As %Status [ CodeMode = objectgenerator ]
{
	#dim tPropDef As %Dictionary.CompiledProperty
	
	Set tIdProperty = "InternalReference"
	
	Do %code.WriteLine($Char(9)_"Set tSC = $$$OK")
	
	Set tSDARoot = "HS.SDA3."
	Set tCTDRoot = tSDARoot_"CodeTableDetail."
	
	Set tCTDRootLen = $Length(tCTDRoot)
	
	#; These map to FHIR Practitioner.
	Set tIncludeList(tCTDRoot_"CareProvider") = ""
	Set tIncludeList(tCTDRoot_"ReferralDoctor") = ""
	Set tIncludeList(tCTDRoot_"FamilyDoctor") = ""
	#; This maps to FHIR Location and Organization.
	Set tIncludeList(tCTDRoot_"HealthCareFacility") = ""
	#; This maps to FHIR BodySite.
	Set tIncludeList(tCTDRoot_"BodyPart") = ""
	#; This maps to FHIR Medication.
	Set tIncludeList(tCTDRoot_"DrugProduct") = ""
	
	#; Use in-line code to build an array of SDA3 classes to check
	#; for CodeTableDetail type properties.  The CompileAfter
	#; directive at the top of this class is due to this logic.
	Do $system.OBJ.GetPackageList(.tClasses, "HS.SDA3")
	
	Set tClass = ""
	For {
		Set tClass = $Order(tClasses(tClass))
		If tClass="" Quit
		Set tObj = ##class(%Dictionary.ClassDefinition).%OpenId(tClass)
		If '$IsObject($Get(tObj)) Continue
		If tObj.Super["HS.SDA3.SuperClass" Set tSDATypesTemp(tClass) = ""
		Kill tObj
	}
	
	#; Arrange the more frequently-used SDA3 types to be first.
	Set i = 0
	For tSDAType = "Patient","Encounter","Problem","Diagnosis","LabOrder","Observation" {
		Set tSDAType = tSDARoot_tSDAType
		If $i(i) Set tSDATypes(i) = tSDAType
		Kill tSDATypesTemp(tSDAType)
	}
	#; Add the rest of the types.
	Set tSDAType = ""
	For {
		Set tSDAType = $Order(tSDATypesTemp(tSDAType))
		If tSDAType="" Quit
		If $i(i) Set tSDATypes(i) = tSDAType
	}
	
	Set tFoundClass = 0
	Set i = ""
	For {
		Set i = $Order(tSDATypes(i))
		If i="" Quit
		
		Set tClassName = tSDATypes(i)
		Set tSDAType = $Piece(tClassName,".",$Length(tClassName,"."))
		
		Set tClsObj = ##class(%Dictionary.CompiledClass).%OpenId(tClassName)
		
		Set tFoundProp = 0

		For n=1:1:tClsObj.Properties.Count() {
			Set tPropDef = tClsObj.Properties.GetAt(n)
			Set tPropType = tPropDef.Type
			Set tPropName = tPropDef.Name
			Set tPropRef = "pSDA."_tPropName
			
			If $Data(tIncludeList(tPropType)) {
				Set tShortType = $Extract(tPropType, tCTDRootLen+1, *)
				If tFoundProp=0 {
					Do %code.WriteLine($Char(9)_$Select(tFoundClass=0:"If",1:"ElseIf")_" pSDAType="""_tSDAType_""" {")
					Set tFoundProp = 1
				}
				Set tFoundClass = 1
				If tPropDef.Collection="list" {
					Do %code.WriteLine($Char(9,9)_"If (pSDA.IsDefined("""_tPropName_"""))&&("_tPropRef_".Count()>0) {")
					Do %code.WriteLine($Char(9,9,9)_"For i=1:1:"_tPropRef_".Count() {")
					Do %code.WriteLine($Char(9,9,9,9)_"If (("_tPropRef_".GetAt(i).Code'="""")||("_tPropRef_".GetAt(i).Description'=""""))&&("_tPropRef_".GetAt(i)."_tIdProperty_"="""") {")
					Do %code.WriteLine($Char(9,9,9,9,9)_"Set tKey="_tPropRef_".GetAt(i).Code_""/""_"_tPropRef_".GetAt(i).Description_""/""_"_tPropRef_".GetAt(i).SDACodingStandard")
					Do %code.WriteLine($Char(9,9,9,9,9)_"If '$Data(pCTDResourceIds("""_tShortType_""",tKey)) {")
					Do %code.WriteLine($Char(9,9,9,9,9,9)_"Set pCTDResourceIds("""_tShortType_""",tKey)=..GetResourceId(pSDA)")
					Do %code.WriteLine($Char(9,9,9,9,9)_"}")
					Do %code.WriteLine($Char(9,9,9,9,9)_"Set "_tPropRef_".GetAt(i)."_tIdProperty_"=pCTDResourceIds("""_tShortType_""",tKey)")
					Do %code.WriteLine($Char(9,9,9,9)_"}")
					Do %code.WriteLine($Char(9,9,9)_"}")
				} Else {
					Do %code.WriteLine($Char(9,9)_"If (pSDA.IsDefined("""_tPropName_"""))&&(("_tPropRef_".Code'="""")||("_tPropRef_".Description'=""""))&&("_tPropRef_"."_tIdProperty_"="""") {")
					Do %code.WriteLine($Char(9,9,9)_"Set tKey="_tPropRef_".Code_""/""_"_tPropRef_".Description_""/""_"_tPropRef_".SDACodingStandard")
					Do %code.WriteLine($Char(9,9,9)_"If '$Data(pCTDResourceIds("""_tShortType_""",tKey)) {")
					Do %code.WriteLine($Char(9,9,9,9)_"Set pCTDResourceIds("""_tShortType_""",tKey)=..GetResourceId(pSDA)")
					Do %code.WriteLine($Char(9,9,9)_"}")
					Do %code.WriteLine($Char(9,9,9)_"Set "_tPropRef_"."_tIdProperty_"=pCTDResourceIds("""_tShortType_""",tKey)")
					#; Special case for HealthCareFacility Organization.
					If tPropName="HealthCareFacility" {
						Set txPropName = "HealthCareFacility.Organization"
						Set txPropRef = "pSDA."_txPropName
						Set txShortType = "Organization"
						Do %code.WriteLine($Char(9,9,9)_"If "_txPropRef_"."_tIdProperty_"="""" {")
						Do %code.WriteLine($Char(9,9,9,9)_"Set tKey="_txPropRef_".Code_""/""_"_txPropRef_".Description_""/""_"_txPropRef_".SDACodingStandard")
						Do %code.WriteLine($Char(9,9,9,9)_"If '$Data(pCTDResourceIds("""_txShortType_""",tKey)) {")
						Do %code.WriteLine($Char(9,9,9,9,9)_"Set pCTDResourceIds("""_txShortType_""",tKey)=..GetResourceId(pSDA)")
						Do %code.WriteLine($Char(9,9,9,9)_"}")
						Do %code.WriteLine($Char(9,9,9,9)_"Set "_txPropRef_"."_tIdProperty_"=pCTDResourceIds("""_txShortType_""",tKey)")
						Do %code.WriteLine($Char(9,9,9)_"}")
					}
				}
				Do %code.WriteLine($Char(9,9)_"}")
			}
		}
		If tFoundProp=1 Do %code.WriteLine($Char(9)_"}")
	}
	
	Do %code.WriteLine($Char(9)_"Quit tSC")
	
	Quit $$$OK
}

/// AddResultId adds a reference id to a Result that
/// is just ResultText or a Stream.
Method AddResultId(pSDAType As %String, ByRef pSDA, ByRef pAux As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set pAux("ResultResourceId") = ..GetResourceId(pSDA)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// AddDiagnosticOrderId adds a reference id to a LabOrder
/// that is going to need to generate a DiagnosticReport
/// resource that contains a DiagnosticOrder resource.
Method AddDiagnosticOrderId(pSDAType As %String, ByRef pSDA, ByRef pAux As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set pAux("OrderResourceId") = ..GetResourceId(pSDA)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// AddResultItemIds adds a reference id to all ResultItems
/// on an SDA LabOrder or OtherOrder.  This reference id
/// can then be used by the DTL transforms and subtransforms
/// to set contained resource id values and the reference
/// values that point to them.
Method AddResultItemIds(pSDAType As %String, ByRef pSDA, ByRef pAux As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		For i = 1:1:pSDA.Result.ResultItems.Count() {
			Set pAux("ResultItemResourceIds", i) = ..GetResourceId(pSDA.Result.ResultItems.GetAt(i))
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method AddBundleEntry(pBundle As HS.FHIR.vDSTU2.Model.Resource.Bundle, pTransmissionMode As %String, pResource As HS.FHIR.vDSTU2.Model.Base.DomainResource) As %Status
{
	If pTransmissionMode="transaction" {
		Set tSC = ..AddPUTRequestAndEntry(.pBundle, pResource)
	} ElseIf pTransmissionMode="batch" {
		Set tSC = ..AddPOSTRequestAndEntry(.pBundle, pResource)
	} ElseIf pTransmissionMode="individual" {
		Set tSC = ..AddOtherEntry(.pBundle, pResource)
	}
	
	Quit tSC
}

/// AddPOSTRequestAndEntry creates a new Bundle entry object,
/// creates a request property with method=POST (create),
/// adds the request property to the entry, adds the specified
/// resource to the entry, and adds the entry to the Bundle.
Method AddPOSTRequestAndEntry(pBundle As HS.FHIR.vDSTU2.Model.Resource.Bundle, pResource As HS.FHIR.vDSTU2.Model.Base.DomainResource) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tNewEntry = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Entry).%New()
		Set tEntryRequest = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Request).%New()
		Set tSC = tNewEntry.SetFullUrl(pResource.%ClassName(0)_"/"_pResource.id.value)
		Set tSC = tEntryRequest.SetUrl(pResource.%ClassName(0)_"/"_pResource.id.value)
		Set tSC = pResource.SetId("")
		If $$$ISERR(tSC) Quit
		#; POST = create
		Do tEntryRequest.SetMethod("POST")
		Set tNewEntry.request = tEntryRequest
		Set tSC = tNewEntry.SetResource(pResource)
		If $$$ISERR(tSC) Quit
		Set tSC = pBundle.entry.Insert(tNewEntry)
		If $$$ISERR(tSC) Quit
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// AddPUTRequestAndEntry creates a new Bundle entry object,
/// creates a request property with method=PUT, adds the
/// request property to the entry, adds the specified resource
/// to the entry, and adds the entry to the specified Bundle.
Method AddPUTRequestAndEntry(pBundle As HS.FHIR.vDSTU2.Model.Resource.Bundle, pResource As HS.FHIR.vDSTU2.Model.Base.DomainResource) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tNewEntry = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Entry).%New()
		Set tEntryRequest = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Request).%New()
		Set tSC = tNewEntry.SetFullUrl(pResource.%ClassName(0)_"/"_pResource.id.value)
		Set tSC = tEntryRequest.SetUrl(pResource.%ClassName(0)_"/"_pResource.id.value)
		If $$$ISERR(tSC) Quit
		#; PUT = update
		Do tEntryRequest.SetMethod("PUT")
		Set tNewEntry.request = tEntryRequest
		Set tSC = tNewEntry.SetResource(pResource)
		If $$$ISERR(tSC) Quit
		Set tSC = pBundle.entry.Insert(tNewEntry)
		If $$$ISERR(tSC) Quit
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// AddOtherEntry creates a new Bundle entry object, without
/// a request object, adds the specified resource to the
/// entry, and adds the entry to the specified Bundle.
Method AddOtherEntry(pBundle As HS.FHIR.vDSTU2.Model.Resource.Bundle, pResource As HS.FHIR.vDSTU2.Model.Base.DomainResource) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tNewEntry = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Entry).%New()
		Set tEntryRequest = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Request).%New()
		Set tSC = tNewEntry.SetFullUrl(pResource.%ClassName(0)_"/"_pResource.id.value)
		If $$$ISERR(tSC) Quit
		Set tSC = tNewEntry.SetResource(pResource)
		If $$$ISERR(tSC) Quit
		Set tSC = pBundle.entry.Insert(tNewEntry)
		If $$$ISERR(tSC) Quit
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Either get the resource id from the SDA object, or if none
/// is on the object, then generate an id and return that.
Method GetResourceId(pSDA) As %String
{
	#; For now, simply return a UUID.
	Quit $ZConvert($system.Util.CreateGUID(),"L")
}

}
