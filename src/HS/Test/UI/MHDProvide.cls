Include HS.HC

Class HS.Test.UI.MHDProvide Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Provide Document Bundle";

Parameter SERVICEREGISTRYENTRY = "MHD.Recipient";

Parameter MHDPROVIDE As %Boolean = 1;

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

/// This XML block defines the contents of the IHE Test workflow pane.
XData Contents
{
<page title="HealthShare IHE Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<spacer height="10"/>
<text id="isFHIR" value="1" hidden="1" />
<vgroup id='DataSelection'>
<html>Step 1 - Please choose a data source for the patient (select one).</html>
<spacer height="10"/>
<form id='uploadForm' width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left" enctype="multipart/form-data">
<hgroup labelPosition="left">
<radioButton name="radType" optionValue="radCDAFile"/>
<fileUpload disabled="false" label="Upload Local CDA File:" name="txtCDAFile" id="txtCDAFile" size="20" />
</hgroup>
<spacer height="10"/>
<hgroup labelPosition="left">
<radioButton name="radType" id='radType' optionValue="radSampleCDA"/>
<text label="Use sample xdata block CDA" name="txtSampleCDA" disabled="false" size="80" value="xdata://HS.Test.UI.XDSbPnR:Sample" title="A generic sample xdata block available for use."/>
</hgroup>
<spacer height="10"/>
<hgroup labelPosition="left">
<radioButton name="radType" optionValue="radNonCDAFile"/>
<fileUpload disabled="false" label="Upload Local (non) CDA File:" name="txtNonCDAFile" id="txtNonCDAFile" size="20" />
</hgroup>
<spacer height="10"/>
<button id="btnUpload" caption=" Upload / generate document " onclick="zenPage.validateAndSubmit()" />
</form>
</vgroup>
<form id='frmOptions' hidden="true"  width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left" enctype="multipart/form-data">
<spacer height="5"/>
<html>Step 2 - Construct XDSb Provide and Register for conversion to MHD Provide Document Bundle</html>
<spacer height="5"/>
<checkbox label="Enable logging" name="chkLogging" id="chkLogging" title="Route traffic through tcp trace utility" hidden="1"/>
<combobox id="cmbFormat" label="FHIR Format:" size="22" tabIndex="10" title="Value to use for the _format URL parameter" />
<spacer width="5" />
<combobox id="cmbVersion" label="FHIR Version:" size="22" tabIndex="35" title="FHIR version to use" />
<spacer width="5" />
<combobox id="cmbPatientID" label=" Select Patient:" size="80" valueList="" displayList="" value="" onchange="zenPage.selectPatient();zenPage.populateSourcePatient();" />
<text label="Full Patient ID:" name="txtPatientID" id="txtPatientID" size="80" value="#(%page.PatientMRN)#^^^&amp;#(%page.PatientAA)#&amp;ISO" onchange="zenPage.updatePatientID(zenThis);"/>
<combobox id="cmbSourcePatientID" label=" Select Source Patient ID:" size="80" valueList="" displayList="" value="" onchange="zenPage.updateSourcePatientID();zenPage.updateSourceOID();"/>
<text label="Source Patient ID:" name="txtSourcePatientID2" id="txtSourcePatientID2" size="80" value="" title="Optional (if available in submitted cda) source patient id" onchange="zenPage.clearSourcePatientIDCombo();zenPage.updateSourceOID();"/>
<text label="Source OID:" name="txtSourceOID" id="txtSourceOID" size="80" />
<text label="Patient Resource URL:" name="txtResourceURL" id="txtResourceURL" size="80" title="Full URL that points to an existing FHIR Patient resource representing the XDS Affinity Domain Patient." />
<dataCombo id="cmbContentTypeCode" maxRows="10000" label="Content Type Code:" title="Does not map to any MHD FHIR property." sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" size="80" editable="true" searchKeyLen="10" OnCreateResultSet="CreateCodedEntryRS"><parameter value = 'ContentTypeCode'/></dataCombo>

<dataCombo id="cmbFormatCode" maxRows="10000" label="Format Code:" title="Maps to the MHD FHIR 'content.format' property." sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" size="80" editable="true" searchKeyLen="10" OnCreateResultSet="CreateCodedEntryRS"><parameter value = 'FormatCode'/></dataCombo>

<dataCombo id="cmbConfidentialityCode" maxRows="10000" label="Confidentiality Code:" title="Maps to the MHD FHIR 'securityLabel' property." sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" size="80" editable="true" searchKeyLen="10" valueColumn="1" OnCreateResultSet="CreateCodedEntryRS"><parameter value = 'ConfidentialityCode'/></dataCombo>
<dataCombo id="cmbHealthcareFacilityTypeCode" maxRows="10000" label="HealthcareFacilityType Code:" title="Maps to the MHD FHIR 'context.facilityType' property." sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" size="80" editable="true" searchKeyLen="10" OnCreateResultSet="CreateCodedEntryRS"><parameter value = 'HealthCareFacilityTypeCode'/></dataCombo>
<dataCombo id="cmbPracticeSettingCode" maxRows="10000" label="Practice Setting Code:" title="Maps to the MHD FHIR 'context.practiceSetting' property." sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" size="80" editable="true" searchKeyLen="10" OnCreateResultSet="CreateCodedEntryRS"><parameter value = 'PracticeSettingCode'/></dataCombo>
<dataCombo id="cmbTypeCode" maxRows="10000" label="Type Code:" title="Maps to the MHD FHIR 'type' property." sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" size="80" editable="true" searchKeyLen="10" OnCreateResultSet="CreateCodedEntryRS"><parameter value = 'TypeCode'/></dataCombo>
<dataCombo id="cmbClassCode" maxRows="10000" label="Class Code:" title="Maps to the MHD FHIR 'class' property." sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" size="80" editable="true" searchKeyLen="10" OnCreateResultSet="CreateCodedEntryRS"><parameter value = 'ClassCode'/></dataCombo>

<combobox id="cmbMimeType" label="MimeType:" title="Maps to the MHD FHIR 'content.attachment.contentType' property. This is the Mime Type of the document content, not the FHIR payload." size="80" valueList=",text/xml,text/plain,application/pdf,application/rtf,application/msword,image/jpef,image/gif" value='text/xml' />

<checkbox label="Include Folder:" id="chkFolder" title="Include an auto-created folder in the XDSb PnR request"/>

<text label="Document UniqueId:" name="txtDocUniqueId" id="txtDocUniqueId" title="Optional Document Entry UniqueId for testing OID^extension format. If a value is not specified here, then an OID value is auto-created upon generate of the XDSb PnR request." size="80"/>

<dataCombo id="cmbServiceRegistry" size='80' label="EndPoint: *" dropdownWidth="800" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	OnCreateResultSet="CreateServiceRegistryRS"
	maxRows="10000">
</dataCombo>

<checkbox caption="Deprecate all previously registered documents for this patient" name="deprecateDocs" id="chkDeprecateDocs" hidden="true"/>
<spacer height="15"/>
<hgroup width="40%" cellAlign="right">
<button id="btnSend" caption=" Generate XDSb PnR Request " onclick="zenPage.StartSend('btnSend',1);" />
<spacer width="5" />
<button id="btnCancel" caption=" Cancel " onclick="zenPage.cancel();" />
<spacer width="5" />
<button id="btnClear" caption=" Clear " onclick="zenPage.Clear();" />
<spacer width="5" />
</hgroup>
<hgroup width="100%" cellAlign="center">
<button id="btnGoPatientSearch" caption="View Patient in HealthShare Clinical Portal" onclick="zenPage.GoPatientSearch();" hidden='true'/>
</hgroup>
</form>
<vgroup>
<pane paneName="asyncPane"/>
</vgroup>
<pane id="paneResults"/>
</pane>
</page>
}

ClientMethod reload() [ Language = javascript ]
{
	window.location.reload();
}

ClientMethod validateAndSubmit() [ Language = javascript ]
{
	var rad = zenPage.getComponentById("radType").getValue();
	if (rad == 'radNonCDAFile') {
		if(zenPage.getComponentById("txtNonCDAFile").getValue()=='') {
			alert('Choose a file to submit');return;
		}
	} else if (rad=='radCDAFile') {
		if(zenPage.getComponentById("txtCDAFile").getValue()=='') {
			alert('Choose a file to submit');return;
		}
	}
	zenPage.getComponentById("uploadForm").submit();
}

ClientMethod selectPatient() [ Language = javascript ]
{
	patientID = zenPage.getComponentById("cmbPatientID").getValue();
	zenPage.getComponentById("txtPatientID").setValue(patientID);
}

Method cancel() [ ZenMethod ]
{
	Set tDocOID=$g(%session.Data("IHE.Test","PnRStream"))
	If tDocOID]"" {
		Do ##class(%Stream.GlobalCharacter).%Delete(tDocOID)
		kill %session.Data("IHE.Test","PnRStream")
	}
	&js<window.location.reload();>
}

ClientMethod Clear() [ Language = javascript ]
{
	zen('cmbPatientID').setValue("");
	zen('txtPatientID').setValue("");
	zen('cmbSourcePatientID').setValue("");
	zen('txtSourcePatientID2').setValue("");
	zen('txtSourceOID').setValue("");
	zen('txtResourceURL').setValue("");
	zen('cmbContentTypeCode').setValue("");
	zen('cmbFormatCode').setValue("");
	zen('cmbConfidentialityCode').setValue("");
	zen('cmbHealthcareFacilityTypeCode').setValue("");
	zen('cmbPracticeSettingCode').setValue("");
	zen('cmbTypeCode').setValue("");
	zen('cmbClassCode').setValue("");
	zen('cmbMimeType').setValue("");
	zen('chkFolder').setValue("");
	zen('txtDocUniqueId').setValue("");
	zenPage.ClearInputCache();
}

Method ClearInputCache() [ ZenMethod ]
{
	Set tCtrl("cmbSourcePatientID") = ""
	Set tCtrl("txtSourcePatientID2") = ""
	Set tCtrl("txtSourceOID") = ""
	Set tCtrl("txtResourceURL") = ""
	Set tCtrl("cmbContentTypeCode") = ""
	Set tCtrl("cmbFormatCode") = ""
	Set tCtrl("cmbConfidentialityCode") = ""
	Set tCtrl("cmbHealthcareFacilityTypeCode") = ""
	Set tCtrl("cmbPracticeSettingCode") = ""
	Set tCtrl("cmbTypeCode") = ""
	Set tCtrl("cmbClassCode") = ""
	Set tCtrl("cmbMimeType") = ""
	Set tCtrl("chkFolder") = ""
	Set tCtrl("txtDocUniqueId") = ""
	Set tCtrl = ""
	For {
		Set tCtrl = $Order(tCtrl(tCtrl))
		If tCtrl="" Quit
		Kill %session.Data("IHE.Test",..%ClassName(0),tCtrl)
	}
	Quit
}

ClientMethod GoPatientSearch() [ Language = javascript ]
{
	var patientID = zen('txtPatientID').getValue();
	var mRN = "";
	if (patientID) {
		//mRN = patientID.replace(/[\^&ISO]/g, "");
		mRN = patientID.substring(0, patientID.indexOf("^^^"));
	}
	var queryParam = "?MRN="+mRN;
	window.location="/csp/healthshare/HSACCESS/HS.UI.PatientSearch.cls"+queryParam;
}

Method onloadHandler() [ ZenMethod ]
{
	If $D(%session.Data("IHE.Test","PnRLogging")) Set %page.%GetComponentById("chkLogging").value=%session.Data("IHE.Test","PnRLogging")
	If $g(%session.Data("IHE.Test","PnRSubmitError"))]"" &js< alert('#(%session.Data("IHE.Test","PnRSubmitError"))#');>
	Kill %session.Data("IHE.Test","PnRSubmitError"),%session.Data("IHE.Test","PnRLogging")
}

Method populateSourcePatient() [ ZenMethod ]
{
	Set tPatientId = ..%GetValueById("txtPatientID")
	Do ..AddRecentPatientMRNAA(tPatientId,,"cmbSourcePatientID")
	Do ..%SetValueById("txtSourcePatientID2","")
	Do ..%SetValueById("txtSourceOID","")
	Do ..%SetValueById("cmbSourcePatientID","")
	Set tIndex = ""
	For {
		Set tIndex = $Order(%session.Data("IHE.Test","RecentPatients",tIndex))
		If tIndex="" Quit
		If $ListGet(%session.Data("IHE.Test","RecentPatients",tIndex),1)=tPatientId {
			Do ..%SetValueById("txtResourceURL",$ListGet(%session.Data("IHE.Test","RecentPatients",tIndex),3))
		}
	}
}

ClientMethod updateSourcePatientID() [ Language = javascript ]
{
	sourcePatientID = zenPage.getComponentById("cmbSourcePatientID").getValue();
	zenPage.getComponentById("txtSourcePatientID2").setValue(sourcePatientID);
}

ClientMethod clearSourcePatientIDCombo() [ Language = javascript ]
{
	zenPage.getComponentById("cmbSourcePatientID").setValue("");
}

Method updateSourceOID() [ ZenMethod ]
{
	// Get SourcePatientID from ComboBox and Text Field
	Set tSourcePatientID=..%GetValueById("txtSourcePatientID2")
	
	If tSourcePatientID'="" {
		Set tSourceOID = $p(tSourcePatientID,"&",2)
		Do %page.%SetValueById("txtSourceOID",tSourceOID)
	}
}

Method CreateCodedEntryRS(Output tSC As %Status, pInfo As %ZEN.Auxiliary.QueryInfo) As %ResultSet
{
	#; p1 is the typed text and p2 is the CodeType (any type of <parameter value=''/> setting 
	Set tSQL="select ID,(Code _' ['_ CodingScheme _'] '_ Description) as Description from HS_IHE.CodedEntry where ( %UPPER(Code _' ['_ CodingScheme _']') [ %UPPER(?) OR (? IS NULL)) AND CodeType=?"
	#; p3 is "exclude Deprecated codes"
	If $Get(pInfo.parms(3))=1 Set tSQL = tSQL_" AND Deprecated=0"
	Set tSQL = tSQL_" order by Code"
	Set tRS= ##class(%SQL.Statement).%ExecDirect("",tSQL,pInfo.parms(1),pInfo.parms(1),pInfo.parms(2))
	Set tSC=$S(tRS.SQLCODE=0:$$$OK,1:$$$ERROR($$$GeneralError,"SQLCODE:"_tRS.SQLCODE))
    Set pInfo.queryExecuted=1
	Quit tRS
}

Method Send() As %String [ ZenMethod ]
{
	try {
		set tSC = $$$OK,tSessionID=""
		
		set tFHIRVersion = %page.%GetValueById("cmbVersion")
		If tFHIRVersion="" &js< alert('FHIR Version is required');> Quit
		
		Set tSourcePatientID=..%GetValueById("txtSourcePatientID2")
		Set tSourceOID=..%GetValueById("txtSourceOID")
			//collect patient id from tester input
		Set tDocID=$g(%session.Data("IHE.Test","PnRStream"))
		set tStream=##class(%Stream.GlobalCharacter).%Open(tDocID)
		If '$isObject(tStream) || (tStream.Size=0) { 
			Set %session.Data("IHE.Test","PnRSubmitError")="Select a file"
			Quit
		}
		
		Set tPatientId = ..%GetValueById("txtPatientID")
		If (tPatientId="")&&(..#MHDPROVIDE=0) {
			Set %session.Data("IHE.Test","PnRSubmitError")="Select Patient"
		} Else {

			#;Put together a ProviderAndRegisterRequest
		    Set tRequest = ##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
		    if ..#MHDPROVIDE=1 do tRequest.AdditionalInfo.SetAt(..%GetValueById("txtResourceURL"),"ResourceUrl")
			if ..#MHDPROVIDE=1 do tRequest.AdditionalInfo.SetAt(..%GetValueById("cmbServiceRegistry"),"ServiceName")
			Set tRequest.PatientId=tPatientId
			Set tRequest.Title = "InterSystems SubmissionSet Title"
			Set tRequest.Comments = "InterSystems SubmissionSet Comments"
			#define getCodedEntry(%combo,%code,%required) Set %CodedEntry=##class(HS.IHE.CodedEntry).%OpenId(..%GetValueById(%combo)),%code="" Set:$isObject(%CodedEntry) %code=##class(HS.IHE.XDSb.Types.CodedValue).Create(%CodedEntry.Code,%CodedEntry.CodingScheme,%CodedEntry.Description) if %code="" && (%required) {&js<alert('No value found for #($p(%combo,"cmb",2))#');> Quit} else { Set %session.Data("IHETest",..%ClassName(0),%combo)=..%GetValueById(%combo) }
			#define insertCodedEntry(%object,%propertyName,%combo,%required) $$$getCodedEntry(%combo,%codedEntry,%required) If $isObject(%codedEntry) {Set property=$property(%object,%propertyName) Do property.Insert(%codedEntry)}
			#define setCodedEntry(%object,%propertyName,%combo,%required) $$$getCodedEntry(%combo,%codedEntry,%required) If $isObject(%codedEntry) {Set $property(%object,%propertyName)=%codedEntry}

			$$$setCodedEntry(tRequest,"ContentTypeCode","cmbContentTypeCode",1)

			Set tRequest.SourceId=tSourceOID
			Set tDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
			Set tDocument.Title = "InterSystems DocumentEntry Title"
			Set tDocument.Comments = "InterSystems DocumentEntry Comments"
			Set tDocument.EntryUUID = "urn:uuid:"_$ZConvert($system.Util.CreateGUID(),"L")
			Set tDocumentUniqueId = ..%GetValueById("txtDocUniqueId")
			If tDocumentUniqueId'="" {
				Set tDocument.UniqueId = tDocumentUniqueId
			} Else {
				Set tDocument.UniqueId = "2.25."_$system.Util.CreateDecimalGUID()
			}
			set tAuthor = ##class(HS.IHE.XDSb.Types.Author).%New()
    		set tAuthor.AuthorPerson = "^Smitty^Gerald^^^"
			set tSC= tDocument.Author.Insert(tAuthor)
			Do tRequest.Author.Insert(tAuthor)
			Set tDocument.SourcePatientId=tSourcePatientID
			Set:tDocument.SourcePatientId="" tDocument.SourcePatientId=tPatientId
			
			$$$setCodedEntry(tDocument,"FormatCode","cmbFormatCode",1)
			$$$insertCodedEntry(tDocument,"ConfidentialityCode","cmbConfidentialityCode",1)

			$$$setCodedEntry(tDocument,"HealthcareFacilityTypeCode","cmbHealthcareFacilityTypeCode",1)
			$$$setCodedEntry(tDocument,"PracticeSettingCode","cmbPracticeSettingCode",1)
			$$$setCodedEntry(tDocument,"TypeCode","cmbTypeCode",1)
			$$$setCodedEntry(tDocument,"ClassCode","cmbClassCode",1)

			Set tSlot = ##class(HS.IHE.XDSb.Types.Slot).%New()
			Set tSlot.Name = "urn:ihe:iti:xds:2013:referenceIdList"
			Set tSlotValue = ##class(HS.IHE.XDSb.Types.SlotValue).%New()
			Set tSlotValue.Value = "2013001^^^&1.2.3.4.5.6&ISO^urn:ihe:iti:xds:2013:accession"
			Do tSlot.ValueList.Insert(tSlotValue)
			Set tSlotValue = ##class(HS.IHE.XDSb.Types.SlotValue).%New()
			Set tSlotValue.Value = "2013002^^^&1.2.3.4.5.6&ISO^urn:ihe:iti:xds:2013:accession"
			Do tSlot.ValueList.Insert(tSlotValue)
			Do tDocument.DocumentSlots.Insert(tSlot)
			
			If tStream.%IsA("%Stream.GlobalBinary") {
				Do tDocument.Body.CopyFrom(tStream)
				Do tDocument.Body.Rewind()
				If tDocument.CreationTime="" Set tDocument.CreationTime=##class(HS.Util.XSLTHelper).xmltimestampToUTC($tr($zdt($h,8),": "))
				Set:tDocument.LanguageCode="" tDocument.LanguageCode="en-US"
				Set tDocument.Size = tDocument.Body.Size
				Set tDocument.Hash = ##class(HS.IHE.XDSb.Util).StreamHash(tDocument.Body)
			 
			} Else {
				Do tDocument.BodyCharacter.CopyFrom(tStream)
				Do tDocument.BodyCharacter.Rewind()
				If tDocument.CreationTime="" Set tDocument.CreationTime=##class(HS.Util.XSLTHelper).xmltimestampToUTC($tr($zdt($h,8),": "))
				Set:tDocument.LanguageCode="" tDocument.LanguageCode="en-US"
				Set tDocument.Size = tDocument.BodyCharacter.Size
				Set tDocument.Hash = ##class(HS.IHE.XDSb.Util).StreamHash(tDocument.BodyCharacter)
			}
			Set tDocument.MimeType=..%GetValueById("cmbMimeType")

			If tDocument.MimeType="" &js< alert('#($$$Text("MimeType is required"))#');> Quit
			Set tDocument.Availability=1
			Do tRequest.Documents.Insert(tDocument)
			Do tRequest.AdditionalInfo.SetAt("MHDSource"_tFHIRVersion,"FHIRActor")
			
			If ..%GetValueById("chkFolder") {
				Set tFolder = ##class(HS.Message.IHE.XDSb.Folder).%New()
				Set tFolder.EntryUUID = "urn:uuid:"_$ZConvert($system.Util.CreateGUID(),"L")
				Set tFolder.UniqueId = "2.25."_$system.Util.CreateDecimalGUID()
				Set tFolder.PatientId = tPatientId
				Set tFolder.AvailabilityStatus = "Approved"
				Set tFolder.LastUpdateTime = ##class(HS.Util.XSLTHelper).xmltimestampToUTC($tr($zdt($h,8),": "))
				Set tFolder.Comments = "InterSystems Document Folder Comments"
				Set tFolder.Title = "InterSystems Document Folder Title"
				Set tCodeValue = ##class(HS.IHE.XDSb.Types.CodedValue).%New("Referrals","1.3.6.1.4.1.21367.2017.3","Referrals")
				Do tFolder.CodeList.Insert(tCodeValue)
				Do tRequest.Folders.Insert(tFolder)
				Set tAssociation = ##class(HS.Message.IHE.XDSb.Association).Create("HasMember", tFolder.EntryUUID, tDocument.EntryUUID)
				Do tRequest.Associations.Insert(tAssociation)
			}
			
			set tFormat = %page.%GetValueById("cmbFormat")
			if (tFormat'="") { Do tRequest.AdditionalInfo.SetAt($ZConvert(tFormat,"L"),"_format") }
			
			Set %session.Data("IHE.Test",..%ClassName(0),"FHIRFormat")=tFormat
			Set %session.Data("IHE.Test",..%ClassName(0),"FHIRVersion")=tFHIRVersion
			
			Set tCodes = $lb("ContentTypeCode","FormatCode","ConfidentialityCode","HealthcareFacilityTypeCode","PracticeSettingCode","TypeCode","ClassCode","MimeType")
			For tIdx=1:1:$ll(tCodes) {
				Set tCode=$li(tCodes,tIdx)
				Set %session.Data("IHE.Test",..%ClassName(0),"cmb"_tCode) = ..%GetValueById("cmb"_tCode)
			}
			Set %session.Data("IHE.Test",..%ClassName(0),"chkFolder") = ..%GetValueById("chkFolder")
			
			Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
			Set tChkLogging = %page.%GetValueById("chkLogging")
			#; Disable logging for FHIR-related options.
			Set tChkLogging = 0
			Set tTest=tGroup.NewTest(tRequest,tChkLogging)
			Do tGroup.AdditionalInfo.SetAt(tRequest.PatientId,"PatientID")
			Do tGroup.AdditionalInfo.SetAt(tDocument.SourcePatientId,"SourcePatientID")
			Do tGroup.AdditionalInfo.SetAt(1,"DoNotReEnable")
			Set tSessionID = ..ExecuteAsync(tTest,tGroup)
		}
	} catch ex {
		Do ..LogMessage($zcvt(ex.DisplayString(),"O","HTML"),$g(tGroup))
	}
	Quit tSessionID
}

Method DisplayTestResult(pTest As HS.Test.UI.Test, pGroupTest As HS.Test.UI.TestGroup = "", pClear = 0)
{
	Do ##super(pTest,pGroupTest,pClear)
	Set tResponse=pTest.Response
	If $IsObject(tResponse) && $$$ISOK(pTest.Status) {
		If '$IsObject(tResponse.ContentStream) {
			Do ..LogMessage("Response message empty")
		} Else {
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tResponse.ContentStream,"/rs:RegistryResponse","@status",.tValue,.tParsedDoc)
			If $$$ISOK(tSC) {
				Do ..LogMessage("Status is:"_$zcvt(tValue,"O","HTML"))
				If tValue["Failure" {
					Set tSC = ##class(HS.IHE.Util).GetXPathValue(tResponse.ContentStream,"/rs:RegistryResponse/rs:RegistryErrorList/rs:RegistryError","@codeContext",.tValue,.tParsedDoc)
					Do ..LogMessage("Error is:"_$zcvt(tValue,"O","HTML"))
				} Else {
					Set tDocID=$g(%session.Data("IHE.Test","PnRStream"))
					If tDocID]"" {
						Kill %session.Data("IHE.Test","PnRStream")
						Do ##class(%Stream.GlobalCharacter).%DeleteId(tDocID)
					}
				}
				
			} Else {
				Do ..LogMessage("Unable to locate status"_tResponse.ContentStream.Read())
			}
		}
	}
}

/// This callback is called when a form on this page is submitted.
/// <var>pSubmit</var> is a <class>%ZEN.Submit</class> object
/// containing details of the form submit.<br/>
/// Upload CCD file content from client machine to server
ClassMethod %OnSubmit(pSubmit As %ZEN.Submit) As %Status
{
	Set tSourcePatientID=$G(%request.Data("$V_txtSourcePatientID",1))
	Set tType = $G(%request.Data("$V_radType",1))
	Set tStream=""
	Set tIsCDA=1
	
	Set %session.Data("IHE.Test",..%ClassName(0),"RadType")=tType
	Set tError=""
	If tType="radSampleCDA" {
		Set tSampleCDA = $G(%request.Data("$V_txtSampleCDA",1))
		Set tSC = ##class(HS.Test.TestCase).GetXDataAsStreamWithSubstitutions(tSampleCDA,.tStream) 
		If $$$ISERR(tSC) Set tError="Error locating xdata:"_tSampleCDA
	} Elseif tType="radCDAFile" {
		set tStream = %request.GetMimeData("$V_txtCDAFile")
	} Elseif tType="radNonCDAFile" {
		set tStream = %request.GetMimeData("$V_txtNonCDAFile")
		Set tIsCDA= 0
		
	} 
	
	Set %session.Data("IHE.Test","SourcePatientID")=tSourcePatientID
	if $isObject(tStream) {
		If tIsCDA {
			Set file = ##class(%Stream.GlobalCharacter).%New("^CacheTemp.IHETest")
		} Else {
			Set file = ##class(%Stream.GlobalBinary).%New("^CacheTemp.IHETest")
		}
		Do tStream.Rewind()
		Do file.CopyFrom(tStream)
		set tSC = file.%Save()
		if ($$$ISOK(tSC)) {
			Set %session.Data("IHE.Test","PnRStream")=file.%Oid()
		}
		Set %session.Data("IHE.Test","PnRSubmit")=1
	} Else {
		Set:tError="" tError="Select a file to upload"
		Set %session.Data("IHE.Test","PnRSubmitError")=tError
	}

	Quit $$$OK
}

ClassMethod AddPatientRequest(pStream, Output pSourcePatientID, pGlobalIdentifier) As %Status
{
	Set tSC = ##class(HS.IHE.XDSb.DocumentSource.Abstract).GetAddPatientRequest(pStream,.tAddRequest)
	If $g(%session.Data("IHE.Test","SAMLUsername"))'="" Set tAddRequest.RequestingUser = %session.Data("IHE.Test","SAMLUsername")
	If $$$ISERR(tSC) {
		Set %session.Data("IHE.Test","PnRSubmitError")="Error getting patient request from CDA"
		Quit tSC
	} 
	If tAddRequest.MRN="" || (tAddRequest.AssigningAuthority="") {
		Set %session.Data("IHE.Test","PnRSubmitError")="Patient MRN / Assigning Authority not located in CDA"
		Quit tSC
	}
	If tAddRequest.Facility]"" {
		Set tFAC = ##class(HS.Facility.Config).%OpenId(tAddRequest.Facility)
		Set tAddRequest.GatewayName=$S($isObject(tFAC):tFAC.Gateway.Name,1:"")
	}
	Set tSC = ##class(HS.Test.Service).SendSync(tAddRequest,.tAddResponse)
	If $$$ISERR(tSC) {
		Set %session.Data("IHE.Test","PnRSubmitError")="Error adding patient - "_$system.Status.GetErrorText(tSC)
		Quit tSC
	} 
	Set pSourcePatientID=tAddRequest.MRN_"^^^&"_##class(HS.Data.OIDMap).OIDForType(tAddRequest.AssigningAuthority)_"&ISO"
	Set pGlobalIdentifier=tAddResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO"
	Quit tSC
}

Method PopulateComboBoxes()
{
	#dim component as %ZEN.Component.combobox
	Set tCodes = $lb("ContentTypeCode","FormatCode","ConfidentialityCode","HealthcareFacilityTypeCode","PracticeSettingCode","TypeCode","ClassCode","MimeType")
	For tIdx=1:1:$ll(tCodes) {
		Set tCode=$li(tCodes,tIdx)
		Set tField = $p(tCode,"||")
		Set tID = $g(%session.Data("IHE.Test",..%ClassName(0),"cmb"_tField))
		If tID="" {
			Set tValue = ##class(HS.Registry.Config).GetKeyValue("\IHE\MHD\Default\"_$p(tCode,"||"),$p(tCode,"||",2,3))
			If tValue'="" {
				Set tResult = ##class(%SQL.Statement).%ExecDirect("","SELECT ID FROM HS_IHE.CodedEntry WHERE CodeType=? and Code=? and CodingScheme=?",$p(tCode,"||",1),$p(tValue,"||",1),$p(tValue,"||",2))
				if tResult.%Next() { 
					Set tID = tResult.ID
				}
			}
		}
		Do ..%SetValueById("cmb"_$p(tCode,"||"),tID)
	}
	Do ..%SetValueById("chkFolder", +$g(%session.Data("IHE.Test",..%ClassName(0), "chkFolder")))
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
	
	Set tFHIRFormat=$g(%session.Data("IHE.Test",..%ClassName(0),"FHIRFormat"))
	Do ..%SetValueById("cmbFormat", tFHIRFormat)
	Set tFHIRVersion=$g(%session.Data("IHE.Test",..%ClassName(0),"FHIRVersion"))
	Do ..%SetValueById("cmbVersion", tFHIRVersion)
	
	Set tServiceRegistry=$g(%session.Data("IHE.Test",..%ClassName(0),"ServiceRegistry"))
	Set:tServiceRegistry="" tServiceRegistry=..#SERVICEREGISTRYENTRY
	Set tRadType = $g(%session.Data("IHE.Test",..%ClassName(0),"RadType"),"radSampleCDA")
	Do ..%SetValueById("radType",tRadType)
	Do ..SetLogging()
	If $D(%session.Data("IHE.Test","LogTransactionsPage",1)) {
		Set %page.%GetComponentById("chkLogging").value=%session.Data("IHE.Test","LogTransactionsPage")
	}
	Do ..AddRecentPatients("","cmbPatientID")
	Do ..PopulateComboBoxes()
	Set tPatientID=$g(%session.Data("IHE.Test","PatientID"))
	Set tSourcePatientID=$g(%session.Data("IHE.Test","SourcePatientID"))
	Set tSourceOID=$p(tSourcePatientID,"&",2)
	
	If $G(%session.Data("IHE.Test","PnRSubmit"))=1 {
		Set %page.%GetComponentById("DataSelection").hidden=1
		Set %page.%GetComponentById("frmOptions").hidden=0
		Kill %session.Data("IHE.Test","PnRSubmit")
	}
	Set tDocID=$g(%session.Data("IHE.Test","PnRStream"))

	If %page.TESTGROUPID]"" {
		Set tGroup = ##class(HS.Test.UI.TestGroup).%OpenId(%page.TESTGROUPID)

		If $isObject(tGroup) {
			Set tServiceRegistry=tGroup.AdditionalInfo.GetAt("ServiceRegistry")
			Do ..DisplayGroupTestResult(tGroup)
			Set tValue=tGroup.AdditionalInfo.GetAt("PatientID")
			If tValue]"" Set tPatientID=tValue
			Set tValue=tGroup.AdditionalInfo.GetAt("SourcePatientID")
			If tValue]"" Set tSourcePatientID=tValue
		}
	}
	Do ..%SetValueById("txtPatientID",tPatientID)
	Do ..%SetValueById("cmbServiceRegistry",tServiceRegistry)
	
	Do %page.%SetValueById("txtSourcePatientID2",tSourcePatientID)
	Do %page.%SetValueById("txtSourceOID",tSourceOID)
	
	Quit $$$OK
}

XData Sample
{
<ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:hl7-org:v3">
<realmCode code="US" />
<!--Begin Document Header-->
<typeId extension="POCD_HD000040" root="2.16.840.1.113883.1.3" />
<!--(ISC3) REQUIRED:templateId-->
<templateId root="2.16.840.1.113883.10.20.3" />
<templateId root="2.16.840.1.113883.3.27.1776" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.1.1" />
<templateId root="2.16.840.1.113883.10.20.10" />
<templateId root="2.16.840.1.113883.10.20.20" />
<templateId root="2.16.840.1.113883.10.20.30" />
<templateId root="2.16.840.1.113883.3.88.11.32.1" />
<id assigningAuthorityName="InterSystems" extension="ISC_CORP_ANNOTATED_MODEL_CCD" root="2.16.840.1.113883.3.86" />
<code code="34133-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Summarization of episode note" />
<!--(ISC8) INFO:title-->
<title>InterSystems Corporation HealthShare Annotated Model CCD</title>
<!--(ISC2) REQUIRED:effectiveTime:xsi type-->
<effectiveTime value="20111020130945" />
<confidentialityCode />
<languageCode code="en-US" />
<recordTarget>
<patientRole>
<id assigningAuthorityName="InterSystems" extension="PAT0001" root="1.3.6.1.4.1.21367.2010.1.2.310" />
<addr use="HP">
<streetAddressLine>7 Woodlands Way</streetAddressLine>
<streetAddressLine>Apt. 24</streetAddressLine>
<city>Abington</city>
<state>MA</state>
<postalCode>02351</postalCode>
<country>USA</country>
</addr>
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
<telecom use="HP" value="tel:6472253133" />
<telecom use="WP" value="tel:8001111111;ext=1234" />
<telecom use="MC" value="tel:6472222222" />
<telecom value="mailto:test@intersystems.com" />
<patient>
<name>
<prefix />
<given>BOB</given>
<given>G</given>
<family>RUBLIC</family>
<suffix>III</suffix>
</name>
<administrativeGenderCode code="M" codeSystem="2.16.840.1.113883.5.1" codeSystemName="AdministrativeGenderCode" displayName="Male" />
<birthTime value="19780930000000" />
<maritalStatusCode code="M" codeSystem="2.16.840.1.113883.5.2" codeSystemName="MaritalStatus" displayName="Married" />
<religiousAffiliationCode code="1022" codeSystem="2.16.840.1.113883.5.1076" codeSystemName="religiousAffiliation" displayName="Independent" />
<raceCode code="2106-3" codeSystem="2.16.840.1.113883.6.238" codeSystemName="Race" displayName="White" />
<ethnicGroupCode code="2186-5" codeSystem="2.16.840.1.113883.6.238" codeSystemName="CDC Race and Ethnicity" displayName="Not Hispanic or                          Latino" />
<languageCommunication>
<templateId root="2.16.840.1.113883.3.88.11.83.2" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.2.1" />
<languageCode code="en-US" />
<preferenceInd value="true" />
</languageCommunication>
</patient>
</patientRole>
</recordTarget>
<!--(ISC10) INFO:author-->
<author typeCode="AUT">
<time value="20111020130945-0300" />
<assignedAuthor classCode="ASSIGNED">
<id nullFlavor="NI" />
<addr nullFlavor="NI" />
<telecom nullFlavor="NI" />
<assignedPerson>
<name nullFlavor="NI" />
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>Intersystems</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
</representedOrganization>
</assignedAuthor>
</author>
<!--(ISC10) INFO:author-->
<author typeCode="AUT">
<time value="20111020130945-0300" />
<assignedAuthor classCode="ASSIGNED">
<id nullFlavor="NI" />
<addr nullFlavor="NI" />
<telecom nullFlavor="NI" />
<assignedAuthoringDevice>
<softwareName>InterSystems HealthShare</softwareName>
</assignedAuthoringDevice>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
</representedOrganization>
</assignedAuthor>
</author>
<!--(ISC7) INFO:informant-->
<informant>
<assignedEntity>
<id nullFlavor="UNK" />
<addr nullFlavor="UNK" />
<telecom nullFlavor="UNK" />
<assignedPerson>
<name nullFlavor="UNK" />
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
</representedOrganization>
</assignedEntity>
</informant>
<custodian>
<assignedCustodian>
<representedCustodianOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom nullFlavor="UNK" />
<addr nullFlavor="UNK" />
</representedCustodianOrganization>
</assignedCustodian>
</custodian>
<legalAuthenticator contextControlCode="OP" typeCode="LA">
<time value="20111013142100-0300" />
<signatureCode code="s" />
<assignedEntity>
<id nullFlavor="UNK" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
<telecom use="WP" value="tel:+13122919000" />
<assignedPerson>
<name use="L">InterSystems Corp.</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
</representedOrganization>
</assignedEntity>
</legalAuthenticator>
<!--(ISC9) INFO:participant:typeCode='IND'-->
<participant typeCode="IND">
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.2.4" />
<associatedEntity classCode="NOK">
<code code="GRMTH" codeSystem="2.16.840.1.113883.5.111" codeSystemName="RoleCode" displayName="Grandmother" />
<addr use="HP">
<streetAddressLine>7 Woodlands Way</streetAddressLine>
<city>Abington</city>
<state>MA</state>
<postalCode>02351</postalCode>
<country>USA</country>
</addr>
<telecom use="HP" value="tel:6472253133" />
<associatedPerson>
<name>
<prefix />
<given>GRANNIE</given>
<given>P</given>
<family>RUBLIC</family>
<suffix />
</name>
</associatedPerson>
</associatedEntity>
</participant>
<!--(ISC9) INFO:participant:typeCode='IND'-->
<participant typeCode="IND">
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.2.4" />
<associatedEntity classCode="CAREGIVER">
<code code="STPDAU" codeSystem="2.16.840.1.113883.5.111" codeSystemName="RoleCode" displayName="Step-Daughter" />
<addr>
<streetAddressLine>1500 86th Street</streetAddressLine>
<city>Brooklyn</city>
<state>NY</state>
<postalCode>11228</postalCode>
<country>USA</country>
</addr>
<telecom use="HP" value="tel:+1-718-555-9856" />
<telecom use="WP" value="tel:+1-800-867-5309" />
<associatedPerson>
<name use="L">
<given>Jenny</given>
<family>Igotyournumber</family>
</name>
</associatedPerson>
</associatedEntity>
</participant>
<documentationOf typeCode="DOC">
<serviceEvent classCode="PCPR">
<id extension="123456789" root="2.16.840.1.113883.3.86" />
<!--(ISC6) REQUIRED:effectiveTime:xsi:type='IVL_TS'-->
<effectiveTime xsi:type="IVL_TS">
<low value="20120501" />
<high value="20120501" />
</effectiveTime>
<performer typeCode="PRF">
<templateId root="2.16.840.1.113883.3.88.11.83.4" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.2.3" />
<functionCode code="PP" codeSystem="2.16.840.1.113883.12.443" codeSystemName="HL7 Provider Role" displayName="Primary Care Provider">
<originalText>Primary Care Provider</originalText>
</functionCode>
<time>
<low nullFlavor="UNK" />
<high nullFlavor="UNK" />
</time>
<assignedEntity>
<id extension="BOMBAY" root="2.16.840.1.113883.3.86" />
<id assigningAuthorityName="National Provider Identifier" extension="000000" root="2.16.840.1.113883.4.6" />
<code code="200000000X" codeSystem="2.16.840.1.113883.6.101" codeSystemName="Provider Codes" displayName="Allopathic &amp; Osteopathic Physicians" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>HealthShare Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="HP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
</representedOrganization>
</assignedEntity>
</performer>
</serviceEvent>
</documentationOf>
<componentOf>
<encompassingEncounter>
<id extension="123456789" root="2.16.840.1.113883.3.86" />
<effectiveTime xsi:type="IVL_TS">
<low value="20120501" />
<high value="20120501" />
</effectiveTime>
</encompassingEncounter>
</componentOf>
<!--End Document Header-->
<component>
<structuredBody>
<!--Begin Allergies and Adverse Reactions Section-->
<component>
<section>
<templateId assigningAuthorityName="HITSP/C83" root="2.16.840.1.113883.3.88.11.83.102" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.3.13" />
<templateId assigningAuthorityName="HL7 CCD" root="2.16.840.1.113883.10.20.1.2" />
<code code="48765-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Allergies" />
<title>Allergies and Adverse Reactions</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Type</th>
<th>Substance</th>
<th>Reaction</th>
<th>Severity</th>
<th>Status</th>
</tr>
</thead>
<tbody>
<tr ID="ALGSUMMARY_1">
<td ID="ALGTYPE_1">Drug Allergy</td>
<td ID="ALGSUB_1">Penicillin</td>
<td ID="ALGREACT_1">Hives</td>
<td ID="ALGSEV_1">Moderate</td>
<td ID="ALGSTATUS_1">Active</td>
</tr>
<tr ID="ALGSUMMARY_2">
<td ID="ALGTYPE_2">Drug Intolerance</td>
<td ID="ALGSUB_2">Aspirin</td>
<td ID="ALGREACT_2">Wheezing</td>
<td ID="ALGSEV_2">Mild</td>
<td ID="ALGSTATUS_2">Active</td>
</tr>
<tr ID="ALGSUMMARY_3">
<td ID="ALGTYPE_3">Drug Intolerance</td>
<td ID="ALGSUB_3">Codeine</td>
<td ID="ALGREACT_3">Nausea</td>
<td ID="ALGSEV_3">Fatal</td>
<td ID="ALGSTATUS_3">Active</td>
</tr>
</tbody>
</table>
</text>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.27" />
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.6" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5.1" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5.3" />
<!--(ISC4) INFO:id:root-->
<id root="36e3e930-7b14-11db-9fe1-0800200c9a66" />
<code nullFlavor="NA" />
<!--(ISC15) WARNING:act[templateId='1.3.6.1.4.1.19376.1.5.3.1.4.5.3']/statusCode:-->
<statusCode code="active" />
<!--(ISC6) REQUIRED:effectiveTime:xsi:type='IVL_TS'-->
<effectiveTime xsi:type="IVL_TS">
<low nullFlavor="UNK" />
</effectiveTime>
<!--(ISC14) INFO:act[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5.3']/author-->
<author typeCode="AUT">
<time value="19990110000000-0300" />
<assignedAuthor classCode="ASSIGNED">
<id extension="BOMBAY" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86.3" />
<name>Intersystems-HealthShare</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
<entryRelationship inversionInd="false" typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.6" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.18" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.28" />
<id root="4adc1020-7b14-11db-9fe1-0800200c9a66" />
<!--(ISC11) INFO:observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.6']/code-->
<code code="416098002" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED-CT" displayName="Drug Allergy (disorder)" />
<!--(ISC6) REQUIRED:effectiveTime:xsi:type='IVL_TS'-->
<statusCode code="completed" />
<effectiveTime xsi:type="IVL_TS">
<low value="20010301" />
</effectiveTime>
<!--(ISC15) WARNING:statusCode:-->
<value code="70618" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED-CT" displayName="Allergy" xsi:type="CD">
<originalText>
<reference value="#ALGTYPE_1" />
</originalText>
</value>
<participant typeCode="CSM">
<participantRole classCode="MANU">
<playingEntity classCode="MMAT">
<!--(ISC18) INFO:participant[typeCode='CSM']/participantRole[classCode='MANU']/playingEntity[classCode='MMAT']/code-->
<code code="70618" codeSystem="2.16.840.1.113883.6.88" codeSystemName="RxNorm" displayName="Penicillin">
<originalText>
<reference value="#ALGSUB_1" />
</originalText>
</code>
<name>Penicillin</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship inversionInd="true" typeCode="MFST">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5" />
<templateId root="2.16.840.1.113883.10.20.1.54" />
<templateId root="2.16.840.1.113883.10.20.1.28" />
<!--(ISC4) INFO:id:root-->
<id root="444BB0A3-4916-4A8A-AF40-D63EE862EBC4" />
<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" />
<!--(ISC15) WARNING:statusCode:-->
<statusCode code="completed" />
<effectiveTime xsi:type="IVL_TS">
<low nullFlavor="UNK" />
<high nullFlavor="UNK" />
</effectiveTime>
<!--(ISC12) INFO:observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5']/value-->
<value code="247472004" codeSystem="2.16.840.1.113883.6.96" displayName="Hives" xsi:type="CD">
<originalText>
<reference value="#ALGREACT_1" />
</originalText>
</value>
<entryRelationship inversionInd="false" typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<templateId root="2.16.840.1.113883.10.20.1.50" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.1.1" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" displayName="Status" />
<text>
<reference value="#ALGSTATUS_1" />
</text>
<!--(ISC15) WARNING:statusCode:-->
<statusCode code="completed" />
<!--(ISC16) INFO:observation[templateId='1.3.6.1.4.1.19376.1.5.3.1.4.1.1']/value:-->
<value code="55561003" codeSystem="2.16.840.1.113883.6.96" displayName="Active" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.55" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.1" />
<code code="SEV" codeSystem="2.16.840.1.113883.5.4" codeSystemName="HL7 ActCode" displayName="Severity" />
<text>
<reference value="#ALGSEV_1" />
</text>
<!--(ISC15) WARNING:statusCode:-->
<statusCode code="completed" />
<!--(ISC52) INFO:entryRelationship[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.1']/value-->
<value code="6736007" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED-CT" displayName="Moderate" xsi:type="CD" />
</observation>
</entryRelationship>
</observation>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.6" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.27" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5.3" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5.1" />
<!--(ISC4) INFO:id:root-->
<id root="eb936010-7b17-11db-9fe1-0800200c9a66" />
<!--(ISC15) WARNING:act[templateId='1.3.6.1.4.1.19376.1.5.3.1.4.5.3']/statusCode:-->
<code nullFlavor="NA" />
<statusCode code="active" />
<!--(ISC6) REQUIRED:effectiveTime:xsi:type='IVL_TS'-->
<effectiveTime xsi:type="IVL_TS">
<low nullFlavor="UNK" />
</effectiveTime>
<!--(ISC14) INFO:act[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5.3']/author-->
<author typeCode="AUT">
<time value="20050612000000-0300" />
<assignedAuthor classCode="ASSIGNED">
<id nullFlavor="UNK" />
<code nullFlavor="UNK" />
<addr nullFlavor="UNK" />
<telecom nullFlavor="UNK" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Breathe</given>
<family>Easy</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id nullFlavor="UNK" />
<name>HealthShare Heart and Lung Clinic</name>
<telecom nullFlavor="UNK" />
<addr nullFlavor="UNK" />
</representedOrganization>
</assignedAuthor>
</author>
<entryRelationship inversionInd="false" typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.6" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.28" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.18" />
<id root="628F5BA8-FB64-482B-AB43-B5593DEB0C04" />
<!--(ISC11) INFO:observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.6']/code-->
<code code="419511003" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="propensity to adverse reactions to drug" />
<text>
<reference value="#ALGSUMMARY_2" />
</text>
<!--(ISC15) WARNING:statusCode:-->
<statusCode code="completed" />
<!--(ISC6) REQUIRED:effectiveTime:xsi:type='IVL_TS'-->
<effectiveTime xsi:type="IVL_TS">
<low value="19980101" />
</effectiveTime>
<value code="70618" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED-CT" displayName="Allergy" xsi:type="CD">
<originalText>
<reference value="#ALGTYPE_2" />
</originalText>
</value>
<participant typeCode="CSM">
<participantRole classCode="MANU">
<playingEntity classCode="MMAT">
<!--(ISC18) INFO:participant[typeCode='CSM']/participantRole[classCode='MANU']/playingEntity[classCode='MMAT']/code-->
<code code="1191" codeSystem="2.16.840.1.113883.6.88" codeSystemName="RxNorm" displayName="Aspirin">
<originalText>
<reference value="#ALGSUB_2" />
</originalText>
</code>
<name>Aspirin</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship inversionInd="false" typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<templateId root="2.16.840.1.113883.10.20.1.50" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.1.1" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" displayName="Status" />
<text>
<reference value="#ALGSTATUS_2" />
</text>
<!--(ISC15) WARNING:statusCode:-->
<statusCode code="completed" />
<!--(ISC16) INFO:observation[templateId='1.3.6.1.4.1.19376.1.5.3.1.4.1.1']/value:-->
<value code="55561003" codeSystem="2.16.840.1.113883.6.96" displayName="Active" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="MFST">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5" />
<templateId root="2.16.840.1.113883.10.20.1.54" />
<templateId root="2.16.840.1.113883.10.20.1.28" />
<!--(ISC4) INFO:id:root-->
<id root="8C8DBA00-3EDD-4B3C-9C53-D3B345883E04" />
<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" />
<!--(ISC15) WARNING:statusCode:-->
<statusCode code="completed" />
<!--(ISC6) REQUIRED:effectiveTime:xsi:type='IVL_TS'-->
<effectiveTime xsi:type="IVL_TS">
<low nullFlavor="UNK" />
<high nullFlavor="UNK" />
</effectiveTime>
<!--(ISC12) INFO:observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5']/value-->
<value code="272040008" codeSystem="2.16.840.1.113883.6.96" displayName="Wheezing" xsi:type="CD">
<originalText>
<reference value="#ALGREACT_2" />
</originalText>
</value>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.55" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.1" />
<code code="SEV" codeSystem="2.16.840.1.113883.5.4" codeSystemName="HL7 ActCode" displayName="Severity" />
<text>
<reference value="#ALGSEV_2" />
</text>
<!--(ISC15) WARNING:statusCode:-->
<statusCode code="completed" />
<!--(ISC52) INFO:entryRelationship[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.1']/value-->
<value code="255604002" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED-CT" displayName="Mild" xsi:type="CD" />
</observation>
</entryRelationship>
</observation>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.6" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.27" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5.3" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5.1" />
<!--(ISC4) INFO:id:root-->
<id root="c3df3b61-7b18-11db-9fe1-0800200c9a66" />
<code nullFlavor="NA" />
<!--(ISC15) WARNING:act[templateId='1.3.6.1.4.1.19376.1.5.3.1.4.5.3']/statusCode:-->
<statusCode code="completed" />
<!--(ISC6) REQUIRED:effectiveTime:xsi:type='IVL_TS'-->
<effectiveTime xsi:type="IVL_TS">
<low value="20051201" />
<high nullFlavor="UNK" />
</effectiveTime>
<!--(ISC14) INFO:act[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5.3']/author-->
<author typeCode="AUT">
<time value="19990110000000-0300" />
<assignedAuthor classCode="ASSIGNED">
<id extension="BOMBAY" root="2.16.840.1.113883.3.86.3" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86.3" />
<name>InterSystems-HealthShare</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
<entryRelationship inversionInd="false" typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.18" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.28" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.6" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.18" />
<id root="c3df3b60-7b18-11db-9fe1-0800200c9a66" />
<!--(ISC11) INFO:observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.6']/code-->
<code code="59037007" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="drug intolerance" />
<text>
<reference value="#ALGSUMMARY_3" />
</text>
<statusCode code="completed" />
<!--(ISC6) REQUIRED:effectiveTime:xsi:type='IVL_TS'-->
<effectiveTime xsi:type="IVL_TS">
<low value="20051201" />
</effectiveTime>
<value code="70618" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED-CT" displayName="Allergy" xsi:type="CD">
<originalText>
<reference value="#ALGTYPE_3" />
</originalText>
</value>
<participant typeCode="CSM">
<participantRole classCode="MANU">
<addr nullFlavor="UNK" />
<telecom nullFlavor="UNK" />
<playingEntity classCode="MMAT">
<!--(ISC18) INFO:participant[typeCode='CSM']/participantRole[classCode='MANU']/playingEntity[classCode='MMAT']/code-->
<code code="2670" codeSystem="2.16.840.1.113883.6.88" codeSystemName="RxNorm" displayName="Codeine">
<originalText>
<reference value="#ALGSUB_3" />
</originalText>
</code>
<name>Codeine</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship inversionInd="false" typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<templateId root="2.16.840.1.113883.10.20.1.50" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.1.1" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" displayName="Status" />
<text>
<reference value="#ALGSTATUS_3" />
</text>
<!--(ISC15) WARNING:statusCode:-->
<statusCode code="completed" />
<!--(ISC16) INFO:observation[templateId='1.3.6.1.4.1.19376.1.5.3.1.4.1.1']/value:-->
<value code="55561003" codeSystem="2.16.840.1.113883.6.96" displayName="Active" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="MFST">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5" />
<templateId root="2.16.840.1.113883.10.20.1.54" />
<templateId root="2.16.840.1.113883.10.20.1.28" />
<id nullFlavor="UNK" />
<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" />
<text nullFlavor="UNK" />
<statusCode code="completed" />
<!--(ISC6) REQUIRED:effectiveTime:xsi:type='IVL_TS'-->
<effectiveTime xsi:type="IVL_TS">
<low nullFlavor="UNK" />
<high nullFlavor="UNK" />
</effectiveTime>
<!--(ISC12) INFO:observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5']/value-->
<value code="73879007" codeSystem="2.16.840.1.113883.6.96" displayName="Nausea" xsi:type="CD">
<originalText>
<reference value="#ALGREACT_3" />
</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.55" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.1" />
<code code="SEV" codeSystem="2.16.840.1.113883.5.4" codeSystemName="HL7 ActCode" displayName="Severity" />
<text>
<reference value="#ALGSEV_3" />
</text>
<statusCode code="completed" />
<!--(ISC52) INFO:entryRelationship[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.1']/value-->
<value code="255604002" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED-CT" displayName="Mild" xsi:type="CD" />
</observation>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
</section>
</component>
<!--End Allergies and Adverse Reactions Section-->
<!--Begin Problems Section-->
<component>
<section>
<templateId assigningAuthorityName="HITSP/C83" root="2.16.840.1.113883.3.88.11.83.103" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.3.6" />
<templateId assigningAuthorityName="HL7 CCD" root="2.16.840.1.113883.10.20.1.11" />
<code code="11450-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Problem list" />
<title>Problems</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Problem</th>
<th>Effective Dates</th>
<th>Problem Status</th>
</tr>
</thead>
<tbody>
<tr ID="PROBSUMMARY_1">
<td ID="PROBKIND_1">Asthma, Exercise Induced</td>
<td>1950</td>
<td ID="PROBSTATUS_1">Active</td>
</tr>
<tr ID="PROBSUMMARY_2">
<td ID="PROBKIND_2">Pneumonia</td>
<td>Jan 1997</td>
<td ID="PROBSTATUS_2">Resolved</td>
</tr>
<tr ID="PROBSUMMARY_3">
<td ID="PROBKIND_3">Pneumonia</td>
<td>Mar 1999</td>
<td ID="PROBSTATUS_3">Resolved</td>
</tr>
<tr ID="PROBSUMMARY_4">
<td ID="PROBKIND_4">Myocardial Infarction</td>
<td>Jan 1997</td>
<td ID="PROBSTATUS_4">Resolved</td>
</tr>
</tbody>
</table>
</text>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.7" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.27" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5.1" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5.2" />
<id root="6a2fa88d-4174-4909-aece-db44b60a3abb" />
<code nullFlavor="NA" />
<statusCode code="completed" />
<!--(ISC6) REQUIRED:effectiveTime:xsi:type='IVL_TS'-->
<!--(ISC45) INFO:act[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5.2']/effectiveTime-->
<effectiveTime xsi:type="IVL_TS">
<low nullFlavor="UNK" />
<high nullFlavor="UNK" />
</effectiveTime>
<!--(ISC46) INFO:templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.4.5.2']/author-->
<author typeCode="AUT">
<time value="20111020090700-0300" />
<assignedAuthor classCode="ASSIGNED">
<id extension="EASY" root="2.16.840.1.113883.3.86.3.1" />
<addr nullFlavor="UNK" />
<telecom nullFlavor="UNK" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Breathe</given>
<family>Easy</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86.3.1" />
<name>HealthShare Respiratory Therapy</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
<entryRelationship inversionInd="false" typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.28" />
<id root="d11275e7-67ae-11db-bd13-0800200c9a66" />
<code code="64572001" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED-CT" displayName="Condition" />
<!--(ISC42) INFO:entryRelationship/observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5']/text-->
<text>
<reference value="#PROBKIND_1" />
</text>
<statusCode code="completed" />
<!--(ISC6) REQUIRED:effectiveTime:xsi:type='IVL_TS'-->
<!--(ISC44) INFO:entryRelationship/observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5']/effectiveTime-->
<effectiveTime xsi:type="IVL_TS">
<low value="19500101" />
<high nullFlavor="UNK" />
</effectiveTime>
<!--(ISC43) INFO:entryRelationship/observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5']/value-->
<value code="195967001" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED" displayName="Asthma" xsi:type="CD" />
<entryRelationship inversionInd="false" typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<templateId root="2.16.840.1.113883.10.20.1.50" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.1.1" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" displayName="Status" />
<text>
<reference value="#PROBSTATUS_1" />
</text>
<statusCode code="completed" />
<!--(ISC41) INFO:observation[templateId/@root='2.16.840.1.113883.10.20.1.50']/value-->
<value code="55561003" codeSystem="2.16.840.1.113883.6.96" displayName="Active" xsi:type="CE" />
</observation>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.7" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.27" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5.1" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5.2" />
<id root="ec8a6ff8-ed4b-4f7e-82c3-e98e58b45de7" />
<code nullFlavor="NA" />
<statusCode code="completed" />
<!--(ISC6) REQUIRED:effectiveTime:xsi:type='IVL_TS'-->
<!--(ISC45) INFO:act[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5.2']/effectiveTime-->
<effectiveTime xsi:type="IVL_TS">
<low nullFlavor="UNK" />
<high nullFlavor="UNK" />
</effectiveTime>
<!--(ISC46) INFO:templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.4.5.2']/author-->
<author typeCode="AUT">
<time value="19970101000000-0300" />
<assignedAuthor classCode="ASSIGNED">
<id extension="BOMBAY" root="2.16.840.1.113883.3.86.3" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86.3" />
<name>InterSystems-HealthShare</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
<entryRelationship inversionInd="false" typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.28" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5" />
<id root="ab1791b0-5c71-11db-b0de-0800200c9a66" />
<code code="64572001" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED-CT" displayName="Condition" />
<!--(ISC42) INFO:entryRelationship/observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5']/text-->
<text>
<reference value="#PROBKIND_2" />
</text>
<statusCode code="completed" />
<!--(ISC6) REQUIRED:effectiveTime:xsi:type='IVL_TS'-->
<!--(ISC44) INFO:entryRelationship/observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5']/effectiveTime-->
<effectiveTime xsi:type="IVL_TS">
<low value="19970101" />
<high value="19970101" />
</effectiveTime>
<!--(ISC43) INFO:entryRelationship/observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5']/value-->
<value code="233604007" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED" displayName="Pneumonia" xsi:type="CD" />
<entryRelationship inversionInd="false" typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<templateId root="2.16.840.1.113883.10.20.1.50" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.1.1" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" displayName="Status" />
<text>
<reference value="#PROBSTATUS_2" />
</text>
<statusCode code="completed" />
<!--(ISC41) INFO:observation[templateId/@root='2.16.840.1.113883.10.20.1.50']/value-->
<value code="413322009" codeSystem="2.16.840.1.113883.6.96" displayName="Resolved" xsi:type="CE" />
</observation>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.7" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.27" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5.1" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5.2" />
<id root="d11275e9-67ae-11db-bd13-0800200c9a66" />
<code nullFlavor="NA" />
<statusCode code="completed" />
<!--(ISC6) REQUIRED:effectiveTime:xsi:type='IVL_TS'-->
<!--(ISC45) INFO:act[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5.2']/effectiveTime-->
<effectiveTime xsi:type="IVL_TS">
<low nullFlavor="UNK" />
<high nullFlavor="UNK" />
</effectiveTime>
<!--(ISC46) INFO:templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.4.5.2']/author-->
<author typeCode="AUT">
<time value="19990301000000-0300" />
<assignedAuthor classCode="ASSIGNED">
<id extension="BOMBAY" root="2.16.840.1.113883.3.86.3" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86.3" />
<name>InterSystems-HealthShare</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
<entryRelationship inversionInd="false" typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.28" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5" />
<id root="9d3d416d-45ab-4da1-912f-4583e0632000" />
<code code="64572001" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED-CT" displayName="Condition" />
<!--(ISC42) INFO:entryRelationship/observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5']/text-->
<text>
<reference value="#PROBKIND_3" />
</text>
<statusCode code="completed" />
<!--(ISC6) REQUIRED:effectiveTime:xsi:type='IVL_TS'-->
<!--(ISC44) INFO:entryRelationship/observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5']/effectiveTime-->
<effectiveTime xsi:type="IVL_TS">
<low value="19990301" />
<high value="19990301" />
</effectiveTime>
<!--(ISC43) INFO:entryRelationship/observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5']/value-->
<value code="233604007" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED" displayName="Pneumonia" xsi:type="CD" />
<entryRelationship inversionInd="false" typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<templateId root="2.16.840.1.113883.10.20.1.50" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.1.1" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" displayName="Status" />
<text>
<reference value="#PROBSTATUS_3" />
</text>
<statusCode code="completed" />
<!--(ISC41) INFO:observation[templateId/@root='2.16.840.1.113883.10.20.1.50']/value-->
<value code="413322009" codeSystem="2.16.840.1.113883.6.96" displayName="Resolved" xsi:type="CE" />
</observation>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.7" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.27" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5.1" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5.2" />
<id root="5a2c903c-bd77-4bd1-ad9d-452383fbfefa" />
<code nullFlavor="NA" />
<statusCode code="completed" />
<!--(ISC6) REQUIRED:effectiveTime:xsi:type='IVL_TS'-->
<!--(ISC45) INFO:act[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5.2']/effectiveTime-->
<effectiveTime xsi:type="IVL_TS">
<low nullFlavor="UNK" />
<high nullFlavor="UNK" />
</effectiveTime>
<!--(ISC46) INFO:templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.4.5.2']/author-->
<author typeCode="AUT">
<time value="19970101000000-0300" />
<assignedAuthor classCode="ASSIGNED">
<id extension="BOMBAY" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>HealthShare Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
<entryRelationship inversionInd="false" typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="HL7 CCD" root="2.16.840.1.113883.10.20.1.28" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.5" />
<id root="107c2dc0-67a5-11db-bd13-0800200c9aac" />
<code code="64572001" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED-CT" displayName="Condition" />
<!--(ISC42) INFO:entryRelationship/observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5']/text-->
<text>
<reference value="#PROBKIND_4" />
</text>
<statusCode code="completed" />
<!--(ISC6) REQUIRED:effectiveTime:xsi:type='IVL_TS'-->
<!--(ISC44) INFO:entryRelationship/observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5']/effectiveTime-->
<effectiveTime xsi:type="IVL_TS">
<low value="19970101" />
<high value="19970101" />
</effectiveTime>
<!--(ISC43) INFO:entryRelationship/observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5']/value-->
<value code="22298006" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED" displayName="Myocardial infarction" xsi:type="CD" />
<entryRelationship inversionInd="false" typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<templateId root="2.16.840.1.113883.10.20.1.50" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" displayName="Status" />
<text>
<reference value="#PROBSTATUS_4" />
</text>
<statusCode code="completed" />
<!--(ISC41) INFO:observation[templateId/@root='2.16.840.1.113883.10.20.1.50']/value-->
<value code="413322009" codeSystem="2.16.840.1.113883.6.96" displayName="Resolved" xsi:type="CE" />
</observation>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
</section>
</component>
<!--End Problems Section-->
<!--Begin Medications Section-->
<component>
<section>
<templateId assigningAuthorityName="HITSP/C83" root="2.16.840.1.113883.3.88.11.83.112" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.3.19" />
<templateId assigningAuthorityName="HL7 CCD" root="2.16.840.1.113883.10.20.1.8" />
<code code="10160-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="History of medication use" />
<title>Medications</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Medication</th>
<th>Dose</th>
<th>Form</th>
<th>Route</th>
<th>Sig Text</th>
<th>Dates</th>
<th>Status</th>
</tr>
</thead>
<tbody>
<tr ID="MEDSUMMARY_1">
<td ID="MEDNAME_1">Albuterol inhalant</td>
<td ID="MEDDOSE_1">2 puffs</td>
<td ID="MEDFORM_1">inhaler</td>
<td ID="MEDROUTE_1">inhalation</td>
<td ID="SIGTXT_1">2 puffs QID PRN (as needed for wheezing)</td>
<td>July 2005+</td>
<td ID="MEDSTATUS_1">Active</td>
</tr>
<tr ID="MEDSUMMARY_2">
<td ID="MEDNAME_2">clopidogrel (Plavix)</td>
<td ID="MEDDOSE_2">75 mg</td>
<td ID="MEDFORM_2">tablet</td>
<td ID="MEDROUTE_2">oral</td>
<td ID="SIGTXT_2">75mg PO daily</td>
<td>unknown</td>
<td ID="MEDSTATUS_2">Active</td>
</tr>
<tr ID="MEDSUMMARY_3">
<td ID="MEDNAME_3">metoprolol</td>
<td ID="MEDDOSE_3">25 mg</td>
<td ID="MEDFORM_3">tablet</td>
<td ID="MEDROUTE_3">oral</td>
<td ID="SIGTXT_3">25mg PO BID</td>
<td>Nov 2007+</td>
<td ID="MEDSTATUS_3">Active</td>
</tr>
<tr ID="MEDSUMMARY_4">
<td ID="MEDNAME_4">prednisone (Deltasone)</td>
<td ID="MEDDOSE_4">20 mg</td>
<td ID="MEDFORM_4">tablet</td>
<td ID="MEDROUTE_4">oral</td>
<td ID="SIGTXT_4">20mg PO daily</td>
<td>Mar 28, 2000+</td>
<td ID="MEDSTATUS_4">Active</td>
</tr>
<tr ID="MEDSUMMARY_5">
<td ID="MEDNAME_5">cephalexin (Keflex)</td>
<td ID="MEDDOSE_5">500 mg</td>
<td ID="MEDFORM_5">tablet</td>
<td ID="MEDROUTE_5">oral</td>
<td ID="SIGTXT_5">500mg PO QID x 7 days (for bronchitis)</td>
<td>Mar-Apr 2000</td>
<td ID="MEDSTATUS_5">Completed</td>
</tr>
</tbody>
</table>
</text>
<entry typeCode="DRIV">
<substanceAdministration classCode="SBADM" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.8" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.24" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.7" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.7.1" />
<id root="cdbd33f0-6cde-11db-9fe1-0800200c9a66" />
<text>
<reference value="#SIGTEXT_1" />
</text>
<statusCode code="completed" />
<!--(ISC6) REQUIRED:effectiveTime:xsi:type='IVL_TS'-->
<!--(ISC39) INFO:hl7:substanceAdministration[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7/effectiveTime:xsi:type='IVL_TS'-->
<!--(ISC38) WARNING:hl7:substanceAdministration[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7/effectiveTime:xsi:type='IVL_TS'-->
<effectiveTime xsi:type="IVL_TS">
<low value="20050612000000-0300" />
</effectiveTime>
<!--(ISC40) INFO:hl7:substanceAdministration[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7/effectiveTime:xsi:type='PIVL_TS'-->
<effectiveTime institutionSpecified="false" operator="A" xsi:type="PIVL_TS">
<period unit="h" value="6" />
</effectiveTime>
<!--(ISC37) INFO:routeCode-->
<routeCode code="C38216" codeSystem="2.16.840.1.113883.3.26.1.1" codeSystemName="NCI - FDA RouteOfAdministration" displayName="Respiratory (Inhalation)">
<originalText>
<reference value="#MEDROUTE_1" />
</originalText>
<translation code="IPINHL" codeSystem="2.16.840.1.113883.5.112" codeSystemName="HL7 RouteOfAdministration" displayName="Inhalation, oral" />
</routeCode>
<!--(ISC36) INFO:doseQuantity-->
<doseQuantity>
<low unit="puffs" value="2" />
<high unit="puffs" value="2" />
</doseQuantity>
<!--(ISC53) INFO:administrationUnitCode-->
<administrationUnitCode code="C42944" codeSystem="2.16.840.1.113883.3.26.1.1" codeSystemName="NCI - FDA Dosage Forms" displayName="Inhalant">
<originalText>
<reference value="#MEDFORM_1" />
</originalText>
</administrationUnitCode>
<consumable>
<manufacturedProduct>
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.8.2" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.53" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.7.2" />
<!--(ISC35) INFO:manufacturedProduct/templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.4.7.2']/manufacturedMaterial-->
<manufacturedMaterial>
<code code="307782" codeSystem="2.16.840.1.113883.6.88" codeSystemName="RxNorm" displayName="Albuterol 0.09 MG/ACTUAT inhalant solution">
<originalText>
<reference value="#MEDNAME_1" />
</originalText>
</code>
<name>Albuterol Inhalent</name>
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
<author typeCode="AUT">
<time value="20050610000000-0300" />
<assignedAuthor classCode="ASSIGNED">
<id extension="EASY" root="2.16.840.1.113883.3.86.3.1" />
<addr nullFlavor="UNK" />
<telecom nullFlavor="UNK" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Breathe</given>
<family>Easy</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86.3.1" />
<name>HealthShare Heart and Lung Clinic</name>
<telecom nullFlavor="UNK" />
<addr nullFlavor="UNK" />
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
<entryRelationship typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.8.1" />
<code code="73639000" codeSystem="2.16.840.1.113883.6.96" displayName="Prescription Drug" />
</observation>
</entryRelationship>
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<templateId root="2.16.840.1.113883.10.20.1.47" />
<id nullFlavor="UNK" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="55561003" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="Active" xsi:type="CE">
<originalText>
<reference value="#MEDSTATUS_1" />
</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship inversionInd="false" typeCode="REFR">
<sequenceNumber nullFlavor="UNK" />
<supply classCode="SPLY" moodCode="INT">
<templateId root="2.16.840.1.113883.10.20.1.34" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.7.3" />
<id root="92D997EE-7B87-4BAF-8A3E-C497F08B2342" />
<repeatNumber value="3" />
<!--(ISC34) INFO:supply[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7.3']/author-->
<author typeCode="AUT">
<time value="20050610000000-0300" />
<assignedAuthor classCode="ASSIGNED">
<id extension="EASY" root="2.16.840.1.113883.3.86.3.1" />
<addr nullFlavor="UNK" />
<telecom nullFlavor="UNK" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Breathe</given>
<family>Easy</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86.3.1" />
<name>HealthShare Heart and Lung Clinic</name>
<telecom nullFlavor="UNK" />
<addr nullFlavor="UNK" />
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
</supply>
</entryRelationship>
</substanceAdministration>
</entry>
<entry typeCode="DRIV">
<substanceAdministration classCode="SBADM" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.8" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.24" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.7" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.7.1" />
<id root="cdbd5b05-6cde-11db-9fe1-0800200c9a66" />
<text>
<reference value="#SIGTEXT_2" />
</text>
<statusCode code="completed" />
<!--REQUIRED:effectiveTime:xsi type-->
<!--(ISC39) INFO:hl7:substanceAdministration[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7/effectiveTime:xsi:type='IVL_TS'-->
<!--(ISC38) WARNING:hl7:substanceAdministration[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7/effectiveTime:xsi:type='IVL_TS'-->
<effectiveTime xsi:type="IVL_TS">
<low value="20111020" />
<high nullFlavor="UNK" />
</effectiveTime>
<!--(ISC40) INFO:hl7:substanceAdministration[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7/effectiveTime:xsi:type='PIVL_TS'-->
<effectiveTime institutionSpecified="false" operator="A" xsi:type="PIVL_TS">
<period unit="h" value="24" />
</effectiveTime>
<!--(ISC37) INFO:routeCode-->
<routeCode code="C38288" codeSystem="2.16.840.1.113883.3.26.1.1" codeSystemName="NCI - FDA RouteOfAdministration" displayName="Oral">
<originalText>
<reference value="#MEDROUTE_2" />
</originalText>
<translation code="PO" codeSystem="2.16.840.1.113883.5.112" codeSystemName="HL7 RouteOfAdministration" displayName="Swallow, oral" />
</routeCode>
<!--(ISC36) INFO:doseQuantity-->
<doseQuantity>
<low unit="mg" value="75" />
<high unit="mg" value="75" />
</doseQuantity>
<!--(ISC53) INFO:administrationUnitCode-->
<administrationUnitCode code="C42998" codeSystem="2.16.840.1.113883.3.26.1.1" codeSystemName="NCI - FDA Dosage Forms" displayName="Tablet">
<originalText>
<reference value="#MEDFORM_2" />
</originalText>
</administrationUnitCode>
<consumable>
<manufacturedProduct>
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.8.2" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.53" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.7.2" />
<!--(ISC35) INFO:manufacturedProduct/templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.4.7.2']/manufacturedMaterial-->
<manufacturedMaterial>
<code code="309362" codeSystem="2.16.840.1.113883.6.88" codeSystemName="RxNorm" displayName="Clopidogrel 75 MG oral tablet">
<originalText>
<reference value="#MEDNAME_2" />
</originalText>
<translation code="174742" codeSystem="2.16.840.1.113883.6.88" codeSystemName="RxNorm" displayName="Plavix" />
</code>
<name>Plavix</name>
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
<author typeCode="AUT">
<time value="20111020000000-0300" />
<assignedAuthor classCode="ASSIGNED">
<id extension="BOMBAY" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>HealthShare Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<templateId root="2.16.840.1.113883.10.20.1.47" />
<id nullFlavor="UNK" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="55561003" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="Active" xsi:type="CE">
<originalText>
<reference value="#MEDSTATUS_2" />
</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship inversionInd="false" typeCode="REFR">
<sequenceNumber nullFlavor="UNK" />
<supply classCode="SPLY" moodCode="INT">
<templateId root="2.16.840.1.113883.10.20.1.34" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.7.3" />
<id nullFlavor="UNK" />
<!--(ISC34) INFO:supply[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7.3']/author-->
<author typeCode="AUT">
<time value="20111020000000-0300" />
<assignedAuthor classCode="ASSIGNED">
<id extension="BOMBAY" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>HealthShare Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
</supply>
</entryRelationship>
<entryRelationship typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.8.1" />
<code code="73639000" codeSystem="2.16.840.1.113883.6.96" displayName="Prescription Drug" />
</observation>
</entryRelationship>
</substanceAdministration>
</entry>
<entry typeCode="DRIV">
<substanceAdministration classCode="SBADM" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.8" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.24" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.7" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.7.1" />
<id root="cdbd5b01-6cde-11db-9fe1-0800200c9a66" />
<text>
<reference value="#SIGTEXT_3" />
</text>
<statusCode code="completed" />
<!--REQUIRED:effectiveTime:xsi type-->
<!--(ISC39) INFO:hl7:substanceAdministration[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7/effectiveTime:xsi:type='IVL_TS'-->
<!--(ISC38) WARNING:hl7:substanceAdministration[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7/effectiveTime:xsi:type='IVL_TS'-->
<effectiveTime xsi:type="IVL_TS">
<low value="20071121" />
<high nullFlavor="UNK" />
</effectiveTime>
<!--(ISC40) INFO:hl7:substanceAdministration[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7/effectiveTime:xsi:type='PIVL_TS'-->
<effectiveTime institutionSpecified="false" operator="A" xsi:type="PIVL_TS">
<period unit="h" value="12" />
</effectiveTime>
<!--(ISC37) INFO:routeCode-->
<routeCode code="C38288" codeSystem="2.16.840.1.113883.3.26.1.1" codeSystemName="NCI - FDA RouteOfAdministration" displayName="Oral">
<originalText>
<reference value="#MEDROUTE_3" />
</originalText>
<translation code="PO" codeSystem="2.16.840.1.113883.5.112" codeSystemName="HL7 RouteOfAdministration" displayName="Swallow, oral" />
</routeCode>
<!--(ISC36) INFO:doseQuantity-->
<doseQuantity>
<low unit="mg" value="25" />
<high unit="mg" value="25" />
</doseQuantity>
<!--(ISC53) INFO:administrationUnitCode-->
<administrationUnitCode code="C42998" codeSystem="2.16.840.1.113883.3.26.1.1" codeSystemName="NCI - FDA Dosage Forms" displayName="Tablet">
<originalText>
<reference value="#MEDFORM_3" />
</originalText>
</administrationUnitCode>
<consumable>
<manufacturedProduct>
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.8.2" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.53" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.7.2" />
<!--(ISC35) INFO:manufacturedProduct/templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.4.7.2']/manufacturedMaterial-->
<manufacturedMaterial>
<code code="430618" codeSystem="2.16.840.1.113883.6.88" codeSystemName="RxNorm" displayName="Metoprolol 25 MG oral tablet">
<originalText>
<reference value="#MEDNAME_3" />
</originalText>
</code>
<name nullFlavor="UNK" />
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
<author typeCode="AUT">
<time value="20071121000000-0300" />
<assignedAuthor classCode="ASSIGNED">
<id extension="BOMBAY" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>HealthShare Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
<entryRelationship typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.8.1" />
<code code="73639000" codeSystem="2.16.840.1.113883.6.96" displayName="Prescription Drug" />
</observation>
</entryRelationship>
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<templateId root="2.16.840.1.113883.10.20.1.47" />
<id nullFlavor="UNK" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="55561003" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="Active" xsi:type="CE">
<originalText>
<reference value="#MEDSTATUS_3" />
</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship inversionInd="false" typeCode="REFR">
<sequenceNumber nullFlavor="UNK" />
<supply classCode="SPLY" moodCode="INT">
<templateId root="2.16.840.1.113883.10.20.1.34" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.7.3" />
<id nullFlavor="UNK" />
<!--(ISC34) INFO:supply[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7.3']/author-->
<author typeCode="AUT">
<time value="20071121000000-0300" />
<assignedAuthor classCode="ASSIGNED">
<id extension="BOMBAY" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>HealthShare Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
</supply>
</entryRelationship>
</substanceAdministration>
</entry>
<entry typeCode="DRIV">
<substanceAdministration classCode="SBADM" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.8" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.24" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.7" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.7.1" />
<id root="cdbd5b03-6cde-11db-9fe1-0800200c9a66" />
<text>
<reference value="#SIGTEXT_4" />
</text>
<statusCode code="completed" />
<!--REQUIRED:effectiveTime:xsi type-->
<!--(ISC39) INFO:hl7:substanceAdministration[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7/effectiveTime:xsi:type='IVL_TS'-->
<!--(ISC38) WARNING:hl7:substanceAdministration[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7/effectiveTime:xsi:type='IVL_TS'-->
<effectiveTime xsi:type="IVL_TS">
<low value="20000328" />
<high nullFlavor="UNK" />
</effectiveTime>
<!--(ISC40) INFO:hl7:substanceAdministration[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7/effectiveTime:xsi:type='PIVL_TS'-->
<effectiveTime institutionSpecified="false" operator="A" xsi:type="PIVL_TS">
<period unit="h" value="24" />
</effectiveTime>
<!--(ISC37) INFO:routeCode-->
<routeCode code="C38288" codeSystem="2.16.840.1.113883.3.26.1.1" codeSystemName="NCI - FDA RouteOfAdministration" displayName="Oral">
<originalText>
<reference value="#MEDROUTE_4" />
</originalText>
<translation code="PO" codeSystem="2.16.840.1.113883.5.112" codeSystemName="HL7 RouteOfAdministration" displayName="Swallow, oral" />
</routeCode>
<!--(ISC36) INFO:doseQuantity-->
<doseQuantity>
<low unit="mg" value="20" />
<high unit="mg" value="20" />
</doseQuantity>
<!--(ISC53) INFO:administrationUnitCode-->
<administrationUnitCode code="C42998" codeSystem="2.16.840.1.113883.3.26.1.1" codeSystemName="NCI - FDA Dosage Forms" displayName="Tablet">
<originalText>
<reference value="#MEDFORM_4" />
</originalText>
</administrationUnitCode>
<consumable>
<manufacturedProduct>
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.8.2" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.53" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.7.2" />
<!--(ISC35) INFO:manufacturedProduct/templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.4.7.2']/manufacturedMaterial-->
<manufacturedMaterial>
<code code="312615" codeSystem="2.16.840.1.113883.6.88" codeSystemName="RxNorm" displayName="Prednisone 20 MG oral tablet">
<originalText>
<reference value="#MEDNAME_4" />
</originalText>
<translation code="227730" codeSystem="2.16.840.1.113883.6.88" codeSystemName="RxNorm" displayName="Deltasone" />
</code>
<name>Deltasone</name>
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
<author typeCode="AUT">
<time value="20000328000000-0300" />
<assignedAuthor classCode="ASSIGNED">
<id extension="BOMBAY" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>HealthShare Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<templateId root="2.16.840.1.113883.10.20.1.47" />
<id nullFlavor="UNK" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<effectiveTime>
<low value="2011" />
<high value="2011" />
</effectiveTime>
<value code="55561003" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="Active" xsi:type="CE">
<originalText>
<reference value="#MEDSTATUS_4" />
</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship inversionInd="false" typeCode="REFR">
<sequenceNumber nullFlavor="UNK" />
<supply classCode="SPLY" moodCode="INT">
<templateId root="2.16.840.1.113883.10.20.1.34" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.7.3" />
<id nullFlavor="UNK" />
<!--(ISC34) INFO:supply[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7.3']/author-->
<author typeCode="AUT">
<time value="20000328000000-0300" />
<assignedAuthor classCode="ASSIGNED">
<id extension="BOMBAY" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>HealthShare Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
</supply>
</entryRelationship>
<entryRelationship typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.8.1" />
<code code="329505003" codeSystem="2.16.840.1.113883.6.96" displayName="Over the counter product" />
</observation>
</entryRelationship>
</substanceAdministration>
</entry>
<entry typeCode="DRIV">
<substanceAdministration classCode="SBADM" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.8" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.24" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.7" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.7.1" />
<id root="cdbd5b07-6cde-11db-9fe1-0800200c9a66" />
<text>
<reference value="#SIGTEXT_5" />
</text>
<statusCode code="completed" />
<!--REQUIRED:effectiveTime:xsi type-->
<!--(ISC39) INFO:hl7:substanceAdministration[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7/effectiveTime:xsi:type='IVL_TS'-->
<!--(ISC38) WARNING:hl7:substanceAdministration[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7/effectiveTime:xsi:type='IVL_TS'-->
<effectiveTime xsi:type="IVL_TS">
<low value="20000328000000-0300" />
<high value="20000404000000-0300" />
</effectiveTime>
<!--(ISC40) INFO:hl7:substanceAdministration[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7/effectiveTime:xsi:type='PIVL_TS'-->
<effectiveTime institutionSpecified="false" operator="A" xsi:type="PIVL_TS">
<period unit="h" value="6" />
</effectiveTime>
<!--(ISC37) INFO:routeCode-->
<routeCode code="C38288" codeSystem="2.16.840.1.113883.3.26.1.1" codeSystemName="NCI - FDA RouteOfAdministration" displayName="Oral">
<originalText>
<reference value="#MEDROUTE_2" />
</originalText>
<translation code="PO" codeSystem="2.16.840.1.113883.5.112" codeSystemName="HL7 RouteOfAdministration" displayName="Swallow, oral" />
</routeCode>
<!--(ISC36) INFO:doseQuantity-->
<doseQuantity>
<low unit="mg" value="500" />
<high unit="mg" value="500" />
</doseQuantity>
<!--(ISC53) INFO:administrationUnitCode-->
<administrationUnitCode code="C42998" codeSystem="2.16.840.1.113883.3.26.1.1" codeSystemName="NCI - FDA Dosage Forms" displayName="Tablet">
<originalText>
<reference value="#MEDFORM_5" />
</originalText>
</administrationUnitCode>
<consumable>
<manufacturedProduct>
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.8.2" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.53" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.7.2" />
<!--(ISC35) INFO:manufacturedProduct/templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.4.7.2']/manufacturedMaterial-->
<manufacturedMaterial>
<code code="197454" codeSystem="2.16.840.1.113883.6.88" codeSystemName="RxNorm" displayName="Cephalexin 500 MG oral tablet">
<originalText>
<reference value="#MEDNAME_5" />
</originalText>
<translation code="203167" codeSystem="2.16.840.1.113883.6.88" codeSystemName="RxNorm" displayName="Keflex" />
</code>
<name>Keflex</name>
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
<author typeCode="AUT">
<time value="20000327000000-0300" />
<assignedAuthor classCode="ASSIGNED">
<id extension="ONCALL" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>On</given>
<family>Call</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>HealthShare Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<templateId root="2.16.840.1.113883.10.20.1.47" />
<id nullFlavor="UNK" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<effectiveTime>
<low value="2011" />
<high value="2011" />
</effectiveTime>
<value code="73425007" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="No Longer Active" xsi:type="CE">
<originalText>
<reference value="#MEDSTATUS_5" />
</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship inversionInd="false" typeCode="REFR">
<sequenceNumber nullFlavor="UNK" />
<supply classCode="SPLY" moodCode="INT">
<templateId root="2.16.840.1.113883.10.20.1.34" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.7.3" />
<id nullFlavor="UNK" />
<!--(ISC34) INFO:supply[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.7.3']/author-->
<author typeCode="AUT">
<time value="20000327000000-0300" />
<assignedAuthor classCode="ASSIGNED">
<id extension="ONCALL" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>On</given>
<family>Call</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>HealthShare Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
</supply>
</entryRelationship>
<entryRelationship typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.8.1" />
<code code="73639000" codeSystem="2.16.840.1.113883.6.96" displayName="Prescription Drug" />
</observation>
</entryRelationship>
</substanceAdministration>
</entry>
</section>
</component>
<!--End Medications Section-->
<!--Begin Diagnostic Results Section-->
<component>
<section>
<templateId assigningAuthorityName="HITSP/C83" root="2.16.840.1.113883.3.88.11.83.122" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.3.28" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.14" />
<code code="30954-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Results" />
<title>Diagnostic Results</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>&#160;</th>
<th>March 23, 2000</th>
<th>April 06, 2000</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="3">
<content ID="RESULTPROC_1">CBC W/O DIFFERENTIAl</content>
</td>
</tr>
<tr ID="TESTSUMMARY_1">
<td ID="TESTRANGE_1">HGB (13-18 g/dl)</td>
<td>13.2</td>
<td>&#160;</td>
</tr>
<tr>
<td ID="TESTRANGE_2">WBC (4.3-10.8 10+3/ul)</td>
<td>6.7</td>
<td>&#160;</td>
</tr>
<tr>
<td ID="TESTRANGE_3">PLT (135-145 meq/l)</td>
<td>123 (L)</td>
<td>&#160;</td>
</tr>
</tbody>
</table>
<table border="1" width="100%">
<thead>
<tr>
<th>&#160;</th>
<th>March 23, 2000</th>
<th>April 06, 2000</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="3">
<content ID="RESULTPROC_2">Electrolytes</content>
</td>
</tr>
<tr>
<td ID="TESTRANGE_4">NA (135-145meq/l)</td>
<td>&#160;</td>
<td>140</td>
</tr>
<tr>
<td ID="TESTRANGE_5">K (3.5-5.0 meq/l)</td>
<td>&#160;</td>
<td>4.0</td>
</tr>
<tr>
<td ID="TESTRANGE_6">CL (98-106 meq/l)</td>
<td>&#160;</td>
<td>102</td>
</tr>
<tr>
<td ID="TESTRANGE_7">HCO3 (18-23 meq/l)</td>
<td>&#160;</td>
<td>35 (H)</td>
</tr>
</tbody>
</table>
</text>
<entry>
<organizer classCode="BATTERY" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.32" />
<id root="7d5a02b0-67a4-11db-bd13-0800200c9a66" />
<id nullFlavor="UNK" />
<id nullFlavor="UNK" />
<code code="43789009" codeSystem="2.16.840.1.113883.6.96" displayName="CBC WO DIFFERENTIAL" />
<statusCode code="completed" />
<effectiveTime value="200003231630" />
<component>
<procedure classCode="PROC" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.17" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.29" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.19" />
<id root="7d5a02b0-67a4-11db-bd13-0800200c9a66" />
<id root="107c2dc0-67a5-11db-bd13-0800200c9aaa" />
<id nullFlavor="UNK" />
<!--(ISC30) INFO:organizer[templateId/@root='2.16.840.1.113883.10.20.1.32']//procedure[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.19]/code-->
<code code="43789009" codeSystem="2.16.840.1.113883.6.96" displayName="CBC WO DIFFERENTIAL">
<originalText>
<reference value="#RESULTPROC_1" />
</originalText>
</code>
<text>
<reference value="#RESULTPROC_1" />
</text>
<statusCode code="completed" />
<effectiveTime value="200003231430" />
<performer>
<assignedEntity>
<id nullFlavor="UNK" />
<addr>
<streetAddressLine nullFlavor="UNK" />
<city nullFlavor="UNK" />
<state nullFlavor="UNK" />
<postalCode nullFlavor="UNK" />
</addr>
<telecom nullFlavor="UNK" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Joe</given>
<family>Lab</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id nullFlavor="UNK" />
<name nullFlavor="UNK" />
<telecom nullFlavor="UNK" />
<addr nullFlavor="UNK" />
</representedOrganization>
</assignedEntity>
</performer>
</procedure>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.15.1" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.31" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<id root="7d5a02b0-67a4-11db-bd13-0800200c9a66" />
<id root="107c2dc0-67a5-11db-bd13-0800200c9aaa" />
<id root="107c2dc0-67a5-11db-bd13-0800200c9a66" />
<!--(ISC31) INFO:organizer[templateId/@root='2.16.840.1.113883.10.20.1.32']//observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13']/code-->
<code code="30313-1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="HGB" />
<text>
<reference value="#TESTSUMMARY_1" />
</text>
<statusCode code="completed" />
<effectiveTime value="200003231630" />
<!--(ISC32) INFO:organizer[templateId/@root='2.16.840.1.113883.10.20.1.32']//observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13']/value:!-->
<value unit="g/dl" value="13.2" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<referenceRange>
<observationRange>
<text>
<reference value="#TESTRANGE_1" />
</text>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.15.1" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.31" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<id root="7d5a02b0-67a4-11db-bd13-0800200c9a66" />
<id root="107c2dc0-67a5-11db-bd13-0800200c9aaa" />
<id root="8b3fa370-67a5-11db-bd13-0800200c9a66" />
<!--(ISC31) INFO:organizer[templateId/@root='2.16.840.1.113883.10.20.1.32']//observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13']/code-->
<code code="33765-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="WBC" />
<text>
<reference value="#TESTSUMMARY_2" />
</text>
<statusCode code="completed" />
<effectiveTime value="200003231630" />
<!--(ISC32) INFO:organizer[templateId/@root='2.16.840.1.113883.10.20.1.32']//observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13']/value:!-->
<value unit="10+3/ul" value="6.7" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<referenceRange>
<observationRange>
<text>
<reference value="#TESTRANGE_2" />
</text>
<value xsi:type="IVL_PQ">
<low unit="10+3/ul" value="4.3" />
<high unit="10+3/ul" value="10.8" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.15.1" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.31" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<id root="7d5a02b0-67a4-11db-bd13-0800200c9a66" />
<id root="107c2dc0-67a5-11db-bd13-0800200c9aaa" />
<id root="80a6c740-67a5-11db-bd13-0800200c9a66" />
<!--(ISC31) INFO:organizer[templateId/@root='2.16.840.1.113883.10.20.1.32']//observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13']/code-->
<code code="26515-7" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="PLT" />
<text>
<reference value="#TESTSUMMARY_3" />
</text>
<statusCode code="completed" />
<effectiveTime value="200003231630" />
<!--(ISC32) INFO:organizer[templateId/@root='2.16.840.1.113883.10.20.1.32']//observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13']/value:!-->
<value unit="10+3/ul" value="123" xsi:type="PQ" />
<interpretationCode code="L" codeSystem="2.16.840.1.113883.5.83" />
<referenceRange>
<observationRange>
<text>
<reference value="#TESTRANGE_3" />
</text>
<value xsi:type="IVL_PQ">
<low unit="10+3/ul" value="150" />
<high unit="10+3/ul" value="350" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
</organizer>
</entry>
<entry>
<organizer classCode="BATTERY" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.32" />
<id root="a40027e0-67a5-11db-bd13-0800200c9a66" />
<id nullFlavor="UNK" />
<id nullFlavor="UNK" />
<code code="20109005" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="LYTES" />
<statusCode code="completed" />
<effectiveTime value="200004061300" />
<component>
<procedure classCode="PROC" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.17" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.29" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.19" />
<id root="a40027e0-67a5-11db-bd13-0800200c9a66" />
<id root="107c2dc0-67a5-11db-bd13-0800200c9aab" />
<id nullFlavor="UNK" />
<!--(ISC30) INFO:organizer[templateId/@root='2.16.840.1.113883.10.20.1.32']//procedure[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.19]/code-->
<code code="20109005" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="LYTES">
<originalText>
<reference value="#RESULTPROC_2" />
</originalText>
</code>
<text>
<reference value="#RESULTPROC_2" />
</text>
<statusCode code="completed" />
<effectiveTime value="200004061300" />
<performer>
<assignedEntity>
<id nullFlavor="UNK" />
<addr>
<streetAddressLine nullFlavor="UNK" />
<city nullFlavor="UNK" />
<state nullFlavor="UNK" />
<postalCode nullFlavor="UNK" />
</addr>
<telecom nullFlavor="UNK" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Joe</given>
<family>Lab</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id nullFlavor="UNK" />
<name nullFlavor="UNK" />
<telecom nullFlavor="UNK" />
<addr nullFlavor="UNK" />
</representedOrganization>
</assignedEntity>
</performer>
</procedure>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.15" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.31" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<id root="a40027e0-67a5-11db-bd13-0800200c9a66" />
<id root="107c2dc0-67a5-11db-bd13-0800200c9aab" />
<id root="a40027e1-67a5-11db-bd13-0800200c9a66" />
<!--(ISC31) INFO:organizer[templateId/@root='2.16.840.1.113883.10.20.1.32']//observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13']/code-->
<code code="2951-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="NA" />
<text>
<reference value="#TESTSUMMARY_4" />
</text>
<statusCode code="completed" />
<effectiveTime value="200004061300" />
<!--(ISC32) INFO:organizer[templateId/@root='2.16.840.1.113883.10.20.1.32']//observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13']/value:!-->
<value unit="meq/l" value="140" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<referenceRange>
<observationRange>
<text>
<reference value="#TESTRANGE_4" />
</text>
<value xsi:type="IVL_PQ">
<low unit="meq/l" value="135" />
<high unit="meq/l" value="145" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.15" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.31" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<id root="a40027e0-67a5-11db-bd13-0800200c9a66" />
<id root="107c2dc0-67a5-11db-bd13-0800200c9aab" />
<id root="a40027e2-67a5-11db-bd13-0800200c9a66" />
<!--(ISC31) INFO:organizer[templateId/@root='2.16.840.1.113883.10.20.1.32']//observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13']/code-->
<code code="2823-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="K" />
<text>
<reference value="#TESTSUMMARY_5" />
</text>
<statusCode code="completed" />
<effectiveTime value="200004061300" />
<!--(ISC32) INFO:organizer[templateId/@root='2.16.840.1.113883.10.20.1.32']//observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13']/value:!-->
<value unit="meq/l" value="4.0" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<referenceRange>
<observationRange>
<text>
<reference value="#TESTRANGE_5" />
</text>
<value xsi:type="IVL_PQ">
<low unit="meq/l" value="3.5" />
<high unit="meq/l" value="5.0" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.15" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.31" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<id root="a40027e0-67a5-11db-bd13-0800200c9a66" />
<id root="107c2dc0-67a5-11db-bd13-0800200c9aab" />
<id root="a40027e3-67a5-11db-bd13-0800200c9a66" />
<!--(ISC31) INFO:organizer[templateId/@root='2.16.840.1.113883.10.20.1.32']//observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13']/code-->
<code code="2075-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="CL" />
<text>
<reference value="#TESTSUMMARY_6" />
</text>
<statusCode code="completed" />
<effectiveTime value="200004061300" />
<!--(ISC32) INFO:organizer[templateId/@root='2.16.840.1.113883.10.20.1.32']//observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13']/value:!-->
<value unit="meq/l" value="102" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<referenceRange>
<observationRange>
<text>
<reference value="#TESTRANGE_6" />
</text>
<value xsi:type="IVL_PQ">
<low unit="meq/l" value="98" />
<high unit="meq/l" value="106" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.15" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.31" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<id root="a40027e0-67a5-11db-bd13-0800200c9a66" />
<id root="107c2dc0-67a5-11db-bd13-0800200c9aab" />
<id root="a40027e4-67a5-11db-bd13-0800200c9a66" />
<!--(ISC31) INFO:organizer[templateId/@root='2.16.840.1.113883.10.20.1.32']//observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13']/code-->
<code code="1963-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="HCO3" />
<text>
<reference value="#TESTSUMMARY_7" />
</text>
<statusCode code="completed" />
<effectiveTime value="200004061300" />
<!--(ISC32) INFO:organizer[templateId/@root='2.16.840.1.113883.10.20.1.32']//observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13']/value:!-->
<value unit="meq/l" value="35" xsi:type="PQ" />
<interpretationCode code="H" codeSystem="2.16.840.1.113883.5.83" />
<referenceRange>
<observationRange>
<text>
<reference value="#TESTRANGE_7" />
</text>
<value xsi:type="IVL_PQ">
<low unit="meq/l" value="18" />
<high unit="meq/l" value="23" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
</organizer>
</entry>
</section>
</component>
<!--End Diagnostic Results Section-->
<!--Begin Vital Signs Section-->
<component>
<section>
<templateId root="2.16.840.1.113883.3.88.11.83.119" />
<templateId root="2.16.840.1.113883.10.20.1.16" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.25" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.1.5.3.2" />
<code code="8716-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Vital Signs" />
<title>Vital Signs</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Vital Name</th>
<th>Observation Time</th>
<th>Observation Value</th>
<th>Comments</th>
</tr>
</thead>
<tbody>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.1">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.1">Pulse</td>
<td>2008-10-29T14:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.1">88</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.1" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.2">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.2">Temperature</td>
<td>2008-10-29T14:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.2">38.8</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.2" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.3">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.3">Respirations</td>
<td>2008-10-29T14:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.3">20</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.3" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.4">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.4">Diastolic</td>
<td>2008-10-29T14:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.4">100</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.4" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.5">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.5">Systolic</td>
<td>2008-10-29T14:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.5">160</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.5" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.6">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.6">Pulse</td>
<td>2008-10-29T16:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.6">90</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.6" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.7">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.7">Temperature</td>
<td>2008-10-29T16:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.7">38.1</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.7" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.8">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.8">Respirations</td>
<td>2008-10-29T16:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.8">20</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.8" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.9">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.9">Diastolic</td>
<td>2008-10-29T16:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.9">90</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.9" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.10">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.10">Systolic</td>
<td>2008-10-29T16:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.10">140</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.10" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.11">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.11">Pulse</td>
<td>2008-10-29T18:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.11">89</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.11" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.12">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.12">Temperature</td>
<td>2008-10-29T18:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.12">37.9</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.12" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.13">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.13">Respirations</td>
<td>2008-10-29T18:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.13">22</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.13" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.14">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.14">Diastolic</td>
<td>2008-10-29T18:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.14">80</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.14" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.15">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.15">Systolic</td>
<td>2008-10-29T18:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.15">140</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.15" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.16">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.16">Pulse</td>
<td>2008-10-29T20:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.16">92</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.16" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.17">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.17">Temperature</td>
<td>2008-10-29T20:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.17">37.6</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.17" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.18">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.18">Respirations</td>
<td>2008-10-29T20:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.18">22</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.18" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.19">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.19">Diastolic</td>
<td>2008-10-29T20:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.19">89</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.19" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.20">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.20">Systolic</td>
<td>2008-10-29T20:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.20">134</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.20" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.21">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.21">Pulse</td>
<td>2008-10-30T11:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.21">88</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.21" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.22">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.22">Temperature</td>
<td>2008-10-30T11:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.22">39.8</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.22" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.23">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.23">Respirations</td>
<td>2008-10-30T11:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.23">25</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.23" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.24">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.24">Diastolic</td>
<td>2008-10-30T11:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.24">120</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.24" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.25">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.25">Systolic</td>
<td>2008-10-30T11:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.25">170</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.25" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.26">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.26">Pulse</td>
<td>2008-10-30T12:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.26">90</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.26" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.27">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.27">Temperature</td>
<td>2008-10-30T12:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.27">38.1</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.27" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.28">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.28">Respirations</td>
<td>2008-10-30T12:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.28">22</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.28" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.29">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.29">Diastolic</td>
<td>2008-10-30T12:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.29">90</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.29" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.30">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.30">Systolic</td>
<td>2008-10-30T12:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.30">140</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.30" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.31">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.31">Pulse</td>
<td>2008-10-30T13:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.31">92</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.31" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.32">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.32">Temperature</td>
<td>2008-10-30T13:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.32">37.2</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.32" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.33">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.33">Respirations</td>
<td>2008-10-30T13:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.33">22</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.33" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.34">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.34">Diastolic</td>
<td>2008-10-30T13:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.34">89</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.34" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.35">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.35">Systolic</td>
<td>2008-10-30T13:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.35">140</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.35" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.36">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.36">Pulse</td>
<td>2008-10-31T10:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.36">88</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.36" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.37">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.37">Temperature</td>
<td>2008-10-31T10:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.37">38.9</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.37" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.38">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.38">Respirations</td>
<td>2008-10-31T10:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.38">19</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.38" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.39">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.39">Diastolic</td>
<td>2008-10-31T10:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.39">100</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.39" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.40">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.40">Systolic</td>
<td>2008-10-31T10:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.40">150</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.40" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.41">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.41">Pulse</td>
<td>2008-10-31T12:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.41">89</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.41" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.42">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.42">Temperature</td>
<td>2008-10-31T12:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.42">38.4</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.42" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.43">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.43">Respirations</td>
<td>2008-10-31T12:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.43">20</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.43" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.44">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.44">Diastolic</td>
<td>2008-10-31T12:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.44">90</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.44" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.45">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.45">Systolic</td>
<td>2008-10-31T12:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.45">140</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.45" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.46">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.46">Pulse</td>
<td>2008-10-31T13:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.46">89</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.46" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.47">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.47">Temperature</td>
<td>2008-10-31T13:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.47">37.9</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.47" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.48">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.48">Respirations</td>
<td>2008-10-31T13:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.48">23</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.48" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.49">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.49">Diastolic</td>
<td>2008-10-31T13:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.49">80</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.49" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.50">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.50">Systolic</td>
<td>2008-10-31T13:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.50">140</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.50" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.51">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.51">Pulse</td>
<td>2008-10-31T14:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.51">92</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.51" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.52">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.52">Temperature</td>
<td>2008-10-31T14:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.52">38.6</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.52" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.53">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.53">Respirations</td>
<td>2008-10-31T14:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.53">21</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.53" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.54">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.54">Diastolic</td>
<td>2008-10-31T14:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.54">90</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.54" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.55">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.55">Systolic</td>
<td>2008-10-31T14:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.55">140</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.55" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.56">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.56">Pulse</td>
<td>2008-10-29T14:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.56">88</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.56" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.57">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.57">Pulse</td>
<td>2008-10-29T16:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.57">90</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.57" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.58">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.58">Pulse</td>
<td>2008-10-29T18:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.58">89</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.58" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.59">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.59">Pulse</td>
<td>2008-10-29T20:00:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.59">92</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.59" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.60">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.60">Pulse</td>
<td>2008-10-30T11:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.60">88</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.60" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.61">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.61">Pulse</td>
<td>2008-10-30T12:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.61">90</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.61" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.62">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.62">Pulse</td>
<td>2008-10-30T13:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.62">92</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.62" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.63">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.63">Pulse</td>
<td>2008-10-31T10:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.63">88</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.63" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.64">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.64">Pulse</td>
<td>2008-10-31T12:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.64">89</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.64" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.65">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.65">Pulse</td>
<td>2008-10-31T13:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.65">89</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.65" />
</tr>
<tr ID="vitalSignNarrativeLink-CGH.HSVN00004_200810290945.66">
<td ID="vitalSignIdentifierLink-CGH.HSVN00004_200810290945.66">Pulse</td>
<td>2008-10-31T14:45:00Z</td>
<td ID="vitalSignValueLink-CGH.HSVN00004_200810290945.66">92</td>
<td ID="vitalSignCommentsLink-CGH.HSVN00004_200810290945.66" />
</tr>
</tbody>
</table>
</text>
<!--(ISC54) INFO:section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.25']/entry[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13.1']:-->
<entry>
<organizer classCode="BATTERY" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.32" />
<templateId root="2.16.840.1.113883.10.20.1.35" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.1" />
<id root="a40027e0-67a5-11db-bd13-0800200c9a66" />
<code code="46680005" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="Vital signs" />
<statusCode code="completed" />
<effectiveTime value="20081029140000" />
<!--(ISC55) INFO:section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.25']/entry[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13.1']/author:-->
<author typeCode="AUT">
<time value="20081029140000" />
<assignedAuthor classCode="ASSIGNED">
<id nullFlavor="UNK" />
<addr nullFlavor="UNK" />
<telecom nullFlavor="UNK" />
<assignedPerson>
<name>
<given>Lab</given>
<family>Technician</family>
</name>
</assignedPerson>
<representedOrganization>
<id nullFlavor="UNK" />
<name>Generic Lab</name>
<telecom nullFlavor="UNK" />
<addr nullFlavor="UNK" />
</representedOrganization>
</assignedAuthor>
</author>
<informant>
<assignedEntity>
<id nullFlavor="UNK" />
<addr nullFlavor="UNK" />
<telecom nullFlavor="UNK" />
<assignedPerson>
<name nullFlavor="UNK" />
</assignedPerson>
<representedOrganization>
<id nullFlavor="UNK" />
<name>Generic Lab</name>
<telecom nullFlavor="UNK" />
<addr nullFlavor="UNK" />
</representedOrganization>
</assignedEntity>
</informant>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.1" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029140000" />
<value unit="/min" value="88" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.1" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8310-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Body                                                   temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.2" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029140000" />
<value unit="Cel" value="38.8" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.2" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="Cel" value="34" />
<high unit="Cel" value="39" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="9279-1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.3" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029140000" />
<value unit="/min" value="20" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.3" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="10" />
<high unit="/min" value="50" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8462-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.4" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029140000" />
<value unit="mm[Hg]" value="100" xsi:type="PQ" />
<interpretationCode code="H" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.4" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="40" />
<high unit="mm[Hg]" value="100" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8480-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.5" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029140000" />
<value unit="mm[Hg]" value="160" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.5" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="90" />
<high unit="mm[Hg]" value="200" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.6" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029160000" />
<value unit="/min" value="90" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.6" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8310-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Body                                                   temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.7" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029160000" />
<value unit="Cel" value="38.1" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.7" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="Cel" value="34" />
<high unit="Cel" value="39" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="9279-1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.8" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029160000" />
<value unit="/min" value="20" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.8" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="10" />
<high unit="/min" value="50" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8462-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.9" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029160000" />
<value unit="mm[Hg]" value="90" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.9" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="40" />
<high unit="mm[Hg]" value="100" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8480-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.10" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029160000" />
<value unit="mm[Hg]" value="140" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.10" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="90" />
<high unit="mm[Hg]" value="200" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.11" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029180000" />
<value unit="/min" value="89" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.11" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8310-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Body                                                   temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.12" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029180000" />
<value unit="Cel" value="37.9" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.12" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="Cel" value="34" />
<high unit="Cel" value="39" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="9279-1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.13" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029180000" />
<value unit="/min" value="22" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.13" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="10" />
<high unit="/min" value="50" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8462-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.14" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029180000" />
<value unit="mm[Hg]" value="80" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.14" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="40" />
<high unit="mm[Hg]" value="100" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8480-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.15" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029180000" />
<value unit="mm[Hg]" value="140" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.15" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="90" />
<high unit="mm[Hg]" value="200" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.16" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029200000" />
<value unit="/min" value="92" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.16" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8310-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Body                                                   temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.17" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029200000" />
<value unit="Cel" value="37.6" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.17" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="Cel" value="34" />
<high unit="Cel" value="39" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="9279-1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.18" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029200000" />
<value unit="/min" value="22" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.18" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="10" />
<high unit="/min" value="50" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8462-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.19" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029200000" />
<value unit="mm[Hg]" value="89" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.19" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="40" />
<high unit="mm[Hg]" value="100" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8480-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.20" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029200000" />
<value unit="mm[Hg]" value="134" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.20" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="90" />
<high unit="mm[Hg]" value="200" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.21" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081030114500" />
<value unit="/min" value="88" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.21" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8310-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Body                                                   temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.22" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081030114500" />
<value unit="Cel" value="39.8" xsi:type="PQ" />
<interpretationCode code="H" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.22" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="Cel" value="34" />
<high unit="Cel" value="39" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="9279-1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.23" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081030114500" />
<value unit="/min" value="25" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.23" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="10" />
<high unit="/min" value="50" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8462-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.24" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081030114500" />
<value unit="mm[Hg]" value="120" xsi:type="PQ" />
<interpretationCode code="H" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.24" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="40" />
<high unit="mm[Hg]" value="100" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8480-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.25" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081030114500" />
<value unit="mm[Hg]" value="170" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.25" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="90" />
<high unit="mm[Hg]" value="200" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.26" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081030124500" />
<value unit="/min" value="90" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.26" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8310-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Body                                                   temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.27" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081030124500" />
<value unit="Cel" value="38.1" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.27" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="Cel" value="34" />
<high unit="Cel" value="39" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="9279-1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.28" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081030124500" />
<value unit="/min" value="22" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.28" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="10" />
<high unit="/min" value="50" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8462-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.29" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081030124500" />
<value unit="mm[Hg]" value="90" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.29" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="40" />
<high unit="mm[Hg]" value="100" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8480-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.30" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081030124500" />
<value unit="mm[Hg]" value="140" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.30" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="90" />
<high unit="mm[Hg]" value="200" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.31" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081030134500" />
<value unit="/min" value="92" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.31" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8310-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Body                                                   temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.32" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081030134500" />
<value unit="Cel" value="37.2" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.32" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="Cel" value="34" />
<high unit="Cel" value="39" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="9279-1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.33" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081030134500" />
<value unit="/min" value="22" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.33" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="10" />
<high unit="/min" value="50" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8462-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.34" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081030134500" />
<value unit="mm[Hg]" value="89" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.34" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="40" />
<high unit="mm[Hg]" value="100" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8480-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.35" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081030134500" />
<value unit="mm[Hg]" value="140" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.35" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="90" />
<high unit="mm[Hg]" value="200" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.36" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031104500" />
<value unit="/min" value="88" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.36" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8310-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Body                                                   temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.37" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031104500" />
<value unit="Cel" value="38.9" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.37" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="Cel" value="34" />
<high unit="Cel" value="39" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="9279-1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.38" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031104500" />
<value unit="/min" value="19" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.38" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="10" />
<high unit="/min" value="50" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8462-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.39" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031104500" />
<value unit="mm[Hg]" value="100" xsi:type="PQ" />
<interpretationCode code="H" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.39" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="40" />
<high unit="mm[Hg]" value="100" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8480-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.40" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031104500" />
<value unit="mm[Hg]" value="150" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.40" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="90" />
<high unit="mm[Hg]" value="200" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.41" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031124500" />
<value unit="/min" value="89" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.41" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8310-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Body                                                   temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.42" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031124500" />
<value unit="Cel" value="38.4" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.42" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="Cel" value="34" />
<high unit="Cel" value="39" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="9279-1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.43" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031124500" />
<value unit="/min" value="20" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.43" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="10" />
<high unit="/min" value="50" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8462-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.44" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031124500" />
<value unit="mm[Hg]" value="90" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.44" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="40" />
<high unit="mm[Hg]" value="100" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8480-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.45" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031124500" />
<value unit="mm[Hg]" value="140" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.45" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="90" />
<high unit="mm[Hg]" value="200" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.46" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031134500" />
<value unit="/min" value="89" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.46" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8310-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Body                                                   temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.47" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031134500" />
<value unit="Cel" value="37.9" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.47" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="Cel" value="34" />
<high unit="Cel" value="39" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="9279-1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.48" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031134500" />
<value unit="/min" value="23" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.48" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="10" />
<high unit="/min" value="50" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8462-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.49" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031134500" />
<value unit="mm[Hg]" value="80" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.49" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="40" />
<high unit="mm[Hg]" value="100" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8480-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.50" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031134500" />
<value unit="mm[Hg]" value="140" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.50" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="90" />
<high unit="mm[Hg]" value="200" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.51" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031144500" />
<value unit="/min" value="92" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.51" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8310-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Body                                                   temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.52" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031144500" />
<value unit="Cel" value="38.6" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.52" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="Cel" value="34" />
<high unit="Cel" value="39" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="9279-1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.53" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031144500" />
<value unit="/min" value="21" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.53" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="10" />
<high unit="/min" value="50" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8462-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.54" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031144500" />
<value unit="mm[Hg]" value="90" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.54" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="40" />
<high unit="mm[Hg]" value="100" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8480-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.55" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031144500" />
<value unit="mm[Hg]" value="140" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.55" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="mm[Hg]" value="90" />
<high unit="mm[Hg]" value="200" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.56" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029140000" />
<value unit="/min" value="88" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.56" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.57" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029160000" />
<value unit="/min" value="90" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.57" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.58" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029180000" />
<value unit="/min" value="89" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.58" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.59" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081029200000" />
<value unit="/min" value="92" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.59" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.60" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081030114500" />
<value unit="/min" value="88" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.60" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.61" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081030124500" />
<value unit="/min" value="90" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.61" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.62" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081030134500" />
<value unit="/min" value="92" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.62" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.63" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031104500" />
<value unit="/min" value="88" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.63" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.64" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031124500" />
<value unit="/min" value="89" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.64" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.65" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031134500" />
<value unit="/min" value="89" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.65" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.14" />
<templateId root="2.16.840.1.113883.10.20.1.31" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2" />
<id root="57d07056-bd97-4c90-891d-eb716d3170c8" />
<code code="8867-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Heart rate">
<originalText>Pulse</originalText>
</code>
<text>
<reference value="#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.66" />
</text>
<statusCode code="completed" />
<effectiveTime value="20081031144500" />
<value unit="/min" value="92" xsi:type="PQ" />
<interpretationCode code="N" codeSystem="2.16.840.1.113883.5.83" />
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.57" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<value code="final" codeSystem="2.16.840.1.113883.6.96" codeSystemName="2.16.840.1.113883.6.96" displayName="final" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.3.88.11.83.11" />
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation                                                   Comment" />
<text>
<reference value="#vitalSignCommentsLink-CGH.HSVN00004_200810290945.66" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
<referenceRange>
<observationRange>
<value xsi:type="IVL_PQ">
<low unit="/min" value="40" />
<high unit="/min" value="150" />
</value>
</observationRange>
</referenceRange>
</observation>
</component>
</organizer>
</entry>
</section>
</component>
<!--End Vital Signs Section-->
<!--Begin Advance Directives Section-->
<component>
<section>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.34" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.35" />
<templateId root="2.16.840.1.113883.3.88.11.83.116" />
<templateId root="2.16.840.1.113883.10.20.1.1" />
<code code="42348-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="ADVANCE DIRECTIVES" />
<title>Advance Directives</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Directive</th>
<th>Effective Date</th>
<th>Comment</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<content ID="advdir_0" xmlns="urn:hl7-org:v3">Do Not Resuscitate</content>
</td>
<td>5/16/2011</td>
<td ID="comment-1">Patient does not want to be resuscitated.</td>
</tr>
<tr>
<td>
<content ID="advdir_1" xmlns="urn:hl7-org:v3">Life Support</content>
</td>
<td>5/16/2011</td>
<td ID="comment-2">Daughter is only person who has legal right to order removal of life support.</td>
</tr>
</tbody>
</table>
</text>
<entry typeCode="DRIV">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="2.16.840.1.113883.10.20.1.17" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.7" />
<templateId root="2.16.840.1.113883.3.88.11.83.12" />
<id root="35186a4f-aaca-40b4-99ef-4a748f7f640f" />
<!--(ISC57) INFO:observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13.7']/code-->
<code code="304251008" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="Resuscitation status">
<originalText>
<reference value="#advdir_0" />
</originalText>
</code>
<!--(ISC25) WARNING:observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13.7']/text-->
<text>
<reference value="#advdir_0" />
</text>
<statusCode code="completed" />
<effectiveTime nullFlavor="NA">
<low value="20110516" />
<high nullFlavor="UNK" />
</effectiveTime>
<value value="true" xsi:type="BL" />
<!--(ISC24) INFO:observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13.7']/author-->
<author typeCode="AUT">
<time value="20110517" />
<assignedAuthor classCode="ASSIGNED">
<id extension="BOMBAY" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86.3.111" />
<name>HealthShare Heart Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
<participant typeCode="CST">
<participantRole classCode="AGNT">
<addr>
<streetAddressLine nullFlavor="UNK" />
<city nullFlavor="UNK" />
<state nullFlavor="UNK" />
<postalCode nullFlavor="UNK" />
</addr>
<telecom nullFlavor="UNK" />
<playingEntity>
<name>Mary Grublic</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.37" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<!--(ISC59) INFO:observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13.7']/entryRelationship[typeCode='REFR']/observation/value/@code-->
<value code="425396000" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="Verified With Family Only" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation Comment" />
<text>
<reference value="#comment-1" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
</observation>
</entry>
<entry typeCode="DRIV">
<observation classCode="OBS" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.7" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13" />
<templateId root="2.16.840.1.113883.10.20.1.17" />
<templateId root="2.16.840.1.113883.3.88.11.83.12" />
<id root="323e362b-5961-4446-b777-ad146a58af4a" />
<!--(ISC57) INFO:observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13.7']/code-->
<code code="78823007" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="Life Support">
<originalText>
<reference value="#advdir_1" />
</originalText>
</code>
<!--(ISC25) WARNING:observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13.7']/text-->
<text>
<reference value="#advdir_1" />
</text>
<statusCode code="completed" />
<!--(ISC58) INFO:observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13.7']/effectiveTime-->
<effectiveTime nullFlavor="NA">
<low value="20110516" />
<high nullFlavor="UNK" />
</effectiveTime>
<value value="true" xsi:type="BL" />
<!--(ISC24) INFO:observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13.7']/author-->
<author typeCode="AUT">
<time value="20110516" />
<assignedAuthor classCode="ASSIGNED">
<id extension="BOMBAY" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86.3.111" />
<name>HealthShare Heart Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
<participant typeCode="CST">
<participantRole classCode="AGNT">
<addr>
<streetAddressLine>592 Rockaway Avenue</streetAddressLine>
<city>Brooklyn</city>
<state>NY</state>
<postalCode>11212</postalCode>
</addr>
<telecom use="WP" value="tel:+1-7183455000" />
<playingEntity>
<name>Brownsville Multi-Services Family Health</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship typeCode="REFR">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.37" />
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
<statusCode code="completed" />
<!--(ISC59) INFO:observation[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13.7']/entryRelationship[typeCode='REFR']/observation/value/@code-->
<value code="425396000" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="Verified With Family Only" xsi:type="CE" />
</observation>
</entryRelationship>
<entryRelationship inversionInd="true" typeCode="SUBJ">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.40" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2" />
<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation Comment" />
<text>
<reference value="#comment-2" />
</text>
<statusCode code="completed" />
</act>
</entryRelationship>
</observation>
</entry>
</section>
</component>
<!--End Advance Directives Section-->
<!--Begin Immunizations Section-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.6" />
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.117" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.3.23" />
<code code="11369-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="HISTORY OF IMMUNIZATIONS" />
<title>Immunizations</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Vaccine</th>
<th>Date</th>
<th>Status</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<content ID="imm_0" xmlns="urn:hl7-org:v3">meningococcal polysaccharide vaccine (MPSV4)</content>
</td>
<td>May-16-2011</td>
<td>completed</td>
</tr>
<tr>
<td>
<content ID="imm_1" xmlns="urn:hl7-org:v3">VACCINATION FOR DTP-DTAP</content>
</td>
<td>May-16-2011</td>
<td>completed</td>
</tr>
<tr>
<td>
<content ID="imm_2" xmlns="urn:hl7-org:v3">VAC-MEASLE-MUMPS-RUBELLA</content>
</td>
<td>May-16-2011</td>
<td>completed</td>
</tr>
</tbody>
</table>
</text>
<entry typeCode="DRIV">
<!--(ISC60) INFO:substanceAdministration[templateid/@root='1.3.6.1.4.1.19376.1.5.3.1.4.12']:negationInd-->
<substanceAdministration classCode="SBADM" moodCode="EVN" negationInd="true">
<templateId assigningAuthorityName="HL7 SDTC CCD" root="2.16.840.1.113883.10.20.1.24" />
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.13" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.12" />
<id root="330b6cdc-d9e4-442c-9a4a-079434d33065" />
<code code="IMMUNIZ" codeSystem="2.16.840.1.113883.5.4" codeSystemName="ActCode" />
<text>
<reference value="#imm_0" />
</text>
<statusCode code="completed" />
<!--(ISC62) INFO:substanceAdministration[templateid/@root='1.3.6.1.4.1.19376.1.5.3.1.4.12']/effectiveTime:value-->
<effectiveTime nullFlavor="UNK" />
<!--(ISC63) INFO:substanceAdministration[templateid/@root='1.3.6.1.4.1.19376.1.5.3.1.4.12']/routeCode:-->
<routeCode code="IM" codeSystem="2.16.840.1.113883.5.112" codeSystemName="RouteOfAdministration" displayName="Intramuscular" />
<consumable typeCode="CSM">
<manufacturedProduct>
<templateId assigningAuthorityName="HL7 SDTC CCD" root="2.16.840.1.113883.10.20.1.53" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.7.2" />
<!--(ISC61) INFO:substanceAdministration[templateid/@root='1.3.6.1.4.1.19376.1.5.3.1.4.12']//manufacturedMaterial/code-->
<manufacturedMaterial>
<code code="32" codeSystem="2.16.840.1.113883.6.59" codeSystemName="CVX" displayName="meningococcal polysaccharide vaccine (MPSV4)">
<originalText>
<reference value="#imm_0" />
</originalText>
</code>
<lotNumberText />
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
<author typeCode="AUT">
<time value="20111020000000-0300" />
<assignedAuthor classCode="ASSIGNED">
<id extension="BOMBAY" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>HealthShare Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
</substanceAdministration>
</entry>
<entry typeCode="DRIV">
<!--(ISC60) INFO:substanceAdministration[templateid/@root='1.3.6.1.4.1.19376.1.5.3.1.4.12']:negationInd-->
<substanceAdministration classCode="SBADM" moodCode="EVN" negationInd="false">
<templateId assigningAuthorityName="HL7 SDTC CCD" root="2.16.840.1.113883.10.20.1.24" />
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.13" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.12" />
<id root="0fb56347-7991-4fb3-a44c-bbc1e90754aa" />
<code code="IMMUNIZ" codeSystem="2.16.840.1.113883.5.4" codeSystemName="ActCode" />
<text>
<reference value="#imm_1" />
</text>
<statusCode code="completed" />
<!--(ISC62) INFO:substanceAdministration[templateid/@root='1.3.6.1.4.1.19376.1.5.3.1.4.12']/effectiveTime:value-->
<effectiveTime value="20110516" />
<!--(ISC63) INFO:substanceAdministration[templateid/@root='1.3.6.1.4.1.19376.1.5.3.1.4.12']/routeCode:-->
<routeCode code="IM" codeSystem="2.16.840.1.113883.5.112" codeSystemName="RouteOfAdministration" displayName="Intramuscular" />
<consumable typeCode="CSM">
<manufacturedProduct>
<templateId assigningAuthorityName="HL7 SDTC CCD" root="2.16.840.1.113883.10.20.1.53" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.7.2" />
<!--(ISC61) INFO:substanceAdministration[templateid/@root='1.3.6.1.4.1.19376.1.5.3.1.4.12']//manufacturedMaterial/code-->
<manufacturedMaterial>
<code code="115" codeSystem="2.16.840.1.113883.6.59" codeSystemName="CVX" displayName="tetanus toxoid, reduced diphtheria toxoid and acellular pertussis                                                   vaccine adsorbed (Tdap)">
<originalText>
<reference value="#imm_1" />
</originalText>
</code>
<lotNumberText />
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
<author typeCode="AUT">
<time value="20111020000000-0300" />
<assignedAuthor classCode="ASSIGNED">
<id extension="BOMBAY" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>HealthShare Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
</substanceAdministration>
</entry>
<entry typeCode="DRIV">
<!--(ISC60) INFO:substanceAdministration[templateid/@root='1.3.6.1.4.1.19376.1.5.3.1.4.12']:negationInd-->
<substanceAdministration classCode="SBADM" moodCode="EVN" negationInd="false">
<templateId assigningAuthorityName="HL7 SDTC CCD" root="2.16.840.1.113883.10.20.1.24" />
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.13" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.12" />
<id root="26eb5cd4-cd09-46cb-b694-25a4272d314b" />
<code code="IMMUNIZ" codeSystem="2.16.840.1.113883.5.4" codeSystemName="ActCode" />
<text>
<reference value="#imm_2" />
</text>
<statusCode code="completed" />
<!--(ISC62) INFO:substanceAdministration[templateid/@root='1.3.6.1.4.1.19376.1.5.3.1.4.12']/effectiveTime:value-->
<effectiveTime value="20110516" />
<!--(ISC63) INFO:substanceAdministration[templateid/@root='1.3.6.1.4.1.19376.1.5.3.1.4.12']/routeCode:-->
<routeCode code="IM" codeSystem="2.16.840.1.113883.5.112" codeSystemName="RouteOfAdministration" displayName="Intramuscular" />
<consumable typeCode="CSM">
<manufacturedProduct>
<templateId assigningAuthorityName="HL7 SDTC CCD" root="2.16.840.1.113883.10.20.1.53" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.7.2" />
<!--(ISC61) INFO:substanceAdministration[templateid/@root='1.3.6.1.4.1.19376.1.5.3.1.4.12']//manufacturedMaterial/code-->
<manufacturedMaterial>
<code code="3" codeSystem="2.16.840.1.113883.6.59" codeSystemName="CVX" displayName="measles, mumps and rubella virus vaccine">
<originalText>
<reference value="#imm_2" />
</originalText>
</code>
<lotNumberText />
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
<author typeCode="AUT">
<time value="20111020000000-0300" />
<assignedAuthor classCode="ASSIGNED">
<id extension="BOMBAY" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>HealthShare Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
</substanceAdministration>
</entry>
</section>
</component>
<!--End Immunizations Section-->
<!--Begin Procedures Section-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.12" />
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.108" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.3.11" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.3.12" />
<code code="47519-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="HISTORY OF PROCEDURES" />
<title>Procedures</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Procedure</th>
<th>Date</th>
</tr>
</thead>
<tbody>
<tr>
<td ID="Proc_0">Laparoscopic Appendectomy</td>
<td>OCT-01-1999</td>
</tr>
<tr>
<td ID="Proc_1">Coronary Bypass</td>
<td>May-02-2011</td>
</tr>
</tbody>
</table>
</text>
<entry typeCode="DRIV">
<procedure classCode="PROC" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.17" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.19" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.29" />
<id nullFlavor="UNK" />
<!--(ISC47) INFO:section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.12']/entry[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.19']/code-->
<code code="801460020" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="Laparoscopic Appendectomy">
<originalText>
<reference value="#Proc_0" />
</originalText>
</code>
<text>
<reference value="#Proc_0" />
</text>
<statusCode code="completed" />
<!--(ISC49) INFO:section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.12']/entry[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.19']/effectiveTime-->
<effectiveTime xsi:type="IVL_TS">
<low value="19990110" />
<high value="19990110" />
</effectiveTime>
<!--(ISC50) INFO:section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.12']/entry[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.19']/performer-->
<performer typeCode="PRF">
<assignedEntity>
<id extension="DRNICK" root="2.16.840.1.113883.3.86.3.112" />
<addr nullFlavor="UNK" />
<telecom nullFlavor="UNK" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Nick</given>
<family>Ramirez</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization:-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86.3.112" />
<name>Springfield Hospital</name>
<telecom nullFlavor="UNK" />
<addr use="WP">
<streetAddressLine>1 Homer Drive</streetAddressLine>
<city>Springfield</city>
<state>??</state>
<postalCode>12345-6789</postalCode>
</addr>
</representedOrganization>
</assignedEntity>
</performer>
<!--(ISC48) INFO:section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.12']/entry[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.19']/author-->
<author typeCode="AUT">
<time value="20111002000000-0300" xsi:type="TS" />
<assignedAuthor classCode="ASSIGNED">
<id extension="BOMBAY" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization:-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>HealthShare Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
</procedure>
</entry>
<entry typeCode="DRIV">
<procedure classCode="PROC" moodCode="EVN">
<templateId assigningAuthorityName="HITSP C83" root="2.16.840.1.113883.3.88.11.83.17" />
<templateId assigningAuthorityName="IHE PCC" root="1.3.6.1.4.1.19376.1.5.3.1.4.19" />
<templateId assigningAuthorityName="CCD" root="2.16.840.1.113883.10.20.1.29" />
<id nullFlavor="UNK" />
<!--(ISC47) INFO:section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.12']/entry[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.19']/code-->
<code code="P1-33860" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED-CT" displayName="Aortocoronary bypass of two coronary arteries">
<originalText>
<reference value="#Proc_1" />
</originalText>
</code>
<text>
<reference value="#Proc_1" />
</text>
<statusCode code="completed" />
<!--(ISC49) INFO:section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.12']/entry[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.19']/effectiveTime-->
<effectiveTime xsi:type="IVL_TS">
<low value="20081010" />
<high value="20081010" />
</effectiveTime>
<!--(ISC50) INFO:section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.12']/entry[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.19']/performer-->
<performer typeCode="PRF">
<assignedEntity>
<id extension="HAWKEYE" root="2.16.840.1.113883.3.86.3.113" />
<addr nullFlavor="UNK" />
<telecom nullFlavor="UNK" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Hawkeye</given>
<family>Pierce</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization:-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86.3.113" />
<name>MASH Hospital</name>
<telecom nullFlavor="UNK" />
<addr use="WP">
<streetAddressLine>22 MASH Court</streetAddressLine>
<city>Hollywood</city>
<state>CA</state>
<postalCode>90211</postalCode>
</addr>
</representedOrganization>
</assignedEntity>
</performer>
<!--(ISC48) INFO:section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.12']/entry[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.19']/author-->
<author typeCode="AUT">
<time value="20111002000000-0300" xsi:type="TS" />
<assignedAuthor classCode="ASSIGNED">
<id extension="BOMBAY" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization:-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>HealthShare Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
</procedure>
</entry>
</section>
</component>
<!--End Procedures Section-->
<!--Begin Encounters Section-->
<component>
<section>
<templateId root="2.16.840.1.113883.3.88.11.83.127" />
<templateId root="2.16.840.1.113883.10.20.1.3" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.1.5.3.3" />
<code code="46240-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="History of Encounters" />
<title>Encounters</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Start Date/Time</th>
<th>End Date/Time</th>
<th>Encounter Type</th>
<th>Admission Type</th>
<th>Care Provider</th>
<th>Care Facility</th>
<th>Care Department</th>
<th>Encounter ID</th>
</tr>
</thead>
<tbody>
<tr ID="encounterNarrativeLink-PHLS.HSVN00005_200709170907.1">
<td>2007-09-17</td>
<td>2007-09-17</td>
<td>Outpatient</td>
<td ID="encounterAdmissionLink-PHLS.HSVN00005_200709170907.1" />
<td>Dr. Bom Bay</td>
<td>PHLS</td>
<td>PHLS</td>
<td>HSVN00005_200709170907</td>
</tr>
<tr ID="encounterNarrativeLink-PHLS.HSVN00005_199901100907.2">
<td>1999-01-10</td>
<td>1999-01-10</td>
<td>Outpatient</td>
<td ID="encounterAdmissionLink-PHLS.HSVN00005_199901100907.2" />
<td>Dr. Bom Bay</td>
<td>PHLS</td>
<td>PHLS</td>
<td>HSVN00005_200709170907</td>
</tr>
<tr ID="encounterNarrativeLink-PHLS.HSVN00002_201110200907.3">
<td>2011-10-20</td>
<td>2011-10-20</td>
<td>Outpatient</td>
<td ID="encounterAdmissionLink-PHLS.HSVN00002_201110200907.3" />
<td>Dr. Bom Bay</td>
<td>PHLS</td>
<td>PHLS</td>
<td>HSVN00002_200810130907</td>
</tr>
<tr ID="encounterNarrativeLink-HC6.HSVN00002_200506120907.3">
<td>2005-06-12</td>
<td>2005-06-12</td>
<td>Outpatient</td>
<td ID="encounterAdmissionLink-HC6.HSVN00002_200506120907.3" />
<td>Dr. Breathe Easy</td>
<td>HC6</td>
<td>HC6</td>
<td>HSVN00003_200810220945</td>
</tr>
<tr ID="encounterNarrativeLink-CGH.HSVN00004_200810290945.5">
<td>2008-10-29 09:45:00</td>
<td>2008-10-31 15:00:00</td>
<td>Inpatient</td>
<td ID="encounterAdmissionLink-CGH.HSVN00004_200810290945.5" />
<td>Farrell, Sam</td>
<td>CGH</td>
<td>CGH</td>
<td>HSVN00004_200810290945</td>
</tr>
</tbody>
</table>
</text>
<entry>
<encounter classCode="ENC" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.14" />
<templateId root="2.16.840.1.113883.10.20.1.21" />
<templateId root="2.16.840.1.113883.3.88.11.83.16" />
<!--(ISC21) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/id-->
<id assigningAuthorityName="PHLS" extension="HSVN00005_200709170907" root="1.3.6.1.4.1.21367.2010.1.2.300.2.5" />
<!--(ISC22) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/code-->
<code code="AMB" codeSystem="2.16.840.1.113883.5.4" codeSystemName="Encounter Type Value Set" displayName="Ambulatory">
<originalText>
<reference value="#encounterNarrativeLink-PHLS.HSVN00005_200709170907.1" />
</originalText>
</code>
<text>
<reference value="#encounterNarrativeLink-PHLS.HSVN00005_200709170907.1" />
</text>
<!--(ISC23) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/effectiveTime-->
<effectiveTime xsi:type="IVL_TS">
<low value="20070917070000-0300" />
<high value="20070917070000-0300" />
</effectiveTime>
<!--(ISC20) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/performer -->
<performer typeCode="PRF">
<assignedEntity>
<id extension="BOMBAY" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>HealthShare Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
</performer>
<!--(ISC19) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/participant -->
<participant typeCode="LOC">
<participantRole classCode="SDLOC">
<id root="2.16.840.1.113883.3.86" />
<addr nullFlavor="UNK" />
<telecom nullFlavor="UNK" />
<playingEntity>
<name>HealthShare Clinic</name>
</playingEntity>
</participantRole>
</participant>
</encounter>
</entry>
<entry>
<encounter classCode="ENC" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.14" />
<templateId root="2.16.840.1.113883.10.20.1.21" />
<templateId root="2.16.840.1.113883.3.88.11.83.16" />
<!--(ISC21) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/id-->
<id assigningAuthorityName="PHLS" extension="HSVN00005_200709170907" root="1.3.6.1.4.1.21367.2010.1.2.300.2.5" />
<!--(ISC22) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/code-->
<code code="AMB" codeSystem="2.16.840.1.113883.5.4" codeSystemName="Encounter Type Value Set" displayName="Ambulatory">
<originalText>
<reference value="#encounterNarrativeLink-PHLS.HSVN00005_199901100907.2" />
</originalText>
</code>
<text>
<reference value="#encounterNarrativeLink-PHLS.HSVN00005_199901100907.2" />
</text>
<!--(ISC23) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/effectiveTime-->
<effectiveTime xsi:type="IVL_TS">
<low value="19990110070000-0300" />
<high value="19990110070000-0300" />
</effectiveTime>
<!--(ISC20) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/performer -->
<performer typeCode="PRF">
<assignedEntity>
<id extension="BOMBAY" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>HealthShare Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
</performer>
<!--(ISC19) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/participant -->
<participant typeCode="LOC">
<participantRole classCode="SDLOC">
<id root="2.16.840.1.113883.3.86" />
<addr nullFlavor="UNK" />
<telecom nullFlavor="UNK" />
<playingEntity>
<name>HealthShare Clinic</name>
</playingEntity>
</participantRole>
</participant>
</encounter>
</entry>
<entry>
<encounter classCode="ENC" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.14" />
<templateId root="2.16.840.1.113883.10.20.1.21" />
<templateId root="2.16.840.1.113883.3.88.11.83.16" />
<!--(ISC21) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/id-->
<id assigningAuthorityName="HC6" extension="HSVN00002_200810130907" root="1.3.6.1.4.1.21367.2010.1.2.300.2.3" />
<!--(ISC22) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/code-->
<code code="AMB" codeSystem="2.16.840.1.113883.5.4" codeSystemName="Encounter Type Value Set" displayName="Ambulatory">
<originalText>
<reference value="#encounterNarrativeLink-PHLS.HSVN00002_201110200907.3" />
</originalText>
</code>
<text>
<reference value="#encounterNarrativeLink-PHLS.HSVN00002_201110200907.3" />
</text>
<!--(ISC23) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/effectiveTime-->
<effectiveTime xsi:type="IVL_TS">
<low value="20111020090700-0300" />
<high value="20111020090700-0300" />
</effectiveTime>
<!--(ISC20) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/performer -->
<performer typeCode="PRF">
<assignedEntity>
<id extension="BOMBAY" root="2.16.840.1.113883.3.86" />
<addr use="WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use="WP" value="tel:+1-617-225-3133" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<!--(ISC5) INFO:representedOrganization-->
<representedOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>HealthShare Clinic</name>
<telecom use="WP" value="tel:+1-617-225-3133" />
<addr use="WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor="UNK" />
<wholeOrganization>
<id root="2.16.840.1.113883.3.86" />
<name>InterSystems Corporation</name>
<telecom use="WP" value="tel:(617) 621-0600" />
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
</performer>
<!--(ISC19) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/participant -->
<participant typeCode="LOC">
<participantRole classCode="SDLOC">
<id root="2.16.840.1.113883.3.86" />
<addr nullFlavor="UNK" />
<telecom nullFlavor="UNK" />
<playingEntity>
<name>HealthShare Clinic</name>
</playingEntity>
</participantRole>
</participant>
</encounter>
</entry>
<entry>
<encounter classCode="ENC" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.14" />
<templateId root="2.16.840.1.113883.10.20.1.21" />
<templateId root="2.16.840.1.113883.3.88.11.83.16" />
<!--(ISC21) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/id-->
<id assigningAuthorityName="HC6" extension="HSVN00003_200810220945" root="2.16.840.1.113883.3.86.3.1" />
<!--(ISC22) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/code-->
<code code="SLEEP" displayName="Sleep Study">
<originalText>
<reference value="#encounterNarrativeLink-HC6.HSVN00002_200506120907.3" />
</originalText>
</code>
<text>
<reference value="#encounterNarrativeLink-HC6.HSVN00002_200506120907.3" />
</text>
<!--(ISC23) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/effectiveTime-->
<effectiveTime xsi:type="IVL_TS">
<low value="20050612090700-0300" />
<high value="20050612090700-0300" />
</effectiveTime>
<!--(ISC20) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/performer -->
<performer typeCode="PRF">
<assignedEntity>
<id nullFlavor="UNK" />
<addr nullFlavor="UNK" />
<telecom nullFlavor="UNK" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Breathe</given>
<family>Easy</family>
</name>
</assignedPerson>
</assignedEntity>
</performer>
<!--(ISC19) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/participant -->
<participant typeCode="LOC">
<participantRole classCode="SDLOC">
<id root="2.16.840.1.113883.3.86.3.1" />
<addr nullFlavor="UNK" />
<telecom nullFlavor="UNK" />
<playingEntity>
<name>HealthShare Heart and Lung Clinic</name>
</playingEntity>
</participantRole>
</participant>
</encounter>
</entry>
<entry>
<encounter classCode="ENC" moodCode="EVN">
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.14" />
<templateId root="2.16.840.1.113883.10.20.1.21" />
<templateId root="2.16.840.1.113883.3.88.11.83.16" />
<!--(ISC21) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/id-->
<id assigningAuthorityName="CGH" extension="HSVN00004_200810290945" root="2.16.840.1.113883.3.86.3.2" />
<!--(ISC22) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/code-->
<code code="IMP" codeSystem="2.16.840.1.113883.5.4" codeSystemName="Encounter Type Value Set" displayName="Inpatient Encounter">
<originalText>
<reference value="#encounterNarrativeLink-CGH.HSVN00004_200810290945.5" />
</originalText>
</code>
<text>
<reference value="#encounterNarrativeLink-CGH.HSVN00004_200810290945.5" />
</text>
<!--(ISC23) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/effectiveTime-->
<effectiveTime xsi:type="IVL_TS">
<low value="20081029094500-0300" />
<high value="20081031150000-0300" />
</effectiveTime>
<!--(ISC20) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/performer -->
<performer typeCode="PRF">
<assignedEntity>
<id nullFlavor="UNK" />
<addr nullFlavor="UNK" />
<telecom nullFlavor="UNK" />
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Sam</given>
<family>Farrell</family>
</name>
</assignedPerson>
</assignedEntity>
</performer>
<!--(ISC19) INFO:encounter[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.14']/participant -->
<participant typeCode="LOC">
<participantRole classCode="SDLOC">
<id nullFlavor="UNK" />
<addr nullFlavor="UNK" />
<telecom nullFlavor="UNK" />
<playingEntity>
<name>Emergency Department</name>
</playingEntity>
</participantRole>
</participant>
</encounter>
</entry>
</section>
</component>
<!--End Encounters Section-->
<!--Begin Plan of Care Section-->
<component>
<section>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.31" />
<templateId root="2.16.840.1.113883.10.20.1.10" />
<code code="18776-5" codeSystem="2.16.840.1.113883.6.1" />
<title>Plan</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Planned Activity</th>
<th>Planned Date</th>
</tr>
</thead>
<tbody>
<tr>
<td>Pulmonary function test</td>
<td>April 21, 2012</td>
</tr>
</tbody>
</table>
</text>
<entry typeCode="DRIV">
<observation classCode="OBS" moodCode="RQO">
<templateId root="2.16.840.1.113883.10.20.1.25" />
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.1.20.3.1" />
<id root="9a6d1bac-17d3-4195-89a4-1121bc809b4a" />
<code code="23426006" codeSystem="2.16.840.1.113883.6.96" displayName="Pulmonary function test" />
<statusCode code="new" />
<effectiveTime value="20130421" />
</observation>
</entry>
</section>
</component>
<!--End Plan of Care Section-->
</structuredBody>
</component>
</ClinicalDocument>
}

}
