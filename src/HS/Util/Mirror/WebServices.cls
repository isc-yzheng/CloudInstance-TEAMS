/// Used by the mirror monitor to "phone home" a log of what's happened, good and bad
Class HS.Util.Mirror.WebServices Extends %SOAP.WebService
{

Parameter DOMAIN = "HS";

/// Name of the WebService.
Parameter SERVICENAME = "HS.Util.Mirror.WebServices";

Parameter NAMESPACE = "http://www.intersystems.com/hs/util/mirror";

Parameter XMLIGNOREINVALIDTAG As BOOLEAN [ Internal ] = 1;

ClassMethod AgentLog(pInstance As %String, pDatabase As %String, pStep As %String, pMethod As %String, pIsError As %Boolean, pMessage As %String) As %Status [ Internal, WebMethod ]
{
	Set tSourceClass=pInstance_":MirrorMonitorAgent"
	If pIsError {
		Do ##class(Ens.Util.Log).LogError(tSourceClass,pMethod,pMessage)
	} Else {
		Do ##class(Ens.Util.Log).LogInfo(tSourceClass,pMethod,pMessage)
	}
	If pMethod="CreateDB",pIsError Set ^%SYS("HealthShare","CreateDB","Errors",pInstance)=pMessage
	If pStep'="" {
		Set ^%SYS("HealthShare","SystemAPI",pDatabase,pStep,"Log",pInstance)=$H_"^"_pMessage
		Set ^%SYS("HealthShare","SystemAPILogStep",pDatabase,pInstance)=pStep
	}
	Quit $$$OK
}

Method OnPreWebMethod() [ Internal, ServerOnly = 1 ]
{
	If '$SYSTEM.Security.Check("%HS_WebServices","USE") {
		Set tFault = ..MakeSecurityFault("FailedAuthentication")
		Do ..ReturnFault(tFault)
	}
	Quit
}

}
