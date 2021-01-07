/// HS.HC.Util.Installer.Kit.FHIR.FromSDA adds production components and definitions needed
/// for using DTL to convert incoming SDA3 data into FHIR DSTU2 in a FHIR namespace.
/// 
/// Example:
/// 
/// Set tSC = ##class(HS.HC.Util.Installer.Kit.FHIR.FromSDA).Add( , "FHIR")
/// 
Class HS.HC.Util.Installer.Kit.FHIR.FromSDA Extends HS.Util.Installer.Kit.Base
{

Parameter NamespaceTypes As %String = "Foundation";

ClassMethod Add(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pFoundationNS As %String = {$Namespace}, pFHIRVersion As %String) As %Status
{
	Quit ..AddFoundation( , pFoundationNS, $Get(pFHIRVersion))
}

ClassMethod AddFoundation(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pNS = {$Namespace}, pFHIRVersion As %String) As %Status
{
	New $Namespace
	
	Set tSC = $$$OK
	
	Try {
		If pNS="" Set tSC = $$$ERROR($$$GeneralError, "Namespace not specified") Quit
		
		If $Get(pFHIRVersion)="" {
			Set tSC = $$$ERROR($$$GeneralError, "FHIR version not specified - must be DSTU2")
			Quit
		}
		
		Set pFHIRVersion = $ZConvert(pFHIRVersion,"U")
		
		If '((pFHIRVersion="DSTU2")) {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid FHIR version specified - must be DSTU2")
			Quit
		}
		
		Set $Namespace = pNS
		
		Set tSC = ..ProductionMods(pNS, "FoundationItems", 1)
		If $$$ISERR(tSC) Quit
		
		Set tOverwrite = 0
		Set tSC = ##class(HS.HC.Util.Installer.Kit.FHIR.LookupTables).AddFoundation( , pNS, tOverwrite)
		If $$$ISERR(tSC) Quit
		
		Set $Namespace = pNS
		
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

XData FoundationItems
{
<Items>
  <Item Name="HS.FHIR.REST.Operation" Category="" ClassName="HS.FHIR.REST.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.FHIR.FromSDA.DTL.Transaction.Process" Category="" ClassName="HS.FHIR.FromSDA.DTL.Transaction.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="EnsLib.File.PassthroughService" Category="" ClassName="EnsLib.File.PassthroughService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  <Setting Target="Host" Name="TargetConfigNames">HS.FHIR.FromSDA.DTL.Transaction.Process</Setting>
  </Item>
</Items>
}

}
