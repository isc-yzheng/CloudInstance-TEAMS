/// HealthShare-specific version of %Boolean so that on XML import we do not<br>
/// lose the delete instruction (two double quotes) to validation.
Class HS.Types.Boolean Extends %Library.Boolean
{

/// Based on the superclass method, but adds a case for the delete instruction<br>
/// so that it is unchanged.
ClassMethod XSDToLogical(%val As %String) As %Boolean [ CodeMode = generator, ServerOnly = 1 ]
{
	If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault) {
		$$$GENERATE("	Q $case(%val,""true"":1,""false"":0,1:1,0:0,$C(34,34):$C(34,34),:"""")")
	}
	Quit $$$OK
}

ClassMethod LogicalToXSD(%val As %Boolean) As %String [ CodeMode = generator, ServerOnly = 1 ]
{
	If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault) {
		$$$GENERATE("	Q $s(%val=$C(34,34):$C(34,34),%val:""true"",1:""false"")")
	}
	Quit $$$OK
}

/// Based on the based on the IsValid method of the superclass, but adds a case<br>
/// for the delete instruction so it is valid.
ClassMethod IsValidDT(%val As %Library.RawString = "") As %Status
{
	// Based on the IsValid method on the superclass.
	Q $s($isvalidnum(%val,0,0,2)&&(+%val'=2):1,%val=$C(34,34):1,1:$$$ERROR($$$DTNotBoolean,%val))
}

/// Converts <var>%val</var> to a normalized value.
ClassMethod Normalize(%val As %Library.RawString) As %Boolean [ ServerOnly = 1 ]
{
	Quit $S(%val=$C(34,34):$C(34,34),1:%val\1)
}

/// Converts the input value <var>%val</var>, which is a string representing
/// a boolean value, into a boolean value.
/// <p>Returns the boolean value of the input string <var>%val</var>.
ClassMethod DisplayToLogical(%val As %String) As %Boolean [ ServerOnly = 0 ]
{
	Quit $S(%val=$C(34,34):$C(34,34),1:''%val)
}

}
