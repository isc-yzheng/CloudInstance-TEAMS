/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsJBH

/// A service responsible for starting, monitoring and stopping the Java Gateway Server in a production.
/// Also instantiates Java services associated with instances of Ens.Java.BusinessService found
/// within the production.
Class EnsLib.JavaGateway.Initiator Extends EnsLib.JavaGateway.Service
{

/// Domain for $$$Text()
Parameter DOMAIN = "Ensemble";

Property JavaGateway As EnsLib.JavaGateway.JavaGateway [ Internal ];

Method OnInit() As %Status
{
	#dim tSC As %Status = $$$OK
	#dim ex As %Exception.StatusException
		
	Set tSC = ##super()
	Quit:$$$ISERR(tSC) tSC

	#dim tProdName As %String = ##class(Ens.Director).GetActiveProductionName()
	Quit:(tProdName="") $$$ERROR($$$GeneralError, "GetActiveProductionName()")

	#dim tProd As Ens.Config.Production = ##class(Ens.Config.Production).%OpenId(tProdName)
	Quit:'$ISOBJECT(tProd) $$$ERROR($$$GeneralError, "Production '"_tProdName_"'")

	// connect to the Java Gateway
	#dim tJavaGateway as EnsLib.JavaGateway.JavaGateway
	#dim tEndpoint As %String = ..Address_";"_..Port_";"_$NAMESPACE
	Set tSC = ..ConnectGateway(tEndpoint, .tJavaGateway)
	Quit:$$$ISERR(tSC) tSC
	Set ..JavaGateway = tJavaGateway
	
	// import generic implementation of Java Business Hosts
	Set tSC = ..JavaGateway.%Import($$$JavaJBHPackage_".ProductionConcrete", .tJavaClasses)
	Quit:$$$ISERR(tSC) tSC

	// find and start up all of the Java services of type Ens.Java.BusinessService
	// which are currently enabled and use this Initiator
	#dim tConfigItems As list of Ens.Config.Item = tProd.Items
	#dim tConfigItemsCount As %Integer = tConfigItems.Count()
	#dim tConfigItem As Ens.Config.Item
	For i=1:1:tConfigItemsCount {
		Set tConfigItem = tConfigItems.GetAt(i)
		Set tClassName = tConfigItem.ClassName
		#dim tEnabled As %Boolean = tConfigItem.Enabled
		#dim tTargetClass As %Boolean = $CLASSMETHOD(tClassName, "%Extends", $$$JBHBSSuperClass)
		If tEnabled && tTargetClass {
			Set tFound = tConfigItem.GetModifiedSetting("InitiatorService",.tInitiatorVal)
			If tFound && (tInitiatorVal = ..%ConfigName) {
				$$$LOGINFO($$$FormatText($$$Text("Starting Config Item '%1'"),tConfigItem.Name))
				Do ##class(Ens.Java.Service.Standard).DoLogin(tConfigItem, ..JavaGateway)
			}
		}
	}

	Quit $$$OK
}

Method OnTearDown() As %Status
{
	// find and shut down all of the Java services of type Ens.Java.BusinessService
	// which are currently enabled and use this Initiator
	
	#dim tSC As %Status = $$$OK
	#dim ex As %Exception.StatusException

	#dim tProdName As %String = ##class(Ens.Director).GetActiveProductionName()
	Quit:(tProdName="") $$$ERROR($$$GeneralError, "GetActiveProductionName()")

	#dim tProd As Ens.Config.Production = ##class(Ens.Config.Production).%OpenId(tProdName)
	Quit:'$ISOBJECT(tProd) $$$ERROR($$$GeneralError, "Error opening production '"_tProdName_"'")

	#dim tConfigItems As list of Ens.Config.Item = tProd.Items
	#dim tConfigItemsCount As %Integer = tConfigItems.Count()

	For i=1:1:tConfigItemsCount {
		#dim tConfigItem As Ens.Config.Item = tConfigItems.GetAt(i)
		#dim tClassName As %String = tConfigItem.ClassName
		#dim tEnabled As %Boolean = tConfigItem.Enabled
		#dim tTargetClass As %Boolean = $CLASSMETHOD(tClassName, "%Extends", $$$JBHBSSuperClass)
		If tEnabled && tTargetClass {
			Set tFound = tConfigItem.GetModifiedSetting("InitiatorService",.tInitiatorVal)
			If tFound && (tInitiatorVal = ..%ConfigName) {

				Set tStatus = ##class(Ens.Java.Service.Standard).DoLogout(tConfigItem, ..JavaGateway)

				If $$$ISERR(tStatus) {
					// don't bail out here: 1) other items to stop, and 2) want to ensure
					// that ##super() gets a chance to shut down the JVM
					Set tSC = $System.Status.AppendStatus(tSC,tStatus)
				}
			}
		}
	}
	
	Set tStatus = ##super()
	If $$$ISERR(tStatus) {
		Set tSC = $System.Status.AppendStatus(tSC,tStatus)
	}
	
	Quit tSC
}

}
