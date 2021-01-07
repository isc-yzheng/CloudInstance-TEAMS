ROUTINE HSMOD.REST [Type=INC]
#; HSMOD.REST.inc

#include %occStatus
#include HSMOD.REST.Errors

/// macros for handling errors and %Status

/// Given a %Status code containing one of the HTTP status errors defined in HSMOD.REST.Errors.INC, return the canonical HTTP status 
///  return text, with optional explanatory text if present. Should not be used with non-HTTP errors. 
/// Example: 
///   Set tSC1 = $$$ERROR($$$HTTPStatus400BadRequest,"Some error text") 
///   Set %response.Status = $$$HTTPERRStatus(tSC1) 
#define HTTPERRStatus(%sc)     $P($P($system.Status.GetOneStatusText(%sc)," [")," %1")

/// same as HTTPERRStatus except the inputs are the error code arguments; saves the $$$ERROR step. 
///  Given the macro name of one of the HTTP status errors defined in HSMOD.REST.Errors.INC, return the canonical HTTP status return 
///  text, with optional explanatory text if an argument for it is included. Should not be used with non-HTTP errors. 
/// Example: 
///   Set %response.Status = $$$HTTPSCStatus($$$HTTPStatus400BadRequest,"Some other error text") 
#def1arg HTTPSCStatus(%args)   $P($P($system.Status.GetOneStatusText($$$ERROR(%args))," [")," %1")

/// Given a string matching the short text of one of the HTTP status codes defined in HSMOD.REST.Errors.INC, return the canonical 
///  HTTP status return text, with optional explanatory text appended if an argument for it is included. Should not be used with non-HTTP errors. 
/// Example: 
///  Set %response.Status = $$$HTTPStatus("400BadRequest","Yet another error text")
#def1arg HTTPStatus(%args)     $P($P($system.Status.GetOneStatusText($$$ERROR(##expression("$$$HTTPStatus"_$E($ZStrip($LG(%literalargs,1),"<>W"),2,*-1)_","_$ListToString($List(%literalargs,2,4),","))))," [")," %1")

/// Given an existing %Status object and the macro name of one of the HTTP status errors defined in HSMOD.REST.Errors.INC, 
///  return a new %Status object containing the original status with the given HTTP status appended, including optional explanatory text if an argument for it is included. 
///  Equivalent to using $system.Status.AppendStatus() but saves the step of converting the new piece to a %Status using $$$ERROR or whatnot
/// Example: 
///  Quit $$$AddHTTPSC(tSC,$$$HTTPStatus400BadRequest,"Still different error text")
#def1arg AddHTTPSC(%args)      $$$ADDSC(##expression($LG(%literalargs)),$$$ERROR(##expression($ListToString($List(%literalargs,2,4),","))))

/// Given an existing %Status object and a string matching the short text of one of the HTTP status errors defined in HSMOD.REST.Errors.INC, 
///  return a new %Status object containing the original status with the given HTTP status appended, including optional explanatory text if an argument for it is included.  
/// Example: 
///  Quit $$$AddHTTPStatus(tSC,"400BadRequest","Completely different error text")) 
#def1arg AddHTTPStatus(%args)  $$$ADDSC(##expression($LG(%literalargs)),$$$ERROR(##expression("$$$HTTPStatus"_$E($ZStrip($LG(%literalargs,2),"<>W"),2,*-1)_","_$ListToString($List(%literalargs,3,5),","))))

/// hardcoded flags for managing generated code for serialization proxy objects 
#define HSRESTProxyHandling					"Handling"
#define HSRESTProxyHandlingRESTProxy       	"REST serialization"
#define HSRESTProxyHandlingSerial 			"Serial"
#define HSRESTProxyHandlingStream 			"Stream"
#define HSRESTProxyHandlingDataType			"DataType"
#define HSRESTProxySkipWhileDeSerializing	"SkipWhileDeserializing"
#define HSRESTProxyPropertyType				"Type"
#define HSRESTProxyPropertyRuntimeType 		"RuntimeType"
#define HSRESTProxyPropertyIsCollection 	"IsCollection"
