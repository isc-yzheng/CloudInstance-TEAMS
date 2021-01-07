Include HS.HC

Class HS.FHIR.vSTU3.Repository.Resource.Abstract Extends HS.FHIR.vCommon.ResourceBase [ Abstract, ClassType = persistent ]
{

/// A key useable for disambiguating version-specific cached data
Parameter VERSIONKEY As %String = "STU3";

/// The Package for the Resource Subclasses of this class
Parameter STORAGEPKG As %String = "HS.FHIR.vSTU3.Repository.Resource.";

Parameter INDEXGLOBAL = {##class(HS.FHIR.vCommon.StorageUtils).GetIndexGlobal(%classname)};

Parameter DATAGLOBAL = {##class(HS.FHIR.vCommon.StorageUtils).GetDataGlobal(%classname)};

Parameter STREAMGLOBAL = {##class(HS.FHIR.vCommon.StorageUtils).GetStreamGlobal(%classname)};

Parameter COUNTERGLOBAL = {##class(HS.FHIR.vCommon.StorageUtils).GetCounterGlobal(%classname)};

Parameter MODELPACKAGE = "HS.FHIR.vSTU3.Model";

/// Comma-delimited list of search params that are defined in the FHIR
/// standard (STU3), but that are not currently supported by HealthShare. The
/// parameter value should start and end with commas. Note that all composite
/// type params are currently not supported and do not need to be included here.
Parameter EXCLUDEPARAMS;

Parameter SEARCHTABLEPACKAGE As %String = "NSLocal.FHIR.Search.vSTU3";

/// The name of the table in the search package that will store the searchable
/// values common to all resource types, which will be searched in a	
/// "search-all" interaction. Also, the name of the class in the storage
/// package (HS.FHIR.vSTU3.Repository.Resource) that contains the definitions of the
/// search parameters common to all types in its SearchParams XData block.
Parameter BASERESOURCE = "Resource";

Method IndexHumanName(pParamName As %String, pXPath As %String) As %Status
{
	try {
		if (..Format="JSON") {
			Set tResults = 0
			Set tSC = ..EvaluateXPathDynamicObj(..ResourceObject, .pXPath, .tResults)
			For tI = 1:1:tResults {
				If tResults(tI)="" Continue
				Set tHumanName = tResults(tI)
				Set tValue = ""
				if (tHumanName.text'="") { set tValue = tHumanName.text }
				else {
					set tValue = ""
					if $IsObject(tHumanName.given) {
						set tIterator = tHumanName.given.%GetIterator()
						for {
							If 'tIterator.%GetNext(.tPropName, .tData) Quit
							If tData="" Continue
							set tValue = tValue_$S(tValue="":"", 1:" ")_tData
						}
					}
					if (tHumanName.family'="") { set tValue = tValue_$S(tValue="":"", 1:" ")_tHumanName.family }
				}
				Continue:tValue=""
				set tSC = ..AddToSearchTableEntry(.pParamName, .tValue)
				quit:$$$ISERR(tSC)
			}
			quit
		}
		
		set tSC = ##class(HS.FHIR.Utils).EvaluateXPathExpression(..XPathDoc, pXPath, ..ResourceSchema, .tResultType, .tResults)
		quit:$$$ISERR(tSC)
		// For each HumanName, create an index from either the "text" property if
		// not null, or a concatenation of the other properties if it is.
		for tI=1:1:tResults.Count() {
			set tHumanName = tResults.GetAt(tI)
			set tValue = ""
			if (tHumanName.text.value'="") { set tValue = tHumanName.text.value }
			else {
				for tJ=1:1:tHumanName.given.Count() {
					set tName = tHumanName.given.GetAt(tJ).value
					continue:tName=""
					set tValue = tValue_$S(tValue="":"", 1:" ")_tName
				}
				if (tHumanName.family.value'="") { set tValue = tValue_$S(tValue="":"", 1:" ")_tHumanName.family.value }
			}
			continue:tValue=""
			set tSC = ..AddToSearchTableEntry(pParamName, tValue) quit:$$$ISERR(tSC)
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

/// pType must be either null ("") or a valid resource type with a storage
/// class that will be returned by a call to GetStorageClass().<br/>
/// This method caches search parameters defined in the SearchParams XData of
/// the HS.FHIR.vSTU3.Repository.Resource.[type] class in %HSFHIRSearchParams, if not
/// already cached, as well as the search params common to all resource types,
/// which are defined in HS.FHIR.vSTU3.Repository.Resource.Resource, if not already
/// cached. If the input value is null or ..#BASERESOURCE ("Resource"), only
/// the common search params will be cached. If the given type is already
/// cached in %HSFHIRSearchParams, then this method is effectively a no-op.<br/>
/// The format of %HSFHIRSearchParams is: <br/>
/// %HSFHIRSearchParams(..#VERSIONKEY, resourceType,0) = resource type includes an XPath with complex predicate (0 or 1)<br/>
/// An XPath is considered to have a "complex predicate" if either the predicate is not in the last piece of the XPath,
/// or there are multiple predicates.<br/>
/// %HSFHIRSearchParams(..#VERSIONKEY, resourceType,searchParam) = paramType^xpath^refType1~refType2~...~^custom <br/>
/// %HSFHIRSearchParams(..#VERSIONKEY, "Patient","deceased") = "token^f:Patient/f:deceasedBoolean | f:Patient/f:deceasedDateTime^^1" <br/>
/// %HSFHIRSearchParams(..#VERSIONKEY, "Patient","given") = "string~f:Patient/f:name/f:given~~0" <br/>
/// %HSFHIRSearchParams(..#VERSIONKEY, "MedicationAdministration","effectivetime") = "date^f:MedicationAdministration/f:effectiveDateTime | f:MedicationAdministration/f:effectivePeriod^^0" <br/>
/// %HSFHIRSearchParams(..#VERSIONKEY, "Appointment","practitioner") = "reference^f:Appointment/f:participant/f:actor^Practitioner^0" <br/>
/// %HSFHIRSearchParams(..#VERSIONKEY, "Resource","_lastUpdated") = "date^f:Resource/f:meta/f:lastUpdated^^0" <br/>
/// <ul>
/// <li>resourceType: The type of resource being searched</li>
/// <li>searchParam: The name of the search param, as is appears in the spec (ie, not normalized via <method>NormalizeParamName</method>)</li>
/// <li>paramType: The type of the search param. Currently we support token, date, string, reference, quantity, number, and uri.</li>
/// <li>xpath: The xpath value the describes the location of the value to be indexed/searched. This value will be XML-unescaped
///  from the original SearchParameter resource, in case the original value contains any XML escape sequences, like &apos; for example.</li>
/// <li>refType[x]: If paramType="reference", this field may be used to constrain the types of references that this search
///  param indexes. For example, the Appointment practitioner search param searches the participant.actor property, but only
///  references of type Practitioner. refTypes is "~"-delimited, and begins and ends with "~". A value of "*" may be used to
///  indicate that this search param indexes and searches all reference types.</li>
/// <li>custom: If custom=1, then the search indices for this param are created by a method in the storage
///  class for this type. The name of the method is the param name normalized via <method>NormalizeParamName</method>, so the method for param
///  onset-info is onsetInfo(), for example. This is needed when the indices for a certain search parameter are more complex than
///  simply "the value at [xpath]". If custom=1, the other fields technically aren't needed, since the method should handle all the
///  details of indexing, but can be included for reference.</li>
/// </ul>
ClassMethod CacheSearchParams(pType As %String, pCustomStoragePkg As %String) As %Status
{
	try {
		set tSC = $$$OK
		// This may be called with pType="" for a type-less search (ie, interaction="search-all"),
		//  which is fine. Just set it to the base resource type just to get through this method.
		if (pType="") { set pType=..#BASERESOURCE }
		if $D(%HSFHIRSearchParams(..#VERSIONKEY, pType))&&$D(%HSFHIRSearchParams(..#VERSIONKEY, ..#BASERESOURCE)) { quit }

		#dim tSearchParamsXDataName = "SearchParameters"
		// Resources in the repository may have a different schema, but the search param XData
		// uses the default schema.
		#dim tSearchParamsXDataSchema = ..#MODELPACKAGE_".Resource"
		// This comes from the number of concepts in "http://hl7.org/fhir/resource-types"
		// See http://hl7.org/fhir/STU3/valueset-resource-types.html
		#dim tNumResourceTypesSTU3 = 119
		#dim tBundle As HS.FHIR.vSTU3.Model.Resource.Bundle
		#dim tEntry As HS.FHIR.vSTU3.Model.Resource.Bundle.Entry
		#dim tResourceContainer As HS.FHIR.vSTU3.Model.Base.ResourceContainer
		#dim tSearchParameter As HS.FHIR.vSTU3.Model.Resource.SearchParameter

		set tComplexPredicate = 0
		
		for tResourceType=..#BASERESOURCE,pType {
			set tStorageClassName = ..GetStorageClass(tResourceType, .tSC, $Get(pCustomStoragePkg)) quit:$$$ISERR(tSC)
			if ($D(%HSFHIRSearchParams(..#VERSIONKEY, tResourceType))) { continue }
			// retrieve search param XData
			set tXDataObj = ##class(%Dictionary.CompiledXData).%OpenId(tStorageClassName_"||"_tSearchParamsXDataName)
			if ('$IsObject(tXDataObj)) { set tSC = $$$ERROR($$$GeneralError, "Class has no search params XData: "_tStorageClassName) quit }
			set tXDataStream = tXDataObj.Data
			set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR("XML", tXDataStream, .tBundle, tSearchParamsXDataSchema) quit:$$$ISERR(tSC)
			for tI=1:1:tBundle.entry.Count() {
				set tEntry = tBundle.entry.GetAt(tI)
				set tResourceContainer = tEntry.resource
				set tSearchParameter = tResourceContainer.SearchParameter
				set tName = tSearchParameter.name.value
				// Skip search params that are explicitly excluded by the EXCLUDEPARAMS parameter
				if ($PARAMETER(tStorageClassName, "EXCLUDEPARAMS") [ (","_tName_",")) { continue }
				set tType = tSearchParameter.type.value
				// composite params are not currently supported
				continue:tType="composite"
				// Some SearchParameters are used for multiple resource types, in which case the xpath
				// value will contain expressions for each type. Only cache the ones for the current
				// resource type.
				set tOrigXPath = tSearchParameter.xpath.value
				set tXPath = ""
				set tXPathType = ""
				for tJ=1:1:$L(tOrigXPath,"|") {
					set tOneOrigXPath = $ZSTRIP($P(tOrigXPath,"|",tJ), "<>W")
					if ($P(tOneOrigXPath,"/") '= ("f:"_tResourceType)) { continue }
					set tXPath = tXPath_$S(tXPath="":"", 1:" | ")_tOneOrigXPath
					set tTempOneOrigXPath = tOneOrigXPath
					if tResourceType="Resource" set $Piece(tTempOneOrigXPath,"/",1)="f:"_pType
					set tSC = ##class(HS.FHIR.Utils).GetTypeForXPath(tTempOneOrigXPath, tSearchParamsXDataSchema, .tOneOrigXPathType)
					if $$$ISERR(tSC) $$$LOGERROR("Error getting type for XPath """_tTempOneOrigXPath_""": "_$system.Status.GetOneErrorText(tSC)) continue
					set tXPathType = tXPathType_$S(tXPathType="":"", 1:" | ")_tOneOrigXPathType
					// An XPath is considered to have a "complex predicate" if either the predicate is
					// not in the last piece of the XPath, or there are multiple predicates.
					if 'tComplexPredicate {
						set tBracketCount = 0
						set tCurrentPiece = 1
						set tPredPieces(tCurrentPiece) = 0
						for tZ = 1:1:$Length(tOneOrigXPath) {
							set tC = $extract(tOneOrigXPath,tZ)
							if tC="/" {
								if tBracketCount=0 set tCurrentPiece = tCurrentPiece + 1 set tPredPieces(tCurrentPiece) = 0
							} elseif tC="[" {
								set tBracketCount = tBracketCount + 1
								set tPredPieces(tCurrentPiece) = 1
							} elseif tC="]" {
								set tBracketCount = tBracketCount - 1
							}
						}
						set tPredCount = 0
						for tZ = 1:1:tCurrentPiece if tPredPieces(tZ)=1 set tPredCount = tPredCount + 1
						if (tPredCount>1) {
							set tComplexPredicate = 1
						} elseif (tPredCount=1)&&(tPredPieces(tCurrentPiece)=0) {
							set tComplexPredicate = 1	
						}
					}
				}
				// The value may be XML escaped. For example, a predicate condition may contain single
				// quotes escaped as "&#39;". Unescape it.
				set tXPath = $ZCVT(tXPath,"I","XML")
				if (tType '= "reference") { set tRefTypes="" }
				else {
					// TO DO: Update this for STU3
					// In DSTU2 there are 2 reference type parameters with 0 targets, "composition" and "message"
					// on Bundle. We aren't going to support those so it doesn't really matter. There are several
					// that support all 93 resource types in DSTU2, so rather than cache them all, we will use "*"
					// to mean "any".
					if (tSearchParameter.target.Count()=tNumResourceTypesSTU3)||(tSearchParameter.target.Count()=0) {
						set tRefTypes = "*"
					}
					else {
						set tRefTypes = "~"
						for tJ=1:1:tSearchParameter.target.Count() {
							set tRefTypes = tRefTypes_tSearchParameter.target.GetAt(tJ).value_"~"
						}
					}
				}
				set tCustom = ##class(%Dictionary.MethodDefinition).%ExistsId(tStorageClassName_"||"_..NormalizeParamName(tName))
				// Without a path or a custom method to create indices, we can't create indices for this param
				if (tXPath="")&&(tCustom=0) { continue }
				set %HSFHIRSearchParams(..#VERSIONKEY, tResourceType, tName) = tType_"^"_tXPath_"^"_tRefTypes_"^"_tCustom_"^"_tXPathType
			}
		}
		set %HSFHIRSearchParams(..#VERSIONKEY, tResourceType, 0) = tComplexPredicate
		quit:$$$ISERR(tSC)
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

/// Based on definitions as seen at:
/// <li>http://hl7.org/fhir/STU3/compartmentdefinition.html
/// <li>http://hl7.org/fhir/STU3/compartmentdefinition-patient.html
/// <li>http://hl7.org/fhir/STU3/compartmentdefinition-encounter.html
/// <li>http://hl7.org/fhir/STU3/compartmentdefinition-relatedperson.html
/// <li>http://hl7.org/fhir/STU3/compartmentdefinition-practitioner.html
/// <li>http://hl7.org/fhir/STU3/compartmentdefinition-device.html
ClassMethod BuildCompartmentDef(pFHIRVersion As %String)
{
	// Format is:
	// %CompartmentDef(fhirVersion, compartment, resourceType, searchParam) = ""
	
	set %CompartmentDef(pFHIRVersion,"Encounter","ChargeItem","context") = ""
	set %CompartmentDef(pFHIRVersion,"Encounter","Claim","encounter") = ""
	set %CompartmentDef(pFHIRVersion,"Encounter","ClinicalImpression","context") = ""
	set %CompartmentDef(pFHIRVersion,"Encounter","Communication","context") = ""
	set %CompartmentDef(pFHIRVersion,"Encounter","CommunicationRequest","context") = ""
	set %CompartmentDef(pFHIRVersion,"Encounter","Composition","encounter") = ""
	set %CompartmentDef(pFHIRVersion,"Encounter","Condition","context") = ""
	set %CompartmentDef(pFHIRVersion,"Encounter","DiagnosticReport","encounter") = ""
	set %CompartmentDef(pFHIRVersion,"Encounter","DocumentReference","encounter") = ""
	set %CompartmentDef(pFHIRVersion,"Encounter","ExplanationOfBenfit","encounter") = ""
	set %CompartmentDef(pFHIRVersion,"Encounter","MedicationAdministration","context") = ""
	set %CompartmentDef(pFHIRVersion,"Encounter","MedicationRequest","context") = ""
	set %CompartmentDef(pFHIRVersion,"Encounter","NutritionOrder","encounter") = ""
	set %CompartmentDef(pFHIRVersion,"Encounter","Observation","encounter") = ""
	set %CompartmentDef(pFHIRVersion,"Encounter","Procedure","encounter") = ""
	set %CompartmentDef(pFHIRVersion,"Encounter","ProcedureRequest","context") = ""
	set %CompartmentDef(pFHIRVersion,"Encounter","QuestionnaireResponse","context") = ""
	set %CompartmentDef(pFHIRVersion,"Encounter","RequestGroup","encounter") = ""
	set %CompartmentDef(pFHIRVersion,"Encounter","VisionPrescription","encounter") = ""

	set %CompartmentDef(pFHIRVersion,"Patient","Account","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","AdverseEvent","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","AllergyIntolerance","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","AllergyIntolerance","recorder") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","AllergyIntolerance","asserter") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Appointment","actor") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","AppointmentResponse","actor") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","AuditEvent","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","AuditEvent","agent.patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","AuditEvent","entity.patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Basic","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Basic","author") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","BodySite","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","CarePlan","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","CarePlan","performer") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","CareTeam","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","CareTeam","participant") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","ChargeItem","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Claim","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Claim","payee") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","ClaimResponse","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","ClinicalImpression","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Communication","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Communication","sender") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Communication","recipient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","CommunicationRequest","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","CommunicationRequest","sender") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","CommunicationRequest","recipient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","CommunicationRequest","requester") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Composition","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Composition","author") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Composition","attester") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Condition","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Condition","asserter") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Consent","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Coverage","policy-holder") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Coverage","subscriber") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Coverage","beneficiary") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Coverage","payor") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","DetectedIssue","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","DeviceRequest","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","DeviceRequest","requester") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","DeviceRequest","performer") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","DeviceUseStatement","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","DiagnosticReport","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","DocumentManifest","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","DocumentManifest","author") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","DocumentManifest","recipient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","DocumentReference","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","DocumentReference","author") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","EligibilityRequest","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Encounter","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","EnrollmentRequest","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","EpisodeOfCare","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","ExplanationOfBenefit","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","ExplanationOfBenefit","payee") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","FamilyMemberHistory","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Flag","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Goal","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Group","member") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","ImagingManifest","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","ImagingManifest","author") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","ImagingStudy","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Immunization","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","ImmunizationRecommendation","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","List","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","List","source") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","MeasureReport","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Media","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","MedicationAdministration","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","MedicationAdministration","performer") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","MedicationAdministration","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","MedicationDispense","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","MedicationDispense","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","MedicationDispense","receiver") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","MedicationRequest","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","MedicationStatement","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","NutritionOrder","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Observation","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Observation","performer") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Patient","link") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Person","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Procedure","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Procedure","performer") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","ProcedureRequest","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","ProcedureRequest","performer") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Provenance","target.subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Provenance","target.patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Provenance","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","QuestionnaireResponse","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","QuestionnaireResponse","author") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","ReferralRequest","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","ReferralRequest","requester") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","RelatedPerson","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","RequestGroup","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","RequestGroup","participant") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","ResearchSubject","individual") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","RiskAssessment","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Schedule","actor") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","Specimen","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","SupplyDelivery","patient") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","SupplyRequest","requester") = ""
	set %CompartmentDef(pFHIRVersion,"Patient","VisionPrescription","patient") = ""

	set %CompartmentDef(pFHIRVersion,"RelatedPerson","AdverseEvent","recorder") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","AllergyIntolerance","asserter") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","Appointment","actor") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","AppointmentResponse","actor") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","Basic","author") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","CarePlan","performer") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","CareTeam","participant") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","ChargeItem","enterer") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","ChargeItem","participant-actor") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","Claim","payee") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","Communication","sender") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","Communication","recipient") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","CommunicationRequest","sender") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","CommunicationRequest","recipient") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","CommunicationRequest","requester") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","Composition","author") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","Condition","asserter") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","Coverage","policy-holder") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","Coverage","subscriber orpayor") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","DocumentManifest","author") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","DocumentReference","author") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","Encounter","participant") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","ExplanationOfBenefit","payee") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","ImagingManifest","author") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","MedicationAdministration","performer") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","MedicationStatement","source") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","Observation","performer") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","Patient","link") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","Person","link") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","Procedure","performer") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","ProcedureRequest","performer") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","Provenance","agent") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","QuestionnaireResponse","author") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","QuestionnaireResponse","source") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","RequestGroup","participant") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","Schedule","actor") = ""
	set %CompartmentDef(pFHIRVersion,"RelatedPerson","SupplyRequest","requester") = ""

	set %CompartmentDef(pFHIRVersion,"Practitioner","Account","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","AdverseEvent","recorder") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","AllergyIntolerance","recorder") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","AllergyIntolerance","asserter") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Appointment","actor") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","AppointmentResponse","actor") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","AuditEvent","agent") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Basic","author") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","CarePlan","performer") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","CareTeam","participant") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","ChargeItem","enterer") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","ChargeItem","participant-actor") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Claim","enterer") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Claim","provider") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Claim","payee") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Claim","care-team") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","ClaimResponse","request-provider") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","ClinicalImpression","assessor") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Communication","sender") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Communication","recipient") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","CommunicationRequest","sender") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","CommunicationRequest","recipient") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","CommunicationRequest","requester") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Composition","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Composition","author") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Composition","attester") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Condition","asserter") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","DetectedIssue","author") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","DeviceRequest","requester") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","DeviceRequest","performer") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","DiagnosticReport","performer") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","DocumentManifest","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","DocumentManifest","author") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","DocumentManifest","recipient") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","DocumentReference","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","DocumentReference","author") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","DocumentReference","authenticator") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","EligibilityRequest","enterer") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","EligibilityRequest","provider") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","EligibilityResponse","request-provider") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Encounter","practitioner") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Encounter","participant") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","EpisodeOfCare","care-manager") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","ExplanationOfBenefit","enterer") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","ExplanationOfBenefit","provider") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","ExplanationOfBenefit","payee") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","ExplanationOfBenefit","care-team") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Flag","author") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Group","member") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","ImagingManifest","author") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Immunization","practitioner") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Linkage","author") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","List","source") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Media","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Media","operator") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","MedicationAdministration","performer") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","MedicationDispense","performer") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","MedicationDispense","receiver") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","MedicationRequest","requester") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","MedicationStatement","source") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","MessageHeader","receiver") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","MessageHeader","author") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","MessageHeader","responsible") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","MessageHeader","enterer") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","NutritionOrder","provider") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Observation","performer") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Patient","general-practitioner") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","PaymentNotice","provider") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","PaymentReconciliation","request-provider") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Person","practitioner") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","PractitionerRole","practitioner") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Procedure","performer") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","ProcedureRequest","performer") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","ProcedureRequest","requester") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","ProcessRequest","provider") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","ProcessResponse","request-provider") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Provenance","agent") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","QuestionnaireResponse","author") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","QuestionnaireResponse","source") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","ReferralRequest","requester") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","ReferralRequest","recipient") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","RequestGroup","participant") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","RequestGroup","author") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","ResearchStudy","principalinvestigator") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","RiskAssessment","performer") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Schedule","actor") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","Specimen","collector") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","SupplyDelivery","supplier") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","SupplyDelivery","receiver") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","SupplyRequest","requester") = ""
	set %CompartmentDef(pFHIRVersion,"Practitioner","VisionPrescription","prescriber") = ""

	set %CompartmentDef(pFHIRVersion,"Device","Account","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Device","Appointment","actor") = ""
	set %CompartmentDef(pFHIRVersion,"Device","AppointmentResponse","actor") = ""
	set %CompartmentDef(pFHIRVersion,"Device","AuditEvent","agent") = ""
	set %CompartmentDef(pFHIRVersion,"Device","ChargeItem","enterer") = ""
	set %CompartmentDef(pFHIRVersion,"Device","ChargeItem","participant-actor") = ""
	set %CompartmentDef(pFHIRVersion,"Device","Communication","sender") = ""
	set %CompartmentDef(pFHIRVersion,"Device","Communication","recipient") = ""
	set %CompartmentDef(pFHIRVersion,"Device","CommunicationRequest","sender") = ""
	set %CompartmentDef(pFHIRVersion,"Device","CommunicationRequest","recipient") = ""
	set %CompartmentDef(pFHIRVersion,"Device","Composition","author") = ""
	set %CompartmentDef(pFHIRVersion,"Device","DetectedIssue","author") = ""
	set %CompartmentDef(pFHIRVersion,"Device","DeviceComponent","source") = ""
	set %CompartmentDef(pFHIRVersion,"Device","DeviceMetric","source") = ""
	set %CompartmentDef(pFHIRVersion,"Device","DeviceRequest","device") = ""
	set %CompartmentDef(pFHIRVersion,"Device","DeviceRequest","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Device","DeviceRequest","requester") = ""
	set %CompartmentDef(pFHIRVersion,"Device","DeviceRequest","performer") = ""
	set %CompartmentDef(pFHIRVersion,"Device","DeviceUseStatement","device") = ""
	set %CompartmentDef(pFHIRVersion,"Device","DiagnosticReport","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Device","DocumentManifest","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Device","DocumentManifest","author") = ""
	set %CompartmentDef(pFHIRVersion,"Device","DocumentReference","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Device","DocumentReference","author") = ""
	set %CompartmentDef(pFHIRVersion,"Device","Flag","author") = ""
	set %CompartmentDef(pFHIRVersion,"Device","Group","member") = ""
	set %CompartmentDef(pFHIRVersion,"Device","ImagingManifest","author") = ""
	set %CompartmentDef(pFHIRVersion,"Device","List","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Device","List","source") = ""
	set %CompartmentDef(pFHIRVersion,"Device","Media","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Device","MedicationAdministration","device") = ""
	set %CompartmentDef(pFHIRVersion,"Device","MessageHeader","target") = ""
	set %CompartmentDef(pFHIRVersion,"Device","Observation","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Device","Observation","device") = ""
	set %CompartmentDef(pFHIRVersion,"Device","ProcedureRequest","performer") = ""
	set %CompartmentDef(pFHIRVersion,"Device","ProcedureRequest","requester") = ""
	set %CompartmentDef(pFHIRVersion,"Device","Provenance","agent") = ""
	set %CompartmentDef(pFHIRVersion,"Device","QuestionnaireResponse","author") = ""
	set %CompartmentDef(pFHIRVersion,"Device","RequestGroup","author") = ""
	set %CompartmentDef(pFHIRVersion,"Device","RiskAssessment","performer") = ""
	set %CompartmentDef(pFHIRVersion,"Device","Schedule","actor") = ""
	set %CompartmentDef(pFHIRVersion,"Device","Specimen","subject") = ""
	set %CompartmentDef(pFHIRVersion,"Device","SupplyRequest","requester") = ""

	quit
}

/// Returns true if the given search parameter on the given resource type
/// searches of property of type Period, and false otherwise. pParamName must
/// be the name of the search parameter as it appears in the parameter
/// definition, *not* the param name normalized via <method>NormalizeParamName</method>.
/// ie, "date-recorded", not "dateRecorded". If a search parameter searches
/// more than one property, this will return true if any of them is a Period.
/// For example, the "date" parameter on Procedure searches two properties,
/// performedDateTime and performedPeriod.  performedPeriod is a Period, so
/// this method returns true for that parameter.
ClassMethod ParamSearchesPeriod(pResourceType As %String, pParamName As %String) As %Boolean
{
	if '$D(%HSFHIRPeriodParams(..#VERSIONKEY)) {
		set %HSFHIRPeriodParams(..#VERSIONKEY,"Account","period") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"ActivityDefinition","effective") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"CarePlan","activity-date") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"CarePlan","date") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"CareTeam","date") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"ChargeItem","occurrence") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"Composition","period") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"Condition","abatement-date") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"Condition","onset-date") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"Consent","period") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"DeviceRequest","event-date") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"DiagnosticReport","date") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"DocumentReference","period") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"Encounter","date") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"Encounter","location-period") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"EpisodeOfCare","date") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"Flag","date") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"Library","effective") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"Measure","effective") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"Media","date") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"MedicationAdministration","effective-time") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"MedicationStatement","effective") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"NamingSystem","period") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"Observation","date") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"Observation","value-date") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"PlanDefinition","effective") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"PractitionerRole","date") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"Procedure","date") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"ProcedureRequest","occurrence") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"Questionnaire","effective") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"ReferralRequest","occurrence-date") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"ResearchStudy","date") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"ResearchSubject","date") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"Schedule","date") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"ServiceDefinition","effective") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"Specimen","collected") = ""
		set %HSFHIRPeriodParams(..#VERSIONKEY,"Task","period") = ""
	}
	quit $D(%HSFHIRPeriodParams(..#VERSIONKEY,pResourceType,pParamName))
}

/// API
/// In this context, "orphaned" means the resource references a non-existent
/// session.<br>
/// There *should* never be orphaned resources. The deletion of the referenced
/// session should trigger the delete of the resource. Still, this utility
/// is provided in case something goes wrong and orphaned resources are left
/// in the repository.
ClassMethod DeleteOrphanedResources() As %Status
{
	try {
		set tSC = $$$OK
		&sql(DELETE FROM HS_FHIR_vSTU3_Repository_Resource.Abstract
		            WHERE NOT Session IS NULL
		              AND NOT EXISTS (SELECT * FROM HS_FHIR_SessionData.FHIRSession WHERE FHIRSession.Application=$PIECE(Abstract.Session,'||') AND FHIRSession.SessionId=$PIECE(Abstract.Session,'||',2)))
		if (SQLCODE < 0) { set tSC = $$$ERROR($$$GeneralError, "SQL Error "_SQLCODE_", "_$system.SQL.SQLCODE(SQLCODE)) quit }
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

ClassMethod DeleteSessionResources(pSession As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If $Get(pSession)="" {
			Set tSC = $$$ERROR($$$GeneralError, "Session identifier not specified")
			Quit
		}
		
		&sql(DELETE %NOLOCK FROM HS_FHIR_vSTU3_Repository_Resource.Abstract WHERE Session=:pSession)
		
		If (SQLCODE < 0) {
			Set tSC = $$$ERROR($$$GeneralError, "SQL Error "_SQLCODE_", "_$system.SQL.SQLCODE(SQLCODE))
			Quit
		}
		
	} Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

Storage Default
{
<Data name="AbstractDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ResourceType</Value>
</Value>
<Value name="3">
<Value>ResourceId</Value>
</Value>
<Value name="4">
<Value>VersionId</Value>
</Value>
<Value name="5">
<Value>Deleted</Value>
</Value>
<Value name="6">
<Value>LastModified</Value>
</Value>
<Value name="7">
<Value>Format</Value>
</Value>
<Value name="8">
<Value>Verb</Value>
</Value>
<Value name="9">
<Value>Session</Value>
</Value>
<Value name="10">
<Value>Compartments</Value>
</Value>
<Value name="11">
<Value>ResourceStream</Value>
</Value>
<Value name="12">
<Value>ResourceSchema</Value>
</Value>
</Data>
<Data name="ResourceString">
<Attribute>ResourceString</Attribute>
<Structure>node</Structure>
<Subscript>"Resource"</Subscript>
</Data>
<DataLocation>^HS.FHIR.Repo.Data.STU3D</DataLocation>
<DefaultData>AbstractDefaultData</DefaultData>
<IdLocation>^HS.FHIR.Repo.Data.STU3D</IdLocation>
<IndexLocation>^HS.FHIR.Repo.Data.STU3I</IndexLocation>
<StreamLocation>^HS.FHIR.Repo.Data.STU3S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
