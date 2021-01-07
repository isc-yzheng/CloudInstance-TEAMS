Class HS.Util.Installer.Kit.IHE.XCAI Extends HS.Util.Installer.Kit.PostInstall.Base
{

Parameter NamespaceTypes As %String = "Bus,Hub,Foundation";

/// For Foundation namespaces call Add(,$namespace,$namespace), which will setup the production items and the service registry entries in the same namespace<BR>
/// For UCR systems where the Bus and the Hub are on the same system, calling Add(,"HSBUS","HSREGISTRY") will update the namespaces correctly.<BR>
/// Individual calls to AddBus or AddHub can be used.
ClassMethod Add(pNamespaces As HS.Util.Installer.Kit.Namespaces = {$$$NULLOREF}, pBusNS As %String = "", pRegistryNS As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		New $namespace
		If pBusNS = "" {
			If $D(^%SYS("HealthShare","Instances","HSBUS")) {
				Set pBusNS = "HSBUS"
			}
		}
		If pBusNS]"" {
			Set $namespace = pBusNS
			$$$ThrowOnError(..AddBus(pBusNS))
		}
		
		If pRegistryNS = "" {
			If $D(^%SYS("HealthShare","Instances","HSREGISTRY")) {
				Set pBusNS = "HSREGISTRY"
			}
		}
		If pRegistryNS = "" {
			If $D(^%SYS("HealthShare","Instances",$namespace)) && (##class(HS.Util.Installer.ConfigItem).TypeGetStored($namespace)="Foundation") {
				Set pRegistryNS = $namespace
				Set pBusNS = $namespace
				$$$ThrowOnError(..AddBus(pBusNS))
			}
		}
		If pRegistryNS '= "" {
			Set $namespace = pRegistryNS
			$$$ThrowOnError(..AddHub(,pRegistryNS,pBusNS))
		}
	} 
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod AddBus(pNamespaces As HS.Util.Installer.Kit.Namespaces = {$$$NULLOREF}, pNS = {$Namespace})
{
	New %VALS
	Set tSC = $$$OK
	Try {
		New $namespace
		Set $namespace=pNS
		Set %VALS("IGWNS")=pNS
		$$$ThrowOnError(..ProductionMods(pNS,"ItemsBus",1))
		$$$ThrowOnError(##class(HS.Util.FileStream.Cleanup).Schedule(pNS))
	} 
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod AddHub(pNamespaces As HS.Util.Installer.Kit.Namespaces = {$$$NULLOREF}, pNS = {$Namespace}, pBusNS) As %Status
{
	New %VALS
	Set tSC = $$$OK
	Try {
		New $namespace
		Set $namespace=pNS
		If pBusNS]"" {
			Set %VALS("IGWNS")=pBusNS
		} Else {
			Set %VALS("IGWNS")=pNS
		}
		$$$ThrowOnError(..%New().AddRegistryEntries(pNS,"RegistryEntries"))
	} 
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

XData RegistryEntries
{
<Items>
<!-- responding gateway -->
<WebService>
<Name>XCAI.Retrieve</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/{$expression{%VALS("IGWNS")}}/services/HS.IHE.XCAI.RespondingGateway.Services.cls</EndPoint>
<MTOM>1</MTOM>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
<OIDMapCode><OIDMapCodeItem OIDMapCodeKey="HomeCommunity">HomeCommunity</OIDMapCodeItem></OIDMapCode>
<DeviceFunction>XCAI.Retrieve</DeviceFunction>
</WebService>

<!-- initiating gateway -->
<WebService>
<Name>XDSI.Retrieve</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/{$expression{%VALS("IGWNS")}}/services/HS.IHE.XCAI.InitiatingGateway.Services.cls</EndPoint>
<MTOM>1</MTOM>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>
</Items>
}

XData ItemsBus
{
<Items>
<!-- responding gateway -->
<Item Name="HS.IHE.XCAI.RespondingGateway.Services" Category="XCAI" ClassName="HS.IHE.XCAI.RespondingGateway.Services" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>
<Item Name="HS.IHE.XCAI.RespondingGateway.Process" Category="XCAI" ClassName="HS.IHE.XCAI.RespondingGateway.Process" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>
<Item Name="HS.IHE.XCAI.RespondingGateway.Operations" Category="XCAI" ClassName="HS.IHE.XCAI.RespondingGateway.Operations" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>

<Item Name="HS.IHE.XCAI.InitiatingGateway.Services" Category="XCAI" ClassName="HS.IHE.XCAI.InitiatingGateway.Services" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>
<Item Name="HS.IHE.XCAI.InitiatingGateway.Process" Category="XCAI" ClassName="HS.IHE.XCAI.InitiatingGateway.Process" PoolSize="2" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>
<Item Name="HS.IHE.XCAI.InitiatingGateway.Operations" Category="XCAI" ClassName="HS.IHE.XCAI.InitiatingGateway.Operations" PoolSize="2" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>
</Items>
}

XData ItemsAccessGateway
{
<Items>
</Items>
}

XData ItemsEdgeGateway
{
<Items>
</Items>
}

XData ItemsHub
{
<Items>
</Items>
}

}
