Class HS.HL7.Annotation.Data Extends EnsLib.HL7.Annotation.Data
{

Method %OnNew(pVersion) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set ..Version=pVersion
	Set ..BaseVer=$G(^EnsHL7.Schema(..Version,"base"),..Version)
	IF ..BaseVer'=..Version {
		Merge ..Schema=^EnsHL7.Schema(..BaseVer),..Names=^EnsHL7.Description(..BaseVer)
	}
	Merge ..Schema=^EnsHL7.Schema(..Version),..Names=^EnsHL7.Description(..Version)
	DO ..ReIndex(0)
	Merge ..Lindex=^EnsHL7.Annotation(..Version,"Index")
	Quit $$$OK
}

}
