Include (HS.HC, HS.HC.Errors)

/// Invoke a service on the audit production
/// Intended primarily for reporting
/// Similar to HubServices, except it always goes thru SOAP, even if on the same instance
/// Trace is controlled by the same hub tracing switch
Class HS.Util.AuditServices [ Abstract ]
{

Parameter HSDEPLOY = 1;

/// Input pArgs... may not include by reference (or output) arguments.
ClassMethod InvokeAuditService(pServiceClassName As %String, pProxyClassName As %String, pMethodName As %String, Output pResponse, pArgs...) As %Status
{
	try {
		Set tSC=..GetAuditConnect(.tURL,.tUser,.tPW,.tSSLConfig,.tTrace)
		QUIT:'tSC
		#; reset tracing if the production isn't running 
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

		If $e(pServiceClassName)="%" Set $E(pServiceClassName)="_"
	
		Set tSoap=$zobjclassmethod(pProxyClassName,"%New")
		Set tSoap.Location=tURL_"/"_pServiceClassName_".cls"
		Set tSC=tSoap.WSSecurityLogin(tUser,tPW) QUIT:'tSC
		Set tSoap.SSLConfiguration=tSSLConfig
		Set pResponse=$zobjmethod(tSoap,pMethodName,pArgs...),tSC=$$$OK

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
ClassMethod GetAuditConnect(Output pURL As %String, Output pUser As %String, Output pPW As %String, Output pSSLConfig As %String, Output pTrace As %Boolean) As %Status
{
	New %Ensemble
	try {
		Set tSC=$$$OK,pTrace=0
		#; if on the hub get the trace value from HS.Hub.Services
		#dim tConfig as HS.Registry.Service.SOAP = ##class(HS.Registry.Service.SOAP).EndPointForNameType("HSAudit.Repository","SOAP")
		If $isObject(tConfig) {
			Set pURL = $p(tConfig.EndPoint,"/",1,$l(tConfig.EndPoint,"/")-1)
			Set pSSLConfig=tConfig.SSLConfig
			Set tEnsembleUser = tConfig.UsernameTokenProfileConfig
			Set tCredentials = ##class(Ens.Config.Credentials).%OpenId(tEnsembleUser)
			Set pUser=tCredentials.Username, pPW=tCredentials.Password
		} Else {
			Set tSC =  $$$ERROR($$$HSErrComponentNotConfigured,"HSAudit.Repository SOAP Service")
			Quit
		}
		If $$$IsHub	{
			Set tService=##Class(Ens.Host).GetShadowInstance("||HS.Hub.Services",.tSC2)
			Set:$isObject(tService) pTrace=tService.TraceOperations'=""
		} Else {
			For name = "HUB","HS.Hub.HSWS.RemoteOperations" {
				Set tOperation=##Class(Ens.Host).GetShadowInstance("||"_name,.tSC2)
				If $$$ISOK(tSC2) {
					Set pTrace=tOperation.TraceOperations'=""
					Quit
				}
			}
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
