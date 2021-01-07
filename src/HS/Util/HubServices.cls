Include HS.HC

/// For now, this is not using Ensemble to invoke the services. This may change in the future
Class HS.Util.HubServices [ Abstract ]
{

Parameter HSDEPLOY = 1;

/// This may be called on the hub or any gateway, to invoke a web service.
/// If called from the hub, it will directly call the service
/// If called from a gateway, it will make a web service call
/// Input pArgs... may not include by reference (or output) arguments.
/// While this is written to support any number of input pArgs, for future use
/// it's best to restrict to a single Request argument.
ClassMethod InvokeHubService(pServiceClassName As %String, pProxyClassName As %String, pMethodName As %String, Output pResponse, pArgs...) As %Status
{
	Quit ..Invoke(0,pServiceClassName, pProxyClassName, pMethodName, .pResponse, pArgs...)
}

ClassMethod InvokeHubServiceNoTrace(pServiceClassName As %String, pProxyClassName As %String, pMethodName As %String, Output pResponse, pArgs...) As %Status
{
	Quit ..Invoke(1,pServiceClassName, pProxyClassName, pMethodName, .pResponse, pArgs...)
}

ClassMethod Invoke(pNoTrace, pServiceClassName As %String, pProxyClassName As %String, pMethodName As %String, Output pResponse, pArgs...) As %Status
{
	try {
		Set tSC=##Class(HS.Util.HubServices).GetHubConnect(.tURL,.tUser,.tPW,.tSSLConfig,.tTrace,pNoTrace)
		QUIT:'tSC
		Set:pNoTrace tTrace=0
		#; if we are on the hub reset tracing if the production isn't running 
		If tTrace {
			set tSC=##class(Ens.Director).GetProductionStatus(.tProductionName,.pInitialState) 
			/// can't do a trace if the production isn't running
			If $$$ISOK(tSC) Set:pInitialState'=$$$eProductionStateRunning tTrace=0
		}
		If tTrace {
			Set tRequest=##Class(HS.Util.Trace.Request).%New()
			Set tRequest.CurrentClass=pServiceClassName
			Set tRequest.CurrentMethod=pMethodName
			Set tRequest.Comment="Invoke Hub Service Request"
			For tI=1:1:$G(pArgs) {
				If $Data(pArgs(tI)) {
					Set tVal=pArgs(tI)
					Set tItem=##Class(HS.Util.Trace.Item).%New()
					Set tItem.ItemName="Arg "_tI //later - maybe look at service class to get actual name?
					If $IsObject(tVal),tVal.%Extends("%XML.Adaptor") {
						DO tVal.XMLExportToString(.tObjVal)
						Set tItem.ItemValue=tObjVal
						Set tItem.ItemClass=tVal
					}
					Elseif $IsObject(tVal),tVal.%Extends("%Stream.Object") {
						Do tItem.ItemStream.CopyFrom(tVal)
						Do tVal.Rewind()
					}
					Else {Set tItem.ItemValue=tVal}
					Do tRequest.Items.Insert(tItem)
				}
			}
			Do ##Class(HS.Util.MaintenanceService).SendSync(tRequest)
		}
		IF tURL="" {
			Set pResponse=$zobjclassmethod(pServiceClassName,pMethodName,pArgs...), tSC=$$$OK QUIT:$$$ISERR(tSC)
		} Else {
			If $e(pServiceClassName)="%" Set $E(pServiceClassName)="_"
		
			Set tSoap=$zobjclassmethod(pProxyClassName,"%New")
			Set tSoap.Location=tURL_"/"_pServiceClassName_".cls"
			Set tSC=tSoap.WSSecurityLogin(tUser,tPW) QUIT:'tSC
			Set tSoap.SSLConfiguration=tSSLConfig
			Set pResponse=$zobjmethod(tSoap,pMethodName,pArgs...),tSC=$$$OK
		}
		If tTrace {
			Set tRequest=##Class(HS.Util.Trace.Request).%New()
			Set tRequest.CurrentClass=pServiceClassName
			Set tRequest.CurrentMethod=pMethodName
			Set tRequest.Comment="Invoke Hub Service Response"
			Set tVal=pResponse
			Set tItem=##Class(HS.Util.Trace.Item).%New()
			Set tItem.ItemName="Response" //later - maybe look at service class to get actual name?
			If $IsObject(tVal),tVal.%Extends("%XML.Adaptor") {
				DO tVal.XMLExportToString(.tObjVal)
				Set tItem.ItemValue=tObjVal
				Set tItem.ItemClass=tVal
			}
			Elseif $IsObject(tVal),tVal.%Extends("%Stream.Object") {
				Do tItem.ItemStream.CopyFrom(tVal)
				Do tVal.Rewind()
			}
			Else {Set tItem.ItemValue=tVal}
			Do tRequest.Items.Insert(tItem)
			Do ##Class(HS.Util.MaintenanceService).SendSync(tRequest)
		}
		QUIT

	} catch ex {
		Set tSC=$S($ZE["ZSOA":%objlasterror,1:$$$EnsSystemError) //$$$EnsSystemError
	}
	Quit tSC
}

/// This may be called on the hub or any gateway.
/// It returns a status and 3 output parameters:
/// When called from the hub, the output parameters will all be nil
/// When called from a gateway, the output parameters will be
/// Hub URL - Like the hub endpoint, but without the actual service class, User, PW
/// It will use the connection parameters from either the currently running production,
/// or if not running, from the most recently run production
ClassMethod GetHubConnect(Output pURL As %String, Output pUser As %String, Output pPW As %String, Output pSSLConfig As %String, Output pTrace As %Boolean, pNoTrace = 0) As %Status
{
	New %Ensemble
	try {
		Set tSC=$$$OK,pTrace=0
		#; if on the hub get the trace value from HS.Hub.Services
		If $$$IsHub	{
			Set pURL="", pUser="", pPW="" 
			Set tService=##Class(Ens.Host).GetShadowInstance("||HS.Hub.Services",.tSC2)
			Set:$isObject(tService) pTrace=tService.TraceOperations'=""
			Quit
		}
		#dim tConfig as HS.Registry.Service.SOAP = ##class(HS.Registry.Service.SOAP).EndPointForNameType("HSREGISTRY","SOAP")
		If $isObject(tConfig) {
			Set pURL = $p(tConfig.EndPoint,"/",1,$l(tConfig.EndPoint,"/")-1)
			Set pSSLConfig=tConfig.SSLConfig
			Set tEnsembleUser = tConfig.UsernameTokenProfileConfig
			Set tSC = ##class(Ens.Config.Credentials).GetCredentialsObj(.tCredentials, $classname(), "Ens.Config.Credentials", tEnsembleUser)
			Quit:$$$ISERR(tSC)
			Set pUser=tCredentials.Username, pPW=tCredentials.Password
		} Else {
			Set tSC =  $$$ERROR($$$HSErrComponentNotConfigured,"HSREGISTRY SOAP Service")
			Quit
		}
		Quit:pNoTrace  //don't bother checking for trace
		For name = "HUB","HS.Hub.HSWS.RemoteOperations" {
			Set tOperation=##Class(Ens.Host).GetShadowInstance("||"_name,.tSC2)
			If $$$ISOK(tSC2) {
				Set pTrace=tOperation.TraceOperations'=""
				Quit
			}
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
