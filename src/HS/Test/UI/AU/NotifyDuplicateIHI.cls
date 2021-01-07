Class HS.Test.UI.AU.NotifyDuplicateIHI Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Notify Duplicate IHI";

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
<html>Notify Duplicate IHI</html>
<spacer height="5"/>
<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left">
<checkbox label="Enable logging" id="chkLogging"/>
<spacer height="5"/>
<text label="First IHI Number:" id="txtFirstIHINumber" size="60" tabIndex="5" />
<text label="Second IHI Number:" id="txtSecondIHINumber" size="60" tabIndex="5" />

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
	this.getComponentById('txtFirstIHINumber').setValue("");
	this.getComponentById('txtSecondIHINumber').setValue("");
	this.getComponentById("btnSend").setProperty('disabled',0);
	this.getComponentById("btnDemoData").setProperty('disabled',0);
}

ClientMethod DemoData() [ Language = javascript ]
{
	document.getElementById('paneResults').innerHTML='Executing sample transaction';
	this.getComponentById("btnSend").setProperty('disabled',1);
	this.getComponentById("btnDemoData").setProperty('disabled',1);
	zenPage.CreateDemoData();
}

Method CreateDemoData() As %String [ ZenMethod ]
{
	try {
		#; create the first unverified record and set the ihi number into the txtFirstIHINumber field
		set tRequest=##class(HS.AU.Message.HI.CreateUnverifiedIHIRequest).%New()
		set tRequest.FamilyName = "UNVER"_$TR($SYSTEM.Util.CreateGUID(),"-","")
		Set tRequest.Usage="O"
		
		Set tIndividual=##class(HS.AU.Types.HI.IndividualHealthcareIdentityType).%New()
		set tIndividual.DateOfBirth = $ZDH("01/02/1980",4)
		set tIndividual.DateOfBirthAccuracyIndicator="AAA"
		set tIndividual.Sex="M"
		set tRequest.IndividualHealthcareIdentity=tIndividual
		
		Do tRequest.AdditionalInfo.SetAt("HS.AU.HI.Consumer.Operations","Operation")

		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Set tTest=tGroup.NewTest(tRequest,%page.%GetValueById("chkLogging"),"","Create First Unverified patient")
		Set tSC = ..Execute(tTest,tGroup)
		Do ..DisplayTestResult(tTest,tGroup) Quit:$$$ISERR(tSC)
		Set tResponse=tTest.Response
		
		If $IsObject(tResponse) {
			Set tResult=tResponse.Result
			If $isObject(tResult) {
				Do ..LogMessage("ihiRecordStatus:"_tResult.IHIRecordStatus_" ihiStatus:"_tResult.IHIStatus_" ihiNumber:"_tResult.IHINumber,tGroup)
				Do ..%SetValueById("txtFirstIHINumber",tResult.IHINumber)
			} Else {
				Do ..LogMessage("No Result",tGroup)
			}
		} Else {
			Do ..LogMessage("No Response",tGroup)
			Quit
		}
		Do ..LogFinished(tGroup)


		#; create the second unverified record and set the ihi number into the txtSecondIHINumber field
		Set tRequest.FamilyName="Dup"_$E(tRequest.FamilyName,6,*)
		Set tTest=tGroup.NewTest(tRequest,%page.%GetValueById("chkLogging"),"","Create second Unverified patient")
		Set tSC = ..Execute(tTest,tGroup)
		Do ..DisplayTestResult(tTest,tGroup) Quit:$$$ISERR(tSC)
		Set tResponse=tTest.Response
		
		If $IsObject(tResponse) {
			Set tResult=tResponse.Result
			If $isObject(tResult) {
				Do ..LogMessage("ihiRecordStatus:"_tResult.IHIRecordStatus_" ihiStatus:"_tResult.IHIStatus_" ihiNumber:"_tResult.IHINumber,tGroup)
				Do ..%SetValueById("txtSecondIHINumber",tResult.IHINumber)
			} Else {
				Do ..LogMessage("No Result",tGroup)
			}
		} Else {
			Do ..LogMessage("No Response",tGroup)
			Quit
		}
		Do ..LogFinished(tGroup)

		Do ..Send(tGroup)

	} catch ex {
		Do ..LogMessage($zcvt(ex.DisplayString(),"O","HTML"),$G(tGroup))
	}
	&js<zen('btnDemoData').setProperty('disabled',false);>
	Quit ""
}

Method Send(pGroup As HS.Test.UI.TestGroup = "") As %String [ ZenMethod ]
{
	try {
		set tRequest=##class(HS.AU.Message.HI.NotifyDuplicateIHIRequest).%New()
		Do tRequest.IHINumber.Insert(%page.%GetValueById("txtFirstIHINumber"))
		Do tRequest.IHINumber.Insert(%page.%GetValueById("txtSecondIHINumber"))
		Set tRequest.Comment="see potential duplicates."

		Do tRequest.AdditionalInfo.SetAt("HS.AU.HI.Consumer.Operations","Operation")

		Set:'$isObject(pGroup) pGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Set tTest=pGroup.NewTest(tRequest,%page.%GetValueById("chkLogging"),"","Notify of duplicate IHI's")
		Set tSC = ..Execute(tTest,pGroup)
		Do ..DisplayTestResult(tTest,pGroup) Quit:$$$ISERR(tSC)
		Set tResponse=tTest.Response

		If $IsObject(tResponse) {
			#dim tResult as HS.AU.Message.HI.NotifyDuplicateIHIResult
			Set tResult=tResponse.Result
			If $isObject(tResult) {
				Do ..LogMessage("ServiceMessage:"_tResult.ServiceMessages.ServiceMessage.GetAt(1).Reason,pGroup)
			} Else {
				Do ..LogMessage("No Result",pGroup)
			}
		} Else {
			Do ..LogMessage("No Response",pGroup)
		}
	} catch ex {
		Do ..LogMessage($zcvt(ex.DisplayString(),"O","HTML"),$G(pGroup))

	}
	&js<zen('btnSend').setProperty('disabled',false);>
	Quit ""
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
