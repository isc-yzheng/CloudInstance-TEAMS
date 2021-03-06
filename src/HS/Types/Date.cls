/// HealthShare-specific version of %Date so that on XML import we do<br>
/// not lose the delete instruction (two double quotes) to validation.<br>
/// The <b>%Date</b> data type class represents a date.
/// The logical value of the <b>%Date</b> data type is in <i>Cach&eacute;</i> <code>$H</code> format.
Class HS.Types.Date Extends %Library.Date
{

/// Declares the XSD type used when projecting XML Schemas.
Parameter XSDTYPE = "string";

/// Converts the SOAP encoded input date value into a Cache %Date value.
/// Modified from the superclass method to allow the import of the delete<br>
/// instruction (two double quotes).
ClassMethod XSDToLogical(%val As %String) As HS.Types.Date [ CodeMode = generator, ServerOnly = 1 ]
{
	Set qq=$C(34,34)
    If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault) {
		$$$GENERATE("	Quit:%val="_qq_qq_qq_" %val")
        $$$GENERATE("   Set len=$length(%val)")
        $$$GENERATE("   If len'=10 {")
        $$$GENERATE("       If $extract(%val,len)=""Z"" {")
        $$$GENERATE("           Set %val=$extract(%val,1,len-1),len=len-1")
        $$$GENERATE("       } ElseIf $case($extract(%val,len-5),""+"":1,""-"":1,:0) {")
        $$$GENERATE("           Set %val=$extract(%val,1,len-6),len=len-6")
        $$$GENERATE("       }")
        $$$GENERATE("   }")
        $$$GENERATE("   If $extract(%val,11,19)=""T00:00:00"" {")
        $$$GENERATE("       If (len=19)||(($extract(%val,20,21)="".0"")&&($translate($extract(%val,22,len),""0"","""")="""")) {")
        $$$GENERATE("           Set %val=$extract(%val,1,10)")
        $$$GENERATE("       }")
        $$$GENERATE("   }")
        $$$GENERATE("   Quit $select(%val="""":"""",1:$zdateh(%val,3,,,,,"_%parameter("MINVAL")_","_%parameter("MAXVAL")_",""""))")
    } Else {
        Set %code=0 
    }
    Quit $$$OK
}

/// Converts the Cache %Date value to the canonical SOAP encoded value.
ClassMethod LogicalToXSD(%val As HS.Types.Date) As %String [ CodeMode = generator, ServerOnly = 1 ]
{
 	Set qq=$C(34,34)
   If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault) {
        $$$GENERATE("   quit $select(%val="""":"""",%val="_qq_qq_qq_":"_qq_qq_qq_",1:$zdate(%val,3,,,,,"_%parameter("MINVAL")_"))")
    }
    Quit $$$OK
}

/// Converts <var>%val</var> to a normalized value.
ClassMethod Normalize(%val As %Library.RawString) As HS.Types.Date [ ServerOnly = 1 ]
{
   Quit $s($zu(115,13)&&(%val=$c(0)):"",(%val=""""""):%val,1:%val\1)
}

/// Tests if the logical value <var>%val</var>, which represents a date in <code>$H</code> format,
/// is valid. The validation is based on the class parameter settings used
/// for the class attribute this data type is associated with.
/// In this case, <a href="#MAXVAL">MAXVAL</a> and <a href="#MINVAL">MINVAL</a>.
ClassMethod IsValid(%val As %Library.RawString) As %Status [ CodeMode = generator, ServerOnly = 0 ]
{
	Set qq=$C(34,34)
	#; If subclass has a IsValidDT then call this
	If %property'="",$$$comSubMemberDefined(%class,$$$cCLASSproperty,%property,$$$cPROPmethod,"IsValidDT") {
		$$$GENERATE("	Q $s(##class("_%class_")."_$$$QN(%property_"IsValidDT")_"(%val):1,1:$$$ERROR($$$DTFailure,%val))")
		Quit $$$OK
	}
	$$$GENERATE("	Quit:%val="_qq_qq_qq_" $$$OK")
	i %parameter("VALUELIST")'="" d   QUIT $$$OK
	. s sep=$e(%parameter("VALUELIST")) ;for now
	. $$$GENERATE("	Q $s(%val'["""_sep_"""&&("_$$$quote(%parameter("VALUELIST")_sep)_"[("""_sep_"""_%val_"""_sep_""")):$$$OK,1:$$$ERROR($$$DTValueList,%val,"_$$$quote(%parameter("VALUELIST"))_"))")
	s minval=$s(%parameter("MINVAL")<-672045:-672045,%parameter("MINVAL")="":0,1:%parameter("MINVAL")) 
	s maxval=$s(%parameter("MAXVAL")>2980013:2980013,%parameter("MAXVAL")="":2980013,1:%parameter("MAXVAL")) 

	s str="$isvalidnum(%val,0,"_minval_","_maxval_")"
	s code="$s($zu(115,13)&&(%val=$c(0)):1,"_str_":1,'$isvalidnum(%val):$$$ERROR($$$DTNotNum,%val),"
	Set code=code_"%val<"_minval_":$$$ERROR($$$DTMinVal,%val,"_minval_"),1:$$$ERROR($$$DTMaxVal,%val,"_maxval_"))"
	$$$GENERATE("	Q "_code)
	QUIT $$$OK
}

/// Converts the value of <var>%val</var>, which is in logical <code>$H</code> format, into a display string.
/// The formatting is based on the value of the <a href="#FORMAT">FORMAT</a> parameter.
/// <p>Returns the formatted value of <var>%val</var>.
ClassMethod LogicalToDisplay(%val As HS.Types.Date) As %String [ CodeMode = generator, ServerOnly = 0 ]
{
    k %code s %code=0
 	Set qq=$C(34,34)
   if %parameter("VALUELIST")'="",%parameter("DISPLAYLIST")'="" {
		do GenerateValConv^%occLibrary(%parameter("VALUELIST"),%parameter("DISPLAYLIST"))
        QUIT $$$OK
    }
 	$$$GENERATE("	Quit:%val="_qq_qq_qq_" %val")
   if %parameter("MINVAL")<0 {
        if %parameter("FORMAT")="" $$$GENERATE("    quit $select(%val="""":"""",1:$zdate(+%val,,,4,,,"_%parameter("MINVAL")_"))") QUIT $$$OK
        $$$GENERATE("   quit $select(%val="""":"""",1:$zdate(+%val,"_%parameter("FORMAT")_",,4,,,"_%parameter("MINVAL")_"))")
    }
    else {
        if %parameter("FORMAT")="" $$$GENERATE("    quit $select(%val="""":"""",%val'[""-"":$zdate(%val,,,4),1:$$FormatJulian^%qarfunc(%val,-1))") QUIT $$$OK
        $$$GENERATE("   quit $select(%val="""":"""",%val'[""-"":$zdate(%val,"_%parameter("FORMAT")_",,4),1:$$FormatJulian^%qarfunc(%val,"_%parameter("FORMAT")_"))")
    }
    QUIT $$$OK
}

/// Converts the input value <var>%val</var>, which represents a date, into <code>$H</code> format.
/// <p>Returns the logical (<code>$H</code>) value of the input string <var>%val</var>.
ClassMethod DisplayToLogical(%val As %String) As HS.Types.Date [ CodeMode = generator, ServerOnly = 0 ]
{
 	Set qq=$C(34,34)
    if %parameter("VALUELIST")'="",%parameter("DISPLAYLIST")'="" {
		do GenerateValConv^%occLibrary(%parameter("DISPLAYLIST"),%parameter("VALUELIST"))
        QUIT $$$OK
    }
 	$$$GENERATE("	Quit:%val="_qq_qq_qq_" %val")
        #; -672045 is the date 01/01/0001.  If this field supports negative logical date values, use -672045 as the MINVAL in what we allow to be converted to a date
    if %parameter("FORMAT")="" { 
        if %parameter("MINVAL")<0 {
            $$$GENERATE(" q:%val="""" """" set %val=$zdh(%val,,,5,80,20,-672045,,""Error: '""_%val_""' is an invalid DISPLAY Date value"") q:%val||(%val=0) %val s %msg=%val ZTRAP ""ODAT""")
        }
        else {
            $$$GENERATE(" q:%val="""" """" set %val=$zdh(%val,,,5,80,20,,,""Error: '""_%val_""' is an invalid DISPLAY Date value"") q:%val||(%val=0) %val s %msg=%val ZTRAP ""ODAT""")
        }
    }
    else { 
        if %parameter("MINVAL")<0 {
            $$$GENERATE(" q:%val=""""||($zu(115,13)&&(%val=$c(0))) """" set %val=$zdh(%val,"_%parameter("FORMAT")_",,5,80,20,-672045,,""Error: '""_%val_""' is an invalid DISPLAY Date value"") q:%val||(%val=0) %val s %msg=%val ZTRAP ""ODAT""")
        }
        else {
            $$$GENERATE(" q:%val=""""||($zu(115,13)&&(%val=$c(0))) """" set %val=$zdh(%val,"_%parameter("FORMAT")_",,5,80,20,,,""Error: '""_%val_""' is an invalid DISPLAY Date value"") q:%val||(%val=0) %val s %msg=%val ZTRAP ""ODAT""")
        }
    }
    QUIT $$$OK
}

/// Converts <var>%val</var>, which represents a date in logical <code>$H</code> format, into ODBC date format.
/// <p>Returns the ODBC date string for the logical (<code>$H</code>) value <var>%val</var>.
///   Assume if there is a "-" in the value already, that we already have an ODBC format.
///   This is used by TO_DATE(val,"J") for Julian dates
ClassMethod LogicalToOdbc(%val As HS.Types.Date = "") As %String [ CodeMode = generator, ServerOnly = 1 ]
{
  	Set qq=$C(34,34)
   if %parameter("MINVAL")<0 {
        $$$GENERATE("   Quit $select(%val="""":"""",%val="_qq_qq_qq_":"_qq_qq_qq_",1:$zdate(+%val,3,,,,,"_%parameter("MINVAL")_"))")
    }
    else {
        $$$GENERATE("   Quit $select(%val="""":"""",%val="_qq_qq_qq_":"_qq_qq_qq_",%val'[""-"":$zdate(%val,3),1:%val)")
    }
    QUIT $$$OK
}

/// Converts <var>%val</var>, which represents a date in ODBC format, into <code>$H</code> format.
/// <p>Returns the <code>$H</code> value of the ODBC date string <var>%val</var>.
ClassMethod OdbcToLogical(%val As %String = "") As HS.Types.Date [ CodeMode = generator, ServerOnly = 1 ]
{
  	Set qq=$C(34,34)
 	$$$GENERATE("	Quit:%val="_qq_qq_qq_" %val")
        #; -672045 is the date 01/01/0001.  If this field supports negative logical date values, use -672045 as the MINVAL in what we allow to be converted to a date
    if %parameter("MINVAL")<0 {
        $$$GENERATE(" quit:%val=""""||($zu(115,13)&&(%val=$c(0))) """" set %val=$zdh(%val,3,,,,,-672045,,""Error: '""_%val_""' is an invalid ODBC/JDBC Date value"") q:%val||(%val=0) %val s %msg=%val ZTRAP ""ODAT""")
    }
    else {
        $$$GENERATE(" quit:%val=""""||($zu(115,13)&&(%val=$c(0))) """" set %val=$zdh(%val,3,,,,,,,""Error: '""_%val_""' is an invalid ODBC/JDBC Date value"") q:%val||(%val=0) %val s %msg=%val ZTRAP ""ODAT""")
    }
}

}
