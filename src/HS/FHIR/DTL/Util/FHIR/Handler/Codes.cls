Class HS.FHIR.DTL.Util.FHIR.Handler.Codes
{

ClassMethod InCodeableConcept(codeableConcept As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept, code As %String) As %Boolean
{
	if codeableConcept = "" {
		return 0
	}
	if codeableConcept.%Extends("%Collection.ListOfObj") {
		for i=1:1:codeableConcept.Count() {
			for j=1:1:codeableConcept.GetAt(i).coding.Count() {
				if codeableConcept.GetAt(i).coding.GetAt(j).code = code {
					return 1
				}
			}
		}
	}
	else {
		for i=1:1:codeableConcept.coding.Count() {
			if codeableConcept.coding.GetAt(i).code = code {
				return 1
			}
		}
	}
	return 0
}

}
