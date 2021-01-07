Include HS.Test

Class HS.Test.IHE.PIX.Base Extends HS.Test.IHE.Base [ Abstract ]
{

Parameter BaseClassItems = "HS.Test.IHE.PIX.Base";

Parameter MPIManager = "HS.Generated.Test.MPI.Manager";

Parameter PIXv2Source = "HS.Generated.Test.IHE.PIXv2.Source.Operations";

Parameter PIXv2Consumer = "HS.Generated.Test.IHE.PIXv2.Consumer.Operations";

Parameter PIXv3Source = "HS.Generated.Test.IHE.PIXv3.Source.Operations";

Parameter PIXv3Consumer = "HS.Generated.Test.IHE.PIXv3.Consumer.Operations";

Method SetupMain()
{
	try {
		Set tSC=$$$OK
		$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.PIXv3.Manager.Services",,1)=$$$OK,"Created PIXv3 Manager Service")
		$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.PIXv3.Consumer.Services",,1)=$$$OK,"Created PIXv3 Consumer Service")

		For tConsumerID = "Test.PIXv2ConsumerDevice","Test.PIXv3ConsumerDevice" {
			Set tRS = ##class(%SQL.Statement).%ExecDirect(,"Delete from HS_IHE_PIX_Manager.DomainsOfInterest where consumerID=?",tConsumerID)
			Set tOBJ=##class(HS.IHE.PIX.Manager.DomainsOfInterest).%New()
			Set tOBJ.ConsumerID=tConsumerID  // oid entry for our pix consumer - to accept updates
			Do tOBJ.Domains.Clear()
			Set tSC=tOBJ.%Save()
		}
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method SetupLast()
{
	Try {
		Set tSC = ##super() Quit:$$$ISERR(tSC)
		/// update Test.PIXv3.Manager Endpoint with Device=Test.PIXv3ManagerDevice
		Set tEP = ##class(HS.Registry.Service.SOAP).EndPointForNameType("Test.PIXv3.Manager","SOAP")
		Do tEP.OIDMapCode.SetAt("Test.PIXv3ManagerDevice","Device")
		Set tSC = tEP.%Save()
		Quit:'$$$AssertStatusOK(tSC,"Updated Test.PIXv3.Manager end point")
		Set tEP = ##class(HS.Registry.Service.SOAP).EndPointForNameType("Test.PIXv3.Consumer","SOAP")
		Do tEP.OIDMapCode.SetAt("Test.PIXv3ConsumerDevice","Device")
		Set tSC = tEP.%Save()
		Quit:'$$$AssertStatusOK(tSC,"Updated Test.PIXv3.Consumer end point")
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
  <Item Name="HS.Generated.Test.IHE.PIXv3.Manager.Services" Category="" ClassName="HS.Generated.Test.IHE.PIXv3.Manager.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="PIXv3AddTarget">HS.Generated.Test.IHE.PIX.Manager.Process</Setting>
    <Setting Target="Host" Name="PIXv3MergeTarget">HS.Generated.Test.IHE.PIX.Manager.Process</Setting>
    <Setting Target="Host" Name="PIXv3QueryTarget">HS.Generated.Test.IHE.PIX.Manager.Process</Setting>
    <Setting Target="Host" Name="PIXv3ReviseTarget">HS.Generated.Test.IHE.PIX.Manager.Process</Setting>
	<Setting Target="Host" Name="RequireValidSAMLToken">0</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.PIX.Manager.Process" Category="" ClassName="HS.IHE.PIX.Manager.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="DeviceID">Test.PIXv3ManagerDevice</Setting>
    <Setting Target="Host" Name="MPIOperations">HS.Generated.Test.MPI.Manager</Setting>
    <Setting Target="Host" Name="PIXv2Operations">HS.Generated.Test.PIXv2.Notification.Operations</Setting>
    <Setting Target="Host" Name="PIXv3Operations">HS.Generated.Test.PIXv3.Notification.Operations</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.PIXv3.Source.Operations" Category="" ClassName="HS.IHE.PIXv3.Source.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Device">Test.PIXv3SourceDevice</Setting>
    <Setting Target="Host" Name="ServiceName">Test.PIXv3.Manager</Setting>
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="OperationToLocateMPIID">HS.Generated.Test.IHE.PIXv3.Consumer.Operations</Setting>
    <Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.PIXv3.Consumer.Operations" Category="" ClassName="HS.IHE.PIXv3.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="Device">Test.PIXv3ConsumerDevice</Setting>
    <Setting Target="Host" Name="ServiceName">Test.PIXv3.Manager</Setting>
    <Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.PIXv3.Consumer.Services" Category="" ClassName="HS.Generated.Test.IHE.PIXv3.Consumer.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="PIXv3ReviseTarget">HS.Generated.Test.IHE.PIX.Consumer.Process</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.PIX.Consumer.Process" Category="" ClassName="HS.IHE.PIX.Consumer.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="MPIOperations"></Setting>
    <Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.PIXv2.Consumer.Services" Category="" ClassName="HS.IHE.PIXv2.Consumer.Services" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Host" Name="TargetConfigNames">HS.Generated.Test.IHE.PIX.Consumer.Process</Setting>
    <Setting Target="Host" Name="AckMode">App</Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
    <Setting Target="Adapter" Name="JobPerConnection">1</Setting>
    <Setting Target="Adapter" Name="Port">48005</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.PIXv2.Manager.Services" Category="" ClassName="HS.IHE.PIXv2.Manager.Services" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Host" Name="TargetConfigNames">HS.Generated.Test.IHE.PIX.Manager.Process</Setting>
    <Setting Target="Host" Name="AckMode">App</Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
    <Setting Target="Adapter" Name="JobPerConnection">1</Setting>
    <Setting Target="Adapter" Name="Port">48001</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.PIXv2.Consumer.Operations" Category="" ClassName="HS.IHE.PIXv2.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ServiceName">Test.PIXv2.Manager</Setting>
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.PIXv2.Source.Operations" Category="" ClassName="HS.IHE.PIXv2.Source.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ServiceName">Test.PIXv2.Manager</Setting>
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>

<Item Name="HS.Generated.Test.MPI.Manager" Category="" ClassName="HS.HC.MPI.Manager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="TraceOperations">1</Setting>
<Setting Target="Host" Name="PIXManager">HS.Generated.Test.IHE.PIX.Manager.Process</Setting>
</Item>
<Item Name="HS.Generated.Test.PIXv2.Notification.Operations" Category="" ClassName="HS.Util.HL7Client.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="ServiceName">Test.PIXv2.Consumer</Setting>
</Item>
<Item Name="HS.Generated.Test.PIXv3.Notification.Operations" Category="" ClassName="HS.Util.SOAPClient.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="InactivityTimeout">0</Setting>
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
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.6.99</OID>
<IdentityCode>Test.PIXv2ManagerDevice</IdentityCode>
<IdentityTypes><OIDType><Description>Device</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.7.99</OID>
<IdentityCode>Test.PIXv2ConsumerDevice</IdentityCode>
<IdentityTypes><OIDType><Description>Device</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.10.99</OID>
<IdentityCode>Test.PIXv2SourceDevice</IdentityCode>
<IdentityTypes><OIDType><Description>Device</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>

<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.2.99</OID>
<IdentityCode>Test.PIXv3ConsumerDevice</IdentityCode>
<IdentityTypes><OIDType><Description>Device</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.5.99</OID>
<IdentityCode>Test.PIXv3SourceDevice</IdentityCode>
<IdentityTypes><OIDType><Description>Device</Description></OIDType></IdentityTypes>
<Description></Description>
</Item>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.3.11.99</OID>
<IdentityCode>Test.PIXv3ManagerDevice</IdentityCode>
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
<Name>Test.PIXv3.Manager</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/{Namespace}/services/HS.Generated.Test.IHE.PIXv3.Manager.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>
<WebService>
<OIDMapCode><OIDMapCodeItem OIDMapCodeKey="Device">Test.PIXv3ManagerDevice</OIDMapCodeItem></OIDMapCode>
<Name>Test.PIXv3.Consumer</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/{Namespace}/services/HS.Generated.Test.IHE.PIXv3.Consumer.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
<DeviceFunction>PIXv3.Consumer</DeviceFunction>
</WebService>

<TCPService>
<Name>Test.PIXv2.Manager</Name>
<Host>127.0.0.1</Host>
<Port>48001</Port>
<SSLConfig></SSLConfig>
<StayConnected></StayConnected>
<OIDMapCode>
<OIDMapCodeItem OIDMapCodeKey="Device">Test.PIXv2ManagerDevice</OIDMapCodeItem>
<OIDMapCodeItem OIDMapCodeKey="ReceivingApplication">ISC-HealthShare</OIDMapCodeItem>
<OIDMapCodeItem OIDMapCodeKey="ReceivingFacility">CGH</OIDMapCodeItem>
</OIDMapCode>
<DeviceFunction>PIXv2.Manager</DeviceFunction>
</TCPService>
<TCPService>
<Name>Test.PIXv2.Consumer</Name>
<Host>127.0.0.1</Host>
<Port>48005</Port>
<SSLConfig></SSLConfig>
<StayConnected></StayConnected>
<DeviceFunction>PIXv2.Consumer</DeviceFunction>
<OIDMapCode>
<OIDMapCodeItem OIDMapCodeKey="Device">Test.PIXv2ConsumerDevice</OIDMapCodeItem>
<OIDMapCodeItem OIDMapCodeKey="ReceivingApplication">ISC-HealthShare</OIDMapCodeItem>
<OIDMapCodeItem OIDMapCodeKey="ReceivingFacility"></OIDMapCodeItem>
</OIDMapCode>
</TCPService>
</Items>
}

XData AdditionalRegistryEntries
{
}

}
