Class HS.FHIR.DTL.Util.FHIR.Handler.ResultItem
{

/// Convert a referenceRange BackboneElemnt into a string that represents the same information,
/// so it can be saved in the SDA3 equivalent field.
ClassMethod ResultNormalRange(range As HS.FHIR.DTL.vSTU3.Model.Element.Observation.referenceRange) As %String
{
	if ((range.high.value = "") && (range.low.value = "")) {
		quit range.text
	}
	elseif (range.high.value '= "") && (range.low.value = "") { 
		quit "<=" _ range.high.value
	}
	elseif (range.high.value = "") && (range.low.value '= "") {
		quit ">=" _ range.low.value
	}
	elseif (range.high.value '= "") && (range.low.value '= "")  {
		quit range.low.value _ "-" _ range.high.value
	}
	else {
		quit ""
	}
}

}
