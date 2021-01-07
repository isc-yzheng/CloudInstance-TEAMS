Class HS.FHIR.DTL.SubXFrm.SDA3.vR4.String.Annotation [ DependsOn = (%Library.String, HS.FHIR.DTL.vR4.Model.Datatype.Annotation), ProcedureBlock ]
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
	quit "HS.FHIR.DTL.vR4.Model.Datatype.Annotation"
}

}
