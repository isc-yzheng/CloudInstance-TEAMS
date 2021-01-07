/// HS.Util.Installer.Kit.IHE.PIXPDQv2 sets up a starter or demo set of definitions for PIXv2 and PDQv2.
/// 
Class HS.Util.Installer.Kit.IHE.PIXPDQv2 Extends HS.Util.Installer.Kit.Base
{

/// 
/// Set tSC = ##class(HS.Util.Installer.Kit.IHE.PIXPDQv2).Add()
/// 
Parameter NamespaceTypes As %String = "Hub";

ClassMethod Add(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pRegistryNS As %String = "HSREGISTRY") As %Status
{
	try {
		Set tSC = ..AddHub(,pRegistryNS)
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
		Kill tProdRef
		Set tSC=..GetProduction(.tProdRef,"") Quit:$$$ISERR(tSC)
		Set tFound=0
		For tI=1:1:tProdRef.Items.Count() {
			Set tItem=tProdRef.Items.GetAt(tI)
			If tItem.ClassName="HS.IHE.PIXv2.Manager.Services" Set tFound=1 Quit
		}
		If tFound=0 {
			Set tProdRef.ActorPoolSize = tProdRef.ActorPoolSize+10
			Set tSC=##class(HS.Util.Installer.Upgrade.Abstract).SaveProduction(tProdRef)
		}
		Kill tProdRef
		Quit:$$$ISERR(tSC)
		
		Set tSC= ..ProductionMods(pNS,"HubItems",1) Quit:$$$ISERR(tSC)
		Set tSC = ..%New().AddRegistryEntries()
		Set tSC = ..AddOIDEntries(pNS,"OIDEntries") Quit:$$$ISERR(tSC)

		Set tConsumerID = "PIXv2ConsumerDevice"
		#; if already run don't try to set it up again
		If '##class(HS.IHE.PIX.Manager.DomainsOfInterest).ConsumerFound(tConsumerID,"") {
			Set tOBJ=##class(HS.IHE.PIX.Manager.DomainsOfInterest).%New()
			Set tOBJ.ConsumerID=tConsumerID  // oid entry for our pix consumer - to accept updates
			Set tOBJ.AllDomains=0
			Do tOBJ.Domains.Clear()
			Set tSC=tOBJ.%Save()
		}
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

XData RegistryEntries
{
<Items>
<TCPService>
<Name>PIXv2.Manager</Name>
<Host>127.0.0.1</Host>
<Port>47001</Port>
<SSLConfig></SSLConfig>
<StayConnected></StayConnected>
<OIDMapCode>
<OIDMapCodeItem OIDMapCodeKey="Device">PIXv2ManagerDevice</OIDMapCodeItem>
<OIDMapCodeItem OIDMapCodeKey="ReceivingApplication">ISC-HealthShare</OIDMapCodeItem>
<OIDMapCodeItem OIDMapCodeKey="ReceivingFacility">CGH</OIDMapCodeItem>
</OIDMapCode>
<DeviceFunction>PIXv2.Manager</DeviceFunction>
</TCPService>
<TCPService>
<Name>PDQv2.Supplier</Name>
<Host>127.0.0.1</Host>
<Port>47003</Port>
<SSLConfig></SSLConfig>
<StayConnected></StayConnected>
<OIDMapCode>
<OIDMapCodeItem OIDMapCodeKey="Device">PDQv2SupplierDevice</OIDMapCodeItem>
<OIDMapCodeItem OIDMapCodeKey="ReceivingApplication">ISC-HealthShare</OIDMapCodeItem>
<OIDMapCodeItem OIDMapCodeKey="ReceivingFacility"></OIDMapCodeItem>
</OIDMapCode>
<DeviceFunction>PDQv2.Supplier</DeviceFunction>
</TCPService>
<TCPService>
<Name>PIXv2.Consumer</Name>
<Host>127.0.0.1</Host>
<Port>47005</Port>
<SSLConfig></SSLConfig>
<StayConnected></StayConnected>
<DeviceFunction>PIXv2.Consumer</DeviceFunction>
<OIDMapCode>
<OIDMapCodeItem OIDMapCodeKey="Device">PIXv2ConsumerDevice</OIDMapCodeItem>
<OIDMapCodeItem OIDMapCodeKey="ReceivingApplication">ISC-HealthShare</OIDMapCodeItem>
<OIDMapCodeItem OIDMapCodeKey="ReceivingFacility"></OIDMapCodeItem>
</OIDMapCode>
</TCPService>
</Items>
}

XData OIDEntries
{
<Items>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.6</OID>
<IdentityCode>PIXv2ManagerDevice</IdentityCode>
<IdentityTypes><OIDType><Description>Device</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.7</OID>
<IdentityCode>PIXv2ConsumerDevice</IdentityCode>
<IdentityTypes><OIDType><Description>Device</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.8</OID>
<IdentityCode>PDQv2SupplierDevice</IdentityCode>
<IdentityTypes><OIDType><Description>Device</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.9</OID>
<IdentityCode>PDQv2ConsumerDevice</IdentityCode>
<IdentityTypes><OIDType><Description>Device</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.10</OID>
<IdentityCode>PIXv2SourceDevice</IdentityCode>
<IdentityTypes><OIDType><Description>Device</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>

</Items>
}

XData HubItems
{
<Items>
<Item Name="HS.IHE.PIX.Consumer.Process" Category="" ClassName="HS.IHE.PIX.Consumer.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="MPIOperations"></Setting>
</Item>
<Item Name="HS.IHE.PIX.Manager.Process" Category="" ClassName="HS.IHE.PIX.Manager.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="InactivityTimeout">0</Setting>
</Item>
<Item Name="HS.IHE.PDQ.Supplier.Process" Category="" ClassName="HS.IHE.PDQ.Supplier.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
</Item>
<Item Name="HS.IHE.PIXv2.Consumer.Services" Category="" ClassName="HS.IHE.PIXv2.Consumer.Services" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
<Setting Target="Host" Name="TargetConfigNames">HS.IHE.PIX.Consumer.Process</Setting>
<Setting Target="Host" Name="AckMode">App</Setting>
<Setting Target="Adapter" Name="StayConnected">-1</Setting>
<Setting Target="Adapter" Name="JobPerConnection">1</Setting>
<Setting Target="Adapter" Name="Port">47005</Setting>
</Item>
<Item Name="HS.IHE.PIXv2.Manager.Services" Category="" ClassName="HS.IHE.PIXv2.Manager.Services" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
<Setting Target="Host" Name="TargetConfigNames">HS.IHE.PIX.Manager.Process</Setting>
<Setting Target="Host" Name="AckMode">App</Setting>
<Setting Target="Adapter" Name="StayConnected">-1</Setting>
<Setting Target="Adapter" Name="JobPerConnection">1</Setting>
<Setting Target="Adapter" Name="Port">47001</Setting>
</Item>
<Item Name="HS.IHE.PDQv2.Supplier.Services" Category="" ClassName="HS.IHE.PDQv2.Supplier.Services" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
<Setting Target="Host" Name="TargetConfigNames">HS.IHE.PDQ.Supplier.Process</Setting>
<Setting Target="Host" Name="AckMode">App</Setting>
<Setting Target="Adapter" Name="StayConnected">-1</Setting>
<Setting Target="Adapter" Name="JobPerConnection">1</Setting>
<Setting Target="Adapter" Name="Port">47003</Setting>
</Item>
<Item Name="HS.IHE.PIXv2.Consumer.Operations" Category="" ClassName="HS.IHE.PIXv2.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="ServiceName">PIXv2.Manager</Setting>
</Item>
<Item Name="HS.IHE.PIXv2.Source.Operations" Category="" ClassName="HS.IHE.PIXv2.Source.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="ServiceName">PIXv2.Manager</Setting>
</Item>
<Item Name="HS.IHE.PDQv2.Consumer.Operations" Category="" ClassName="HS.IHE.PDQv2.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="ServiceName">PDQv2.Supplier</Setting>
</Item>
<Item Name="PIXv2.Notification.Operations" Category="" ClassName="HS.Util.HL7Client.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="ServiceName">PIXv2.Consumer</Setting>
</Item>
</Items>
}

}
