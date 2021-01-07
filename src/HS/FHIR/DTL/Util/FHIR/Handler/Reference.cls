Include Ensemble

Class HS.FHIR.DTL.Util.FHIR.Handler.Reference
{

/// Convert the resource type for a reference when going between STU3 and DSTU2.
/// from - Source schema, eg. "vSTU3"
/// to - Target schema, eg. "vDSTU2"
/// source - reference string, eg. "Patient/1"
ClassMethod ConvertResourceType(from As %String, to As %String, source As %String) As %String
{
	if source [ "#" quit source
	if source = "" quit ""
	
	set prefix = $piece(source, "/", 1, *-2)
	set sourceType = $piece(source, "/", *-1)
	set DTL = ""
	set DTL = $order(^HS.XF.Transform(from, to, sourceType, ""))
	set targetType = $piece(DTL, sourceType _ ".", *)
	if targetType = "" quit ""
	
	set newReference = ""
	if prefix '= "" {
		set newReference = prefix _ "/"
	}
	set newReference = newReference _ targetType _ "/" _ $piece(source, "/",*)
	quit newReference
}

}
