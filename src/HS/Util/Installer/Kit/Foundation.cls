/// setup production for demonstration
/// 	in HealthShare Foundation namespace Do ##class(HS.Util.Installer.Kit.Foundation).Add()
/// 	
/// 	This adds the various hosts to the production to perform simple PIX / PDQ / XDS /XCA tasks
Class HS.Util.Installer.Kit.Foundation Extends HS.Util.Installer.Kit.PostInstall.Base
{

Parameter NamespaceTypes As %String;

ClassMethod Add(pNamespaces As HS.Util.Installer.Kit.Namespaces = {$$$NULLOREF}, pNS As %String = {$namespace}, pProduction = "") As %Status
{
	try {
		Set tWhere = $Namespace
		Set $Namespace = pNS
		Set tSC= ..ProductionMods(pNS,"Items",1,pProduction) Quit:$$$ISERR(tSC)
		Set tSC = ..AddOIDEntries(pNS,"OIDEntries") Quit:$$$ISERR(tSC)
		Set tSC = ..%New().AddRegistryEntries(pNS,"RegistryEntries") Quit:$$$ISERR(tSC)
		
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

XData OIDEntries
{
<Items>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.1</OID>
<IdentityCode>HSREPOSITORY</IdentityCode>
<IdentityTypes><OIDType><Description>Repository</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>
</Items>
}

XData RegistryEntries
{
<Items>
<!-- Registry / Repository -->
<WebService>
<Name>XDSb.Registry</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/hsregistry/services/HS.IHE.XDSb.Registry.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>
<WebService>
<Name>XDSb.Repository</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/hsrepository/services/HS.IHE.XDSb.Repository.Services.cls</EndPoint>
<MTOM>1</MTOM>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>

<WebService>
<Name>XDR.Recipient</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/hsrepository/services/HS.IHE.XDR.Recipient.Services.cls</EndPoint>
<MTOM>1</MTOM>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>

<WebService>
<Name>PIXv3.Manager</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/hsregistry/services/HS.IHE.PIXv3.Manager.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>
<WebService>
<Name>PDQv3.Supplier</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/hsregistry/services/HS.IHE.PDQv3.Supplier.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>

<TCPService>
<Name>PIXv2.Manager</Name>
<Host></Host>
<Port></Port>
<SSLConfig></SSLConfig>
<StayConnected></StayConnected>
<OIDMapCode>
<OIDMapCodeItem OIDMapCodeKey="ReceivingApplication"></OIDMapCodeItem>
<OIDMapCodeItem OIDMapCodeKey="ReceivingFacility"></OIDMapCodeItem>
</OIDMapCode>
<DeviceFunction></DeviceFunction>
</TCPService>
<TCPService>
<Name>PDQv2.Supplier</Name>
<Host></Host>
<Port></Port>
<SSLConfig></SSLConfig>
<StayConnected></StayConnected>
<OIDMapCode>
<OIDMapCodeItem OIDMapCodeKey="ReceivingApplication"></OIDMapCodeItem>
<OIDMapCodeItem OIDMapCodeKey="ReceivingFacility"></OIDMapCodeItem>
</OIDMapCode>
<DeviceFunction></DeviceFunction>
</TCPService>
<TCPService>
<Name>SyslogCollector.IHE</Name>
<Host>128.252.175.39</Host>
<Port>3101</Port>
<SSLConfig></SSLConfig>
<StayConnected>1</StayConnected>
<DeviceFunction></DeviceFunction>
</TCPService>
</Items>
}

XData Items
{
<Items>
  <Item Name="HS.Audit.ConsolidationService" Category="" ClassName="HS.HC.Audit.ConsolidationService" PoolSize="1" Enabled="true" Foreground="false" DisableErrorTraps="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="AuditAlertOperations"></Setting>
  </Item>
  <Item Name="HS.Test.Service" Category="" ClassName="HS.Test.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.IHE.PDQv3.Consumer.Operations" Category="" ClassName="HS.IHE.PDQv3.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ServiceName">PDQv3.Supplier</Setting>
    <Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>
  <Item Name="HS.IHE.PIXv3.Consumer.Operations" Category="" ClassName="HS.IHE.PIXv3.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ServiceName">PIXv3.Manager</Setting>
    <Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>
  <Item Name="HS.IHE.PIXv3.Source.Operations" Category="" ClassName="HS.IHE.PIXv3.Source.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ServiceName">PIXv3.Manager</Setting>
    <Setting Target="Host" Name="OperationToLocateMPIID">HS.IHE.PIXv3.Consumer.Operations</Setting>
    <Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>
  <Item Name="HS.IHE.ATNA.SecureApplication.TCP.Operations" Category="" ClassName="HS.IHE.ATNA.SecureApplication.TCP.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
	<Setting Target="Host" Name="ServiceName">SyslogCollector.IHE</Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.DocumentSource.Operations" Category="" ClassName="HS.IHE.XDSb.DocumentSource.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>
  <Item Name="HS.IHE.XDR.Source.Operations" Category="" ClassName="HS.IHE.XDR.Source.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">1</Setting>
    <Setting Target="Host" Name="ServiceName">XDR.Recipient</Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.Consumer.Operations" Category="" ClassName="HS.HC.IHE.XDSb.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="XDSbRegistryServiceName">XDSb.Registry</Setting>
    <Setting Target="Host" Name="XDSbRepositoryServiceName">XDSb.Repository</Setting>
    <Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>

<Item Name="HS.IHE.XDM.PortableMediaCreator.Process" Category="" ClassName="HS.IHE.XDM.PortableMediaCreator.Process" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>
  <Item Name="HS.IHE.XDM.FileOutputOperation" Category="" ClassName="HS.IHE.XDM.FileOutputOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>


<!-- xca -->
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
<Setting Target="Host" Name="RepositoryOperations">HS.IHE.XDSb.Repository.Operations</Setting>
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
<Setting Target="Host" Name="XCPDQueryServiceNames">Other.XCPD.RespondingGateway</Setting>
</Item>
<Item Name="HS.IHE.XCPD.InitiatingGateway.Operations" Category="" ClassName="HS.IHE.XCPD.InitiatingGateway.Operations" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
</Item>

<!-- pixv2/pdqv2 -->
<Item Name="HS.IHE.PIXv2.Consumer.Operations" Category="" ClassName="HS.IHE.PIXv2.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="ServiceName">PIXv2.Manager</Setting>
</Item>
<Item Name="HS.IHE.PIXv2.Source.Operations" Category="" ClassName="HS.IHE.PIXv2.Source.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="ServiceName">PIXv2.Manager</Setting>
</Item>
<Item Name="HS.IHE.PDQv2.Consumer.Operations" Category="" ClassName="HS.IHE.PDQv2.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="ServiceName">PDQv2.Supplier</Setting>
</Item>

<Item Name="HS.IHE.XDSb.Administrator.Operations" Category="" ClassName="HS.IHE.XDSb.Administrator.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
</Item>

</Items>
}

}
