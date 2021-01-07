/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Used in a conjunction with a com.intersystems.gateway.bh.BusinessService to create a Java Business Service.
Class Ens.Java.Service.Standard Extends Ens.BusinessService [ Abstract ]
{

/// Config Name of the EnsLib.JavaGateway.Initiator with which this service connects
Property InitiatorService As %String;

/// Credentials for Java to use when authenticating with InterSystems IRIS
Property Credentials As %String;

/// Path to JAR file containing Java-side implementation of this Business Service
Property JarFile As %String(MAXLEN = 255);

/// Database location where incoming messages will be persisted.  Defaults to ^CacheStream if blank (must start with ^)
Property Location As %String [ Internal ];

Property Restart As %Boolean [ InitialExpression = 0 ];

/// User-configurable settings for this service
Parameter SETTINGS = "InitiatorService:Basic:selector?context={Ens.ContextSearch/ProductionItems?className=EnsLib.JavaGateway.Initiator&productionName=@productionId},Credentials:Additional:credentialsSelector,JarFile:Additional:fileSelector?wildcard=*.jar";

/// Domain for $$$Text()
Parameter DOMAIN = "Ensemble";

/// This method is called from Ens.Config.Production::SaveToClass() when any changes have been
/// applied to the instance.  If the 'Enabled' state has changed, we propagate the change to the Java implementation.
ClassMethod OnConfigChange(pProduction As Ens.Config.Production, pItem As Ens.Config.Item) [ Internal ]
{
	#dim tSC As %Status = $$$OK
   	#dim tConfigName As %String = pItem.Name
 	#dim tRunning As %Boolean = ##class(Ens.Director).IsProductionRunning(.pProductionName)
 	Kill $$$EnsRuntimeAppData(pItem.Name,"InRestart")
 	if (tRunning) {
		#dim tWasEnabled As %Boolean = $$$ConfigIsEnabled(tConfigName)
		#dim tIsEnabled As %Boolean = ##class(Ens.Director).IsItemEnabled(tConfigName)
		//If disabling, handle here.  If enabling, handle in OnProductionStart so that Host Monitor Status is not overwritten if it is an error
		if 'tIsEnabled && tWasEnabled {
			set tSC = ..UpdateBusinessService(pItem)
			if $$$ISERR(tSC) {
				Set tOldJob = $$$JobConfigName
				// First make sure that the message will appear under the correct config item
				Set ($$$EnsJobStatus($$$SystemName,$Job,$$$eJobGuestConfigName),$$$EnsJobLocal("GuestConfigName"))=tConfigName
				Do ##class(Ens.Util.Trace).SetTraceOptimizer()
				
				$$$LOGERROR($System.Status.GetErrorText(tSC))
				$$$SetHostMonitor(tConfigName,$$$eMonitorStatus,"Error")
				
				Kill $$$EnsJobStatus($$$SystemName,$Job,$$$eJobGuestConfigName), $$$EnsJobLocal("GuestConfigName")
			 	Do:(tOldJob'="") ##class(Ens.Util.Trace).SetTraceOptimizer()
			}
		} 
		If tIsEnabled && 'tWasEnabled {
			set $$$EnsRuntimeAppData(pItem.Name,"InRestart") = 1
		}
 	}
}

ClassMethod OnProductionStart(pConfigName) As %Status
{
	#dim tSC As %Status = $$$OK
	
	Do {
		Set tSC = ##class(Ens.Java.Utils).GetSetting(pConfigName,"InitiatorService",.tInitiatorService)
		Quit:$$$ISERR(tSC)
		If (tInitiatorService="") {
			Set tSC = $$$ERROR($$$PropertyRequired,"InitiatorService")
			Quit
		}
		
		Set tSC = ##class(Ens.Java.Utils).GetSetting(pConfigName,"TargetConfigNames",.tTargetConfigNames)
		Quit:$$$ISERR(tSC)
		
		If $D($$$EnsRuntimeAppData(pConfigName,"InRestart"),tRestart)&&tRestart {
			Set pItem = ##class(Ens.Config.Production).OpenItemByConfigName(pConfigName,.tSC)
			Quit:$$$ISERR(tSC)
			set tSC = ..UpdateBusinessService(pItem)
			Quit:$$$ISERR(tSC)
		}
	} While 0
	
	If $$$ISERR(tSC) {
		Set tOldJob = $$$JobConfigName
		// First make sure that the message will appear under the correct config item
		Set ($$$EnsJobStatus($$$SystemName,$Job,$$$eJobGuestConfigName),$$$EnsJobLocal("GuestConfigName"))=pConfigName
		Do ##class(Ens.Util.Trace).SetTraceOptimizer()
		
		$$$LOGERROR($System.Status.GetErrorText(tSC))
		$$$SetHostMonitor(pConfigName,$$$eMonitorStatus,"Error")
		
		Kill $$$EnsJobStatus($$$SystemName,$Job,$$$eJobGuestConfigName), $$$EnsJobLocal("GuestConfigName")
	 	Do:(tOldJob'="") ##class(Ens.Util.Trace).SetTraceOptimizer()
	}
	
	If ""=tTargetConfigNames { 
		Set tOldJob = $$$JobConfigName
		// First make sure that the message will appear under the correct config item
		Set ($$$EnsJobStatus($$$SystemName,$Job,$$$eJobGuestConfigName),$$$EnsJobLocal("GuestConfigName"))=pConfigName
		Do ##class(Ens.Util.Trace).SetTraceOptimizer()

		$$$LOGWARNING("No Target Config Name configured") 
		
		Kill $$$EnsJobStatus($$$SystemName,$Job,$$$eJobGuestConfigName), $$$EnsJobLocal("GuestConfigName")
	 	Do:(tOldJob'="") ##class(Ens.Util.Trace).SetTraceOptimizer()
	}

	
	Kill $$$EnsRuntimeAppData(pConfigName,"InRestart")
	Quit $$$OK
}

/// Invoked when the Enabled state of an Ens.JavaBusinessService has changed.
/// Determines the new state and notifies the corresponding Java service.
ClassMethod UpdateBusinessService(pConfigItem As Ens.Config.Item) As %Status [ Internal ]
{
	#dim tSC As %Status = $$$OK
	#dim tConfigName As %String = pConfigItem.Name

	// find an EnsLib.JavaGateway.Service
	#dim tGatewayConfigName As %String
	Set tSC = ##class(Ens.Java.Utils).GetSetting(tConfigName,"InitiatorService",.tGatewayConfigName)
	Quit:$$$ISERR(tSC) tSC
	Quit:(""=tGatewayConfigName) $$$ERROR($$$PropertyRequired,"InitiatorService")
	// get Address
	#dim tAddress As %String = ""
	Set tSC = ##class(Ens.Java.Utils).GetSetting(tGatewayConfigName, "Address", .tAddress)
	Quit:$$$ISERR(tSC) tSC
	
	// get Port
	#dim tPort As %String = ""
	Set tSC = ##class(Ens.Java.Utils).GetSetting(tGatewayConfigName, "Port", .tPort)
	Quit:$$$ISERR(tSC) tSC
	
	#dim tEndpoint As %String = tAddress_";"_tPort_";"_$NAMESPACE
	#dim tJavaGateway as EnsLib.JavaGateway.JavaGateway;
	Set tSC = ##class(EnsLib.JavaGateway.Service).ConnectGateway(tEndpoint, .tJavaGateway)
	Quit:$$$ISERR(tSC) tSC
	
	// notify Java about the state change
	#dim tIsEnabled As %Boolean = pConfigItem.Enabled
	If tIsEnabled {
		Set tSC = ..DoLogin(pConfigItem, tJavaGateway)
	} Else {
		Set tSC = ..DoLogout(pConfigItem, tJavaGateway)
	}
	
	Quit tSC
}

/// Notify the Java service associated with a given configuration item that it has
/// been enabled (either explicitly or along with the production).
ClassMethod DoLogin(pConfigItem As Ens.Config.Item, pJavaGateway As EnsLib.JavaGateway.JavaGateway) As %Status [ Internal ]
{
	#dim tSC As %Status = $$$OK
	
	Do {
		
		#dim tOldJob As %String = $$$JobConfigName
		// Make sure that any messages we log appear under the correct config item
		Set ($$$EnsJobStatus($$$SystemName,$Job,$$$eJobGuestConfigName),$$$EnsJobLocal("GuestConfigName")) = pConfigItem.Name
	 	Do ##class(Ens.Util.Trace).SetTraceOptimizer()

		#dim tJavaClass As %String = $PARAMETER(pConfigItem.ClassName, "JavaClass")
		If tJavaClass="" {
			Set tSC = $$$ERROR($$$ParameterNameRequired, "JavaClass")
			Quit
		}	
		
		#dim tJarFile As %String = ""
		Do pConfigItem.GetModifiedSetting("JarFile",.tJarFile)
		
		// validate jar file
		Set tSC = ##class(Ens.Java.Utils).ValidateJar(pJavaGateway, tJarFile, tJavaClass)
		Quit:$$$ISERR(tSC)
		
		Set tSC = ##class(Ens.Java.Utils).GetProductionArgs(pConfigItem,.argv)
		Quit:$$$ISERR(tSC)

		Set tStatus = ##class(com.intersystems.gateway.bh.ProductionConcrete).init(pJavaGateway, argv)
		If (1'=tStatus) {
			Set tSC = $$$ERROR($$$ErrorExecutingJavaCommand, "init()"_" returned: """_tStatus_"""")
		}
	} While 0
	
	// log here to ensure error appears in the correct config item
	If $$$ISERR(tSC) {
		$$$LOGERROR($System.Status.GetErrorText(tSC))
		$$$SetHostMonitor(pConfigItem.Name,$$$eMonitorStatus,"Error")
	}
	Kill $$$EnsJobStatus($$$SystemName,$Job,$$$eJobGuestConfigName), $$$EnsJobLocal("GuestConfigName")
 	Do:(tOldJob'="") ##class(Ens.Util.Trace).SetTraceOptimizer()

	Quit $$$OK
}

/// Notify the Java service associated with a given configuration item that it has
/// been disabled (either explicitly or along with the production).
ClassMethod DoLogout(pConfigItem As Ens.Config.Item, pJavaGateway As EnsLib.JavaGateway.JavaGateway) As %Status [ Internal ]
{
	#dim tSC As %Status = $$$OK
	
	#dim tOldJob As %String = $$$JobConfigName
	Set ($$$EnsJobStatus($$$SystemName,$Job,$$$eJobGuestConfigName),$$$EnsJobLocal("GuestConfigName"))=pConfigItem.Name
 	Do ##class(Ens.Util.Trace).SetTraceOptimizer()

	Set tStatus = ##class(com.intersystems.gateway.bh.ProductionConcrete).tearDown(pJavaGateway, pConfigItem.Name)
	If (1'=tStatus) {
		Set tSC = $$$ERROR($$$ErrorExecutingJavaCommand, "tearDown()"_" returned: """_tStatus_"""")
		$$$LOGERROR($System.Status.GetErrorText(tSC))
		$$$SetHostMonitor(pConfigItem.Name,$$$eMonitorStatus,"Error")
	}
	
	Kill $$$EnsJobStatus($$$SystemName,$Job,$$$eJobGuestConfigName), $$$EnsJobLocal("GuestConfigName")
 	Do:(tOldJob'="") ##class(Ens.Util.Trace).SetTraceOptimizer()

	Quit $$$OK
}

}
