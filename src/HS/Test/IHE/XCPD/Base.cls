Include HS.Test

Class HS.Test.IHE.XCPD.Base Extends HS.Test.IHE.Base [ Abstract ]
{

Parameter BaseClassItems = "HS.Test.IHE.XCPD.Base";

Parameter MPIManager = "HS.Generated.Test.MPI.Manager";

Parameter XCPDProcess = "HS.Generated.Test.IHE.XCPD.InitiatingGateway.Process";

Parameter XCPDConsumer = "HS.Generated.Test.IHE.XCPD.InitiatingGateway.Operations";

Method SetupMain()
{
	try {
		Set tSC=$$$OK
		$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.XCPD.RespondingGateway.Services",,1)=$$$OK,"Created XCPD RespondingGateway Service")
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method SetupLast()
{
	Try {
		Set tSC = ##super() Quit:$$$ISERR(tSC)
		Set tEP = ##class(HS.Registry.Service.SOAP).EndPointForNameType("Test.XCPD.RespondingGateway","SOAP")
		Do tEP.OIDMapCode.SetAt("Test.XCPDReceiverDevice","Device")
		Set tSC = tEP.%Save()
		Quit:'$$$AssertStatusOK(tSC,"Updated RespondingGateway end point")
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
  <Item Name="HS.Generated.Test.IHE.XCPD.RespondingGateway.Services" Category="" ClassName="HS.Generated.Test.IHE.XCPD.RespondingGateway.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="XCPDDiscoveryTarget">HS.Generated.Test.IHE.XCPD.RespondingGateway.Process</Setting>
    <Setting Target="Host" Name="RequireValidSAMLToken">0</Setting>
    <Setting Target="Host" Name="XMLValidator">HS.Util.XML.Validator</Setting>
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
    <Setting Target="Host" Name="SenderDevice">Test.XCPDSenderDevice</Setting>
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

XData AdditionalItems
{
}

XData OIDEntries
{
<Items>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.8.98</OID>
<IdentityCode>Test.XCPDSenderDevice</IdentityCode>
<IdentityTypes><OIDType><Description>Device</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.8.99</OID>
<IdentityCode>Test.XCPDReceiverDevice</IdentityCode>
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
<Name>Test.XCPD.RespondingGateway</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/{Namespace}/services/HS.Generated.Test.IHE.XCPD.RespondingGateway.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>

</Items>
}

XData AdditionalRegistryEntries
{
}

}
