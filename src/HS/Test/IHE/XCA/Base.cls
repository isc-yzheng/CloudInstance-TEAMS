Include (HS.Test, HS.IHE.XCA)

Class HS.Test.IHE.XCA.Base Extends HS.Test.IHE.Base [ Abstract ]
{

Parameter BaseClassItems = "HS.Test.IHE.XCA.Base";

Parameter MPIManager = "HS.Generated.Test.MPI.Manager";

Parameter XCPDProcess = "HS.Generated.Test.IHE.XCPD.InitiatingGateway.Process";

Parameter XCAIGOperation = "HS.Generated.Test.IHE.XCA.InitiatingGateway.Operations";

Method SetupMain()
{
	try {
		Set tSC=$$$OK
		$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.XCPD.RespondingGateway.Services",,1)=$$$OK,"Created XCPD Responding Gateway Service")
		$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.XCA.RespondingGateway.Services",,1)=$$$OK,"Created XCA Responding Gateway Service")
		$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.XCA.InitiatingGateway.Services",,1)=$$$OK,"Created XCA Initiating Gateway Service")
		$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.XDSb.Registry.Services",,1)=$$$OK,"Created registry service")
		$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.XDSb.Repository.Services",,1)=$$$OK,"Created repository service")

		Do ##class(HS.Util.Installer.Kit.PostInstall.XDSbCodes).RunHub()
		Do ##class(HS.Util.Installer.Kit.PostInstall.Demo.OIDEntries).RunHub()
		$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.XDSb.Registry.Services",,1)=$$$OK,"Created registry service")
		$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.XDSb.Repository.Services",,1)=$$$OK,"Created repository service")
		
		Do ##class(HS.Data.OIDMap).FileOID("Test.HomeCommunity","HomeCommunity","1.1.1.1.6.6.6.6")
		Set tSC = ##class(HS.Registry.Config).AddUpdateKeyValue("\IHE\HomeCommunity","Test.HomeCommunity")
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method SetupLast()
{
	Try {
		Set tSC = ##super() Quit:$$$ISERR(tSC)
		/// update XCA.RespondingGateway Endpoint with Test.HomeCommunity
		Set tEP = ##class(HS.Registry.Service.SOAP).EndPointForNameType("Test.XCA.RespondingGateway","SOAP")
		Do tEP.OIDMapCode.SetAt("Test.HomeCommunity","HomeCommunity")
		Set tSC = tEP.%Save()
		Quit:'$$$AssertStatusOK(tSC,"Updated Test.XCA.RespondingGateway end point")
		/// update Repository Endpoint with $namespace
		Set tEP = ##class(HS.Registry.Service.SOAP).EndPointForNameType("Test.XDSb.Repository","SOAP")
		Do tEP.OIDMapCode.SetAt($namespace,"Repository")
		Set tSC = tEP.%Save()
		Quit:'$$$AssertStatusOK(tSC,"Updated Test.Reepository end point")
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
  <Item Name="HS.Generated.Test.IHE.XCA.InitiatingGateway.Services" Category="" ClassName="HS.Generated.Test.IHE.XCA.InitiatingGateway.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="XCAQueryTarget">HS.Generated.Test.IHE.XCA.InitiatingGateway.Process</Setting>
    <Setting Target="Host" Name="XCARetrieveTarget">HS.Generated.Test.IHE.XCA.InitiatingGateway.Process</Setting>
	<Setting Target="Host" Name="RequireValidSAMLToken">0</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.XCA.InitiatingGateway.Process" Category="" ClassName="HS.IHE.XCA.InitiatingGateway.Process" PoolSize="2" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
	<Setting Target="Host" Name="TraceOperations">1</Setting>
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
	<Setting Target="Host" Name="XDSbQueryServiceName"></Setting>  
	<!--    <Setting Target="Host" Name="XDSbQueryServiceName">Test.XDSb.Registry</Setting>  -->
    <Setting Target="Host" Name="XCPDInitiatingGatewayProcess">HS.Generated.Test.IHE.XCPD.InitiatingGateway.Process</Setting>
    <Setting Target="Host" Name="XCAInitiatingGatewayOperations">HS.Generated.Test.IHE.XCA.InitiatingGateway.Operations</Setting>
    
  </Item>
  <Item Name="HS.Generated.Test.IHE.XCA.InitiatingGateway.Operations" Category="" ClassName="HS.IHE.XCA.InitiatingGateway.Operations" PoolSize="2" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="TraceOperations">1</Setting>
 <!--   <Setting Target="Host" Name="ServiceName">Test.XCA.RespondingGateway</Setting> -->
  </Item>
  <Item Name="HS.Generated.Test.IHE.XCA.RespondingGateway.Services" Category="" ClassName="HS.Generated.Test.IHE.XCA.RespondingGateway.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="XCAQueryTarget">HS.Generated.Test.IHE.XCA.RespondingGateway.Process</Setting>
    <Setting Target="Host" Name="XCARetrieveTarget">HS.Generated.Test.IHE.XCA.RespondingGateway.Process</Setting>
	<Setting Target="Host" Name="RequireValidSAMLToken">0</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.XCA.RespondingGateway.Process" Category="" ClassName="HS.IHE.XCA.RespondingGateway.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="XDSbRegistryOperations">HS.Generated.Test.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="XCARespondingGatewayOperations">HS.Generated.Test.IHE.XCA.RespondingGateway.Operations</Setting>
    <Setting Target="Host" Name="XDSbRepositoryProcess">HS.Generated.Test.IHE.XDSb.Repository.Process</Setting>
	<Setting Target="Host" Name="TraceOperations">1</Setting>
</Item>
  <Item Name="HS.Generated.Test.IHE.XCA.RespondingGateway.Operations" Category="" ClassName="HS.IHE.XCA.RespondingGateway.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
	<Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.XDSb.Registry.Services" Category="" ClassName="HS.Generated.Test.IHE.XDSb.Registry.Services" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
    <Setting Target="Host" Name="XDSbQueryTarget">HS.Generated.Test.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="XDSbRegisterTarget">HS.Generated.Test.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="XDSbRegisterOnDemandTarget">HS.Generated.Test.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="XDSbUpdateDocumentSetTarget">HS.Generated.Test.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="XDSbDeleteDocumentSetTarget">HS.Generated.Test.IHE.XDSb.Registry.Operations</Setting>
	<Setting Target="Host" Name="RequireValidSAMLToken">0</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.XDSb.Registry.Operations" Category="" ClassName="HS.HC.IHE.XDSb.Registry.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.XDSb.DocumentSource.Operations" Category="" ClassName="HS.IHE.XDSb.DocumentSource.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">1</Setting>
    <Setting Target="Host" Name="XDSbRepositoryServiceName">Test.XDSb.Repository</Setting>
    <Setting Target="Host" Name="XDSbRegistryServiceName">Test.XDSb.Registry</Setting>
	<Setting Target="Host" Name="PIXv3ConsumerOperations">HS.Generated.Test.MPI.Manager</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.XDSb.Consumer.Operations" Category="" ClassName="HS.HC.IHE.XDSb.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="XDSbRegistryServiceName">Test.XCA.InitiatingGateway</Setting>
    <Setting Target="Host" Name="XDSbRepositoryServiceName">Test.XCA.InitiatingGateway</Setting>
    <Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>

  <Item Name="HS.Generated.Test.IHE.XDSb.Repository.Services" Category="" ClassName="HS.Generated.Test.IHE.XDSb.Repository.Services" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
    <Setting Target="Host" Name="XDSbProvideAndRegisterTarget">HS.Generated.Test.IHE.XDSb.Repository.Process</Setting>
    <Setting Target="Host" Name="XDSbRetrieveTarget">HS.Generated.Test.IHE.XDSb.Repository.Process</Setting>
    <Setting Target="Host" Name="RequireValidSAMLToken">0</Setting>
  </Item>

<Item Name="HS.Generated.Test.IHE.XDSb.Repository.Process" Category="" ClassName="HS.IHE.XDSb.Repository.Process" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="RepositoryOperations">HS.Generated.Test.IHE.XDSb.Repository.Operations</Setting>
<Setting Target="Host" Name="RegistryOperations">HS.Generated.Test.IHE.XDSb.Repository.Operations</Setting>
<Setting Target="Host" Name="TraceOperations">1</Setting>
</Item>

  <Item Name="HS.Generated.Test.IHE.XDSb.Repository.Operations" Category="" ClassName="HS.IHE.XDSb.Repository.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="XDSbRegistryServiceName">Test.XDSb.Registry</Setting>
    <Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>

  <Item Name="HS.Generated.Test.IHE.XCPD.RespondingGateway.Services" Category="" ClassName="HS.Generated.Test.IHE.XCPD.RespondingGateway.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="XCPDDiscoveryTarget">HS.Generated.Test.IHE.XCPD.RespondingGateway.Process</Setting>
    <Setting Target="Host" Name="RequireValidSAMLToken">0</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.XCPD.RespondingGateway.Process" Category="" ClassName="HS.IHE.XCPD.RespondingGateway.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="PDQv3Supplier">HS.Generated.Test.MPI.Manager</Setting>
    <Setting Target="Host" Name="XCPDRespondingGatewayOperations">HS.Generated.Test.IHE.XCPD.RespondingGateway.Operations</Setting>
	<Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.XCPD.RespondingGateway.Operations" Category="" ClassName="HS.IHE.XCPD.RespondingGateway.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
	<Setting Target="Host" Name="TraceOperations">1</Setting>
</Item>
  <Item Name="HS.Generated.Test.IHE.XCPD.InitiatingGateway.Process" Category="" ClassName="HS.IHE.XCPD.InitiatingGateway.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="XCPDQueryServiceNames">Test.XCPD.RespondingGateway</Setting>
    <Setting Target="Host" Name="PDQv3Consumer">HS.Generated.Test.MPI.Manager</Setting>
    <Setting Target="Host" Name="XCPDInitiatingGatewayOperations">HS.Generated.Test.IHE.XCPD.InitiatingGateway.Operations</Setting>
	<Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.XCPD.InitiatingGateway.Operations" Category="" ClassName="HS.IHE.XCPD.InitiatingGateway.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
<Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>


<Item Name="HS.Generated.Test.MPI.Manager" Category="" ClassName="HS.HC.MPI.Manager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="TraceOperations">1</Setting>
</Item>


</Items>
}

/// Used to run XCPD through PDQv3 consumer
XData XCPDPDQv3
{
<Items>
  <Item Name="HS.Generated.Test.IHE.XCPD.RespondingGateway.Process" Category="" ClassName="HS.IHE.XCPD.RespondingGateway.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="PDQv3Supplier">HS.Generated.Test.IHE.PDQv3.Consumer.Operations</Setting>
  </Item>
 </Items>
}

XData XCPDPDQv2
{
<Items>
  <Item Name="HS.Generated.Test.IHE.XCPD.RespondingGateway.Process" Category="" ClassName="HS.IHE.XCPD.RespondingGateway.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="PDQv3Supplier">HS.Generated.Test.IHE.PDQv2.Consumer.Operations</Setting>
  </Item>
 </Items>
}

XData XCPDPDQAdditionalItems
{
<Items>
  <Item Name="HS.Generated.Test.IHE.PDQv3.Supplier.Services" Category="" ClassName="HS.Generated.Test.IHE.PDQv3.Supplier.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="PDQv3CancelTarget">HS.Generated.Test.IHE.PDQ.Supplier.Process</Setting>
    <Setting Target="Host" Name="PDQv3ContinueTarget">HS.Generated.Test.IHE.PDQ.Supplier.Process</Setting>
    <Setting Target="Host" Name="PDQv3QueryTarget">HS.Generated.Test.IHE.PDQ.Supplier.Process</Setting>
	<Setting Target="Host" Name="RequireValidSAMLToken">0</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.PDQ.Supplier.Process" Category="" ClassName="HS.IHE.PDQ.Supplier.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MPIOperations">HS.Generated.Test.MPI.Manager</Setting>
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.PDQv3.Consumer.Operations" Category="" ClassName="HS.IHE.PDQv3.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="Device">Test.PDQv3ConsumerDevice</Setting>
    <Setting Target="Host" Name="ServiceName">Test.PDQv3.Supplier</Setting>
    <Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.PDQv2.Supplier.Services" Category="" ClassName="HS.IHE.PDQv2.Supplier.Services" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Host" Name="TargetConfigNames">HS.Generated.Test.IHE.PDQ.Supplier.Process</Setting>
    <Setting Target="Host" Name="AckMode">App</Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
    <Setting Target="Adapter" Name="JobPerConnection">1</Setting>
    <Setting Target="Adapter" Name="Port">48003</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.PDQv2.Consumer.Operations" Category="" ClassName="HS.IHE.PDQv2.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ServiceName">Test.PDQv2.Supplier</Setting>
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  </Items>
}

XData AdditionalItems
{
}

XData OIDEntries
{
}

XData AdditionalOIDEntries
{
}

XData RegistryEntries
{
<Items>
<WebService>
<Name>Test.PDQv3.Supplier</Name>
<SSLConfig></SSLConfig>
<EndPoint>http://{HostAndPort}/csp/healthshare/{Namespace}/services/HS.Generated.Test.IHE.PDQv3.Supplier.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
<OIDMapCode><OIDMapCodeItem OIDMapCodeKey="Device">PDQv3SupplierDevice</OIDMapCodeItem></OIDMapCode>
<DeviceFunction>PDQv3.Supplier</DeviceFunction>
</WebService>

<TCPService>
<Name>Test.PDQv2.Supplier</Name>
<Host>127.0.0.1</Host>
<Port>48003</Port>
<SSLConfig></SSLConfig>
<StayConnected></StayConnected>
<OIDMapCode>
<OIDMapCodeItem OIDMapCodeKey="Device">Test.PDQv2SupplierDevice</OIDMapCodeItem>
<OIDMapCodeItem OIDMapCodeKey="ReceivingApplication">ISC-HealthShare</OIDMapCodeItem>
<OIDMapCodeItem OIDMapCodeKey="ReceivingFacility"></OIDMapCodeItem>
</OIDMapCode>
<DeviceFunction>PDQv2.Supplier</DeviceFunction>
</TCPService>
<WebService>
<Name>Test.XCPD.RespondingGateway</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/{Namespace}/services/HS.Generated.Test.IHE.XCPD.RespondingGateway.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>
<WebService>
<OIDMapCode><OIDMapCodeItem OIDMapCodeKey="HomeCommunity">Test.HomeCommunity</OIDMapCodeItem></OIDMapCode>
<Name>Test.XCA.RespondingGateway</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/{Namespace}/services/HS.Generated.Test.IHE.XCA.RespondingGateway.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>
<WebService>
<Name>Test.XCA.InitiatingGateway</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/{Namespace}/services/HS.Generated.Test.IHE.XCA.InitiatingGateway.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>
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
