/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

/// Zen based DICOM Settings UI
Class EnsPortal.DICOM.Settings Extends EnsPortal.Template.listPage [ System = 4 ]
{

/// User must have READ permissions on the %Ens_ProductionConfig resource to view this page.
Parameter RESOURCE = "%Ens_ProductionConfig:READ";

/// User must have WRITE permissions on the %Ens_ProductionConfig resource to make changes on this page.
Parameter EDITRESOURCE = "%Ens_ProductionConfig:WRITE";

/// Displayed name of this page.
Parameter PAGENAME = "DICOM Settings";

/// The last selected PID
Property PID As %ZEN.Datatype.string;

/// This XML block defines the contents of the table pane.
XData ListPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>
<hgroup valign="top">
<spacer width="20"/>
<vgroup valign="top">
<spacer height="30" />
<label id="Text1" value="" containerStyle="padding-bottom:4px;"/>
<spacer height="10" />
<tablePane id="table" 
cellSpacing="2"
fixedHeaders="false"
queryClass="EnsPortal.DICOM.Settings"
queryName="Enumerate"
maxRows="1000"
showZebra="true"
valueColumn="ID"
useSnapshot="true"
>
<parameter id="filter" value=""/>
<parameter id="queryMethod" value="Enumerate"/>
<parameter id="queryClass" value="EnsLib.DICOM.Util.AssociationContext"/>
<column colName="ID" hidden="true"/>
<column colName="CallingAET" header="Calling AET"/>
<column colName="CalledAET" header="Called AET"/>
<column colName="Name" header="Name"/>
<column colName="Description" header="Description"/>
</tablePane>
<hgroup id="idButton" >
<text id="PID" hidden="true"/>
<label id="result" controlClass="redText" value=""/>
</hgroup>
<spacer height="20"/>
</vgroup>
<spacer width="20"/>
</hgroup>
</pane>
}

/// Class query with filter added.
/// Override this in order to add rowspec specific to the list being displayed 
Query Enumerate(Filter As %String = "", QueryMethod As %String, QueryClass As %String) As %Query(ROWSPEC = "ID,CallingAET,CalledAET,Name,Description") [ SqlProc ]
{
}

/// Add a new setting. Open Setting page.
ClientMethod addSetting() [ Language = javascript ]
{
	if (!this.checkEdit()) { return false; }
	
	var page = "EnsPortal.DICOM.Setting.zen?isNew=1";
	this.gotoPage(page);
	return;
}

/// Add a new setting. Open Setting page.
ClientMethod viewAS() [ Language = javascript ]
{
	var page = "EnsPortal.DICOM.ASList.zen";
	this.gotoPage(page);
	return;
}

/// Add a new setting. Open Setting page.
ClientMethod viewDict() [ Language = javascript ]
{
	var page = "EnsPortal.DICOM.Dictionary.zen"; 
	this.gotoPage(page);
	return;
}

/// Delete existing association.
ClientMethod deleteSetting() [ Language = javascript ]
{
	if (!this.checkEdit()) { return false; }
	
	if (confirm($$$Text("Are you sure you want to delete this DICOM association?"))) {
		pid = zen("table").value;
		try {
			var ok = this.DeleteData(pid);
			if (ok == 1) {
				zen("table").setProperty("selectedIndex",-1);
				this.PID = "";
				this.refreshTable();
				this.updateTable();
			} else {
				alert(ok);
			}
		} 
		catch (ex) {
			alert("Error: " + ex);	
		}
	}
}

/// User clicked the "Edit" link which is there for clearity and consistency. No need to do anything here as onselectrow is going to kick in.
ClientMethod editSetting() [ Language = javascript ]
{
	if (!this.checkEdit()) { return false; }
	
	pid = zen("table").value;
	try {
		var page = "EnsPortal.DICOM.Setting.cls?PID="+encodeURIComponent(pid);
		this.gotoPage(page);
		return;
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// After user deletes an item, refresh the table.
ClientMethod updateTable() [ Language = javascript ]
{
	// reset result message
	//zenPage.getComponentById("result").setValue("");
	var table = zenPage.getComponentById("table");	
	if (table.getProperty("selectedIndex")>-1) table.setProperty("selectedIndex",-1)
}

/// This method is called after a setting is saved or deleted.
ClientMethod refreshTable() [ Language = javascript ]
{
	this.PID = "";
	var table = zenPage.getComponentById("table");
	table.executeQuery();
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	Quit:'tSC tSC
	
	Set msgTable = $$$FormatText($$$Text("DICOM association context settings currently defined for %1:"),$namespace)	
	Set ..%GetComponentById("Text1").value = msgTable
	Quit $$$OK
}

ClassMethod CheckAllBlanks(string) As %Boolean [ ZenMethod ]
{
	Quit $ZStrip(string,"<>W")=""
}

/// Delete an association context
ClassMethod DeleteData(pid) As %String [ ZenMethod ]
{
	Set $ZT="Error"
	Set tSC = ##class(EnsLib.DICOM.Util.AssociationContext).%DeleteId(pid)
	If $$$ISERR(tSC) {
		Set ok = $System.Status.GetErrorText(tSC)
	} Else {
		Set ok = 1
	}
	Quit ok
Error	///
	Set $ZT=""
	Set tSC = $$$SystemError
	Quit $system.Status.GetErrorText(tSC)
}

/// Get the (localized) title string for the page.
Method %OnGetTitle() As %String
{
	Quit ..%OnGetPageName()
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("DICOM Settings","Ensemble")
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 1
	Set pRibbonTitle = ..%OnGetPageName()

	// commands: $LB(id,caption,help,onclick)
	Set pCommands(1) = $LB("btnAdd",$$$Text("New"),$$$Text("Add a new DICOM association"),"zenPage.addSetting();")
	Set pCommands(2) = $LB("btnEdit",$$$Text("Edit"),$$$Text("Edit the currently selected DICOM setting"),"zenPage.editSetting();")
	Set pCommands(3) = $LB("btnDelete",$$$Text("Delete"),$$$Text("Delete the currently selected DICOM setting"),"zenPage.deleteSetting();")

	Quit $$$OK
}

/// Callback to return a list of resources required for a specific HyperEvent.
/// The user must have sufficient privileges on one of the resource/permission pairs
/// to be permitted to execute the hyperevent. An empty string implies the user already
/// has sufficient privileges for the ZenMethod specified in <var>pMethod</var>.
ClassMethod GetHyperEventResources(pMethod As %String = "") As %String
{
	Quit $case(pMethod, "DeleteData": ..#EDITRESOURCE, : "")
}

}
