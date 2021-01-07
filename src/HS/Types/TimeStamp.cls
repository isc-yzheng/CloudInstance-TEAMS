/// HealthShare-specific version of %TimeStamp so that on XML import we do<br>
/// not lose the delete instruction (two double quotes) to validation.<br>
/// Also implements a PRECISION parameter to support partial dates:<br>
/// -If PRECISION is "TIME", value must be a full timestamp.<br>
/// -If PRECISION is "DATE", value may also be formatted as YYYY-MM-DD.<br>
/// -If PRECISION is "PARTIALDATE", value may also be formatted as YYYY-MM and<br>
/// YYYY.<br>
/// There is also an additional value available for the XMLTIMEZONE parameter,<br>
/// "LOCAL" (the default). If XMLTIMEZONE = "LOCAL", then an imported timestamp<br>
/// with a UTC offset will be converted to local time (local to the HealthShare<br>
/// instance), and once imported, the offset will no longer be included in the<br>
/// value.
Class HS.Types.TimeStamp Extends %Library.TimeStamp
{

/// Declares the XSD type used when projecting XML Schemas.
Parameter XSDTYPE = "string";

/// "TIME" is the same precision as a %TimeStamp - the date and time components<br>
/// are required.<br>
/// "DATE" means that the time component is optional.<br>
/// "PARTIALDATE" means that the time component is optional, and also permits<br>
/// YYYY-MM and YYYY
Parameter PRECISION [ Constraint = "PARTIALDATE,DATE,TIME" ] = "TIME";

/// XMLTIMEZONE specifies the handling of timezone part of the XML format<br>
/// dateTime.<br>
/// "UTC" means convert to UTC on input.<br>
/// "IGNORE" means ignore the timezone.<br>
/// "LOCAL" means convert the timestamp to local time on input.
Parameter XMLTIMEZONE [ Constraint = "IGNORE,UTC,LOCAL", Flags = ENUM ] = "LOCAL";

/// Modified from the superclass method to allow the delete instruction (two<br>
/// double quotes) and possibly (depending on the PRECISION parameter) partial<br>
/// dates to pass validation.
ClassMethod IsValid(%val As %Library.RawString) As %Status [ CodeMode = generator, GenerateAfter = IsValidDT, ServerOnly = 0 ]
{
	s %code=0, qq=$C(34,34)
	$$$GENERATE("	Quit:%val="_qq_qq_qq_" $$$OK")
	$$$GENERATE("	Quit:$zu(115,13)&&(%val=$c(0)) $$$OK Set val=%val")
	If %parameter("PRECISION")="DATE" {
		$$$GENERATE("	Set:val?4N1""-""2N1""-""2N val=val_"" 00:00:00""") 
	}
	If %parameter("PRECISION")="PARTIALDATE" {
		$$$GENERATE("	Set:val?4N val=val_""-01-01 00:00:00""") 
		$$$GENERATE("	Set:val?4N1""-""2N val=val_""-01 00:00:00""") 
		$$$GENERATE("	Set:val?4N1""-""2N1""-""2N val=val_"" 00:00:00""") 
	}
	$$$GENERATE("	Quit:($length(val)<19||($zdth(val,3,,,,,,,,"""")="""")) $$$ERROR($$$DTTimeStamp,%val)")
	$$$GENERATE("	Quit $$$OK")
	QUIT $$$OK
}

/// Modified from the superclass method to allow the import of the delete<br>
/// instruction (two double quotes) and partial dates, and to convert a<br>
/// timestamp to local time when XMLTIMEZONE="LOCAL".
ClassMethod XSDToLogical(%val As %String) As %TimeStamp [ CodeMode = generator, ServerOnly = 1 ]
{
	Set qq=$C(34,34)
	If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault) {
		$$$GENERATE("	Quit:%val="_qq_qq_qq_" %val")
		IF %parameter("PRECISION")="TIME" $$$GENERATE(" If $length($get(%val),""T"")'=2 Quit """"")
		$$$GENERATE(" Set dt=$translate(%val,""T"","" "")")
		$$$GENERATE(" Set len=$length(%val)")
		$$$GENERATE(" If $extract(%val,len)=""Z"" {")
		$$$GENERATE("   Set dt=$extract(dt,1,len-1)")
		$$$GENERATE(" } ElseIf len>10&&$case($extract(%val,len-5),""+"":1,""-"":1,:0) {")
		$$$GENERATE("   If $extract(%val,len-2)'="":"" Quit """"")
		$$$GENERATE("   Set dt=$extract(dt,1,len-6)")
		If %parameter("XMLTIMEZONE")'="IGNORE" {
			$$$GENERATE("   Set f=$piece(dt,""."",2) If f'="""" Set f="".""_f,dt=$piece(dt,""."")")
			$$$GENERATE("   Set t=$zdatetimeh(dt,3,1,,,,,,,"""") If t="""" Quit """_%parameter("XMLDEFAULTVALUE")_"""")
			$$$GENERATE("   Set d=$piece(t,"","")")
			$$$GENERATE("   Set s=$piece(t,"","",2)")
			$$$GENERATE("   Set z=($extract(%val,len-4,len-3)*60+$extract(%val,len-1,len))*60")
			$$$GENERATE("   If $extract(%val,len-5)=""-"" {")
			$$$GENERATE("     Set s=s+z")
			$$$GENERATE("     If s>=(24*60*60) Set d=d+1,s=s-(24*60*60)")
			$$$GENERATE("   } Else {")
			$$$GENERATE("     Set s=s-z")
			$$$GENERATE("     If s<0 Set d=d-1,s=s+(24*60*60)")
			$$$GENERATE("   }")
			If %parameter("XMLTIMEZONE")="LOCAL" {
				$$$GENERATE("   Set dt=$zdatetimeh(d_"",""_s,-3,,,,,,,,"""")")
				$$$GENERATE("   Set:dt'="""" dt=$zdatetime(dt,3,1,0,,,,,,,"""")")
				
			}
			Else {
				$$$GENERATE("   Set dt=$zdatetime(d_"",""_s,3,1,0,,,,,,,"""")")
			}
			$$$GENERATE("   Quit $select(dt="""":"""",1:dt_f)")
		}
		$$$GENERATE(" }")
		If %parameter("PRECISION")="PARTIALDATE" {
			$$$GENERATE(" If dt?4N1""-""2N,$zdatetimeh(dt_""-01"",3,1,,,,,,,"""")'="""" Quit dt")
			$$$GENERATE(" If dt?4N,$zdatetimeh(dt_""-01-01"",3,1,,,,,,,"""")'="""" Quit dt")
		}
		$$$GENERATE(" If dt?4N1""-""2N1""-""2N1"" ""2N1"":""2N1"":""2N,$zdatetimeh(dt,3,1,,,,,,,"""")="""" Quit """_%parameter("XMLDEFAULTVALUE")_"""")
		$$$GENERATE(" Quit dt")
	} Else {
		Set %code=0 
	}
	Quit $$$OK
}

/// Converts the Cache %TimeStamp value to the canonical SOAP encoded value.<br>
/// Modified from the superclass method to allow the export of partial dates.
ClassMethod LogicalToXSD(%val As %TimeStamp) As %String [ CodeMode = generator, ServerOnly = 1 ]
{
	If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault) {
		Set %codemode=$$$cMETHCODEMODEEXPRESSION
		If %parameter("XMLTIMEZONE")="IGNORE" {
			Set %code="$translate(%val,"" "",""T"")"
		} Else {
			Set %code="$select($L(%val)<11:%val,1:$translate(%val,"" "",""T"")_""Z"")"
		}
	} Else {
		Set %code=0 
	}
	Quit $$$OK
}

/// This resolves a partial date or date into a full time stamp<br>
/// pFlavor can be start or end<br>
/// (***TBD - later - add support for middle?)
ClassMethod LogicalToTimeStamp(pVal, pFlavor As %String = "end") As %String
{
	Quit:$L(pVal)>10 pVal // Already a full time stamp
	Quit:pFlavor="start" pVal_$S($L(pVal)=4:"-01-01",$L(pVal)=7:"-01",1:"")_" 00:00:00"
	If pVal?4N {
		Set pVal=pVal_"-12-31"
	} ElseIf pVal?4N1"-"2N {
		If $P(pVal,"-",2)=12 {
			Set pVal=pVal_"-31"
		} Else {
			Set pVal=$P(pVal,"-")_"-"_($P(pVal,"-",2)+1)_"-01"
			//we now have the start of the next month.  Convert to $H, subtract 1, and back to YYYY-MM-DD
			Set pVal=$ZDATEH(pVal,3)-1,pVal=$ZDATE(pVal,3)
		}
	}
	Quit pVal_" 23:59:59"
}

ClassMethod Normalize(%val As %Library.RawString) As %TimeStamp [ CodeMode = expression, ServerOnly = 1 ]
{
%val
}

}
