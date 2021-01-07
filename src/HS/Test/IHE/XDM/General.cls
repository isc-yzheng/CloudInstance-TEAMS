Class HS.Test.IHE.XDM.General Extends HS.Test.IHE.XDSb.Base
{

Parameter BaseClassItems = "HS.Test.IHE.XDM.General";

Parameter XDMCreator = "HS.Generated.Test.IHE.XDM.PortableMediaCreator.Process";

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
	If (##class(HS.Registry.Config).GetKeyValue("\ZipUtility\ZipCommand")="") || (##class(HS.Registry.Config).GetKeyValue("\ZipUtility\UnZipCommand")="") {
		If $zv["UNIX" {
			D ##class(HS.Registry.Config).AddUpdateKeyValue("\ZipUtility\ZipCommand","zip -rm %1 .")
			D ##class(HS.Registry.Config).AddUpdateKeyValue("\ZipUtility\UnZipCommand","unzip %1 -d .")
		}			
	}
	Do ..SetupDirectories()
	$$$HSTestBailout
	Set tSC = ..Setup()
	Set tFacility = ##class(HS.Facility.Config).%OpenId("IHEFACILITY")
	If 'tFacility {
		Set tFacility = ##class(HS.Facility.Config).%New()
		Set tFacility.FacilityCode="IHEFACILITY"
		Set tFacility.Name="IHEFACILITY"
		Set tSC = tFacility.%Save()
		Quit:$$$ISERR(tSC)
		Do ##class(HS.Data.OIDMap).FileOID("IHEFACILITY","Facility","1.3.6.1.4.1.21367.3000.1.6",,"AssigningAuthority")
	}
	$$$HSTestBailout
	$$$HSTestAssertTrueOrBail(tSC,"Configured production "_tSC)
	//Do ##class(HS.Data.OIDMap).FileOID("ISC","AssigningAuthority","2.16.840.1.113883.3.86.3")
	// if there is no oid for this namespace, define it (the OID becomes the repository OID)
	//Do:##class(HS.Data.OIDMap).GetOIDForCode($namespace)="" ##class(HS.Data.OIDMap).FileOID($NAMESPACE,"Repository","2.16.840.1.113883.3.86.3.19998")
	$$$HSTestBailout
}

Method SetupDirectories(pXDMIN, pXDMOUT, pXDMZIP)
{
	#define ND(%nd) ##class(%File).NormalizeDirectory(%nd)
	Set pXDMIN = $$$ND($zu(12)_"Temp/XDM-IN/")
	Set pXDMOUT = $$$ND($zu(12)_"Temp/XDM-OUT/")
	Set pXDMZIP = $$$ND($zu(12)_"Temp/XDM-ZIP/")
	If '##class(%File).DirectoryExists(pXDMIN) $$$HSTestAssertTrueOrBail(##class(%File).CreateDirectoryChain(pXDMIN) = $$$OK,"Created XDM-IN directory")
	If '##class(%File).DirectoryExists(pXDMOUT) $$$HSTestAssertTrueOrBail(##class(%File).CreateDirectoryChain(pXDMOUT) = $$$OK,"Created XDM-OUT directory")	
	If '##class(%File).DirectoryExists(pXDMZIP) $$$HSTestAssertTrueOrBail(##class(%File).CreateDirectoryChain(pXDMZIP) = $$$OK,"Created XDM-ZIP directory")	
	Quit
}

/// Create a HS.Message.IHE.XDM.DistributeDocumentSetOnMedia (documents & submission set)
/// submit to be output to directory
/// configure to zip
/// submit to be output to zip
/// take zip file and process, comparing output to original input
/// take output directory and process, comparing output to original input
Method Test120SubmitDocument()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Do ..SetupDirectories(.tXDMIN,.tXDMOUT,.tXDMZIP)

	/// cleanup output directory
	Set tSC = ..CleanupOutputDirectory(tXDMOUT)
	
	/// build DistributeDocumentSetRequest with Xdata:XDLABDoc and submit to produce output in tXDMOUT directory
	set tRequest = ##class(HS.Message.IHE.XDM.DistributeDocumentSetRequest).%New()
	Set tRequest.FilePath=tXDMOUT

	set tSubSet = ##class(HS.Message.IHE.XDSb.Metadata).%New()
		
	set tDocument = ##class(HS.Types.IHE.XDSb.Document).%New()
	Set tSC = ##class(HS.Util.XMLUtils).GetXDataAsStreamWithSubstitutions("xdata://"_..%ClassName(1)_":XDLABDoc",.tStream)
	set tSC = tDocument.BodyCharacter.CopyFrom(tStream) 
	Quit:'$$$AssertStatusOK(tSC,"Copied Document")
	set tDocument.URI = "XDLAB_OTHER_INTERSYS_HEALTHSHARE.xml"
	Do tDocument.Names.Insert(##class(HS.Types.IHE.XDSb.ValueType).%New( tDocument.URI))

	Set tSubmission = ##class(HS.Types.IHE.XDSb.Submission).%New()
	Set tSubmission.ContentTypeCode=##class(HS.Types.IHE.XDSb.SerialClassification).%New("34133-9","LOINC","Summarization of Episode Note")	
	Set tDocument.MimeType="text/xml"
	Set tDocument.ClassCode = ##class(HS.Types.IHE.XDSb.SerialClassification).%New("DEMO-Consult","1.3.6.1.4.1.21367.100.1","Consultation")			
	Set tDocument.FormatCode=##class(HS.Types.IHE.XDSb.SerialClassification).%New("urn:ihe:lab:xd-lab:2008","1.3.6.1.4.1.19376.1.2.3","urn:ihe:lab:xd-lab:2008")
	Do tDocument.Descriptions.Insert(##class(HS.Types.IHE.XDSb.ValueType).%New("PlaceHolder Description"))
	Set tDocument.PracticeSettingCode = ##class(HS.Types.IHE.XDSb.SerialClassification).%New("Anesthesia","Connect-a-thon practiceSettingCodes", "Anesthesia")
	Set tDocument.Size = tStream.Size
	Set tDocument.HealthCareFacilityTypeCode = ##class(HS.Types.IHE.XDSb.SerialClassification).%New("ACC","2.16.840.1.113883.5.11", "Accident Site")
	set tSC = tSubSet.Documents.Insert(tDocument)
	Do tSubSet.Submissions.Insert(tSubmission)
		
	Set tSubSet.Name = "Placeholder SubSetName"
		
	do tRequest.Submissions.Insert(tSubSet)
	Do tRequest.AdditionalInfo.SetAt(..#XDMCreator,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")

	Set tHighAuditID = ..FindHighAuditID()
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Document Submitted")

	Do ..FindAuditRecords(tHighAuditID,1,"R","ITI-32",.tCount,"HS.IHE.XDM.PortableMediaCreator.Process")
	If '$$$AssertTrue(tCount=1,"XDM creator audit record") 

	/// Ensure files were built correctly
	Set tRS=##class(%ResultSet).%New("%File:FileSet")
	For tFiles=$lb("INDEX.HTM"),$lb("README.TXT"),$lb("METADATA.XML","IHE_XDM/SUBSET01"),$lb("XDLAB_~1.XML","IHE_XDM/SUBSET01",tDocument.BodyCharacter.Size) {
		Set tSubDir=$lg(tFiles,2)
		Set tDir = ##class(%File).NormalizeDirectory(tXDMOUT_tSubDir)
		Do tRS.Execute(tDir,$lg(tFiles))
		Quit:'$$$AssertTrue(tRS.%Next(),"Have "_$lg(tFiles))
		If $lg(tFiles,3)]"" {
			If '$$$AssertTrue(tRS.%Get("Size")=$lg(tFiles,3),"File size matches: "_$lg(tFiles,3))
		}
	}	

	/// Update production to configure for Zip and re-send transaction
	Set tSC= ##class(HS.Util.Installer.Kit.Base).ProductionMods($namespace,"xdata://"_..%ClassName(1)_":XDataConfigureZip",1)
	Quit:'$$$AssertStatusOK(tSC,"Modifying production ConfigureZip")
	Set tSC= ##class(Ens.Director).UpdateProduction() Quit:$$$ISERR(tSC)
	Quit:'$$$AssertStatusOK(tSC,"Updating production ConfigureZip")

	/// because we have configured the inbound directory, we expect that the request will be processed by HS.IHE.XDM.PortableMediaImporter.Services
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Document Submitted")
	/// Ensure the zip file is created
	Do tRS.%Execute(tXDMOUT,"XDM_*.zip")
	Quit:'$$$AssertTrue(tRS.%Next(),"Have zip files:"_tRS.%Get("Name"))

	Set tHighAuditID = ..FindHighAuditID()

	/// Copy the XDM zip file to the XDMIN directory for processing
	Set tSC = ##class(%File).CopyFile(tRS.%Get("Name"),tXDMIN)
	Set tName = ##class(%File).GetFilename(tRS.%Get("Name"))
	For  {
		Do tRS.%Execute(tXDMIN,tName)
		Quit:tRS.%Next()
	}
	For tIdx=1:1:3 {
		Hang 4
		Do ..FindAuditRecords(tHighAuditID,0,"C","ITI-41",.tCount,"HS.HC.IHE.XDR.Recipient.CommonProcess")
		Quit:tCount
	}
	If '$$$AssertTrue(tCount=1,"Document XDR PnR audit record (document consumed from zip)")
}

ClassMethod CleanupOutputDirectory(pDir) As %Status
{
	Set tRS=##class(%ResultSet).%New("%File:FileSet")
	Do tRS.%Execute(pDir,"*","",1)
	While tRS.%Next() {
		If tRS.%Get("Type")="D" {
			Quit:$$$ISERR(..CleanupOutputDirectory(tRS.%Get("Name")))
			Do ##class(%File).RemoveDirectory(tRS.%Get("Name"))
			Continue
		}
		Set tSC=##class(%File).Delete(tRS.%Get("Name"))
		Quit:$$$ISERR(tSC)
	}
	Quit $$$OK
}

XData XDataConfigureZip
{
<Items>
  <Item Name="HS.Generated.Test.IHE.XDM.PortableMediaCreator.Process" Category="" ClassName="HS.IHE.XDM.PortableMediaCreator.Process" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ZipOperation">HS.Generated.Test.Util.Zip.Operations</Setting>
  </Item>
</Items>
}

XData Items
{
<Items>
  <Item Name="HS.Test.Service" Category="" ClassName="HS.Test.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.Generated.Test.MPI.Manager" Category="" ClassName="HS.HC.MPI.Manager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.Generated.Test.IHE.XDM.PortableMediaCreator.Process" Category="" ClassName="HS.IHE.XDM.PortableMediaCreator.Process" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
	<Setting Target="Host" Name="PIXv3ConsumerOperations">HS.Generated.Test.MPI.Manager</Setting>
    <Setting Target="Host" Name="PostCreationOperation">HS.Generated.Test.IHE.XDM.FileOutputOperation</Setting>
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.XDM.FileOutputOperation" Category="" ClassName="HS.IHE.XDM.FileOutputOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
	<Setting Target="Adapter" Name="FilePath">{$expression{##class(%File).NormalizeDirectory($zu(12)_"Temp/XDM-OUT/")}}</Setting>
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.XDM.PortableMediaImporter.Services" Category="" ClassName="HS.IHE.XDM.PortableMediaImporter.Services" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">{$expression{##class(%File).NormalizeDirectory($zu(12)_"Temp/XDM-IN/")}}</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.zip</Setting>
    <Setting Target="Host" Name="ImporterProcess">HS.Generated.Test.IHE.XDM.PortableMediaImporter.Process</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.XDM.PortableMediaImporter.Process" Category="" ClassName="HS.IHE.XDM.PortableMediaImporter.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
	<Setting Target="Host" Name="ZIPTarget">HS.Generated.Test.Util.Zip.Operations</Setting>
    <Setting Target="Host" Name="ProcessTarget">HS.Generated.Test.IHE.XDR.Recipient.CommonProcess</Setting>
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
  <Item Name="HS.Generated.Test.Util.Zip.Operations" Category="" ClassName="HS.Util.Zip.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.XDR.Recipient.Services" Category="" ClassName="HS.Generated.Test.IHE.XDR.Recipient.Services" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
    <Setting Target="Host" Name="ProvideAndRegisterTarget">HS.Generated.Test.IHE.XDR.Recipient.CommonProcess</Setting>
	<Setting Target="Host" Name="RequireValidSAMLToken">0</Setting>
  </Item>
  <Item Name="HS.Generated.Test.IHE.XDR.Recipient.CommonProcess" Category="" ClassName="HS.HC.IHE.XDR.Recipient.CommonProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TransactionType">2</Setting>
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
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

XData XDLABDoc
{
<?xml version="1.0" encoding="UTF-8"?>
<ClinicalDocument xmlns="urn:hl7-org:v3">
<realmCode code="US"/>
<typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040"/>
<templateId root="2.16.840.1.113883.3.27.1776"/>
<templateId root="2.16.840.1.113883.10.20.10"/>
<templateId root="2.16.840.1.113883.10.20.20"/>
<templateId root="2.16.840.1.113883.10.20.30"/>
<templateId root="1.3.6.1.4.1.19376.1.3.3"/>
<id root="9c2ec000-7d44-11e3-a3ed-bcc890787600"/>
<code code="11502-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="LABORATORY REPORT.TOTAL"/>
<title>Lab Report Document</title>
<effectiveTime value="20140114125218-0500"/>
<confidentialityCode nullFlavor="NI"/>
<languageCode code="en-US"/>
<setId root="9C30B4B4-7D44-11E3-A3ED-BCC890787600"/>
<versionNumber value="1"/>
<recordTarget>
<patientRole>
<id root="1.3.6.1.4.1.21367.3000.1.6" extension="9301995" assigningAuthorityName="IHE Facility"/>
<addr use="HP">
<streetAddressLine>9347 113th Street</streetAddressLine>
<streetAddressLine>Apartment 32489</streetAddressLine>
<city>NY</city>
<state>NY</state>
<postalCode>10017</postalCode>
<country>USA</country>
<useablePeriod xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_TS">
<low value="20000201000000"/>
<high value="20170530120000"/>
</useablePeriod>
</addr>
<telecom use="HP" value="tel:212-493-9323"/>
<telecom use="WP" value="tel:212-491-1121"/>
<telecom use="MC" value="tel:520-570-3934"/>
<telecom value="mailto:XDLAB@worldmail.com"/>
<patient>
<name use="L">
<family>OTHER_INTERSYS_HEALTHSHARE</family>
<given>XDLAB</given>
</name>
<administrativeGenderCode code="M" codeSystem="2.16.840.1.113883.5.1" codeSystemName="AdministrativeGenderCode" displayName="Male"/>
<birthTime value="19670303003700"/>
<maritalStatusCode code="S" codeSystem="2.16.840.1.113883.5.2" codeSystemName="MaritalStatus" displayName="Single"/>
<religiousAffiliationCode code="PRE" codeSystem="2.16.840.1.113883.5.1076" codeSystemName="ReligiousAffiliation" displayName="Christian: Presbyterian"/>
<raceCode code="2106-3" codeSystem="2.16.840.1.113883.6.238" codeSystemName="Race &amp; Ethnicity - CDC" displayName="White"/>
<languageCommunication>
<templateId root="2.16.840.1.113883.3.88.11.83.2"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.2.1"/>
<languageCode code="ENG"/>
<preferenceInd value="true"/>
</languageCommunication>
<languageCommunication>
<templateId root="2.16.840.1.113883.3.88.11.83.2"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.2.1"/>
<languageCode code="RUS"/>
<preferenceInd value="false"/>
</languageCommunication>
</patient>
</patientRole>
</recordTarget>
<author typeCode="AUT">
<time value="20140114125218-0500"/>
<assignedAuthor classCode="ASSIGNED">
<id nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name nullFlavor="UNK"/>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</representedOrganization>
</assignedAuthor>
</author>
<author typeCode="AUT">
<time value="20140114125218-0500"/>
<assignedAuthor classCode="ASSIGNED">
<id root="2.16.840.1.113883.3.86.3"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedAuthoringDevice>
<softwareName>InterSystems HealthShare</softwareName>
</assignedAuthoringDevice>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</representedOrganization>
</assignedAuthor>
</author>
<informant>
<assignedEntity>
<id root="2.16.840.1.113883.3.86.3.1" extension="HomeCommunity"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
<telecom use="WP" value="tel:(617) 621-0600"/>
<assignedPerson>
<name use="L">Home Community</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>1.3.6.1.4.1.21367.2010.1.2.300</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
</assignedEntity>
</informant>
<custodian>
<assignedCustodian>
<representedCustodianOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>1.3.6.1.4.1.21367.2010.1.2.300</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</representedCustodianOrganization>
</assignedCustodian>
</custodian>
<legalAuthenticator>
<time value="20140114125218-0500"/>
<signatureCode code="S"/>
<assignedEntity>
<id nullFlavor="UNK"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
<telecom use="WP" value="tel:(617) 621-0600"/>
<assignedPerson>
<name use="L">
<family>InterSystems</family>
<given>HealthShare</given>
</name>
</assignedPerson>
<representedOrganization>
<id nullFlavor="UNK"/>
<name nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
</representedOrganization>
</assignedEntity>
</legalAuthenticator>
<participant typeCode="IND">
<templateId root="2.16.840.1.113883.3.88.11.83.3"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.2.4"/>
<time nullFlavor="UNK"/>
<associatedEntity classCode="NOK">
<id nullFlavor="UNK"/>
<code code="FRND" codeSystem="2.16.840.1.113883.5.111" codeSystemName="RoleCode" displayName="Friend">
<originalText>Friend</originalText>
</code>
<addr use="WP">
<streetAddressLine>232 Lambert Lane</streetAddressLine>
<city>PATERSON</city>
<state>NJ</state>
<postalCode>66024</postalCode>
<country>USA</country>
<useablePeriod xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_TS">
<low value="19600101000000"/>
<high value="20201209120000"/>
</useablePeriod>
</addr>
<telecom use="HP" value="tel:785-232-1111"/>
<telecom use="WP" value="tel:785-232-3234"/>
<telecom use="MC" value="tel:785-232-5454"/>
<telecom value="mailto:jasonb@unknown.com"/>
<associatedPerson>
<name use="L">
<family>Webb</family>
<given>David</given>
<given>T</given>
<prefix>Mr</prefix>
<suffix>MBA</suffix>
</name>
</associatedPerson>
</associatedEntity>
</participant>
<participant typeCode="IND">
<templateId root="2.16.840.1.113883.3.88.11.83.3"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.2.4"/>
<time nullFlavor="UNK"/>
<associatedEntity classCode="CAREGIVER">
<id nullFlavor="UNK"/>
<code code="FRND" codeSystem="2.16.840.1.113883.5.111" codeSystemName="RoleCode" displayName="Friend">
<originalText>Friend</originalText>
</code>
<addr use="WP">
<streetAddressLine>1621 N Broadway</streetAddressLine>
<city>NY</city>
<state>NY</state>
<postalCode>10018</postalCode>
<country>USA</country>
<useablePeriod xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_TS">
<low value="19990101000000"/>
<high value="20150630120000"/>
</useablePeriod>
</addr>
<telecom use="HP" value="tel:212-232-1111"/>
<telecom use="WP" value="tel:212-132-8834"/>
<telecom use="MC" value="tel:212-165-0033"/>
<telecom value="mailto:rjohnson11@citymail.com"/>
<associatedPerson>
<name use="L">
<family>Johnson</family>
<given>Rachel</given>
<given>V</given>
<prefix>Ms</prefix>
<suffix>Esq</suffix>
</name>
</associatedPerson>
</associatedEntity>
</participant>
<component>
<structuredBody>
<component>
<section>
<templateId root="1.3.6.1.4.1.19376.1.3.3.2.1"/>
<code code="26436-6" displayName="LABORATORY STUDIES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<title>Results</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Test Description</th>
<th>Test Time</th>
<th>Test Comments</th>
<th>Text Results</th>
<th>Atomic Results</th>
<th>Result Comments</th>
</tr>
</thead>
<tbody>
<tr ID="resultNarrativeLink-1">
<td ID="resultTestDescriptionLink-1">COMPREHENSIVE METABOLIC W/CO2</td>
<td>2011-10-14 00:47:00</td>
<td ID="resultTestCommentsLink-1"/>
<td ID="resultTextLink-1"/>
<td>
<list>
<item>
<table border="1" width="100%">
<thead>
<tr>
<th>Test Item</th>
<th>Value</th>
<th>Reference Range</th>
<th>Comments</th>
</tr>
</thead>
<tbody>
<tr>
<td>GLUCOSE (test code = 2350-7)</td>
<td ID="resultValueLink-1-1">96 mg/dL</td>
<td>70-110</td>
<td ID="resultValueCommentsLink-1-1"/>
</tr>
<tr>
<td>Urea Nitrogen (test code = 3095-7)</td>
<td ID="resultValueLink-1-2">9 mg/dL</td>
<td>7-23</td>
<td ID="resultValueCommentsLink-1-2"/>
</tr>
<tr>
<td>Creatinine (test code = 2161-8)</td>
<td ID="resultValueLink-1-3">0.8 mg/dL</td>
<td>-0.6-1.3</td>
<td ID="resultValueCommentsLink-1-3"/>
</tr>
<tr>
<td>Sodium (test code = 2955-3)</td>
<td ID="resultValueLink-1-4">139 mmol/L</td>
<td>136-145</td>
<td ID="resultValueCommentsLink-1-4"/>
</tr>
<tr>
<td>Potassium (test code = 2828-2)</td>
<td ID="resultValueLink-1-5">3.7 mmol/L</td>
<td>3.5-5.1</td>
<td ID="resultValueCommentsLink-1-5"/>
</tr>
<tr>
<td>Chloride (test code = 2078-4)</td>
<td ID="resultValueLink-1-6">101 mmol/L</td>
<td>102-110</td>
<td ID="resultValueCommentsLink-1-6"/>
</tr>
<tr>
<td>Carbon Dioxide (test code = 13538-4)</td>
<td ID="resultValueLink-1-7">27 mmol/L</td>
<td>22-29</td>
<td ID="resultValueCommentsLink-1-7"/>
</tr>
<tr>
<td>Calcium (test code = 17862-4)</td>
<td ID="resultValueLink-1-8">9.2 mg/dL</td>
<td>8.5-10.1</td>
<td ID="resultValueCommentsLink-1-8"/>
</tr>
<tr>
<td>Albumin (test code = 2862-1)</td>
<td ID="resultValueLink-1-9">4.4 g/dL</td>
<td>3.4-5.0</td>
<td ID="resultValueCommentsLink-1-9"/>
</tr>
<tr>
<td>Bilirubin (test code = 1978-6)</td>
<td ID="resultValueLink-1-10">0.55 mg/dL</td>
<td>0.0-1.0</td>
<td ID="resultValueCommentsLink-1-10"/>
</tr>
</tbody>
</table>
</item>
</list>
</td>
<td ID="resultCommentsLink-1"/>
</tr>
<tr ID="resultNarrativeLink-2">
<td ID="resultTestDescriptionLink-2">RENAL PANEL CH</td>
<td>2011-10-14 19:59:00</td>
<td ID="resultTestCommentsLink-2">This is Order Comments text.</td>
<td ID="resultTextLink-2"/>
<td>
<list>
<item>
<table border="1" width="100%">
<thead>
<tr>
<th>Test Item</th>
<th>Value</th>
<th>Reference Range</th>
<th>Comments</th>
</tr>
</thead>
<tbody>
<tr>
<td>Glucose (test code = 2350-7)</td>
<td ID="resultValueLink-2-1">90 mg/dL</td>
<td>70-110</td>
<td ID="resultValueCommentsLink-2-1"/>
</tr>
<tr>
<td>Urea Nitrogen (test code = 3095-7)</td>
<td ID="resultValueLink-2-2">8 mg/dL</td>
<td>7-18</td>
<td ID="resultValueCommentsLink-2-2"/>
</tr>
<tr>
<td>Creatinine (test code = 2161-8)</td>
<td ID="resultValueLink-2-3">0.9 mg/dL</td>
<td>0.6-1.0</td>
<td ID="resultValueCommentsLink-2-3"/>
</tr>
<tr>
<td>Sodium (test code = 2955-3)</td>
<td ID="resultValueLink-2-4">140 mmol/L</td>
<td>135-145</td>
<td ID="resultValueCommentsLink-2-4"/>
</tr>
<tr>
<td>Potassium (test code = 2828-2)</td>
<td ID="resultValueLink-2-5">5.0 mmol/L</td>
<td>3.5-5.1</td>
<td ID="resultValueCommentsLink-2-5"/>
</tr>
<tr>
<td>Chloride (test code = 2078-4)</td>
<td ID="resultValueLink-2-6">100 mmol/L</td>
<td>95-108</td>
<td ID="resultValueCommentsLink-2-6"/>
</tr>
<tr>
<td>Carbon Dioxide (test code = 13538-4)</td>
<td ID="resultValueLink-2-7">31.0 mmol/L</td>
<td>21.0-31.0</td>
<td ID="resultValueCommentsLink-2-7"/>
</tr>
<tr>
<td>Albumin (test code = 2862-1)</td>
<td ID="resultValueLink-2-8">&lt;4.0 g/dL</td>
<td>3.4-5.0</td>
<td ID="resultValueCommentsLink-2-8">This comment
has line
  feeds embedded.</td>
</tr>
<tr>
<td>Calcium (test code = 17862-4)</td>
<td ID="resultValueLink-2-9">9.0 mg/dL</td>
<td>8.5-10.1</td>
<td ID="resultValueCommentsLink-2-9">This is Result Comments text.</td>
</tr>
<tr>
<td>Battery Notes (test code = NT1)</td>
<td ID="resultValueLink-2-10">This is Result ResultValue text.</td>
<td/>
<td ID="resultValueCommentsLink-2-10"/>
</tr>
<tr>
<td>Date results verified (test code = DT)</td>
<td ID="resultValueLink-2-11">2011-10-14T23:00:00Z</td>
<td/>
<td ID="resultValueCommentsLink-2-11"/>
</tr>
<tr>
<td>Phosphate (test code = 2778-9)</td>
<td ID="resultValueLink-2-12">3.0 mg/dL</td>
<td>2.5-4.9</td>
<td ID="resultValueCommentsLink-2-12"/>
</tr>
</tbody>
</table>
</item>
</list>
</td>
<td ID="resultCommentsLink-2"/>
</tr>
</tbody>
</table>
</text>
<entry typeCode="DRIV">
<templateId root="1.3.6.1.4.1.19376.1.3.1" extension="Lab.Report.Data.Processing.Entry"/>
<act classCode="ACT" moodCode="EVN">
<id root="9C320E90-7D44-11E3-A3ED-BCC890787600" assigningAuthorityName="-UnspecifiedPlacerId"/>
<code code="CMP" codeSystem="LAB" codeSystemName="LAB" displayName="COMPREHENSIVE METABOLIC W/CO2">
<originalText>
<reference value="#resultTestDescriptionLink-1"/>
</originalText>
</code>
<text>
<reference value="#resultNarrativeLink-1"/>
</text>
<statusCode code="completed"/>
<performer typeCode="PRF">
<time>
<low value="20111014004700"/>
<high nullFlavor="UNK"/>
</time>
<assignedEntity classCode="ASSIGNED">
<id root="2.16.840.1.113883.3.86.3.1" extension="ELL"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name use="L">Lemon, Liz<family>Lemon</family>
<given>Liz</given>
</name>
</assignedPerson>
</assignedEntity>
</performer>
<entryRelationship typeCode="COMP">
<organizer classCode="BATTERY" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.32"/>
<id root="1.3.6.1.4.1.21367.3000.1.6" extension="20121127:C00845S" assigningAuthorityName="IHEFACILITY-FillerId"/>
<code code="CMP" codeSystem="LAB" codeSystemName="LAB" displayName="COMPREHENSIVE METABOLIC W/CO2">
<originalText>
<reference value="#resultTestDescriptionLink-1"/>
</originalText>
</code>
<statusCode code="completed"/>
<effectiveTime value="20111014004700"/>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="completed" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="completed" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>completed</originalText>
</value>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="2350-7" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="GLUCOSE">
<originalText>GLUCOSE</originalText>
</code>
<text>
<reference value="#resultTextLink-1-1"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014004700"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="PQ" value="96" unit="mg/dL"/>
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="Normal"/>
<performer typeCode="PRF">
<time nullFlavor="UNK"/>
<assignedEntity>
<id root="2.16.840.1.113883.3.86.3.1" extension="LAB34"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name use="L">34TH STREET LAB</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300.2.35"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="LAB34" displayable="true"/>
<name>34TH STREET LAB</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
<sdtc:patient xmlns:sdtc="urn:hl7-org:sdtc">
<sdtc:id root="1.3.6.1.4.1.21367.3000.1.6" extension="9301995"/>
</sdtc:patient>
</assignedEntity>
</performer>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="70" unit="mg/dL"/>
<high value="110" unit="mg/dL"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="3095-7" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Urea Nitrogen">
<originalText>Urea Nitrogen</originalText>
</code>
<text>
<reference value="#resultTextLink-1-2"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014004700"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="PQ" value="9" unit="mg/dL"/>
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="Normal"/>
<performer typeCode="PRF">
<time nullFlavor="UNK"/>
<assignedEntity>
<id root="2.16.840.1.113883.3.86.3.1" extension="LAB34"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name use="L">34TH STREET LAB</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300.2.35"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="LAB34" displayable="true"/>
<name>34TH STREET LAB</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
<sdtc:patient xmlns:sdtc="urn:hl7-org:sdtc">
<sdtc:id root="1.3.6.1.4.1.21367.3000.1.6" extension="9301995"/>
</sdtc:patient>
</assignedEntity>
</performer>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="7" unit="mg/dL"/>
<high value="23" unit="mg/dL"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="2161-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Creatinine">
<originalText>Creatinine</originalText>
</code>
<text>
<reference value="#resultTextLink-1-3"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014004700"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="PQ" value="0.8" unit="mg/dL"/>
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="Normal"/>
<performer typeCode="PRF">
<time nullFlavor="UNK"/>
<assignedEntity>
<id root="2.16.840.1.113883.3.86.3.1" extension="LAB34"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name use="L">34TH STREET LAB</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300.2.35"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="LAB34" displayable="true"/>
<name>34TH STREET LAB</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
<sdtc:patient xmlns:sdtc="urn:hl7-org:sdtc">
<sdtc:id root="1.3.6.1.4.1.21367.3000.1.6" extension="9301995"/>
</sdtc:patient>
</assignedEntity>
</performer>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="-0.6" unit="mg/dL"/>
<high value="1.3" unit="mg/dL"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="2955-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Sodium">
<originalText>Sodium</originalText>
</code>
<text>
<reference value="#resultTextLink-1-4"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014004700"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="PQ" value="139" unit="mmol/L"/>
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="Normal"/>
<performer typeCode="PRF">
<time nullFlavor="UNK"/>
<assignedEntity>
<id root="2.16.840.1.113883.3.86.3.1" extension="LAB34"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name use="L">34TH STREET LAB</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300.2.35"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="LAB34" displayable="true"/>
<name>34TH STREET LAB</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
<sdtc:patient xmlns:sdtc="urn:hl7-org:sdtc">
<sdtc:id root="1.3.6.1.4.1.21367.3000.1.6" extension="9301995"/>
</sdtc:patient>
</assignedEntity>
</performer>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="136" unit="mmol/L"/>
<high value="145" unit="mmol/L"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="2828-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Potassium">
<originalText>Potassium</originalText>
</code>
<text>
<reference value="#resultTextLink-1-5"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014004700"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="PQ" value="3.7" unit="mmol/L"/>
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="Normal"/>
<performer typeCode="PRF">
<time nullFlavor="UNK"/>
<assignedEntity>
<id root="2.16.840.1.113883.3.86.3.1" extension="LAB34"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name use="L">34TH STREET LAB</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300.2.35"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="LAB34" displayable="true"/>
<name>34TH STREET LAB</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
<sdtc:patient xmlns:sdtc="urn:hl7-org:sdtc">
<sdtc:id root="1.3.6.1.4.1.21367.3000.1.6" extension="9301995"/>
</sdtc:patient>
</assignedEntity>
</performer>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="3.5" unit="mmol/L"/>
<high value="5.1" unit="mmol/L"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="2078-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Chloride">
<originalText>Chloride</originalText>
</code>
<text>
<reference value="#resultTextLink-1-6"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014004700"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="PQ" value="101" unit="mmol/L"/>
<interpretationCode code="L" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="Low"/>
<performer typeCode="PRF">
<time nullFlavor="UNK"/>
<assignedEntity>
<id root="2.16.840.1.113883.3.86.3.1" extension="LAB34"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name use="L">34TH STREET LAB</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300.2.35"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="LAB34" displayable="true"/>
<name>34TH STREET LAB</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
<sdtc:patient xmlns:sdtc="urn:hl7-org:sdtc">
<sdtc:id root="1.3.6.1.4.1.21367.3000.1.6" extension="9301995"/>
</sdtc:patient>
</assignedEntity>
</performer>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="102" unit="mmol/L"/>
<high value="110" unit="mmol/L"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="13538-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Carbon Dioxide">
<originalText>Carbon Dioxide</originalText>
</code>
<text>
<reference value="#resultTextLink-1-7"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014004700"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="PQ" value="27" unit="mmol/L"/>
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="Normal"/>
<performer typeCode="PRF">
<time nullFlavor="UNK"/>
<assignedEntity>
<id root="2.16.840.1.113883.3.86.3.1" extension="LAB34"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name use="L">34TH STREET LAB</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300.2.35"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="LAB34" displayable="true"/>
<name>34TH STREET LAB</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
<sdtc:patient xmlns:sdtc="urn:hl7-org:sdtc">
<sdtc:id root="1.3.6.1.4.1.21367.3000.1.6" extension="9301995"/>
</sdtc:patient>
</assignedEntity>
</performer>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="22" unit="mmol/L"/>
<high value="29" unit="mmol/L"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="17862-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Calcium">
<originalText>Calcium</originalText>
</code>
<text>
<reference value="#resultTextLink-1-8"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014004700"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="PQ" value="9.2" unit="mg/dL"/>
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="Normal"/>
<performer typeCode="PRF">
<time nullFlavor="UNK"/>
<assignedEntity>
<id root="2.16.840.1.113883.3.86.3.1" extension="LAB34"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name use="L">34TH STREET LAB</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300.2.35"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="LAB34" displayable="true"/>
<name>34TH STREET LAB</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
<sdtc:patient xmlns:sdtc="urn:hl7-org:sdtc">
<sdtc:id root="1.3.6.1.4.1.21367.3000.1.6" extension="9301995"/>
</sdtc:patient>
</assignedEntity>
</performer>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="8.5" unit="mg/dL"/>
<high value="10.1" unit="mg/dL"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="2862-1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Albumin">
<originalText>Albumin</originalText>
</code>
<text>
<reference value="#resultTextLink-1-9"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014004700"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="PQ" value="4.4" unit="g/dL"/>
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="Normal"/>
<performer typeCode="PRF">
<time nullFlavor="UNK"/>
<assignedEntity>
<id root="2.16.840.1.113883.3.86.3.1" extension="LAB34"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name use="L">34TH STREET LAB</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300.2.35"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="LAB34" displayable="true"/>
<name>34TH STREET LAB</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
<sdtc:patient xmlns:sdtc="urn:hl7-org:sdtc">
<sdtc:id root="1.3.6.1.4.1.21367.3000.1.6" extension="9301995"/>
</sdtc:patient>
</assignedEntity>
</performer>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="3.4" unit="g/dL"/>
<high value="5.0" unit="g/dL"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="1978-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Bilirubin">
<originalText>Bilirubin</originalText>
</code>
<text>
<reference value="#resultTextLink-1-10"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014004700"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="PQ" value="0.55" unit="mg/dL"/>
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="Normal"/>
<performer typeCode="PRF">
<time nullFlavor="UNK"/>
<assignedEntity>
<id root="2.16.840.1.113883.3.86.3.1" extension="LAB34"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name use="L">34TH STREET LAB</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300.2.35"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="LAB34" displayable="true"/>
<name>34TH STREET LAB</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
<sdtc:patient xmlns:sdtc="urn:hl7-org:sdtc">
<sdtc:id root="1.3.6.1.4.1.21367.3000.1.6" extension="9301995"/>
</sdtc:patient>
</assignedEntity>
</performer>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="0.0" unit="mg/dL"/>
<high value="1.0" unit="mg/dL"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
</organizer>
</entryRelationship>
</act>
</entry>
<entry typeCode="DRIV">
<templateId root="1.3.6.1.4.1.19376.1.3.1" extension="Lab.Report.Data.Processing.Entry"/>
<act classCode="ACT" moodCode="EVN">
<id root="1.3.6.1.4.1.21367.3000.1.6" extension="PSNSDA008" assigningAuthorityName="IHEFACILITY-PlacerId"/>
<code nullFlavor="OTH">
<originalText>
<reference value="#resultTestDescriptionLink-2"/>
</originalText>
<translation code="69CH" codeSystem="2.16.840.1.113883.3.86.3.1" codeSystemName="ISC-NoCodeSystem" displayName="RENAL PANEL CH"/>
</code>
<text>
<reference value="#resultNarrativeLink-2"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014192700"/>
<specimen typeCode="SPC">
<specimenRole classCode="SPEC">
<specimenPlayingEntity>
<code code="Urine" codeSystem="2.16.840.1.113883.5.129" codeSystemName="SpecimenType" displayName="Urine">
<originalText>Urine</originalText>
</code>
</specimenPlayingEntity>
</specimenRole>
</specimen>
<performer typeCode="PRF">
<time>
<low value="20111014191300"/>
<high value="20111014192100"/>
</time>
<assignedEntity classCode="ASSIGNED">
<id root="2.16.840.1.113883.3.86.3.1" extension="LZK"/>
<addr use="WP">
<streetAddressLine>485 Northern Blvd</streetAddressLine>
<city>QUNY</city>
<state>NY</state>
<postalCode>11034</postalCode>
<country>US</country>
<useablePeriod xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_TS">
<low value="19950308000100"/>
<high value="20100630235959"/>
</useablePeriod>
</addr>
<telecom use="HP" value="tel:215-434-4535"/>
<telecom use="WP" value="tel:215-654-5433"/>
<telecom use="MC" value="tel:215-845-9433"/>
<telecom value="mailto:luka@ermail.com"/>
<assignedPerson>
<name use="L">Luka Kovac<family>Kovac</family>
<given>Luka</given>
<given>Z</given>
<prefix>Dr</prefix>
<suffix>MD</suffix>
</name>
</assignedPerson>
</assignedEntity>
</performer>
<author typeCode="AUT">
<time value="20111014192700"/>
<assignedAuthor classCode="ASSIGNED">
<id root="2.16.840.1.113883.3.86.3.1" extension="LT"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name use="L">Lab Tech</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.3000.1.6"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="IHEFACILITY" displayable="true"/>
<name>IHE Facility</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
</assignedAuthor>
</author>
<informant>
<assignedEntity>
<id root="2.16.840.1.113883.3.86.3.1" extension="IHEFACILITY"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name nullFlavor="UNK"/>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.3000.1.6"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="IHEFACILITY" displayable="true"/>
<name>IHE Facility</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
</assignedEntity>
</informant>
<entryRelationship typeCode="SUBJ" inversionInd="true">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11"/>
<templateId root="2.16.840.1.113883.10.20.1.40"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation Comment"/>
<text>
<reference value="#resultTestCommentsLink-2"/>
</text>
<statusCode code="completed"/>
<author typeCode="AUT">
<time value="20111014192700"/>
<assignedAuthor classCode="ASSIGNED">
<id root="2.16.840.1.113883.3.86.3.1" extension="LZK"/>
<addr use="WP">
<streetAddressLine>485 Northern Blvd</streetAddressLine>
<city>QUNY</city>
<state>NY</state>
<postalCode>11034</postalCode>
<country>US</country>
<useablePeriod xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_TS">
<low value="19950308000100"/>
<high value="20100630235959"/>
</useablePeriod>
</addr>
<telecom use="HP" value="tel:215-434-4535"/>
<telecom use="WP" value="tel:215-654-5433"/>
<telecom use="MC" value="tel:215-845-9433"/>
<telecom value="mailto:luka@ermail.com"/>
<assignedPerson>
<name use="L">Luka Kovac<family>Kovac</family>
<given>Luka</given>
<given>Z</given>
<prefix>Dr</prefix>
<suffix>MD</suffix>
</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.3000.1.6"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="IHEFACILITY" displayable="true"/>
<name>IHE Facility</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
</assignedAuthor>
</author>
<author typeCode="AUT">
<time value="20111014192700"/>
<assignedAuthor classCode="ASSIGNED">
<id root="2.16.840.1.113883.3.86.3.1" extension="LMGR"/>
<addr use="WP">
<streetAddressLine>144 N Fifth Avenue</streetAddressLine>
<city>NY</city>
<state>NY</state>
<postalCode>10021</postalCode>
<country>USA</country>
<useablePeriod xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_TS">
<low value="19610703000000"/>
<high value="20201231235959"/>
</useablePeriod>
</addr>
<telecom use="HP" value="tel:212-545-5552"/>
<telecom use="WP" value="tel:212-432-3482"/>
<telecom use="MC" value="tel:212-266-0485"/>
<telecom value="mailto:labManager@mymail.com"/>
<assignedPerson>
<name use="L">Lab, Manager<family>Lab</family>
<given>Manager</given>
<given>J</given>
<prefix>Ms</prefix>
<suffix>MT ASCP</suffix>
</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.3000.1.6"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="IHEFACILITY" displayable="true"/>
<name>IHE Facility</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
</assignedAuthor>
</author>
<author typeCode="AUT">
<time value="20111014192700"/>
<assignedAuthor classCode="ASSIGNED">
<id root="2.16.840.1.113883.3.86.3.1" extension="RHD"/>
<addr use="WP">
<streetAddressLine>9453 Seventh Ave</streetAddressLine>
<city>NY</city>
<state>NY</state>
<postalCode>00023</postalCode>
<country>USA</country>
<useablePeriod xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_TS">
<low value="19900101000500"/>
<high nullFlavor="UNK"/>
</useablePeriod>
</addr>
<telecom use="HP" value="tel:212-443-3434"/>
<telecom use="WP" value="tel:212-544-2353"/>
<telecom use="MC" value="tel:212-533-9244"/>
<telecom value="mailto:rogerd@what.com"/>
<assignedPerson>
<name use="L">Roger Denver<family>Denver</family>
<given>Roger</given>
<given>Harry</given>
<prefix>Dr</prefix>
<suffix>MD</suffix>
</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.3000.1.6"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="IHEFACILITY" displayable="true"/>
<name>IHE Facility</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
</assignedAuthor>
</author>
</act>
</entryRelationship>
<entryRelationship typeCode="COMP">
<organizer classCode="BATTERY" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.32"/>
<id root="1.3.6.1.4.1.21367.3000.1.6" extension="TSNSDA-113-RFP-ab" assigningAuthorityName="IHEFACILITY-FillerId"/>
<code nullFlavor="OTH">
<originalText>
<reference value="#resultTestDescriptionLink-2"/>
</originalText>
<translation code="69CH" codeSystem="2.16.840.1.113883.3.86.3.1" codeSystemName="ISC-NoCodeSystem" displayName="RENAL PANEL CH"/>
</code>
<statusCode code="completed"/>
<effectiveTime value="20111014195900"/>
<author typeCode="AUT">
<time value="20111014192700"/>
<assignedAuthor classCode="ASSIGNED">
<id root="2.16.840.1.113883.3.86.3.1" extension="LT"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name use="L">Lab Tech</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.3000.1.6"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="IHEFACILITY" displayable="true"/>
<name>IHE Facility</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
</assignedAuthor>
</author>
<informant>
<assignedEntity>
<id root="2.16.840.1.113883.3.86.3.1" extension="IHEFACILITY"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name nullFlavor="UNK"/>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.3000.1.6"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="IHEFACILITY" displayable="true"/>
<name>IHE Facility</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
</assignedEntity>
</informant>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="active" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="active" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>active</originalText>
</value>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="2350-7" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Glucose">
<originalText>Glucose</originalText>
</code>
<text>
<reference value="#resultTextLink-2-1"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014195900"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="PQ" value="90" unit="mg/dL"/>
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="Normal"/>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="70" unit="mg/dL"/>
<high value="110" unit="mg/dL"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="3095-7" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Urea Nitrogen">
<originalText>Urea Nitrogen</originalText>
</code>
<text>
<reference value="#resultTextLink-2-2"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014195900"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="PQ" value="8" unit="mg/dL"/>
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="Normal"/>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="7" unit="mg/dL"/>
<high value="18" unit="mg/dL"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="2161-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Creatinine">
<originalText>Creatinine</originalText>
</code>
<text>
<reference value="#resultTextLink-2-3"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014195900"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="PQ" value="0.9" unit="mg/dL"/>
<interpretationCode code="H" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="High"/>
<performer typeCode="PRF">
<time nullFlavor="UNK"/>
<assignedEntity>
<id root="2.16.840.1.113883.3.86.3.1" extension="FIFTYTWO"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name use="L">52nd Street Laboratory</name>
</assignedPerson>
<representedOrganization>
<id root="FIFTYTWO"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="FIFTYTWO" displayable="true"/>
<name>FIFTYTWO</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
<sdtc:patient xmlns:sdtc="urn:hl7-org:sdtc">
<sdtc:id root="1.3.6.1.4.1.21367.3000.1.6" extension="9301995"/>
</sdtc:patient>
</assignedEntity>
</performer>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="0.6" unit="mg/dL"/>
<high value="1.0" unit="mg/dL"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="2955-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Sodium">
<originalText>Sodium</originalText>
</code>
<text>
<reference value="#resultTextLink-2-4"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014195900"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="PQ" value="140" unit="mmol/L"/>
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="Normal"/>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="135" unit="mmol/L"/>
<high value="145" unit="mmol/L"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="2828-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Potassium">
<originalText>Potassium</originalText>
</code>
<text>
<reference value="#resultTextLink-2-5"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014195900"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="PQ" value="5.0" unit="mmol/L"/>
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="Normal"/>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="3.5" unit="mmol/L"/>
<high value="5.1" unit="mmol/L"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="2078-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Chloride">
<originalText>Chloride</originalText>
</code>
<text>
<reference value="#resultTextLink-2-6"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014195900"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="PQ" value="100" unit="mmol/L"/>
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="Normal"/>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="95" unit="mmol/L"/>
<high value="108" unit="mmol/L"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="13538-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Carbon Dioxide">
<originalText>Carbon Dioxide</originalText>
</code>
<text>
<reference value="#resultTextLink-2-7"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014195900"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="PQ" value="31.0" unit="mmol/L"/>
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="Normal"/>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="21.0" unit="mmol/L"/>
<high value="31.0" unit="mmol/L"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="2862-1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Albumin">
<originalText>Albumin</originalText>
</code>
<text>
<reference value="#resultTextLink-2-8"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014195900"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ST">&lt;4.0 g/dL</value>
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="Normal"/>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode="SUBJ" inversionInd="true">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11"/>
<templateId root="2.16.840.1.113883.10.20.1.40"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation Comment"/>
<text>
<reference value="#resultValueCommentsLink-2-8"/>
</text>
<statusCode code="completed"/>
</act>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="3.4" unit="g/dL"/>
<high value="5.0" unit="g/dL"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="17862-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Calcium">
<originalText>Calcium</originalText>
</code>
<text>
<reference value="#resultTextLink-2-9"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014195900"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="PQ" value="9.0" unit="mg/dL"/>
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="Normal"/>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode="SUBJ" inversionInd="true">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11"/>
<templateId root="2.16.840.1.113883.10.20.1.40"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation Comment"/>
<text>
<reference value="#resultValueCommentsLink-2-9"/>
</text>
<statusCode code="completed"/>
</act>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="8.5" unit="mg/dL"/>
<high value="10.1" unit="mg/dL"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="NT1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Battery Notes">
<originalText>Battery Notes</originalText>
</code>
<text>
<reference value="#resultTextLink-2-10"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014195900"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ST">This is Result ResultValue text.</value>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="DT" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Date results verified">
<originalText>Date results verified</originalText>
</code>
<text>
<reference value="#resultTextLink-2-11"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014195900"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ST">2011-10-14T23:00:00Z</value>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
</observation>
</component>
<component typeCode="COMP">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.3.1.6"/>
<id nullFlavor="UNK"/>
<code code="2778-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Phosphate">
<originalText>Phosphate</originalText>
</code>
<text>
<reference value="#resultTextLink-2-12"/>
</text>
<statusCode code="completed"/>
<effectiveTime value="20111014195900"/>
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="PQ" value="3.0" unit="mg/dL"/>
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" codeSystemName="ObservationInterpretation" displayName="Normal"/>
<performer typeCode="PRF">
<time nullFlavor="UNK"/>
<assignedEntity>
<id root="2.16.840.1.113883.3.86.3.1" extension="FORTYTWO"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name use="L">42nd Street Laboratory</name>
</assignedPerson>
<representedOrganization>
<id root="FORTYTWO"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="FORTYTWO" displayable="true"/>
<name>FORTYTWO</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK"/>
<wholeOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.300"/>
<id root="1.3.6.1.4.1.21367.2010.1.2.300" extension="HomeCommunity" displayable="true"/>
<name>Home Community</name>
<telecom use="WP" value="tel:(617) 621-0600"/>
<addr use="WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
<sdtc:patient xmlns:sdtc="urn:hl7-org:sdtc">
<sdtc:id root="1.3.6.1.4.1.21367.3000.1.6" extension="9301995"/>
</sdtc:patient>
</assignedEntity>
</performer>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57"/>
<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text/>
<statusCode code="completed"/>
<value code="final" codeSystem="2.16.840.1.113883.5.14" codeSystemName="ActStatus" displayName="final" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CE">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<referenceRange typeCode="REFV">
<observationRange classCode="OBS" moodCode="EVN.CRT">
<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IVL_PQ">
<low value="2.5" unit="mg/dL"/>
<high value="4.9" unit="mg/dL"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
</organizer>
</entryRelationship>
</act>
</entry>
</section>
</component>
</structuredBody>
</component>
</ClinicalDocument>
}

}
