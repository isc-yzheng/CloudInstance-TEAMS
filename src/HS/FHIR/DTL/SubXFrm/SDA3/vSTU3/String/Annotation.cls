Class HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.String.Annotation [ DependsOn = (%Library.String, HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation), ProcedureBlock ]
{

ClassMethod Transform(source As %RegisteredObject, Output target As %RegisteredObject, Output aux = "") As %Status
{
	set tSC = $$$OK
	try {
		set target.text = source
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

ClassMethod GetTargetType(create) As %String
{
	quit "HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation"
}

}
