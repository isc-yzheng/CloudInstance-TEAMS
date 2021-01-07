Class HS.Test.UI.DSUB Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Query Patient CCD";

Parameter SERVICEREGISTRYENTRY = "DSUB.NotificationBroker";

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
<html>Please specify document search criteria for patient</html>
<spacer height="5"/>
<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left" >
<spacer height="5"/>
<vgroup>
<hgroup labelPosition="left">
<checkbox label="Enable logging" id="chkLogging" title="Route traffic through tcp trace utility"/>
<checkbox label="Execute Connectathon Tests" id="chkConnectathonTests" title="Specific test scenarios for connectathon" value="true" hidden="true"/>
</hgroup>
<hgroup labelPosition="left">
<radioButton name='radType' optionValue="Subscribe" value='Subscribe' label='Subscribe' onclick="zenPage.chooseType('Subscribe')"  />
<radioButton name='radType' optionValue="Cancel" value='Subscribe' label='Cancel Subscription' onclick="zenPage.chooseType('Cancel')"  />
</hgroup>
</vgroup>
<pane id='SubscribeOptions'  >
<vgroup labelPosition="left">
<combobox id="cmbPatientID" label=" Select Patient:" size="90" valueList="" displayList="" value="" onchange="zenPage.selectPatient();" />
<text label="Full Patient ID:" name="patientID" id="txtPatientID" size="80" value="" onchange="zenPage.updatePatientID(zenThis);"/>
<text label="Consumer Endpoint:" id="txtConsumer" size="80" value="DSUB.NotificationConsumer" title="Service registry entry used to determine where notifications will be sent"/>
<hgroup labelPosition="left">
<radioButton name='radTopic' optionValue="M" value='M' label='Minimal'/>
<radioButton name='radTopic' optionValue="F" value='M' label='Full'  />
</hgroup>
</vgroup>
<vgroup>
<hgroup id='filter1' labelPosition="left">
<combobox id="cmbFilter1" label=" Filter:" size="52" valueList="$XDSDocumentEntryClassCode,$XDSDocumentEntryTypeCode,$XDSDocumentEntryPracticeSettingCode,$XDSDocumentEntryHealthcareFacilityTypeCode,$XDSDocumentEntryEventCodeList,$XDSDocumentEntryConfidentialityCode,$XDSDocumentEntryFormatCode" displayList="$XDSDocumentEntryClassCode,$XDSDocumentEntryTypeCode,$XDSDocumentEntryPracticeSettingCode,$XDSDocumentEntryHealthcareFacilityTypeCode,$XDSDocumentEntryEventCodeList,$XDSDocumentEntryConfidentialityCode,$XDSDocumentEntryFormatCode" value="" onchange="zenPage.UpdateFilter('cmbFilter1');"/>
<combobox id="cmbFilterOption1" label="Value:" size="52" value="" />
<text label="Value:" id="txtFilterValue1" size="52" value="" hidden='true'/>
</hgroup>
<hgroup labelPosition="left">
<combobox id="cmbFilter2" label=" Filter:" size="52" valueList="$XDSDocumentEntryClassCode,$XDSDocumentEntryTypeCode,$XDSDocumentEntryPracticeSettingCode,$XDSDocumentEntryHealthcareFacilityTypeCode,$XDSDocumentEntryEventCodeList,$XDSDocumentEntryConfidentialityCode,$XDSDocumentEntryFormatCode" displayList="$XDSDocumentEntryClassCode,$XDSDocumentEntryTypeCode,$XDSDocumentEntryPracticeSettingCode,$XDSDocumentEntryHealthcareFacilityTypeCode,$XDSDocumentEntryEventCodeList,$XDSDocumentEntryConfidentialityCode,$XDSDocumentEntryFormatCode" value="" onchange="zenPage.UpdateFilter('cmbFilter2');"/>
<combobox id="cmbFilterOption2" label="Value:" size="52" value="" />
<text label="Value:" id="txtFilterValue2" size="52" value="" hidden='true'/>
</hgroup>
<hgroup labelPosition="left">
<combobox id="cmbFilter3" label=" Filter:" size="52" valueList="$XDSDocumentEntryClassCode,$XDSDocumentEntryTypeCode,$XDSDocumentEntryPracticeSettingCode,$XDSDocumentEntryHealthcareFacilityTypeCode,$XDSDocumentEntryEventCodeList,$XDSDocumentEntryConfidentialityCode,$XDSDocumentEntryFormatCode" displayList="$XDSDocumentEntryClassCode,$XDSDocumentEntryTypeCode,$XDSDocumentEntryPracticeSettingCode,$XDSDocumentEntryHealthcareFacilityTypeCode,$XDSDocumentEntryEventCodeList,$XDSDocumentEntryConfidentialityCode,$XDSDocumentEntryFormatCode" value="" onchange="zenPage.UpdateFilter('cmbFilter3');"/>
<combobox id="cmbFilterOption3" label="Value:" size="52" value="" />
<text label="Value:" id="txtFilterValue3" size="52" value="" hidden='true'/>
</hgroup>
</vgroup>
<spacer height="15"/>
</pane>
<fieldSet id='CancelOptions' hidden='true'>
<text label="Subscription ID:" id="txtSubscriptionID" size="80" />
</fieldSet>
<dataCombo id="cmbServiceRegistry" size='80' label="EndPoint: *" dropdownWidth="800" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	OnCreateResultSet="CreateServiceRegistryRS"
	maxRows="10000">
</dataCombo>
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

ClientMethod selectPatient() [ Language = javascript ]
{
	patientID = zenPage.getComponentById("cmbPatientID").getValue();
	zenPage.getComponentById("txtPatientID").setValue(patientID);
}

ClientMethod chooseType(type) [ Language = javascript ]
{
	if(type=='Subscribe') {
		subscribe=false;
		cancel=true;
	} else {
		subscribe=true;
		cancel=false;
	}
	
	zenPage.getComponentById("SubscribeOptions").setHidden(subscribe);
	zenPage.getComponentById("CancelOptions").setHidden(cancel);
}

ClientMethod Clear() [ Language = javascript ]
{
	zen('cmbPatientID').setValue("");
	zen('txtPatientID').setValue("");
	zen('chkDocTypeStable').setValue("");
	zen('chkDocTypeOnDemand').setValue("");
	zen('cmbDocStatus').setValue("Approved");
	zenPage.ClearResultsPane();
}

Method UpdateFilter(pControl) As %Status [ ZenMethod ]
{
	Set tSC=$$$OK
	try {
		Set tFilterCombo =%page.%GetComponentById(pControl)
		Set tValue = tFilterCombo.value
		
		/// removed $XDSDocumentEntryReferenceIdList and $XDSDocumentEntryAuthorPerson for now
		Set tList = $Case(tValue,"$XDSDocumentEntryReferenceIdList":"text","$XDSDocumentEntryAuthorPerson":"text",:$p(tValue,"$XDSDocumentEntry",2))
		//$XDSDocumentEntryClassCode,$XDSDocumentEntryTypeCode,$XDSDocumentEntryReferenceIdList,$XDSDocumentEntryPracticeSettingCode,$XDSDocumentEntryHealthcareFacilityTypeCode,$XDSDocumentEntryEventCodeList,$XDSDocumentEntryConfidentialityCode,$XDSDocumentEntryFormatCode,$XDSDocumentEntryAuthorPerson" displayList="$XDSDocumentEntryClassCode,$XDSDocumentEntryTypeCode,$XDSDocumentEntryReferenceIdList,$XDSDocumentEntryPracticeSettingCode,$XDSDocumentEntryHealthcareFacilityTypeCode,$XDSDocumentEntryEventCodeList,$XDSDocumentEntryConfidentialityCode,$XDSDocumentEntryFormatCode,$XDSDocumentEntryAuthorPerson
		If tList="text" {
			set tTextField=%page.%GetComponentById("txtFilterValue"_$e(pControl,*))
			Set tTextField.hidden=0
			Set tControl = "cmbFilterOption"_$e(pControl,*)
			set tCombo=%page.%GetComponentById(tControl)
			Set tCombo.hidden=1
		} Else {
			Set (tDisplay,tValueList)=""
			Set tResult = ##class(%SQL.Statement).%ExecDirect("","SELECT Code,CodingScheme,Description FROM HS_IHE.codedEntry WHERE codetype=? ORDER BY Description",tList)
			While tResult.%Next() {
				Set tDisplay=tDisplay_","_tResult.Code_" ["_tResult.CodingScheme_"]"_$S(tResult.Description]"":..%EscapeComma(tResult.Description),1:"")
				Set tValueList=tValueList_","_tResult.Code_"^^^"_tResult.CodingScheme
			}		
			Set tControl = "cmbFilterOption"_$e(pControl,*)
			set tCombo=%page.%GetComponentById(tControl)
			Set tCombo.displayList=$e(tDisplay,2,*)
			Set tCombo.valueList=$e(tValueList,2,*)
			Set tCombo.hidden=0
		}
	
	} catch ex { 
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

Method Send() As %String [ ZenMethod ]
{
	try {
		Set tSessionID="",tSC=$$$OK
		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		If %page.%GetValueByName("radType")="Subscribe" {
			Set tPatientId=%page.%GetValueById("txtPatientID")
			If tPatientId="" {
				&js< alert('Patient ID is required');>
				Quit
			}
			Set tRequest = ##class(HS.Message.IHE.DSUB.SubscriptionRequest).%New()
			Do tRequest.SetDocumentPatientId($P(tPatientId,"^"),$p(tPatientId,"&",2))
			Set tConsumer=%page.%GetValueById("txtConsumer")
			Set tServiceObject = ##class(HS.Registry.Service.SOAP).EndPointForNameType(tConsumer,"SOAP")
			If '$IsObject(tServiceObject) {
				&js< alert('Service Registry [Consumer:#(tConsumer)#] not found');>
				Quit
			}
			Do tGroup.AdditionalInfo.SetAt(tConsumer,"Consumer")

			Set tRequest.RecipientAddress=tServiceObject.EndPoint
			Set tRequest.Topic=%page.%GetValueByName("radTopic")
			Set tRequest.Type="Document"
			If ..%GetValueById("chkConnectathonTests") {
				Do ..UpdateConnectathonTests(tRequest,tPatientId)
			} Else {
				For tIdx=1:1:3 {
					Set tFilter=%page.%GetValueById("cmbFilter"_tIdx)
					Set tCodeScheme = %page.%GetValueById("cmbFilterOption"_tIdx)
					Set tCode=$p(tCodeScheme,"^^^"),tScheme=$p(tCodeScheme,"^^^",2)
					//Set tScheme = %page.%GetValueById("txtFilterScheme"_tIdx)
					If tFilter]"" {
						If (tCode="" || tScheme="") {
							Set tSC = $$$ERROR($$$GeneralError,$$$Text("Filter selected code and scheme are required"))
						} Else {
							Set tSC= tRequest.AddFilterValues(tFilter,tCode,tScheme)
							Do tGroup.AdditionalInfo.SetAt(tFilter,"Filter"_tIdx)
							Do tGroup.AdditionalInfo.SetAt(tCodeScheme,"FilterOption"_tIdx)

						}
					}
					Quit:$$$ISERR(tSC)
				}
			}
			If $$$ISERR(tSC) {
				&js< alert('#($system.Status.GetErrorText(tSC))#');>
				Quit
			}

			Set:tPatientId]"" %session.Data("IHE.Test","PatientID")=tPatientId
			Set %session.Data("IHE.Test",..%ClassName(0),"Topic")=tRequest.Topic
			Do tGroup.AdditionalInfo.SetAt(tRequest.Topic,"Topic")
			Do tGroup.AdditionalInfo.SetAt(tPatientId,"PatientID")
		} Else {
			Set tSubscriptionId=%page.%GetValueById("txtSubscriptionID")
			If tSubscriptionId="" {
				&js< alert('Subscription ID is required');>
				Quit
			}
			Set tRequest = ##class(HS.Message.IHE.DSUB.CancelSubscriptionRequest).%New()
			Set tRequest.SubscriptionID=tSubscriptionId
			Do tGroup.AdditionalInfo.SetAt(tSubscriptionId,"SubscriptionID")
		
		}

		Do tRequest.AdditionalInfo.SetAt("HS.IHE.DSUB.Subscriber.Operations","Host")
		Do tGroup.AdditionalInfo.SetAt(%page.%GetValueByName("radType"),"RadType")

		Set %session.Data("IHE.Test",..%ClassName(0),"radType")=%page.%GetValueByName("radType")
	
		Set tTest=tGroup.NewTest(tRequest,%page.%GetValueById("chkLogging"))
		Set tSessionID = ..ExecuteAsync(tTest,tGroup)

		
	} catch ex {
		Do ..LogException(ex,$g(tGroup))
		Set tSessionID=""
	}
	Quit tSessionID
}

Method UpdateConnectathonTests(pRequest, pPatientID) As %Status
{
	/*
XDSDocumentEntryPracticeSettingCode 	

    Emergency (IHE*1014 & IHE*1024)
    Orthopedics (IHE*1015)
    General Medicine (IHE*1016)

XDSDocumentEntryHealthcareFacilityTypeCode 	

    Hospital Setting (IHE*1014, IHE*1024)
    Emergency Department (IHE*1015)
    Outpatient (IHE*1016)

XDSDocumentEntryCodeList 	

    Amputation (all records)

XDSDocumentEntryConfidentialityCode 	

    N (ie normal) (IHE*1014, IHE*1024)
    R (ie restricted) (IHE*1015, IHE*1016)

XDSDocumentEntryFormatCode 	

    CDAR2/IHE 1.0 (all records)

XDSDocumentEntryAuthorPerson and XDSSubmissionSetAuthor 	

    Dsub^Author-One (IHE*1014, IHE*1016, IHE*1024)
    Dsub^Author-Two (IHE*1015)

XDSSubmissionSetIntendedRecipient (REQUIRED) 	

    tbd...under construction

XDSSubmissionSetSourceId 	

    1.3.6.1.4.1.21367.2008.1.2.178 (IHE*1014, IHE*1015, IHE*1016, IHE*1024)
	
	*/
	#define AddFilter(%pRequest,%type,%code,%scheme) Set tSC = %pRequest.AddFilterValues(%type,%code,%scheme) Quit:$$$ISERR(tSC)
	#define AddFilterItem(%pRequest,%type,%value) Set tFilterItem = ##class(HS.Types.IHE.DSUB.SubscriptionItems).%New(),tFilterItem.Item=%type Do tFilterItem.Values.Insert(%value),%pRequest.FilterItems.Insert(tFilterItem)

	try {
		Set tSC = $$$OK
		Set tID=$p($p(pPatientID,"^"),"-",2)
		If tID="1014" {
			/// no summarization of episode in the loaded set
			//Set tCode="
			//$XDSDocumentEntryPracticeSettingCode / Emergency 
			//$XDSDocumentEntryHealthcareFacilityTypeCode / Hospital Setting
			//$XDSDocumentEntryConfidentialityCode / N			
			$$$AddFilter(pRequest,"$XDSDocumentEntryPracticeSettingCode","Emergency","Connect-a-thon practiceSettingCodes")
			$$$AddFilter(pRequest,"$XDSDocumentEntryHealthcareFacilityTypeCode","Hospital Setting","Connect-a-thon healthcareFacilityTypeCodes")
			//$$$AddFilter(pRequest,"$XDSDocumentEntryConfidentialityCode","N","2.16.840.1.113883.5.25")
			
			//$$$AddFilterItem(pRequest,"$XDSSubmissionSetSourceId","1.3.6.1.4.1.21367.2008.1.2.178")
			SEt pRequest.Topic="F"
		} ElseIf tID=1015 {
			//$XDSDocumentEntryPracticeSettingCode / Orthopedics 
			//$XDSDocumentEntryHealthcareFacilityTypeCode / Emergency Department
			$$$AddFilter(pRequest,"$XDSDocumentEntryPracticeSettingCode","Orthopedics","Connect-a-thon practiceSettingCodes")
			$$$AddFilter(pRequest,"$XDSDocumentEntryHealthcareFacilityTypeCode","Emergency Department","Connect-a-thon healthcareFacilityTypeCodes")
			//$$$AddFilterItem(pRequest,"$XDSSubmissionSetSourceId","1.3.6.1.4.1.21367.2008.1.2.178")
			SEt pRequest.Topic="M"
			
			//Orthopedics
		} ElseIf tID=1016 {
			//$XDSDocumentEntryPracticeSettingCode / General Medicine 
			//$XDSDocumentEntryHealthcareFacilityTypeCode / Outpatient
			
			$$$AddFilter(pRequest,"$XDSDocumentEntryPracticeSettingCode","General Medicine","Connect-a-thon practiceSettingCodes")
			$$$AddFilter(pRequest,"$XDSDocumentEntryHealthcareFacilityTypeCode","Outpatient","Connect-a-thon healthcareFacilityTypeCodes")
			//$$$AddFilterItem(pRequest,"$XDSSubmissionSetSourceId","1.3.6.1.4.1.21367.2008.1.2.178")
			Set pRequest.Topic="M"

		} ElseIf tID=1024 {
			//$XDSDocumentEntryPracticeSettingCode / Emergency 
			//$XDSDocumentEntryHealthcareFacilityTypeCode / Hospital Setting
			//$XDSDocumentEntryConfidentialityCode / N					
			$$$AddFilter(pRequest,"$XDSDocumentEntryPracticeSettingCode","Emergency","Connect-a-thon practiceSettingCodes")
			$$$AddFilter(pRequest,"$XDSDocumentEntryHealthcareFacilityTypeCode","Hospital Setting","Connect-a-thon healthcareFacilityTypeCodes")
			//$$$AddFilter(pRequest,"$XDSDocumentEntryConfidentialityCode","N","2.16.840.1.113883.5.25")
			//$$$AddFilterItem(pRequest,"$XDSSubmissionSetSourceId","1.3.6.1.4.1.21367.2008.1.2.178")
			Set pRequest.Topic="F"
		}
	} catch ex {
	}
	Quit tSC
}

Method DisplayTestResult(pTest As HS.Test.UI.Test, pGroupTest As HS.Test.UI.TestGroup = "", pClear = 0)
{
	Do ##super(pTest,pGroupTest,pClear)
	Set tResponse=pTest.Response
	If $IsObject(tResponse) && $$$ISOK(pTest.Status) {
		Do:..IsConnectathon ..AddContentButton("Request Data",pTest.SessionId,"ServiceRequest","RequestContent","xml")
		Do:..IsConnectathon ..AddContentButton("Response Data",pTest.SessionId,"ServiceResponse","ResponseContent","xml")
		If tResponse.%IsA("HS.Message.IHE.DSUB.SubscriptionResponse") {
			Do ..LogMessage("Subscription ID:"_tResponse.SubscriptionID)
			Do ..LogMessage("Cancellation Address: "_tResponse.CancellationAddress)
			Do ..%SetValueById("txtSubscriptionID",tResponse.SubscriptionID)
		} 
		Set tErrorText=tResponse.Errors.getErrorText()
		Do:tErrorText]"" ..LogMessage(tErrorText)
	}
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set tPatientId=$g(%session.Data("IHE.Test","PatientID"))
	Set tType=$g(%session.Data("IHE.Test",..%ClassName(0),"radType"))
	Set tTopic=$g(%session.Data("IHE.Test",..%ClassName(0),"Topic"))
	Set tConsumer = $g(%session.Data("IHE.Test",..%ClassName(0),"Consumer"))
	If ..IsConnectathon Set %page.%GetComponentById("chkConnectathonTests").hidden=0
	Set tSC= ..AddServiceEntries(..#SERVICEREGISTRYENTRY) 
	Do ..SetLogging()
	Do ..AddRecentPatients("","cmbPatientID")
	If %page.TESTGROUPID]"" {
		Set tGroup = ##class(HS.Test.UI.TestGroup).%OpenId(%page.TESTGROUPID)
		Set tPatientId=tGroup.AdditionalInfo.GetAt("PatientID")
		For tIdx=1:1:3 {
			Set tFilter(tIdx)=tGroup.AdditionalInfo.GetAt("Filter"_tIdx)
			Set tFilter(tIdx,"FilterOption")=tGroup.AdditionalInfo.GetAt("FilterOption"_tIdx)
		}
		Set tTopic = tGroup.AdditionalInfo.GetAt("Topic")
		Set tConsumer = tGroup.AdditionalInfo.GetAt("Consumer")
		If $isObject(tGroup) Do ..PostAsyncExecuteDisplay(tGroup,1)
	}
	Do ..%SetValueById("txtPatientID",tPatientId)
	For tIdx=1:1:3 {
		Do ..%SetValueById("cmbFilter"_tIdx,$g(tFilter(tIdx)))
		Do ..%SetValueById("cmbFilterOption"_tIdx,$g(tFilter(tIdx,"FilterOption")))
	}
	Do:tType]"" ..%SetValueById("radType",tType)
	Do:tTopic]"" ..%SetValueById("radTopic",tTopic)
	Do:tConsumer]"" ..%SetValueById("txtConsumer",tConsumer)
	Quit $$$OK
}

}
