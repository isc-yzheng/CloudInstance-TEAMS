/// Web client that performs communications with the Hub(Registry) AU HI Web services, via SOAP messages.
Class HS.AU.HI.RemoteOperations Extends (Ens.BusinessOperation, %SOAP.WebClient, HS.HC.Util.Trace.Helper) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter ADAPTER = "EnsLib.SOAP.OutboundAdapter";

/// Web services client class
Parameter WEBSERVICECLIENTCLASS As %String = "HS.AU.HI.RemoteOperations";

Parameter INVOCATION = "Queue";

/// This is the URL used to access the web service.
Parameter LOCATION;

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.intersystems.com/hs/au/hiws";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "HS.AU.HI.WebServices";

Parameter SETTINGS = "ServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItems}";

Property ServiceName As %String [ InitialExpression = "HI.WebServices" ];

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HS.AU.Message.HI.SearchIndividualProviderRequest"> 
		<Method>ValidateHPII</Method>
	</MapItem>
	<MapItem MessageType="HS.AU.Message.HI.SearchOrganisationProviderRequest"> 
		<Method>ValidateHPIO</Method>
	</MapItem>
</MapItems>
}

/// Ensemble operation code which determines the endpoint information and executes the web service call
Method ValidateHPII(pRequest As HS.AU.Message.HI.SearchIndividualProviderRequest, Output pResponse As HS.AU.Message.HI.SearchIndividualProviderResponse) As %Status [ WebMethod ]
{
	try {
		Set tSC=$$$OK
		Set tSC = ..UpdateEndpoint() Quit:$$$ISERR(tSC)
		s pResponse= ..ValidHPII(pRequest)
	} Catch (eException) {
		Set tSC = eException.AsStatus()
	}
	Quit tSC
}

/// Ensemble operation code which determines the endpoint information and executes the web service call
Method ValidateHPIO(pRequest As HS.AU.Message.HI.SearchOrganisationProviderRequest, Output pResponse As HS.AU.Message.HI.SearchOrganisationProviderResponse) As %Status [ WebMethod ]
{
	try {
		Set tSC=$$$OK
		Set tSC = ..UpdateEndpoint() Quit:$$$ISERR(tSC)
		s pResponse= ..ValidHPIO(pRequest)
	} Catch (eException) {
		Set tSC = eException.AsStatus()
	}
	Quit tSC
}

/// code to execute the web service call
Method ValidHPII(pRequest As HS.AU.Message.HI.SearchIndividualProviderRequest) As HS.AU.Message.HI.SearchIndividualProviderResponse [ WebMethod ]
{
	Quit ..WebMethod("ValidHPII").Invoke(##this,"http://www.intersystems.com/hs/au/hiws/HS.AU.HI.WebServices.ValidHPII",pRequest)
}

/// code to execute the web service call
Method ValidHPIO(pRequest As HS.AU.Message.HI.SearchOrganisationProviderRequest) As HS.AU.Message.HI.SearchOrganisationProviderResponse [ WebMethod ]
{
	Quit ..WebMethod("ValidHPIO").Invoke(##this,"http://www.intersystems.com/hs/au/hiws/HS.AU.HI.WebServices.ValidHPIO",pRequest)
}

Method UpdateEndpoint()
{
	try {
		Set tSC=$$$OK
		#dim tEndPoint as HS.Registry.Service.SOAP = ##class(HS.Registry.Service.SOAP).EndPointForNameType(..ServiceName,"SOAP")
		If '$isObject(tEndPoint) Set tSC = $$$ERROR($$$GeneralError,"Service name:"_..ServiceName_" was not located") $$$LOGSTATUS(tSC) Quit
		Set ..Location=tEndPoint.EndPoint
		Set ..MTOMRequired = tEndPoint.MTOM
		Set ..SoapVersion = $Case(tEndPoint.SOAPVersion = "", 0:tEndPoint.SOAPVersion, :"1.2")
		Set ..SSLConfiguration = tEndPoint.SSLConfig

		If (tEndPoint.UsernameTokenProfileConfig '= "") && ##class(Ens.Config.Credentials).%ExistsId(tEndPoint.UsernameTokenProfileConfig) {
			#dim tCredentials As Ens.Config.Credentials
			Set tCredentials = ##class(Ens.Config.Credentials).%OpenId(tEndPoint.UsernameTokenProfileConfig)
			Set tSC = ..WSSecurityLogin(tCredentials.Username, tCredentials.Password)
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		If tEndPoint.ProxyHost]"",tEndPoint.ProxyPort]"" {
			Set ..HttpProxyPort=tEndPoint.ProxyPort
			Set ..HttpProxyServer=tEndPoint.ProxyHost
			Set ..HttpProxyHTTPS=tEndPoint.ProxyHTTPS
			Set ..HttpProxySSLConnect=tEndPoint.ProxyHTTPSSLConnect
			Set ..HttpProxyTunnel=tEndPoint.ProxyHTTPTunnel
		}
		If tEndPoint.HTTPCredentialsConfig]"" {
			Set tCredentials = ##class(Ens.Config.Credentials).%OpenId(tEndPoint.HTTPCredentialsConfig)
			Set ..HttpUsername=tCredentials.Username
			Set ..HttpPassword=tCredentials.Password
		}

	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
