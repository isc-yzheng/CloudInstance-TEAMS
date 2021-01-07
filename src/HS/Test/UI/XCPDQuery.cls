Class HS.Test.UI.XCPDQuery Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Query for patient";

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
<text label="Patient MPIID:" id="txtMPIID" size="30" title="Global patient identifier"/>
<text hidden="true" label="Host:" id="txtHost" value="HS.IHE.XCPD.InitiatingGateway.Process" size="80" title="Route transaction."/>
<spacer height="15"/>
<hgroup width="40%" cellAlign="right">
<button id="btnSend" caption=" Submit Request " onclick="zenPage.StartSend('btnSend',1)" />
<spacer width="5" />
<button id="btnClear" caption=" Clear " onclick="zenPage.Clear();" />
<spacer width="5" />
</hgroup>
<vgroup>
<pane paneName="asyncPane"/>
</vgroup>
<pane id="paneResults">
</pane>
</pane>
</page>
}

ClientMethod Clear() [ Language = javascript ]
{
	zen('txtMPIID').setValue("");
}

Method Send() [ ZenMethod ]
{
	try {
		set tSC = $$$OK
		Set tMPIID=..%GetValueById("txtMPIID") 
		If tMPIID="" &js< alert('Select Patient');> Quit
		Set tRequest = ##class(HS.Message.PatientSearchRequest).%New()
		Set tRequest.MPIID = tMPIID
		Set tHost = %page.%GetValueById("txtHost")
		Do tRequest.AdditionalInfo.SetAt(tHost,"Host")
		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Set tTest=tGroup.NewTest(tRequest,0)

		Set %session.Data("IHE.Test",..%ClassName(0),"MPIID")=tMPIID
		Do tGroup.AdditionalInfo.SetAt(tMPIID,"MPIID")

		Set tSessionID = ..ExecuteAsync(tTest,tGroup)
	} catch ex {
		Do ..LogMessage($zcvt(ex.DisplayString(),"O","HTML"),$g(tGroup))
		Set tSessionID=""
	}
	&js<zen('btnSend').setProperty('disabled',false);>
	Quit tSessionID
}

Method DisplayTestResult(pTest As HS.Test.UI.Test, pGroupTest As HS.Test.UI.TestGroup = "", pClear = 0)
{
	Do ##super(pTest,pGroupTest,pClear)
	Set tResponse=pTest.Response
	If $IsObject(tResponse) && $$$ISOK(pTest.Status) {
		#dim results as %ZEN.Component.pane
		set results=%page.%GetComponentById("paneResults")
		For tIdx=1:1:tResponse.Patients.Count() {
			#dim tPatient as HS.Message.IHE.XCPDPatient = tResponse.Patients.GetAt(tIdx)
			Set label=##class(%ZEN.Component.label).%New()
			Set label.label = tPatient.HomeCommunityId_" - "_tPatient.Extension_"^^^&"_##class(HS.Data.OIDMap).GetOIDForCode(tPatient.Root)_"&ISO"
			Do results.%AddChild(label)
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
	Set tMPIID=$g(%session.Data("IHE.Test",..%ClassName(0),"MPIID"))
	If %page.TESTGROUPID]"" {
		Set tGroup = ##class(HS.Test.UI.TestGroup).%OpenId(%page.TESTGROUPID)
		If $isObject(tGroup) {
			Do ..PostAsyncExecuteDisplay(tGroup,1)
			Set tMPIID=tGroup.AdditionalInfo.GetAt("MPIID")
		}
	}

	Do ..%SetValueById("txtMPIID",tMPIID)
	Quit $$$OK
}

}
