Class HS.Util.Mirror.WebServicesClient Extends %SOAP.WebClient
{

/// This is the URL used to access the web service.
Parameter LOCATION;

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.intersystems.com/hs/util/mirror";

/// Use xsi:type attribute for literal types. 
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "HS.Util.Mirror.WebServices";

Method AgentLog(pInstance As %String, pDatabase As %String, pStep As %String, pMethod As %String, pIsError As %Boolean, pMessage As %String) As %Status [ WebMethod ]
{
	Quit ..WebMethod("AgentLog").Invoke(##this,"http://www.intersystems.com/hs/util/mirror/HS.Util.Mirror.WebServices.AgentLog",pInstance,pDatabase,pStep,pMethod,pIsError,pMessage)
}

}
