/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsUI)

Class EnsPortal.Configuration.Settings Extends EnsPortal.Template.standardPage [ System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "Configure Interoperability Settings";

Parameter RESOURCE = "%Admin_Manage:USE";

Parameter EDITRESOURCE = "%Admin_Manage:USE";

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
</style>
}

/// This XML block defines the contents of the table pane.
XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>
<spacer height="20" />
<hgroup>
<spacer width="20" />
<vgroup>
<hgroup>
<titleBox id="id_Settings" title="Change the setting as required, then click Apply"
		subtitle="" />
<spacer width="30"/>
<button caption="Apply" id="btnApply" onclick="zenPage.doApply();" controlClass="commandButton" title="Save" />
</hgroup>
<spacer height="20" />
<titleBox id="id_SettingsNspSpecific" title="Namespace Specific:" titleStyle="border-bottom:0px;font-weight:normal"
		subtitle="" />
<spacer height="20" />
<hgroup>
<vgroup labelPosition="left">
<checkbox id="chkProdSCExclude" label="Exclude Production Configuration Page from Source Control:" enclosingStyle="padding-bottom:4px;"/>
</vgroup>
</hgroup>
</vgroup>
<spacer height="10" />

</hgroup>
</pane>
}

ClientMethod doApply() [ Language = javascript ]
{
	if (!this.checkEdit()) { return false; }
	// Convert to 1 or 0 from true or false
	var check = +zen('chkProdSCExclude').getProperty('value');
	ret = zenPage.ProdSCExclude(check);
	if ((ret) && (ret.length > 0)) {
		alert(ret);
	} else {
		alert($$$Text('Setting saved successfully'));
	}
}

Method ProdSCExclude(check) As %String [ ZenMethod ]
{
	#dim ex As %Exception.AbstractException
	Try {
		#; check ought to come in as 1 or 0
		If (check="true") {
			Set check = 1
		} ElseIf (''check '= check) {
			Set check = 0
		}
		Do ##class(Ens.Util.Production).SetExcludeFromPortalSourceControl(check)
	} Catch ex {
		Return $ZCVT($$$StatusDisplayString(ex.AsStatus()),"O","JS")
	}
	Return ""
}

/// This class method callback is called just before the server-side page
/// object is created.
Method %OnAfterCreatePage() As %Status
{
	#dim tSC = ##super()
	If $$$ISERR(tSC) Return tSC
	#dim tCheckBox = ..%GetComponentById("chkProdSCExclude")
	Set tCheckBox.value = ##class(Ens.Util.Production).IsExcludedFromPortalSourceControl()
	Return tSC
}

/// Get the (localized) title string for the page.
Method %OnGetTitle() As %String
{
	Return ..%OnGetPageName()
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Return $$$Text("Configure Interoperability Settings","Ensemble")
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 0
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()
	Return $$$OK
}

ClassMethod GetHyperEventResources(pMethod As %String = "") As %String
{
	Return $case(pMethod, "ProdSCExclude": ..#EDITRESOURCE, : "")
}

}
