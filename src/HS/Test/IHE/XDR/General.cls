Class HS.Test.IHE.XDR.General Extends HS.Test.IHE.XDSb.Base
{

Parameter BaseClassItems = "HS.Test.IHE.XDR.General";

Parameter XDRDocumentSource = "HS.Generated.Test.IHE.XDR.Source.Operations";

Method SetupMain()
{
	#define XData(%val,%node) Do ..getStream(%val,.%node) if %node]"" 
	try {
		Set tSC=$$$OK
		$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.XDR.Recipient.Services",,1)=$$$OK,"Created recipient service")
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method Test100Setup()
{
	///
	Set tSC = ..Setup()

	$$$HSTestAssertTrueOrBail(tSC,"Configured production "_tSC)
	//Do ##class(HS.Data.OIDMap).FileOID("ISC","AssigningAuthority","2.16.840.1.113883.3.86.3")
	// if there is no oid for this namespace, define it (the OID becomes the repository OID)
	//Do:##class(HS.Data.OIDMap).GetOIDForCode($namespace)="" ##class(HS.Data.OIDMap).FileOID($NAMESPACE,"Repository","2.16.840.1.113883.3.86.3.19998")
	$$$HSTestBailout
}

Method Test120SubmitDocument()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")

	Set tHighAuditID = ..FindHighAuditID()
	Do ..createDocument("XDR Document #1","",.tRequest,0)
	//Set tSC = ##class(HS.Util.XSLTTransformer).%New().TransformIntoObject(tSu.ContentStream, ..MetadataTransform /*"IHE/XDSb/Version1/Message-to-MetadataObject.xsl"*/,.tRequest,"","HS.Message.IHE.XDSb.Metadata","Metadata")
	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Document Submitted")
	Quit:'$$$AssertTrue(tResponse.ContentStream.Read()["ResponseStatusType:Success","Document added successfully")

	Do ..FindAuditRecords(tHighAuditID,1,"R","ITI-41",.tCount,"HS.IHE.XDSb.DocumentSource.Operations")
	If '$$$AssertTrue(tCount=1,"Document source PnR audit record")

	Do ..FindAuditRecords(tHighAuditID,0,"C","ITI-41",.tCount,"HS.HC.IHE.XDR.Recipient.CommonProcess")
	If '$$$AssertTrue(tCount=2,"Recipient PnR audit record")  /// two audit records because of the looping back with updated direct info

	Do ..FindAuditRecords(tHighAuditID,1,"R","ITI-41",.tCount,"HS.HC.IHE.XDR.Recipient.CommonProcess")
	If '$$$AssertTrue(tCount=2,"Recipient sending on to Custom PnR audit record")  /// two audit records because of the looping back with updated direct info
	
	//
}

XData Items
{
<Items>
  <Item Name="HS.Test.Service" Category="" ClassName="HS.Test.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.Generated.Test.IHE.XDSb.DocumentSource.Operations" Category="" ClassName="HS.IHE.XDSb.DocumentSource.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
    <Setting Target="Host" Name="XDSbRepositoryServiceName">Test.XDR.Recipient</Setting>
  </Item>

  <Item Name="HS.Generated.Test.IHE.XDR.Source.Operations" Category="" ClassName="HS.IHE.XDR.Source.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
    <Setting Target="Host" Name="ServiceName">Test.XDR.Recipient</Setting>
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>

  <Item Name="HS.Generated.Test.IHE.XDR.Recipient.Services" Category="" ClassName="HS.Generated.Test.IHE.XDR.Recipient.Services" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
    <Setting Target="Host" Name="ProvideAndRegisterTarget">HS.Generated.Test.IHE.XDR.Recipient.CommonProcess</Setting>
	<Setting Target="Host" Name="RequireValidSAMLToken">0</Setting>
  </Item>

  <Item Name="HS.Generated.Test.IHE.XDR.Recipient.CommonProcess" Category="" ClassName="HS.HC.IHE.XDR.Recipient.CommonProcess" PoolSize="2" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
    <Setting Target="Host" Name="TransactionType">2</Setting>
    <Setting Target="Host" Name="CustomProcessor">HS.Test.IHE.XDR.General</Setting>
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

XData RegistryEntries
{
<Items>
<!-- Registry / Repository -->
<WebService>
<Name>Test.XDR.Recipient</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/{Namespace}/services/HS.Generated.Test.IHE.XDR.Recipient.Services.cls</EndPoint>
<MTOM>1</MTOM>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>
</Items>
}

XData AdditionalOIDEntries
{
}

XData AdditionalRegistryEntries
{
}

ClassMethod OnPreCustom(pHost As Ens.Host, Output pStopProcessing As %Boolean, pRequest As HS.Message.IHE.XDSb.Metadata, pResponse As HS.Message.XMLMessage) As %Status
{
	/// if direct:FROM is set we already went through here, don't want to loop
	If pRequest.AdditionalInfo.GetAt("Direct:FROM")]"" Quit $$$OK
	/// Add a Direct:FROM and Direct:TO
	Do pRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Do pRequest.AdditionalInfo.SetAt("test@xdr.com","Direct:FROM")
	Do pRequest.AdditionalInfo.SetAt("test-recipient@xdr.com","Direct:TO")
	Set tSC = pHost.SendRequestSync(..#XDRDocumentSource,pRequest,.pResponse)
	Quit tSC
}

}
