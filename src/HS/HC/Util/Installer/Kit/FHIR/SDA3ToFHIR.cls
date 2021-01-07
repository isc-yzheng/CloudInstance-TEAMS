/// HS.HC.Util.Installer.Kit.FHIR.SDA3ToFHIR adds production components and definitions
/// needed to facilitate using an interoperability production to invoke the SDA3 to FHIR
/// DTL transformation API for FHIR versions STU3 and later.
/// 
/// Example:
/// 
/// Set status = ##class(HS.HC.Util.Installer.Kit.FHIR.SDA3ToFHIR).Add( , "FHIR", "STU3")
/// 
Class HS.HC.Util.Installer.Kit.FHIR.SDA3ToFHIR Extends HS.Util.Installer.Kit.Base
{

Parameter NamespaceTypes As %String = "Foundation";

/// This method calls the AddFoundation() method to add the production components and definitions for the SDA3 to FHIR DTL transforms.<br>
/// <br>Inputs:<br>
/// <li>pNamespaces   : (not used, leave blank)
/// <li>pFoundationNS : (required) The name of a Foundation type namespace.
/// <li>pFHIRVersion  : (required) Target FHIR version for transforms - "STU3".
ClassMethod Add(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pFoundationNS As %String = {$Namespace}, pFHIRVersion As %String) As %Status
{
	Quit ..AddFoundation( , pFoundationNS, $Get(pFHIRVersion))
}

/// This method adds the production components and definitions for SDA3 to FHIR DTL transforms.<br>
/// <br>Inputs:<br>
/// <li>pNamespaces   : (not used, leave blank)
/// <li>pFoundationNS : (required) The name of a Foundation type namespace.
/// <li>pFHIRVersion  : (required) Target FHIR version for transforms - "STU3".
ClassMethod AddFoundation(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pNS = {$Namespace}, pFHIRVersion As %String) As %Status
{
	New $Namespace
	
	Set tSC = $$$OK
	
	Try {
		If pNS="" Set tSC = $$$ERROR($$$GeneralError, "Namespace not specified") Quit
		
		If $Get(pFHIRVersion)="" {
			Set tSC = $$$ERROR($$$GeneralError, "FHIR version not specified")
			Quit
		}
		
		Set pFHIRVersion = $ZConvert(pFHIRVersion,"U")
		
		If '((pFHIRVersion="STU3")) {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid FHIR version specified - must be STU3")
			Quit
		}
		
		Set $Namespace = pNS
		
		Set tSC = ..ProductionMods(pNS, "FoundationItems", 1)
		If $$$ISERR(tSC) Quit
		
		If '$Data(^HS.XF.LookupTable) {
			Set tSC = ..ImportFHIRGlobals(pNS)
			If $$$ISERR(tSC) Quit
			Set tSC = ..ImportLookupJSON(pNS)
			If $$$ISERR(tSC) Quit
		}
		
		Set tSC = ##class(Ens.Director).GetProductionStatus(.tProdName, .tProdStatus)
		If $$$ISERR(tSC) Quit
		
		If tProdStatus=$$$eProductionStateStopped {
			Set tSC = ##class(HS.HC.Util.Installer).StartProduction(pNS, tProdName)
			Write !
		} ElseIf tProdStatus=$$$eProductionStateRunning {
			Set tSC = ##class(Ens.Director).UpdateProduction()
			Write !
		} ElseIf tProdStatus=$$$eProductionStateSuspended {
			Set tSC = $$$ERROR($$$GeneralError, "Production is currently suspended - cannot activate changes")
		} ElseIf tProdStatus=$$$eProductionStateTroubled {
			Set tSC = $$$ERROR($$$GeneralError, "Production is currently troubled - cannot activate changes")
		}
		If $$$ISERR(tSC) Quit
		
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	
	If $$$WriteProg {
		If $$$ISERR(tSC) {
			Write !,..%ClassName(1)_" "_$$$CurrentMethod_" ERROR - "_$system.Status.GetErrorText(tSC)
		} Else {
			Write !,..%ClassName(1)_" "_$$$CurrentMethod_" completed successfully"
		}
	}
	
	Quit tSC
}

ClassMethod ImportFHIRGlobals(pNamespace As %String = "") As %Status
{
	Set tSC = $$$OK
	
	New $Namespace
	
	Try {
		If pNamespace="" Set pNamespace = $Namespace
		
		Set $Namespace = pNamespace
		
		Set tDirName = $system.Util.InstallDirectory() _ "dev/fhir/gbl/"
		If '##class(%Library.File).DirectoryExists(tDirName) {
			Set tSC = $$$ERROR($$$GeneralError, tDirName _ " not found")
			Quit
		}
		
		Set tProject = ""
		For {
			Set tProject = $Order(^HS.XF.Config("Delivery", tProject))
			If tProject="" Quit
			If $Data(^HS.XF.Config("Delivery", tProject, "CustomPackage", "DTL")) {
				Set tCustomPackage(tProject) = ^HS.XF.Config("Delivery", tProject, "CustomPackage", "DTL")
			}
		}
		
		Set tSC = $system.OBJ.ImportDir(tDirName)
		
		Set tProject = ""
		For {
			Set tProject = $Order(tCustomPackage(tProject))
			If tProject="" Quit
			Set ^HS.XF.Config("Delivery", tProject, "CustomPackage", "DTL") = tCustomPackage(tProject)
		}
		
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	
	Quit tSC
}

ClassMethod ImportLookupJSON(pNamespace As %String = "") As %Status
{
	Set tSC = $$$OK
	
	New $Namespace
	
	Try {
		If pNamespace="" Set pNamespace = $Namespace
		
		Set $Namespace = pNamespace
		
		// Do not overlay or overwrite an existing ^HS.XF.LookupTable.
		// Once established by an install, it can be updated only via
		// the customization procedure.
		If $Data(^HS.XF.LookupTable) Quit
		
		Set tDirName = $system.Util.InstallDirectory() _ "dev/fhir/lookup/"
		If '##class(%Library.File).DirectoryExists(tDirName) {
			Set tSC = $$$ERROR($$$GeneralError, tDirName _ " not found")
			Quit
		}
		Set tFileName = ##class(%Library.File).NormalizeFilename("Lookup.json", tDirName)
		If '##class(%Library.File).Exists(tFileName) {
			Set tSC = $$$ERROR($$$GeneralError, tFileName _ " not found")
			Quit
		}
		
		Set tSC = ##class(HS.FHIR.DTL.Util.API.LookupTable).ImportLookupJSONToGlobal()
		
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	
	Quit tSC
}

XData FoundationItems
{
<Items>
  <Item Name="HS.FHIR.REST.Operation" Category="" ClassName="HS.FHIR.REST.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process" Category="" ClassName="HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process" PoolSize="3" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  <Setting Target="Host" Name="TargetConfigName">HS.FHIR.REST.Operation</Setting>
  </Item>
  <Item Name="EnsLib.File.PassthroughService" Category="" ClassName="EnsLib.File.PassthroughService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  <Setting Target="Host" Name="TargetConfigNames">HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process</Setting>
  </Item>
</Items>
}

}
