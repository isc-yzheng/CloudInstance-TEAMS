Class HS.Test.UI.AU.XDSbPnR Extends HS.Test.UI.XDSbPnR
{

Parameter SERVICEREGISTRYENTRY = "AU.Repository.Provide";

/// This XML block defines the contents of the IHE Test workflow pane.
XData Contents
{
<page title="HealthShare IHE Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<spacer height="5"/>
<vgroup id='DataSelection'>
<html>Step 1 - Please choose a local CDA file and (up to 3) optional attachments to upload.</html>
<spacer height="5"/>
<form id='uploadForm' width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left" enctype="multipart/form-data">
<hgroup labelPosition="left">
<fileUpload disabled="false" label="Choose CDA file" name="txtCDAFile" id="txtCDAFile" size="20" />
</hgroup>
<spacer height="15"/>
<hgroup labelPosition="left">
<fileUpload disabled="false" label="Choose attachment #1" name="txtAttachFile1" id="txtAttachFile1" size="20" />
</hgroup>
<spacer height="5"/>
<hgroup labelPosition="left">
<fileUpload disabled="false" label="Choose attachment #2" name="txtAttachFile2" id="txtAttachFile2" size="20" />
</hgroup>
<spacer height="5"/>
<hgroup labelPosition="left">
<fileUpload disabled="false" label="Choose attachment #3" name="txtAttachFile3" id="txtAttachFile3" size="20" />
</hgroup>

<spacer height="15"/>
<button id="btnUpload" caption=" Upload / generate document " onclick="zenPage.validateAndSubmit()" />
</form>
</vgroup>

<form id='frmOptions' hidden="true"  width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left" enctype="multipart/form-data">
<spacer height="5"/>
<checkbox label="Enable logging" name="chkLogging" id="chkLogging" title="Route traffic through tcp trace utility"/>
<text label="IHI Number:" id="txtIHINumber" size="30" onchange="zenPage.updatePatientID();"/>
<text label="HPII Number:" id="txtHPII" size="30"/>
<text label="HPIO Number:" id="txtHPIO" size="30"/>
<text label="Organisation Name:" id="txtHPIOName" size="30"/>
<text label="User Name:" id="txtUserName" size="30"/>
<text label="User Role:" id="txtUserRole" size="30"  />
<spacer height="15"/>
<combobox id="cmbPatientID" label=" Select Patient:" size="80" valueList="" displayList="" value="" onchange="zenPage.selectPatient();zenPage.populateSourcePatient();" hidden="true"/>
<text label="Full Patient ID:" name="txtPatientID" id="txtPatientID" size="80" value="#(%page.PatientMRN)#^^^&amp;#(%page.PatientAA)#&amp;ISO" onchange="zenPage.updatePatientID(zenThis);"/>
<combobox id="cmbSourcePatientID" label=" Select Source Patient ID:" size="80" valueList="" displayList="" value="" onchange="zenPage.updateSourcePatientID();zenPage.updateSourceOID();"/>
<text label="Source Patient ID:" name="txtSourcePatientID2" id="txtSourcePatientID2" size="80" value="" title="Used for patient information in HL7 generated data, otherwise optional (if available in submitted cda) source patient id" onchange="zenPage.clearSourcePatientIDCombo();zenPage.updateSourceOID();"/>
<text label="Source OID:" name="txtSourceOID" id="txtSourceOID" size="80" />
<dataCombo id="cmbContentTypeCode" maxRows="10000" label="Content Type Code:" sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" size="100" editable="true" searchKeyLen="10" OnCreateResultSet="CreateCodedEntryRS"><parameter value = 'ContentTypeCode'/></dataCombo>

<dataCombo id="cmbFormatCode" maxRows="10000" label="Format Code:" sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" size="100" editable="true" searchKeyLen="10" OnCreateResultSet="CreateCodedEntryRS"><parameter value = 'FormatCode'/></dataCombo>

<dataCombo id="cmbConfidentialityCode" maxRows="10000" label="Confidentiality Code:" sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" size="100" editable="true" searchKeyLen="10" valueColumn="1" OnCreateResultSet="CreateCodedEntryRS"><parameter value = 'ConfidentialityCode'/></dataCombo>
<dataCombo id="cmbHealthcareFacilityTypeCode" maxRows="10000" label="HealthcareFacilityType Code:" sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" size="100" editable="true" searchKeyLen="10" OnCreateResultSet="CreateCodedEntryRS"><parameter value = 'HealthCareFacilityTypeCode'/></dataCombo>
<dataCombo id="cmbPracticeSettingCode" maxRows="10000" label="Practice Setting Code:" sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" size="100" editable="true" searchKeyLen="10" OnCreateResultSet="CreateCodedEntryRS"><parameter value = 'PracticeSettingCode'/></dataCombo>
<dataCombo id="cmbTypeCode" maxRows="10000" label="Type Code:" sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" size="100" editable="true" searchKeyLen="10" OnCreateResultSet="CreateCodedEntryRS"><parameter value = 'TypeCode'/></dataCombo>
<dataCombo id="cmbClassCode" maxRows="10000" label="Class Code:" sqlLookup="SELECT (Code _' ['_ CodingScheme _'] '_ Description) from HS_IHE.CodedEntry WHERE ID=?" size="100" editable="true" searchKeyLen="10" OnCreateResultSet="CreateCodedEntryRS"><parameter value = 'ClassCode'/></dataCombo>

<combobox id="cmbMimeType" label="MimeType:" size="80" valueList=",text/xml,text/plain,application/pdf,application/zip" value='application/zip' />
		
<dataCombo id="cmbServiceRegistry" size='80' label="EndPoint: *" dropdownWidth="800" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	OnCreateResultSet="CreateServiceRegistryRS"
	maxRows="10000">
</dataCombo>

<checkbox caption="Deprecate all previously registered documents for this patient" name="deprecateDocs" id="chkDeprecateDocs" hidden="true"/>
<spacer height="15"/>
<hgroup width="40%" cellAlign="right">
<button id="btnSend" caption=" Generate XDSb PnR Request " onclick="zenPage.onBeforeStartSend('btnSend',1);" />
<spacer width="5" />
<button id="btnClear" caption=" Cancel " onclick="zenPage.cancel();" />
<spacer width="5" />
<button id="btnDemoData" caption=" Demo Data " onclick="zenPage.DemoData();" />
</hgroup>
</form>
<vgroup>
<pane paneName="asyncPane"/>
</vgroup>
<pane id="paneResults"/>
</pane>
</page>
}

ClientMethod onBeforeStartSend(pButton, pURL = "") [ Language = javascript ]
{
	zenPage.StartSend(pButton,pURL)
}

ClientMethod validateAndSubmit() [ Language = javascript ]
{
	if(zenPage.getComponentById("txtCDAFile").getValue()=='') {
		alert('Choose a file to submit');return;
	}
	zenPage.getComponentById("uploadForm").submit();
}

/// This callback is called when a form on this page is submitted.
/// <var>pSubmit</var> is a <class>%ZEN.Submit</class> object
/// containing details of the form submit.<br/>
/// Upload CCD file content from client machine to server
ClassMethod %OnSubmit(pSubmit As %ZEN.Submit) As %Status
{
	Set tStream=""
	Set tIsCDA=1
	Set tError=""
	
	set tStream = %request.GetMimeData("$V_txtCDAFile")
	if $isObject(tStream) {
		Set file = ##class(%Stream.GlobalCharacter).%New("^CacheTemp.IHETest")
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
	
	// Loop through 3 possible attachments
	For tIdx=1:1:3 {
		set tAttachStream = %request.GetMimeData("$V_txtAttachFile"_tIdx)

		if $isObject(tAttachStream) {
			Set file = ##class(%Stream.GlobalCharacter).%New("^CacheTemp.IHETest")
			Do tAttachStream.Rewind()
			Do file.CopyFrom(tAttachStream)
			set tSC = file.%Save()
			if ($$$ISOK(tSC)) {
				Set %session.Data("IHE.Test.AU","PnRAttachStream"_tIdx)=file.%Oid()
				Set %session.Data("IHE.Test.AU","PnRAttachName"_tIdx)=tAttachStream.Attributes("FileName")
			}
		} else { quit }
	}
	Quit $$$OK
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set tServiceRegistry=$g(%session.Data("IHE.Test",..%ClassName(0),"ServiceRegistry"))
	Set:tServiceRegistry="" tServiceRegistry=..#SERVICEREGISTRYENTRY

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
	Else {
		// Reset attachments
		For tIdx=1:1:3 {
			Set tDocOID=$g(%session.Data("IHE.Test.AU","PnRAttachStream"_tIdx))
			If tDocOID]"" {
				Do ##class(%Stream.GlobalCharacter).%Delete(tDocOID)
				kill %session.Data("IHE.Test.AU","PnRAttachStream"_tIdx)
				kill %session.Data("IHE.Test.AU","PnRAttachName"_tIdx)
			}
		}
	}
	Set tDocID=$g(%session.Data("IHE.Test","PnRStream"))
	
	If %page.TESTGROUPID]"" {
		Set tGroup = ##class(HS.Test.UI.TestGroup).%OpenId(%page.TESTGROUPID)

		If $isObject(tGroup) {
			Set tServiceRegistry=tGroup.AdditionalInfo.GetAt("ServiceRegistryAU")
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

Method Send() As %String [ ZenMethod ]
{
	try {
		set tSC = $$$OK,tSessionID=""
		//Set tSourcePatientID=..%GetValueById("cmbSourcePatientID")
		//Set:tSourcePatientID="" tSourcePatientID=..%GetValueById("txtSourcePatientID")
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
		If tPatientId="" {
			Set %session.Data("IHE.Test","PnRSubmitError")="Select Patient"
		} Else {

			#;Put together a ProviderAndRegisterRequest
		    Set tRequest = ..GetRequestMessage()
		    
			Set tRequest.PatientId=tPatientId
			#define getCodedEntry(%combo,%code,%required) Set %CodedEntry=##class(HS.IHE.CodedEntry).%OpenId(..%GetValueById(%combo)),%code="" Set:$isObject(%CodedEntry) %code=##class(HS.IHE.XDSb.Types.CodedValue).Create(%CodedEntry.Code,%CodedEntry.CodingScheme,%CodedEntry.Description) if %code="" && (%required) {&js<alert('No value found for #($p(%combo,"cmb",2))#');> Quit} else { Set %session.Data("IHETest",..%ClassName(0),%combo)=..%GetValueById(%combo) }
			#define insertCodedEntry(%object,%propertyName,%combo,%required) $$$getCodedEntry(%combo,%codedEntry,%required) If $isObject(%codedEntry) {Set property=$property(%object,%propertyName) Do property.Insert(%codedEntry)}
			#define setCodedEntry(%object,%propertyName,%combo,%required) $$$getCodedEntry(%combo,%codedEntry,%required) If $isObject(%codedEntry) {Set $property(%object,%propertyName)=%codedEntry}

			$$$setCodedEntry(tRequest,"ContentTypeCode","cmbContentTypeCode",1)
			
			Set tRequest.SourceId="1.2.36.1.2001.1003.0."_..%GetValueById("txtHPIO")
			Set tDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
			set tAuthor = ##class(HS.IHE.XDSb.Types.Author).%New()
    		set tAuthor.AuthorPerson = "^"_..%GetValueById("txtUserName")_"^^^^^^^&1.2.36.1.2001.1003.0."_..%GetValueById("txtHPII")_"&ISO"
    		do tAuthor.AuthorInstitution.Insert(##class(HS.Types.IHE.XDSb.SlotValue).%New(..%GetValueById("txtHPIOName")_"^^^^^^^^^1.2.36.1.2001.1003.0."_..%GetValueById("txtHPIO")))
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

			If tStream.%IsA("%Stream.GlobalBinary") ||$G(%session.Data("IHE.Test","SDA")) {
				Do tDocument.Body.CopyFrom(tStream)
				Do tDocument.Body.Rewind()
				If tDocument.CreationTime="" Set tDocument.CreationTime=##class(HS.Util.XSLTHelper).xmltimestampToUTC($tr($zdt($h,8),": "))
				Set:tDocument.LanguageCode="" tDocument.LanguageCode="en-US"
				kill %session.Data("IHE.Test","SDA")

			} Else {
				Do tDocument.BodyCharacter.CopyFrom(tStream)
				Do tDocument.BodyCharacter.Rewind()
			}
			Set tDocument.MimeType=..%GetValueById("cmbMimeType")

			If tDocument.MimeType="" &js< alert('#($$$Text("MimeType is required"))#');> Quit
			Set tDocument.Availability=1
			
			Set tXPathDoc=""
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:id","@root",.tValue,.tXPathDoc)
			If tValue'="" {
				Set tDocument.UniqueId=tValue
				Set tRequest.UniqueId=tValue
			}
			
			// Insert attachments into tDocument.ZipItems
			For tIdx=1:1:3 {
				Set tDocID=$g(%session.Data("IHE.Test.AU","PnRAttachStream"_tIdx))
				If tDocID]"" {
					Set tFileName=$g(%session.Data("IHE.Test.AU","PnRAttachName"_tIdx))
					set tAttachStream=##class(%Stream.GlobalCharacter).%Open(tDocID)
					Set tZipItem = ##class(HS.Types.ZipItem).%New()
					Set tZipItem.Filename=tFileName
					Do tZipItem.File.CopyFrom(tAttachStream)
					Do tDocument.ZipItems.Insert(tZipItem)
				}
			}
			
			Do tRequest.Documents.Insert(tDocument)
			
			Set tRequest.SAMLData.IHINumber=%page.%GetValueById("txtIHINumber")
			Set tRequest.SAMLData.NPI=%page.%GetValueById("txtHPII")
			Set tRequest.SAMLData.OrganizationID=%page.%GetValueById("txtHPIO")
			Set tRequest.SAMLData.Organization=%page.%GetValueById("txtHPIOName")
			Set tRequest.SAMLData.UserName=%page.%GetValueById("txtUserName")
			Set tRequest.SAMLData.Role=%page.%GetValueById("txtUserRole")
			Set tRequest.SAMLData.UseRoleForAudit=1
			
			// Approver PersonId = HPII
			Set tRequest.Approver.PersonId = tRequest.SAMLData.NPI
			// Approver PersonName = UserName
			Set tRequest.Approver.PersonName.FamilyName=tRequest.SAMLData.UserName
			
			Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
			Set tTest=tGroup.NewTest(tRequest,%page.%GetValueById("chkLogging"))
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
					For tIdx=1:1:3 {
						Set tDocOID=$g(%session.Data("IHE.Test","PnRAttachStream"_tIdx))
						If tDocOID]"" {
							Do ##class(%Stream.GlobalCharacter).%Delete(tDocOID)
							kill %session.Data("IHE.Test","PnRAttachStream"_tIdx)
							kill %session.Data("IHE.Test","PnRAttachName"_tIdx)
						}
					}
				}
				
			} Else {
				Do ..LogMessage("Unable to locate status"_tResponse.ContentStream.Read())
			}
		}
	}
}

Method GetRequestMessage() As HS.Message.IHE.XDSb.ProvideAndRegisterRequest
{
	Set tRequest=##class(HS.AU.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
	Set tRequest.SAMLData.IHINumber=$G(%session.Data("IHETest.AU","LastIHINumber"))
	// Pull in demo values
	/*
	Set tRequest.SAMLData.NPI="8003616566666809"
	Set tRequest.SAMLData.OrganizationID="8003629900019452"
	Set tRequest.SAMLData.Organization="DHS5504"
	Set tRequest.SAMLData.UseRoleForAudit=1
	Set tRequest.SAMLData.UserName="NEHTA_Test_User"
	Set tRequest.SAMLData.Role="HealthcareProvider"
	Set tRequest.SAMLData.UseRoleForAudit=1
	*/
	Quit tRequest
}

Method cancel() [ ZenMethod ]
{
	Set tDocOID=$g(%session.Data("IHE.Test","PnRStream"))
	If tDocOID]"" {
		Do ##class(%Stream.GlobalCharacter).%Delete(tDocOID)
		kill %session.Data("IHE.Test","PnRStream")
	}
	
	For tIdx=1:1:3 {
		Set tDocOID=$g(%session.Data("IHE.Test","PnRAttachStream"_tIdx))
		If tDocOID]"" {
			Do ##class(%Stream.GlobalCharacter).%Delete(tDocOID)
			kill %session.Data("IHE.Test","PnRAttachStream"_tIdx)
			kill %session.Data("IHE.Test","PnRAttachName"_tIdx)
		}
	}
	
	&js<window.location.reload();>
}

ClientMethod DemoData() [ Language = javascript ]
{
	this.getComponentById('txtIHINumber').setValue("8003608500128236");
	this.getComponentById('txtHPII').setValue("8003616566666809");
	this.getComponentById('txtHPIO').setValue("8003629900019452");
	this.getComponentById('txtHPIOName').setValue("DHS5504");
	this.getComponentById('txtUserName').setValue("NEHTA_Test_User");
	this.getComponentById('txtUserRole').setValue("HealthcareProvider");
	
	this.PopulateComboBoxes(1);
	this.updatePatientID();
}

Method PopulateComboBoxes(pFlag As %Boolean = 1) [ ZenMethod ]
{
	#dim component as %ZEN.Component.combobox
	If pFlag=1 {
		Set tCodes = $lb("FormatCode||1.2.36.1.2001.1006.1.20000.26||PCEHR_FormatCodes","ConfidentialityCode||GENERAL||PCEHR_DocAccessLevels","HealthcareFacilityTypeCode||8401||ANZSIC","PracticeSettingCode||8401-6||ANZSIC","TypeCode||18842-5||LOINC","ClassCode||18842-5||LOINC","ContentTypeCode||18842-5||LOINC")
	}
	Set:tCodes="" tCodes = $lb("FormatCode||2.16.840.1.113883.10.20.1||2.16.840.1.113883.3.88","ConfidentialityCode||N||2.16.840.1.113883.5.25","HealthcareFacilityTypeCode||Outpatient||Connect-a-thon healthcareFacilityTypeCodes","PracticeSettingCode||General Medicine||Connect-a-thon practiceSettingCodes","TypeCode||34133-9||LOINC","ClassCode||Summarization of episode||Connect-a-thon classCodes","ContentTypeCode||Summarization of episode||Connect-a-thon contentTypeCodes||Summarization of episode")
	For tIdx=1:1:$ll(tCodes) {
		Set tCode=$li(tCodes,tIdx)
		Set tField = $p(tCode,"||")
		Set tID = $g(%session.Data("IHE.Test",..%ClassName(0),"cmb"_tField))
		If tID="" {
			Set tResult = ##class(%SQL.Statement).%ExecDirect("","SELECT ID FROM HS_IHE.CodedEntry WHERE CodeType=? and Code=? and CodingScheme=?",$p(tCode,"||",1),$p(tCode,"||",2),$p(tCode,"||",3))
			if tResult.%Next() { 
				Set tID = tResult.ID
			}
		}
		Do ..%SetValueById("cmb"_$p(tCode,"||"),tID)
	}
}

/// Override for AU to set PatientID based on IHI Number
ClientMethod updatePatientID() [ Language = javascript ]
{
	var value = zenPage.getComponentById('txtIHINumber').getValue();
	var AAOID = "1.2.36.1.2001.1003.0"
	var newvalue = value+"^^^&"+AAOID+"&ISO"
	zenPage.getComponentById('txtPatientID').setValue(newvalue);
}

ClientMethod Clear() [ Language = javascript ]
{
	this.getComponentById('txtIHINumber').setValue("");
	this.getComponentById('txtHPII').setValue("");
	this.getComponentById('txtHPIO').setValue("");
	this.getComponentById('txtHPIOName').setValue("");
	this.getComponentById('txtUserName').setValue("");
	this.getComponentById('txtUserRole').setValue("");
	
	//zen('cmbPatientID').setValue("");
	//zen('txtPatientID').setValue("");
	//zen('chkDocTypeStable').setValue("");
	//zen('chkDocTypeOnDemand').setValue("");
	//zen('cmbDocStatus').setValue("Approved");
	zenPage.ClearResultsPane();
}

}
