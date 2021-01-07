/// Not for use in Information Exchange/Unified Care Record
/// Instead, use HS.Util.Installer.Kit.IHE.XCA.ExpireAndQuery
Class HS.Util.Installer.Kit.IHE.XCA Extends HS.Util.Installer.Kit.PostInstall.Base
{

Parameter NamespaceTypes As %String = "Bus,Hub";

/// This will only work where all namespaces are on the same system.  Use individual calls 
ClassMethod Add(pNamespaces As HS.Util.Installer.Kit.Namespaces = {$$$NULLOREF}, pBusNS As %String = "HSBUS", pRegistryNS As %String = "HSREGISTRY") As %Status
{
	try {
		Set tWhere = $Namespace
		Set $Namespace = pBusNS
		Set tSC = ..AddBus()
		Set $Namespace = pRegistryNS
		Set tSC = ..AddHub()
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod AddBus(pNamespaces As HS.Util.Installer.Kit.Namespaces = {$$$NULLOREF}, pNS = {$Namespace})
{
	try {
		Set tSC= ..ProductionMods(pNS,"ItemsBus",1) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod AddHub(pNamespaces As HS.Util.Installer.Kit.Namespaces = {$$$NULLOREF}, pNS = {$Namespace}) As %Status
{
	try {
		Set tSC= ..ProductionMods(pNS,"ItemsHub",1) Quit:$$$ISERR(tSC)
		Set tSC = ..AddOIDEntries(pNS,"OIDEntries") Quit:$$$ISERR(tSC)
		Set tSC = ..%New().AddRegistryEntries(pNS,"RegistryEntries") Quit:$$$ISERR(tSC)
		Set tSC = ##class(HS.Util.Installer.Kit.IHE.PIXPDQ).AddHub(pNS) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

XData OIDEntries
{
<Items>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.400</OID>
<IdentityCode>Other.HomeCommunity</IdentityCode>
<IdentityTypes><OIDType><Description>HomeCommunity</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.2060</OID>
<IdentityCode>ISC.HomeCommunity</IdentityCode>
<IdentityTypes><OIDType><Description>HomeCommunity</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>
</Items>
}

XData RegistryEntries
{
<Items>
<WebService>
<OIDMapCode><OIDMapCodeItem OIDMapCodeKey="HomeCommunity">Other.HomeCommunity</OIDMapCodeItem></OIDMapCode>
<DeviceFunction>XCA.Query</DeviceFunction>
<Name>Other.XCA.Query</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/hsbus/services/HS.IHE.XCA.RespondingGateway.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>
<WebService>
<OIDMapCode><OIDMapCodeItem OIDMapCodeKey="HomeCommunity">Other.HomeCommunity</OIDMapCodeItem></OIDMapCode>
<DeviceFunction>XCA.Retrieve</DeviceFunction>
<Name>Other.XCA.Retrieve</Name>
<MTOM>1</MTOM>
<EndPoint>http://{HostAndPort}/csp/healthshare/hsbus/services/HS.IHE.XCA.RespondingGateway.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>

<!-- responding gateway -->
<WebService>
<Name>XCA.Query</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/hsbus/services/HS.IHE.XCA.RespondingGateway.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
<OIDMapCode><OIDMapCodeItem OIDMapCodeKey="HomeCommunity">HomeCommunity</OIDMapCodeItem></OIDMapCode>
<DeviceFunction>XCA.Query</DeviceFunction>
</WebService>
<WebService>
<Name>XCA.Retrieve</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/hsbus/services/HS.IHE.XCA.RespondingGateway.Services.cls</EndPoint>
<MTOM>1</MTOM>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
<OIDMapCode><OIDMapCodeItem OIDMapCodeKey="HomeCommunity">HomeCommunity</OIDMapCodeItem></OIDMapCode>
<DeviceFunction>XCA.Retrieve</DeviceFunction>
</WebService>

<!-- initiating gateway -->
<WebService>
<Name>XDSb.Query</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/hsbus/services/HS.IHE.XCA.InitiatingGateway.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>
<WebService>
<Name>XDSb.Retrieve</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/hsbus/services/HS.IHE.XCA.InitiatingGateway.Services.cls</EndPoint>
<MTOM>1</MTOM>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>
<WebService>
<Name>Other.XCPD.RespondingGateway</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/hsbus/services/HS.IHE.XCPD.RespondingGateway.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>


</Items>
}

XData ItemsBus
{
<Items>
  <Item Name="HS.IHE.XCA.RespondingGateway.Services" Category="" ClassName="HS.IHE.XCA.RespondingGateway.Services" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="XCAQueryTarget">HS.IHE.XCA.RespondingGateway.Process</Setting>
<Setting Target="Host" Name="XCARetrieveTarget">HS.IHE.XCA.RespondingGateway.Process</Setting>
</Item>
<Item Name="HS.IHE.XCA.RespondingGateway.Process" Category="" ClassName="HS.IHE.XCA.RespondingGateway.Process" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="XDSbRegistryOperations">HS.IHE.XDSb.Registry.Operations</Setting>
<Setting Target="Host" Name="XCARespondingGatewayOperations">HS.IHE.XCA.RespondingGateway.Operations</Setting>
<Setting Target="Host" Name="XDSbRepositoryProcess">HS.IHE.XDSb.Repository.Process</Setting>
</Item>
<Item Name="HS.IHE.XCA.RespondingGateway.Operations" Category="" ClassName="HS.IHE.XCA.RespondingGateway.Operations" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>
<Item Name="HS.IHE.XDSb.Repository.Process" Category="" ClassName="HS.IHE.XDSb.Repository.Process" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>

<Item Name="HS.IHE.XCPD.RespondingGateway.Services" Category="" ClassName="HS.IHE.XCPD.RespondingGateway.Services" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="XCPDDiscoveryTarget">HS.IHE.XCPD.RespondingGateway.Process</Setting>
</Item>
<Item Name="HS.IHE.XCPD.RespondingGateway.Process" Category="" ClassName="HS.IHE.XCPD.RespondingGateway.Process" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>
<Item Name="HS.IHE.XCPD.RespondingGateway.Operations" Category="" ClassName="HS.IHE.XCPD.RespondingGateway.Operations" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>

<Item Name="HS.IHE.XCA.InitiatingGateway.Services" Category="" ClassName="HS.IHE.XCA.InitiatingGateway.Services" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="XCAQueryTarget">HS.IHE.XCA.InitiatingGateway.Process</Setting>
<Setting Target="Host" Name="XCARetrieveTarget">HS.IHE.XCA.InitiatingGateway.Process</Setting>
</Item>
<Item Name="HS.IHE.XCA.InitiatingGateway.Process" Category="" ClassName="HS.IHE.XCA.InitiatingGateway.Process" PoolSize="2" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="XDSbQueryServiceName">XDSb.Registry</Setting>
<Setting Target="Host" Name="XCPDInitiatingGatewayProcess">HS.IHE.XCPD.InitiatingGateway.Process</Setting>
</Item>
<Item Name="HS.IHE.XCA.InitiatingGateway.Operations" Category="" ClassName="HS.IHE.XCA.InitiatingGateway.Operations" PoolSize="2" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>

<Item Name="HS.IHE.XCPD.InitiatingGateway.Process" Category="" ClassName="HS.IHE.XCPD.InitiatingGateway.Process" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="XCPDQueryServiceNames"></Setting>
</Item>
<Item Name="HS.IHE.XCPD.InitiatingGateway.Operations" Category="" ClassName="HS.IHE.XCPD.InitiatingGateway.Operations" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>

<Item Name="HS.IHE.XDSb.Registry.Operations" Category="" ClassName="HS.IHE.XDSb.Registry.Operations" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="XDSbRegistryServiceName">XDSb.Registry</Setting>
</Item>

</Items>
}

XData ItemsAccessGateway
{
<Items>

</Items>
}

/// Items for the HSCONSUMER namespace
XData ItemsEdgeGateway
{
<Items>
  <Item Name="HS.IHE.XDSb.Consumer.Operations" Category="" ClassName="HS.IHE.XDSb.Consumer.Operations" PoolSize="2" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="XDSbRegistryServiceName">IG.Query</Setting>
<Setting Target="Host" Name="XDSbRepositoryServiceName">IG.Retrieve</Setting>
</Item>
</Items>
}

XData ItemsHub
{
<Items>

</Items>
}

}
