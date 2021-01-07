/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsEDIASTM

Class EnsPortal.EDI.ASTM.SchemaMain Extends EnsPortal.EDI.Template [ System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "ASTM Schemas";

/// User must have WRITE permissions on the %Ens_EDISchema resource to make changes on this page.
Parameter EDITRESOURCE = "%Ens_EDISchema:WRITE";

Parameter CSSINCLUDES = "ensemble/Ensemble_Wizards.css,ensemble/Ensemble_EDI.css";

Property Status As %String;

/// Is the user permitted to access the fileSelect popup.
Property canViewFileSystem As %Boolean [ InitialExpression = {$system.Security.Check("%Ens_ViewFileSystem","USE")} ];

/// Id of selected Category row in results table.
Property Category As %ZEN.Datatype.string(ZENURL = "CAT");

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
	queryClass="EnsLib.EDI.ASTM.Schema"
	queryName="TypeCategories"
	useSnapshot="true"
	showZebra="true"
	showRowNumbers="false"
	valueColumn="Category"
	maxRows="2000"
	nowrap="false"
	onselectrow="zenPage.updateRowVals(zenThis);"
	>
<column header="Category" colName="Category" OnDrawCell="DrawHoverTitle" />
<column header="Base" colName="Base"/>
<column header="Standard" colName="IsStandard" OnDrawCell="DrawYesNo" style="text-align:left;" 
	    title="Yes if the schema is a standard schema, otherwise No"/>
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
<tab id="tabDocTypes" caption="DocType Structures" title="Document type structures">
<html id="htmlDocTypes" OnDrawContent="DrawDocTypesContent" />
</tab>
<tab id="tabSegments" caption="Segment Structures" title="Segment structures">
<html id="htmlSegments" OnDrawContent="DrawSegmentsContent" />
</tab>
<tab id="tabComponents" caption="Composite Structures" title="Sub-element composite data structures">
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

/// Draw Yes or No in place of 1 or 0
Method DrawYesNo(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
	Write $S(%query(pName):$$$Text("Yes"), 1:$$$Text("No"))
	Quit $$$OK
}

/// Draw name or name with description hover text if description is available
Method DrawHoverTitle(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
	Set tDescription = ..EscapeHTML(%query("Description"))
	Set tName = ..EscapeHTML(%query(pName))
	Write $S(""=tDescription:tName, 1:"<div title="""_tDescription_""">"_tName_"</div>")
	Quit $$$OK
}

/// This client event, if present, is fired when the page is loaded.
/// Start the timer so we can check the status. If there is a
/// background import job currently running,
/// you will see a periodic update until the job is finished.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',[]);

	// Ensure that tab content is correctly initialised
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

ClientMethod updateRowVals(table) [ Language = javascript ]
{
	this.Category = (table && (typeof table == 'object')) ? table.getValue() : '' // got passed the tablePane object
	this.onTabChange();
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
		wildcard:'*.AST;*.XML'
	}
	zenLaunchPopupWindow(zenLink('%ZEN.Dialog.fileSelect.zen',this.studioMode),this.addPopupSuffix('ASTMImportSelect'),'status,scrollbars,resizable,width=660,height=700,modal=no',parms);
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
		wildcard:'*.AST'
	}
	zenLaunchPopupWindow(zenLink('%ZEN.Dialog.fileSelect.zen',this.studioMode),this.addPopupSuffix('ASTMExportSelect'),'status,scrollbars,resizable,width=660,height=700,modal=no',parms);
	// the onPopupAction callback will be called when this dialog completes.
}

ClientMethod doDelete() [ Language = javascript ]
{
	if (!this.checkEdit()) { return false; }

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

Method DeleteCategory(pCategory As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	Quit:('..CanDeleteCategory(pCategory)) $$$FormatText($$$Text("Could not delete schema category '%1' because it is a standard schema."),pCategory)
	Set tKilled=$D($$$vaSchemaGbl(pCategory))
	Kill $$$vaSchemaGbl(pCategory),$$$vaSchemaDescGbl(pCategory)
	Quit:tKilled ""
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
		case 'ASTMImportSelect':
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
				zenPage.gotoPage("EnsPortal.EDI.ASTM.SchemaMain.zen");
			} else {
				document.getElementById('trStatus').innerHTML = '<td colspan=2>'+err+'</td>';
			var divTitle = $$$FormatText($$$Text('Importing file %1'),value);
				zenPage.showProgressDiv(divTitle);
			}
		break;

		case 'ASTMExportSelect':
			setTimeout(function() {
				zenPage.doExport(value);
			}, 50);
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
		alert($$$FormatText($$$Text("Exported ASTM schema category %1 to file %2"), cat, filename));
	} else {
		alert(err);
	}
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
			Set tSC=##class(EnsLib.EDI.ASTM.SchemaXML).Import(pFilename,.tCatImported)
		}
	} catch {
		Set tSC=$$$SystemError
	}
	If $$$ISOK(tSC) {
		Set ^EnsPortal.Settings($Username,"ASTM","CurrentDrawSchema") = tCatImported
		Quit "|"_tCatImported
	}
	Quit $$$StatusDisplayString(tSC)
}

Method ExportCategory(pCategory As %String, pFilename As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	Set tSC=$System.OBJ.Export(pCategory_".AST",pFilename,"-d")
	Quit:$$$ISOK(tSC) ""
	Quit $$$FormatText($$$Text("Error exporting ASTM Schema category '%1' to file %2: "),pCategory,pFilename)_$$$StatusDisplayString(tSC)
}

/// User clicked on a tab, or selected a new item, so we need to fetch the required content from the server.
ClientMethod onTabChange() [ Language = javascript ]
{
	var btn = document.getElementById('command_cmdDelete')
	if (btn && this.Category!='') {
		if (0 != this.CanDeleteCategory(this.Category)) {
			btn.className = 'commandButton';
			btn.title = 'Delete a schema category definition';
		} else {
			btn.className = 'commandButtonDisabled';
			btn.title ='Cannot delete schema category because it is a standard schema';
		}
	}

	this.layoutTabGroup();
	var tabGroup = zen('detailsTabGroup');
	var currTab = tabGroup.getCurrTabNo();
	if (!this._tabDisplay) {
		this._tabDisplay = new Object();
	}
	var tabName;
	switch (currTab) {
		case 1: tabName='htmlDocTypes'; break;
		case 2: tabName='htmlSegments'; break;
		case 3: tabName='htmlComposites'; break;
		case 4: tabName='htmlCodeTables'; break;
		default: tabName='';
	}
	tabGroup.currTabName=tabName;

	if (tabName != '') {
		if (this._tabDisplay[tabName] != this.Category) {
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

ClassMethod CanDeleteCategory(pCat As %String) As %String [ ZenMethod ]
{
	Quit '(+$G($$$vaSchemaDescGbl(pCat,"std")))
}

ClassMethod DrawDocTypesContent(pCat As %String) As %Status
{
	Quit ..DrawSchemaList(pCat,"DS",$$$FormatText($$$Text("ASTM DocType structures in Category <b>%1</b>"),pCat))
}

ClassMethod DrawSegmentsContent(pCat As %String) As %Status
{
	Quit ..DrawSchemaList(pCat,"SS",$$$FormatText($$$Text("ASTM segment structures in Category <b>%1</b>"),pCat))
}

ClassMethod DrawCompositesContent(pCat As %String) As %Status
{
	Quit ..DrawSchemaList(pCat,"CS",$$$FormatText($$$Text("ASTM composite data type structures in Category <b>%1</b>"),pCat))
}

ClassMethod DrawCodeTablesContent(pCat As %String) As %Status
{
	Quit ..DrawSchemaList(pCat,"CT",$$$FormatText($$$Text("ASTM Code Tables in Category <b>%1</b>"),pCat))
}

ClassMethod DrawSchemaList(pCat As %String, pElement As %String, pTitle As %String) As %Status
{
	Quit:((pCat="")||(pElement="")) $$$OK

	Set ^EnsPortal.Settings($Username,"ASTM","CurrentDrawSchema") = pCat

	// set up values needed in main loop
	Set tNum = $$$Text("Number")
	Set elementsPerRow = 6
	Set max=0
	Set next=$O($$$vaSchemaGbl(pCat,pElement,""))
	Set n1st=$ZCVT($E(next),"U")
	Set cellContent = $S(+next=next:tNum,1:n1st)
	Set linkName=$Case(pElement,
		"DS":"DocumentStructure",
		"SS":"SegmentStructure",
		"CS":"ComponentStructure",
		"CT":"CodeTable",
		  :"UnknownStructure")
	Set zenPage="EnsPortal.EDI.ASTM.Schema"_linkName
	Set lineNum=1

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
		Set tDesc=..EscapeHTML(##class(EnsLib.EDI.ASTM.Schema).GetDescription(pElement_":"_pCat_":"_item))
		Set tooltip = $S(""'=tDesc:tDesc, 1:pElement_":"_pCat_":"_item)
		Set fullLink = ..Link(zenPage_".zen?"_pElement_"="_$$$URLENCODE(pElement_":"_pCat_":"_item))

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
	Quit $$$Text("ASTM Schemas")
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	// commands: $LB(id,caption,help,onclick)
	Set pCommands(1) = $LB("cmdImport",$$$Text("Import"),$$$Text("Import a new schema definition from a SEF or XML file"),"zenPage.doImportBrowse();")
	Set pCommands(2) = $LB("cmdExport",$$$Text("Export"),$$$Text("Export a schema definition category to an XML file"),"zenPage.doExportBrowse();")
	Set pCommands(3) = $LB("cmdDelete",$$$Text("Delete"),$$$Text("Delete a schema definition category"),"zenPage.doDelete();")
	Quit $$$OK
}

/// Decorate the page.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()  Quit:$$$ISERR(tSC) tSC

	Set ..HelpAddress = $$$PRODUCT2 _ ", ASTM Schemas"

	If ..Category="" && $D(^EnsPortal.Settings($Username,"ASTM","CurrentDrawSchema")) {
		Set ..Category = ^EnsPortal.Settings($Username,"ASTM","CurrentDrawSchema")
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

}
