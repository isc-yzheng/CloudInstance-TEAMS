Class HS.Test.UI.AU.CreateProvisionalIHI Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Create Provisional IHI";

Parameter SERVICEREGISTRYENTRY = "AU.HI";

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
<html>Patient demographics</html>
<spacer height="5"/>
<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left">
<checkbox label="Enable logging" id="chkLogging"/>
<spacer height="5"/>
<text label="First Name:" name="FirstName" id="txtFirstName" size="30" tabIndex="5" />
<text label="Last Name:" name="LastName" id="txtLastName" size="30" tabIndex="10" />
<combobox id="cmbGender" label="Gender:" size="22" tabIndex="15">
<option value="" text=""/>
<option value="F" text="Female"/>
<option value="I" text="I"/>
<option value="M" text="Male"/>
<option value="N" text="N"/>
</combobox>
<dateText id="dtDOB" label="Date of Birth:" size="22" minDate="1841-01-01" maxDate="T" hint="(yyyy-mm-dd)" hintStyle="font-size:10px;font-weight:bold;" tabIndex="20"/>
<combobox id="cmbDateOfBirthAccuracyIndicator" label="AccuracyIndicator:" size="22" >
<option value="AAA" text="AAA"/><option value="AAE" text="AAE"/><option value="AAU" text="AAU"/><option value="AEA" text="AEA"/><option value="AEE" text="AEE"/><option value="AEU" text="AEU"/><option value="AUA" text="AUA"/><option value="AUE" text="AUE"/><option value="AUU" text="AUU"/><option value="EAA" text="EAA"/><option value="EAE" text="EAE"/><option value="EAU" text="EAU"/><option value="EEA" text="EEA"/><option value="EEE" text="EEE"/><option value="EEU" text="EEU"/><option value="EUA" text="EUA"/><option value="EUE" text="EUE"/><option value="EUU" text="EUU"/><option value="UAA" text="UAA"/><option value="UAE" text="UAE"/>
<option value="UAU" text="UAU"/><option value="UEA" text="UEA"/><option value="UEE" text="UEE"/><option value="UEU" text="UEU"/><option value="UUA" text="UUA"/><option value="UUE" text="UUE"/><option value="UUU" text="UUU"/>
</combobox>
<dateText id="dtDOD" label="Date of Death:" size="22" minDate="1841-01-01" maxDate="T" hint="(yyyy-mm-dd)" hintStyle="font-size:10px;font-weight:bold;" tabIndex="20"/>
<combobox id="cmbDateOfDeathAccuracyIndicator" label="AccuracyIndicator:" size="22" >
<option value="AAA" text="AAA"/><option value="AAE" text="AAE"/><option value="AAU" text="AAU"/><option value="AEA" text="AEA"/><option value="AEE" text="AEE"/><option value="AEU" text="AEU"/><option value="AUA" text="AUA"/><option value="AUE" text="AUE"/><option value="AUU" text="AUU"/><option value="EAA" text="EAA"/><option value="EAE" text="EAE"/><option value="EAU" text="EAU"/><option value="EEA" text="EEA"/><option value="EEE" text="EEE"/><option value="EEU" text="EEU"/><option value="EUA" text="EUA"/><option value="EUE" text="EUE"/><option value="EUU" text="EUU"/><option value="UAA" text="UAA"/><option value="UAE" text="UAE"/>
<option value="UAU" text="UAU"/><option value="UEA" text="UEA"/><option value="UEE" text="UEE"/><option value="UEU" text="UEU"/><option value="UUA" text="UUA"/><option value="UUE" text="UUE"/><option value="UUU" text="UUU"/>
</combobox>
<combobox id="cmbSourceOfDeathNotification" label="Source Of Death Notification:" size="22" >
<option value="" text=""/><option value="H" text="H"/>
</combobox>

<spacer height="15"/>
<combobox id="cmbServiceRegistry" label="EndPoint: *" labelClass="caption" 
 dropdownWidth="300">
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
	document.getElementById('paneResults').innerHTML='';
	this.getComponentById('txtFirstName').setValue("");
	this.getComponentById('txtLastName').setValue("");
	this.getComponentById('cmbGender').setValue("");
	this.getComponentById('dtDOB').setValue("");
	this.getComponentById('dtDOD').setValue("");

	this.getComponentById('cmbDateOfBirthAccuracyIndicator').setValue("");
	this.getComponentById('cmbDateOfDeathAccuracyIndicator').setValue("");
}

ClientMethod DemoData() [ Language = javascript ]
{
	//this.getComponentById('txtFirstName').setValue("");
	this.getComponentById('txtLastName').setValue("DWAYNE");
	this.getComponentById('cmbGender').setValue("F");
	this.getComponentById('dtDOB').setValue("1984-01-25");
	this.getComponentById('cmbDateOfBirthAccuracyIndicator').setValue("AAA");
}

Method Send() [ ZenMethod ]
{
	try {
		set tRequest=##class(HS.AU.Message.HI.CreateProvisionalIHIRequest).%New()
		set tRequest.FamilyName=%page.%GetValueById("txtLastName")
		set tRequest.GivenName=%page.%GetValueById("txtFirstName")
		Set tDOB=%page.%GetValueById("dtDOB")
		set tRequest.DateOfBirth=$S(tDOB]"":$ZDH(tDOB,3,,,,,,,-1),1:"")
		set tRequest.Sex=%page.%GetValueById("cmbGender")
		Set tRequest.DateOfBirthAccuracyIndicator=%page.%GetValueById("cmbDateOfBirthAccuracyIndicator")
		Set tDOD=%page.%GetValueById("dtDOD")
		set tRequest.DateOfDeath=$S(tDOD]"":$ZDH(tDOD,3,,,,,,,-1),1:"")
		Set tRequest.DateOfDeathAccuracyIndicator=%page.%GetValueById("cmbDateOfDeathAccuracyIndicator")
		Set tRequest.SourceOfDeathNotification=%page.%GetValueById("cmbSourceOfDeathNotification")
		Do tRequest.AdditionalInfo.SetAt("HS.AU.HI.Consumer.Operations","Operation")

		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Set tTest=tGroup.NewTest(tRequest,%page.%GetValueById("chkLogging"))
		Set tSC = ..Execute(tTest,tGroup)
		Do ..DisplayTestResult(tTest,tGroup) Quit:$$$ISERR(tSC)
		Set tResponse=tTest.Response

		If $IsObject(tResponse) {
			Set tResult=tResponse.Result
			If $isObject(tResult) {
				Do ..LogMessage("ihiRecordStatus:"_tResult.IHIRecordStatus_" ihiStatus:"_tResult.IHIStatus_" ihiNumber:"_tResult.IHINumber,tGroup)
			} Else {
				Do ..LogMessage("No Result",tGroup)
			}
		} Else {
			Do ..LogMessage("No Response",tGroup)
		}
	} catch ex {
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
