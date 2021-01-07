Class HS.FHIR.DTL.Util.SDA3.Handler.Vaccination
{

/// Check to see if any Administration in the Vaccination streamlet has a refusal reason
/// and return the result of that search.
ClassMethod RefusalReasonExists(administrations As %ListOfObjects) As %Boolean
{
	set returnVal = 0
	for i=1:1:administrations.Count() {
		if ##class(HS.FHIR.DTL.Util.Element.Object).Defined(administrations.GetAt(i), "RefusalReason") {
			set returnVal = 1
			quit
		}
	}
	quit returnVal
}

}
