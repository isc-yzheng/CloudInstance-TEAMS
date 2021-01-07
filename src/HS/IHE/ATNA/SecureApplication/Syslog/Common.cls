Include HS.HC

/// Create a Syslog message based on RFC5424.
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
Class HS.IHE.ATNA.SecureApplication.Syslog.Common Extends %RegisteredObject
{

Parameter SETTINGS = "SyslogFacility,SyslogSeverity,ApplicationName,IncludeByteOrderMark,StripWhitespace";

/// Facilities:
///           <li>0             kernel messages
///           <li>1             user-level messages
///           <li>2             mail system
///           <li>3             system daemons
///           <li>4             security/authorization messages (note 1)
///           <li>5             messages generated internally by syslogd
///           <li>6             line printer subsystem
///           <li>7             network news subsystem
///           <li>8             UUCP subsystem
///           <li>9             clock daemon (note 2)
///          <li>10             security/authorization messages (note 1)
///          <li>11             FTP daemon
///          <li>12             NTP subsystem
///          <li>13             log audit (note 1)
///          <li>14             log alert (note 1)
///          <li>15             clock daemon (note 2)
///          <li>16             local use 0  (local0)
///          <li>17             local use 1  (local1)
///          <li>18             local use 2  (local2)
///          <li>19             local use 3  (local3)
///          <li>20             local use 4  (local4)
///          <li>21             local use 5  (local5)
///          <li>22             local use 6  (local6)
///          <li>23             local use 7  (local7)
Property SyslogFacility As %String(DISPLAYLIST = ",kernel,user,mail,system,security1,syslogd,printer,news,UUCP,clock1,security2,FTP,NTP,audit,alert,clock2,local0,local1,local2,local3,local4,local5,local6,local7", VALUELIST = ",0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23") [ InitialExpression = "13" ];

/// Severities:
///           <li>0       Emergency: system is unusable
///           <li>1       Alert: action must be taken immediately
///           <li>2       Critical: critical conditions
///           <li>3       Error: error conditions
///           <li>4       Warning: warning conditions
///           <li>5       Notice: normal but significant condition
///           <li>6       Informational: informational messages
///           <li>7       Debug: debug-level messages
Property SyslogSeverity As %String(DISPLAYLIST = ",Alert,Critical,Debug,Emergency,Error,Informational,Notice,Warning", VALUELIST = ",1,2,7,0,3,6,5,4") [ InitialExpression = "6" ];

/// The name of the application to include in the syslog header.  Whitespace is not allowed, and will be stripped out of the name entered here before submitting over the wire.
Property ApplicationName As %String [ InitialExpression = "InterSystems_HealthShare" ];

/// An optional argument to the syslog header is the Byte Order Mark (BOM).  This setting governs whether or not the BOM should be included.
Property IncludeByteOrderMark As %Boolean [ InitialExpression = "0" ];

/// Most ATNA repositories won't handle CR, LF, and TAB characters within the audit event.  This setting allows you to filter these characters out. 
Property StripWhitespace As %Boolean [ InitialExpression = "1" ];

Method GetSyslogHeader() As %String
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		Set tPriority		= "<" _ (($Case(..SyslogFacility = "", 1:1, :+..SyslogFacility) * 8) + $Case(..SyslogSeverity = "", 1:6, :+..SyslogSeverity)) _ ">"
		Set tVersion		= 1
		Set tTimeStamp		= $ZDateTime($Horolog, 3, 7)
		Set tHostName		= $$$HSNetworkHostName
		Set tAppName		= $Translate(..ApplicationName, $Char(32, 13, 10, 9), "")
		Set tProcessID		= $Job
		Set tMessageID		= "IHE+RFC-3881" // Per ITI TF-2a: 3.20.4.1.2, this has to be a fixed value
		Set tStructuredData	= "-" // Not supplied by HealthShare
		Set tByteOrderMark	= ..GetByteOrderMark()
		Set tSyslogHeader	= tPriority _ tVersion _ " " _ tTimeStamp _ " " _ tHostName _ " " _ tAppName _ " " _ tProcessID _ " " _tMessageID _ " " _  tStructuredData _ $Case(..IncludeByteOrderMark, 1:" " _ tByteOrderMark, :"")
	}
	Catch eException {
		$$$LOGSTATUS(eException.AsStatus())
		
		Set tSyslogHeader = ""
	}
	
	Quit tSyslogHeader
}

Method GetByteOrderMark() As %Binary
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		Set tEndian = $ZUtil(40,0,0)	// 0=little, 1=big
		Set tEncoding = 8				// To Do:  find a function that returns 8-bit, 16-bit, or 32-bit
		
		If (tEncoding = 8) { Set tBOM = $Char($ZHex("EF"), $ZHex("BB"), $ZHex("BF")) }					// Bytes:  EF BB BF
		ElseIf (tEndian = 0) && (tEncoding = 16) { Set tBOM = $Char($ZHex("FF"), $ZHex("EE")) }			// Bytes:  FF FE
		ElseIf (tEndian = 0) && (tEncoding = 32) { Set tBOM = $Char($ZHex("FF"), $ZHex("EE"), 00, 00) }	// Bytes:  FF FE 00 00
		ElseIf (tEndian = 1) && (tEncoding = 16) { Set tBOM = $Char($ZHex("FE"), $ZHex("FF")) }			// Bytes:  FE FF
		ElseIf (tEndian = 1) && (tEncoding = 32) { Set tBOM = $Char(00, 00, $ZHex("FE"), $ZHex("FF")) }	// Bytes:  00 00 FE FF  
		Else { Set tBOM = $Char($ZHex("EF"), $ZHex("BB"), $ZHex("BF")) }  // Assume 8-bit encoding
	}
	Catch eException {
		$$$LOGSTATUS(eException.AsStatus())
		
		Set tBOM = $Char($ZHex("EF"), $ZHex("BB"), $ZHex("BF"))	// Assume 8-bit encodiding on error
	}
	
	Quit tBOM
}

}
