Class HS.FHIR.DTL.Util.Mapping
{

/// Determine if a mapping should be excluded from the current transformation. There is a very
/// small percentage of mappings that are used in certain cases, depending on which API the
/// transformation is invoked from.
ClassMethod Exclude(project As %String) As %Boolean
{
	set $ecode = ""
	for i=1:1:$stack(-1) {
		if (project [ "ODS") {
			if ($stack(i, "PLACE") [ "HS.FHIR.DTL.Util.API.ODS.Transform") || ($stack(i, "PLACE") [ "HS.FHIR.DTL.Util.Test.ODS") {
				return 1
			}
		}
		elseif (project [ "HC") && ($stack(i, "PLACE") [ "HS.FHIR.DTL.Util.API.HC.Transform") {
			return 1
		}
	}
	return 0
}

}
