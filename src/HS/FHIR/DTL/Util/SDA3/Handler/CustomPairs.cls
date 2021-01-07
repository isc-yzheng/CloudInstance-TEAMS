Class HS.FHIR.DTL.Util.SDA3.Handler.CustomPairs
{

/// Transforms SDA3 CustomPairs into a FHIR Parameters resource, then saves the resource as contained within
/// the parent resource and adds an extension to the resource that indicates the contained resource originated
/// as the list of SDA3 CustomPairs.
/// customPairs - The list of CustomPairs
/// target - The target resource that is being created and will have both the contained resource and extension
/// that references the contained resource added to it.
ClassMethod Extension(customPairs As %ListOfObjects, Output target As %RegisteredObject, ByRef aux) As %RegisteredObject
{
	set tSC = $$$OK
	try {
		set configuredFhirVersion = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaName(aux("transformer").fhirVersion)
		if customPairs.Count() > 0 {
			set extension = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Base.Extension", "%New")
			set parameters = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Resource.Parameters", "%New")
			
			for i=1:1:customPairs.Count() {
				set parameter = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Element.Parameters.parameter", "%New")
				set DTL = aux("transformer").GetDTL(customPairs.GetAt(i), "HS.FHIR.DTL.SDA3." _ configuredFhirVersion _ ".NVPair.Parameters.parameter")
				if DTL = "" continue
				$$$ThrowOnError($classmethod(DTL, "Transform", customPairs.GetAt(i), .parameter, .aux))
				
				do parameters.parameter.Insert(parameter)
			}
		}
		else {
			return ""
		}
		set tSC = ##class(HS.FHIR.DTL.Util.FHIR.Handler.Contained).Reference(.parameters, target.contained.Count(), 1, .ref)
		quit:$$$ISERR(tSC)
		do target.contained.Insert(parameters)
		set extension.valueReference = ref
		
	} catch ex {
		do $system.Status.DisplayError(ex.AsStatus())
		set extension = ""
	}
 	quit extension
}

}
