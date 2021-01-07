Class HS.FHIR.DTL.Util.FHIR.Handler.Patient
{

/// Convert the Patient citizenship hl7.org extension into an SDA3 CodeTable. This method is needed due to the unique
/// structure of the citizenship hl7.org extension.
ClassMethod Citizenship(extension As HS.FHIR.DTL.vSTU3.Model.Base.Extension, aux) As HS.SDA3.CodeTableDetail.Citizenship
{
	set configuredFhirVersion = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaName(aux("transformer").fhirVersion)
	set citizenship = ##class(HS.SDA3.CodeTableDetail.Citizenship).%New()
	
	if extension.extension.Count() > 0 {
		set DTL = aux("transformer").GetDTL(extension.extension.GetAt(1), "HS.FHIR.DTL." _ configuredFhirVersion _ ".SDA3.Extension.CodeTableTranslated")
		if DTL = "" quit ""
		$$$ThrowOnError($classmethod(DTL, "Transform", extension.extension.GetAt(1), .citizenship, .aux))
		
		quit citizenship
	}
	else {
		quit ""
	}
}

}
