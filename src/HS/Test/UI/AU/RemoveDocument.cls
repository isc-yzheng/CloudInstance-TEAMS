Class HS.Test.UI.AU.RemoveDocument Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Remove PCEHR Document";

Parameter SERVICEREGISTRYENTRY = "AU.PCEHR.RemoveDocument";

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
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page title="HealthShare Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<spacer height="15"/>
<html>Document Identifier</html>
<spacer height="5"/>
<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left">
<checkbox label="Enable logging" id="chkLogging"/>
<spacer height="5"/>
<text label="IHI Number:" id="txtIHINumber" size="30"/>
<text label="HPII Number:" id="txtHPII" size="30"/>
<text label="HPIO Number:" id="txtHPIO" size="30"/>
<text label="Organisation Name:" id="txtHPIOName" size="30"/>
<text label="User Name:" id="txtUserName" size="30"/>
<text label="User Role:" id="txtUserRole" size="30"  />
<spacer height="15"/>
<combobox id="cmbServiceRegistry" label="EndPoint: *" labelClass="caption" 
 dropdownWidth="300">
</combobox>

<text label="Document Id: *" id="txtDocumentId" size="30" required="true"  />
<combobox id="cmbReason" label="Reason for Removal: *" labelClass="caption" dropdownWidth="300" editable="false" required="true">
<option value="Withdrawn" text="Withdrawn"/>
<option value="ElectToRemove" text="Elect To Remove"/>
<option value="IncorrectIdentity" text="Incorrect Identity"/> 
</combobox>

<hgroup width="40%" cellAlign="right">
<button id="btnSend" caption=" Submit Request " onclick="zenPage.Start('btnSend',1);zenPage.Send();" />
<spacer width="5" />
<button id="btnClearDemo" caption=" Clear " onclick="zenPage.ClearDemographics();" />
<spacer width="5" />
<button id="btnDemoData" caption=" Demo Data " onclick="zenPage.DemoData();" />

</hgroup>

</form>
<pane id="paneResults"/>
</pane>
</page>
}

ClientMethod ClearDemographics() [ Language = javascript ]
{
	this.getComponentById('txtIHINumber').setValue("");
	this.getComponentById('txtHPII').setValue("");
	this.getComponentById('txtHPIO').setValue("");
	this.getComponentById('txtHPIOName').setValue("");
	this.getComponentById('txtUserName').setValue("");
	this.getComponentById('txtUserRole').setValue("");
	this.getComponentById('txtDocumentId').setValue("");
	this.getComponentById('cmbReason').setValue("");
}

ClientMethod DemoData() [ Language = javascript ]
{
	this.getComponentById('txtIHINumber').setValue("8003608500128236");
	this.getComponentById('txtHPII').setValue("8003616566666809");
	this.getComponentById('txtHPIO').setValue("8003629900019452");
	this.getComponentById('txtHPIOName').setValue("DHS5504");
	this.getComponentById('txtUserName').setValue("NEHTA_Test_User");
	this.getComponentById('txtUserRole').setValue("HealthcareProvider");
	this.getComponentById('cmbReason').setValue("Withdrawn");
	docid=prompt("Please supply a document id to remove:");
	this.getComponentById('txtDocumentId').setValue(docid);
}

Method Send() [ ZenMethod ]
{
		
	try {
		if %page.%GetValueById("txtDocumentId")="" {
			set tSC=$$$ERROR(5001,"Document Id is required.")
			$$$ThrowStatus(tSC)
		} 
		if %page.%GetValueById("cmbReason") {
			set tSC=$$$ERROR(5001,"Reason for Removal is required.")
			$$$ThrowStatus(tSC)
		}
		
		set tRequest=##class(HS.AU.Message.PCEHR.RemoveDocumentRequest).%New()
		Set tRequest.SAMLData.IHINumber=%page.%GetValueById("txtIHINumber")
		Set tRequest.SAMLData.NPI=%page.%GetValueById("txtHPII")
		Set tRequest.SAMLData.OrganizationID=%page.%GetValueById("txtHPIO")
		Set tRequest.SAMLData.Organization=%page.%GetValueById("txtHPIOName")
		Set tRequest.SAMLData.UserName=%page.%GetValueById("txtUserName")
		Set tRequest.SAMLData.Role=%page.%GetValueById("txtUserRole")
		Set tRequest.SAMLData.UseRoleForAudit=1

		Set tRequest.DocumentID=%page.%GetValueById("txtDocumentId")
		Set tRequest.ReasonForRemoval=%page.%GetValueById("cmbReason")
		
		Do tRequest.AdditionalInfo.SetAt("HS.AU.PCEHR.Consumer.Operations","Operation")

		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Set tTest=tGroup.NewTest(tRequest,%page.%GetValueById("chkLogging"))
		Set tSC = ..Execute(tTest,tGroup)
		Do ..DisplayTestResult(tTest,tGroup) Quit:$$$ISERR(tSC)
		Set tResponse=tTest.Response

		If $IsObject(tResponse) {
			If $$$ISOK(tResponse.ServiceCallStatus) {
				Do ..LogMessage("PCEHR Document Removal response:"_tResponse.ResponseStatus.Description,tGroup)
			} Else {
				Do ..LogMessage("Status:"_$system.Status.GetErrorText(tResponse.ServiceCallStatus),tGroup)
			}
		} Else {
			Do ..LogMessage("No Response",tGroup)
		}
	} catch ex {
		Do ..LogMessage($zcvt(ex.DisplayString(),"O","HTML"),$g(tGroup))
	}

	&js<zen('btnSend').setProperty('disabled',false);>
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set tSC= ..AddServiceEntries(..#SERVICEREGISTRYENTRY) 
	Do ..SetLogging()
	If %page.TESTGROUPID]"" {
		Set tGroup = ##class(HS.Test.UI.TestGroup).%OpenId(%page.TESTGROUPID)
		If $isObject(tGroup) Do ..DisplayGroupTestResult(tGroup)
	}

	Quit tSC
}

}
