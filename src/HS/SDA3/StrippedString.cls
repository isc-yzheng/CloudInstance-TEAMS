/// HealthShare-specific version of %String that strips leading and trailing<br>
/// whitespace from the value on XML import. Currently only the Code and<br>
/// Description of HS.SDA3.CodeTableDetail are of type StrippedString.
Class HS.SDA3.StrippedString Extends %Library.String
{

/// Strip leading and trailing whitespace from input value (via $ZSTRIP, mask<br>
/// code "W")
ClassMethod XSDToLogical(%val As %String) As %String [ CodeMode = generator, ServerOnly = 1 ]
{
	Set %code=0
	$$$GENERATE(" Q $Zstrip(%val,""<>W"")")
	/*Set xmllist=$get(%parameter("XMLLISTPARAMETER"))
	If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault),
	   		$case(xmllist,"":0,"VALUELIST":0,:1),%parameter("VALUELIST")'="",$get(%parameter(xmllist))'="" {
		s sep=$e(%parameter(xmllist))
		if $l(%parameter("VALUELIST"))+$l(%parameter(xmllist))<4000 {
			set line="$case(%val"
			f i=2:1:$l(%parameter(xmllist),sep) s line=line_","_$$$quote($p(%parameter(xmllist),sep,i))_":"_$$$quote($p(%parameter("VALUELIST"),sep,i))
			$$$GENERATE("	Q "_line_",:"""")")
		}
		else {
			set line=""
			f i=2:1:$l(%parameter(xmllist),sep) { s line=line_" q:%val="_$$$quote($p(%parameter(xmllist),sep,i))_" "_$$$quote($p(%parameter("VALUELIST"),sep,i)) if $l(line)>4000 { $$$GENERATE(line) s line="" } }
			if line'="" { $$$GENERATE(line_"	Q %val") } else { $$$GENERATE("	Q """"") }
		}
	}
	*/
	Quit $$$OK
}

/// The maximum number of characters the string can contain.
Parameter MAXLEN As INTEGER = 32000;

}
