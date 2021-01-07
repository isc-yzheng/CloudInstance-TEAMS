Class HS.FHIR.DTL.Util.FHIR.Handler.Quantity
{

/// convert a Quantity FHIR datatype to a string.
ClassMethod String(quantity As %RegisteredObject) As %String
{
	if quantity.comparator '= "" {
		quit quantity.comparator _ " " _ quantity.value
	}
	else {
		quit quantity.value
	}
}

}
