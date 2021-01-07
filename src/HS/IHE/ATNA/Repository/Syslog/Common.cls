/// Parse a Syslog message based on RFC5424.
/// 	<br>
/// 	<br>The syslog header has the following ABNF [RFC5234] definition:
/// 		<li>SYSLOG-MSG      = HEADER SP STRUCTURED-DATA [SP MSG]
/// 		<li>HEADER          = PRI VERSION SP TIMESTAMP SP HOSTNAME SP APP-NAME SP PROCID SP MSGID
/// 	<br>
/// 	<br>The syslog field values have the following ABNF [RFC5234] definition:
/// 		<li>PRI             = "<" PRIVAL ">"
/// 		<li>PRIVAL          = 1*3DIGIT ; range 0 .. 191
/// 		<li>VERSION         = NONZERO-DIGIT 0*2DIGIT
/// 		<li>HOSTNAME        = NILVALUE / 1*255PRINTUSASCII
/// 		<li>APP-NAME        = NILVALUE / 1*48PRINTUSASCII
/// 		<li>PROCID          = NILVALUE / 1*128PRINTUSASCII
/// 		<li>MSGID           = NILVALUE / 1*32PRINTUSASCII
/// 		<li>TIMESTAMP       = NILVALUE / FULL-DATE "T" FULL-TIME
/// 		<li>FULL-DATE       = DATE-FULLYEAR "-" DATE-MONTH "-" DATE-MDAY
/// 		<li>DATE-FULLYEAR   = 4DIGIT
/// 		<li>DATE-MONTH      = 2DIGIT  ; 01-12
/// 		<li>DATE-MDAY       = 2DIGIT  ; 01-28, 01-29, 01-30, 01-31 based on month/year
/// 		<li>FULL-TIME       = PARTIAL-TIME TIME-OFFSET
/// 		<li>PARTIAL-TIME    = TIME-HOUR ":" TIME-MINUTE ":" TIME-SECOND [TIME-SECFRAC]
/// 		<li>TIME-HOUR       = 2DIGIT  ; 00-23
/// 		<li>TIME-MINUTE     = 2DIGIT  ; 00-59
/// 		<li>TIME-SECOND     = 2DIGIT  ; 00-59
/// 		<li>TIME-SECFRAC    = "." 1*6DIGIT
/// 		<li>TIME-OFFSET     = "Z" / TIME-NUMOFFSET
/// 		<li>TIME-NUMOFFSET  = ("+" / "-") TIME-HOUR ":" TIME-MINUTE
/// 		<li>STRUCTURED-DATA = NILVALUE / 1*SD-ELEMENT
/// 		<li>SD-ELEMENT      = "[" SD-ID *(SP SD-PARAM) "]"
/// 		<li>SD-PARAM        = PARAM-NAME "=" %d34 PARAM-VALUE %d34
/// 		<li>SD-ID           = SD-NAME
/// 		<li>PARAM-NAME      = SD-NAME
/// 		<li>PARAM-VALUE     = UTF-8-STRING ; characters '"', '\' and ']' MUST be escaped.
/// 		<li>SD-NAME         = 1*32PRINTUSASCII except '=', SP, ']', %d34 (")
/// 		<li>MSG             = MSG-ANY / MSG-UTF8
/// 		<li>MSG-ANY         = *OCTET ; not starting with BOM
/// 		<li>MSG-UTF8        = BOM UTF-8-STRING
/// 		<li>BOM             = %xEF.BB.BF
/// 		<li>UTF-8-STRING    = *OCTET ; UTF-8 string as specified in RFC 3629
/// 		<li>OCTET           = %d00-255
/// 		<li>SP              = %d32
/// 		<li>PRINTUSASCII    = %d33-126
/// 		<li>NONZERO-DIGIT   = %d49-57
/// 		<li>DIGIT           = %d48 / NONZERO-DIGIT
/// 		<li>NILVALUE        = "-"
Class HS.IHE.ATNA.Repository.Syslog.Common Extends %RegisteredObject
{

Method ParseSyslogHeader(pSyslogHeader As %String, ByRef pSyslogArray As %ArrayOfDataTypes = {$$$NULLOREF}) As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		If ('$IsObject(pSyslogArray) || 'pSyslogArray.%IsA("%ArrayOfDataTypes")) Set pSyslogArray = ##class(%ArrayOfDataTypes).%New()
		//1128 <110>1 2011-04-13T06:39:08Z laroccambp InterSystems_HealthShare 71475 - - 
		Do pSyslogArray.SetAt($Piece($Piece(pSyslogHeader, ">", 1), "<", 2), "SyslogHeader:Priority")
		Do pSyslogArray.SetAt($Piece($Piece(pSyslogHeader, " ", 1), ">", 2), "SyslogHeader:Version")
		Do pSyslogArray.SetAt($Piece(pSyslogHeader, " ", 2), "SyslogHeader:TimeStamp")
		Do pSyslogArray.SetAt($Piece(pSyslogHeader, " ", 3), "SyslogHeader:HostName")
		Do pSyslogArray.SetAt($Piece(pSyslogHeader, " ", 4), "SyslogHeader:ApplicationName")
		Do pSyslogArray.SetAt($Piece(pSyslogHeader, " ", 5), "SyslogHeader:ProcessID")
		Do pSyslogArray.SetAt($Piece(pSyslogHeader, " ", 6), "SyslogHeader:MessageID")
		Do pSyslogArray.SetAt($Piece(pSyslogHeader, " ", 7), "SyslogHeader:StructuredData")
		Do pSyslogArray.SetAt($Piece(pSyslogHeader, " ", 8), "SyslogHeader:ByteOrderMark")
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}

	Quit tStatus
}

}
