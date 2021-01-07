/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsHL7)

Class EnsPortal.HL7.SchemaMain Extends EnsPortal.EDI.devTemplate [ System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "HL7 Schemas";

Parameter CSSINCLUDES = "ensemble/Ensemble_Wizards.css,ensemble/Ensemble_EDI.css";

Property Status As %String;

/// Is the user permitted to access the fileSelect popup.
Property canViewFileSystem As %Boolean [ InitialExpression = {$system.Security.Check("%Ens_ViewFileSystem","USE")} ];

/// Id of selected Category row in results table.
Property Category As %ZEN.Datatype.string(ZENURL = "CAT");

Property msgDocReadOnly As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("This custom schema is read only.")} ];

XData Style
{
<style type="text/css">

#searchPanel {
	/*width: 300px;*/
	padding-left: 5px;
	padding-right: 5px;
	background: #edece4;
	overflow: hidden;
	overflow-y: auto;
}

table.tpTable tr.tpEven {
	background: white;
}

table.tpTable tr.tpOdd {
	background: #F1F0E7;
}

table.tpTable tr.tpSelected {
	background: rgb(47,98,128);
	color: white;
}

table.tpTable tr.tpSelected td {
	font-weight: bold;
}

table.tpTable td {
	padding-right:10px;
}

table.tpTable {
	width: auto;
}

.searchPanelText {
	color: #404040;
	font-size: 10pt;
	text-align: center;
	padding: 3px;
	padding-top: 20px;
	padding-bottom: 20px;
}

.titlePane {
	color: #606060;
	font-family: Arial, Helvetica, sans-serif;
	font-weight: bold;
	background: none;
	width: 100%;
	padding: 0px;
	border-bottom: 1px solid silver;
	font-size: 12pt;
	text-align: center;
}

.zenLabel {
	color: #404040;
	font-size: 10pt;
}

a.radioSetCaption {
	vertical-align: top;
	text-decoration: none;
	color: #404040;
	font-size: 10pt;
}

.formLabel {
	color: #404040;
	font-size: 10pt;
	font-weight: bold;
}

a.resultsAction {
	font-size: 11px;
	color: #3b84bc;
	text-decoration: none;
}

a.resultsAction:hover {
	color: darkred;
}

td.resultsRowNo {
	color: #808080;
	text-align: left;
}

.resultsRowSelected a.resultsAction {
	color: white;
}

.resultsRowSelected a.resultsAction:hover {
	color: orange;
}

.resultsRowMouseover, .tpMouseOver {
	background: #FFEEAA;
}

/* expanded details within table */
table td.detailsBox {
	padding: 0px;
	height: 200px;
	background: white;
	border: 1px solid black;
}

table.detailsTable {
	width: 100%;
}
/* selected row after "Details" is clicked */
table tr.detailsTableHeader {
	background: rgb(47,98,128);
	color: white;
	font-size: 12px;
}

/* details pane style */
#detailsGroup {
	background: #EDECE4;
	color: #606060;
	padding-left: 5px;
	padding-right: 5px;
	overflow: auto;
	border-left: 1px solid gray;
}
#searchGroup {
	background: #EDECE4;
	padding-left: 5px;
	padding-right: 5px;
	border-right: 1px solid gray;
}

/* styles for message details */
table.AutoFormTable {
	color: #606060;
	background: white;
	border: 1px solid black;
	padding: 0px;
	font-size: 12px;
}

table td.AutoFormTableCaption {
	font-weight: bold;
	border-bottom: 1px solid darkgray;
	border-right: 1px solid darkgray;
	padding-left: 2px;
	padding-right: 2px;
}

table td.AutoFormTableValue {
	border-bottom: 1px solid darkgray;
	padding-left: 2px;
	padding-right: 2px;
}

#detailExpanderLink {
	margin-right: 5px;
}

div.dimmer
{
    visibility:hidden;
    position:absolute;
    left:0px;
    top:0px;
    width:600px;
    height:300px;
    font-family:verdana;
    font-weight:bold;
    padding:40px;
	color: #606060;
	background-color: #000;
    background-color: rgba(0,0,0,0.5);
}

table.progress
{
    position:absolute;
    left:20px;
    top:30px;
    width:518px;
    height:287px;
    font-family:verdana;
    font-weight:bold;
    padding:40px;
	color: #606060;
	background: white;
	opacity:1;
}

</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<jsonProvider id="scjson" OnGetTargetObject="LoadSchemaAsJSON" OnSubmitContent="SaveJSONversionOfSchema" targetClass="%ZEN.proxyObject" />
<hgroup cellVAlign="top"  width="90%">
<hgroup id="searchGroup" valign="top">
<spacer width="20"/>
</hgroup>
<pane id="resultsPanel" paneName="resultsPane" width="600px" />
<hgroup id="detailsGroup">
<spacer width="10"/>
<pane id="detailsPanel" paneName="detailsPane"/>
</hgroup>
</hgroup>
<html>
<div id="divDimmer" class="dimmer">
<table id="tblProgressBox" class="progress">
<tr><td id="lblProgress" colspan="2">Importing...</td></tr>
<tr id ="trStatus"><td>In Progress:</td><td id="lblDuration" >0 seconds elapsed</td></tr>
<tr><td><input id="btnSubmit" type="button" value="OK" onclick="zenPage.progressSubmit();" style="width: 119px"/></td></tr>
</table>
</div>
</html>
</pane>
}

XData resultsPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>
<vgroup valign="top">
<spacer height="10" />
<tablePane id="table"
	cellSpacing="2"
	dataSource="columns"
	queryClass="EnsLib.HL7.Schema"
	queryName="TypeCategories"
	useSnapshot="true"
	showZebra="true"
	showRowNumbers="false"
	valueColumn="Category"
	maxRows="2000"
	nowrap="false"
	onselectrow="zenPage.updateRowVals(zenThis);"
	>
<column header="Category" colName="Category" OnDrawCell="DrawHoverTitle" title="HL7 Schema Category"/>
<column header="Base" colName="Base" title="Base category used by this schema category"/>
<column header="Standard" colName="IsStandard" OnDrawCell="DrawStd" style="text-align:center;"
	    title="Is this a standard or a custom schema category?"/>
<column header="Description" colName="Description" hidden="true"/>
</tablePane>
</vgroup>
</pane>
}

XData detailsPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>
<vgroup>
<spacer height="10"/>
<tabGroup id="detailsTabGroup" showTabBar="true" remember="true" width="100%" onshowTab="zenPage.onTabChange();" >
<tab id="tabMessageTypes" caption="Message Types" title="Message types">
<html id="htmlMessageTypes" OnDrawContent="DrawMessageTypesContent" />
</tab>
<tab id="tabDocTypes" caption="DocType Structures" title="Document type structures">
<html id="htmlDocTypes" OnDrawContent="DrawDocTypesContent" />
</tab>
<tab id="tabSegments" caption="Segment Structures" title="Segment structures">
<html id="htmlSegments" OnDrawContent="DrawSegmentsContent" />
</tab>
<tab id="tabComponents" caption="Data Structures" title="Sub-element composite and elementary data type structures">
<html id="htmlComposites" OnDrawContent="DrawCompositesContent" />
</tab>
<tab id="tabCodeTables" caption="Code Tables" title="Code Table enumerations">
<html id="htmlCodeTables" OnDrawContent="DrawCodeTablesContent" />
</tab>
</tabGroup>
<spacer height="10"/>
</vgroup>
</pane>
}

/// Draw Yes or nothing in place of 1 or 0
Method DrawStd(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
	If %query(pName) {
		Set tVal=$$$Text("Yes")
		Set tTitle=$$$Text("This is a standard schema")
	} Else {
		Set tVal="&nbsp;"
		Set tTitle=$$$Text("This is a custom schema")
	}
	Write "<div title="""_tTitle_""">"_tVal_"</div>"
	Quit $$$OK
}

/// Draw name or name with description hover text if description is available
Method DrawHoverTitle(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
	Set tName = ..EscapeHTML(%query(pName))
	Set tDescription = ..EscapeHTML(%query("Description"))
	Write $S(""=tDescription:tName, 1:"<div title="""_tDescription_""">"_tName_"</div>")
	Quit $$$OK
}

/// This client event, if present, is fired when the page is loaded.
/// Start the timer so we can check the status. If there is a
/// background import job currently running,
/// you will see a periodic update until the job is finished.
ClientMethod onloadHandler() [ Language = javascript ]
{
	// Not invoking super onloadHandler() since we call source control init per schema
	// A document in this page is identified by row
	// Ensure that tab content is correctly initialised
	
	// ZHJ037: SMP Reskin - Menu Style Overriden for Interoperability Pages
	var mainMenu=document.getElementById("mainMenu");
	if(mainMenu!=null) {
		mainMenu.parentElement.removeAttribute("style");
	}
	
	var menuBar=document.getElementsByClassName("csMenuBar");
	if(menuBar.length>0) {
		menuBar[0].removeAttribute("style");
	}
	var menuBarItem=document.getElementsByClassName("csMenuBarItem");
	if(menuBarItem.length>0) {
		menuBarItem[0].removeAttribute("style");
	}	
	var children=menuBarItem[0].children;
	if(children.length>0){
		for(var i=0; i<children.length; i++) {
			children[i].removeAttribute("style");
			if(i===2) {
				var menuBarText = children[i];
				menuBarText.setAttribute("style", "margin-top:12px;");				
			}
		}	
	} // end of SMP Reskin overridden
	
	if (!this.Category || this.Category.length <= 0) {
		this.Category = '';
	}
	var table = zenPage.getComponentById('table');
	table.selectRow(zenPage.findCatRow(table,this.Category));
	this.onTabChange();

	document.getElementById('divDimmer').style.width = window.screen.width + 'px';
	document.getElementById('divDimmer').style.height = window.screen.height + 'px';
}

ClientMethod findCatRow(table, cat) [ Language = javascript ]
{
	if (cat == '' || !table || (typeof table != 'object')) { // got passed the tablePane object
		return 0;
	}
	for (var i=0; i<table.rowCount; i=i+1) {
		var row = table.getRenderedRowData(i);
		if (row.Category == cat) return i;
	}
	return 0
}

ClientMethod findCatBase(table, cat) [ Language = javascript ]
{
	if (cat == '' || !table || (typeof table != 'object')) { // got passed the tablePane object
		return '';
	}
	for (var i=0; i<table.rowCount; i=i+1) {
		var row = table.getRenderedRowData(i);
		if (row.Category == cat) return row.Base;
	}
	return ''
}

ClientMethod updateRowVals(table) [ Language = javascript ]
{
	this.Category = (table && (typeof table == 'object')) ? table.getValue() : '' // got passed the tablePane object
	// If std schema and sourceControl enabled then hide Source Control Icons.
	if (this.sourceControlEnabled) {
		var std = this.isStandardSchema(table) ;
		var hide = (std||(!this.canEdit));
		var sync = this.toggleSourceControlIcons(hide);
	}
	this.onTabChange(true);
}

ClientMethod showProgressDiv(title) [ Language = javascript ]
{
	document.getElementById('divDimmer').style.visibility = "visible";
	var tdLbl=document.getElementById('lblProgress');
	tdLbl.innerHTML = title;
}

ClientMethod progressSubmit() [ Language = javascript ]
{
	document.getElementById('divDimmer').style.visibility = "hidden";
	document.getElementById('trStatus').innerHTML = '<td>In Progress:</td><td id="lblDuration" >0 seconds elapsed</td>'; // restore contents after error
}

ClassMethod FileExists(filename As %String) As %String [ ZenMethod ]
{
	Quit ##class(%File).Exists(filename)
}

ClientMethod doImportBrowse() [ Language = javascript ]
{
	if (!this.checkEdit()) {
		return false;
	}
	if (!this.canViewFileSystem) {
		alert(this.msgNotPermitted);
		return false;
	}
	parms = {
		Dir:zenPage.GetDefaultDir(),
		wildcard:'*.HL7;*.XML'
	}
	zenLaunchPopupWindow(zenLink('%ZEN.Dialog.fileSelect.zen',this.studioMode),this.addPopupSuffix('HL7ImportSelect'),'status,scrollbars,resizable,width=660,height=700,modal=no',parms);
	// the onPopupAction callback will be called when this dialog completes.
}

ClientMethod doExportBrowse() [ Language = javascript ]
{
	var tbl = zen('table');
	var cat = (tbl ? tbl.getValue() : '');
	if (!cat || cat.length <= 0) {
		alert($$$Text("First select a schema category row in the table, then click Export and choose a target filename to export the schema category."));
		return;
	}
	parms = {
		Dir:zenPage.GetDefaultDir(),
		wildcard:'*.HL7'
	}
	zenLaunchPopupWindow(zenLink('%ZEN.Dialog.fileSelect.zen',this.studioMode),this.addPopupSuffix('HL7ExportSelect'),'status,scrollbars,resizable,width=660,height=700,modal=no',parms);
	// the onPopupAction callback will be called when this dialog completes.
}

ClientMethod doDelete() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }

	var tbl = zen('table');
	var cat = (tbl ? tbl.getValue() : '');
	if (!cat || cat.length <= 0) {
		alert($$$Text("First select a schema category row in the table, then click Delete to delete the category."));
		return;
	}
	if (0 == zenPage.CanDeleteCategory(cat)) {
		alert($$$FormatText($$$Text("Schema category '%1' cannot be deleted because it is a standard schema."),cat));
		return;
	}
	if (!confirm($$$FormatText($$$Text("Are you sure you want to delete schema category '%1'?"),cat))) {
		return;
	}
	// A category was selected and confirmed for delete
	err = zenPage.DeleteCategory(cat);
	if (err.length > 0) {
		alert(err);
	} else { // Success: refresh the table
		var old = zenSynchronousMode;
		zenSynchronousMode = true;
		var sync = tbl.executeQuery();
		tbl.selectRow(0); //select first row so deleted category not still showing
		zenSynchronousMode = old;
	}
}

ClientMethod doCustomSchema() [ Language = javascript ]
{
	if (!this.checkEdit()) { return false; }

	parms = {
		CURRENT : ((this.Category && (this.Category != "")) ? this.Category : "")
	}
	zenLaunchPopupWindow(zenLink('EnsPortal.HL7.Dialog.CustomSchema.zen'),this.addPopupSuffix('HL7CreateSchema'),'status,scrollbars,resizable,width=660,height=500',parms);
}

ClientMethod doNewMT() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }

	if (this.Category.length <= 0) {
		alert($$$Text("Please select a schema category and try again."));
	}
	else {
		var table = zenPage.getComponentById('table');
		var base = zenPage.findCatBase(table, this.Category);
		parms = {
			CAT : zenPage.Category,
			BASE : base,
			TYPE : "newFromSchemaMain"
		}
		zenLaunchPopupWindow(zenLink('EnsPortal.HL7.Dialog.CustomMessageType.zen'),this.addPopupSuffix('HL7CreateMessageType'),'status,scrollbars,resizable,width=700,height=650',parms);
	}
}

ClientMethod doCopyMT() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }

	if (this.Category.length <= 0) {
		alert($$$Text("Please select a schema category and try again."));
	}
	else {
		var table = zenPage.getComponentById('table');
		var base = zenPage.findCatBase(table, this.Category);
		parms = {
			CAT : zenPage.Category,
			BASE : base,
			TYPE : "copyFromSchemaMain"
		}
		zenLaunchPopupWindow(zenLink('EnsPortal.HL7.Dialog.CustomMessageType.zen'),this.addPopupSuffix('HL7CreateMessageType'),'status,scrollbars,resizable,width=700,height=720',parms);
	}
}

ClientMethod doNewMS() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }

	if (this.Category.length <= 0) {
		alert($$$Text("Please select a schema category and try again."));
	}
	else {
		zenPage.gotoPage(zenPage.getDocTypeLink());
	}
}

Method getDocTypeLink(pIsCopy As %Boolean = 0) As %String [ ZenMethod ]
{
	Set tQuery("MS") = "MS:"_..Category
	Set tQuery("COPY") = pIsCopy
	Quit ..Link("EnsPortal.HL7.SchemaDocumentStructure.zen",.tQuery)
}

ClientMethod doCopyMS() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }

	if (this.Category.length <= 0) {
		alert($$$Text("Please select a schema category and try again."));
	}
	else {
		zenPage.gotoPage(zenPage.getDocTypeLink(1));
	}
}

ClientMethod doNewSS() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }

	if (this.Category.length <= 0) {
		alert($$$Text("Please select a schema category and try again."));
	}
	else {
		var table = zenPage.getComponentById('table');
		var base = zenPage.findCatBase(table, this.Category);
		parms = {
			CAT : zenPage.Category,
			BASE : base,
			TYPE : "newFromSchemaMain"
		}
		if (zenIsChrome) {
			var details = 'status,scrollbars,resizable,top=10,left=10,width=1500,height=720';
		}
		else {
			var details = 'status,scrollbars,resizable,top=10,left=10,width=1600,height=720';
		}
		zenLaunchPopupWindow(zenLink('EnsPortal.HL7.Dialog.CustomSegmentStructure.zen'),this.addPopupSuffix('HL7CreateSegmentStructure'),details,parms);
	}
}

ClientMethod doCopySS() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }

	if (this.Category.length <= 0) {
		alert($$$Text("Please select a schema category and try again."));
	}
	else {
		var table = zenPage.getComponentById('table');
		var base = zenPage.findCatBase(table, this.Category);
		parms = {
			CAT : zenPage.Category,
			BASE : base,
			TYPE : "copyFromSchemaMain"
		}
		if (zenIsChrome) {
			var details = 'status,scrollbars,resizable,top=10,left=10,width=1500,height=720';
		}
		else {
			var details = 'status,scrollbars,resizable,top=10,left=10,width=1600,height=720';
		}
		zenLaunchPopupWindow(zenLink('EnsPortal.HL7.Dialog.CustomSegmentStructure.zen'),this.addPopupSuffix('HL7CreateSegmentStructure'),details,parms);
	}
}

ClientMethod doNewDS() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }

	if (this.Category.length <= 0) {
		alert($$$Text("Please select a schema category and try again."));
	}
	else {
		var table = zenPage.getComponentById('table');
		var base = zenPage.findCatBase(table, this.Category);
		parms = {
			CAT : zenPage.Category,
			BASE : base,
			TYPE : "newFromSchemaMain"
		}
		if (zenIsChrome) {
			var details = 'status,scrollbars,resizable,top=10,left=10,width=1500,height=720';
		}
		else {
			var details = 'status,scrollbars,resizable,top=10,left=10,width=1600,height=720';
		}
		zenLaunchPopupWindow(zenLink('EnsPortal.HL7.Dialog.CustomDataStructure.zen'),this.addPopupSuffix('HL7CreateDataStructure'),details,parms);
	}
}

ClientMethod doCopyDS() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }

	if (this.Category.length <= 0) {
		alert($$$Text("Please select a schema category and try again."));
	}
	else {
		var table = zenPage.getComponentById('table');
		var base = zenPage.findCatBase(table, this.Category);
		parms = {
			CAT : zenPage.Category,
			BASE : base,
			TYPE : "copyFromSchemaMain"
		}
		if (zenIsChrome) {
			var details = 'status,scrollbars,resizable,top=10,left=10,width=1500,height=720';
		}
		else {
			var details = 'status,scrollbars,resizable,top=10,left=10,width=1600,height=720';
		}
		zenLaunchPopupWindow(zenLink('EnsPortal.HL7.Dialog.CustomDataStructure.zen'),this.addPopupSuffix('HL7CreateDataStructure'),details,parms);
	}
}

ClientMethod doNewCT() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }

	if (this.Category.length <= 0) {
		alert($$$Text("Please select a schema category and try again."));
	}
	else {
		var table = zenPage.getComponentById('table');
		var base = zenPage.findCatBase(table, this.Category);
		parms = {
			CAT : zenPage.Category,
			BASE : base,
			TYPE : "newFromSchemaMain"
		}
		var details = 'status,scrollbars,resizable,top=10,left=200,width=650,height=720';
		zenLaunchPopupWindow(zenLink('EnsPortal.HL7.Dialog.CustomCodeTable.zen'),this.addPopupSuffix('HL7CreateCodeTable'),details,parms);
	}
}

ClientMethod doCopyCT() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }

	if (this.Category.length <= 0) {
		alert($$$Text("Please select a schema category and try again."));
	}
	else {
		var table = zenPage.getComponentById('table');
		var base = zenPage.findCatBase(table, this.Category);
		parms = {
			CAT : zenPage.Category,
			BASE : base,
			TYPE : "copyFromSchemaMain"
		}
		var details = 'status,scrollbars,resizable,top=10,left=200,width=650,height=720';
		zenLaunchPopupWindow(zenLink('EnsPortal.HL7.Dialog.CustomCodeTable.zen'),this.addPopupSuffix('HL7CreateCodeTable'),details,parms);
	}
}

Method DeleteCategory(pCategory As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	Quit:('..CanDeleteCategory(pCategory)) $$$FormatText($$$Text("Could not delete schema category '%1' because it is a standard schema."),pCategory)
	#dim tMsg = ""

	If ..sourceControlEnabled {

		If ..IsSourceControlReadOnly(..GetInternalName()) {
			Quit $$$FormatText($$$Text("Could not delete schema category '%1' because source control framework has marked it as read only"),pCategory)
		}

		Set tMsg = ..OnSchemaDelete("before")
		If tMsg '= "" Quit $$$FormatText($$$Text("Error calling source control OnBeforeDelete for schema category %1. %2"),pCategory, tMsg)
	}

	#dim tKilled=$D($$$vaSchemaGbl(pCategory))
	Kill $$$vaSchemaGbl(pCategory),$$$vaSchemaDescGbl(pCategory)

	If ..sourceControlEnabled {
		Set tMsg = ..OnSchemaDelete("after")
		If tMsg '= "" Set tMsg = $$$FormatText($$$Text("Error calling source control OnAfterDelete for schema category %1. %2"),pCategory, tMsg)
	}

	If tKilled {
		#dim tSC2 = $$$AuditModifySchema("HL7 "_pCategory,"Deleted schema")
		Quit tMsg
	}
	Quit $$$FormatText($$$Text("Could not find schema category %1 to delete."),pCategory)
}

/// This client event, if present, is fired when the a popup page
/// launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if (action != "ok") {
		return false;
	}
	popupName = this.removePopupSuffix(popupName);
	switch(popupName) {
		case 'HL7ImportSelect':
			if (value != '') zenPage.SetDefaultDir(value);
			if (action == 'ok') {
				var fileExists = zenPage.FileExists(value);
				if (fileExists == 0) {
					setTimeout('alert("' + $$$FormatText($$$Text("File not found: %1"),zenEscapeJS(value)) + '");', 50);
					return false;
				}
			}
			var err = this.Import(value);

			if (!err) { err = 'err|' + $$$Text("Server Session Error") + '|' + $$$Text('unknown') + '|' + $$$Text('unknown'); }
			var status = err.split('|');

			if ('' == status[0]) {
				document.getElementById('divDimmer').style.visibility = "hidden";
				zenPage.gotoPage("EnsPortal.HL7.SchemaMain.zen");
			} else {
				document.getElementById('trStatus').innerHTML = '<td colspan=2>'+err+'</td>';
			var divTitle = $$$FormatText($$$Text('Importing file %1'),value);
				zenPage.showProgressDiv(divTitle);
			}
		break;

		case 'HL7ExportSelect':
			setTimeout(function() {
				zenPage.doExport(value);
			}, 50);
		break;

		case 'HL7CreateSchema':
			if (value.length > 0) {
				zenPage.gotoPage("EnsPortal.HL7.SchemaMain.zen");
			}
			else {
				setTimeout('alert("' + $$$Text("Unable to create custom schema.") + '");', 50);
			}
		break;

		case 'HL7CreateMessageType':
			if (value.length > 0) {
				zenPage.gotoPage("EnsPortal.HL7.SchemaMain.zen");
			}
			else {
				setTimeout('alert("' + $$$Text("Unable to create custom message type.") + '");', 50);
			}
		break;

		case 'HL7CreateMessageStructure':
			if (value.length > 0) {
				if (value != "cancel") {
					zenPage.gotoPage("EnsPortal.HL7.SchemaMain.zen");
				}
			}
			else {
				setTimeout('alert("' + $$$Text("Unable to create custom message structure.") + '");', 50);
			}
		break;

		case 'HL7CreateSegmentStructure':
			if (value.length > 0) {
				zenPage.gotoPage("EnsPortal.HL7.SchemaMain.zen");
			}
			else {
				setTimeout('alert("' + $$$Text("Unable to create custom segment structure.") + '");', 50);
			}
		break;

		case 'HL7CreateDataStructure':
			if (value.length > 0) {
				zenPage.gotoPage("EnsPortal.HL7.SchemaMain.zen");
			}
			else {
				setTimeout('alert("' + $$$Text("Unable to create custom data structure.") + '");', 50);
			}
		break;

		case 'HL7CreateCodeTable':
			if (value.length > 0) {
				zenPage.gotoPage("EnsPortal.HL7.SchemaMain.zen");
			}
			else {
				setTimeout('alert("' + $$$Text("Unable to create custom code table.") + '");', 50);
			}
		break;

		case 'switchNamespace':
			zenPage.changeURLNamespace(value);
		break;
	}
	return true;
}

ClientMethod doExport(filename) [ Language = javascript ]
{
	var fileExists = zenPage.FileExists(filename);
	if (fileExists != 0) {
		var ok = confirm($$$FormatText($$$Text("Are you sure you want to overwrite %1?"),filename));
		if (!ok) {
			return;
		} else {
			var status = zenPage.setProperty('Filename',filename);
		}
	}
	var tbl = zen('table');
	var cat = tbl.getValue();
	var err = zenPage.ExportCategory(cat,filename);
	if (err == '') {
		alert($$$FormatText($$$Text("Exported HL7 schema category %1 to file %2"), cat, filename));
	} else {
		alert(err);
	}
}

ClassMethod CanDeleteCategory(pCategory) As %String [ ZenMethod ]
{
	Quit ('$D($$$vaSchemaDescGbl(pCategory,"std")))
}

ClassMethod GetDefaultDir() As %String [ ZenMethod ]
{
	Quit $G(^EnsPortal.Settings($Username,"ImportExportDir"))
}

ClassMethod SetDefaultDir(pPathname As %String) [ ZenMethod ]
{
	Set ^EnsPortal.Settings($Username,"ImportExportDir") = ##class(%File).GetDirectory(pPathname, 1)
}

Method Import(pFilename As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	try {
		If '##class(%File).Exists(pFilename) {
			Set tSC=$$$ERROR($$$EnsErrGeneral,"Unable to open file '"_pFilename_"'")
		} Else {
			TStart
			Set tSC=##class(EnsLib.HL7.SchemaXML).Import(pFilename,.tCatImported)
		}
	} catch {
		TRollback
		Set tSC=$$$SystemError
	}
	If $$$ISOK(tSC) {
		TCommit
		Set ^EnsPortal.Settings($Username,"HL7","CurrentDrawSchema") = tCatImported
		Quit "|"_tCatImported
	}
	Else { TRollback }
	Quit $$$StatusDisplayString(tSC)
}

Method ExportCategory(pCategory As %String, pFilename As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	Set tSC=$System.OBJ.Export(pCategory_".HL7",pFilename,"-d")
	Quit:$$$ISOK(tSC) ""
	Quit $$$FormatText($$$Text("Error exporting HL7 Schema category '%1' to file %2: "),pCategory,pFilename)_$$$StatusDisplayString(tSC)
}

/// User clicked on a tab, or selected a new item, so we need to fetch the required content from the server.
/// Use parameter rowSelected to reduce repeated disabling/enabling of Delete button
/// Use reloadtab to force tab data reload - for Source Control.
ClientMethod onTabChange(rowSelected, reloadtab) [ Language = javascript ]
{
	if (rowSelected) {
		var btn = document.getElementById('command_cmdDelete')
		if (btn && this.Category!='') {
			if (0 != this.CanDeleteCategory(this.Category)) {
				btn.className = 'commandButton';
				btn.title = 'Delete a schema category definition';
				if ((this.sourceControlEnabled) &&(!reloadtab)&&(this._lastSCTabCheck !== this.Category)) {
					//mark doc as unloaded so goes through source control
					zenPage._documentLoaded = false;
					//clear readOnlyReason so we will have another alert if needed showing reason
					this.readOnlyReason = '';
					//go through source control loadDocument: either call AddToSourceControl if new or call GetLatest. then call before and after sc holds
					this.initializeSourceControl();
				}
			} else {
				btn.className = 'commandButtonDisabled';
				btn.title ='Cannot delete schema category because it is a standard schema';
			}
		}
		this._lastSCTabCheck = this.Category;
	}

	this.layoutTabGroup();
	var tabGroup = zen('detailsTabGroup');
	var currTab = tabGroup.getCurrTabNo();
	if (!this._tabDisplay) {
		this._tabDisplay = new Object();
	}
	var tabName;
	switch (currTab) {
		case 1: tabName='htmlMessageTypes'; break;
		case 2: tabName='htmlDocTypes'; break;
		case 3: tabName='htmlSegments'; break;
		case 4: tabName='htmlComposites'; break;
		case 5: tabName='htmlCodeTables'; break;
		default: tabName='';
	}
	tabGroup.currTabName=tabName;

	if (tabName != '') {

		if ((this._tabDisplay[tabName] != this.Category)||(reloadtab)) {
			this.drawTabDetails(this.Category,tabName);
			this._tabDisplay[tabName] = this.Category;
		}
	}
}

ClientMethod drawTabDetails(row As %String, tabName As %String) [ Language = javascript ]
{
	var details = zen(tabName);
	if ((row == '') || (row == null)) {
		details.seed = '';
	} else {
		details.seed = row
	}
	details.refreshContents(true);
}

/// Handle the client-side rendering the of the right hand pane.
/// This is primarily due to IE as it shrinks the contents div without this intervention.
/// The function only adjusts the size of the tab group if not hidden.
ClientMethod layoutTabGroup() [ Language = javascript ]
{
	var detailsGroup = zen('detailsGroup');
	var detailsDiv = detailsGroup.getEnclosingDiv();
	var detailsTabGroup = zen('detailsTabGroup');
	var tabsDiv = detailsTabGroup.getEnclosingDiv();

	var winHeight = zenGetWindowHeight();

	var detailsPanel = zen('detailsPanel');
	var detailsDiv = detailsPanel.getEnclosingDiv();
	var paneWidth = detailsDiv.offsetWidth;

	var tabBar = detailsTabGroup.getTabBarElement();
	var hgt = winHeight - this.getTitleAreaHeight() - tabBar.offsetHeight;
	tabsDiv.style.height = hgt + 'px';

	// prevent IE resize logic
	detailsTabGroup.ieResizeBody = function() { return; };

	var winWidth = zenGetWindowWidth();
	var searchPanel = zen('searchGroup').getEnclosingDiv();
	var resultsPanel = zen('resultsPanel').getEnclosingDiv();

	var tabsWidth = winWidth - searchPanel.offsetWidth - resultsPanel.offsetWidth - 50;
	detailsTabGroup.setBodySize(hgt - 50, tabsWidth);
	//tabsDiv.style.width = detailsDiv.style.width + 'px';
}

ClassMethod DrawMessageTypesContent(pCat As %String) As %Status
{
	Quit ..DrawSchemaList(pCat,"MT",$$$FormatText($$$Text("HL7 Message Types in Category <b>%1</b>"),pCat))
}

ClassMethod DrawDocTypesContent(pCat As %String) As %Status
{
	Quit ..DrawSchemaList(pCat,"MS",$$$FormatText($$$Text("HL7 DocType structures in Category <b>%1</b>"),pCat))
}

ClassMethod DrawSegmentsContent(pCat As %String) As %Status
{
	Quit ..DrawSchemaList(pCat,"SS",$$$FormatText($$$Text("HL7 segment structures in Category <b>%1</b>"),pCat))
}

ClassMethod DrawCompositesContent(pCat As %String) As %Status
{
	Quit:(pCat="") $$$OK
	If ($D($$$vaSchemaGbl(pCat,"DT"))) {
		Quit ..DrawSchemaList(pCat,"DT",$$$FormatText($$$Text("HL7 composite and elementary data type structures in Category <b>%1</b>"),pCat))
	} Else {
		Quit ..DrawSchemaList(pCat,"DS",$$$FormatText($$$Text("HL7 composite and elementary data type structures in Category <b>%1</b>"),pCat))
	}
}

ClassMethod DrawCodeTablesContent(pCat As %String) As %Status
{
	Quit ..DrawSchemaList(pCat,"CT",$$$FormatText($$$Text("HL7 Code Tables in Category <b>%1</b>"),pCat))
}

ClassMethod DrawSchemaList(pCat As %String, pElement As %String, pTitle As %String) As %Status
{
	Quit:((pCat="")||(pElement="")) $$$OK

	Set ^EnsPortal.Settings($Username,"HL7","CurrentDrawSchema") = pCat

	// set up values needed in main loop
	Set tNum = $$$Text("Number")
	Set elementsPerRow = 6
	Set max=0
	Set next=$O($$$vaSchemaGbl(pCat,pElement,""))
	Set n1st=$ZCVT($E(next),"U")
	Set cellContent = $S(+next=next:tNum,1:n1st)
	Set linkName=$case(pElement,
		"MT":"MessageType",
		"MS":"DocumentStructure",
		"SS":"SegmentStructure",
		"DS":"DataStructure",
		"DT":"DataStructure",
		"CT":"CodeTable",
		  :"UnknownStructure")
	Set zenPage="EnsPortal.HL7.Schema"_linkName
	Set lineNum=1

	If ('$D($$$vaSchemaDescGbl(pCat,"std"))) {
		If pElement '= "DT" {
			Set tNew = "zenPage.doNew" _ pElement _ "();"
			Set tCopy = "zenPage.doCopy" _ pElement _ "();"
		}
		Else {
			Set tNew = "zenPage.doNewDS();"
			Set tCopy = "zenPage.doCopyDS();"
		}
		&html<
			<div style="padding:10px 0px 0px 0px;">
			<table cellspacing=4>
			<tr>
			<td>
			<button type="button" class="commandButton" onclick="#(tNew)#">New</button>
			</td>
			<td>
			<button type="button" class="commandButton" onclick="#(tCopy)#">Copy From Base</button>
			</td>
			</tr>
			</table>
			</div>
		>
	}
	// display all the items
	Set tDesc=..EscapeHTML($G($$$vaSchemaDescGbl(pCat)))
	&html<
		<div style="padding:10px 0px 10px 0px">#(pTitle_$S(""=tDesc:"",1:"<br/><i>"_tDesc_"</i>"))#</div>
		<table cellpadding=0 cellspacing=0>
			<tr>
				<td valign="top" class="alphaEntry">#(cellContent)#&nbsp;</td>
				<td>
					<table class="tpTable" cellpadding=4 cellspacing=0>
	>

	For itemCount=1:1 {
		Set item=next, i1st=n1st
		Quit:item=""
		Set next=$O($$$vaSchemaGbl(pCat,pElement,item)), n1st=$ZCVT($E(next),"U")
		If itemCount=1 { // start the row
			&html<<tr>>
		}
		Set:itemCount>max max=itemCount
		Set tDesc=..EscapeHTML(##class(EnsLib.HL7.Schema).GetDescription(pElement_":"_pCat_":"_item))
		Set tooltip = $S(""'=tDesc:tDesc, 1:pElement_":"_pCat_":"_item)
		Set:(pElement="DT") fullLink = ..Link(zenPage_".zen?DS="_$$$URLENCODE("DS:"_pCat_":"_item))
		Set:(pElement '= "DT") fullLink = ..Link(zenPage_".zen?"_pElement_"="_$$$URLENCODE(pElement_":"_pCat_":"_item))

		&html<<td><a title='#(tooltip)#' href='#(fullLink)#'>#(item)#</a></td>>

		If i1st'=n1st&&'((+item=item)&&(+next=next)) { // there are no more items left

			// reset the counters
			Set max=0,itemCount=0
			Set lineNum = 1

			// finish the inner row, inner table, outer row; do spacer row; start next row and entry
			&html<
				</tr></table></td></tr><tr><td>&nbsp;</td></tr>
				<tr>
					<td valign="top" class="alphaEntry">#($S(+next=next:tNum,1:n1st))#&nbsp;</td>
					<td>
						<table class="tpTable" cellpadding=4 cellspacing=0>
				>
		}
		ElseIf (itemCount#elementsPerRow=0) { // reached max elements in row, but there are more items left
			Set itemCount=0
			Set lineNum = lineNum + 1

			&html<</tr>#($C(13,10))#>
		}
	} //end For itemCount

	&html<</tr></table></td></tr></table>>
	Quit $$$OK
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("HL7 Schemas")
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	// commands: $LB(id,caption,help,onclick)
	Set pCommands(1) = $LB("cmdNew",$$$Text("New"),$$$Text("Create a new custom schema category definition"),"zenPage.doCustomSchema();")
	Set pCommands(2) = $LB("cmdImport",$$$Text("Import"),$$$Text("Import a new schema category definition from a .HL7 XML schema file"),"zenPage.doImportBrowse();")
	Set pCommands(3) = $LB("cmdExport",$$$Text("Export"),$$$Text("Export a schema category definition to a .HL7 XML file"),"zenPage.doExportBrowse();")
	Set pCommands(4) = $LB("cmdDelete",$$$Text("Delete"),$$$Text("Delete a schema category definition"),"zenPage.doDelete();")
	Quit $$$OK
}

/// Decorate the page.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()  Quit:$$$ISERR(tSC) tSC

	Set ..HelpAddress = $$$PRODUCT2 _ ", HL7 Schemas"

	If ..Category="" && $D(^EnsPortal.Settings($Username,"HL7","CurrentDrawSchema")) {
		Set ..Category = ^EnsPortal.Settings($Username,"HL7","CurrentDrawSchema")
	}
	Quit tSC
}

/// Callback to return a list of resources required for a specific HyperEvent.
/// The user must have sufficient privileges on one of the resource/permission pairs
/// to be permitted to execute the hyperevent. An empty string implies the user already
/// has sufficient privileges for the ZenMethod specified in <var>pMethod</var>.
ClassMethod GetHyperEventResources(pMethod As %String = "") As %String
{
	Quit $case(pMethod,
					"Import": ..#EDITRESOURCE,
					"DeleteCategory": ..#EDITRESOURCE,
					: "")
}

/*
	Source Control support.
*/
/// Get the JSON 'model' on the client.
ClientMethod getClientModel() [ Language = javascript ]
{
	return zen('scjson');
}

/// Needed for getClientModel - timestamp
Method LoadSchemaAsJSON(ByRef pParms, Output pObject As %ZEN.proxyObject) As %Status [ Internal ]
{
	If '..sourceControlEnabled Quit $$$OK
	#; If system schema ('std' schema) quit
	If ((..Category="") || ('..CanDeleteCategory(..Category))) Quit $$$OK

	#dim tStatus = $$$OK
	Set pObject = ""
	#dim tObject = ""
	Try {
		Set tStatus = ..GetCategoryProxy(..Category,.tObject)
		If $$$ISERR(tStatus) Quit
		Set pObject = tObject
		If $IsObject(pObject) {
			Set pObject.isNew = ..isNew
			If ..IsSourceControlReadOnly(..GetInternalName()) {
				Set pObject.ReadOnly = 2
			}
		}
	}
	Catch {
		Set tStatus = $$$SystemError
	}

	Quit tStatus
}

/// Helper method to create a Zen proxyObject instance to represent the specified Schema Category timestamp.
ClassMethod GetCategoryProxy(pCategory As %String = "", Output pProxy As %ZEN.proxyObject) As %Status [ Internal ]
{
	#dim tStatus = $$$OK
	#dim tLocked = 0
	Set pProxy = ""
	Try {
		If pCategory = "" {
			Quit
		}
		#dim tReadOnly = 0
		Lock +^EnsHL7.Schema(pCategory):2
		If '$Test {
			Set tReadOnly = 1
		}
		Else {
			Set tLocked = 1
		}
		Set pProxy = ##class(%ZEN.proxyObject).%New()
		Set pProxy.Timestamp = ##class(EnsLib.HL7.SchemaDocument).TimeStamp(pCategory)
		Set pProxy.ReadOnly = tReadOnly

	} Catch {
		Set tStatus = $$$SystemError
	}
	If tLocked Lock -^EnsHL7.Schema(pCategory)
	Quit tStatus
}

/// Provide JSON saving stub of HL7 Schema - for timestamp and and locking purposes.
/// HL7 Schema edits are done directly and not via json document. This is provided as place holder.
Method SaveJSONversionOfSchema(pCommand As %String, pProvider As %ZEN.Auxiliary.jsonProvider, pSubmitObject As %ZEN.proxyObject, Output pResponseObject As %RegisteredObject) As %Status [ Internal ]
{
	If '..sourceControlEnabled Quit $$$OK

	If ((..Category'="") && ('..CanDeleteCategory(..Category))) Quit $$$OK

	#dim tStatus = $$$OK
	#dim tLocked = 0
	Try {
		If (pCommand = "save") || (pCommand = "forcesave") {
			If ..Category = "" {
				Set tStatus = $$$ERROR($$$EnsErrGeneral,"Schema cannot be saved without a Category name.")
				Quit
			}
			Lock +^EnsHL7.Schema(..Category):3
			If '$Test {
				Set tStatus = $$$ERROR($$$LockFailedToAcquireExclusive,$name(^EnsHL7.Schema(..Category)))
				Quit
			}
			Set tLocked = 1
			If (pCommand = "save") && ##class(EnsLib.HL7.SchemaDocument).Exists(..Category) {
				#dim  tSavedTimestamp = ##class(EnsLib.HL7.SchemaDocument).TimeStamp(..Category)
				#; Handle non-upgraded cases where timestamp will be ""
				If (tSavedTimestamp '= "") && (tSavedTimestamp '= pSubmitObject.Timestamp) {
					Set pProvider.error = "timestamp"
					Quit
				}
			}
			If ..IsSourceControlReadOnly(..GetInternalName()) {
				Set pProvider.error = $$$Text("Your source control framework has marked this document as read only, so you will not be able to modify this document.")
				Quit
			}

			Set tStatus = ..GetCategoryProxy(..Category,.pResponseObject)
			If $$$ISERR(tStatus) Quit
		}
		Else {
			Set tStatus = $$$ERROR($$$EnsErrGeneral,"Invalid command")
			Quit
		}
	}
	Catch {
		Set tStatus = $$$SystemError
	}
	If tLocked Lock -^EnsHL7.Schema(..Category)
	Quit tStatus
}

/// Return the internal name of the current document.
Method GetInternalName() As %String
{
	Quit ..Category_".HL7"
}

/// Return the current name of the class/object being modified
ClientMethod getCurrentName() [ Language = javascript ]
{
	return this.Category;
}

/// Return the extension used by Studio for the class/object
ClientMethod getCurrentExtension() [ Language = javascript ]
{
	return '.HL7';
}

/// Ensure we redraw the schema information if a reload was requested
ClientMethod onDocumentReload(reason) [ Language = javascript ]
{
	if (this._inUndo || this._inReload) return; // avoid recursion
	this._inReload = true;
	// Only show alert() if canEdit
	this.updateDocumentState((this.canEdit));
	this._inReload = false;
}

/// Toggle showing the source control icons
ClientMethod toggleSourceControlIcons(hide) [ Language = javascript ]
{
	var scRibbonElements = self.document.querySelectorAll('[id^="sourceControl"]');
	if ((scRibbonElements) && (scRibbonElements.length)) {
		for (var i = 0; i < scRibbonElements.length; i++) {
			if (scRibbonElements[i].id) self.document.getElementById(scRibbonElements[i].id).hidden = hide ;
		}
	}
	return '';
}

/// Look through the table data to see if standard schema
ClientMethod isStandardSchema(table) As %Boolean [ Language = javascript ]
{
	var isStandard = true;
	if (table && table.getRenderedRowData && table.selectedIndex) {
		var rowData = table.getRenderedRowData(table.selectedIndex);
		if (rowData) isStandard = (rowData.IsStandard.toLowerCase() == 'yes');
	}
	return isStandard;
}

/// Callback method invoked after we have successfully loaded the current document.
/// If user does not have write privileges then no need to show any Source Control reason
ClientMethod onDocumentLoadComplete() [ Language = javascript ]
{
	// Only show any source control alert() if canEdit
	this.updateDocumentState(this.canEdit);
}

/// Helper method to ensure that <property>documentTimestamp</property> and
/// <property>readOnly</property> are up to date on the client.
ClientMethod updateDocumentState(alertOnReadOnly) [ Language = javascript ]
{
	this.invokeSuper('updateDocumentState',arguments);
	this.onTabChange(true,true);
}

/// Call <method>UpdateSCMenu</method>() first in case the document has been modified elsewhere,
/// then display the source control menu based on the contents of the _sourceControlMenu data
/// created by <method>UpdateSCMenu</method>().
ClientMethod showSCMenu() [ Language = javascript ]
{
	this.UpdateSCMenus();
	this.invokeSuper('showSCMenu',arguments);
}

/// Handle a source control menu selection.
ClientMethod chooseSCMenu(menuName, commandName, saveFlags) [ Language = javascript ]
{
	zenPage.wasReadOnly = zenPage.getIsReadOnly();
	this.invokeSuper('chooseSCMenu',arguments);
	zenPage.toggleReadOnly();
}

/// Implement OnSchemaDelete to be able to call Source Control OnBeforeDelete and OnAfterDelete around the global sets
Method OnSchemaDelete(pWhen As %String = "before", Output pOutput As %DynamicObject) As %String [ Internal ]
{
	If '..sourceControlEnabled Quit ""

	#dim tStatus = $$$OK
	#dim ex AS %Exception.AbstractException

	Set pOutput = {}

	#dim tIO
	#dim tSourceControl
	#dim tCreated = 0

	Try {
		#dim tReturn = ""
		Set tStatus = $$$OK
		Set pOutput.serverOutput = ""

		Set tStatus = ##class(%CSP.Portal.SourceControl.IO).Redirect(.tIO,,,,..sourceControlNewlineFormat)
		If $$$ISERR(tStatus) Quit
		Set tStatus = ..CreateSourceControl(.tSourceControl, .tCreated)
		If $$$ISERR(tStatus) Quit

		If 'tCreated Quit

		#dim tProjectName = ..GetCurrentProject()

		If tProjectName '= "" {
			Set tStatus = ..LoadProject(tSourceControl, tProjectName, 0)
			If $$$ISERR(tStatus) Quit
		}

		Set pOutput.created = 1
		If pWhen = "before" {
			Set tStatus = tSourceControl.OnBeforeDelete(..GetInternalName())
		}
		Else {
			Set tStatus = tSourceControl.OnAfterDelete(..GetInternalName())
		}

	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	If $IsObject($get(tIO)) {
		Try {
			Do ..handleRedirect(tIO, .tStatus, pOutput)
		} Catch ex {Set tStatus = $$$ADDSC(tStatus,ex.AsStatus())}
	}

	If $$$ISERR(tStatus) Set tReturn = $system.Status.GetErrorText(tStatus)

	Quit tReturn
}

}
