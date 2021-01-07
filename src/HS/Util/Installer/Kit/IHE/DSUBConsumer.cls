Class HS.Util.Installer.Kit.IHE.DSUBConsumer Extends HS.Util.Installer.Kit.PostInstall.Base
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
<Name>DSUB.NotificationConsumer</Name>
<SSLConfig></SSLConfig>
<EndPoint>http://{HostAndPort}/csp/healthshare/{Namespace}/services/HS.IHE.DSUB.NotificationConsumer.Services.cls</EndPoint>
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
<Item Name="HS.IHE.DSUB.NotificationConsumer.Services" Category="" ClassName="HS.IHE.DSUB.NotificationConsumer.Services" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>
<Item Name="HS.IHE.DSUB.NotificationConsumer.Process" Category="" ClassName="HS.IHE.DSUB.NotificationConsumer.Process" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>
<Item Name="HS.IHE.DSUB.Subscriber.Operations" Category="" ClassName="HS.IHE.DSUB.Subscriber.Operations" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>
</Items>
}

XData BusItems
{
<Items>
<Item Name="HS.IHE.DSUB.NotificationConsumer.Services" Category="" ClassName="HS.IHE.DSUB.NotificationConsumer.Services" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>
<Item Name="HS.IHE.DSUB.NotificationConsumer.Operations" Category="" ClassName="HS.Util.SOAPClient.Operations" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="ServiceName">DSUB.NotificationConsumer</Setting>
</Item>
</Items>
}

}
