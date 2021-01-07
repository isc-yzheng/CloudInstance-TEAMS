Include HS.Test

Class HS.Test.IHE.DSUB.Base Extends HS.Test.IHE.Base [ Abstract ]
{

Parameter BaseClassItems = "HS.Test.IHE.DSUB.Base";

Parameter MPIManager = "HS.Generated.Test.MPI.Manager";

Parameter Repository = "HS.Generated.Test.IHE.XDSb.Repository.Services";

Parameter Registry = "HS.Generated.Test.IHE.XDSb.Registry.Services";

Parameter DocumentSource = "HS.Generated.Test.IHE.XDSb.DocumentSource.Operations";

Parameter DocumentConsumer = "HS.Generated.Test.IHE.XDSb.Consumer.Operations";

Parameter DSUBSubscriber = "HS.Generated.Test.IHE.DSUB.Subscriber.Operations";

Parameter PDQConsumer = "HS.Generated.Test.MPI.Manager";

Parameter ConsumerServiceName = "Test.DSUB.NotificationConsumer";

Parameter BrokerServiceName = "Test.DSUB.NotificationBroker";

Method SetupMain()
{
	try {
		Set tSC = $$$OK
		Do ##class(HS.Util.Installer.Kit.PostInstall.XDSbCodes).RunHub()
		Do ##class(HS.Util.Installer.Kit.PostInstall.Demo.OIDEntries).RunHub()
		$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.XDSb.Registry.Services",,1)=$$$OK,"Created registry service")
		$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.XDSb.Repository.Services",,1)=$$$OK,"Created repository service")
		$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.DSUB.NotificationBroker.Services",,1)=$$$OK,"Created notification broker service")
		$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.DSUB.NotificationConsumer.Services",,1)=$$$OK,"Created notification broker service")
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

XData Items
{
<Items>
  <Item Name="HS.Test.Service" Category="" ClassName="HS.Test.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>

  <Item Name="HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services" Category="" ClassName="HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
	<Setting Target="Host" Name="NotificationTarget">HS.Generated.Test.IHE.DSUB.NotificationConsumer.Process</Setting>
	<Setting Target="Host" Name="RequireValidSAMLToken">0</Setting>
  </Item>

  <Item Name="HS.Generated.Test.IHE.DSUB.NotificationConsumer.Process" Category="" ClassName="HS.IHE.DSUB.NotificationConsumer.Process" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>

  <Item Name="HS.Generated.Test.IHE.DSUB.NotificationBroker.Services" Category="" ClassName="HS.Generated.Test.IHE.DSUB.NotificationBroker.Services" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
	<Setting Target="Host" Name="NotificationTarget">HS.Generated.Test.IHE.DSUB.NotificationBroker.Operations</Setting>
	<Setting Target="Host" Name="SubscribeTarget">HS.Generated.Test.IHE.DSUB.NotificationBroker.Operations</Setting>
	<Setting Target="Host" Name="UnsubscribeTarget">HS.Generated.Test.IHE.DSUB.NotificationBroker.Operations</Setting>
	<Setting Target="Host" Name="RequireValidSAMLToken">0</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.DSUB.NotificationBroker.Operations" Category="" ClassName="HS.IHE.DSUB.NotificationBroker.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
    <Setting Target="Host" Name="NotificationBrokerServiceName">Test.DSUB.NotificationBroker</Setting>
    <Setting Target="Host" Name="PDQConsumer">HS.Generated.Test.MPI.Manager</Setting>
    <Setting Target="Host" Name="NotificationOperation">HS.Generated.Test.IHE.DSUB.Notification.Operations</Setting>
    
  </Item>
  <Item Name="HS.Generated.Test.IHE.DSUB.Notification.Operations" Category="" ClassName="HS.Util.SOAPClient.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
  
  
  <Item Name="HS.Generated.Test.IHE.DSUB.Subscriber.Operations" Category="" ClassName="HS.IHE.DSUB.Subscriber.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>





  <Item Name="HS.Generated.Test.IHE.XDSb.Registry.Services" Category="" ClassName="HS.Generated.Test.IHE.XDSb.Registry.Services" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="XDSbQueryTarget">HS.Generated.Test.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="XDSbRegisterTarget">HS.Generated.Test.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="XDSbRegisterOnDemandTarget">HS.Generated.Test.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="XDSbUpdateDocumentSetTarget">HS.Generated.Test.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="XDSbDeleteDocumentSetTarget">HS.Generated.Test.IHE.XDSb.Registry.Operations</Setting>
	<Setting Target="Host" Name="RequireValidSAMLToken">0</Setting>
  </Item>

  <Item Name="HS.Generated.Test.IHE.DSUB.Publisher.Process" Category="" ClassName="HS.HC.IHE.DSUB.Publisher.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
    <Setting Target="Host" Name="LocalBrokerOperation">HS.Generated.Test.IHE.DSUB.NotificationBroker.Operations</Setting>
  </Item>

  <Item Name="HS.Generated.Test.IHE.XDSb.Registry.Operations" Category="" ClassName="HS.HC.IHE.XDSb.Registry.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
    <Setting Target="Host" Name="Publisher">HS.Generated.Test.IHE.DSUB.Publisher.Process</Setting>
  </Item>

  <Item Name="HS.Generated.Test.IHE.XDSb.DocumentSource.Operations" Category="" ClassName="HS.IHE.XDSb.DocumentSource.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">1</Setting>
    <Setting Target="Host" Name="XDSbRepositoryServiceName">Test.XDSb.Repository</Setting>
    <Setting Target="Host" Name="XDSbRegistryServiceName">Test.XDSb.Registry</Setting>
	<Setting Target="Host" Name="PIXv3ConsumerOperations">HS.Generated.Test.MPI.Manager</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.XDSb.Consumer.Operations" Category="" ClassName="HS.HC.IHE.XDSb.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="XDSbRegistryServiceName">Test.XDSb.Registry</Setting>
    <Setting Target="Host" Name="XDSbRepositoryServiceName">Test.XDSb.Repository</Setting>
    <Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>

  <Item Name="HS.Generated.Test.IHE.XDSb.Repository.Services" Category="" ClassName="HS.Generated.Test.IHE.XDSb.Repository.Services" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="XDSbProvideAndRegisterTarget">HS.Generated.Test.IHE.XDSb.Repository.Process</Setting>
    <Setting Target="Host" Name="XDSbRetrieveTarget">HS.Generated.Test.IHE.XDSb.Repository.Process</Setting>
    <Setting Target="Host" Name="RequireValidSAMLToken">0</Setting>
  </Item>

<Item Name="HS.Generated.Test.IHE.XDSb.Repository.Process" Category="" ClassName="HS.IHE.XDSb.Repository.Process" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="RepositoryOperations">HS.Generated.Test.IHE.XDSb.Repository.Operations</Setting>
<Setting Target="Host" Name="RegistryOperations">HS.Generated.Test.IHE.XDSb.Repository.Operations</Setting>
</Item>

  <Item Name="HS.Generated.Test.IHE.XDSb.Repository.Operations" Category="" ClassName="HS.IHE.XDSb.Repository.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="XDSbRegistryServiceName">Test.XDSb.Registry</Setting>
    <Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>
  <Item Name="HS.Generated.Test.MPI.Manager" Category="" ClassName="HS.HC.MPI.Manager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>

</Items>
}

XData AdditionalItems
{
}

XData OIDEntries
{
<Items>
<Item><OID>1.3.6.1.4.1.21367.2010.1.2.300.100</OID><IdentityCode>HSREGISTRY</IdentityCode><IdentityTypes><OIDType><Description>Repository</Description></OIDType></IdentityTypes></Item>
</Items>
}

XData AdditionalOIDEntries
{
}

XData RegistryEntries
{
<Items>
<WebService>
<Name>Test.DSUB.NotificationBroker</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/{Namespace}/services/HS.Generated.Test.IHE.DSUB.NotificationBroker.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>

<WebService>
<Name>Test.DSUB.NotificationConsumer</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/{Namespace}/services/HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>

<!-- Registry / Repository -->
<WebService>
<Name>Test.XDSb.Registry</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/{Namespace}/services/HS.Generated.Test.IHE.XDSb.Registry.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>
<WebService>
<Name>Test.XDSb.Repository</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/{Namespace}/services/HS.Generated.Test.IHE.XDSb.Repository.Services.cls</EndPoint>
<MTOM>1</MTOM>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>
</Items>
}

XData AdditionalRegistryEntries
{
}

}
