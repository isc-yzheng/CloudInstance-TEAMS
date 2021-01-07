Class HS.Test.UI.AU.MergeProvisionalIHI Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Merge Provisional IHI";

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
<spacer height="40"/>
<html>Merge Provisional IHI</html>
<spacer height="5"/>
<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left">
<checkbox label="Enable logging" id="chkLogging"/>
<spacer height="5"/>
<text label="From IHI Number:" id="txtFromIHINumber" size="60" tabIndex="5" />
<text label="Into IHI Number:" id="txtIntoIHINumber" size="60" tabIndex="5" />

<spacer height="15"/><combobox id="cmbServiceRegistry" label="EndPoint: *" labelClass="caption" dropdownWidth="300"/>
<hgroup width="40%" cellAlign="right">
<button id="btnSend" caption=" Submit Request " onclick="zenPage.Start('btnSend',1);zenPage.Send();" />
<spacer width="5" />
<button id="btnClear" caption=" Clear " onclick="zenPage.Clear();" />
<spacer width="5" />
<button id="btnDemoData" caption=" Demo Data " onclick="zenPage.DemoData();" />
</hgroup>
</form>
<pane id="paneResults"/>
</pane>
</page>
}

ClientMethod Clear() [ Language = javascript ]
{
	document.getElementById('paneResults').innerHTML='';
	this.getComponentById('txtFromIHINumber').setValue("");
	this.getComponentById('txtToIHINumber').setValue("");
	this.getComponentById("btnSend").setProperty('disabled',0);
	this.getComponentById("btnDemoData").setProperty('disabled',0);
}

ClientMethod DemoData() [ Language = javascript ]
{
	document.getElementById('paneResults').innerHTML='Creating Provisional IHI';
	this.getComponentById("btnSend").setProperty('disabled',1);
	this.getComponentById("btnDemoData").setProperty('disabled',1);
	zenPage.CreateDemoData();
}

Method CreateDemoData() [ ZenMethod ]
{
	try {
		set tRequest=##class(HS.AU.Message.HI.CreateProvisionalIHIRequest).%New()
		set tRequest.FamilyName = "DWAYNE"
		set tRequest.Sex = "F" 
		set tRequest.DateOfBirth = $ZDH("25/01/1984",4)
		set tRequest.DateOfBirthAccuracyIndicator="AAA"

		Do tRequest.AdditionalInfo.SetAt("HS.AU.HI.Consumer.Operations","Operation")

		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Set tTest=tGroup.NewTest(tRequest,%page.%GetValueById("chkLogging"))
		Set tSC = ..Execute(tTest,tGroup)
		Do ..LogMessage("Creating provisional IHI",tGroup)
		Do ..DisplayTestResult(tTest,tGroup) Quit:$$$ISERR(tSC)
		Set tResponse=tTest.Response

		If $IsObject(tResponse) {
			Set tResult=tResponse.Result
			If $isObject(tResult) {
				Do ..LogMessage("ihiRecordStatus:"_tResult.IHIRecordStatus_" ihiStatus:"_tResult.IHIStatus_" ihiNumber:"_tResult.IHINumber,tGroup)
				Do ..%SetValueById("txtFromIHINumber",tResult.IHINumber)
				Do ..%SetValueById("txtIntoIHINumber","http://ns.electronichealth.net.au/id/hi/ihi/1.0/8003608333339208")
				
			} Else {
				Do ..LogMessage("No Result",tGroup)
			}
		} Else {
			Do ..LogMessage("No Response",tGroup)
		}
	} catch ex {
		&js<alert('#($zcvt($system.Status.GetErrorText(ex.AsStatus()),"O","JS"))#');>
	}
	&js<zen('btnDemoData').setProperty('disabled',false);>
}

Method Send() [ ZenMethod ]
{
	try {
		set tRequest=##class(HS.AU.Message.HI.MergeProvisionalIHIRequest).%New()
		Do tRequest.IHINumber.Insert(%page.%GetValueById("txtFromIHINumber"))
		Do tRequest.IHINumber.Insert(%page.%GetValueById("txtIntoIHINumber"))

		Do tRequest.AdditionalInfo.SetAt("HS.AU.HI.Consumer.Operations","Operation")

		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Set tTest=tGroup.NewTest(tRequest,%page.%GetValueById("chkLogging"))
		Do ..LogMessage("Merging IHI's",tGroup)
		Set tSC = ..Execute(tTest)
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
