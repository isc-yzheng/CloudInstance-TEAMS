Include (HS.HC, HS.FHIRServer)

/// This class provides methods for converting HS response messages into FHIRServer-related response objects.
Class HS.FHIRServer.HC.HSToFHIR
{

/// @API<br>
/// Parse the HS Patient Search response and populate a FHIRServer resultset with FHIR Patient
/// resources derived from that response. This method does no filtering of the response data.<br>
/// @Input pSearchResponse HS Patient Search Response message object.<br>
/// @Input pFHIRVersion Fully qualified numeric FHIR version string (e.g., "3.0.1", "4.0.1")<br>
/// @Input pAffinityDomain Affinity Domain code, used for detecting identifiers that should be interpreted as MPIID.<br>
/// @Input pURIMode "strict" = Assigning Authority codes in the search response must have corresponding entries
///   in the OID Registry, "lenient" = If an Assigning Authority code does not have an entry in the OID Registry
///   then a URL is synthesized for it in the FHIR response.
ClassMethod PatientSearchResponseToFHIR(pSearchResponse As HS.Message.PatientSearchResponse, pFHIRVersion As %String, pAffinityDomainCode As %String, pURIMode As %String = "strict") As HS.FHIRServer.Util.SearchResult
{
	#define AddToArray(%jsonobj,%propname,%addobj) Do:'%jsonobj.%IsDefined(%propname) %jsonobj.%Set(%propname,$$$NewJSONArray) Do %jsonobj.%Get(%propname).%Push(%addobj)
	
	// HS.FHIRServer.Service Search() will set PageSize on the ResultSet later.
	#dim tResultSet As HS.FHIRServer.Util.SearchResult = ##class(HS.FHIRServer.Util.SearchResult).Create()
	
	Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(pAffinityDomainCode, "")
	Set tAffinityDomainURL = ##class(HS.Data.OIDMap).GetURLForCode(pAffinityDomainCode, "")
	
	#dim tPatientMPIMatch As HS.Message.PatientMPIMatch
	
	For tMPIIdx = 1:1:pSearchResponse.MPIIDList.Count() {
		
		Set tPatientMPIMatch = pSearchResponse.MPIIDList.GetAt(tMPIIdx)
		
		Set tMPIID = tPatientMPIMatch.MPIID
		
		#dim tPatient As %Library.DynamicObject
		Set tPatient = $$$NewJSONObject
		Set tPatient.resourceType = "Patient"
		Set tPatient.id = tMPIID
		
		Do tPatient.%Set("active", 1, "boolean")
		
		// NOTE: meta is not required, and is omitted here. Hard-setting versionId to 1
		// could cause problems if the ODS-stored Patient resource is versioned. Cannot
		// set _lastUpdated because PatientSearchResponse does not return LastUpdated.
		
		// AffinityDomain needs to have an entry in the OID Registry,
		// in order to get the system OID or URL to use.
		If tAffinityDomainURL'="" {
			Set tSystem = tAffinityDomainURL
			Set tAssignerDisplay = ""
		} ElseIf tAffinityDomainOID'="" {
			Set tSystem = $Select($Extract(tAffinityDomainOID,1,9)'="urn:oid:":"urn:oid:"_tAffinityDomainOID,1:tAffinityDomainOID)
			Set tAssignerDisplay = pAffinityDomainCode
		} Else {
			Set tSystem = ""
			Set tAssignerDisplay = ""
		}
		Set tIdentifierType = ..MakeCodeableConcept(, , , "MPIID", , , , )
		Set tIdentifier = ..MakeIdentifier(tMPIID, tSystem, "official", tIdentifierType, , , , tAssignerDisplay, , )
		$$$AddToArray(tPatient, "identifier", tIdentifier)
		Set tItemsAdded("identifier", tMPIID_"||"_tSystem) = ""
		
		Do ..PatientMatchToFHIRPatient(tPatientMPIMatch, pFHIRVersion, pAffinityDomainCode, pURIMode, tPatient, .tItemsAdded)
		
		#dim tPatientSearchMatch As HS.Message.PatientSearchMatch
		
		For tMatchIdx = 1:1:tPatientMPIMatch.SearchMatches.Count() {
			Set tPatientSearchMatch = pSearchResponse.Results.GetAt(tPatientMPIMatch.SearchMatches.GetAt(tMatchIdx))
			Do ..PatientMatchToFHIRPatient(tPatientSearchMatch, pFHIRVersion, pAffinityDomainCode, pURIMode, tPatient, .tItemsAdded)
		}
		
		Set tRowNum = tResultSet.AddRow(tMPIIdx, "Patient", tPatient.id, "", "match", "GET", tPatient)
	}
	
	Do tResultSet.%SetIterator(0)
	
	Return tResultSet
}

ClassMethod PatientMatchToFHIRPatient(pPatientMatch As HS.Message.PatientMPIMatch, pFHIRVersion As %String, pAffinityDomainCode As %String, pURIMode As %String = "strict", ByRef pPatient As %Library.DynamicObject, ByRef pItemsAdded)
{
	#define AddToArray(%jsonobj,%propname,%addobj) Do:'%jsonobj.%IsDefined(%propname) %jsonobj.%Set(%propname,$$$NewJSONArray) Do %jsonobj.%Get(%propname).%Push(%addobj)
	
	// NOTE: meta is not required, and is omitted here. Hard-setting versionId to 1
	// could cause problems if the ODS-stored Patient resource is versioned. Cannot
	// set _lastUpdated because PatientSearchResponse does not return LastUpdated.
	
	Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(pAffinityDomainCode, "")
	Set tAffinityDomainURL = ##class(HS.Data.OIDMap).GetURLForCode(pAffinityDomainCode, "")
	
	Set tSSNSystem = 
		$Select(+pFHIRVersion=3:"http://hl7.org/fhir/identifier-type", 1:"http://terminology.hl7.org/CodeSystem/v2-0203")
		
	Set tMRNSystem = 
		$Select(+pFHIRVersion=3:"http://hl7.org/fhir/v2/0203", 1:"http://terminology.hl7.org/CodeSystem/v2-0203")
		
	Set tMaritalStatusSystem = 
		$Select(+pFHIRVersion=3:"http://hl7.org/fhir/v3/MaritalStatus", 1:"http://terminology.hl7.org/CodeSystem/v3-MaritalStatus")
	
	Set tNullFlavorSystem = 
		$Select(+pFHIRVersion=3:"http://hl7.org/fhir/v3/NullFlavor", 1:"http://terminology.hl7.org/CodeSystem/v3-NullFlavor")
	
	Set tSSN = pPatientMatch.SSN
	If tSSN'="" {
		Set tSSNURI = ##class(HS.Data.OIDMap).GetURIForCode("SSN", "")
		If tSSNURI="" Set tSSNURI = "urn:oid:2.16.840.1.113883.4.1"
		Set tItemKey = tSSN_"||"_tSSNURI
		// "SB" (Social Beneficiary Identifier)
		// ISC deems SB to be the more appropriate alternative to SSN and TAXID.
		If '$Data(pItemsAdded("identifier", tItemKey)) {
			Set tIdentifierType = ..MakeCodeableConcept("SB", , tSSNSystem, "SB", , , , )
			Set tIdentifier = ..MakeIdentifier(tSSN, tSSNURI, "official", tIdentifierType, , , , , , )
			$$$AddToArray(pPatient, "identifier", tIdentifier)
			Set pItemsAdded("identifier", tItemKey) = ""
		}
	}
	
	Set tValue = pPatientMatch.MRN
	Set tAACode = pPatientMatch.AssigningAuthority
	Set tSystem = ..GetURI("assigningauthority", tAACode, pURIMode, tAACode)
	Set tItemKey = tValue_"||"_tSystem
	If '$Data(pItemsAdded("identifier", tItemKey)) {
		Set tIdentifierType = ..MakeCodeableConcept("MR", "Medical Record Number", tMRNSystem, "MRN", , , , )
		Set tAssignerDisplay = pPatientMatch.Facility
		Set tIdentifier = ..MakeIdentifier(tValue, tSystem, "official", tIdentifierType, , , , tAssignerDisplay, , )
		$$$AddToArray(pPatient, "identifier", tIdentifier)
		Set pItemsAdded("identifier", tItemKey) = ""
	}
	
	#dim tMatchIdentifier As HS.Types.Identifier
	For tIdentIdx = 1:1:pPatientMatch.Identifiers.Count() {
		Set tMatchIdentifier = pPatientMatch.Identifiers.GetAt(tIdentIdx)
		Set tValue = tMatchIdentifier.Extension
		Set tAACode = tMatchIdentifier.AssigningAuthorityName
		Set tUse = tMatchIdentifier.Use
		Set tSystem = ..GetURI("assigningauthority", tAACode, pURIMode, tAACode)
		Set tItemKey = tValue_"||"_tSystem
		If $Data(pItemsAdded("identifier", tItemKey)) {
			Continue
		}
		If (tUse="") || (tUse="PAT") || (tUse="MR") {
			Set tIdentifierType = ..MakeCodeableConcept("MR", "Medical Record Number", tMRNSystem, "MRN", , , , )
			Set tIdentifier = ..MakeIdentifier(tValue, tSystem, "official", tIdentifierType, , , , , , )
			$$$AddToArray(pPatient, "identifier", tIdentifier)
			Set pItemsAdded("identifier", tItemKey) = ""
		} Else {
			// For all other Identifier Types (tUse), HS has no deterministic mapping from the
			// Assigning Authority Identifier Types Registry to codes in a given code system
			// (e.g., http://terminology.hl7.org/CodeSystem/v2-0203). HL7 validator warns when
			// identifier type coding code is present without an accompanying system value.
			// However, this is the best we can do, and it is just a warning (not an error).
			Set tIdentifierTypeValue = tUse
			Set tAADef = ##class(HS.AssignAuth.Config).CodeIdxOpen(tAACode, tUse)
			If ($IsObject(tAADef)) && ($IsObject(tAADef.IdentifierType)) {
				Set tIdentifierTypeDisplay = tAADef.IdentifierType.Name
			} Else {
				Set tIdentifierTypeDisplay = ""
			}
			Set tIdentifierType = ..MakeCodeableConcept(tUse, tIdentifierTypeDisplay, , tIdentifierTypeDisplay, , , , )
			Set tIdentifier = ..MakeIdentifier(tValue, tSystem, "official", tIdentifierType, , , , , , )
			$$$AddToArray(pPatient, "identifier", tIdentifier)
			Set pItemsAdded("identifier", tItemKey) = ""
		}
	}
	
	// Get the primary name in the search result.
	Set tLast = pPatientMatch.LastName
	Set tFirst = pPatientMatch.FirstName
	Set tMiddle = pPatientMatch.MiddleName
	Set tPrefix = pPatientMatch.Prefix
	Set tSuffix = pPatientMatch.Suffix
	Set tNameText = tFirst_$Select(tFirst'="":" ",1:"")_tMiddle_$Select(tMiddle'="":" ",1:"")_tLast
	If (tNameText'="") && ('$Data(pItemsAdded("patientname", tNameText))) {
		Set tFHIRName = $$$NewJSONObject
		Set tFHIRName.use = "official"
		Set tFHIRName.text = tNameText
		If tLast'="" Set tFHIRName.family = tLast
		$$$AddToArray(tFHIRName, "given", tFirst)
		If tMiddle'="" {
			$$$AddToArray(tFHIRName, "given", tMiddle)
		}
		If tPrefix'="" {
			$$$AddToArray(tFHIRName, "prefix", tPrefix)
		}
		If tSuffix'="" {
			$$$AddToArray(tFHIRName, "suffix", tSuffix)
		}
		$$$AddToArray(pPatient, "name", tFHIRName)
		Set pItemsAdded("patientname", tNameText) = ""
	}
	
	// Because SDA3-to-AddUpdateHub.xsl at this time only puts Aliases into the Names
	// collection, this code assumes that anything in the Names collection is an Alias.
	#dim tName As HS.Types.PersonName
	For j = 1:1:pPatientMatch.Names.Count() {
		Set tName = pPatientMatch.Names.GetAt(j)
		Set tLast = tName.Family
		Set tFirst = tName.Given
		Set tMiddle = tName.Middle
		Set tPrefix = tName.Prefix
		Set tSuffix = tName.Suffix
		Set tNameText = tFirst_$Select(tFirst'="":" ",1:"")_tMiddle_$Select(tMiddle'="":" ",1:"")_tLast
		If (tNameText'="") && ('$Data(pItemsAdded("patientname", tNameText))) {
			Set tFHIRName = $$$NewJSONObject
			Set tFHIRName.use = "anonymous"
			Set tFHIRName.text = tNameText
			If tLast'="" Set tFHIRName.family = tLast
			$$$AddToArray(tFHIRName, "given", tFirst)
			If tMiddle'="" {
				$$$AddToArray(tFHIRName, "given", tMiddle)
			}
			If tPrefix'="" {
				$$$AddToArray(tFHIRName, "prefix", tPrefix)
			}
			If tSuffix'="" {
				$$$AddToArray(tFHIRName, "suffix", tSuffix)
			}
			$$$AddToArray(pPatient, "name", tFHIRName)
			Set pItemsAdded("patientname", tNameText) = ""
		}
	}
	
	For j = 1:1:pPatientMatch.Telecoms.Count() {
		Set tTelecom = pPatientMatch.Telecoms.GetAt(j)
		Set tFHIRTelecom = $$$NewJSONObject
		Set tUse = $Case(tTelecom.Use, "AS":"home", "BAD":"old", "DIR":"home", "EC":"home", "H":"home", "HP":"home", "HV":"home", "MC":"mobile", "PG":"mobile", "PUB":"work", "TMP":"temp", "WP":"work", :"")
		If tTelecom.Email'="" {
			Set tFHIRTelecom.system = "email"
			Set tFHIRTelecom.value = tTelecom.Email
			Set tItemKey = "email||"_tTelecom.Email_"||"_tTelecom.Use
		} Else {
			Set tFHIRTelecom.system = $Case(tTelecom.Type, "F":"fax", "P":"pager", "L":"phone", "M":"phone", "O":"other", :"phone")
			Set tFHIRTelecom.value = tTelecom.PhoneNumberFull
			Set tItemKey = "phone||"_tTelecom.PhoneNumberFull_"||"_tFHIRTelecom.system_"||"_tUse
		}
		If '$Data(pItemsAdded("telecom", tItemKey)) {
			If tUse'="" Set tFHIRTelecom.use = tUse
			$$$AddToArray(pPatient, "telecom", tFHIRTelecom)
			Set pItemsAdded("telecom", tItemKey) = ""
		}
	}
	
	Set tPhone = pPatientMatch.Telephone
	If tPhone'="" {
		Set tSystem = "phone"
		Set tUse = "home"
		Set tItemKey = "phone||"_tPhone_"||"_tSystem_"||"_tUse
		If '$Data(pItemsAdded("telecom", tItemKey)) {
			Set tFHIRTelecom = $$$NewJSONObject
			Set tFHIRTelecom.system = tSystem
			Set tFHIRTelecom.value = tPhone
			Set tFHIRTelecom.use = tUse
			$$$AddToArray(pPatient, "telecom", tFHIRTelecom)
			Set pItemsAdded("telecom", tItemKey) = ""
		}
	}
	
	Set tPhone = pPatientMatch.BusinessPhone
	If tPhone'="" {
		Set tSystem = "phone"
		Set tUse = "work"
		Set tItemKey = "phone||"_tPhone_"||"_tSystem_"||"_tUse
		If '$Data(pItemsAdded("telecom", tItemKey)) {
			Set tFHIRTelecom = $$$NewJSONObject
			Set tFHIRTelecom.system = tSystem
			Set tFHIRTelecom.value = tPhone
			Set tFHIRTelecom.use = tUse
			$$$AddToArray(pPatient, "telecom", tFHIRTelecom)
			Set pItemsAdded("telecom", tItemKey) = ""
		}
	}
	
	If (pPatient.gender="") && (pPatientMatch.Sex'="") {
		Set tFHIRCode = ##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3",
															$Select(+pFHIRVersion=3:"vSTU3", 1:"vR"_+pFHIRVersion),
															"HS.SDA3.CodeTableDetail.Gender",
															"administrative-gender"_$Select(+pFHIRVersion=3:"", 1:"|"_pFHIRVersion),
															pPatientMatch.Sex)
		If tFHIRCode'="" {
			Set pPatient.gender = tFHIRCode
		}
	}
	
	If (pPatient.birthDate="") && (pPatientMatch.DOB'="") {
		Set pPatient.birthDate = $ZDate(pPatientMatch.DOB, 3)
	}
	
	For j = 1:1:pPatientMatch.Addresses.Count() {
		Set tAddress = pPatientMatch.Addresses.GetAt(j)
		Set tItemKey = tAddress.StreetLine_"||"_tAddress.City_"||"_tAddress.State_"||"_tAddress.PostalCode
		If '$Data(pItemsAdded("address", tItemKey)) {
			Set tUse = $Case(tAddress.Use, "ABC":"home", "BAD":"old", "H":"home", "HP":"home", "HV":"home", "IDE":"home", "PHYS":"home", "PST":"home", "SYL":"home", "TMP":"temp", "WP":"work", "BIL":"home", "ML":"home", :"home")
			Set tType = "both"
			Set tFHIRAddress = ..MakeAddress(tAddress.StreetLine, tAddress.City, tAddress.State, tAddress.PostalCode, tAddress.County, tAddress.Country, tType, tUse)
			$$$AddToArray(pPatient, "address", tFHIRAddress)
			Set pItemsAdded("address", tItemKey) = ""
		}
	}
	
	Set tItemKey = pPatientMatch.Street_"||"_pPatientMatch.City_"||"_pPatientMatch.State_"||"_pPatientMatch.Zip
	If ($Translate(tItemKey,"|")'="") && ('$Data(pItemsAdded("address", tItemKey))) {
		Set tUse = $Case(pPatientMatch.Use, "ABC":"home", "BAD":"old", "H":"home", "HP":"home", "HV":"home", "IDE":"home", "PHYS":"home", "PST":"home", "SYL":"home", "TMP":"temp", "WP":"work", "BIL":"home", "ML":"home", :"home")
		Set tType = "both"
		Set tFHIRAddress = ..MakeAddress(pPatientMatch.Street, pPatientMatch.City, pPatientMatch.State, pPatientMatch.Zip, , , tType, tUse)
		$$$AddToArray(pPatient, "address", tFHIRAddress)
		Set pItemsAdded("address", tItemKey) = ""
	}
	
	If pPatientMatch.MothersMaidenSurname'="" {
		Set tExtUrl = "http://hl7.org/fhir/StructureDefinition/patient-mothersMaidenName"
		If '..HasExtension(pPatient, tExtUrl) {
			Set tFHIRExtension = $$$NewJSONObject
			Set tFHIRExtension.url = tExtUrl
			Set tFHIRExtension.valueString = pPatientMatch.MothersMaidenSurname
			$$$AddToArray(pPatient, "extension", tFHIRExtension)
		}
	}
	
	If pPatientMatch.ReligiousAffiliation'="" {
		Set tExtUrl = "http://hl7.org/fhir/StructureDefinition/patient-religion"
		If '..HasExtension(pPatient, tExtUrl) {
			Set tFHIRExtension = $$$NewJSONObject
			Set tFHIRExtension.url = tExtUrl
			Set tFHIRExtension.valueCodeableConcept = ..MakeCodeableConcept(pPatientMatch.ReligiousAffiliation, pPatientMatch.ReligiousAffiliation, , pPatientMatch.ReligiousAffiliation, , , , )
			$$$AddToArray(pPatient, "extension", tFHIRExtension)
		}
	}
	
	If (pPatient.multipleBirthBoolean="") && (pPatient.multipleBirthInteger="") {
		If +pPatientMatch.BirthOrder=0 {
			Do pPatient.%Set("multipleBirthBoolean", 0, "boolean")
		} Else {
			Do pPatient.%Set("multipleBirthInteger", pPatientMatch.BirthOrder, "number")
		}
	}
	
	// PatientSearchMatch MaritalStatus is a string, put it into the code property
	// and text property of the FHIR CodeableConcept.
	If (pPatient.maritalStatus="") && (pPatientMatch.MaritalStatus'="") {
		If $Data(tMS)=0 {
			Set tMS("A")="Annulled"
			Set tMS("D")="Divorced"
			Set tMS("I")="Interlocutory"
			Set tMS("L")="Legally Separated"
			Set tMS("M")="Married"
			Set tMS("P")="Polygamous"
			Set tMS("S")="Never Married"
			Set tMS("T")="Domestic partner"
			Set tMS("U")="unmarried"
			Set tMS("W")="Widowed"
			Set tMS("UNK")="unknown"
		}
		Set tFHIRCode = ##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3",
														$Select(+pFHIRVersion=3:"vSTU3", 1:"vR"_+pFHIRVersion),
														"HS.SDA3.CodeTableDetail.MaritalStatus",
														"marital-status",
														pPatientMatch.MaritalStatus)
		If tFHIRCode'="" {
			Set tDescription = $Get(tMS(tFHIRCode))
			Set tSystem = $Select(tFHIRCode="UNK":tNullFlavorSystem, 1:tMaritalStatusSystem)
			Set pPatient.maritalStatus = ..MakeCodeableConcept(tFHIRCode, tDescription, tSystem, tFHIRCode, , , , )
		}
	}
	
	// PatientSearchMatch Language is a string. Put it into the code property
	// and text property of the FHIR CodeableConcept.
	If (('$IsObject(pPatient.communication))||('pPatient.communication.%Size())) && (pPatientMatch.Language'="") {
		Set tFHIRCommunication = $$$NewJSONObject
		Set tFHIRCommunication.language = ..MakeCodeableConcept(pPatientMatch.Language, , , pPatientMatch.Language, , , , )
		$$$AddToArray(pPatient, "communication", tFHIRCommunication)
	}
	
	// FHIR Patient deceased is a variant, can be dateTime or boolean but not both.
	If (pPatient.deceasedDateTime="") && (pPatient.deceasedBoolean="") {
		If pPatientMatch.DeathTime'="" {
			// DeathTime in pPatientMatch is YYYY-MM-DD HH:MM:SS (no "T" and no time zone).
			Set pPatient.deceasedDateTime = $ZDateTime($ZDateTimeH(pPatientMatch.DeathTime, 3, 1), 3, 7)
		} ElseIf pPatientMatch.DeathStatus'="" {
			Do pPatient.%Set("deceasedBoolean", pPatientMatch.DeathStatus, "boolean")
		}
	}
	
	Quit
}

/// Return a Boolean value indicating whether the specified FHIR object's extension
/// collection includes an extension with the specified url.
ClassMethod HasExtension(pFHIRObj As %Library.DynamicObject, pExtensionUrl As %String) As %Boolean
{
	If ('$IsObject(pFHIRObj.extension)) || ('pFHIRObj.extension.%Size()) {
		Set tHasExtension = 0
	} Else {
		Set tHasExtension = 0
		For i = 0:1:pFHIRObj.extension.%Size()-1 {
			If pFHIRObj.extension.%Get(i).url=pExtensionUrl {
				Set tHasExtension = 1
				Quit
			}
		}
	}
	Return tHasExtension
}

ClassMethod FilterByUnsupportedParamsODS(pParameters As HS.FHIRServer.API.Data.QueryParameters = "", ByRef pResultSet As HS.FHIRServer.Util.SearchResult)
{
	For i = 1:1:pParameters.GetParameterCount("identifier") {
		Set tParamVal = pParameters.GetParameterValue("identifier", i)
		For j = 1:1:$Length(tParamVal, ",") {
			Set tP = $Piece(tParamVal, ",", j)
			If ($Extract(tP,*)="|") && ($Length(tP,"|")=2) && ($Piece(tP, "|", 1)'="") {
				// The parameter value for this is just "system|".
				Set tScopingSystems($Piece(tP, "|", 1)) = ""
			}
		}
	}
	If $Data(tScopingSystems) {
		// For ODS, if a resource does not include any identifiers that
		// have any of the specified systems - i.e., identifier search
		// parameter values that are just "system|" - then mark that
		// resource as Deleted.
		While (pResultSet.NextUndeleted()){
			Set tIncludeResource = 0
			Set tDynObj = pResultSet.ResourceJson
			For i = tDynObj.identifier.%Size()-1:-1:0 {
				If (tDynObj.identifier.%Get(i).system'="") && ($Data(tScopingSystems(tDynObj.identifier.%Get(i).system))) {
					Set tIncludeResource = 1
					Quit
				}
			}
			If 'tIncludeResource {
				Do pResultSet.MarkAsDeleted()
				Do pResultSet.%SaveRow()
			}
		}
	}
	
	Do pResultSet.%SetIterator(0)
	
	Quit
}

/// GetURI wraps the logic for obtaining a URI, based on a specified code and code type.
ClassMethod GetURI(pType As %String, pCode As %String, pMode As %String = "strict", pDefault As %String = "") As %String
{
	set tRet = ""
	
	if pMode = "strict" quit ##class(HS.Data.OIDMap).GetURIForCode(pCode, pDefault)
	
	set tRet = ##class(HS.Data.OIDMap).GetURLForCode(pCode, "")
	if tRet '= "" quit tRet
	
	set tHost = "http://"_$$$HSNetworkHostName
	set tRet = tHost_"/"_pType_"/"_pCode
	quit tRet
}

/// Build and return a FHIR Identifier.
ClassMethod MakeIdentifier(pValue As %String = "", pSystem As %String = "", pUse As %String = "", pType As %Library.DynamicObject = "", pStart As %String = "", pEnd As %String = "", pAssignerReference As %String = "", pAssignerDisplay As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Library.DynamicObject
{
	#define AddToArray(%jsonobj,%propname,%addobj) Do:'%jsonobj.%IsDefined(%propname) %jsonobj.%Set(%propname,$$$NewJSONArray) Do %jsonobj.%Get(%propname).%Push(%addobj)
	
	Set tIdentifier = $$$NewJSONObject
	
	If pValue'="" Set tIdentifier.value = pValue
	If pSystem'="" Set tIdentifier.system = pSystem
	If pUse'="" Set tIdentifier.use = pUse
	// pType is a CodeableConcept.
	If $IsObject(pType) Set tIdentifier.type = pType
	If (pAssignerReference'="") || (pAssignerDisplay'="") {
		Set tIdentifier.assigner = $$$NewJSONObject
		If pAssignerReference'="" Set tIdentifier.assigner.reference = pAssignerReference
		If pAssignerDisplay'="" Set tIdentifier.assigner.display = pAssignerDisplay
	}
	If (pStart'="") || (pEnd'="") {
		Set tIdentifier.period = $$$NewJSONObject
		If pStart'="" Set tIdentifier.period.start = pStart
		If pEnd'="" Set tIdentifier.period.end = pEnd
	}
	
	Return tIdentifier
}

/// Build and return a FHIR CodeableConcept - with maximum one coding item.
ClassMethod MakeCodeableConcept(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Library.DynamicObject
{
	#define AddToArray(%jsonobj,%propname,%addobj) Do:'%jsonobj.%IsDefined(%propname) %jsonobj.%Set(%propname,$$$NewJSONArray) Do %jsonobj.%Get(%propname).%Push(%addobj)
	
	Set tCodeableConcept = $$$NewJSONObject
	
	If (pCode'="") || (pDisplay'="") || (pSystem'="") || (pVersion'="") || (pUserSelected'="") {
		$$$AddToArray(tCodeableConcept, "coding", ..MakeCoding(pCode, pDisplay, pSystem, pVersion, pUserSelected, , ))
	}
	
	If pText'="" Set tCodeableConcept.text = pText
	
	Return tCodeableConcept
}

/// Build and return a FHIR Coding object.
ClassMethod MakeCoding(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %String = "") As %Library.DynamicObject
{
	Set tCoding = $$$NewJSONObject
	
	If pSystem'="" Set tCoding.system = pSystem
	If pVersion'="" Set tCoding.version = pVersion
	If pCode'="" Set tCoding.code = pCode
	If pDisplay'="" Set tCoding.display = pDisplay
	If pUserSelected'="" Set tCoding.userSelected = pUserSelected
	
	Return tCoding
}

/// Build and return a FHIR Address.<br>
ClassMethod MakeAddress(pStreet As %String = "", pCity As %String = "", pState As %String = "", pPostalCode As %String = "", pCounty As %String = "", pCountry As %String = "", pType As %String = "", pUse As %String = "", pStart As %String = "", pEnd As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Library.DynamicObject
{
	#define AddToArray(%jsonobj,%propname,%addobj) Do:'%jsonobj.%IsDefined(%propname) %jsonobj.%Set(%propname,$$$NewJSONArray) Do %jsonobj.%Get(%propname).%Push(%addobj)
	
	Set tAddress = $$$NewJSONObject
	
	If pStreet'="" {
		For k = 1:1:$Length(pStreet, ";") {
			Set tP = $ZStrip($Piece(pStreet, ";", k), "<>W")
			If tP'="" {
				$$$AddToArray(tAddress, "line", tP)
			}
		}
	}
	If pCity'="" Set tAddress.city = pCity
	If pState'="" Set tAddress.state = pState
	If pPostalCode'="" Set tAddress.postalCode = pPostalCode
	If pCounty'="" Set tAddress.district = pCounty
	If pCountry'="" Set tAddress.country = pCountry
	If pType'="" Set tAddress.type = pType
	If pUse'="" Set tAddress.use = pUse
	If (pStart'="") || (pEnd'="") {
		Set tAddress.period = $$$NewJSONObject
		If pStart'="" Set tAddress.period.start = pStart
		If pEnd'="" Set tAddress.period.end = pEnd
	}
	
	Return tAddress
}

}
