Class HS.FHIR.DTL.SubXFrm.vSTU3.SDA3.Extension.String
{

ClassMethod Transform(source As HS.FHIR.DTL.vSTU3.Model.Base.Extension, Output target As %String, Output aux = "") As %Status
{
	set tSC = $$$OK
	try {
		set target = source.valueString
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
