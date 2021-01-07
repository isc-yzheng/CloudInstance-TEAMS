/// General test for XCPD (Cross Community Patient Discovery)
/// Add a patient, query
/// Query for non-existent patient
Class HS.Test.IHE.XCPD.General Extends HS.Test.IHE.XCPD.Base
{

Method SetupMain()
{
	Quit:'##super()
	$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.PDQv3.Supplier.Services",,1)=$$$OK,"Created PDQv3 Supplier Service")
	Quit $$$OK
}

Method Test100Setup()
{
	Set tSC=##class(HS.Util.Installer.Kit.Base).SetupFacility("EXTERNAL","EXTERNAL",1)
	$$$HSTestAssertTrueOrBail(##class(HS.Data.OIDMap).FileOID("EXTERNAL","AssigningAuthority","1.3.6.1.4.1.21367.2010.1.2.310","External System","Facility"),"Filed EXTERNAL facility")
	Set tSC = ..Setup()
	$$$HSTestAssertTrueOrBail(tSC,"Configured production "_tSC)
}

/// Add Patient with MPIID 7777777
Method Test120AddPatient1()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")

	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="John"
	Set tRequest.LastName="XCPDSmith"
	Set tRequest.Sex="M"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1975-09-22")
	Set tRequest.MRN="XCPD7777777"
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"
	Set tAddress=##class(HS.Types.Address).%New()
	Do tRequest.Addresses.Insert(tAddress)
	Set tAddress.City="XCPDVille"
	Set tAddress.StreetLine="123 XCPD Street"
	Set tAddress.PostalCode="XCPD"

	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient:"_tResponse.MPIID)
	Quit:'$$$AssertTrue(tResponse.ErrStatus=""||(tResponse.ErrStatus=$$$OK),"Patient added without error")
	
	Set tHighAuditID = ..FindHighAuditID()
	Set tSearchRequest=##class(HS.Message.PatientSearchRequest).%New()
	Set tSearchRequest.MPIID=tResponse.MPIID
	Do tSearchRequest.AdditionalInfo.SetAt(..#XCPDProcess,"Host")
	Do tSearchRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tSearchRequest,.tSearchResponse)
	Quit:'$$$AssertStatusOK(tSC,"Sent search request")
	Quit:'$$$AssertTrue(tSearchResponse.Patients.Count()=1,"Patient Count is 1:"_tSearchResponse.Patients.Count())
	Set tPatient = tSearchResponse.Patients.GetAt(1)
	Quit:'$$$AssertTrue(tPatient.Extension = tResponse.MPIID,"Patient MPIID matches")
	Do ..FindAuditRecords(tHighAuditID,1,"E","ITI-55",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 source record for XCPD:"_tCount) break
	Do ..FindAuditRecords(tHighAuditID,0,"E","ITI-55",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 server record for XCPD:"_tCount) break
}

Method Test140SearchNotOnFilePatient()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")

	Set tSearchRequest=##class(HS.Message.PatientSearchRequest).%New()
	Set tSearchRequest.MPIID=1
	Do tSearchRequest.AdditionalInfo.SetAt(..#XCPDProcess,"Host")
	Do tSearchRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tSearchRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Sent search request")
	Quit:'$$$AssertTrue('$IsObject(tResponse.Patients) || (tResponse.Patients.Count()=0),"0 Patient Count")
}

Method Test150()
{
	$$$HSTestBailout

	Set tHighAuditID = ..FindHighAuditID()
	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="Test150"
	Set tRequest.LastName="XCPD"
	Set tRequest.Sex="M"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1978-5-25")
	Set tRequest.MRN="XCPD-150"
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"
	Set tAddress=##class(HS.Types.Address).%New()
	Do tRequest.Addresses.Insert(tAddress)
	Set tAddress.City="XCPDVille"
	Set tAddress.StreetLine="150 1st XCPD Street"
	Set tAddress.PostalCode="XCPDP1"
	Set tName = ##class(HS.Types.PersonName).%New()
	Set tName.Prefix="Mr"
	Set tName.Given="Jimmy"
	Set tName.Middle="Middle"
	Set tName.Family="XCPD"
	Set tName.Suffix="III"
	Set tName.Type="Alias"
	Do tRequest.Names.Insert(tName)
	Set tName = ##class(HS.Types.PersonName).%New()
	Set tName.Prefix="Mr"
	Set tName.Given="Johnny"
	Set tName.Middle="Middle"
	Set tName.Family="XCPD"
	Set tName.Suffix="III"
	Set tName.Type="Alias"
	Do tRequest.Names.Insert(tName)
	Set tName = ##class(HS.Types.PersonName).%New()
	Set tName.Prefix="Mr"
	Set tName.Given="Test150"
	Set tName.Middle="Middle"
	Set tName.Family="Smith-XCPD"
	Set tName.Suffix=""
	Set tName.Type="Birth"
	Do tRequest.Names.Insert(tName)
	Set tName = ##class(HS.Types.PersonName).%New()
	Set tName.Prefix="Mrs"
	Set tName.Given="Mary"
	Set tName.Middle="no-Middle"
	Set tName.Family="Jones-XCPD"
	Set tName.Suffix=""
	Set tRequest.MothersName=tName
	Set tName = ##class(HS.Types.PersonName).%New()
	Set tName.Prefix="Mr"
	Set tName.Given="John"
	Set tName.Middle="no-Middle"
	Set tName.Family="Smith-XCPD"
	Set tName.Suffix=""
	Set tRequest.FathersName=tName
	Set tRequest.MothersMaidenSurname="Jones-XCPD"
	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient:"_tResponse.MPIID)
	Do ..Manager.UserFields.SetAt(tResponse.MPIID,"MPIID")
	Quit:'$$$AssertTrue(tResponse.ErrStatus=""||(tResponse.ErrStatus=$$$OK),"Patient added without error")

	Set tSearchRequest=##class(HS.Message.PatientSearchRequest).%New()
	Do tSearchRequest.CopyFrom(tRequest,tSearchRequest)
	Set tSearchRequest.MPIID=tResponse.MPIID
	Do tSearchRequest.AdditionalInfo.SetAt(..#XCPDProcess,"Host")
	Do tSearchRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tSearchRequest,.tSearchResponse)
	Quit:'$$$AssertStatusOK(tSC,"Search Patient OK")
	Quit:'$$$AssertTrue(1=tSearchResponse.Patients.Count(),"Found one patient for the search")
}

Method Test160()
{
	#define XData(%val,%node) Do ..getStream(%val,.%node) if %node]"" 
	$$$XData("UpdateToPDQ",node) Set tSC= ##class(HS.Util.Installer.Kit.Base).ProductionMods($namespace,node,1)
	Quit:'$$$AssertStatusOK(tSC,"Production Modifications UpdateToPDQ "_node)
	Do ##class(Ens.Director).UpdateProduction()

	Set tSearchRequest=##class(HS.Message.PatientSearchRequest).%New()
	//Set tSearchRequest.AssigningAuthority="EXTERNAL"
	//Set tSearchRequest.FirstName="Test150"
	//Set tSearchRequest.LastName="XCPD"
	//Set tSearchRequest.Sex="M"
	//Set tSearchRequest.DOB=tSearchRequest.DOBDisplayToLogical("1978-5-25")
	Set tSearchRequest.MPIID=..Manager.UserFields.GetAt("MPIID")
	//Set tSearchRequest.AssigningAuthority="EXTERNAL"
	//Set tSearchRequest.Facility="EXTERNAL"
	//Set tAddress=##class(HS.Types.Address).%New()
	//Do tSearchRequest.Addresses.Insert(tAddress)
	//Set tAddress.City="XCPDVille"
	//Set tAddress.StreetLine="150 1st XCPD Street"
	//Set tAddress.PostalCode="XCPDP1"
	Do tSearchRequest.AdditionalInfo.SetAt(..#XCPDProcess,"Host")
	Do tSearchRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tSearchRequest,.tSearchResponse)
	Quit:'$$$AssertStatusOK(tSC,"Search Patient OK")
	Quit:'$$$AssertTrue(1=tSearchResponse.Patients.Count(),"Found one patient for the search")
}

/*

    <!--
    <Setting Target="Host" Name="PDQv3Supplier">HS.Generated.Test.MPI.Manager</Setting>
    -->


*/
XData UpdateToPDQ
{
<Items>
  <Item Name="HS.Generated.Test.IHE.XCPD.RespondingGateway.Process" Category="" ClassName="HS.IHE.XCPD.RespondingGateway.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="PDQv3Supplier">HS.Generated.Test.IHE.PDQv3.Consumer.Operations</Setting>
</Item>
</Items>
}

XData AdditionalItems
{
<Items>
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
</Items>
}

XData AdditionalOIDEntries
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

XData AdditionalRegistryEntries
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

</Items>
}

}
