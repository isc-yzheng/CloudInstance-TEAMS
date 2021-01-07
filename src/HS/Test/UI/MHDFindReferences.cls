Include HS.HC

Class HS.Test.UI.MHDFindReferences Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "MHD Find Document References";

Property PatientMRN As %String(ZENURL = "PATIENTMRN");

Property PatientAA As %String(ZENURL = "PATIENTAA");

Parameter SERVICEREGISTRYENTRY = "MHD.Responder";

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
.textReadOnly {
	border: 1px inset threedface;
	color:#777777;
	background: #EEEEEE;
}
</style>
}

/// This XML block defines the contents of the ICE IHE test workflow pane.
XData Contents
{
<page title="HealthShare IHE Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">

<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">

<spacer height="15"/>
<text id="isFHIR" value="1" hidden="1" />
<html>Construct XDSb Query for conversion to FHIR MHD Find Document References</html>
<spacer height="5"/>
<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left" enctype="multipart/form-data">
<spacer height="5"/>
<checkbox label="Enable logging" id="chkLogging" title="Route traffic through tcp trace utility" hidden="1"/>

<spacer height="5"/>

<combobox id="cmbFormat" label="FHIR Format:" size="22" tabIndex="35" title="Value to use for the _format URL parameter" />
<spacer width="5" />
<combobox id="cmbVersion" label="FHIR Version:" size="22" tabIndex="35" title="FHIR version to use" />
<spacer width="5" />
<combobox id="cmbDocStatus" label="Availability Status:" size="22" title="Maps to the MHD 'status' search parameter. XDSb Approved = MHD current, XDSb Deprecated = MHD superseded" valueList=",Approved,Deprecated,Approved/Deprecated" displayList=",Approved,Deprecated,Approved &amp; Deprecated" value="Approved" />
<combobox id="cmbPatientID" label=" Select Patient:" size="80" valueList="" displayList="" value="" onchange="zenPage.populatePatient();" />
<text label="Full Patient ID:" name="patientID" id="txtPatientID" title="ISO formatted full Patient ID (Identifier^^^&amp;AssigningAuthorityOID&amp;ISO). Maps to the MHD 'patient.identifier' search parameter. If Patient Resource URL has a specified value then the Patient Resource URL value supersedes Full Patient ID." size="80" value="#(%page.PatientMRN)#^^^&amp;#(%page.PatientAA)#&amp;ISO"/>
<text label="Patient Resource URL:" id="txtPatientReference" size="80" title="Maps to the MHD 'patient' search parameter. Full URL that points to an existing FHIR Patient resource representing the XDS Affinity Domain Patient. This search parameter supersedes the Full Patient ID parameter."/>
<spacer height="10"/>
<hgroup>
<dateText id="dtFromTime" label="Creation Date Start:" size="22" title="Maps to the MHD 'indexed' search parameter. If Creation Date Start is specified AND is not the same value as Creation Date End, then the MHD 'indexed' parameter value will be prefixed with 'ge'. If Creation Date Start and Creation Date End have the same non-blank values then it is interpreted as a single 'indexed' search parameter and the value is prefixed with 'eq'." minDate="1841-01-01" maxDate="T" hint="(yyyy-mm-dd)" hintStyle="font-size:10px;font-weight:bold;" tabIndex="60"/>
<spacer width="15"/>
<dateText id="dtToTime" label="Creation Date End:" size="22" title="Maps to the MHD 'indexed' search parameter. If Creation Date End is specified AND is not the same value as Creation Date Start, then the MHD 'indexed' parameter value will be prefixed with 'le'. If Creation Date Start and Creation Date End have the same non-blank values then it is interpreted as a single 'indexed' search parameter and the value is prefixed with 'eq'." minDate="1841-01-01" maxDate="T" hint="(yyyy-mm-dd)" hintStyle="font-size:10px;font-weight:bold;" tabIndex="60"/>
</hgroup>
<hgroup>
<text label="Author First Name:" id="txtAuthorFirst" title="Maps to the MHD 'author.given' search parameter." size="35"/>
<spacer width="15"/>
<text label="Author Last Name:" id="txtAuthorLast" title="Maps to the MHD 'author.family' search parameter." size="35"/>
</hgroup>
<dataCombo id="cmbFormatCode" size='80' label="Format Code:" sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" title="Maps to the MHD 'format' search parameter." dropdownWidth="500" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreateCodedEntryRS"
	maxRows="10000">
	<parameter id="pType6" value="formatCode"/>
</dataCombo>
<dataCombo id="cmbConfidentialityCode" size='80' label="Confidentiality Code:" sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" title="Maps to the MHD 'securityLabel' search parameter." dropdownWidth="500" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreateCodedEntryRS"
	maxRows="10000">
	<parameter id="pType5" value="confidentialityCode"/>
</dataCombo>
<dataCombo id="cmbFacilityType" size='80' label="HealthcareFacilityType Code:" sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" title="Maps to the MHD 'facility' search parameter." dropdownWidth="500" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreateCodedEntryRS"
	maxRows="10000">
	<parameter id="pType3" value="healthcareFacilityTypeCode"/>
</dataCombo>
<dataCombo id="cmbPracticeSetting" size='80' label="Practice Setting Code:" sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" title="Maps to the MHD 'setting' search parameter." dropdownWidth="500" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreateCodedEntryRS"
	maxRows="10000">
	<parameter id="pType9" value="practiceSettingCode"/>
</dataCombo>
<dataCombo id="cmbTypeCode" size='80' label="Type Code:" sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" title="Maps to the MHD 'type' search parameter." dropdownWidth="500" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreateCodedEntryRS"
	maxRows="10000">
	<parameter id="pType2" value="typeCode"/>
</dataCombo>
<dataCombo id="cmbClass" size='80' label="Class Code:" sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" title="Maps to the MHD 'class' search parameter." dropdownWidth="500" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreateCodedEntryRS"
	maxRows="10000">
	<parameter id="pType8" value="classCode"/>
</dataCombo>
<dataCombo id="cmbEventCodeList" size='80' label="Event Code List:" sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" title="Maps to the MHD 'event' search parameter." dropdownWidth="500" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreateCodedEntryRS"
	maxRows="10000">
	<parameter id="pType4" value="eventCodeList"/>
</dataCombo>
<checkbox label="Code only:" id="chkCodeOnly" title="When checked, coded entry criteria will use only the code, and will not include the scheme."/>
<text label="Reference ID List: " id="txtRefIdList" title="Maps to the MHD 'related-id' search parameter. Enter a comma-delimited list of one or more ISO-formatted reference ids. For example, '2013001^^^&amp;1.2.3.4.5.6&amp;ISO^urn:ihe:iti:xds:2013:accession,2013002^^^&amp;1.2.3.4.5.6&amp;ISO^urn:ihe:iti:xds:2013:accession'." size="40"/>

<spacer height="30"/>

<dataCombo id="cmbServiceRegistry" size='80' label="EndPoint: *" dropdownWidth="800" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreatePIXPDQServiceRegistryRS"
	maxRows="10000">
	<parameter id="pType" value="HTTP"/>
</dataCombo>

<spacer height="5"/>

<hgroup width="40%" cellAlign="right">
<button id="btnSend" caption=" Submit Request " onclick="zenPage.StartSend('btnSend',1)" />
<spacer width="5" />
<button id="btnClear" caption=" Clear " onclick="zenPage.Clear();" />
<spacer width="5" />
</hgroup>

</form>
<vgroup>
<pane paneName="asyncPane"/>
</vgroup>

<pane id="paneResults"/>

</pane>
</page>
}

Method populatePatient() [ ZenMethod ]
{
	Set tPatientId = ..%GetValueById("cmbPatientID")
	Do ..%SetValueById("txtPatientID",tPatientId)
	Set tIndex = ""
	For {
		Set tIndex = $Order(%session.Data("IHE.Test","RecentPatients",tIndex))
		If tIndex="" Quit
		If $ListGet(%session.Data("IHE.Test","RecentPatients",tIndex),1)=tPatientId {
			Do ..%SetValueById("txtPatientReference",$ListGet(%session.Data("IHE.Test","RecentPatients",tIndex),3))
		}
	}
}

ClientMethod Clear() [ Language = javascript ]
{
	zen('cmbDocStatus').setValue("Approved");
	zen('cmbPatientID').setValue("");
	zen('txtPatientID').setValue("");
	zen('txtPatientReference').setValue("");
	zen('dtFromTime').setValue("");
	zen('dtToTime').setValue("");
	zen('txtAuthorFirst').setValue("");
	zen('txtAuthorLast').setValue("");
	zen('cmbFormatCode').setValue("");
	zen('cmbConfidentialityCode').setValue("");
	zen('cmbFacilityType').setValue("");
	zen('cmbPracticeSetting').setValue("");
	zen('cmbTypeCode').setValue("");
	zen('cmbClass').setValue("");
	zen('cmbEventCodeList').setValue("");
	zen('txtRefIdList').setValue("")
	zen('chkCodeOnly').setValue("")
	zenPage.ClearInputCache();
	zenPage.ClearResultsPane();
}

Method ClearInputCache() [ ZenMethod ]
{
	Set tCtrl("cmbDocStatus") = ""
	Set tCtrl("cmbPatientID") = ""
	Set tCtrl("txtPatientID") = ""
	Set tCtrl("txtPatientReference") = ""
	Set tCtrl("dtFromTime") = ""
	Set tCtrl("dtToTime") = ""
	Set tCtrl("txtAuthorFirst") = ""
	Set tCtrl("txtAuthorLast") = ""
	Set tCtrl("cmbFormatCode") = ""
	Set tCtrl("cmbConfidentialityCode") = ""
	Set tCtrl("cmbFacilityType") = ""
	Set tCtrl("cmbPracticeSetting") = ""
	Set tCtrl("cmbTypeCode") = ""
	Set tCtrl("cmbClass") = ""
	Set tCtrl("cmbEventCodeList") = ""
	Set tCtrl("txtRefIdList") = ""
	Set tCtrl("chkCodeOnly") = ""
	Set tCtrl = ""
	For {
		Set tCtrl = $Order(tCtrl(tCtrl))
		If tCtrl="" Quit
		Kill %session.Data("IHE.Test",..%ClassName(0),tCtrl)
	}	Quit
}

Method Send() As %String [ ZenMethod ]
{
	try {
		Set tSessionID=""

		set tFHIRVersion = %page.%GetValueById("cmbVersion")
		If tFHIRVersion="" &js< alert('FHIR Version is required');> Quit

		//collect patient id from tester input
		Set tPatientId = %page.%GetValueById("txtPatientID")
		If $Extract(tPatientId)="^" Set tPatientId = ""
		Set tDocStatus= %page.%GetValueById("cmbDocStatus")
		Set tServiceRegistry= %page.%GetValueById("cmbServiceRegistry")
		
		//Put together a HS.Message.IHE.XDSb.QueryRequest
		set tRequest = ##class(HS.Message.IHE.XDSb.QueryRequest).%New()
		
		set tQueryType = "FindDocuments"
		set tRequest.QueryType = tQueryType
		
		set tXDSItemName = $Select(tQueryType="FindSubmissionSets":"$XDSSubmissionSetPatientId",1:"$XDSDocumentEntryPatientId")
		do tRequest.AddPatientId(tPatientId, tXDSItemName)
		
		set tXDSItemName = $Select(tQueryType="FindSubmissionSets":"$XDSSubmissionSetStatus",1:"$XDSDocumentEntryStatus")
		if tDocStatus'="" Do tRequest.AddStatusValues($tr(tDocStatus,"/",","), tXDSItemName)

		set tPatientReference = %page.%GetValueById("txtPatientReference")
		if tPatientReference'="" Do tRequest.AdditionalInfo.SetAt(tPatientReference, "PatientReference")
		
		set tFromTime = %page.%GetValueById("dtFromTime")
		set tXDSItemName = $Select(tQueryType="FindSubmissionSets":"$XDSSubmissionSetSubmissionTimeFrom",1:"$XDSDocumentEntryCreationTimeFrom")
		if tFromTime'="" do tRequest.AddParam(tFromTime, tXDSItemName)
		
		set tToTime = %page.%GetValueById("dtToTime")
		set tXDSItemName = $Select(tQueryType="FindSubmissionSets":"$XDSSubmissionSetSubmissionTimeTo",1:"$XDSDocumentEntryCreationTimeTo")
		if tToTime'="" do tRequest.AddParam(tToTime, tXDSItemName)
		
		set tAuthorLast = %page.%GetValueById("txtAuthorLast")
		set tAuthorFirst = %page.%GetValueById("txtAuthorFirst")
		set tXDSItemName = $Select(tQueryType="FindSubmissionSets":"$XDSSubmissionSetAuthorPerson",1:"$XDSDocumentEntryAuthorPerson")
		if ((tAuthorLast_tAuthorFirst)'="") do tRequest.AddParam("^"_tAuthorLast_"^"_tAuthorFirst, tXDSItemName)
		
		set tCodeOnly = %page.%GetValueById("chkCodeOnly")
		
		set tTypeCode = %page.%GetValueById("cmbTypeCode")
		set tXDSItemName = $Select(tQueryType="FindSubmissionSets":"$XDSSubmissionSetContentType",1:"$XDSDocumentEntryTypeCode")
		if tTypeCode'="" do ..SetCodedEntryParam(tRequest, tTypeCode, tXDSItemName, tCodeOnly)
		
		Do ..SetCodedEntryParam(tRequest, %page.%GetValueById("cmbFacilityType"), "$XDSDocumentEntryHealthcareFacilityTypeCode", tCodeOnly)
		
		Do ..SetCodedEntryParam(tRequest, %page.%GetValueById("cmbPracticeSetting"), "$XDSDocumentEntryPracticeSettingCode", tCodeOnly)

		Do ..SetCodedEntryParam(tRequest, %page.%GetValueById("cmbEventCodeList"), "$XDSDocumentEntryEventCodeList", tCodeOnly)

		Do ..SetCodedEntryParam(tRequest, %page.%GetValueById("cmbConfidentialityCode"), "$XDSDocumentEntryConfidentialityCode", tCodeOnly)
		
		Do ..SetCodedEntryParam(tRequest, %page.%GetValueById("cmbFormatCode"), "$XDSDocumentEntryFormatCode", tCodeOnly)
		
		Do ..SetCodedEntryParam(tRequest, %page.%GetValueById("cmbClass"), "$XDSDocumentEntryClassCode", tCodeOnly)

		Set tRefIdList = %page.%GetValueById("txtRefIdList")
		If (tRefIdList'="") {
			For j = 1:1:$Length(tRefIdList,",") {
				Set tRefId = $Piece(tRefIdList,",",j)
				If tRefId="" Continue
				Do tRequest.AddParam(tRefId,"$XDSDocumentEntryReferenceIdList")
			}
		}
		
		set tFormat = %page.%GetValueById("cmbFormat")
		if (tFormat'="") { Do tRequest.AdditionalInfo.SetAt($ZConvert(tFormat,"L"),"_format") }
		Do tRequest.AdditionalInfo.SetAt(tServiceRegistry,"ServiceName")
		Do tRequest.AdditionalInfo.SetAt("MHDConsumer"_tFHIRVersion,"FHIRActor")
		
		Set %session.Data("IHE.Test",..%ClassName(0),"FHIRFormat")=tFormat
		Set %session.Data("IHE.Test",..%ClassName(0),"FHIRVersion")=tFHIRVersion
		
		Set:tPatientId]"" %session.Data("IHE.Test","PatientID")=tPatientId
		Set %session.Data("IHE.Test",..%ClassName(0),"DocStatus")=tDocStatus
		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Do tGroup.AdditionalInfo.SetAt(tPatientId,"PatientID")
		
		Do tGroup.AdditionalInfo.SetAt(tDocStatus,"DocStatus")
		Do tGroup.AdditionalInfo.SetAt(tServiceRegistry,"ServiceRegistry")
		
		Set tCtrl("dtFromTime") = ""
		Set tCtrl("dtToTime") = ""
		Set tCtrl("txtAuthorFirst") = ""
		Set tCtrl("txtAuthorLast") = ""
		Set tCtrl("cmbFormatCode") = ""
		Set tCtrl("cmbConfidentialityCode") = ""
		Set tCtrl("cmbFacilityType") = ""
		Set tCtrl("cmbPracticeSetting") = ""
		Set tCtrl("cmbTypeCode") = ""
		Set tCtrl("cmbClass") = ""
		Set tCtrl("cmbEventCodeList") = ""
		Set tCtrl("txtRefIdList") = ""
		Set tCtrl("chkCodeOnly") = ""
		Set tCtrl = ""
		For {
			Set tCtrl = $Order(tCtrl(tCtrl))
			If tCtrl="" Quit
			Set %session.Data("IHE.Test",..%ClassName(0),tCtrl) = %page.%GetValueById(tCtrl)
		}
		
		Set tChkLogging = %page.%GetValueById("chkLogging")
		#; Disable logging for FHIR-related options.
		Set tChkLogging = 0
		Set tTest=tGroup.NewTest(tRequest,tChkLogging)
		
		Kill %session.Data("IHE.Test","RecentDocuments")

		Set tSessionID = ..ExecuteAsync(tTest,tGroup)
	} catch ex {
		Do ..LogException(ex,$g(tGroup))
		Set tSessionID=""
	}
	Quit tSessionID
}

Method SetCodedEntryParam(pRequest As HS.Message.IHE.XDSb.QueryRequest, pCodedEntryID As %String, pItemName As %String, pCodeOnly As %Boolean = 0)
{
	Set tCodedEntry = ##class(HS.IHE.CodedEntry).%OpenId(pCodedEntryID)
	If $IsObject(tCodedEntry) {
		Set tCode = tCodedEntry.Code
		Set tScheme = tCodedEntry.CodingScheme
		Set tDescription = tCodedEntry.Description
		If pCodeOnly=0 {
			Do pRequest.AddParam(tCode_"^"_tDescription_"^"_tScheme, pItemName)
		} Else {
			Do pRequest.AddParam(tCode, pItemName)
		}
	}
	Quit
}

Method DisplayTestResult(pTest As HS.Test.UI.Test, pGroupTest As HS.Test.UI.TestGroup = "", pClear = 0)
{
	Do ##super(pTest,pGroupTest,pClear)
	Set tResponse=pTest.Response
	If $IsObject(tResponse) && $$$ISOK(pTest.Status) {
		Set tPatientId = %page.%GetValueById("txtPatientID")
		Set (tDisplayList,tValueList)=""
		#dim results as %ZEN.Component.pane
		set results=%page.%GetComponentById("paneResults")
	 	if $IsObject(tResponse) && (tResponse.Documents.Count()) {
			Do ..AddRecentDocuments(tResponse,"",tPatientId)
			For tIdx = 1:1:tResponse.Documents.Count() {
				If tIdx=1 {
					Set label=##class(%ZEN.Component.label).%New()
					Set label.label="Documents (hover on row for details):"
					Do results.%AddChild(label)
				}
				#dim tDocument as HS.Message.IHE.XDSb.Document
				Set tDocument = tResponse.Documents.GetAt(tIdx)
				Set tRepo = tDocument.RepositoryUniqueId
				Set tPatientId = tDocument.PatientId
				Set tRepo=##class(HS.Data.OIDMap).CodeForOID(tDocument.RepositoryUniqueId,,"Unknown Repo")
				Set label=##class(%ZEN.Component.label).%New()
				Set label.label=tDocument.UniqueId_" ["_tRepo_"]"
				Set tAuthorPerson = "(none)"
				If ($IsObject(tDocument.Author))&&(tDocument.Author.Count()>0) Set tAuthorPerson = tDocument.Author.GetAt(1).AuthorPerson
				Set tConfidentialityCode = "(none)"
				If ($IsObject(tDocument.ConfidentialityCode))&&(tDocument.ConfidentialityCode.Count()>0) Set tConfidentialityCode = tDocument.ConfidentialityCode.GetAt(1).Code
				Set tEventCode = "(none)"
				If ($IsObject(tDocument.EventCodeList))&&(tDocument.EventCodeList.Count()>0) Set tEventCode = tDocument.EventCodeList.GetAt(1).Code
				Set title="patientid: "_tPatientId_
					$c(13,10)_"sourcepatientid: "_tDocument.SourcePatientId_
					$c(13,10)_"version: "_tDocument.Version_
					$c(13,10)_"availability: "_tDocument.AvailabilityStatus_
					$c(13,10)_"creationtime: "_tDocument.CreationTime_
					$c(13,10)_"author: "_tAuthorPerson_
					$c(13,10)_"format: "_tDocument.FormatCode.Code_"["_tDocument.FormatCode.Description_"]"_
					$c(13,10)_"confidentialitycode: "_tConfidentialityCode_
					$c(13,10)_"healthcarefacilitytype: "_tDocument.HealthcareFacilityTypeCode.Code_"["_tDocument.HealthcareFacilityTypeCode.Description_"]"_
					$c(13,10)_"practicesetting: "_tDocument.PracticeSettingCode.Code_"["_tDocument.PracticeSettingCode.Description_"]"_
					$c(13,10)_"typecode: "_tDocument.TypeCode.Code_"["_tDocument.TypeCode.Description_"]"_
					$c(13,10)_"classcode: "_tDocument.ClassCode.Code_"["_tDocument.ClassCode.Description_"]"_
					$c(13,10)_"eventcodelist: "_tEventCode_
					$c(13,10)_"language: "_tDocument.LanguageCode_
					$c(13,10)_"mimetype: "_tDocument.MimeType
					
				Set label.title=title
				Do results.%AddChild(label)
			}
	 	}
	 	if $IsObject(tResponse) && (tResponse.Submissions.Count()) {
			For tIdx = 1:1:tResponse.Submissions.Count() {
				If tIdx=1 {
					Set label=##class(%ZEN.Component.label).%New()
					Set label.label="Submissions (hover on row for details):"
					Do results.%AddChild(label)
				}
				#dim tSubmission as HS.Message.IHE.XDSb.Submission
				Set tSubmission = tResponse.Submissions.GetAt(tIdx)
				Set tSourceIdCode = ##class(HS.Data.OIDMap).GetCodeForOID(tSubmission.SourceId,"(not found in oid registry)")
				Set tAuthorPerson = "(none)"
				If ($IsObject(tSubmission.Author))&&(tSubmission.Author.Count()>0) Set tAuthorPerson = tSubmission.Author.GetAt(1).AuthorPerson
				Set label=##class(%ZEN.Component.label).%New()
				Set label.label=tSubmission.UniqueId
				Set title="patientid:"_tSubmission.PatientId_
					$c(13,10)_"availability:"_tSubmission.AvailabilityStatus_
					$c(13,10)_"creationdate:"_tSubmission.SubmissionTime_
					$c(13,10)_"author:"_tAuthorPerson_
					$c(13,10)_"contenttypecode:"_tSubmission.ContentTypeCode.Code_"["_tSubmission.ContentTypeCode.Description_"]"_
					$c(13,10)_"sourceid:"_tSubmission.SourceId_"["_tSourceIdCode_"]"
					
				Set label.title=title
				Do results.%AddChild(label)
			}
	 	}
	}
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set tCombo=..%GetComponentById("cmbFormat")
	Set tCombo.valueList=",application/fhir+xml,application/fhir+json,xml,json,application/xml+fhir,application/json+fhir"
	Set tCombo.displayList=tCombo.valueList
	
	Set tCombo=..%GetComponentById("cmbVersion")
	Set tCombo.valueList="STU3,DSTU2"
	Set tCombo.displayList=tCombo.valueList
	
	Set tPatientId=$g(%session.Data("IHE.Test","PatientID"))
	Set tDocStatus=$g(%session.Data("IHE.Test",..%ClassName(0),"DocStatus"))
	Set tServiceRegistry=$g(%session.Data("IHE.Test",..%ClassName(0),"ServiceRegistry"))
	Set:tServiceRegistry="" tServiceRegistry=..#SERVICEREGISTRYENTRY
	Set tFHIRFormat=$g(%session.Data("IHE.Test",..%ClassName(0),"FHIRFormat"))
	Do ..%SetValueById("cmbFormat", tFHIRFormat)
	Set tFHIRVersion=$g(%session.Data("IHE.Test",..%ClassName(0),"FHIRVersion"))
	Do ..%SetValueById("cmbVersion", tFHIRVersion)
	
	Do ..SetLogging()
	Do ..AddRecentPatients("","cmbPatientID")
	If %page.TESTGROUPID]"" {
		Set tGroup = ##class(HS.Test.UI.TestGroup).%OpenId(%page.TESTGROUPID)
		Set tPatientId=tGroup.AdditionalInfo.GetAt("PatientID")
		Set tDocStatus=tGroup.AdditionalInfo.GetAt("DocStatus")
		Set tServiceRegistry=tGroup.AdditionalInfo.GetAt("ServiceRegistry")
		If $isObject(tGroup) Do ..PostAsyncExecuteDisplay(tGroup,1)
	}
	Do ..%SetValueById("txtPatientID",tPatientId)
	Do:tDocStatus]"" ..%SetValueById("cmbDocStatus",tDocStatus)
	Do:tServiceRegistry]"" ..%SetValueById("cmbServiceRegistry",tServiceRegistry)
	
	Set tCtrl("dtFromTime") = ""
	Set tCtrl("dtToTime") = ""
	Set tCtrl("txtAuthorFirst") = ""
	Set tCtrl("txtAuthorLast") = ""
	Set tCtrl("cmbFormatCode") = ""
	Set tCtrl("cmbConfidentialityCode") = ""
	Set tCtrl("cmbFacilityType") = ""
	Set tCtrl("cmbPracticeSetting") = ""
	Set tCtrl("cmbTypeCode") = ""
	Set tCtrl("cmbClass") = ""
	Set tCtrl("cmbEventCodeList") = ""
	Set tCtrl("txtRefIdList") = ""
	Set tCtrl("chkCodeOnly") = ""
	Set tCtrl = ""
	For {
		Set tCtrl = $Order(tCtrl(tCtrl))
		If tCtrl="" Quit
		Do ..%SetValueById(tCtrl, $g(%session.Data("IHE.Test",..%ClassName(0),tCtrl)))
	}
	
	Quit $$$OK
}

}
