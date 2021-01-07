Include (HS.Test, HS.IHE.XDSb)

Class HS.Test.IHE.XDSb.Base Extends HS.Test.IHE.Base [ Abstract ]
{

Parameter BaseClassItems = "HS.Test.IHE.XDSb.Base";

Parameter MPIManager = "HS.Generated.Test.MPI.Manager";

Parameter Repository = "HS.Generated.Test.IHE.XDSb.Repository.Services";

Parameter Registry = "HS.Generated.Test.IHE.XDSb.Registry.Services";

Parameter DocumentSource = "HS.Generated.Test.IHE.XDSb.DocumentSource.Operations";

Parameter DocumentConsumer = "HS.Generated.Test.IHE.XDSb.Consumer.Operations";

Parameter Administrator = "HS.Generated.Test.IHE.XDSb.Administrator.Operations";

Method SetupMain()
{
	#define XData(%val,%node) Do ..getStream(%val,.%node) if %node]"" 
	try {
		Set tSC=$$$OK
		Do ##class(HS.Util.Installer.Kit.PostInstall.XDSbCodes).RunHub()
		Do ##class(HS.Util.Installer.Kit.PostInstall.Demo.OIDEntries).RunHub()
		$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.XDSb.Registry.Services",,1)=$$$OK,"Created registry service")
		$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.XDSb.Repository.Services",,1)=$$$OK,"Created repository service")
		// if there is no oid for this namespace, define it (the OID becomes the repository OID)
		Do:##class(HS.Data.OIDMap).GetOIDForCode($namespace)="" ##class(HS.Data.OIDMap).FileOID($NAMESPACE,"Repository","2.16.840.1.113883.3.86.3.19998")
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method XDSReset(pForce = 0)
{
	If +..Manager.UserFields.GetAt("ResetData") || pForce {
		/// For some tests the test will fail if too many results (ie test package has been run too many times)
		For tType = "Slot","Association","Classification","RegistryPackage","ExternalIdentifier" Do $zobjclassMethod("HS.Registry.Document."_tType,"%KillExtent")
		Do ##class(HS.Registry.Document).%KillExtent()
	}
}

/// For creation time from / to get an offset window
ClassMethod OffsetTime(time, offsetseconds) As %String
{
	Set tNewSeconds = $zdth($E(time,1,8),8)*86400+$zth($E(time,9,10)_":"_$E(time,11,12)_":"_$e(time,13,14))+offsetseconds
	Quit $tr($zdt(((tNewSeconds\86400)_","_(tNewSeconds#86400)),8),": ")
}

ClassMethod DynamicCode(pCodeType, Output pCode, Output pScheme, Output pDescription) As %Status
{
	#define DynamicCodes ^||HS.Test.DynamicCodes
	If '$D($$$DynamicCodes) {
		Set tRS=##class(%SQL.Statement).%ExecDirect(,"select CodeType,Code,CodingScheme,Description from HS_IHE.CodedEntry ")
		While tRS.%Next() {
			Set $$$DynamicCodes($zcvt(tRS.CodeType,"l"),$i($$$DynamicCodes($zcvt(tRS.CodeType,"l"))))=$lb(tRS.Code,tRS.CodingScheme,tRS.Description)
		}
	}
	Set tItem = $$$DynamicCodes($zcvt(pCodeType,"l"),$R($$$DynamicCodes($zcvt(pCodeType,"l")))+1)
	Set pCode=$li(tItem,1),pScheme=$li(tItem,2),pDescription=$li(tItem,3)
	Quit $$$OK
}

Method createDocument(pDocNum, pID = "", Output pSubmission, pSubmit = 1, pSourcePatientID = {"A7777777^^^&"_##class(HS.Data.OIDMap).GetOIDForCode("EXTERNAL")_"&ISO"}) As %Status
{
	// if we don't complete don't mark to continue
	Do ..Manager.UserFields.SetAt(0,"Continue")
	#define DynamicCode(%object,%field,%multiple) Do ..DynamicCode(##quote(%field),.tCode,.tScheme,.tDescription) If tCode]"" { if '%multiple{Set %object.%field=##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription)} else {Do %object.%field.Insert(##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription))}}
	Set tRegisterOnly = +..Manager.UserFields.GetAt("RegisterOnly")
	If $IsObject($g(pSubmission)) {
		Set tRequest=pSubmission
	} Else {
		If tRegisterOnly {
			Set tRequest=##class(HS.Message.IHE.XDSb.RegisterRequest).%New()
		} Else {
			Set tRequest=##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
		}	
		Set pSubmission=tRequest
	}
	#; don't assign the patient id let the system look it up from the cda
	Set tID=$S(pID]"":pID,1:100000000+$R(99999999)+1)
	Set tRequest.PatientId=tID_"^^^&"_$$$AffinityDomainOID_"&ISO"
	Set tRequest.SourceId="1.3.6.1.4.1.21367.1"
	$$$DynamicCode(tRequest,ContentTypeCode,0)
	Set tDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
	Do tRequest.Documents.Insert(tDocument)
	Set tDocument.LanguageCode="en-US"
	Do tDocument.BodyCharacter.Write("Document #"_pDocNum)
	If tRegisterOnly {
		Set tDocument.RepositoryUniqueId=##class(HS.Data.OIDMap).GetOIDForCode($namespace)
		Set tDocument.Size=tDocument.BodyCharacter.Size
		Set tDocument.Hash=##class(HS.IHE.XDSb.Util).StreamHash(tDocument.BodyCharacter)
	}
	Set tDocument.CreationTime=$TR($zdt($h,8),": ")
 	$$$DynamicCode(tDocument,ConfidentialityCode,1)
	Set tDocument.SourcePatientId=pSourcePatientID
	$$$DynamicCode(tDocument,ClassCode,0)
	$$$DynamicCode(tDocument,FormatCode,0)
	Set tDocument.MimeType="text/xml"
	$$$DynamicCode(tDocument,HealthcareFacilityTypeCode,0)
	$$$DynamicCode(tDocument,PracticeSettingCode,0)
	$$$DynamicCode(tDocument,TypeCode,0)
	$$$DynamicCode(tDocument,EventCodeList,1)
	If 0 {
		set tAuthor = ##class(HS.Types.IHE.XDSb.Author).%New()
		Set tAuthor.EntryUUID="MyAuthor"
	    set tAuthor.AuthorPerson = "^Welby^Marcus^^MD^Dr"
	    Set tAuthor.AuthorInstitution="Some Hospital^^^^^^^^^1.2.3.5.8.9.1789.45"
	    Do tAuthor.AuthorSpecialty.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("Specialty"))
		Do tDocument.Author.Insert(tAuthor)
		Do tRequest.Author.Insert(tAuthor)
	}

	Set tDocument.UniqueId=tDocument.UniqueId_"^TESTEXTENSIONVALUE"
	If pSubmit {
		#; send request to test service
		Do tRequest.AdditionalInfo.SetAt(..#DocumentSource,"Host")
		Set tAsync = +..Manager.UserFields.GetAt("ASYNC")
		If tAsync {
			Set tSC = ##class(HS.Test.Service).SendAsync(tRequest)
		} Else {
			Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
		}	
		Quit:'$$$AssertStatusOK(tSC,"Added Document for Patient "_tRequest.PatientId) tSC
	
		If 'tAsync Quit:'$$$AssertTrue(tResponse.ContentStream.Read()["ResponseStatusType:Success","Document added successfully") $$$OK
		/// successfully completed mark to continue
	}
	Do ..Manager.UserFields.SetAt(1,"Continue")
	Quit $$$OK
}

XData Items
{
<Items>
  <Item Name="HS.Test.Service" Category="" ClassName="HS.Test.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>

  <Item Name="HS.Generated.Test.IHE.XDSb.Registry.Services" Category="" ClassName="HS.Generated.Test.IHE.XDSb.Registry.Services" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
    <Setting Target="Host" Name="XDSbQueryTarget">HS.Generated.Test.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="XDSbRegisterTarget">HS.Generated.Test.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="XDSbRegisterOnDemandTarget">HS.Generated.Test.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="XDSbUpdateDocumentSetTarget">HS.Generated.Test.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="XDSbDeleteDocumentSetTarget">HS.Generated.Test.IHE.XDSb.Registry.Operations</Setting>
	<Setting Target="Host" Name="RequireValidSAMLToken">1</Setting>
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
    <Setting Target="Host" Name="XDSbRegistryServiceName">Test.XDSb.Registry</Setting>
    <Setting Target="Host" Name="XDSbRepositoryServiceName">Test.XDSb.Repository</Setting>
    <Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>

  <Item Name="HS.Generated.Test.IHE.XDSb.Repository.Services" Category="" ClassName="HS.Generated.Test.IHE.XDSb.Repository.Services" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
    <Setting Target="Host" Name="XDSbProvideAndRegisterTarget">HS.Generated.Test.IHE.XDSb.Repository.Process</Setting>
    <Setting Target="Host" Name="XDSbRetrieveTarget">HS.Generated.Test.IHE.XDSb.Repository.Process</Setting>
    <Setting Target="Host" Name="RequireValidSAMLToken">1</Setting>
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
  
  <Item Name="HS.Generated.Test.IHE.XDSb.Administrator.Operations" Category="" ClassName="HS.IHE.XDSb.Administrator.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="XDSbRegistryServiceName">Test.XDSb.Registry</Setting>
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
<Item><OID>1.3.6.1.4.1.21367.2010.1.2.300.100</OID><IdentityCode>HSREGISTRY</IdentityCode><IdentityTypes><OIDType><Description>Repository</Description></OIDType></IdentityTypes></Item>
</Items>
}

XData AdditionalOIDEntries
{
}

XData RegistryEntries
{
<Items>
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
