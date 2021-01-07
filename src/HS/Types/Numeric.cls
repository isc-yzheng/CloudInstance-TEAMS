/// HealthShare-specific version of %Numeric so that on XML import we do not<br>
/// lose the delete instruction (two double quotes) to validation.
Class HS.Types.Numeric Extends %Library.Numeric
{

/// Based on the IsValid method of the superclass, but adds a case for the<br>
/// delete instruction so it is valid.
ClassMethod IsValid(%val As %Library.RawString) As %Status [ CodeMode = generator, GenerateAfter = IsValidDT, ServerOnly = 0 ]
{
	s %code=0, qq=$c(34,34)
	s %codemode=$$$cMETHCODEMODEEXPRESSION
	Set %code="$select($isvalidnum(%val):1,%val="_qq_qq_qq_":1,1:$$$ERROR($$$DTNotNum,%val))" Quit $$$OK
}

/// Based on the superclass method, but adds a case for the delete instruction<br>
/// so that it is unchanged.
ClassMethod XSDToLogical(%val As %String) As %Numeric [ CodeMode = generator, ServerOnly = 1 ]
{
	Set qq=$C(34,34)
	If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault) {
		Set %codemode=$$$cMETHCODEMODEEXPRESSION
		Set %code="$S(%val="_qq_qq_qq_":%val,1:$inumber(%val,""L"",""""))"
	} Else {
		Set %code=0 
	}
	Quit $$$OK
}

/// Converts <var>%val</var> to a normalized value.
ClassMethod Normalize(%val As %Library.RawString) As %Numeric [ CodeMode = generator, ServerOnly = 1 ]
{
	s %codemode=$$$cMETHCODEMODEEXPRESSION
	s %code="$select($zu(115,13)&&(%val=$c(0)):"""",%val=$C(34,34):%val,1:$normalize($decimal(%val),"_+%parameter("SCALE")_"))"
	QUIT $$$OK
}

}
