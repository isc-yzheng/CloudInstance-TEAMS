Class HS.Util.Installer.Kit.IHE.DSUBBroker Extends HS.Util.Installer.Kit.PostInstall.Base
{

Parameter NamespaceTypes As %String = "Bus,Hub";

ClassMethod Add(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pRegistryNS As %String = {$Namespace}, pBusNS = "HSBUS") As %Status
{
	try {
		Set tSC = ..AddHub(,pRegistryNS)
		Set:pBusNS]"" tSC = ..AddBus(,pBusNS)
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod AddHub(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pNS = {$Namespace})
{
	try {
		Set tSC= ..ProductionMods(pNS,"HubItems",1) Quit:$$$ISERR(tSC)
		Set tSC = ..%New().AddRegistryEntries()
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod AddBus(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pNS = {$Namespace})
{
	try {
		Set tSC= ..ProductionMods(pNS,"BusItems",1) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

XData RegistryEntries
{
<Items>
<WebService>
<DeviceFunction></DeviceFunction>
<Name>DSUB.NotificationBroker</Name>
<SSLConfig></SSLConfig>
<EndPoint>http://{HostAndPort}/csp/healthshare/{Namespace}/services/HS.IHE.DSUB.NotificationBroker.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>
</Items>
}

XData OIDEntries
{
<Items>
</Items>
}

/// /
XData HubItems
{
<Items>
<Item Name="HS.IHE.DSUB.NotificationBroker.Services" Category="" ClassName="HS.IHE.DSUB.NotificationBroker.Services" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>
<Item Name="HS.IHE.DSUB.NotificationBroker.Operations" Category="" ClassName="HS.IHE.DSUB.NotificationBroker.Operations" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>
<Item Name="HS.IHE.DSUB.Notification.Operations" Category="" ClassName="HS.Util.SOAPClient.Operations" PoolSize="5" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="SOAPCredentials">HS_Services</Setting>
<Setting Target="Host" Name="ReplyCodeActions">E=R</Setting>
</Item>
<Item Name="HS.IHE.XDSb.Registry.Operations" ClassName="HS.IHE.XDSb.Registry.Operations">
<Setting Target="Host" Name="Publisher">HS.IHE.DSUB.Publisher.Process</Setting>
</Item>
<Item Name="HS.IHE.DSUB.Publisher.Process" Category="" ClassName="HS.IHE.DSUB.Publisher.Process" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="LocalBrokerOperation">HS.IHE.DSUB.NotificationBroker.Operations</Setting>
</Item>
</Items>
}

XData BusItems
{
<Items>
<Item Name="HS.IHE.DSUB.NotificationBroker.Services" Category="" ClassName="HS.IHE.DSUB.NotificationBroker.Services" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>
<Item Name="HS.IHE.DSUB.NotificationBroker.Operations" Category="" ClassName="HS.IHE.DSUB.NotificationBroker.Operations" PoolSize="5" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="ServiceName">DSUB.NotificationBroker</Setting>
</Item>
</Items>
}

}
