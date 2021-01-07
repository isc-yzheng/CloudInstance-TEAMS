/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.SAP.BootStrap Extends EnsLib.JavaGateway.InterfaceEnabler [ ClassType = "", ProcedureBlock, System = 3 ]
{

/// This method must be called to import the SAP JavaClases and generate the proxies which
/// enable the SAP connectivity prior to use. The full path to the SAP sapjco3.jar file must be
/// provided along with the port and address of the RUNNING java gateway (see Demo.SAP.Production.BootStrap)
ClassMethod ImportSAP(pFullPathToSAPJarFile As %String = "", pPort As %Integer = 55554, pAddress As %String = "127.0.0.1")
{
	#dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException

	#dim tJavaGateway As EnsLib.JavaGateway.JavaGateway
	#dim tClassPath As %ListOfDataTypes
	
	try {
		
		#; Create an instance of the JavaGateway (proxy)
		Kill %objlasterror
		Set tJavaGateway=##class(EnsLib.JavaGateway.JavaGateway).%New()
		If '$IsObject(tJavaGateway) Set tSC=$Get(%objlasterror,$$$ERROR($$$FailedToNewClass,"EnsLib.JavaGateway.JavaGateway")) Quit
		
		#; Create a list of datatypes for the classpath
		Kill %objlasterror
		Set tClassPath=##class(%ListOfDataTypes).%New()
		If '$IsObject(tClassPath) Set tSC=$Get(%objlasterror,$$$ERROR($$$FailedToNewClass,"%ListDataTypes")) Quit
		
		#; Insert the path
		Set tSC=tClassPath.Insert(pFullPathToSAPJarFile)
		If $$$ISERR(tSC) Quit
		
		#; Only load those classes which we need
		Do ..Import("com.sap.conn.jco.JCoContext",tClassPath,pPort,pAddress)
		
		#; More
 		Do ..Import("com.sap.conn.jco.JCoDestinationManager",tClassPath,pPort,pAddress)
 		
 		#; More
 		Do ..Import("com.sap.conn.jco.JCo",tClassPath,pPort,pAddress)
 		
 		#; More
 		Do ..Import("com.sap.conn.jco.About",tClassPath,pPort,pAddress)
		
	} catch (e) {
		If e.Name="<ZJGTW>",$Data(%objlasterror) Set tSC=%objlasterror Quit
		Set tSC=e.AsStatus()
	}
	If $$$ISERR(tSC) Do $System.Status.DisplayError(tSC)
	Quit
}

}
