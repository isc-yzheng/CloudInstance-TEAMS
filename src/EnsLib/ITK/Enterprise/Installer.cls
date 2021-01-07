/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include %occInclude

/// Installer for Auto-Deployment based on a Config File.
Class EnsLib.ITK.Enterprise.Installer [ System = 4 ]
{

/******************************************************************************
$Id$

Description: Installer for Auto-Deployment based on a Config File.
   
Update history:
2011-03-25  RobertHickingbotham Namespace names can contain numeric chars
2010-08-03  RobertHickingbotham  Added Configuration Export Utility
2010-04-27  RajivBhatia  ITK Enterprise Base Release
******************************************************************************/
Parameter SrcVer = "$Id$";

XData ITKManifest [ XMLNamespace = INSTALLER ]
{
<Manifest>

<If Condition='##class(Config.Namespaces).Exists("${NAMESPACE}")=1'>
<!-- Report an error if the namespace already exists -->
<Error Status="$$$CPFNamespaceAlreadyExists">
<Arg Value="${NAMESPACE}"/>
</Error>
</If>

<Var Name="DBRESOURCE" Value="%DB_%DEFAULT"/>

<Namespace Name="${NAMESPACE}" 
			Create="yes" 
			Code="${NAMESPACE}"
			Data="${NAMESPACE}"
			Ensemble="1"
			EnsemblePortalGrant="${DBRESOURCE}">
			
<Configuration>
<Database Name="${NAMESPACE}" 
			Create="yes"
			Dir="${ENSMGR}${NAMESPACE}"/>

<RoutineMapping Routines="ITK" Type="INC" From="${TEMPLATE}" />
<ClassMapping Package="ITK" From="${TEMPLATE}" />
<ClassMapping Package="ITKEnterprise" From="${TEMPLATE}" />
</Configuration>

<!-- Create a CSP application for the namespace -->
<Var Name="URL" Value='/csp/#{$ZCVT("${NAMESPACE}","L")}'/>

<Var Name="TEMPCSPSRC" Value='${CSPDIR}#{$ZCVT("${TEMPLATE}", "L")}'/>
<Var Name="TEMPCSPTARGET" Dir='${CSPDIR}#{$ZCVT("${NAMESPACE}","L")}'/>

<Var Name="CSPSRC" Dir='#{##class(%File).NormalizeDirectory("${TEMPCSPSRC}")}'/>
<Var Name="CSPTARGET" Dir='#{##class(%File).NormalizeDirectory("${TEMPCSPTARGET}")}'/>

<CSPApplication Url="${URL}"
			Directory="${CSPTARGET}"
			Resource=""
			Grant="${DBRESOURCE}"
			Description="MyApp CSP Interface"
			Recurse="1"
			CookiePath=""
			AuthenticationMethods="32"/>

<ForEach Index="tName" Values="ITKConsumerRegistry.csp,ITKFaultCode.csp,ITKFaultVocabulary.csp,ITKFaultVocabularyMap.csp,ITKSenderRegistry.csp,ITKServiceDefinition.csp,ITKSetupHome.csp,ITKSubscriptionRules.csp,ITKSystemDefinition.csp,UtilEnsHome.csp" >
<CopyFile Src='${CSPSRC}${tName}' Target='${CSPTARGET}${tName}' />	 
</ForEach>

<Invoke Class="ITKEnterprise.Installer" Method="Setup" CheckStatus="1">
<Arg Value="${TEMPLATE}"/>
<Arg Value="${NAMESPACE}"/>
<Arg Value="${DEPLOYFILE}"/>
</Invoke>

</Namespace>
</Manifest>
}

ClassMethod RunInstaller(ByRef pVars, pLogLevel As %Integer, pInstaller As %Installer.Installer) As %Status [ CodeMode = objectgenerator, Internal ]
{
	#; Let our XGL document generate code for this method. 
	Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "ITKManifest")
}

ClassMethod Deploy(pFile As %String) As %Status
{
	Set tSC = $$$OK

	If ($G(pFile) = "") {
		READ !, "File containing Production Definition for this deployment: ", pFile
	}
	
	If ('##class(%File).Exists(pFile)) {
		W !, "File "_pFile_" not found."
		Set tSC = $$$ERROR($$$FileNotFound, $G(pFile))
		Quit tSC
	}
	
	Set tIsOk = ##class(ITKEnterprise.Util).ImportConfigFile(pFile, .tProdDef)
	If 'tIsOk {
		w !, "Could not import the Production Definition file "_pFile_". Check the file's format and content, and try again."
		Set tSC = $$$ERROR($$$GeneralError, "Could not import the Production Definition file "_pFile_". Check the file's format and content, and try again.")
		Quit tSC
	}
	
	Set tNamespace = $ZCVT(tProdDef.TargetNamespace, "U")
	If ('(tNamespace?1.UN)) {
		w !, "Error: Namespace should use alphabetic characters only."
		Quit
	}	
	Set tVar("NAMESPACE") = tNamespace
	
	Set tVar("DEPLOYFILE") = pFile
	
	Set tVar("TEMPLATE") = $namespace
	
	SET tVar("ENSROOT") = $SYSTEM.Util.InstallDirectory()
	SET tVar("ENSMGR") = $SYSTEM.Util.ManagerDirectory()
	
	Quit ##class(ITKEnterprise.Installer).RunInstaller(.tVar, 3)
}

ClassMethod Setup(pNamespace As %String = {$namespace}, pDstNamespace As %String, pFilePath As %String) As %Status
{
	#dim tSC As %Status
	Set tSC=$$$OK,$ZT="Trap"
	Do {

		Do ..CopyGlobals(pNamespace, pDstNamespace)

		ZN pDstNamespace

		Do $SYSTEM.OBJ.CompilePackage("ITK")
		Do $SYSTEM.OBJ.CompilePackage("ITKEnterprise")

		Set tCSPPath = "csp/"_$ZCVT(pDstNamespace, "L")_"/"
		Do $SYSTEM.OBJ.CompileList(tCSPPath_"ITK*.csp")
		Do $SYSTEM.OBJ.CompileList(tCSPPath_"UtilEnsHome.csp")

		Do ##class(ITKEnterprise.Util).CreateProduction(pFilePath)

		// Remove Package Mapping for ITKEnterprise
		ZN "%SYS"
		Do ##class(Config.MapPackages).Delete(pDstNamespace, "ITKEnterprise")

	} While (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$ERROR($$$ObjectScriptError,$ZE)
	Goto Exit
}

ClassMethod CopyGlobals(pNamespace As %String = {$namespace}, pDstNamespace As %String) As %Status
{
	#dim tSC As %Status
	Set tSC=$$$OK,$ZT="Trap"
	Do {
		ZN pDstNamespace

		For tMask = "EnsLib.ITK.Setup.*", "EnsLib.ITK.Framework.*", "Ens.Rule.*" {
			Set tResult = ##class(%ResultSet).%New("%SYS.GlobalQuery:NameSpaceList")
			Do tResult.Execute(pNamespace, tMask)
			While (tResult.Next(.sc)) { 
				W !, "Copying ... "_tResult.Data("Name")
				// Copy Globals
				Set tGloName = tResult.Data("Name") 
				MERGE @("^"_tGloName) = @("^["""_pNamespace_"""]"_tGloName)
			}
		}

	} While (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$ERROR($$$ObjectScriptError,$ZE)
	Goto Exit
}

ClassMethod ExportConfig(pFile As %String, pNamespace As %String) As %Status
{
	#dim tSC As %Status
	Set tSC=$$$OK,$ZT="Trap"
	
	set tNS = $namespace

	If ($G(pFile) = "") {
		READ !, "File to export to: ", pFile
		
	}

	ZN "%SYS"

	s tSC=##Class(Config.Namespaces).Get(tNS,.TemplateProperties)
	Quit:$$$ISERR(tSC) tSC
	
	s Properties("Database")=TemplateProperties("Routines")
	s tSC= ##Class(Config.MapPackages).Create(pNamespace,"ITKEnterprise",.Properties)
	Quit:$$$ISERR(tSC) tSC
	
	zn tNS
	
	set tSC = ##class(ITKEnterprise.Util).GetProductionEndpoints("ITKEnterprise.Production.TEMPLATE",.tTemplateServices,.tTemplateOperations)
	Quit:$$$ISERR(tSC)
	
	w "Exporting Configuration...",!
	
	set tProdDef = ##class(ITKEnterprise.Production).%New()
	set tProdDef.TargetNamespace = pNamespace
	
	Do {
		zn pNamespace
		Set tIsOk = ##class(ITKEnterprise.Util).GetITKProduction(.tProdName,.tDepName)
		If 'tIsOk {
			s errText = "ITK Production not found in the namespace: "_pNamespace
			w !, errText
			Set tSC = $$$ERROR($$$GeneralError, errText)
			Quit
		}	
		set tProdDef.DeploymentName=tDepName
		
		set tSC = ##class(ITKEnterprise.Util).GetProductionEndpoints(tProdName,.tProdServices,.tProdOperations)
		Quit:$$$ISERR(tSC)
		
		set ptr=0
		while $LISTNEXT(tProdServices,ptr,value)
		{
			if ('$LISTFIND(tTemplateServices,value))
			{
				w "Business Service: "_value,!

				set tEndpoint = ##class(ITKEnterprise.Endpoint).%New()
				d tProdDef.Endpoint.Insert(tEndpoint)
				set tEndpoint.Name = value
				
				s tEndpoint.Port = ##class(Ens.Director).GetAdapterSettingValue(tProdName_"||"_value,"Port")
				s tEndpoint.URL = ##class(Ens.Director).GetHostSettingValue(tProdName_"||"_value,"EndpointURL")
				
				s rs = ##class(%ResultSet).%New()
				set tSC =  rs.Prepare("select SourceAppName,WebServiceName,ValidatePayload from EnsLib_ITK_Setup.SenderRegistry where BusinessServiceName = '"_tEndpoint.Name_"' Order by SourceAppName")
				Quit:$$$ISERR(tSC)
				set tSC =  rs.Execute()
				Quit:$$$ISERR(tSC)
				
				while rs.Next()
				{
					if ($g(sender)="") || (rs.Get("SourceAppName") '= sender.Name)
					{
						s sender = ##class(ITKEnterprise.Sender).%New()
						d tEndpoint.Sender.Insert(sender)
						s sender.Name=rs.Get("SourceAppName")
						w " Sender: "_sender.Name,!
					}
					s service = ##class(ITKEnterprise.Service).%New()
					s service.Name = rs.Get("WebServiceName")
					s service.ValidatePayload = rs.Get("ValidatePayload")
					d sender.Service.Insert(service)
					w "  Service: "_service.Name,!
					
				}
				kill sender

			}
		}
		Quit:$$$ISERR(tSC)
		
		set ptr=0
		s buildSubscriptions = 0
		while $LISTNEXT(tProdOperations,ptr,value)
		{
			if ('$LISTFIND(tTemplateOperations,value))
			{
				w "Business Operation "_value,!
				s deviceid = ##class(Ens.Director).GetHostSettingValue(tProdName_"||"_value,"ApplicationName")
 				s applicationname = $p(deviceid,":")
 				s devicenname = $p(deviceid,":",2)
 				i devicenname="" s devicenname = applicationname
				if ($g(application)="") || (application.Name '=applicationname)
				{
					s application = ##class(ITKEnterprise.Application).%New()	
					s application.Name = applicationname
					d tProdDef.Application.Insert(application)
					s buildSubscriptions = 1
					w " Application "_application.Name,!
				}
				else
				{
					s buildSubscriptions = 0
				}
				set tDevice = ##class(ITKEnterprise.Device).%New()
				set tDevice.Name = devicenname
				
				w "  Device "_tDevice.Name,!
				
				d application.Device.Insert(tDevice)
				
				set webserverurl = ##class(Ens.Director).GetAdapterSettingValue(tProdName_"||"_value,"WebServiceURL")
				set iProtocol = $Find(webserverurl,"://")
				s:iProtocol=0 iProtocol=1
				set iHost = $Find(webserverurl,":",iProtocol)
				s:iHost=0 iHost=$LENGTH(webserverurl)+1
				
				w webserverurl," ",iProtocol," ",iHost-2
				
				set tDevice.Host = $EXTRACT(webserverurl,iProtocol,iHost-2)
				set tDevice.Port =  $EXTRACT(webserverurl,iHost,*)+0
				set:tDevice.Port=0 tDevice.Port=80
				set tDevice.EndpointBaseURL = ##class(Ens.Director).GetHostSettingValue(tProdName_"||"_value,"EndpointBaseURL")
				set tDevice.Throttle = ##class(Ens.Director).GetHostSettingValue(tProdName_"||"_value,"Throttle")

				if (tProdDef.ITKUsernameToken="") set tProdDef.ITKUsernameToken=##class(Ens.Director).GetHostSettingValue(tProdName_"||"_value,"UserNameToken")

				set rsCons = ##class(%ResultSet).%New()
				set tSC = rsCons.Prepare("Select ServiceName, ServiceURL, RouteURL from EnsLib_ITK_Setup.ConsumerServiceRegistry where ConsumerName = '"_tDevice.Name_"'")
				Quit:$$$ISERR(tSC)
				set tSC = rsCons.Execute()
				Quit:$$$ISERR(tSC)
				while (rsCons.Next())
				{
					s consumer = ##class(ITKEnterprise.Service).%New()
					s consumer.Name = rsCons.Data("ServiceName")
					s consumer.RouteURL = rsCons.Data("RouteURL")
					s consumer.URI = rsCons.Data("ServiceURL")
					
					d tDevice.Service.Insert(consumer)
				}
				if buildSubscriptions
				{

					set rsSubs = ##class(%ResultSet).%New()
					set tSC = rsSubs.Prepare("select SourceApplication,SourceService from EnsLib_ITK_Setup.SubscriptionRules where Subscriber  = '"_application.Name_"'")
					Quit:$$$ISERR(tSC)
					set tSC = rsSubs.Execute()
					Quit:$$$ISERR(tSC)
	
					while rsSubs.Next()
					{
						set service = ##class(ITKEnterprise.Subscription).%New()
						set service.SourceApplication = rsSubs.Data("SourceApplication")
						set service.Service = rsSubs.Data("SourceService")
						
						do application.Subscription.Insert(service)
						w "  Subscription "_service.SourceApplication_":"_service.Service,!
					}

				}
			}
		}
		Quit:$$$ISERR(tSC)
		set config = ##class(ITKEnterprise.Config).%New()
		set config.ItemName="DeadMessageHandler"
		set config.SettingName="FilePath"
		set config.Target="Adapter"
		set config.Value = ##class(Ens.Director).GetAdapterSettingValue(tProdName_"||"_config.ItemName,config.SettingName)
		do tProdDef.Config.Insert(config)
		
		set config = ##class(ITKEnterprise.Config).%New()
		set config.ItemName="SLAReportOperation"
		set config.SettingName="FilePath"
		set config.Target="Adapter"
		set config.Value = ##class(Ens.Director).GetAdapterSettingValue(tProdName_"||"_config.ItemName,config.SettingName)
		do tProdDef.Config.Insert(config)
		
		set config = ##class(ITKEnterprise.Config).%New()
		set config.ItemName="SLAReportOperation"
		set config.SettingName="InstallationID"
		set config.Target="Host"
		set config.Value = ##class(Ens.Director).GetHostSettingValue(tProdName_"||"_config.ItemName,config.SettingName)
		do tProdDef.Config.Insert(config)
		
		d ##class(%File).Delete(pFile)
	
		set writer=##class(%XML.Writer).%New()
		set writer.Indent=1

		set tSC=writer.OutputToFile(pFile)
		Quit:$$$ISERR(tSC)
	
		set tSC=writer.RootObject(tProdDef)
		Quit:$$$ISERR(tSC)
	} while (0)

	if $$$ISERR(tSC)
	{
		Do DecomposeStatus^%apiOBJ(tSC,.err,"-d")
		For i=1:1:err Write err(i),!
	}
	
	
Exit
	zn "%SYS"
	Do ##class(Config.MapPackages).Delete(pNamespace, "ITKEnterprise")
	
	zn tNS
	Quit tSC
Trap
	w $ZE,!
	Set $ZT="",tSC=$$$ERROR($$$ObjectScriptError,$ZE)
	Goto Exit
}

}
