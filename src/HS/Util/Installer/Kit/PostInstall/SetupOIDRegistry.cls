Include %ZHSLIB

Class HS.Util.Installer.Kit.PostInstall.SetupOIDRegistry Extends HS.Util.Installer.Kit.Base
{

ClassMethod RunHub(pHubNS = "HSREGISTRY") As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = ..CreateOIDTypes() $$$ThrowOnError(tSC)
		Set tSC = ..CreateOIDEntries() $$$ThrowOnError(tSC)
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

ClassMethod CreateOIDTypes() As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set SQLCODE = ""
		For tItem = "Facility", "Gateway", "AssigningAuthority", "Device", "HomeCommunity", "Repository", "CodeSystem", "Organization", "SoftwareProduct", "LicensingAuthority" {
			&sql(Select ID From HS_Data.OIDType Where Description = :tItem)
			
			If (SQLCODE = 100) {
				Set tOIDType = ##class(HS.Data.OIDType).%New()
				Set tOIDType.Description = tItem
				Set tSC = tOIDType.%Save() $$$ThrowOnError(tSC)
			}
		}
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

ClassMethod CreateOIDEntries() As %Status
{
	Set tSC = $$$OK
	
	/* tSC is not checked in the following code so that one failure doesn't abort the rest of the save attempts */
	Try {
		#; InterSystems Corporate and SoftwareProduct OIDs (as registered with hl7.org)
		Set tSC = ##class(HS.Data.OIDMap).FileOID("ISC", "Organization", "2.16.840.1.113883.3.86", "InterSystems Corporation")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("ISC-Cache", "SoftwareProduct", "2.16.840.1.113883.3.86.1", "InterSystems Cache")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("ISC-Ensemble", "SoftwareProduct", "2.16.840.1.113883.3.86.2", "InterSystems Ensemble")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("ISC-HealthShare", "SoftwareProduct", "2.16.840.1.113883.3.86.3", "InterSystems HealthShare")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("ISC-TrakCare", "SoftwareProduct", "2.16.840.1.113883.3.86.4", "InterSystems TrakCare")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("ISC-DeepSee", "SoftwareProduct", "2.16.840.1.113883.3.86.5", "InterSystems DeepSee")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("ISC-NoCodeSystem","CodeSystem","2.16.840.1.113883.3.86.3.1","HealthShare Null Codeset")

		#; Common Code Sets
		Set tSC = ##class(HS.Data.OIDMap).FileOID("ActCode", "CodeSystem", "2.16.840.1.113883.5.4", "HL7 Act Code")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("ActStatus", "CodeSystem", "2.16.840.1.113883.5.14", "HL7 Act Status")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("AdministrativeGender", "CodeSystem", "2.16.840.1.113883.5.1", "HL7 AdministrativeGender")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("C4", "CodeSystem", "2.16.840.1.113883.6.12", "CPT-4 (Current Procedure Terminology 4)")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("C5", "CodeSystem", "2.16.840.1.113883.6.82", "CPT-5 (Current Procedure Terminology 5)")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("CVX", "CodeSystem", "2.16.840.1.113883.12.292", "CVX (Centers for Disease Control -- Vaccine Codes)", , "http://hl7.org/fhir/sid/cvx")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("Discharge Disposition", "CodeSystem", "2.16.840.1.113883.12.112", "HL7 Discharge Disposition Desc")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("DCM", "CodeSystem", "1.2.840.10008.2.16.4", "DCM (DICOM Controlled Terminology)")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("FDDC", "CodeSystem", "2.16.840.1.113883.6.64", "FDDC (First DataBank Drug Codes)")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("FDDX", "CodeSystem", "2.16.840.1.113883.6.63", "FDDX (First DataBank Diagnostic Codes)")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("HITSP", "CodeSystem", "2.16.840.1.113883.3.88", "HITSP (Healthcare Information Technology Standards Panel)")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("HL7", "CodeSystem", "2.16.840.1.113883.5.4", "HL7 (Health Level 7)")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("I9", "CodeSystem", "2.16.840.1.113883.6.42", "ICD-9 (International Classification of Diseases, revision 9)", , "http://hl7.org/fhir/sid/icd-9-cm")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("I9C", "CodeSystem", "2.16.840.1.113883.6.2", "ICD-9-CM (International Classification of Diseases, revision 9 -- Clinical Modification)")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("I9CDCS", "CodeSystem", "2.16.840.1.113883.6.103", "ICD-9-CM (International Classification of Diseases, revision 9 -- Clinical Modification) (Diagnosis Codes)", , "http://hl7.org/fhir/sid/icd-9-cm/diagosis")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("I9CPCS", "CodeSystem", "2.16.840.1.113883.6.104", "ICD-9-CM (International Classification of Diseases, revision 9 -- Clinical Modification) (Procedure Codes)", , "http://hl7.org/fhir/sid/icd-9-cm/procedure")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("I10", "CodeSystem", "2.16.840.1.113883.6.3", "ICD-10 (International Classification of Diseases, revision 10)", , "http://hl7.org/fhir/sid/icd-10")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("I10C", "CodeSystem", "2.16.840.1.113883.6.90", "ICD-10 (International Classification of Diseases, revision 10)")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("I10CPCS", "CodeSystem", "2.16.840.1.113883.6.4", "ICD-10 (International Classification of Diseases, revision 10) (Procedure Codes)", , "http://www.icd10data.com/icd10pcs")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("LanguageAbilityMode", "CodeSystem", "2.16.840.1.113883.5.60", "HL7 Language Ability Mode")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("LN", "CodeSystem", "2.16.840.1.113883.6.1", "LOINC (Logical Observation Identifiers Names and Codes)", , "http://loinc.org", "LOINC")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("NDC", "CodeSystem", "2.16.840.1.113883.6.69", "NDC (National Drug Codes)", , "http://hl7.org/fhir/sid/ndc")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("MaritalStatus", "CodeSystem", "2.16.840.1.113883.5.2", "HL7 Marital Status")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("NCI Thesaurus", "CodeSystem", "2.16.840.1.113883.3.26.1.1", "NCI Thesaurus", , "http://ncimeta.nci.nih.gov")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("nubc-UB92", "CodeSystem", "2.16.840.1.113883.6.21", "National Uniform Billing Committee")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("ObservationInterpretation", "CodeSystem", "2.16.840.1.113883.5.83", "Observation Interpretation")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("Provider Role", "CodeSystem", "2.16.840.1.113883.12.443", "HL7 Provider Role")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("ParticipationFunction", "CodeSystem", "2.16.840.1.113883.5.88", "HL7 Participation Function")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("ParticipationType", "CodeSystem", "2.16.840.1.113883.5.90", "HL7 Participation Type")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("Race & Ethnicity - CDC", "CodeSystem", "2.16.840.1.113883.6.238", "Race & Ethnicity - CDC")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("ReligiousAffiliation", "CodeSystem", "2.16.840.1.113883.5.1076", "HL7 Religious Affiliation")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("RoleClass", "CodeSystem", "2.16.840.1.113883.5.110", "HL7 Role Class")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("RoleCode", "CodeSystem", "2.16.840.1.113883.5.111", "HL7 Role Code")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("RXNORM", "CodeSystem", "2.16.840.1.113883.6.88", "RxNorm", , "http://www.nlm.nih.gov/research/umls/rxnorm")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("SCT", "CodeSystem", "2.16.840.1.113883.6.96", "SNOMED-CT (Systematized Nomenclature of Medicine -- Clinical Terms)", , "http://snomed.info/sct", "SNOMED CT")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("SpecimenType", "CodeSystem", "2.16.840.1.113883.5.129", "HL7 Specimen Type")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("UCUM", "CodeSystem", "2.16.840.1.113883.6.8", "UCUM (Unified Code for Units of Measure)", , "http://unitsofmeasure.org")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("UNII", "CodeSystem", "2.16.840.1.113883.4.9", "Unique Ingredient Identifier", , "http://fdasis.nlm.nih.gov")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("X12N-1336", "CodeSystem", "2.16.840.1.113883.6.255.1336", "X12N-1336")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("ISO21298", "CodeSystem", "1.3.6.1.4.1.21298", "ISO 21298")
		
		#; Assigning Authorities
		Set tSC = ##class(HS.Data.OIDMap).FileOID("NPI", "AssigningAuthority", "2.16.840.1.113883.4.6", "HCFA National Provider Identifier", , "http://hl7.org/fhir/sid/us-npi")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("SSA", "AssigningAuthority", "2.16.840.1.113883.3.184", "Social Security Administration")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("SSN", "AssigningAuthority", "2.16.840.1.113883.4.1", "Social Security Administration", , "http://hl7.org/fhir/sid/us-ssn")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("UPIN", "AssigningAuthority", "2.16.840.1.113883.4.8", "UPIN Registry")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("DEA", "AssigningAuthority", "2.16.840.1.113883.11.19254", "Drug Enforcement Administration")
		Set tSC = ##class(HS.Data.OIDMap).FileOID("TAXID", "AssigningAuthority", "2.16.840.1.113883.4.4", "IRS Employer Identification")
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

}
