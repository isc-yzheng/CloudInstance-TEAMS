/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Used in a conjunction with a com.intersystems.gateway.bh.BusinessOperation to create a Java Business Operation. 
Class Ens.Java.Operation.Standard Extends EnsLib.JavaGateway.AbstractOperation [ Abstract ]
{

/// Path to JAR file containing Java-side implementation of this Business Operation
Property JarFile As %String(MAXLEN = 255);

/// Credentials for Java to use when authenticating with IRIS
Property Credentials As %String;

/// Name of the Config Item for the Java Gateway Server.  If specified, the Address and Port of this Java Gateway Server
/// override any values entered in the Address and Port settings. 
Property JavaGatewayService As %String;

/// User-configurable settings for this service
Parameter SETTINGS = "JavaGatewayService:Basic:selector?context={Ens.ContextSearch/ProductionItems?className=EnsLib.JavaGateway.Service&productionName=@productionId},Credentials:Additional:credentialsSelector,JarFile:Additional:fileSelector?wildcard=*.jar";

Parameter INVOCATION = "Queue";

Method OnInit() As %Status
{
	#dim tSC As %Status = $$$OK
	#dim ex As %Exception.StatusException
	#dim tName,tValue As %String
	
	// If Java Gateway Service is specified, then use its Address and Port even if they differ from the settings values
	If "" '= ..JavaGatewayService {
		#dim tAddress,tPort As %String
		Set tSC = ##class(Ens.Java.Utils).GetSetting(..JavaGatewayService,"Address",.tAddress)
		If $$$ISERR(tSC) $$$LOGERROR($system.Status.GetErrorText(tSC))
		Set:(""'=tAddress) ..Address = tAddress
		Set tSC = ##class(Ens.Java.Utils).GetSetting(..JavaGatewayService,"Port",.tPort)
		If $$$ISERR(tSC) $$$LOGERROR($system.Status.GetErrorText(tSC))
		Set:(""'=tPort) ..Port = tPort
	}

	Set tSC = ##super()
	Quit:$$$ISERR(tSC) tSC
	
	#dim tItem As Ens.Config.Item = ##class(Ens.Config.Production).OpenItemByConfigName(..%ConfigName,.tSC)
	Quit:$$$ISERR(tSC) tSC
	
	// jarFile and className will be gathered from the production args, so no need to gather twice
	Set tSkip("JarFile")=""
	Set tSkip("Classname")=""
	
	// Port and Address values that are used may be different from the settings value (if from Java Gateway Service)
	Set tOverwrite("Address") = ..Address
	Set tOverwrite("Port") = ..Port
	
	Set tSC = ##class(Ens.Java.Utils).GetAllItemSettings(tItem,.tSkip,.tOverwrite,.tItemArgs)
	Quit:$$$ISERR(tSC) tSC
	
	Set tSC = ##class(Ens.Java.Utils).GetProductionArgs(tItem,.tArgs)
	Quit:$$$ISERR(tSC) tSC
	
	For i=1:1:tItemArgs.Count() {
		Set tSC = tArgs.Insert(tItemArgs.GetAt(i))
		Quit:$$$ISERR(tSC)
	}
	Quit:$$$ISERR(tSC) tSC

	Set tSC = ##class(com.intersystems.gateway.bh.ProductionConcrete).init(..JavaGateway, tArgs)
	Quit:$$$ISERR(tSC) $$$ERROR($$$ErrorExecutingJavaCommand, "init()"_" returned: """_$System.Status.GetErrorText(tSC)_"""")

	Quit $$$OK
}

Method OnTearDown() As %Status
{
	Set tSC = ##class(com.intersystems.gateway.bh.ProductionConcrete).tearDown(..JavaGateway, ..%ConfigName)
	Quit:$$$ISERR(tSC) $$$ERROR($$$ErrorExecutingJavaCommand, "tearDown()"_" returned: """_$System.Status.GetErrorText(tSC)_"""")
	
	Quit ##super()
}

}
