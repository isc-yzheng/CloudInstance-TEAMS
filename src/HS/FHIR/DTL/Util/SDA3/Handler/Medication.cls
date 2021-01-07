Class HS.FHIR.DTL.Util.SDA3.Handler.Medication
{

/// Transform a Medication streamlet into a list of MedicationAdministration resources.
ClassMethod MedicationAdministration(source As HS.SDA3.Administration, Output targets As %ListOfObjects, ByRef aux) As %Status
{
	set tSC = $$$OK
	try {
		set configuredFhirVersion = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaName(aux("transformer").fhirVersion)
		set targets = ##class(%Library.ListOfObjects).%New()
		if source.Administrations.Count() > 0 {
			set targets = ##class(%Library.ListOfObjects).%New()
			for i=1:1:source.Administrations.Count() {
				set medicationAdministration = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Resource.MedicationAdministration", "%New")
				set DTL = aux("transformer").GetDTL(source.Administrations.GetAt(i), "HS.FHIR.DTL.SDA3." _ configuredFhirVersion _ ".Administration.MedicationAdministration")
				if DTL = "" continue
				$$$ThrowOnError($classmethod(DTL, "Transform", source.Administrations.GetAt(i), .medicationAdministration, .aux))
				do targets.Insert(medicationAdministration)
			}
		}
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
