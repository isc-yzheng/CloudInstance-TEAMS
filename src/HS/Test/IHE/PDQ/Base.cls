Include HS.Test

Class HS.Test.IHE.PDQ.Base Extends HS.Test.IHE.Base [ Abstract ]
{

Parameter BaseClassItems = "HS.Test.IHE.PDQ.Base";

Parameter MPIManager = "HS.Generated.Test.MPI.Manager";

Parameter PDQv2Consumer = "HS.Generated.Test.IHE.PDQv2.Consumer.Operations";

Parameter PDQv3Consumer = "HS.Generated.Test.IHE.PDQv3.Consumer.Operations";

Method SetupMain()
{
	try {
		Set tSC=$$$OK
		$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.PDQv3.Supplier.Services",,1)=$$$OK,"Created PDQv3 Supplier Service")
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method SetupLast()
{
	Try {
		Set tSC = ##super() Quit:$$$ISERR(tSC)
		/// update Test.PDQv3.Supplier Endpoint with Device=Test.PDQv3SupplierDevice
		Set tEP = ##class(HS.Registry.Service.SOAP).EndPointForNameType("Test.PDQv3.Supplier","SOAP")
		Do tEP.OIDMapCode.SetAt("Test.PDQv3SupplierDevice","Device")
		Set tSC = tEP.%Save()
		Quit:'$$$AssertStatusOK(tSC,"Updated Test.PDQv3.Supplier end point")
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
  <Item Name="HS.Generated.Test.IHE.PDQv3.Supplier.Services" Category="" ClassName="HS.Generated.Test.IHE.PDQv3.Supplier.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="PDQv3CancelTarget">HS.Generated.Test.IHE.PDQ.Supplier.Process</Setting>
    <Setting Target="Host" Name="PDQv3ContinueTarget">HS.Generated.Test.IHE.PDQ.Supplier.Process</Setting>
    <Setting Target="Host" Name="PDQv3QueryTarget">HS.Generated.Test.IHE.PDQ.Supplier.Process</Setting>
	<Setting Target="Host" Name="RequireValidSAMLToken">0</Setting>
	<Setting Target="Host" Name="XMLValidator">HS.Util.XML.Validator</Setting>
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
	<Setting Target="Host" Name="XMLValidator">HS.Util.XML.Validator</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.PDQv2.Supplier.Services" Category="" ClassName="HS.IHE.PDQv2.Supplier.Services" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Host" Name="TargetConfigNames">HS.Generated.Test.IHE.PDQ.Supplier.Process</Setting>
    <Setting Target="Host" Name="AckMode">App</Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
    <Setting Target="Adapter" Name="JobPerConnection">1</Setting>
    <Setting Target="Adapter" Name="Port">48103</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.PDQv2.Consumer.Operations" Category="" ClassName="HS.IHE.PDQv2.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ServiceName">Test.PDQv2.Supplier</Setting>
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>

<Item Name="HS.Generated.Test.MPI.Manager" Category="" ClassName="HS.HC.MPI.Manager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="TraceOperations">1</Setting>
<!--<Setting Target="Host" Name="PIXManager">HS.Generated.Test.IHE.PIX.Manager.Process</Setting>-->
</Item>

</Items>
}

XData AdditionalItems
{
}

XData OIDEntries
{
<Items>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.3.99</OID>
<IdentityCode>Test.PDQv3SupplierDevice</IdentityCode>
<IdentityTypes><OIDType><Description>Device</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.4.99</OID>
<IdentityCode>Test.PDQv3ConsumerDevice</IdentityCode>
<IdentityTypes><OIDType><Description>Device</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>

</Items>
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
<OIDMapCode><OIDMapCodeItem OIDMapCodeKey="Device">Test.PDQv3SupplierDevice</OIDMapCodeItem></OIDMapCode>
<DeviceFunction>PDQv3.Supplier</DeviceFunction>
</WebService>

<TCPService>
<Name>Test.PDQv2.Supplier</Name>
<Host>127.0.0.1</Host>
<Port>48103</Port>
<SSLConfig></SSLConfig>
<StayConnected></StayConnected>
<OIDMapCode>
<OIDMapCodeItem OIDMapCodeKey="Device">Test.PDQv2SupplierDevice</OIDMapCodeItem>
<OIDMapCodeItem OIDMapCodeKey="ReceivingApplication">ISC-HealthShare</OIDMapCodeItem>
<OIDMapCodeItem OIDMapCodeKey="ReceivingFacility"></OIDMapCodeItem>
</OIDMapCode>
<DeviceFunction>PDQv2.Supplier</DeviceFunction>
</TCPService>
</Items>
}

XData AdditionalRegistryEntries
{
}

}
