/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsAgent)

/// Agent browser page
Class EnsPortal.Agents Extends EnsPortal.Template.viewerPage [ System = 4 ]
{

/// User needs READ permissions on the %EnsLib_Agent resource to view this page.
Parameter RESOURCE = "%Ens_Agents:READ";

/// User needs WRITE permissions on the %Ens_Agents resource to make changes to this page.
Parameter EDITRESOURCE = "%Ens_Agents:WRITE";

/// Displayed name of this page.
Parameter PAGENAME = "Agents";

/// Comma-separated list of additional JS include files for the page.
Parameter JSINCLUDES = "ensemble/Ensemble_Utils.js";

Property checkEdit As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

Property detailsWidth As %ZEN.Datatype.integer(MAXVAL = 80, MINVAL = 5) [ InitialExpression = 30 ];

Property pageSizeId As %ZEN.Datatype.id [ InitialExpression = "MaxRows" ];

Property pageNumberId As %ZEN.Datatype.id [ InitialExpression = "pageTotal" ];

/// Flag to indicate whether the searchPanel is currently hidden.
Property searchHidden As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

Property sessionLinkTitle As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Click to view a visual trace of the session")} ];

Property tracePage As %ZEN.Datatype.string [ InitialExpression = "EnsPortal.VisualTrace.zen" ];

Property startId As %ZEN.Datatype.string(ZENURL = "StartId");

Property endId As %ZEN.Datatype.string(ZENURL = "EndId");

Property msgVersions As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Versions")} ];

/// Is the user permitted to access the fileSelect popup.
Property canViewFileSystem As %Boolean [ InitialExpression = {$system.Security.Check("%Ens_ViewFileSystem","USE")} ];

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
/* div around results table */
#resultsTable {
	height: 610px;
	overflow-y: scroll;
}

/* style for intro words *//* not currently used */
#intro {
	padding:30px;
}

/* style for table */
#table {
	overflow: auto;
}

/* div around details table */
#detailsTabGroup .tabGroupBar {
	padding-top: 2px;
}

/* details pane style */
#detailsGroup {
	overflow: auto;
}

/* style for search panel */
.menuPanel {
	width: 300px;
	background: #edece4;
	overflow-y: auto;
}

/* slight adjustments to tpTable */
table.tpTable, table.eventInfoTable {
	padding-top: 5px;
	border: none;
}

.sessionLink {
	cursor: pointer;
	color: #3B84BC;
	text-decoration: none;
}
tr.tpSelected a.sessionLink {
	color: white;
	text-decoration: underline;
}

table.propListTable {
	width: 100%;
	border: 1px solid #C0C0C0;
	background: white;
}

.rowEven {
}

.rowOdd {
	background: #F0F0F0;
}

table.propListTable th {
	border-bottom: 1px solid #C0C0C0;
	color: #404040;
	font-size: 9pt;
	font-weight: bold;
	background: #E0E0E0;
	text-align: left;
	padding: 1px;
}

table.propListTable td {
	border-bottom: 1px solid #C0C0C0;
	color: #404040;
	font-size: 9pt;
	text-align: left;
	padding: 1px;
}
</style>
}

/// This pane displays the search criteria. We provide defaults and user can change them.
/// User's values are saved and used as future defaults for this user.
/// Clicking a drop down list item will refresh the table immediately. 
/// Text fields you are required to click [Enter] or the "Search" button.
XData searchPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" >
<vgroup id="mainPanel" enclosingClass="menuPanel"  valign="top">
<form name="searchForm" id="searchForm" layout="vertical" cellStyle="padding: 2px 10px; font-size:0.8em;">
<vgroup valign="top">
<hgroup>
<select label="Auto-Refresh" name="chkRefresh" id="chkRefresh" hidden="true"
	   displayList="None,30 Seconds,60 Seconds,2 Minutes,5 Minutes" valueList="None,30000,60000,120000,300000" value="None" showEmpty="false"
		onclick="zenPage.changeRefresh();"/>
<spacer width="10" />
<select label="Page Size" id="pageSize" name="pageSize" showEmpty="false" valueList="10,20,30,50,100,200,500,1000,2000,5000" value="500" />
<spacer width="10" />
<text label="Page" id="pageNumber" name="pageNumber" readOnly="true" size="4" controlStyle="background: lightgrey" />
</hgroup>
<spacer height="5" />
<hgroup>
<select label="Sort By" id="SortBy" name="SortBy" showEmpty="false" displayList="Name,Status,Last Active,Availability" valueList="AgentName,Status,LastInvocation,Availability" value="Name"/>
<spacer width="10" />
<checkbox valign="bottom" name="Descending" id="Descending" caption="Descending" value="0"/>
</hgroup>
<spacer height="10" />
<selector id="WordMatch" label="Word Match" name="WordMatch" size="30" context=""/>
</vgroup>
<expando name="expAvailability" id="expAvailability" caption="Availability" expanded="true" childIndent="16px" containerStyle="padding:10px 10px 0px 10px;" >
<hgroup>
<vgroup cellStyle="font-size:0.8em">
<checkbox name="Init" id="Init" caption="Init" title="" value="1"/>
<checkbox name="Ready" id="Ready" caption="Ready" title="" value="1"/>
<checkbox name="Failed" id="Failed" caption="Failed" title="" value="1"/>
<checkbox name="Stopped" id="Stopped" caption="Stopped" title="" value="1" />
</vgroup>
<spacer width="15" />
<vgroup cellStyle="font-size:0.8em">
<checkbox name="Partial" id="Partial" caption="Partial" title="" value="1" />
<checkbox name="PartialFailed" id="PartialFailed" caption="Partial Failed" title="" value="1"/>
<checkbox name="PartialStopped" id="PartialStopped" caption="Partial Stopped" title="" value="1"/>
<checkbox name="Other" id="Other" caption="Other" title="" value="1"/>
</vgroup>
</hgroup>
<hgroup cellStyle="font-size:0.8em">
<checkbox name="Overdue"  id="Overdue" caption="Overdue" title="" value="1"/>
</hgroup>
</expando>
</form>
</vgroup>
</pane>
}

/// This pane displays agent items. User may click on a row and details are displayed to the side.
XData resultsPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>
<vgroup valign="top">
<!--<spacer height="5"/>-->
<tablePane id="resultsTable"
	queryClass="EnsPortal.Agents"
	queryName="Enumerate"
	cellSpacing="2"
	dataSource="columns"
	useSnapshot="true"
	pageSize="500"
	showZebra="true"
	valueColumn="ID"
	maxRows="1000"
	useKeys="true"
	showQuery="false"
	onupdate="zenPage.onUpdate(zenThis);"
	onselectrow="zenPage.rowSelected(zenThis);"
	onunselectrow="zenPage.rowUnSelected(zenThis);"
	nowrap="true" 
	onmouseoverClass="tpMouseOver"
	enableToggleSelect="true"
	initialExecute="false"
	unlockSession="true"
	>
	<parameter id="queryWhere" value=""/>
	<parameter id="querySortBy" value=""/>
	<parameter id="queryDescend" value=""/>
<!-- provide header values for all columns so they can be localized -->
<!-- ID,Name,Class,ConfigName,Category,Protocol,Stage,Version,Interface,Invoked,Status,Description -->
<column header="ID" colName="ID" title="Agent ID" disableSort="true" />
<column header="Name" colName="Name" title="Name of the Agent or other registered item" disableSort="true" />
<column colName="ConfigName" hidden="true"/>
<column header="Invoked" colName="LastInvocation" width="180" title="Date and time Agent was last invoked" disableSort="true"/>
<column header="Status" colName="Status" title="Current availability status of the Agent or client" disableSort="true"/>
<column header="Description" colName="Description" title="Description of the Agent or client" width="900" disableSort="true"/>

</tablePane>
<!-- set default auto refresh to "None" -->
<timer id="timer" ontimeout="zenPage.timeout(zenThis);" timeout="0"/>
</vgroup>
</pane>
}

XData detailsPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>
<!-- Get BPL Definition in JSON format -->
<jsonProvider id="regItem"
	OnGetTargetObject="GetRegItem"
	OnSubmitContent="SubmitRegItem"
>
<parameter id="regItemId" paramName="regItemId" value="-1"/>
</jsonProvider>
<tabGroup id="detailsTabGroup" showTabBar="true" remember="true" onshowTab="zenPage.onTabChange();" >
<tab id="tabSummary" caption="Summary" title="Item summary details">
<form id="summaryForm" labelPosition="top" cellStyle="padding:3px;">
<label label="Details For Selected Agent" labelClass="labelBold"/>
</form>

<form id="detailsForm" labelPosition="top" cellStyle="padding:3px;">
<hgroup id="grpDetailsScroll" aux="%" cellVAlign="middle" labelPosition="left" cellStyle="padding:0px;">
<button id="btnApplyDetails" caption="Apply" controlClass="commandButton" onclick="zenPage.applyChanges()" />
<spacer width="5" />
<label id="lblAgent" label="Agent: " labelClass="labelRequired" labelStyle="font-size:0.8em; font-weight:bold;"/>
<spacer width="3" />
<label id="lblAgentName" label="Name" labelClass="labelBold" labelStyle="color:darkgreen;"/>
</hgroup>
<spacer height="3"/>
<hgroup>
<label id="lblAvailability" label="Availability:" labelClass="labelRequired" labelStyle="font-size:0.8em; font-weight:bold;"/>
<spacer width="3"/>
<label id="lblAgentAvailability" label="Availability" labelClass="labelBold" title="Availability of Agent as a whole"/>
</hgroup>
<spacer height="3"/>
<text label="Configuration Item" size="50" id="ctl_.ConfigItem" name="ctl_.ConfigItem"
enclosingStyle="padding-bottom:4px;" labelClass="labelRequired" labelStyle="font-size:0.8em; font-weight:bold;"
hint="Associated configuration item for settings"
title="If this is non-empty then it has an affinity with the named configured Agent.ProxyService; if it is empty the first Agent.ProxyService found will be used."/>
<spacer height="3"/>
<hgroup>
<text label="Config Timeout" size="18" id="ctl_.ConfigTimeout" name="ctl_.ConfigTimeout" 
enclosingStyle="padding-bottom:4px;" labelClass="labelRequired" labelStyle="font-size:0.8em; font-weight:bold;"
title="Number of seconds the associated config item should wait for a synchronous confirmation from the Agent of outbound traffic on this interface"/>
<spacer width="6"/>
<text label="Polling Interval" size="18" id="ctl_.Options.SA_PollInterval" enclosingStyle="padding-bottom:4px;" labelClass="labelRequired"
labelStyle="font-size:0.8em; font-weight:bold;" title="How often to send poll requests when idle" value=""/>
<spacer width="6"/>
<text label="Stay Connected" size="18" id="ctl_.Options.SA_StayConnected" enclosingStyle="padding-bottom:4px;" labelClass="labelRequired"
labelStyle="font-size:0.8em; font-weight:bold;" title="(Seconds) Controls number of HTTP requests on one socket" value=""/>
</hgroup>
<spacer height="3"/>
<textarea id="ctl_.Description" rows="3" cols="47" label="Description" hint="Description of this agent interface"
labelClass="labelRequired" labelStyle="font-size:0.8em; font-weight:bold;"/>
<spacer height="3" />
<textarea id="ctl_.Notes" rows="4" cols="47" label="Notes" hint="Notes about this agent"
labelClass="labelRequired" labelStyle="font-size:0.8em; font-weight:bold;"/>
<spacer height="3"/>
 <hgroup id="grpInterfaces">
<label label="Interfaces" labelClass="labelRequired" labelStyle="font-size:0.8em; font-weight:bold;"/>
<spacer width="5"/>
<image src="deepsee/ds_plus_16.gif" title="Add an interface for this agent" onclick="zenPage.editInterface('');"/>
</hgroup>
<html id="gInterfacesList" hint="List of interfaces for this agent"/>
</form>
</tab>
<tab id="tabActions" caption="Actions" title="Actions you can take relating to this item">
<spacer height="10" />
<hgroup id="grpPurge" cellStyle="padding: 10px;" cellVAlign="top">
<image src="deepsee/cancel_48.png"/>
<vgroup>
<button id="btnPurge" caption="Purge" controlClass="commandButton" title="Delete all the agents that satisfy the current search criteria" onclick="zenPage.doPurge();"/>
<label controlClass="zenLabel" label="Purge all displayed agents"/>
<spacer height="10" />
</vgroup>
</hgroup>
<hgroup id="grpExport" cellStyle="padding: 10px;" cellVAlign="top">
<image src="portal/software_development_48.gif"/>
<vgroup>
<button id="btnExport" caption="Export" controlClass="commandButton" title="Export the set of currently selected services to an XML file" onclick="zenPage.beginExport(zenPage.selectedId);"/>
<label controlClass="zenLabel" label="Export to file"/>
<spacer height="10" />
</vgroup>
</hgroup>
<hgroup id="grpImport" cellStyle="padding: 10px;" cellVAlign="top">
<image src="portal/software_development_48.gif"/>
<vgroup>
<button id="btnImport" caption="Import" controlClass="commandButton" title="Import a set of services from an XML file" onclick="zenPage.beginImport();"/>
<label controlClass="zenLabel" label="Import from file"/>
<spacer height="10" />
</vgroup>
</hgroup>
</tab>
</tabGroup>
</pane>
}

/// If auto-refresh is still on, refresh table and restart the timer
ClientMethod timeout(timer) [ Language = javascript ]
{
	var val = zen('chkRefresh').getValue(); // check auto-refresh
	if (zenPage.enableAutoRefresh && !val.match("None")) { // There is a non-zero timer value
		zenPage.doSearch(); // refresh table
		timer.startTimer(); // restart timer
	}
}

/// User chose a new Auto-Refresh value; set a new timeout value and start the timer
ClientMethod changeRefresh() [ Language = javascript ]
{
	var val = zen('chkRefresh').getValue(); // check auto-refresh
	if (zenPage.enableAutoRefresh && !val.match("None")) { // There is a non-zero timer value
		var timer = zen('timer'); // get timer
		timer.timeout = val; // set timeout
		timer.startTimer(); // restart timer
	}
	// Otherwise don't start the timer and it will just sit there
}

Method setSearchCriteria(init, ready, failed, stopped, overdue, part, partFail, partStop, other, word, sort, descend) As %String [ ZenMethod ]
{
	set where = ""
	Set avail = $S(init'="true":"",1:"'Init'")
	Set:ready="true" avail = $S(avail="":"",1:avail_",")_"'Ready'"
	Set:failed="true" avail = $S(avail="":"",1:avail_",")_"'Failed'"
	Set:stopped="true" avail = $S(avail="":"",1:avail_",")_"'Stopped'"
	Set:overdue="true" avail = $S(avail="":"",1:avail_",")_"'Overdue'"
	Set:part="true" avail = $S(avail="":"",1:avail_",")_"'Partial'"
	Set:partFail="true" avail = $S(avail="":"",1:avail_",")_"'PartialFailed'"
	Set:partStop="true" avail = $S(avail="":"",1:avail_",")_"'PartialStopped'"
	Set:other="true" avail = $S(avail="":"",1:avail_","_"(SELECT DISTINCT AVAILABILITY FROM EnsLib_Agent.Interface WHERE AVAILABILITY NOT IN ('Init','Ready','Failed','Stopped','Overdue','Partial','PartialFailed','PartialStopped'))")
	Set:avail'="" where = "Availability IN ("_avail_")"
	Set:avail="" where = "Availability NOT IN (SELECT DISTINCT AVAILABILITY FROM EnsLib_Agent.Interface)"

	If word'="" {
		Set word = $replace($zcvt(word,"U"),"'","''")
		Set where = $S(where="":"",1:where_" AND ")_"(%UPPER(Notes) LIKE '%"_word_"%' OR %UPPER(Description) LIKE '%"_word_"%' OR %UPPER(AgentName) LIKE '%"_word_"%' OR %UPPER(ConfigItem) LIKE '%"_word_"%')"
	}
	Quit where
}

/// User clicked the Search button, user changed a Quick Search or Event Type criterion, 
ClientMethod onSearchHandler() [ Language = javascript ]
{
	var old = zenSynchronousMode;
	zenSynchronousMode = true;

	var table = this.getResultsTable();
	var pageSize = zen('pageSize').getValue();
	table.setProperty('pageSize',pageSize);
	table.setProperty('clearSnapshot',true);
	table.setProperty('currPage',1);
	var page=zen('pageNumber');
	page.setValue(1);

	var sortBy = zen("SortBy").getValue();
	var descend = (zen("Descending").getValue())?1:0;

	var init = zen("Init").getValue();
	var ready = zen("Ready").getValue();
	var failed = zen("Failed").getValue();
	var stopped = zen("Stopped").getValue();
	var overdue = zen("Overdue").getValue();
	var partial = zen("Partial").getValue();
	var partialFailed = zen("PartialFailed").getValue();
	var partialStopped = zen("PartialStopped").getValue();
	var other = zen("Other").getValue();
	var wordMatch = zen("WordMatch").getValue();

	var where = zenPage.setSearchCriteria(init,ready,failed,stopped,overdue,partial,partialFailed,partialStopped,other,wordMatch,sortBy,descend);
	zen('queryWhere').setProperty('value', where);

	var refresh = zen('chkRefresh').getValue();
	var expAvail = (zen('expAvailability').getProperty('expanded')) ? 1 : 0;
	var hideDets = (this.detailsHidden) ? 1 : 0;
	var hideSearch = (this.searchHidden) ? 1 : 0;

	zen('querySortBy').setProperty('value',sortBy);
	zen('queryDescend').setProperty('value',descend);

	zenPage.saveDefaults(sortBy,descend,pageSize,refresh,expAvail,hideDets,hideSearch);

 /*
	// call server method to build the where clause
	var where = zenPage.GetWhereClause(Defaults,EventType);
	table.whereClause = where;
	table.orderByClause = "%ID";
*/

	zenSynchronousMode = old;
}

ClientMethod textControlKeyDown(evt, escOnly) [ Language = javascript ]
{
}

/// Use with certain <text> fields so user can hit Enter to indicate that an entry in the field is done and ready to use
ClientMethod enterKey() [ Language = javascript ]
{
	if (zenEvent.keyCode == zenENTER) zenPage.doSearch();
}

/// Fill search criteria defaults
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC

	If ..enableAutoRefresh {
		Set ..%GetComponentById("chkRefresh").hidden = 0
	}
	// get defaults and build up the initial display
	Do ..GetAndUseDefaults()
	Quit $$$OK
}

/// Method called from <method>%OnAfterCreatePage</method> to get defaults and build up the initial display
Method GetAndUseDefaults() As %String
{
	#; Get the last saved default values and use them as defaults.
	merge SearchCriteria = ^IRIS.Temp.EnsPortal($Username,"Skorpius","SearchCriteria")
	Set SortBy = $G(SearchCriteria("SortBy"))
	Set Descend = $G(SearchCriteria("Descend"))
	Set MaxRows = $P($G(SearchCriteria("Defaults")),"^",2)
	Set expandoState = $P($G(SearchCriteria("Defaults")),"^",3)
	Set AutoRefresh = $P($G(SearchCriteria("Defaults")),"^",1)
	Set HideDetails = $P($G(SearchCriteria("Defaults")),"^",4)
	Set HideSearch = $P($G(SearchCriteria("Defaults")),"^",5)
	
	If ('..enableAutoRefresh) {
		Set AutoRefresh = "None"
	}

	#; Load defaults
	Set:""'=SortBy ..%GetComponentById("SortBy").value = SortBy
	Set:""'=Descend ..%GetComponentById("Descending").value = Descend
	Set:""'=MaxRows ..%GetComponentById("pageSize").value = MaxRows

	#; Load Expando states
	Set:""'=expandoState ..%GetComponentById("expAvailability").expanded = expandoState
	Set:""'=HideDetails ..detailsHidden = HideDetails
	Set:""'=HideSearch ..searchHidden = HideSearch

	#; Load auto-refresh setting
	Set:""'=AutoRefresh ..%GetComponentById("chkRefresh").value = AutoRefresh

	#; Max Rows (Page Size)
	If (MaxRows > 10000) { Set MaxRows = 500 }
	If (MaxRows < 0) { Set MaxRows = 1 }
}

/// Callback that is executed to create the resultset for the main table.
ClassMethod GetResultSet(pWhere, pSortBy, pDescend, Output pSC As %Status, pInfo As %ZEN.Auxiliary.QueryInfo) As %ResultSet
{
	Set pSC = $$$OK
	Set tRS = ##class(%Library.ResultSet).%New("EnsPortal.Agents:Enumerate")
	//Do ..GetSearchCriteria(.tSearchCriteria)
	Set pSC = tRS.Execute(pWhere,pSortBy,pDescend)  Quit:$$$ISERR(pSC) $$$NULLOREF
	Set pInfo.queryExecuted = 1

	Set tMaxRows = 0
	Set tMaxRows = $p($G(tSearchCriteria("Defaults")),"^",2)
	If (tMaxRows = "") Set tMaxRows = 500
	Set pInfo.rows = tMaxRows
	Quit tRS
}

/// Reset the "Search Events By..." form fields to blank, reset other fields to defaults
ClientMethod formReset() [ Language = javascript ]
{
	var conftext = $$$Text("Reset to default values?")
	if (confirm(conftext)) {
		var table = zenPage.getResultsTable(); 

		// empty out the fields in the form
		zen("searchForm").reset(); 

		zen("Init").setValue(1);
		zen("Ready").setValue(1);
		zen("Failed").setValue(1);
		zen("Stopped").setValue(1);
		zen("Overdue").setValue(1);
		zen("Partial").setValue(1);
		zen("PartialFailed").setValue(1);
		zen("PartialStopped").setValue(1);
		zen("Other").setValue(1);

		zen('expAvailability').setProperty('expanded',true);

		// Restore default values to fields outside the "Search Events By..." area
		zen("SortBy").setValue("Name");  
		zen("pageSize").setValue(500);
		zen("chkRefresh").setValue("None");

		// refresh the display
		zenPage.doSearch();
	}
	return true;
}

ClientMethod onAfterPageChange() [ Language = javascript ]
{
	return true;
}

/// User clicked on a tab, or selected a new item, so we need to fetch the required content from the server.
ClientMethod onTabChange() [ Language = javascript ]
{
	// Don't get data from server if data isn't visible
	// It will be retrieved when the tabs are redisplayed
	if (!this.detailsHidden) {
		this.layoutTabGroup();
		if (this.selectedId != '') {
			var tabGroup = zen('detailsTabGroup');
			var currTab = tabGroup.getCurrTabNo();
			if (!this._tabDisplay) {
				this._tabDisplay = new Object();
			}
			switch (currTab) {
				case 1:
					if (this._tabDisplay['Summary'] != this.selectedId) {
						this._tabDisplay['Summary'] = this.selectedId;
					}
					break;
				case 2:
					if (this._tabDisplay['Actions'] != this.selectedId) {
						this.updateActions();
						this._tabDisplay['Actions'] = this.selectedId;
					}
					break;
				default:
					break;
			}
		}
	}
}

/// Handle the client-side rendering the of the right hand pane.
/// This is primarily due to IE as it shrinks the contents div without this intervention.
/// The function only adjusts the size of the tab group is not hidden.
ClientMethod layoutTabGroup() [ Language = javascript ]
{
	if (!this.detailsHidden) {
		var detailsTabGroup = zen('detailsTabGroup');
		var tabsDiv = detailsTabGroup.getEnclosingDiv();

		var winHeight = zenGetWindowHeight();
		var th = this.getTitleAreaHeight();
		var hgt = winHeight - th - 35;

		var detailsPanel = zen('detailsPanel');
		var detailsDiv = detailsPanel.getEnclosingDiv();
		var paneWidth = detailsDiv.offsetWidth;

		var tabBar = detailsTabGroup.getTabBarElement();
		hgt = hgt - tabBar.offsetHeight;
		//var versionsContentDiv = zen('versionsContent').getEnclosingDiv();
		//var frameHeight = hgt - 14 - versionsContentDiv.offsetHeight;
		tabsDiv.style.height = hgt + 'px';

		// prevent IE resize logic
		detailsTabGroup.ieResizeBody = function() { return; };

		var interfaceTab = zen('gInterfacesList').getEnclosingDiv();
		var tabsWidth = Math.max(interfaceTab.offsetWidth + 50, paneWidth - 10 - (!zenIsGecko * 5) - (zenIsHTML5 * 15));
		detailsTabGroup.setBodySize(hgt, tabsWidth);
		tabsDiv.style.width = tabsWidth + 'px';
		var frameWidth = (tabsWidth - 5) - (!zenIsGecko * 5) - (zenIsHTML5 * 15); // IE and Chrome introduce scrollbars with the extra 5px
	}
}

/// Save user's last search criteria into global for page default
Method saveDefaults(SortBy, Descend, MaxRows, AutoRefresh, Expanded, HideDetails, HideSearch) [ ZenMethod ]
{
	Set ^IRIS.Temp.EnsPortal($Username,"Skorpius","SearchCriteria","SortBy") = SortBy
	Set ^IRIS.Temp.EnsPortal($Username,"Skorpius","SearchCriteria","Descend") = Descend
	Set ^IRIS.Temp.EnsPortal($Username,"Skorpius","SearchCriteria","Defaults") = AutoRefresh_"^"_MaxRows_"^"_Expanded_"^"_HideDetails_"^"_HideSearch
}

Method DrawStatusContent(pHeaderID As %String) As %Status
{
	&html<<div class="detailContents detailContentsError">Status</div>>
	Quit $$$OK
}

ClientMethod updateActions() [ Language = javascript ]
{
	try {
		var hideSel = (this.selectedId != -1);
		var hideNoneSel = (this.selectedId == -1);

		zen('grpPurge').setHidden(hideSel);
		zen('grpImport').setHidden(hideSel);

		if (hideSel) {
			zenSetProp('btnExport','title', $$$Text('Export the currently selected agents to an XML file'));
		} else {
			zenSetProp('btnExport','title', $$$Text('Export all currently displayed agents to an XML file'));
		}
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in updateActions');
	}
}

/// Get the (localized) title string for the page.
Method %OnGetTitle() As %String
{
	Quit ..%OnGetPageName()
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Community Connector Agents")
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	// commands: $LB(id,caption,help,onclick)
	Set pCommands(1) = $LB("searchButton",$$$Text("Search"),$$$Text("Search through the Agents using the current criteria"),"zenPage.doSearch();")
	Set pCommands(2) = $LB("resetButton",$$$Text("Reset"),$$$Text("Reset the Agent search criteria to their default values"),"zenPage.formReset();")
	Set pCommands(3) = $LB("newButton",$$$Text("New Agent"),$$$Text("Register a new Agent"),"zenPage.doAgent();")
	Set pCommands(5) = $LB("delButton",$$$Text("Delete"),$$$Text("Delete the currently selected Agent"),"zenPage.doDelete();")
	Set pCommands(7) = $LB("prevButton",$$$Text("Previous"),$$$Text("Show the previous page of results, based on the Page Size"),"zenPage.getNextData(false);")
	Set pCommands(8) = $LB("nextButton",$$$Text("Next"),$$$Text("Show the next page of results, based on the Page Size"),"zenPage.getNextData(true);")
	Quit $$$OK
}

/// Add to the contents of the tool ribbon.
Method OnDrawRibbon() As %Status
{
	Quit $$$OK
}

/// Open New Agent dialog to register a new agent
ClientMethod doAgent() [ Language = javascript ]
{
	if (this.readOnly || !this.checkEdit) {
		alert(this.msgNotPermitted); 
		return false; 
	}
	var url = zenLink('EnsPortal.Dialog.NewAgent.zen',this.studioMode);
	zenLaunchPopupWindow(url,this.addPopupSuffix('NewAgent'),'status,scrollbars,resizable=yes,width=500,height=600');
}

/// Delete the selected agent
ClientMethod doDelete() [ Language = javascript ]
{
	if (!this.checkEdit) { 
		alert(this.msgNotPermitted);
		return false; }

	if (this.selectedId == -1) {
		alert($$$Text("First select an agent from the table, then click Delete to delete the agent."));
		return;
	}
	if (!confirm($$$Text("Are you sure you want to delete this agent?"))) {
		return;
	}

	// A service or client item was selected and confirmed for delete
	var err = zenPage.DeleteItem(this.selectedId);
	if (err.length > 0) {
		alert(err);
	} else { // Success: refresh the table
		var table = this.getResultsTable();
		table.value = ''; // setProperty does not work here
		zenPage.doSearch();
	}
}

ClassMethod DeleteItem(pId As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	Set tSC = $$$OK
	Set tName = $p(pId,"||",1)
	&sql(DELETE FROM EnsLib_Agent.Interface WHERE AgentName=:tName)
	If SQLCODE { 
		Set tSC=$$$ERROR($$$EnsErrGeneral,"SQL Error deleting agent: SQLCODE="_SQLCODE_" / "_$G(%msg))
	}
	Quit:$$$ISOK(tSC) ""
	Quit $$$FormatText($$$Text("Failed to delete agent %1:"),tName,$$$StatusDisplayString(tSC))
}

/// Delete all agents that satisfy the current search criteria
ClientMethod doPurge() [ Language = javascript ]
{
	if (!this.checkEdit) {
		alert(this.msgNotPermitted);
		return false;
	}

	if (!confirm($$$Text("Are you sure you want to delete all displayed agents?"))) {
		return;
	}
	var where = zen('queryWhere').getProperty('value');
	var sortBy = zen('querySortBy').getProperty('value');
	var descend = zen('queryDescend').getProperty('value');
	var err = zenPage.PurgeSelectedItems(where,sortBy,descend);
	if (err.length > 0) {
		alert(err);
	}
	zenPage.doSearch();
}

ClassMethod PurgeSelectedItems(where, sortBy, descend) As %ZEN.Datatype.string [ ZenMethod ]
{
	Set tMsg=""
	Set tInfo=##class(%ZEN.Auxiliary.QueryInfo).%New()
	Set tRS=..GetResultSet(where,sortBy,descend,.tSC,tInfo)
	If $$$ISOK(tSC) {
		Set tCount=0
		While tRS.Next(.tSC) && $$$ISOK(tSC) && (tCount<tInfo.rows) {
			Set tName=tRS.Data("Name")
			&sql(DELETE FROM EnsLib_Agent.Interface WHERE AgentName=:tName)
			If 'SQLCODE { Set tCount = tCount + 1 }
			Else { Set tMsg=tMsg_$S(""=tMsg:"",1:$C(13,10))_"SQL Error deleting agent: SQLCODE="_SQLCODE_" / "_$G(%msg) }
		}
	}
	Set:$$$ISERR(tSC) tMsg=tMsg_$S(""=tMsg:"",1:$C(13,10))_"Error in purge : "_$$$StatusDisplayString(tSC)
	Set tMsg=tMsg_$S(""=tMsg:"",1:$C(13,10))_"Purged "_tCount_$S(tCount=1:" agent",1:" agents")
	Quit tMsg
}

/// Ensure that the "Next" and "Previous" buttons behave correctly
/// based on the data returned from the current search.
ClientMethod updateNavigationButtons() [ Language = javascript ]
{
	this.isFirstPage = (this.currentPage == 1) || (parseInt(this.currentPageStart,10) < 0);
	var prev = document.getElementById('command_prevButton');
	if (prev) {
		prev.className = (this.isFirstPage ? 'commandButtonDisabled' : 'commandButton');
		prev.title = (this.isFirstPage ? $$$Text('No previous page for this search.') : $$$Text('Show the previous page of results, based on the Page Size'));
		prev.onclick = (this.isFirstPage ? function() { return false; } : function() { zenPage.getNextData(false); return false; });
	}
	
	var table = this.getResultsTable();
	this.isLastPage = (table.getPageCount() == table.getProperty('currPage'));
	var next = document.getElementById('command_nextButton');
	if (next) {
		next.className = (this.isLastPage ? 'commandButtonDisabled' : 'commandButton');
		next.title = (this.isLastPage ? $$$Text('No next page for this search.') : $$$Text('Show the next page of results, based on the Page Size'));
		next.onclick = (this.isLastPage ? function() { return false;} : function() {zenPage.getNextData(true);return false; } );
	}
}

ClientMethod clearPageNumber() [ Language = javascript ]
{
	var table = zenPage.getResultsTable();
	var page = zen('pageNumber');
	if (table.getProperty('rowCount')==0) {
		page.setValue('');
	}
}

ClientMethod getNextData(next) [ Language = javascript ]
{
	var table = this.getResultsTable();
	var currPage = table.getProperty('currPage');
	if (next == false) {
		if (currPage>=1) {
			table.setProperty('currPage',(currPage-1));
		}
	}
	else if (next == true) {
		if (currPage < table.getPageCount()) {
			table.setProperty('currPage',(currPage+1));
		}
	}
	this.currentPage = table.getProperty('currPage');
	var page = zen('pageNumber');
	page.setValue(table.getProperty('currPage'));
}

/// Subclass need to include the case "switchNamespace" if it is enabling "Switch" next to namespace.<br>
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if (action != 'ok') return false;
	popupName = this.removePopupSuffix(popupName);
	switch(popupName) {
		case 'switchNamespace':
			zenPage.changeURLNamespace(value);
			break;
		case 'NewAgent':
			zenPage.doSearch();
			break;
		case 'AgentInterface':
			zenPage.renderInterfacesTable();
			break;
		case 'selectExportFilepath':
			setTimeout(function() {
				var fileExists = zenPage.FileExists(value);
				if (fileExists != 0) {
					var ok = confirm($$$FormatText($$$Text("Are you sure you want to overwrite %1?"),value));
					if (!ok) {
						return;
					}
				}
				zenPage.SetDefaultDir(value);
				var where = zen('queryWhere').getProperty('value');
				var sortBy = zen('querySortBy').getProperty('value');
				var descend = zen('queryDescend').getProperty('value');
				zenPage.doExport(zenPage.selectedId,value,where,sortBy,descend);
			}, 50);
			break;
		case 'selectImportFilepath':
			setTimeout(function() {
				var fileExists = zenPage.FileExists(value);
				if (fileExists == 0) {
					alert($$$FormatText($$$Text("No file can be imported because no file exists at filepath %1."),value));
					return;
				}
				zenPage.SetDefaultDir(value);
				zenPage.setupImport(value);
			}, 50);
			break;	
		case 'importSelect':
			zenPage.doImport(value);
			break;			
	}
	return true;
}

/// override resultsTable TablePane methods
ClientMethod onUpdate(table) [ Language = javascript ]
{
	zenPage.clearPageNumber();
	table.selectRow = zenPage.selectRow;
	setTimeout('zenPage.onAfterSearch();',50);
}

/// Check to see if any properties of the current item have been changed since opening the current item (note that item re-opens on saving)
ClientMethod checkForChanges(obj, propName, changed) [ Language = javascript ]
{
	if (changed == true) return changed;
	if (null == obj || "object" != typeof obj) {
		var ctl = zen("ctl_."+propName);
		if (ctl) {
			changed = (ctl.getValue().toString() != zenPage.getBaseItem(propName).toString());
		}
		return changed;
	}
	if (propName == "Interfaces") {
		changed = zenPage.changedInterfaces();
		return changed;
	}
	if (propName == "Options") {
		if (obj.hasOwnProperty('SA_PollInterval')) {
			changed = (zen('ctl_.Options.SA_PollInterval').getValue().toString() != zenPage.getBaseItem('Options.SA_PollInterval').toString());
		}
		else {
			changed = (zen('ctl_.Options.SA_PollInterval').getValue().toString() != "")
		}
		if (changed) return changed;
		if (obj.hasOwnProperty('SA_StayConnected')) {
			changed = (zen('ctl_.Options.SA_StayConnected').getValue().toString() != zenPage.getBaseItem('Options.SA_StayConnected').toString());
		}
		else {
			changed = (zen('ctl_.Options.SA_StayConnected').getValue().toString() != "")
		}
		return changed;
	}
	
	// Handle Array
	if (obj instanceof Array) {
		for (var i = 0, len = obj.length; i < len; i++) {
			changed = zenPage.checkForChanges(obj[i],'', changed);
		}
		return changed;
	}

	// Handle Object
	if (obj instanceof Object) {
		for (var attr in obj) {
			if (obj.hasOwnProperty(attr)) {
				var name = propName == '' ? attr : propName + "." + attr;
				changed = zenPage.checkForChanges(obj[attr], name, changed);
			}
		}
		return changed;
	}
	throw new Error($$$FormatText($$$Text("Unable to confirm whether or not changes have been made to the current agent due to unsupported property type %1."),typeof obj));
}

ClientMethod getBaseItem(propName) [ Language = javascript ]
{
	if (propName.indexOf(".") == -1 ) {
		return zenPage._baseItem[propName];
	}
	else {
		var dot = propName.lastIndexOf(".");
		var end = propName.slice(dot + 1);
		var beginning = propName.slice(0,dot);
		return zenPage.getBaseItem(beginning)[end];
	}
}

///  Overrides TablePane method
ClientMethod selectRow(row, scroll, which) [ Language = javascript ]
{
	zenPage.changeRow = (row != this.selectedIndex);
	this.invokeSuper('selectRow',arguments);
}

/// User selected a row in the table
ClientMethod rowUnSelected(table) [ Language = javascript ]
{
	if (!zenPage.changeRow) zenPage.rowSelected(table);
}

/// User selected a row in the table
ClientMethod rowSelected(table) [ Language = javascript ]
{
	if (zenPage.inReselect) return;
	// set flag to compensate for tablePane not reporting selectedId -1 for unselected row
	zenPage.noSel = (table.selectedIndex == -1);
	if ((this.checkEdit) && (zenPage._currItem)) {
		try {
			zenPage.pageModified = zenPage.checkForChanges(zenPage._currItem,'',false);
		}
		catch (ex) {
			zenPage.pageModified = true;
			var conf = $$$FormatText($$$Text("%1  Proceed?"),ex);
		}
		if (zenPage.pageModified) {
			if (!conf) {
				if (zenPage.selectedId == -1) { var conf = $$$Text("Changes made will be lost. Proceed?") }
				else { var conf = $$$FormatText($$$Text("Changes made to agent '%1' properties will be lost. Proceed?"),zenPage.selectedId) }
			}
			if (!confirm(conf)) {
				zenPage.inReselect = true;
				delete table._superContext; // prevent recursion trouble with invokeSuper()
				table.selectRow(zenPage.currRow);
				zenPage.inReselect = false;
				return;
			}
			zenPage.pageModified = false;
		}
	} else {
		zenPage.pageModified = false;
	}
	zenPage.currRow = table.selectedIndex;
	zenPage.selectItem(table);
}

/// populate detailTable for the selected row or no selected row
ClientMethod onSelectItem() [ Language = javascript ]
{
	if (zenPage.noSel) this.selectedId = -1;
	var selected = (this.selectedId != -1);

	var btn = document.getElementById('command_delButton');
	if (btn) {
		btn.className = (!selected ? 'commandButtonDisabled' : 'commandButton');
		btn.title = (!selected ? $$$Text('Please select an agent') : $$$Text('Delete the currently selected agent'));
		//btn.onclick = (!selected ? function() { return false; } : function() { zenPage.expand(); return false; });
	}
	var table=zen('resultsTable')
	var sform = zen('summaryForm');
	var dform = zen('detailsForm');
	if (selected) {
		sform.setProperty('hidden',true);
		dform.setProperty('hidden',false);
		var row = table.getRenderedRowData(table.selectedIndex);
		this.selectedClass=row.Class;
		var parm = zen('regItemId');
		parm.value = this.selectedId
		var json = this.getComponentById('regItem');
		json.reloadContents();
		zenPage._currItem = json.getContentObject();
		zenPage.clientInterfaces(zenPage._currItem.AgentName);
		zenPage._baseItem = zenPage.cloneItem(zenPage._currItem);
		zen('lblAgentName').setProperty('label',zenPage._currItem.AgentName);
		zen('lblAgentAvailability').setProperty('label',zenPage._currItem.Availability);
		zen('gInterfacesList').setContent('');
		zen('ctl_.Options.SA_PollInterval').setValue("");
		zen('ctl_.Options.SA_StayConnected').setValue("");
		if (this.readOnly || !this.checkEdit) {
			zen('ctl_.Options.SA_PollInterval').setProperty('disabled',true);
			zen('ctl_.Options.SA_StayConnected').setProperty('disabled',true);
		}
		this.populateControls(zenPage._currItem, "_");
	} else {
		sform.setProperty('hidden',false);
		dform.setProperty('hidden',true);
		this.selectedClass='';
		zenPage._currItem=null;
	}
	// make sure that the tab content is up to date.
	this.onTabChange();
}

ClientMethod populateControls(obj, propName) [ Language = javascript ]
{
	if (null == obj || "object" != typeof obj) {
		var ctl = zen("ctl"+propName);
		if (ctl) {
			ctl.setValue(obj);
			if (!this.checkEdit) {
				ctl.setProperty('readOnly',true);
				ctl.setProperty('disabled',true);
			}
		}
		return;
	}
	if (propName == "_.Interfaces") {
		this.renderInterfacesTable();
		return;
	}
	// Handle Array
	if (obj instanceof Array) {
		for (var i = 0, len = obj.length; i < len; i++) {
			zenPage.populateControls(obj[i]);
		}
		return;
	}

	// Handle Object
	if (obj instanceof Object) {
		for (var attr in obj) {
			if (obj.hasOwnProperty(attr)) zenPage.populateControls(obj[attr], propName+"."+attr);
		}
		return;
	}
	throw new Error("Unable to populate item due to unsupported property type "+(typeof obj));
}

ClientMethod applyChanges() [ Language = javascript ]
{
	if (this.readOnly || !this.checkEdit) {
		alert(this.msgNotPermitted);
		return false;
	}
	zenPage.saveChanges(zenPage._currItem,'_');
	zenPage.doSearch();
}

ClientMethod saveChanges(obj, propName) [ Language = javascript ]
{
	if (null == obj || "object" != typeof obj) {
		var ctl = zen("ctl"+propName);
		if (ctl) {
			zenPage.saveProperty(zenPage._currItem.AgentName,propName,ctl.getValue());
		}
		return;
	}
	if (propName == "_.Interfaces") {
		zenPage.applyInterfaces();
		return;
	}
	if (propName == "_.Options") {
		zenPage.saveOption(zenPage._currItem.AgentName,'SA_PollInterval',zen('ctl_.Options.SA_PollInterval').getValue());
		zenPage.saveOption(zenPage._currItem.AgentName,'SA_StayConnected',zen('ctl_.Options.SA_StayConnected').getValue());
		return;
	}
	
	// Handle Array
	if (obj instanceof Array) {
		for (var i = 0, len = obj.length; i < len; i++) {
			zenPage.saveChanges(obj[i]);
		}
		return;
	}

	// Handle Object
	if (obj instanceof Object) {
		for (var attr in obj) {
			if (obj.hasOwnProperty(attr)) zenPage.saveChanges(obj[attr], propName+"."+attr);
		}
		return;
	}
	throw new Error("Unable to save item due to unsupported property type "+(typeof obj));
}

ClassMethod saveOption(AgentName, propName, value) As %Status [ ZenMethod ]
{
	Set tSC = $$$OK
	Set agent=##class(EnsLib.Agent.Interface).%OpenId(AgentName_"||0")
	If value'="" { Do agent.Options.SetAt(value,propName) }
	Else { Do agent.Options.RemoveAt(propName) }
	Set tSC = agent.%Save()
	Quit tSC
}

ClassMethod saveProperty(Agent, propName, value) As %Status [ ZenMethod ]
{
	Set tSC = $$$OK
	set propName = $replace($piece(propName,"_.",2),".","_")
	set sql = "UPDATE EnsLib_Agent.Interface ("_propName_") VALUES (?) WHERE AgentName=? AND ClientId=?"
	set statement = ##class(%SQL.Statement).%New()
	set tSC = statement.%Prepare(sql)
	do statement.%Execute(value,Agent,0)
	Quit tSC
}

ClientMethod cloneItem(obj) [ Language = javascript ]
{
	if (null == obj || "object" != typeof obj) return obj;

	// Handle Array
	if (obj instanceof Array) {
		var copy = [];
		for (var i = 0, len = obj.length; i < len; i++) {
			copy[i] = zenPage.cloneItem(obj[i]);
		}
		return copy;
	}

	// Handle Object
	if (obj instanceof Object) {
		var copy = {};
		for (var attr in obj) {
			if (obj.hasOwnProperty(attr)) copy[attr] = zenPage.cloneItem(obj[attr]);
		}
		return copy;
	}
	throw new Error("Unable to copy agent due to unsupported property type "+(typeof obj));
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',[]);
	this.updateSecurityHelper();
	if (zenIsIE) { // avoid IE resize bug
		var results = zen('table');
		if (results) {
			results.packRowsIE = function() { return null; };
		}
	}
	// always execute search here, as initialExecute is false for the table,
	// and we need to ensure that the rest of the page can be loaded
	zenPage.doSearch();
}

/// This callback is called at the end of the HTML HEAD section of the page.<br/>
/// (default implementation is a simple expression).
Method %OnDrawHTMLHead() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	Quit ##class(EnsPortal.Utils).DrawEventInfoStyle()
}

/// Adjust sizes of components on the page.
/// Do this differently for Registry than for other children of EnsPortal.Template.viewerPage (hence the override).
/// In this case the details pane does NOT get large when the search pane is minimized.
ClientMethod onlayoutHandler(load) [ Language = javascript ]
{
	try {
		if (load){
			zenPage.changeRefresh();
		}
		var searchPanel = zen('searchPanel');
		var results = zenPage.getResultsTable();
		var detailsPanel = zen('detailsPanel');
		var divSearchPanel = searchPanel.getEnclosingDiv();
		var divResults = results.getEnclosingDiv();
		var divDetailsPanel = detailsPanel.getEnclosingDiv();
		var divDetailsGroup = zen('detailsGroup').getEnclosingDiv();
		var divSearchGroup = zen('searchGroup').getEnclosingDiv();

		// find size of window
		var winHeight = zenGetWindowHeight();
		var winWidth = zenGetWindowWidth();

		var th = this.getTitleAreaHeight();
		var hgt = winHeight - th;

		//var searchWidth = divSearchPanel.offsetWidth;

		if (((divSearchPanel.scrollHeight) == (divSearchPanel.offsetHeight)) && (divSearchPanel.scrollTop == 0 )) {
			var searchWidth = 255;
		}
		else {
			var searchWidth = 265;
		}

		var detailExpanderWidth = 0;
		var detailExpander = zen('detailExpander');
		if (detailExpander) {
			detailExpanderWidth = detailExpander.getEnclosingDiv().offsetWidth + 10 + (zenIsIE * 12);
		}
		if (!this.detailsHidden) {
			var detailsWidth = parseInt(.36 * winWidth, 10);
			var interfaceTab = zen('gInterfacesList').getEnclosingDiv();
			if (detailsWidth >  Math.max(interfaceTab.offsetWidth + 100, 350)) {
				detailsWidth = Math.max(interfaceTab.offsetWidth + 100, 350);
			}
			else if (detailsWidth < 250) {
				detailsWidth = 250;
			}
			divDetailsGroup.style.width = detailsWidth + 'px';
			divDetailsPanel.style.width = detailsWidth - detailExpanderWidth - 15 - (zenIsIE * 5) + 'px';
		}
		else {
			var arrow = document.getElementById('detailExpanderArrow');
			arrow.innerHTML = '&#171;';
			detailsPanel.setHidden(true);
			divDetailsGroup.style.width = detailExpanderWidth + 'px';
		}

		var searchExpanderWidth = 0;
		var searchExpander = zen('searchExpander');
		if (searchExpander) {
			searchExpanderWidth = searchExpander.getEnclosingDiv().offsetWidth + 10 + (zenIsIE * 12);
		}

		if (!this.searchHidden) {
			var innerSearchWidth = searchWidth;
			divSearchGroup.style.width = innerSearchWidth + searchExpanderWidth + 15 + (zenIsIE * 5) + 'px';
			divSearchPanel.style.width = innerSearchWidth + 'px';
		}
		else {
			var arrow = document.getElementById('searchExpanderArrow');
			arrow.innerHTML = '&#187;';
			searchPanel.setHidden(true);
			divSearchGroup.style.width = searchExpanderWidth + 'px';
		}

		var resultsWidth = winWidth - divSearchGroup.offsetWidth - divDetailsGroup.offsetWidth;
		resultsWidth = (resultsWidth <= 0 ? 1 : resultsWidth);
		var extraResults = 0;
		divResults.style.width = resultsWidth + extraResults + 'px';

		if (!(((zenBody.scrollWidth) == (zenBody.offsetWidth)) && (zenBody.scrollLeft == 0))) {
			var resultsWidth = zenBody.scrollWidth - divSearchGroup.offsetWidth - divDetailsGroup.offsetWidth;
			resultsWidth = (resultsWidth <= 0 ? 1 : resultsWidth);
			divResults.style.width = resultsWidth + 'px';

			var hgt = hgt - 20;
		}

		divResults.style.height = hgt + 'px';
		divSearchPanel.style.height = hgt + 'px';
		divDetailsPanel.style.height = (hgt - 35) + 'px';
		divDetailsGroup.style.height = hgt + 'px';
		divSearchGroup.style.height = hgt + 'px';

		this.layoutTabGroup();
		this.updatePageNumber();
		this.adjustExpanderText();

		if (load) { // ensure we update the navigation buttons after first load
			this.updateNavigationButtons();
		}
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in onlayoutHandler.');
	}
}

Query Enumerate(ByRef pWhere, ByRef pSortBy, ByRef pDescend) As %Query(CONTAINID = 2, ROWSPEC = "ID:%String,Name:%String,ConfigName:%String,LastInvocation:%String,Status:%String,Description:%String,Outbound:%Integer,Inbound:%Integer")
{
}

ClassMethod EnumerateExecute(ByRef qHandle As %Binary, ByRef pWhere, ByRef pSortBy, ByRef pDescend) As %Status
{
	Set tSC = $$$OK
	Set tWhere=" WHERE ClientId = 0"
	Set:$G(pWhere)'="" tWhere=tWhere_" AND "_pWhere
	Set tSort = $G(pSortBy) 
	Set:((tSort="")||(tSort = "LastInvocation") || (tSort = "Status")) tSort = "AgentName"
	Set tOrder=" ORDER BY %SQLUPPER("_tSort_")"
	Set tDesc=$S($G(pDescend):" DESC", 1:"")
	
	Set tRS=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Set tRS.RuntimeMode = 0
	Set tSC=tRS.Prepare("SELECT ID,AgentName,ConfigItem,Description,Availability FROM EnsLib_Agent.Interface"_tWhere_tOrder_tDesc)  Quit:$$$ISERR(tSC) tSC
	Set tSC=tRS.Execute()  Quit:$$$ISERR(tSC) tSC
	Set qHandle("rs")=tRS
	If (($G(pSortBy) = "LastInvocation") || ($G(pSortBy) = "Status")) {
		Set qHandle("Sort") = pSortBy
		Set qHandle("Desc") = $S($G(pDescend,0):-1,1:1)
		Set qHandle("Fetched") = 0
	}
	Quit tSC
}

ClassMethod EnumerateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EnumerateExecute ]
{
	Set tSC = $$$OK
	If $G(qHandle("Sort")) '= "" {
		If 'qHandle("Fetched") {
			Do {
				Set Row = ""
				Set tSC = ..InitEnumerateFetch(.qHandle,.Row,.AtEnd)
				If $G(Row)'="" {
					Set num = 5
					Set:(qHandle("Sort") = "LastInvocation") num = 4
					If ($LG(Row,num)'="") {
						Set qHandle("Row", $LG(Row,num), $LG(Row,2)) = Row
					}
					Else {
						Set qHandle("Row"," ",$LG(Row,2)) = Row
					}
				}
			} While ($G(Row)'="")
			Set qHandle("Fetched") = 1
			Set AtEnd = 0
		}
		Set dir = qHandle("Desc")
		Set sort = $o(qHandle("Row",""),dir)
		If (sort = "") {
			Set AtEnd = 1
		}
		Else {
			Set name = $o(qHandle("Row",sort,""),dir)
			Set Row = qHandle("Row",sort,name)
			k qHandle("Row",sort,name)
		}
	}
	Else {
		Set tSC = ..InitEnumerateFetch(.qHandle, .Row, .AtEnd)
	}
	Quit tSC
}

ClassMethod InitEnumerateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
 // Version,Interface,Invoked,Status,
	Set tSC = $$$OK, tRS=$G(qHandle("rs"))
	If tRS.Next(.tSC) { Quit:$$$ISERR(tSC) tSC
		Set tName=tRS.Data("AgentName")
		Set tID=tName_"||", (tInbound,tOutbound,tStatus)=""
		&sql(SELECT TOP 1 Status,EventTime INTO:tStatus,:tEventTime FROM EnsLib_Agent.StatusEvent WHERE Interface %StartsWith :tID ORDER BY ID DESC)
		Set:SQLCODE (tStatus,tEventTime)=""

		&sql(SELECT Count(*) INTO:tOutbound FROM EnsLib_Agent.Interface WHERE AgentName = :tName AND Type IN ('File_Drop,TCP_Connect'))
		Set:SQLCODE tOutbound=""

		&sql(SELECT Count(*) INTO:tInbound FROM EnsLib_Agent.Interface WHERE AgentName = :tName AND Type IN ('File_Pick,TCP_Listen'))
		Set:SQLCODE tInbound=""
		// ID:%String,Name:%String,ConfigName:%String,LastInvocation:%String,Status:%String,Description:%String,Outbound:%Integer,Inbound:%Integer
		Set tStatus = ..DisplayStatus(tStatus)
		Set Row = $lb(tRS.Data("ID"),tName,tRS.Data("ConfigItem"),tEventTime,tStatus,tRS.Data("Description"),tOutbound,tInbound)
	}
	Quit tSC
}

ClassMethod EnumerateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EnumerateExecute ]
{
	Kill qHandle
	Quit $$$OK
}

ClassMethod DisplayStatus(status As %Integer) As %String
{
	set text = $Case(status,
		$$$SkorpStatusSAStartError:$$$Text("Agent Start Error"),
		$$$SkorpStatusSATerminated:$$$Text("Agent Terminated"),
		$$$SkorpStatusTLStarted:$$$Text("TCP Listener Started"),
		$$$SkorpStatusTLStopped:$$$Text("TCP Listener Stopped"),
		$$$SkorpStatusTLConnEvent:$$$Text("TCP Listener Connection Event"),
		$$$SkorpStatusTLConnLost:$$$Text("TCP Listener Connection Lost"),
		$$$SkorpStatusTLConnClosed:$$$Text("TCP Listener Connection Closed"),
		$$$SkorpStatusTLStartError:$$$Text("TCP Listener Start Error"),
		$$$SkorpStatusTCStarted:$$$Text("TCP Outbound Started"),
		$$$SkorpStatusTCStopped:$$$Text("TCP Outbound Stopped"),
		$$$SkorpStatusTCConnOpened:$$$Text("TCP Outbound Connection Opened"),
		$$$SkorpStatusTCConnLost:$$$Text("TCP Outbound Connection Lost"),
		$$$SkorpStatusTCConnClosed:$$$Text("TCP Outbound Connection Closed"),
		$$$SkorpStatusTCConnError:$$$Text("TCP Outbound Connection Error"),
		$$$SkorpStatusTCDataSendOK:$$$Text("TCP Outbound Data Send OK"),
		$$$SkorpStatusFPStarted:$$$Text("File Listener Started"),
		$$$SkorpStatusFPStopped:$$$Text("File Listener Stopped"),
		$$$SkorpStatusFPStartError:$$$Text("File Listener Start Error"),
		$$$SkorpEStatusFPAcceptOK:$$$Text("File Pick Accept OK"),
		$$$SkorpEStatusFPAcceptFailed:$$$Text("File Pick Accept Failed"),
		$$$SkorpStatusFDStarted:$$$Text("File Depositor Started"),
		$$$SkorpStatusFDStopped:$$$Text("File Depositor Stopped"),
		$$$SkorpStatusFDStartError:$$$Text("File Depositor Start Error"),
		$$$SkorpStatusFDSuccess:$$$Text("File Drop Success"),
		$$$SkorpStatusFDError:$$$Text("File Drop Error"),
		:status)
	Quit text
}

/// Delete the given Interface.
ClientMethod deleteInterface(key) [ Language = javascript ]
{
	var conf = $$$FormatText($$$Text("Are you sure you want to delete client interface '%1'?"),key);
	if (confirm(conf)) {
		delete zenPage._currItem.Interfaces[key];
		this.renderInterfacesTable();
	}
}

/// Launch the Interface properties dialog.
ClientMethod editInterface(key) [ Language = javascript ]
{
	if ((key == '') && (this.readOnly || !this.checkEdit)) {
		alert(this.msgNotPermitted);
		return false;
	}
	var model = zenPage._currItem;
	var intr = null;
	if (key != '' && model && model.Interfaces) {
		intr = model.Interfaces[key];
	}

	var parms = {
		READONLY: (this.readOnly || !this.checkEdit)?1:0,
		ID:key,
		NAME:model.AgentName,
	};
	var url = zenLink('EnsPortal.Dialog.AgentInterface.zen',this.studioMode);
	zenLaunchPopupWindow(url,this.addPopupSuffix('AgentInterface'),'status,scrollbars,resizable=yes,width=500,height=600',parms);
}

/// Return boolean = true if client Interfaces have changed since opening the current item
ClientMethod changedInterfaces() [ Language = javascript ]
{
	var changed = false;
	var model = zenPage._baseItem;
	var current = zenPage._currItem;
	if ((model) && (current)) {
		if ((model.Interfaces) && (current.Interfaces)) {
			for (var key in model.Interfaces) {
				if (changed==true) break;
				if (current.Interfaces[key]) {
					var prop = model.Interfaces[key];
					var curr = current.Interfaces[key];
					if ((zenGet(prop.description).toString()) != (zenGet(curr.description).toString())) { changed = true; break; }
					if ((zenGet(prop.type).toString()) != (zenGet(curr.type).toString())) { changed = true; break; }
					if ((zenGet(prop.location).toString()) != (zenGet(curr.location).toString())) { changed = true; break; }
					if ((zenGet(prop.configItem).toString()) != (zenGet(curr.configItem).toString())) { changed = true; break; }
					if ((zenGet(prop.configTimeout).toString()) != (zenGet(curr.configTimeout).toString())) { changed = true; break; }
					if ((zenGet(prop.relayPort).toString()) != (zenGet(curr.relayPort).toString())) { changed = true; break; }
					if ((zenGet(prop.notes).toString()) != (zenGet(curr.notes).toString())) { changed = true; break; }
					if ((zenGet(prop.credential).toString()) != (zenGet(curr.credential).toString())) { changed = true; break; }
					for (var opt in prop.options) {
						if (!(curr.options.hasOwnProperty(opt))) { changed = true; break; }
						if ((zenGet(prop.options[opt]).toString()) != (zenGet(curr.options[opt]).toString())) { changed = true; break; }
					}
					for (var opt in curr.options) {
						if (!(prop.options.hasOwnProperty(opt))) { changed = true; break; }
					}
				}
				else if (typeof model.Interfaces[key] == "object") {
					changed = true;
					break;
				}
			}
			for (var key in current.Interfaces) {
				if (!model.Interfaces[key]) {
					changed = true;
					break;
				}
			}
		}
		else {
			throw new Error($$$Text("Unable to confirm whether or not changes have been made to the current agent due to a problem loading the agent's interfaces."));
		}
	}
	else {
		throw new Error($$$Text("Unable to confirm whether or not changes have been made to the current agent due to a problem loading the agent."));
	}
	return changed;
}

Method clientInterfaces(name) As %Status [ ZenMethod ]
{
	set tSC = ..getClientInterfaces(name, .Interfaces)
	Quit:$$$ISERR(tSC)
	&js<zenPage._currItem.Interfaces = new Array();>
	set k=""
	for {
		set k = $o(Interfaces(k))
		Quit:""=k
		&js<zenPage._currItem.Interfaces[#(k)#] = new Object();>
		&js<zenPage._currItem.Interfaces[#(k)#].options = new Object();>
		set prop = ""
		for {
			set prop = $o(Interfaces(k,prop))
			quit:""=prop
			set setProp = "zenPage._currItem.Interfaces["_k_"]."_prop_"='"_Interfaces(k,prop)_"';"
			&js<#(setProp)#>
		}
	}
	Quit tSC
}

ClassMethod getClientInterfaces(name As %String, ByRef Interfaces) As %Status
{
	set tSC = $$$OK
	set statement = ##class(%SQL.Statement).%New()
	set tSC = statement.%Prepare("SELECT * FROM EnsLib_Agent.Interface WHERE AgentName = '"_name_"' AND ClientId <> 0 ORDER BY ClientId") 
	Set tRS = statement.%Execute() Quit:$$$ISERR(tSC) tSC
	While tRS.%Next(.tSC) {
		Quit:$$$ISERR(tSC)
		set Interfaces(tRS.%Get("ClientId"),"type") =  tRS.%Get("Type")
		set Interfaces(tRS.%Get("ClientId"),"description") =  $zcvt(tRS.%Get("Description"),"O","JS")
		set Interfaces(tRS.%Get("ClientId"),"location") =  $zcvt(tRS.%Get("Location"),"O","JS")
		set Interfaces(tRS.%Get("ClientId"),"configItem") = $zcvt(tRS.%Get("ConfigItem"),"O","JS")
		set Interfaces(tRS.%Get("ClientId"),"credential") =  $zcvt(tRS.%Get("Credential"),"O","JS")
		set Interfaces(tRS.%Get("ClientId"),"notes") =  $zcvt(tRS.%Get("Notes"),"O","JS")
		set Interfaces(tRS.%Get("ClientId"),"availability") =  $zcvt(tRS.%Get("Availability"),"O","JS")
		set Interfaces(tRS.%Get("ClientId"),"relayPort") =  $zcvt(tRS.%Get("RelayPort"),"O","JS")
		set Interfaces(tRS.%Get("ClientId"),"configTimeout") =  $zcvt(tRS.%Get("ConfigTimeout"),"O","JS")
		set intr = ##class(EnsLib.Agent.Interface).%OpenId(name_"||"_tRS.%Get("ClientId"))
		set k=""
		For {
			Do intr.Options.GetNext(.k)
			quit:k=""
			set Interfaces(tRS.%Get("ClientId"),"options."_k)=$zcvt(intr.Options.GetAt(k),"O","JS")
		}
	}
	Quit tSC
}

/// Update the contents of the Interfaces table.
ClientMethod renderInterfacesTable() [ Language = javascript ]
{
	var table = zen('gInterfacesList');
	var html = [];

	var model = zenPage._currItem;
	if (model) {
		html.push('<table class="propListTable" border="0" cellspacing="0">');
		html.push('<tr>');
		html.push('<th>' + '&nbsp;' + '</th>');
		html.push('<th>' + $$$Text('ID') + '&nbsp;'+ '</th>');
		html.push('<th>' + $$$Text('Type') + '</th>');
		html.push('<th>' + $$$Text('Config Item') + '</th>');
		html.push('<th>' + $$$Text('Location') + '</th>');
		html.push('<th>' + $$$Text('Availability') + '&nbsp;&nbsp;</th>');
		html.push('</tr>');
		if (model.Interfaces) {
			var n = 0;
			for (var key in model.Interfaces) {
				var prop = model.Interfaces[key];

				html.push('<tr class="'+((n%2)?'rowOdd':'rowEven')+'" title="'+zenEscapeHTML(zenGet(prop.Address))+'">');
				html.push('<td nowrap>');
				html.push('<image title="'+$$$Text('Edit this Interface')+'" src="deepsee/notepad_16.png"  onclick="zenPage.editInterface(\''+key+'\');"/>');
				html.push('<image title="'+$$$Text('Delete this Interface')+'" src="deepsee/close_a_16.gif" onclick="' + ((this.checkEdit && !this.readOnly) ? 'zenPage.deleteInterface(\''+key+'\');' : 'alert(zenPage.msgNotPermitted);') + '"/>');
				html.push('</td>');
				html.push('<td>' + zenEscapeHTML(key) + '&nbsp;&nbsp;</td>');
				html.push('<td>' + zenEscapeHTML(zenGet(prop.type)) + '&nbsp;</td>');
				html.push('<td>' + zenEscapeHTML(zenGet(prop.configItem)) + '&nbsp;</td>');
				html.push('<td>' + zenEscapeHTML(zenGet(prop.location)) + '&nbsp;</td>');
				html.push('<td>' + zenEscapeHTML(zenGet(prop.availability)) + '&nbsp;</td>');
				html.push('</tr>');
				n = n + 1;
			}
		} else {
			html.push('<tr class="rowEven">');
			html.push('<td colspan="4"><i>' + $$$Text('No Interfaces defined') + '</i></td>');
			html.push('</tr>');
		}
		html.push('</table>');
	}
	table.setContent(html.join(''));
}

ClientMethod applyInterfaces() [ Language = javascript ]
{
	var model = zenPage._currItem;
	if (model) {
		if (model.Interfaces) {
			//var old = zenSynchronousMode;
			//zenSynchronousMode = true;
			var sync = zenPage.deleteAgentInterfaces(model.AgentName);
			for (var key in model.Interfaces) {
				var prop = model.Interfaces[key];
				var options='';
				for (opt in prop.options) {
					options = options+'^'+opt+'='+prop.options[opt];
				}
				var status = zenPage.saveInterface(model.AgentName,key,prop.description,prop.type,prop.location,prop.configItem,prop.configTimeout,prop.relayPort,prop.notes,prop.credential,prop.availability,options);
				if (status != '') { alert(status); }
			}
			//zenSynchronousMode = old;
		}
	}
}

ClassMethod deleteAgentInterfaces(tName) As %Boolean [ ZenMethod ]
{
	&sql(DELETE from EnsLib_Agent.Interface WHERE AgentName = :tName AND ClientId <> 0)
	Quit 1
}

ClassMethod saveInterface(Name, ID, Description = "", Type, Location = "", Config = "", Timeout = "", Port = "", Notes = "", Credential = "", Availability = "", Options = "") As %String [ ZenMethod ]
{
	Set tSC = $$$OK
	Set msg = ""
	set Interface = ##class(EnsLib.Agent.Interface).%New()
	set Interface.AgentName = Name
	set Interface.ClientId = ID
	set Interface.Description = Description
	set Interface.Type = Type
	set Interface.Location = Location
	set Interface.ConfigItem = Config
	set Interface.ConfigTimeout = Timeout
	set Interface.RelayPort = Port
	set Interface.Notes = Notes
	set Interface.Credential = Credential
	Set Interface.Availability = Availability
	Do Interface.Options.Clear()
	for i=2:1:$l(Options,"^") {
		Set opt = $p(Options,"^",i)
		Do Interface.Options.SetAt($p(opt,"=",2,$l(opt,"=")),$p(opt,"=",1))
	}
	Set tSC = Interface.%Save()
	Set:$$$ISERR(tSC) msg = $$$StatusDisplayString(tSC)
	Quit msg
}

ClassMethod GetRegItem(ByRef pParms, Output pObject As %RegisteredObject) As %Status
{
	// create object for client's current row details
	Set tItemId = $G(pParms("regItemId"))
	Quit:tItemId=-1 $$$OK
	Set pObject=$classmethod("EnsLib.Agent.Interface","%OpenId",tItemId,,.tSC)  Quit:$$$ISERR(tSC) tSC
	Quit tSC
}

/// Object submit handler JSON provider.
/// This is called when the client submits the DTL definition.
ClassMethod SubmitRegItem(pCommand As %String, pProvider As %ZEN.Auxiliary.jsonProvider, pSubmitObject As EnsLib.Agent.Interface, Output pResponseObject As %RegisteredObject) As %Status
{
	// pSubmitObject is the current agent
	Set tSC = $$$OK
	If (pCommand = "save") || (pCommand = "forcesave") {
		Set tID=pSubmitObject.%Id()
		If (pCommand = "save") {
			Set tRealItem=pSubmitObject.%OpenId(tID,,.tSC)  Quit:$$$ISERR(tSC) tSC
			Set tSC=..UpdateObj(tRealItem,pSubmitObject)  Quit:$$$ISERR(tSC) tSC
		}
		Set tSC=tRealItem.%Save()  Quit:$$$ISERR(tSC) tSC
		Set pResponseObject = tRealItem
	}
	Quit tSC
}

ClassMethod UpdateObj(pSrc As EnsLib.Agent.Interface, pTarg As EnsLib.Agent.Interface) As %Status
{
	Quit $$$OK
}

ClientMethod onunloadHandler() [ Language = javascript ]
{
	if ((!this._inLogout) && (this.checkEdit) && (zenPage._currItem)) {
		try {
			this.pageModified = zenPage.checkForChanges(zenPage._currItem,'',false);
		} catch (ex) {
			return ex.toString();
		}
		if (this.pageModified) {
			if (this.currItem == -1) { return $$$Text("Changes made will be lost if you leave this page."); }
			else { return $$$FormatText($$$Text("Changes made to agent '%1' will be lost if you leave this page."),zenPage.selectedId); }
		}
	}
	return true;
}

/// This client method, if defined and the AUTOLOGOUT parameter for this
/// page is true, is invoked when the logout timer for this
/// page fires.<br/>
/// If this method return true then the normal page logout behavior will fire.
/// That is, the page will be reloaded causing a login page to appear if the
/// current session has ended.
ClientMethod onlogoutHandler() [ Language = javascript ]
{
	// Ensure that auto-logout is not blocked by onunloadHandler. Modifying pageModified doesn't work here because onunloadHandler resets it. 
	this._inLogout = true;
	return true;
}

/// To display a custom message, override logout() and do the unload check ourselves.
ClientMethod logout() [ Language = javascript ]
{
	if ((this.checkEdit) && (zenPage._currItem)) {
		try {
			this.pageModified = zenPage.checkForChanges(zenPage._currItem,'',false);
		}
		catch (ex) {
			this.pageModified = true;
		}
		if (this.pageModified) {
			if (this.currItem == -1) { var msg = $$$Text("Changes made to the Agent settings will be lost.\n\nDo you want to log out and lose these changes?"); }
			else { var msg = $$$FormatText($$$Text("Changes made to Agent '%1' settings will be lost.\n\nDo you want to log out and lose these changes?"),zenPage.selectedId); }
			if (!confirm(msg)) return false;
		}
	}
	this._inLogout = true;
	this.pageModified = false; // make sure super doesn't ask again
	this.invokeSuper('logout',null);
	return true;
}

ClientMethod beginExport(pId) [ Language = javascript ]
{
	if (this.readOnly || !this.checkEdit) {
		alert(this.msgNotPermitted);
		return false;
	}
	var file = zenPage.GetDefaultFilename(pId);
	zenPage.selectFilepath('true', file);
}

Method doExport(pId, pFile, pWhere, pSortBy, pDescend) [ ZenMethod ]
{
	set exp = ..Export(pId,pFile,pWhere,pSortBy,pDescend)
	&js<alert('#($zcvt(exp,"O","JS"))#');>
}

ClassMethod Export(pId As %Integer = -1, pFile As %String = "", pWhere, pSortBy, pDescend) As %String
{
	Set tSC = $$$OK
	Set tMsg = ""
	Try {
		//make sure we can open the file
		Open pFile:"NWU":0 Else  Set tSC = $$$ERROR($$$GeneralError,"Unable to open file: "_pFile) Quit
		Close pFile
		Set tWriter = ##class(%XML.Writer).%New()
		Set tWriter.Indent = 1
		Set tSC = tWriter.OutputToFile(pFile)
		If $$$ISERR(tSC) Quit
		If pId = -1 {
			Set tSC = tWriter.RootElement("Agents")
			Set tInfo=##class(%ZEN.Auxiliary.QueryInfo).%New()
			Set tRS=..GetResultSet(pWhere,pSortBy,pDescend,.tSC,tInfo)
			If $$$ISOK(tSC) {
				Set tCount=0
				While tRS.Next(.tSC) && $$$ISOK(tSC) && (tCount<tInfo.rows) {
					Set tCount=tCount+1
					Set tName=tRS.Data("Name")
					Set tItem = ##class(EnsLib.Agent.Interface).%OpenId(tName_"||0")
					Set tSC = tWriter.Object(tItem)
					If $$$ISERR(tSC) { Quit }
					Else { 
						Set tCount("Agents") =  $I(tCount("Agents")) 
						set query = "SELECT * FROM EnsLib_Agent.Interface WHERE AgentName = '"_tName_"' AND ClientId<>0"
						set tStatement = ##class(%SQL.Statement).%New()
						set tSC = tStatement.%Prepare(query)
						set rset = tStatement.%Execute()
						While rset.%Next(.tSC) && $$$ISOK(tSC) {
							Set tCount=tCount+1
							Set tID = rset.%Get("ID")
							Set tClient = ##class(EnsLib.Agent.Interface).%OpenId(tID)
							Set tSC = tWriter.Object(tClient)
							If $$$ISERR(tSC) {Quit}
							Else {Set tCount("Interfaces") = $I(tCount("Interfaces"))}
						}
					}
				}
			}
			Set tMsg="Exported "_$G(tCount("Agents"),0)_" Agents, "_$G(tCount("Interfaces"),0)_" Client Interfaces to "_pFile
			Set tSC = tWriter.EndRootElement()
			Set tSC = tWriter.EndDocument()
		}
		Else {
			Set tItem = ##class(EnsLib.Agent.Interface).%OpenId(pId)
			If '$IsObject(tItem) {
				Set tSC = $$$ERROR($$$GeneralError,"Error in export of Agent "_pId)
				Quit
			}
			Set tSC = tWriter.StartDocument()
			If $$$ISERR(tSC) Quit
			Set tSC = tWriter.RootElement(tItem.AgentName)
			Set tSC = tWriter.Object(tItem)
			If $$$ISERR(tSC) Quit
			set query = "SELECT * FROM EnsLib_Agent.Interface WHERE AgentName = '"_tItem.AgentName_"' AND ClientId<>0"
			set tStatement = ##class(%SQL.Statement).%New()
			set tSC = tStatement.%Prepare(query)
			set rset = tStatement.%Execute()
			set tCount = 0
			While rset.%Next(.tSC) && $$$ISOK(tSC) {
				Set tCount=$I(tCount)
				Set tID = rset.%Get("ID")
				Set tClient = ##class(EnsLib.Agent.Interface).%OpenId(tID)
				Set tSC = tWriter.Object(tClient)
				If $$$ISERR(tSC) {Quit}
			}
			Quit:$$$ISERR(tSC)
			Set tSC = tWriter.EndRootElement()
			Set tSC = tWriter.EndDocument()
			Quit:$$$ISERR(tSC)
			Set tMsg="Exported "_$p(pId,"||",1)_$S(tCount>0:" and "_tCount_" Client Interfaces",1:"")_" to "_pFile
		}
	} Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Set:$$$ISERR(tSC) tMsg="Error in export : "_$$$StatusDisplayString(tSC)
	Quit tMsg
}

ClientMethod beginImport() [ Language = javascript ]
{
	if (this.readOnly || !this.checkEdit) {
		alert(this.msgNotPermitted);
		return false;
	}
	zenPage.selectFilepath('false','');
}

Method setupImport(pFile) [ ZenMethod ]
{
	Set tMsg = ..findConflicts(pFile)
	If tMsg'="" {
		&js<alert('#($zcvt(tMsg,"O","JS"))#');>
	}
	Else {
		&js<zenPage.resolveImportConflicts('#($zcvt(pFile,"O","JS"))#');>
	}
}

/// on first pass through the import file, tabulate types of conflicts for each item
ClassMethod findConflicts(pFile As %String) As %String
{

	Set tSC = $$$OK
	kill ^IRIS.Temp.EnsPortal($UserName,"Skorpius","ImportConflicts")
	Set tMsg = ""
	Try {
		// Create an instance of %XML.Reader
		Set tReader = ##class(%XML.Reader).%New()

		// Begin processing of the file
		Set tSC = tReader.OpenFile(pFile)
		If $$$ISERR(tSC) Quit

		Do tReader.Correlate("Interface","EnsLib.Agent.Interface")

		// Read objects from xml file
		While (tReader.Next(.tItem,.tSC)) {
			Quit:$$$ISERR(tSC)
			Set tName = tItem.AgentName
			Set tID = tItem.ClientId
			Set tType = tItem.Type
			Set tConfigItem = tItem.ConfigItem
			&sql(SELECT ClientId INTO :tOldId FROM EnsLib_Agent.Interface WHERE AgentName=:tName AND Type=:tType AND ConfigItem=:tConfigItem)
			If SQLCODE=100 {
				// no conflicts
				Set Conflicts(tName,tID)="None^"_tType_"^"_tConfigItem
			}
			Elseif 'SQLCODE {
				// same info already exists in registry
				Set Conflicts(tName,tID)=tOldId
			}
			Else {
				Set tMsg="Error checking records for agent '"_tName_"': SQLCODE="_SQLCODE
				Quit
			}
		}
		merge ^IRIS.Temp.EnsPortal($UserName,"Skorpius","ImportConflicts") = Conflicts

	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Set:$$$ISERR(tSC) tMsg="Error in import : "_$$$StatusDisplayString(tSC)
	Quit tMsg
}

ClientMethod resolveImportConflicts(fileName As %String) [ Language = javascript ]
{
	parms = {
		File: fileName
	}
	zenPage.launchPopupWindow(
	zenLink('EnsPortal.Dialog.ImportAgents.zen'),
	this.addPopupSuffix('importSelect'),
	'status,scrollbars,resizable,top=10,left=10,width=755,height=700',parms);
}

Method doImport(value As %List) [ ZenMethod ]
{
	set pFile = $p(value,",",1)
	For i=2:1:$length(value,",")
	{
		set listItem = $p(value,",",i)
		CONTINUE:listItem=""
		set agent = $p(listItem,"^",2)
		set items(agent) = $p(listItem,"^",1)
	}
	Set tMsg = ..Overwrite(pFile, .tCount, .items)
	Set tMsg = $S(tMsg="":"",1:tMsg_$C(13,10))_"Imported "_$G(tCount("Agent"),0)_" Agents, "_$G(tCount("Client"),0)_" Client Interfaces"
	&js<alert('#($zcvt(tMsg,"O","JS"))#');>
	&js<zenPage.doSearch();>
}

/// each node in array should be items(agentName)=existance
ClassMethod Overwrite(pFile As %String, ByRef pCount, ByRef items) As %String
{
	Set tSC = $$$OK
	Set tMsg = ""
	Try {
		TStart
		Set tAgent = ""
		For {
			Set tAgent = $o(items(tAgent))
			Quit:tAgent=""
			If ((items(tAgent)="clear") || (items(tAgent)="clearClients")) {
				&sql(DELETE FROM EnsLib_Agent.Interface WHERE AgentName=:tAgent AND ClientId<>0)
				If SQLCODE { 
					Set tSC=$$$ERROR($$$EnsErrGeneral,"SQL Error deleting agent: SQLCODE="_SQLCODE_" / "_$G(%msg))
					Quit 
				}
				If items(tAgent)="clear" {
					Set tSC = ##class(EnsLib.Agent.Interface).%DeleteId(tAgent_"||0")
					Quit:$$$ISERR(tSC)
				}
			}
			Elseif items(tAgent)="create" {
				Set agent = ##class(EnsLib.Agent.Interface).%New()
				Set agent.AgentName = tName
				Set agent.ClientId = 0
				Set tSC = agent.%Save()
				Quit:$$$ISERR(tSC)
				Set pCount("Agent") = $I(pCount("Agent"))
			}
		}
		Quit:$$$ISERR(tSC)
		// Create an instance of %XML.Reader
		Set tReader = ##class(%XML.Reader).%New()

		// Begin processing of the file
		Set tSC = tReader.OpenFile(pFile)
		If $$$ISERR(tSC) Quit

		Do tReader.Correlate("Interface","EnsLib.Agent.Interface")

		// Read objects from xml file
		While (tReader.Next(.tItem,.tSC)) {
			Quit:$$$ISERR(tSC)
			CONTINUE:($D(items(tItem.AgentName))'=1)
			Set tSC = tItem.%Save()
			Quit:$$$ISERR(tSC)
			If tItem.ClientId=0 Set pCount("Agent") = $I(pCount("Agent"))
			Else  Set pCount("Client") = $I(pCount("Client"))
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	If $$$ISERR(tSC) {
		TRollback
		Set tMsg="Error in import : "_$$$StatusDisplayString(tSC)
	}
	Else {
		TCommit
	}
	Quit tMsg
}

ClientMethod selectFilepath(exp As %Boolean, fileName As %String) [ Language = javascript ]
{
	if (!this.canViewFileSystem) {
		alert(this.msgNotPermitted);
		return false;
	}
	var popSuff = (exp=='true')?"selectExportFilepath":"selectImportFilepath";
	parms = {
		wildcard:'*.xml',
		Dir:zenPage.GetDefaultDir(),
		File:fileName
	}
	zenPage.launchPopupWindow(
	zenLink('%ZEN.Dialog.fileSelect.zen',this.studioMode),
	this.addPopupSuffix(popSuff),
	'status,scrollbars,resizable,width=660,height=700,modal=no',
	parms);
}

ClassMethod GetDefaultDir() As %String [ ZenMethod ]
{
	Quit $G(^EnsPortal.Settings($USERNAME, "ImportExportDir"))
}

ClassMethod GetDefaultFilename(pId As %Integer) As %String [ ZenMethod ]
{
	Quit "Export-"_$S(pId=-1:"DisplayedAgents",1:"Agent"_$p(pId,"||",1))_"-"_$ZStrip($ZDT($H,8),"*PC")_".xml"
}

ClassMethod FileExists(filename As %String) As %String [ ZenMethod ]
{
	Quit ##class(%File).Exists(filename)
}

ClassMethod SetDefaultDir(pPathname As %String) [ ZenMethod ]
{
	Set ^EnsPortal.Settings($USERNAME, "ImportExportDir") = ##class(%File).GetDirectory(pPathname, 1)
}

ClientMethod updateSecurityHelper() [ Language = javascript ]
{
	this.checkEdit = zenPage.GetSecurityHelper();
	return true;
}

ClassMethod GetSecurityHelper() As %Boolean [ ZenMethod ]
{
	Quit $system.Security.Check($p(..#EDITRESOURCE,":",1), $p(..#EDITRESOURCE,":",2))
}

/// Callback to return a list of resources required for a specific HyperEvent.
/// The user must have sufficient privileges on one of the resource/permission pairs
/// to be permitted to execute the hyperevent. An empty string implies the user already
/// has sufficient privileges for the ZenMethod specified in <var>pMethod</var>.
ClassMethod GetHyperEventResources(pMethod As %String = "") As %String
{
	Quit $case(pMethod,
				"DeleteItem": ..#EDITRESOURCE,
				"PurgeSelectedItems": ..#EDITRESOURCE,
				"PublishService": ..#EDITRESOURCE,
				"doExport": ..#EDITRESOURCE,
				"setupImport": ..#EDITRESOURCE,
				: "")
}

}
