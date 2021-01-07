Class HS.Util.Installer.Kit.IHE.PIXPDQ Extends HS.Util.Installer.Kit.PostInstall.Base
{

Parameter NamespaceTypes As %String = "Bus,Hub";

ClassMethod Add(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pRegistryNS As %String = "HSREGISTRY", pBusNS = "") As %Status
{
	try {
		Set tSC = ..AddHub(,pRegistryNS)
		Quit:$$$ISERR(tSC)
		Set:pBusNS]"" tSC = ..AddBus(,pBusNS)
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod AddHub(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pNS = {$namespace})
{
	try {
		#; if already run don't try to increase ActorPoolSize again
		#dim tProdRef As Ens.Config.Production
		Set tSC=..GetProduction(.tProdRef,"") Quit:$$$ISERR(tSC)
		Set tFound=0
		For tI=1:1:tProdRef.Items.Count() {
			Set tItem=tProdRef.Items.GetAt(tI)
			If tItem.ClassName="HS.IHE.PIXv3.Manager.Services" Set tFound=1 Quit
		}
		If tFound=0 {
			Set tProdRef.ActorPoolSize = tProdRef.ActorPoolSize+10
			Set tSC=##class(HS.Util.Installer.Upgrade.Abstract).SaveProduction(tProdRef)
		}
		Kill tProdRef
		Quit:$$$ISERR(tSC)
		Set tSC= ..ProductionMods(pNS,"HubItems",1) Quit:$$$ISERR(tSC)
		/// The mpi.manager is different for HealthConnect versus HealthShare
		If '##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance() {
			Set tSC= ..ProductionMods(pNS,"HubItemsHealthConnect",1) Quit:$$$ISERR(tSC)
		} Else {
			Set tSC= ..ProductionMods(pNS,"HubItemsHealthShare",1) Quit:$$$ISERR(tSC)
		}
		Set tSC = ..%New().AddRegistryEntries()
		Set tSC = ..AddOIDEntries(pNS,"OIDEntries") Quit:$$$ISERR(tSC)

		Set tConsumerID = "PIXv3ConsumerDevice"
		#; if already run don't try to set it up again
		If '##class(HS.IHE.PIX.Manager.DomainsOfInterest).ConsumerFound(tConsumerID,"") {
			Set tOBJ=##class(HS.IHE.PIX.Manager.DomainsOfInterest).%New()
			Set tOBJ.ConsumerID=tConsumerID  // oid entry for our pix consumer - to accept updates
			// As of hscore 13, AllDomains needs to be set to 0 since XDSb Registry MPI Updates are handled by PIX Consumer Process directly.  
			// Having this set causes an infinite loop of messages
			Set tOBJ.AllDomains=0
			Do tOBJ.Domains.Clear()
			Set tSC=tOBJ.%Save()
		}
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod AddBus(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pNS = {$namespace})
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
<Name>PIXv3.Manager</Name>
<SSLConfig></SSLConfig>
<EndPoint>http://{HostAndPort}/csp/healthshare/{Namespace}/services/HS.IHE.PIXv3.Manager.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
<OIDMapCode><OIDMapCodeItem OIDMapCodeKey="Device">PIXv3ManagerDevice</OIDMapCodeItem></OIDMapCode>
<DeviceFunction>PIXv3.Manager</DeviceFunction>
</WebService>
<WebService>
<Name>PDQv3.Supplier</Name>
<SSLConfig></SSLConfig>
<EndPoint>http://{HostAndPort}/csp/healthshare/{Namespace}/services/HS.IHE.PDQv3.Supplier.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
<OIDMapCode><OIDMapCodeItem OIDMapCodeKey="Device">PIXv3ManagerDevice</OIDMapCodeItem></OIDMapCode>
<DeviceFunction>PDQv3.Supplier</DeviceFunction>
</WebService>
<WebService>
<OIDMapCode><OIDMapCodeItem OIDMapCodeKey="Device">PIXv3ConsumerDevice</OIDMapCodeItem></OIDMapCode>
<Name>PIXv3.Consumer</Name>
<SSLConfig></SSLConfig>
<EndPoint>http://{HostAndPort}/csp/healthshare/{Namespace}/services/HS.IHE.PIXv3.Consumer.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
<DeviceFunction>PIXv3.Consumer</DeviceFunction>
</WebService>
</Items>
}

XData OIDEntries
{
<Items>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.1</OID>
<IdentityCode>PIXv3ManagerDevice</IdentityCode>
<IdentityTypes><OIDType><Description>Device</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.2</OID>
<IdentityCode>PIXv3ConsumerDevice</IdentityCode>
<IdentityTypes><OIDType><Description>Device</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.3</OID>
<IdentityCode>PDQv3SupplierDevice</IdentityCode>
<IdentityTypes><OIDType><Description>Device</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.4</OID>
<IdentityCode>PDQv3ConsumerDevice</IdentityCode>
<IdentityTypes><OIDType><Description>Device</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.5</OID>
<IdentityCode>PIXv3SourceDevice</IdentityCode>
<IdentityTypes><OIDType><Description>Device</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>

</Items>
}

/// /
XData HubItems
{
<Items>

  <Item Name="HS.IHE.PDQv3.Supplier.Services" Category="" ClassName="HS.IHE.PDQv3.Supplier.Services" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="PDQv3CancelTarget">HS.IHE.PDQ.Supplier.Process</Setting>
    <Setting Target="Host" Name="PDQv3ContinueTarget">HS.IHE.PDQ.Supplier.Process</Setting>
    <Setting Target="Host" Name="PDQv3QueryTarget">HS.IHE.PDQ.Supplier.Process</Setting>
  </Item>
  <Item Name="HS.IHE.PDQ.Supplier.Process" Category="" ClassName="HS.IHE.PDQ.Supplier.Process" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
  </Item>

  <Item Name="HS.IHE.PIXv3.Manager.Services" Category="" ClassName="HS.IHE.PIXv3.Manager.Services" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="PIXv3AddTarget">HS.IHE.PIX.Manager.Process</Setting>
    <Setting Target="Host" Name="PIXv3MergeTarget">HS.IHE.PIX.Manager.Process</Setting>
    <Setting Target="Host" Name="PIXv3QueryTarget">HS.IHE.PIX.Manager.Process</Setting>
    <Setting Target="Host" Name="PIXv3ReviseTarget">HS.IHE.PIX.Manager.Process</Setting>
  </Item>
  <Item Name="HS.IHE.PIX.Manager.Process" Category="" ClassName="HS.IHE.PIX.Manager.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
	<Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="DeviceID">PIXv3ManagerDevice</Setting>
  </Item>
  <Item Name="HS.IHE.PIXv3.Source.Operations" Category="" ClassName="HS.IHE.PIXv3.Source.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
	<Setting Target="Host" Name="Device">PIXv3SourceDevice</Setting>
    <Setting Target="Host" Name="ServiceName">PIXv3.Manager</Setting>
  </Item>

	<!-- notification operations is used to send out update notifications -->
  <Item Name="PIXv3.Notification.Operations" Category="" ClassName="HS.Util.SOAPClient.Operations" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
<Item Name="HS.IHE.PDQv3.Consumer.Operations" Category="" ClassName="HS.IHE.PDQv3.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="Device">PDQv3ConsumerDevice</Setting>
<Setting Target="Host" Name="ServiceName">PDQv3.Supplier</Setting>
</Item>
<Item Name="HS.IHE.PIXv3.Consumer.Operations" Category="" ClassName="HS.IHE.PIXv3.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="Device">PIXv3ConsumerDevice</Setting>
<Setting Target="Host" Name="ServiceName">PIXv3.Manager</Setting>
</Item>
<Item Name="HS.IHE.PIXv3.Consumer.Services" Category="" ClassName="HS.IHE.PIXv3.Consumer.Services" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="PIXv3ReviseTarget">HS.IHE.PIX.Consumer.Process</Setting>
</Item>
<Item Name="HS.IHE.PIX.Consumer.Process" Category="" ClassName="HS.IHE.PIX.Consumer.Process" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="MPIOperations"></Setting>
</Item>

</Items>
}

XData HubItemsHealthConnect
{
<Items>
  <Item Name="HS.Hub.MPI.Manager" ClassName="HS.HC.Hub.MPI.Manager">
    <Setting Target="Host" Name="PIXManager">HS.IHE.PIX.Manager.Process</Setting>
  </Item>
</Items>
}

XData HubItemsHealthShare
{
<Items>
  <Item Name="HS.Hub.MPI.Manager" ClassName="HS.Hub.MPI.Manager">
    <Setting Target="Host" Name="PIXManager">HS.IHE.PIX.Manager.Process</Setting>
  </Item>
</Items>
}

XData BusItems
{
<Items>
<Item Name="HS.IHE.PIXv3.Manager.Services" Category="" ClassName="HS.IHE.PIXv3.Manager.Services" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="PIXv3AddTarget">HS.IHE.PIXv3.Manager.Operations</Setting>
<Setting Target="Host" Name="PIXv3MergeTarget">HS.IHE.PIXv3.Manager.Operations</Setting>
<Setting Target="Host" Name="PIXv3QueryTarget">HS.IHE.PIXv3.Manager.Operations</Setting>
<Setting Target="Host" Name="PIXv3ReviseTarget">HS.IHE.PIXv3.Manager.Operations</Setting>
</Item>
<Item Name="HS.IHE.PIXv3.Manager.Operations" Category="" ClassName="HS.IHE.PIXv3.Manager.Operations" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="ServiceName">PIXv3.Manager</Setting>
</Item>
<Item Name="HS.IHE.PIXv3.Consumer.Services" Category="" ClassName="HS.IHE.PIXv3.Consumer.Services" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="PIXv3ReviseTarget">PIXv3.NotificationOperations</Setting>
</Item>
<Item Name="PIXv3.NotificationOperations" Category="" ClassName="HS.Util.SOAPClient.Operations" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="ServiceName">PIXv3.Consumer</Setting>
</Item>
<Item Name="HS.IHE.PDQv3.Supplier.Services" Category="" ClassName="HS.IHE.PDQv3.Supplier.Services" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="PDQv3CancelTarget">HS.IHE.PDQv3.Consumer.Operations</Setting>
<Setting Target="Host" Name="PDQv3ContinueTarget">HS.IHE.PDQv3.Consumer.Operations</Setting>
<Setting Target="Host" Name="PDQv3QueryTarget">HS.IHE.PDQv3.Consumer.Operations</Setting>
</Item>
<Item Name="HS.IHE.PDQv3.Consumer.Operations" Category="" ClassName="HS.IHE.PDQv3.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="ServiceName">PDQv3.Supplier</Setting>
</Item>
</Items>
}

}
