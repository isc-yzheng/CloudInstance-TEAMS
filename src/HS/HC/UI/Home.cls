Include (%sySystem, HS.HC.UI.Home, %ZHSLIB)

/// Home page for the HealthShare Management Portal.
Class HS.HC.UI.Home Extends HS.UI.Base
{

/// Home favorite icon.
Parameter FAVORITEICON As COSEXPRESSION = "$$$ISCFAVORITEICON";

/// Set this to the appropriate application class.
Parameter APPLICATION = "HS.UI.Application";

/// Set this to the correct domain.
Parameter DOMAIN = "HS";

/// Name of this page.
Parameter PAGENAME = "HealthShare Home";

/// If true, register visits to this page in the recent list.
Parameter RECENT = 0;

/// If true, auto-switch namespace to whatever $NAMESPACE is passed in.
Parameter AUTONS As BOOLEAN = 0;

/// URL of home page (used in links).
Parameter HOMEPAGE = "/csp/sys/%25CSP.Portal.Home.zen";

/// If true, show the Namespace dropdown.
Parameter SHOWNAMESPACE As BOOLEAN = 1;

/// If this page has multiple views, this is its initial display mode.
Parameter DEFAULTVIEWMODE = "columns";

/// If this page has sort options, this is its initial sort mode.
Parameter DEFAULTSORTMODE = "name";

/// Product home page URL with "home" value
Property homePage As %ZEN.Datatype.string [ InitialExpression = {$S($IsObject($G(%request)):%request.URLPrefix, 1:"")_..#HOMEPAGE} ];

/// About page URL
Property aboutPage As %ZEN.Datatype.string;

/// For pages with steps, this is the current step (1-based).
Property currStep As %ZEN.Datatype.integer [ InitialExpression = 1 ];

/// If this page has "views", this is the current view type.
Property currViewMode As %ZEN.Datatype.string [ InitialExpression = {..#DEFAULTVIEWMODE} ];

/// Current sort mode for this page (if applicable).
Property currSortMode As %ZEN.Datatype.string [ InitialExpression = {..#DEFAULTSORTMODE} ];

/// Current search key value (if applicable).
Property searchKey As %ZEN.Datatype.string;

/// True if the contents of this page need to be saved.
Property pageModified As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

/// Indicates the id of which item is selected in the selector pane (on the left).
Property currItemId As %ZEN.Datatype.string [ InitialExpression = "HOME" ];

/// Number of items in the selector pane (this is automatically computed).
Property itemCount As %ZEN.Datatype.integer;

Property btnGo As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Go")} ];

/// Index of current item in search dropdown.
Property currDropdownIndex As %ZEN.Datatype.integer;

/// Used by search box to track link of selected item.
Property searchLink As %ZEN.Datatype.string;

/// If true, the the "Home" page needs to be refreshed to see new favorites.
Property homeChanged As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

/// Current login user name.
Property Username As %ZEN.Datatype.string;

/// Name of the current namespace (from $NAMESPACE).
Property NAMESPACE As %ZEN.Datatype.string;

/// Current $NAMESPACE. This is the namespace user selected from the Switch namespace dialog and will be used in navigate().
Property REQUESTNS As %ZEN.Datatype.string;

/// are we in Ensemble management mode
Property ManageEnsemble As %Boolean;

Property msgConfirm As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Rebuild synchronization data?")} ];

Property msgCompleted As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Rebuild Started")} ];

Property msgResendConfirm As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Request resend of users and roles?")} ];

Property msgResendCompleted As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Request sent.  Check RolesAndResources task status.")} ];

XData Style
{
<style type="text/css">

#selector {
	overflow: auto;
}
/* Style for the outside table */
table.outside {
	vertical-align: top;
	
}
/* Style for the major menu */
table.HSselector {
	border: 1px solid #cbcbcb;
	vertical-align: top;
	padding-right: 20px;
	width: 100%;
}
table.HSselector td {
	font-weight: bold;
	vertical-align: middle;
	font-size: 14pt;
}
/* Style for the sub-menu */
table.HSselectorsub {
	background: white;
	vertical-align: middle;
	padding: 2px;
}
.HSselectorType {
	border: 1px solid #cbcbcb;
	display: block;
	padding: 2px;
	padding-right: 12px;
	vertical-align: middle;
	text-decoration: none;
	color: black;
	font-weight: bold;
	font-size: 14pt;
	width: 300px;
}

.HSselectorItem {
	border: 1px solid #cbcbcb;
	color: #000000;
    font-size: 14px;
    font-weight: 600;
	display: block;
	padding: 10px 12px;
	text-decoration: none;
	vertical-align: middle;
	width: 300px;
}

.HSselectorsub a:hover {
	background: #f0f0f0;
}

div.type_errors {
	border: 1px solid #cbcbcb;
	font-size: 0.9em;
	margin: 10px;
	margin-top: 1em;
	padding: 0.5em;
}

div.type_errors ul.type_error_list {
	list-style-type: circle;
	margin-bottom: 0px;
	margin-top: 0.5em;
	padding-left: 1.5em;
}
.ribbonTitle {
	color:#00AFA9;
	font-family: Montserrat,Futura,Arial,sans-serif;
	font-size:36px;
	font-weight: bold;
	text-align:left;
}
/* tool ribbon */

.toolRibbon {
	height: 48px;
	background: white;
	float: left;
	vertical-align: middle;
}
.toolRibbonEnd {
	border: 1px solid #f0f0f0;
	width: 100%;
}

.ribbonLabel {
	vertical-align: middle;
	color: #404040;
	font-weight: bold;
	font-size: 10pt;
}

.ribbonSortOption:hover,.ribbonSortOptionSelected:hover {
	color: darkred;
}

.ribbonSortOption {
	text-decoration: none;
	color: #5ba4dc;
	font-weight: normal;
}

.ribbonSortOptionSelected {
	text-decoration: none;
	color: #404040;
	background: #FFEEAA;
	font-weight: normal;
}

.viewIconBar {
	vertical-align: bottom;
}

.viewIcon,.viewIconSelected,.viewIconDis,.viewIconHover {
	vertical-align: bottom;
	border: 2px solid white;
	height: 34px;
	width:  34px;
}

.viewIconSelected {
	border-radius: 2px;
	border: 3px solid #000000;
}

.viewIconHover {
	background: #BFE4E3;
	cursor:pointer;
}

.csMenuBar {
	 display:block;
     background-color:white;
     border:1px solid gray;
     height:18; 
     width:100%;
}
.csMenuItem {
    position:absolute;
    cursor:pointer;
    font:12px arial;
    background:white;
    color:black;
    height:18px;
}

.csActiveMenuItem {
	background: #eeeeee;
	color: #98923a;
}

#finder {
	width: 0px;
	background: white;
	overflow: hidden;
}

.finderColumn {
	overflow-y: auto;
}
.selectorOuter {
	background: none;
	padding: 4px;
	padding-right: 6px;
}

.selectorOuterSelected {
	background: white;
	padding: 4px;
	padding-right: 6px;
	-moz-border-radius-topleft: 10px;
	-moz-border-radius-bottomleft: 10px;
	border-radius-topleft: 10px;
	border-radius-bottomleft: 10px;
}

.selectorInner {
	border: 1px solid #cbcbcb;
	text-align: left;
	vertical-align: middle;
}

.selectorInnerDisabled {
	background: #D0D0D0;
	text-align: left;
	vertical-align: middle;
	opacity: 0.50;
}

.selectorOuterSelected .selectorInner {
	border: solid 1px #cbcbcb;
}

.selectorOuterSelected .selectorInner td {
}

.selectorNamespace td {
	font-size: 10pt;
	font-weight: bold ;
}

.selectorInner td,.selectorInnerDisabled td {
	font-weight: bold;
	font-size: 12pt;
}

.selectorInner a,.selectorInnerDisabled a {
	display: block;
	padding: 2px;
	padding-right: 12px;
	text-decoration: none;
	color: black;
	vertical-align: middle;
}

.selectorInnerDisabled .selectorInnerTD {
	color: #808080;
}

.selectorInnerTD {
	cursor: pointer;
}

.selectorOuterSelected {
	color: black;
	border-left:5px solid #333695;
}

.selectorInner a:visited, .selectorInner a:active {
	color: black;
}

.selectorInner a:hover {
	background: #F7F7F7;
}

.selectorOuterSelected .selectorInner a:hover {
	background: none;
}

.selectorInner a:hover .selectorInnerTD {
	color: #404040;
}

.selectorOuterSelected .selectorInner a:hover .selectorInnerTD {
	background: none;
}

.listCommand {
	color: white;
}

.ndMain {
	position: relative;
	padding: 22px;
	color: #404040;
	font-family: arial;
}

.ndMainTitle {
	color: #404040;
	font-size: 22pt;
	text-shadow: #D0D0D0 2px 2px 2px;
}

.ndMainTitle:first-letter {
	color: #404040;
	font-size: 34pt;
}

.ndMainSub {
	color: #606060;
	font-size: 10pt;
	padding-bottom: 10px;
}

.ndWrapper {
	height: 150px;
	width: 80%;
	overflow-y: auto;
}

table td.ndTitle {
	color: rgb(53,107,141);
	font-weight: bold;
	font-size: 12pt;
	border-bottom: 1px solid gray;
}

table td.ndSubtitle {
	color: #808080;
	font-size: 10pt;
	padding-bottom: 5px;
}

table td.ndOption {
	font-size: 11pt;
	padding-bottom: 3px;
}

table td.ndOption a {
	text-decoration: none;
	color: #404040;
	font-size: 11pt;
	display: block;
	width: 100%;
}

table td.ndOption a:hover {
	text-decoration: none;
	color: #202020;
	background: #FFEEAA;
}

table.searchTable {
}

table.searchTable td {
	padding: 4px;
}

table.searchDropDownTable {
}

table.searchDropDownTable td {
}

.rowEven {
}

.rowOdd {
	background: #F0F0F0;
}

.ndDidYou {
	color: #404040;
	font-size: 11pt;
	line-spacing: 120%;
	padding-top: 5px;
	padding-bottom: 3px;
}

a.ndCloseIcon img {
	opacity: 0.5;
	filter:alpha(opacity=50);
}

a.ndCloseIcon:hover img {
	opacity: 1.0;
	filter:alpha(opacity=100);
}

.ndLabel {
	color: #606060;
	font-weight: bold;
	font-size: 8pt;
}

.ndLink {
	padding: 2px;
	text-decoration: none;
	color: #6060D0;
}

.ndLink:hover {
	text-decoration: none;
	color: #202060;
	background: #FFEEAA;
}

.sdLink {
	padding: 2px;
	text-decoration: none;
	color: #606060;
	display: block;
	font-size: 10pt;
}

.sdLink:hover {
	text-decoration: none;
	color: #404040;
	background: #FFEEAA;
}

.sysHeader {
	color: #606060;
	font-weight: bold;
	font-size: 10pt;
	padding-top: 10px;
}

.sysInfo {
	color: #404040;
	font-size: 10pt;
}

.sysAlert {
	color: #F04040;
	font-size: 10pt;
	font-weight: bold;
}

.sysRunning {
	color: #40A040;
	font-size: 10pt;
	font-weight: bold;
}

.sysLinkDiv {
	cursor: pointer;
}
#searchDiv {
	position: absolute;
	top: 117px;
	right: 30px;
}

.search-icon {
	width: 22px;
	vertical-align: bottom;
	cursor: pointer;
}
#searchBox {
	color: #767676;
	width: 136px;
	border: 0;
	outline: 0;
	border-bottom: 1px solid #333695;
	padding: 2px 7px;
	margin-right: 5px;
}

#searchGroupWrapper {
	position: relative;
}

#searchGroup {
	position: absolute;
	visibility: hidden;
}

#searchDropDown {
	position: fixed;
	top: 140px;
	right: 55px;
	width: 149px;
	height: 250px;
	border: 2px solid #d8d8d8;
	background: white;
	z-index: 3;
	overflow-y: auto;
	overflow-x: hidden;
}

#searchDropDownShadow {
	position: fixed;
	top: 104px;
	left: 830px;
	width: 245px;
	height: 250px;
	border: 1px solid gray;
	background: black;
	opacity: 0;
	color: gray;
	z-index: 2;
	overflow-y: auto;
	overflow-x: hidden;
}

.searchDropDownList {
	padding: 2px;
}

/* reskin
#searchBox {
	color: darkblue;
	width: 250px;
	border: 1px solid rgb(53,107,141);
	-moz-border-radius: 3px;
	border-radius: 3px;
}

#searchGroupWrapper {
	position: relative;
}

#searchGroup {
	position: absolute;
	visibility: hidden;
}

#searchDropDown {
	position: fixed;
	top: 100px;
	left: 830px;
	width: 245px;
	height: 250px;
	border: 1px solid rgb(53,107,141);
	background: white;
	z-index: 3;
	overflow-y: auto;
	overflow-x: hidden;
}

#searchDropDownShadow {
	position: fixed;
	top: 104px;
	left: 830px;
	width: 245px;
	height: 250px;
	border: 1px solid gray;
	background: black;
	opacity: 0.5;
	filter:alpha(opacity=25);
	color: gray;
	z-index: 2;
	overflow-y: auto;
	overflow-x: hidden;
}

.searchDropDownList {
	padding: 2px;
}
*/
</style>
}

/// Contents of this page:
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" 
	xmlns:deepsee="http://www.intersystems.com/deepsee" 
	title="#(%page.StdTitle)#"
	dropEnabled="true"
	dragAndDrop="true">
<group layout="none" containerStyle="position:relative; top:0px; left:0px">
<html id="title" OnDrawContent="DrawHSTitle"/>
</group>

<html id="toolRibbon" OnDrawContent="DrawRibbon"/>

<vgroup width="100%" valign="top">
<pane paneName="contentPane" width="100%"/>
</vgroup>

</page>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" xmlns:hs="http://www.intersystems.com/zen/hs" id="homePane" hidden="true">
<group id="searchGroupWrapper">
<group id="searchGroup">
<html id="searchDropDownShadow"/>
<html id="searchDropDown" OnDrawContent="DrawSearchDropDown"/>
</group>
</group>

<jsonProvider id="json" OnGetArray="GetFinderArray"/>
<hgroup cellVAlign="top">
<spacer width="25"/>
<html id="selector" valign="top" OnDrawContent="DrawSelector"/>
<vgroup cellVAlign="top" cellStyle="padding-top:6px;">
<hs:SMPFinderPane id="finder" ongetdata="return zen('json').getContentObject();" 
	onselectitem="return zenPage.itemSelected(item);"
	ondrawdetails="return zenPage.drawDetails(item,finder,index);"
	ondrawempty="return zenPage.drawEmptyFinder();"
	ondblclick="return zenPage.itemDoubleClick(item);"
	 listColumns="name,description"
	/>
</vgroup>

<html id="searchResults" hidden="true" OnDrawContent="DrawSearchResults"/>
</hgroup>

</pane>
}

/// This class method callback is called just before the server-side page 
/// object is created.
Method %OnAfterCreatePage() As %Status
{
	//set %response.TraceDump=1
	Set tSC = ..BuildMenu()
	If $$$ISERR(tSC) Quit tSC
	// save the current $Username into property, so it can be used to compare if it is the same as the last login. 
	// If it differs then the last "state" will not be restored.
	Set ..Username = $Username
	Set ..ManageEnsemble = $G(%request.Data("$ENSEMBLE",1))
	Set ..NAMESPACE = $Namespace
	Set ..REQUESTNS = $G(%request.Data("$NAMESPACE",1))
	Set %session.Data("$NAMESPACE") = $Namespace // need this to carry back to system mgmt portal for favorites
	Quit tSC
}

/// Get the (localized) name of the page.
/// This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $Case(##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance(),1:$$$Text("HealthShare Home"),:$$$Text("Health"))
}

/// Draw the contents of the tool ribbon.
/// This is displayed if a subclass implements the <method>OnGetRibbonInfo</method> callback.
Method DrawRibbon(pSeed As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		Set tDisplay = 0
		Set tSearchBox = 0
		Set tRibbonTitle = ""
		Set tSC = ..OnGetRibbonInfo(.tDisplay,.tViewIcons,.tSortOptions,.tSearchBox,.tRibbonTitle,.tCommands)
		If $$$ISERR(tSC) Quit

		If ('tDisplay) Quit
	
		&html<<div class="toolRibbon">>
		&html<<table border="0" cellspacing="0" cellpadding="0" style="height:48px;width:100%;"><tr>>

		If (tRibbonTitle '= "") {
			&html<<td width="25%" class="ribbonTitle">&nbsp;&nbsp;<nobr>#(tRibbonTitle)#</nobr>&nbsp;&nbsp;</td>>
		}

		// commands
		If ($D(tCommands)) {
			If ($D(tViewIcons)) {
				&html<<td width="10%">&nbsp;</td>>
			}
			&html<<td align="left" nowrap="1">>
			Set n = $O(tCommands(""))
			While (n'="") {
				Set tID = $LG(tCommands(n),1)
				Set tCaption = $LG(tCommands(n),2)
				Set tTitle = $LG(tCommands(n),3)
				Set tOnClick = $LG(tCommands(n),4)
				Set tHidden = $S($LG(tCommands(n),5):"visibility:hidden;",1:"")
				// n.b. set line-height because of ie! 
				&html<<a id="command_#(tID)#" style="line-height:27px;#(tHidden)#" class="commandButton" href="#" onclick="#(tOnClick)#return false;" title="#(tTitle)#"><nobr>#(tCaption)#</nobr></a>&nbsp;&nbsp;>
				Set n = $O(tCommands(n))
			}
			&html<</td>>
		}

		Set tSC = ..OnDrawRibbon()
		If $$$ISERR(tSC) Quit

		// sort
		If ($D(tSortOptions)) {
			&html<<td style="width:80px;">&nbsp;</td>>
			&html<<td class="ribbonLabel" nowrap="1">#($$$Text("Sort:","%Utility"))#&nbsp;>
			Set n = $O(tSortOptions(""))
			While (n '= "") {
				Set tID = $LG(tSortOptions(n),1)
				Set tText = $LG(tSortOptions(n),2)
				Set tTitle = $LG(tSortOptions(n),3)
				Set tCls = $S(tID=..currSortMode:"ribbonSortOptionSelected",1:"ribbonSortOption")
				&html<&nbsp;<a id="sort_#(tID)#" title="#(tTitle)#" class="#(tCls)#" href="#" onclick="zenPage.setSortMode('#(tID)#');return false;">&nbsp;#(tText)#&nbsp;</a>&nbsp;>
				Set n = $O(tSortOptions(n))
			}
			&html<</td>>
		}
		
		#; icons

		If ($D(tViewIcons)) {
			// view
			Set tTitle = $$$Text("Choose how options should be displayed","%Utility")
			&html<<td style="width:40px;">&nbsp;</td>>
			&html<<td class="ribbonLabel" width="1%" title="#(tTitle)#" nowrap>#($$$Text("View:","%Utility"))#&nbsp;</td>>

			&html<<td nowrap="1">
			<div class="viewIconBar">>
			Set n = $O(tViewIcons(""))
			While (n'="") {
				Set tID = $LG(tViewIcons(n),1)
				Set tHelp = $LG(tViewIcons(n),2)
				Set tIcon = $LG(tViewIcons(n),3)
				// use mouse events so that hover works on ie
				&html<<img id="view_#(tID)#" class="#($S(..currViewMode=tID:"viewIconSelected",1:"viewIcon"))#" title="#(tHelp)#" src="#(tIcon)#" onclick="zenPage.setViewMode('#(tID)#');" onmouseover="this._oldClass=this.className;this.className='viewIconHover';" onmouseout="this.className=this._oldClass;" />>
				Set n = $O(tViewIcons(n))
			}
			&html<</div></td>>
		}
		Else {
			&html<<td style="width:40px;">&nbsp;</td>>
		}

		If (tSearchBox) {
			// Search
			// IE doesn't support event.relatedTarget, setTimeout on blur events to get the source target.
			&html<<td nowrap="1"><div id="searchDiv">>
			If ($$$EnsMajorVersion_$$$EnsMinorVersion > 20191) {
				&html<<input id="searchBox" type="text" size="12" placeholder="Search" onkeypress="zenPage.searchKeyPress(event);" onkeydown="return zenPage.searchKeyDown(event);" onblur="setTimeout(function(){zenPage.searchBlur(event);},200);"/>
				<img id="search-icon-glass" class="search-icon" alt="" onclick="zenPage.searchBoxHandler(document.getElementById('searchBox').value);" src="#(..Link("images/icon-search.png"))#"/>>
			} Else {
				&html<<div class="ribbonLabel">#($$$TextHTML("Search"))#: <input id="searchBox" type="text" size="12" onkeypress="zenPage.searchKeyPress(event);" onkeydown="return zenPage.searchKeyDown(event);" onblur="setTimeout(function(){zenPage.searchBlur(event);},200);"/></div>>
	
			}
			&html<</div></td>>
		}

		&html<</tr></table>>
		&html<</div>>
		/// the next line enables us to display the horizontal line below the ribbon bar across the table width 
		/// which could be wider and require horizontal scroll. We seperated this from the toolsRibbon because 
		/// we want the command buttons for the toolsRibbon bar to show on the left, and not float to the right when table becomes too wide.
		&html<</tr><tr><td colspan="50"><div class="toolRibbonEnd"></td></tr>>
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 1
	Set tType=##class(%ZHSLIB.HealthShareMgr).GetHealthShareNamespaceType()
	Set pRibbonTitle = $S(tType="":$$$Text("Management Portal"),1:$Namespace_" "_$$$Text("Management"))

	If ##class(%ZHSLIB.HealthShareMgr).GetHealthShareNamespaceType()'="" {
		Set pViewIcons(1) = $LB("columns",$$$Text("Show columns view"),"portal/view_box_columns.png")
		Set pViewIcons(2) = $LB("list",$$$Text("Show list view"),"portal/view_box_list.png")
		//reskin Set pViewIcons(3) = $LB("icons",$$$Text("Show icons view"),"portal/view_box_icons.png")
	}

	// commands
	// $LB(id,caption,help,onclick)
	IF $system.Security.Check("%All","USE"),('$system.Mirror.IsMember()||$system.Mirror.IsPrimary()) {
		Set pCommands($I(iCmd)) = $LB("cmdStart",$$$Text("Start All"),$$$Text("Start all Productions"),"zenPage.startProductions();")
		Set pCommands($I(iCmd)) = $LB("cmdStop",$$$Text("Stop All"),$$$Text("Stop all Productions"),"zenPage.stopProductions();")
	}
	Quit $$$OK
}

/// This is called in the middle of rendering the tool ribbon.
Method OnDrawRibbon() As %Status
{
	Quit $$$OK
}

/// Draw content of the selector pane.
/// This will only be visible if we're not in a HealthShare component namespace
Method DrawSelector(pSeed As %String) As %Status
{
	Quit:##class(%ZHSLIB.HealthShareMgr).GetHealthShareNamespaceType()'="" $$$OK
	If $system.Mirror.IsMember(),'$system.Mirror.IsPrimary() Quit $$$OK
	Do ..GetNamespaceData(.tHSTypeData,.tErrors)
	
	&html<<table cellspacing="10" cellpadding="6" border="0" >>
	
	Set tIcon=..Link("portal/icon_healthshare.png")
	Set ..itemCount = 0
	Set tUITier = ""
	For {
		Set tUITier = $order(tHSTypeData(tUITier))
		If (tUITier = "") {
			Quit
		}
		Set tType = ""
		For {
			Set tType = $order(tHSTypeData(tUITier,tType))
			If (tType = "") {
				Quit
			}
			Set ..itemCount = ..itemCount+1
			&html<<tr>
			<td>
			<table id="item_#(..itemCount)#" class="HSselector">
				<tr>
					<td style="padding:20px 6px;"><img alt="" src="#(tIcon)#" width="30px" height="30px"/></td>
					<td id="tditem_#(..itemCount)#" valign="middle"><nobr>&nbsp;#($zconvert(tType,"O","HTML"))#</nobr></td>
				</tr>
			</table>
			</td>
			<td>
				<table class="HSselectorsub" cellspacing="0" cellpadding="2" border="0">>
			Set tHSNamespace = ""
			For {
				Set tHSNamespace = $order(tHSTypeData(tUITier,tType,tHSNamespace),1,tURL)
				If (tHSNamespace = "") {
					Quit
				}
				Set tDefaultClass = $S(##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance():"HS.UI.Home.cls",1:"HS.HC.UI.Home.cls")
				Set tLink=..Link(tURL_"/"_##class(%ZHSLIB.SessionEventUtil).GetRegistryConfigValue("\UI\Home", tDefaultClass, tHSNamespace))
				Set tHSNamespaceHTML = $zconvert(tHSNamespace,"O","HTML")
				&html<<tr>
				<td>
				<a class="HSselectorItem" href="#($zconvert(tLink,"O","HTML"))#" title='#($$$TextHTML("Click to select this namespace"))#' >
					<nobr>&nbsp;#(tHSNamespaceHTML)#</nobr>
				</a>
				</td>
				</tr>>
			}
			&html<</tr></td></tr></table></td>>
		}
	}
	&html<</table>>
	
	If $data(tErrors) {
		Set tErrorTitle = $$$TextHTML("We could not get information for the following namespaces:")
		&html<<div class="type_errors">
			<div class="type_errors_title">#(tErrorTitle)#</div>
			<ul class="type_error_list">>
		
		Set tErrorNamespace = ""
		For {
			Set tErrorNamespace = $order(tErrors(tErrorNamespace))
			If (tErrorNamespace = "") {
				Quit
			}
			&html<<li>#($zconvert(tErrorNamespace,"O","HTML"))#</li>>
		}
		
		&html<</ul>
		</div>>
	}
	
	Quit $$$OK
}

Method GetNamespaceData(Output pNamespaceTypeData, Output pErrors) [ Internal ]
{
	Kill pNamespaceTypeData
	Kill pErrors
	Set tRS = ##class(%ResultSet).%New("HS.Util.Installer.ConfigItem:Configuration")
	If $IsObject(tRS) {
		Do tRS.Execute()
		While tRS.Next() {
			Set tType = tRS.Get("Type")
			If (tRS.Get("LastActivated") '= "") && 'tRS.Get("Disabled") {
				Set tItemNamespace = tRS.Get("ID")
				Set tTypeSC = $$$OK
				Try {
					// Note that we require tConfigItemClass to be mapped to the current namespace
					Set tTypeSC = ##class(HS.Util.Installer.ConfigItem).%OnDetermineClass($$$oidForm(tItemNamespace),.tConfigItemClass)
					If $$$ISOK(tTypeSC) && $classmethod(tConfigItemClass,"CheckUISecurityResources",tItemNamespace) {
						Set tTypeName = $classmethod(tConfigItemClass,"GetConfigTypeName",1)
						Set tUITier = +$classmethod(tConfigItemClass,"GetConfigTypeUITier")
						Set tItemName = tRS.Get("Name")
						Set pNamespaceTypeData(tUITier,tTypeName,tItemName) = $system.CSP.GetDefaultApp(tItemName)
					}
				}
				Catch ex {
					Set tTypeSC = ex.AsStatus()
				}
				If $$$ISERR(tTypeSC) && ##class(%SYS.Namespace).Exists(tItemNamespace) {
					Set pErrors(tItemNamespace) = tTypeSC
				}
			}
		}
	}
}

/// Provide the source data (as an array) that will drive the finder.
Method GetFinderArray(ByRef pParameters, Output pMetaData, Output pData) As %Status
{
	// tags are used for searching, but are not displayed
	// pMetaData describes what goes into the list items in the pData array
	Set pMetaData = $LB("name","title","link","disabled","icon","description","resource","customResource","tags","modCustom")
	// resource and customResource are set later
	Kill pData
	If ..ManageEnsemble {
		Set tSC=##class(EnsPortal.Application).GetEnsembleArray(.pData)
		Try {
			// Add stack level to allow $namespace to be popped locally
			If (..NAMESPACE '= ..REQUESTNS) && '##class(%Library.EnsembleMgr).IsEnsembleNamespace() {
				New $namespace
				Set $namespace = ..REQUESTNS
			}
			Set tSC = ..%CheckResources(.pData)
		}
		Catch {}
		Quit tSC
	}
	// This only gets populated in a HealthShare Component namespace
	try {
		Set tSC=$$$OK
		Set tType=##class(%ZHSLIB.HealthShareMgr).GetHealthShareNamespaceType()
		Set:tType]"" tSC = $method($this,"Get"_tType_"Array",.pData)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Check resources for each item in the menu array.
Method %CheckResources(ByRef pData) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Set n = $O(pData(""))
	Set tURLPrefix = $select($IsObject($get(%request)): %request.URLPrefix, 1: "")
	Set tURLPrefixLen = $length(tURLPrefix)
	While (n'="") {
		Set tNode = $G(pData(n))

		If ($D(pData(n))>1) {
			// child nodes: recurse
			Kill tData
			Merge tData = pData(n)
			Set tSC = ..%CheckResources(.tData)
			If $$$ISERR(tSC) Quit
			Kill pData(n)
			Merge pData(n) = tData
		}
		Else {
			// deal with this node
			Set tSuppliedLink = $LG(tNode,3)
			Set tDisabled = $LG(tNode,4)
			// strip off query, hash and the server prefix for local processing
			Set tLink = $P(tSuppliedLink,"?",1)	
			Set tLink = $P(tLink,"#",1)
			If tURLPrefixLen && ($extract(tLink,1,tURLPrefixLen) = tURLPrefix) {
				Set tLink = $extract(tLink,tURLPrefixLen+1,*)
			}

			Set tIsPortalPage = ##class(%CSP.Portal.Utils).%IsPortalPage(tSuppliedLink,.tNormLink)
			Set tResource = ""
			Set tCustomResource = ""
			// find custom resource, if any
			If tIsPortalPage {
				Set tCustomResource = ##class(%CSP.Portal.Utils).%GetCustomResource($zconvert(tNormLink,"O","URL"))
			}
			
			Set tExt = $$$LOWER($P(tLink,".",$L(tLink,".")))
			Set tPath = $$$LOWER($P(tLink,"/",1,$L(tLink,"/")-1))
			Set tSysLink = ($extract(tLink,1,$length("/csp/sys/")) = "/csp/sys/")
			Set tCls = ""

			// Ensemble links should all end in ".zen"
			If ((tExt="cls")||(tExt="zen")) {
				// extract the class name from the link
				Set tCls =$P(tLink,"/",$L(tLink,"/"))
				Set tCls = $ZCVT(tCls,"I","URL")
				If $extract(tCls) = "_" Set $extract(tCls) = "%"
				Set tCls = $P(tCls,".",1,$L(tCls,".")-1)
				// now we can use $parameter to get the resource list
				Try {
					Set tResource = $parameter(tCls,"RESOURCE")
				}
				Catch {}
			}

				// check resource(s)
				If ('tDisabled) {
					Set tCheckResources = $lb(tResource, tCustomResource)
					Set tCanAccess = ##class(%CSP.Portal.Utils).CheckLoggedInResources(tCheckResources)
					Set tDisabled = $case(tCanAccess, $$$caNotCSPLink: 0, $$$caCanAccessRes: 0, $$$caUnknownTarget: 0, : 1)
				}

			Set $List(tNode,4) = tDisabled
			Set $List(tNode,7) = tResource
			Set $List(tNode,8) = tCustomResource
			Set $List(tNode,10) = 0
		}

		Set pData(n) = tNode
		Set n = $O(pData(n))
	} 
	Quit tSC
}

Method AddMenuBranch(pName, pTitle = "", pLicense = "", pMethod, pSecurity = "", pIcon = "", ByRef pData, ByRef pN = 0, pArgs...)
{
	If pSecurity'="" Quit:'$SYSTEM.Security.Check(pSecurity,"USE")
	If pLicense'="" Quit:'$$$HSLicensed(pLicense)
	//reskin If pIcon="" Set pIcon=..Link("portal/role_48.gif")
	Set pIcon=..Link(pIcon)
	Set tList=$LB(pName,pTitle,,0,pIcon)
	If +$G(pArgs)=0 {
		Do $Method(,pMethod,pN+1,.pData)
		Set:$D(pData(pN+1)) pData($I(pN))=tList
	} ElseIf pArgs=1 {
		Do $Method(,pMethod,pArgs(1),pN+1,.pData)
		Set:$D(pData(pArgs(1),pN+1)) pData(pArgs(1),$I(pN))=tList
	} ElseIf pArgs=2 {
		Do $Method(,pMethod,pArgs(1),pArgs(2),pN+1,.pData)
		Set:$D(pData(pArgs(1),pArgs(2),pN+1)) pData(pArgs(1),pArgs(2),$I(pN))=tList
	} ElseIf pArgs=3 {
		Do $Method(,pMethod,pArgs(1),pArgs(2),pArgs(3),pN+1,.pData)
		Set:$D(pData(pArgs(1),pArgs(2),pArgs(3),pN+1)) pData(pArgs(1),pArgs(2),pArgs(3),$I(pN))=tList
	}
}

/// pName - option Name (after $$$Text)
/// pTitle - option Title (hover help, after $$$Text)
/// pKey - configuration registry UI key for the class/page
///  for options invoking methods within this class, this goes in pKey, and pClass would be null
/// pClass - classname (with .cls) of the default class, to be used if not in the configuration registry
/// pSecurity - if filled in, must have Use access to that Role
/// pIcon - reference to icon file (defaults to portal/role_48.gif)
/// pCheckUIVersion - boolean.  Used to check for an out of date UI running on a gateway, where the registry has
///  been upgraded, but the gateway hasn't.
/// pData - the array being populated with the menu, where pData(1-n)=top level of menu, pData(x,1-n1)=nested level, etc.
/// pN - the current index into the current level in PData
/// pArgs - subscripts used when for submenu structure within the array
Method AddOption(pName, pTitle = "", pKey = "", pClass = "", pSecurity = "", pIcon = "", pCheckUIVersion = 0, ByRef pData, ByRef pN = 0, pArgs...)
{
	If pClass'="" Set pClass=$$$HSUILink(pKey,pClass) Quit:pClass=""
	If pClass="", pKey'="" Set pClass=pKey
	If pCheckUIVersion Quit:'##class(HS.UI.Util).CheckUIVersion(pKey)
	If pSecurity'="" Quit:'$SYSTEM.Security.Check(pSecurity,"USE")
	//reskin If pIcon="" Set pIcon=..Link("portal/role_48.gif")
	Set pIcon=..Link(pIcon)
	Set tList=$LB(pName,pTitle,pClass,0,pIcon), pN=pN+1
	If +$G(pArgs)=0 {Set pData(pN)=tList}
	ElseIf pArgs=1 {Set pData(pArgs(1),pN)=tList}
	ElseIf pArgs=2 {Set pData(pArgs(1),pArgs(2),pN)=tList}
	ElseIf pArgs=3 {Set pData(pArgs(1),pArgs(2),pArgs(3),pN)=tList}
	Else {Set pData(pArgs(1),pArgs(2),pArgs(3),pArgs(4),pN)=tList}
}

Method GetFoundationArray(pData) As %Status
{
	Set tSC = ..AddProductsMenu(.pData,.n1) Quit:$$$ISERR(tSC) tSC
	Quit:'$SYSTEM.Security.Check($$$HSHubManagement,"USE") $$$OK

	Set tConfig=##class(HS.Util.Installer.ConfigItem).%OpenId($namespace) Quit:tConfig.%ClassName(0)'="Foundation" $$$OK

	Set tEditSyncTables = $G(%session.Data("FoundationSync",$namespace))
	If tEditSyncTables="" {
		/// If the sync table globals are not mapped to HSSYS then we must be able to edit the tables
		If ##class(%SYS.Namespace).GetGlobalDest($namespace,"^OBJ.GUID") = ##class(%SYS.Namespace).GetGlobalDest($namespace) {
			Set tEditSyncTables=1
		} Else {
			Set tEditSyncTables='##class(HS.Sync.Utils).IsSyncSlave()
			If ##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance() {
				/// disable menu when not foundation even when foundation is mapped
				Set:tEditSyncTables tEditSyncTables = '##class(HS.Sync.Utils).IsMapped()
			}
		}
	}
	Set %session.Data("FoundationSync",$namespace)=tEditSyncTables
	
	Do:tEditSyncTables ..AddOption($$$Text("Facility Registry"),$$$Text("Add and Edit Facilities"),"Hub\Facilities","HS.UI.Hub.Facilities.cls",,,,.pData,.n1)
	Do:tEditSyncTables ..AddOption($$$Text("Service Registry"),$$$Text("Add and Edit Services"),"Registry\Services","HS.UI.Registry.Services.cls",,,,.pData,.n1)
	Do:tEditSyncTables ..AddMenuBranch($$$Text("IHE Configuration"),$$$Text("IHE Configuration"),,"GetIHEConfigurationFoundation",,,.pData,.n1)
	Set tIsHealthShare = ##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance()
	Set tAssigningAuthoritiesUI = $S(tIsHealthShare:"HS.UI.Hub.AssigningAuthorities.cls",1:"HS.HC.UI.AssigningAuthorities.cls")
	Do:tEditSyncTables ..AddOption($$$Text("Assigning Authority Registry"),$$$Text("Add and Edit Assigning Authorities"),"Hub\AssigningAuthorities",tAssigningAuthoritiesUI,,,,.pData,.n1)
	Do:tEditSyncTables ..AddOption($$$Text("Configuration Registry"),$$$Text("Add and Edit Configuration Data"),"Registry\Configuration","HS.UI.Registry.Configuration.cls",,,,.pData,.n1)
	Do ..AddOption($$$Text("Exclude Audit Events"),$$$Text("Manage the list of Audit events that are not saved the audit repository"),"Hub\AuditExclusion","HS.UI.Hub.AuditExclusion.cls",,,,.pData,.n1)
	IF $SYSTEM.Security.Check("%Ens_EDISchemaAnnotations","READ") {
		Do ..AddMenuBranch($$$Text("Schema Documentation"),$$$Text("Schema Documentation"),,"GetSchemaDocumentation",,,.pData,.n1)
	}
	Do ..AddOption($$$Text("Test Utility"),$$$Text("Send test transactions to HealthShare and other systems."),"Hub\TestUtility","HS.Test.UI.Main.cls","%HS_TestSuite",,,.pData,.n1)
	Do ..AddOption($$$Text("FHIR CSP Configuration"),$$$Text("Configure specific FHIR CSP application options"),"Hub\FHIRCSPConfig","HS.UI.Registry.FHIRCSPConfig.cls",,,,.pData,.n1)
	Do ..AddOption($$$Text("FHIR Test Utility"),$$$Text("Send FHIR test transactions to HealthShare and other systems."),"Hub\FHIRTestUtility","HS.Test.UI.FHIR.Main.cls","%HS_TestSuite",,,.pData,.n1)
	//Only display the FHIRServer configuration UI if the FHIRServer has been installed in this namespace
	if $data(^HS.FHIRServer) {
		Do ..AddOption($$$Text("FHIR Configuration"),$$$Text("Configure FHIR Implementation"),"Hub\FHIRConfig","fhirconfig/index.html#home",,,,.pData,.n1)
	}
	Quit $$$OK
}

Method GetIHEConfigurationFoundation(pN1, pData)
{
	Do ..AddMenuBranch($$$Text("OID Registry"),$$$Text("OID Registry"),,"GetOIDRegistry",,,.pData,.n2,pN1)
	Do ..AddOption($$$Text("XUA Configuration Registry"),$$$Text("Add and Edit XUA Configurations"),"Registry\XUAConfig","HS.UI.Registry.XUAConfig.cls",,,,.pData,.n2,pN1)
	Do ..AddOption($$$Text("Trusted RSA Key Registry"),$$$Text("Add and Edit RSA Keys"),"Registry\RSAConfig","HS.UI.Registry.RSAConfig.cls",,,,.pData,.n2,pN1)
	Do ..AddOption($$$Text("Coded Entry Registry"),$$$Text("Add and Edit IHE Coded Entries"),"Registry\CodedEntry","HS.UI.Registry.CodedEntry.cls",,,,.pData,.n2,pN1)
}

Method GetIHEConfiguration(pN1, pData)
{
	Do ..AddMenuBranch($$$Text("OID Registry"),$$$Text("OID Registry"),,"GetOIDRegistry",,,.pData,.n2,pN1)
	Do ..AddOption($$$Text("XUA Configuration Registry"),$$$Text("Add and Edit XUA Configurations"),"Registry\XUAConfig","HS.UI.Registry.XUAConfig.cls",,,,.pData,.n2,pN1)
	Do ..AddOption($$$Text("Trusted RSA Key Registry"),$$$Text("Add and Edit RSA Keys"),"Registry\RSAConfig","HS.UI.Registry.RSAConfig.cls",,,,.pData,.n2,pN1)
	Do ..AddOption($$$Text("Coded Entry Registry"),$$$Text("Add and Edit IHE Coded Entries"),"Registry\CodedEntry","HS.UI.Registry.CodedEntry.cls",,,,.pData,.n2,pN1)
	Do ..AddOption($$$Text("PIX Notification Registry"),$$$Text("Add and Edit PIX Domain Notifications"),"Registry\PIXDomains","HS.UI.Registry.PIXDomains.cls",,,,.pData,.n2,pN1)
}

Method GetOIDRegistry(pN1, pN2, pData)
{
	Do ..AddOption($$$Text("Add/Edit OIDs"),$$$Text("Add and Edit Object Identifiers"),"Registry\OID","HS.UI.OIDRegistry.cls",,,,.pData,.n3,pN1,pN2)
	Do ..AddOption($$$Text("Import OIDs"),$$$Text("Import OIDs from File"),"Registry\OID\Import","HS.UI.OIDRegistry.Import.cls",,,,.pData,.n3,pN1,pN2)
	Do ..AddOption($$$Text("Export OIDs"),$$$Text("Export OIDs to File"),"Registry\OID\Export","HS.UI.OIDRegistry.Export.cls",,,,.pData,.n3,pN1,pN2)
}

Method GetOIDRegistryFoundation(pN1, pData)
{
	Do ..AddOption($$$Text("Add/Edit OIDs"),$$$Text("Add and Edit Object Identifiers"),"Registry\OID","HS.UI.OIDRegistry.cls",,,,.pData,.n2,pN1)
	Do ..AddOption($$$Text("Import OIDs"),$$$Text("Import OIDs from File"),"Registry\OID\Import","HS.UI.OIDRegistry.Import.cls",,,,.pData,.n2,pN1)
	Do ..AddOption($$$Text("Export OIDs"),$$$Text("Export OIDs to File"),"Registry\OID\Export","HS.UI.OIDRegistry.Export.cls",,,,.pData,.n2,pN1)
}

Method GetSchemaDocumentation(pN1, pData)
{
 IF $SYSTEM.Security.Check("%Ens_EDISchemaAnnotations","READ") {
 	Do ..AddOption($$$Text("HL7 Annotations"),$$$Text("Display information about HL7 document types."),"HL7","HS.UI.HL7.cls",,,0,.pData,.n2,pN1)
 	Do ..AddOption($$$Text("SDA/CDA Annotations"),$$$Text("Display information about the data transformations that result in SDA and CDA document types."),"Doc\Mapping","HS.UI.Doc.Mapping.cls",,,0,.pData,.n2,pN1)
 	Do ..AddOption($$$Text("FHIR Annotations"),$$$Text("Display information about the data transformations to and from SDA and FHIR STU3, as well as those used internally by ODS to store SDA as FHIR STU3 and DSTU2."),"Doc\SchemaMap","SchemaMap.Tool.UI.View.cls",,,0,.pData,.n2,pN1) 		
 }
 Quit $$$OK
}

Method GetAustralianCustomisations(pN1, pData)
{
	Do ..AddOption($$$Text("SMD Configuration"),$$$Text("Add and Edit HPIO SMD Configurations"),"\AustralianCustomisations\SMDConfiguration","HS.AU.UI.Registry.SMDConfiguration.cls",,,,.pData,.n2,pN1)
	Do ..AddOption($$$Text("ELS Interaction Cache"),$$$Text("Add and Edit Information Types"),"\AustralianCustomisations\ELSCache","HS.AU.UI.Registry.ELSInteractionCache.cls",,,,.pData,.n2,pN1)
	Quit $$$OK
}

/// Provide HTML for details on selected item in finder.
ClientMethod drawDetails(item, finder, index) [ Language = javascript ]
{
	if (null == item) return '';

	var html = new Array();

	switch (finder.viewType) {
	case 'columns':
		html[html.length] = '<div style="text-align:center; padding: 5px;">';
		if (item.name) {
			html[html.length] = '<b>' + item.name + '</b><br/>';
			html[html.length] = '<hr/>';
		}

		var icon = item.icon ? item.icon : '';
		html[html.length] = '<img alt="" src="' + icon + '"/></b><br/>';

		var desc = item.description ? item.description : '';

		html[html.length] = desc + '<br/>';
		html[html.length] = '<br/>';
		if (item.link) {
			html[html.length] = '<a class="commandButton" href="#" onclick="zenPage.navigate(\''+item.link+'\');return false;">'+this.btnGo+'</a>' + '<br/>';
			//html[html.length] = '<br/><br/><a title="'+$$$Text('Add this item to the favorites list')+'" class="ndLink" href="#" onclick="zenPage.addFavorite(\''+item.name+'\',self.document.location.toString(),\''+item.link+'\'); return false;">'+$$$Text('Add to favorites')+'</a>' + '<br/>';
		}
		else {
			html[html.length] = '<a class="commandButtonDisabled" href="#" onclick="return false;">'+this.btnGo+'</a>' + '<br/>';
		}

		html[html.length] = '</div>';
		break;
	case 'list':
		if (index == finder.selectedList) {
			if (item.link) {
				html[html.length] = '<a class="listCommand" href="#" onclick="return false;" onmousedown="zenPage.navigate(\''+item.link+'\');return false;">Go</a>';
			}
		}
		break;
	case 'icons':
		break;
	}	
	
	return html.join('');
}

/// Provide HTML for empty finder.
ClientMethod drawEmptyFinder(item) [ Language = javascript ]
{
	var html = '';
	return html;
}

/// Item selected within the Finder.
ClientMethod itemSelected(item) [ Language = javascript ]
{
	var finder = zen('finder');
	if (finder.viewType != 'columns') {
		this.itemDoubleClick(item);
	}
	return true;
}

/// Item double-clicked within the Finder.
ClientMethod itemDoubleClick(item) [ Language = javascript ]
{
	// invoke link for this item
	if (item.link && ''!=item.link) {
		zenPage.navigate(item.link);
	}
	return true;
}

/// Request re-send of all user roles / resources and mark task as active
ClientMethod resendUsersRoles() [ Language = javascript ]
{
	try {
		var ok = confirm(this.msgResendConfirm);
		
		if (ok == 1) {
			this.RequestUsersRoles();
			alert(this.msgResendCompleted);
		}
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// Class method to request resend of user roles and resources
Method RequestUsersRoles() As %Status [ ZenMethod ]
{
	Set tSC=##class(HS.Util.HubServices).InvokeHubService("%ZHSLIB.Services.Server","%ZHSLIB.Services.Client","GetNVPair",.tPairs,"SetResourcesAndRolesTime",##class(%SYS.System).InstanceGUID()_"^")
	Set tSC = ##class(%ZHSLIB.Services.TaskUpdateRolesAndResources).RunNow($namespace) Quit:$$$ISERR(tSC)
	Quit tSC
}

/// Update the finder contents and display it.
ClientMethod updateFinder() [ Language = javascript ]
{
	zen('json').refreshContent();
	var finder = zen('finder');
	finder.update(true);
	this.showSearchResults(false);
	return false;
}

/// Adjust sizes of components on the page.
ClientMethod onlayoutHandler(load) [ Language = javascript ]
{
	try {
		
		if (load) {
			
			var sb = self.document.getElementById('searchBox');
			if (sb) {
				sb.value = '';
				try {
					sb.focus();
				}
				catch(ex) {
				}
			}

			// reveal pane
			var pane = zenPage.getComponentById('homePane');
			pane.setHidden(false);
		}

		var selector = zenPage.getComponentById('selector');
		var finder = zenPage.getComponentById('finder');
		var divSelector = selector.getEnclosingDiv();
		var divFinder = finder.getEnclosingDiv();

		if (load) {
			var initialState = '';
			// check for saved state in cookie
			var cookies = document.cookie;
			var stateStash = "nsstate."+this.ManageEnsemble+"."+this.NAMESPACE;
			var initialState = unescape(this.getCookieValue(stateStash,cookies));
			var Username = unescape(this.getCookieValue("Username",cookies));
			if (Username) {
				if ((Username != this.Username) && (initialState != '')) initialState = '';	
			}
			// find last viewMode
			var viewMode = this.getCookieValue("viewMode",cookies);
			if (viewMode != "") zenPage.setViewMode(viewMode);

			zenPage.updateFinder()
			if (initialState!='') {
				finder.selectedList = initialState;
			}
		}

		// find size of window
		var winHeight = zenGetWindowHeight();
		var winWidth = zenGetWindowWidth();

		var th = this.getTitleAreaHeight();
		var hgt = winHeight - th - 50 - (zenIsIE ? 20 : 0);

		hgt = (hgt < divSelector.offsetHeight) ? divSelector.offsetHeight : hgt;
		divFinder.style.height = hgt + 'px';

		this.makeSelectorBig(winWidth > 600);
		var fw = winWidth - divSelector.offsetWidth - 50 ;
		if (fw<10) {
			var fw = 10
		}
		divFinder.style.width = fw + 'px';

		zen('searchResults').getEnclosingDiv().style.width = fw + 'px';

		// compute size of finder columns
		var cols = 3;
		var colWid = fw / cols;
		while (colWid > 250) {
			cols++;
			colWid = (fw-10) / cols;
		}
		colWid = (colWid < 100) ? 100 : colWid;
		finder.setProperty('columnWidth',colWid);
		if (load) {
			divFinder.scrollTop = 0;
			divFinder.scrollLeft = 0;
		}
	}
	catch(ex) {
		alert(fw);
		zenExceptionHandler(ex,arguments,'Error in onlayoutHandler.');
	}
}

/// Set size of selector to big (true) or small (false).
ClientMethod makeSelectorBig(flag) [ Language = javascript ]
{
	for (var n = 0; n < this.itemCount; n++) {
		var table = self.document.getElementById('item_'+(n+1));
		var td = self.document.getElementById('tditem_'+(n+1));
		td.style.display = flag ? '' : 'none';
		table.style.width = flag ? 300 : 70;
	}
}

/// Navigate to a new page in the portal.
ClientMethod navigate(url) [ Language = javascript ]
{
	// override: get state of navigator and save in cookie
	var stateStash = "nsstate."+this.ManageEnsemble+"."+this.NAMESPACE;
	var state = zen('finder').selectedList;

	// save state in cookie
	//YSD2535 document.cookie = 'state=' + escape(state);
	this.setCookieValue(stateStash,escape(state));
	
	//save Username so that we can compare the next time we login.
	this.setCookieValue('Username',escape(this.Username));
	
	if(url=="syncRebuild()") {
		this.syncRebuild();
	} else if(url=="resendUsersRoles()") {
		this.resendUsersRoles();
	} else {
		zenPage.gotoPage(url);
	}
}

/// Do the actual work of updating the view to match the current sort mode.
ClientMethod setSortModeHandler(mode) [ Language = javascript ]
{
	// get new object graph
	zen('json').refreshContent();

	// update finder
	var finder = zen('finder');
	finder.update(true);

	this.showSearchResults(false);
}

/// This method clears the 'state' cookie which indicates the last selection for the finderPane position on the SMP portal home.
ClientMethod clearState() [ Language = javascript ]
{
	document.cookie = 'state=; expires=Thu, 01-Jan-1970 00:00:01 GMT';
	return true;
}

/// Go to the home page.
ClientMethod goHome() [ Language = javascript ]
{
	this.clearState();
	self.document.location = this.homePage;
	return false;
}

/// Change in search box value. Can be overridden by subclasses.
ClientMethod searchBoxHandler(searchKey) [ Language = javascript ]
{
	this.searchKey = searchKey;
	if ('' != this.searchKey) {
		zen('searchResults').refreshContents();
		this.showSearchResults(true);
	}
	else {
		this.showSearchResults(false);
	}
}

/// Hide/show search results.
ClientMethod showSearchResults(flag) [ Language = javascript ]
{
	if (flag) {
		zen('searchResults').setHidden(false);
		zen('finder').setHidden(true);
	}
	else {
		zen('searchResults').setHidden(true);
		zen('finder').setHidden(false);
	}
}

/// Draw contents of the search results panel.
Method DrawSearchResults(pSeed As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		&html<<div class="ndMain">>
		Set lblNoPriv = $$$TextHTML("You do not have privilege to view this page.")	
		Set msgSearch = $$$TextHTML("Search results for:")
		&html<<div class="ndMainSub" style="padding-bottom:5px;">>
		Write msgSearch,"&nbsp;<b><i>",$ZCVT(..searchKey,"O","HTML"),"</i></b>"
		&html<</div>>
		
		&html<<div class="ndMainSub">>
		Set tCount = 0
		If (..searchKey'="") {
			&html<<table class="searchTable" border="0" cellpadding="0" cellspacing="0">>
			Do ..%GetSearchResults($$$UPPER(..searchKey),.tResults)
			Set k = $O(tResults(""))
			While (k'="") {
				Set tCount = tCount + 1
				Set tLabel = $LG(tResults(k),1)
				Set tURL = $LG(tResults(k),2)
				Set tTitle = $LG(tResults(k),3)
				Set tCls = $S(tCount#2:"rowOdd",1:"rowEven")
				#;YSD2518 - do not build link if it failed custom resource check
				Set tDisabled = $LG(tResults(k),4)

				If 'tDisabled &html<<tr class="#(tCls)#"><td><a class="ndLink" href="#(tURL)#" >#($ZCVT(tLabel,"O","HTML"))#</a></td><td>#($ZCVT(tTitle,"O","HTML"))#</td></tr>>
				Else  &html<<tr class="#(tCls)#"><td title="#(lblNoPriv)#">#($ZCVT(tLabel,"O","HTML"))#</td><td title="#(lblNoPriv)#">#($ZCVT(tTitle,"O","HTML"))#</td></tr>>
				Set k = $O(tResults(k))
			}
			&html<</table>>
		}

		If (tCount = 0) {
			Write "<b>",$$$TextHTML("No items found"),"</b>"
		}

		&html<</div>>

		&html<<hr/>>

		Set msgClose = $$$TextHTML("Return to main menu")
		&html<<div class="ndMainSub">>
		&html<<a class="ndLink" href="#" onclick="zenPage.showSearchResults(false);return false;">#(msgClose)#</a>>
		&html<</div>>

		&html<</div>>
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Return an array of search results:
/// pResults(n) = $LB(name,url,title)
Method %GetSearchResults(pSearchKey As %String, Output pResults As %List)
{
	Do ..GetFinderArray(,,.tData)
	Do ..%ApplySearchToArray(pSearchKey,.tData,.pResults)
}

/// Walk down array; find elements containing search key.
Method %ApplySearchToArray(pSearchKey As %String, ByRef pArray, Output pResults As %List)
{
	If (pSearchKey'="") {
		// split search key into words
		For p=1:1:$L(pSearchKey," ") {
			Set:$P(pSearchKey," ",p)'="" tTerms($$$UPPER($P(pSearchKey," ",p))) = ""
		}

		Set k = $O(pArray(""))
		While (k'="") {
			Set tURL = $LG(pArray(k),3)
			If (tURL'="") {
				Set tName = $LG(pArray(k),1)
				Set tTitle = $LG(pArray(k),6)
				Set tTags = $LG(pArray(k),9)
				Set tDisabled = +$LG(pArray(k),4)
			
				// test each term against tags
				Set tMatch = 0
				For p=1:1:$L(tTags,",") {
					If ($P(tTags,",",p)'="") {
						If $D(tTerms($$$UPPER($P(tTags,",",p)))) {
							Set tMatch = 1
							Quit
						}
					}
				}

				If (tMatch||($$$UPPER(tName)[pSearchKey)||($$$UPPER(tTitle)[pSearchKey)) {
					#;YSD2518 Set pResults($$$UPPER(tName)_":"_$I(pResults)) = $LB(tName,tURL,tTitle)
					Set pResults($$$UPPER(tName)_":"_$I(pResults)) = $LB(tName,tURL,tTitle,tDisabled)
				}
			}
			If ($D(pArray(k))>1) {
				// recurse
				Kill tArray
				Merge tArray = pArray(k)
				Do ..%ApplySearchToArray(pSearchKey,.tArray,.pResults)
			}
	
			Set k = $O(pArray(k))
		}
	}
}

/// Display the search results drop down.
ClientMethod showSearchDropdown() [ Language = javascript ]
{
	this.searchLink = '';
	this.currDropdownIndex = -1;

	var sb = self.document.getElementById('searchBox');
	if (sb) {
		var group = zen('searchGroup').getEnclosingDiv();
		group.style.left = zenGetLeft(sb) - zenGetLeftScroll(sb);
		group.style.top = '0px';
		group.style.height = '100px';
		group.style.width = '100px';

		var dd = zen('searchDropDown');
		var enc = dd.getEnclosingDiv();
		enc.style.left = zenGetLeft(sb) - zenGetLeftScroll(sb);

		var dds = zen('searchDropDownShadow');
		var encs = dds.getEnclosingDiv();
		encs.style.left = zenGetLeft(sb) - zenGetLeftScroll(sb) + 2;

		if (zenIsIE) {
			// no shadow on IE!
			encs.style.display = 'none';
		}

		if (sb.value!='' && (sb.value.toString().length > 2)) {
			//dd.setHidden(false);
			dd.setProperty('seed',sb.value);
			//dds.setHidden(false);
			group.style.visibility = 'visible';
		}
		else {
			//dd.setHidden(true);
			//dds.setHidden(true);
			group.style.visibility = 'hidden';
		}
	}
}

/// Display the search results drop down.
ClientMethod hideSearchDropdown() [ Language = javascript ]
{
	var group = zen('searchGroup').getEnclosingDiv();
	group.style.visibility = 'hidden';
	/*
	var dd = zen('searchDropDown');
	dd.setHidden(true);
	var dds = zen('searchDropDownShadow');
	dds.setHidden(true);
	*/
	zenPage.clearSearchTimer();
}

/// Start the search timer.
ClientMethod startSearchTimer() [ Language = javascript ]
{
	zenPage.clearSearchTimer();
	zenPage._searchTimerId = self.setTimeout("zenPage.searchTimerHandler()",220);
}

/// Stop the search timer.
ClientMethod clearSearchTimer() [ Language = javascript ]
{
	if (zenPage._searchTimerId) {
		self.clearTimeout(zenPage._searchTimerId);
		zenPage._searchTimerId = null;
	}
}

/// Action for search timer.
ClientMethod searchTimerHandler() [ Language = javascript ]
{
	zenPage.showSearchDropdown();
}

/// Key down in search box (override).
ClientMethod searchKeyDown(evt) [ Language = javascript ]
{
	if (!zenIsIE) {
		return true;
	}

	evt = evt ? evt : event;
	var ctrl = self.document.getElementById('searchBox');
	if (!ctrl) return;

	switch(evt.keyCode) {
	case zenESC:
		zenPage.hideSearchDropdown();
		break;
	case zenDOWN:
		zenPage.searchBoxDown();
		break;
	case zenUP:
		zenPage.searchBoxUp();
		break;
	default:
		break;
	}

	return true;
}

/// Key press in search box (override).
ClientMethod searchKeyPress(evt) [ Language = javascript ]
{
	evt = evt ? evt : event;
	var ctrl = self.document.getElementById('searchBox');
	if (!ctrl) return;

	switch(evt.keyCode) {
	case zenENTER:
		if (this.searchLink != '') {
			self.document.location = this.searchLink;
			return;
		}

		zenPage.hideSearchDropdown();
		zenPage.searchBoxHandler(ctrl.value);
		break;
	case zenESC:
		if (!zenIsIE) {
			zenPage.hideSearchDropdown();
		}
		break;
	case zenDOWN:
		if (!zenIsIE) {
			zenPage.searchBoxDown();
		}
		break;
	case zenUP:
		if (!zenIsIE) {
			zenPage.searchBoxUp();
		}
		break;
	default:
		// assume edit of value
		this.searchLink = '';
		zenPage.startSearchTimer();
		break;
	}
}

/// Blur event in search box.
ClientMethod searchFocus(evt) [ Language = javascript ]
{
}

/// Blur event in search box.
ClientMethod searchBlur(evt) [ Language = javascript ]
{
	zenPage.hideSearchDropdown();
}

/// Go to prev item in search box dropdown.
ClientMethod searchBoxUp() [ Language = javascript ]
{
	var dd = zen('searchDropDown');
	if (dd.getProperty('hidden')) {
		return;
	}

	if (this.currDropdownIndex > 0) {
		var el = self.document.getElementById('sbdd_' + this.currDropdownIndex);
		if (el) {
			el.style.color = '';
			el.style.background = '';
		}
		this.currDropdownIndex--;
		var el = self.document.getElementById('sbdd_' + this.currDropdownIndex);
		if (el) {
			el.style.color = 'white';
			el.style.background = 'rgb(53,107,141)';
			var sb = self.document.getElementById('searchBox');
			sb.value = el.getAttribute('searchValue');
			this.searchLink = el.href;
			zenScrollIntoView(zen('searchDropDown').getEnclosingDiv(),el);
		}
	}
}

/// Go to next item in search box dropdown.
ClientMethod searchBoxDown() [ Language = javascript ]
{
	var sb = self.document.getElementById('searchBox');

	var dd = zen('searchDropDown');
	if (dd.getProperty('hidden')) {
		return;
	}
	var el = self.document.getElementById('sbdd_' + this.currDropdownIndex);
	var el2 = self.document.getElementById('sbdd_' + (this.currDropdownIndex+1));
	if (!el2) return;

	if (el) {
		el.style.color = '';
		el.style.background = '';
	}
	this.currDropdownIndex++;
	if (el2) {
		el2.style.color = 'white';
		el2.style.background = 'rgb(53,107,141)';
		var sb = self.document.getElementById('searchBox');
		sb.value = el2.getAttribute('searchValue');
		this.searchLink = el2.href;
		zenScrollIntoView(zen('searchDropDown').getEnclosingDiv(),el2);
	}
}

/// Draw contents of the search results dropdown.
Method DrawSearchDropDown(pSeed As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		&html<<div class="searchDropDownList">>

		Set tCount = 0
		If (pSeed'="") {
		&html<<table class="searchDropDownTable" border="0" cellpadding="0" cellspacing="0" width="100%">>
			Do ..%GetSearchResults($$$UPPER(pSeed),.tResults)
			Set k = $O(tResults(""))
			While (k'="") {
				Set tCount = tCount + 1
				Set tLabel = $LG(tResults(k),1)
				Set tURL = $LG(tResults(k),2)
				Set tTitle = $LG(tResults(k),3)
				Set tCls = $S(tCount#2:"rowOdd",1:"rowEven")

				&html<<tr class="#(tCls)#"><td><a id="sbdd_#(tCount-1)#" class="sdLink" title="#($ZCVT(tTitle,"O","HTML"))#" href="#(tURL)#" searchValue="#($ZCVT(tLabel,"O","HTML"))#" >#($ZCVT(tLabel,"O","HTML"))#</a></td></tr>>
				Set k = $O(tResults(k))
			}
			&html<</table>>
		}
		If (tCount = 0) {
			Write "<span style=""color:#606060;font-size:10pt;""><i>",$$$TextHTML("No items found"),"</i></span>"
		}

		&html<</div>>
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Generic method to get a cookie value. cookieName is the name, e.g. "state", cookieString is document.cookie.
ClientMethod getCookieValue(cookieName, cookieString) As %String [ Language = javascript ]
{
	var startLoc = cookieString.indexOf(cookieName);
	if (startLoc == -1) return("");  // No such cookie
	var cookieArray = cookieString.split("; ");
	var returnValue = "";
	for (var n=0; n < cookieArray.length; n++) {
		startLoc = cookieArray[n].split("=");
		if (startLoc[0] == cookieName) {
			returnValue = startLoc[1];
			break;
		}
	}
   	return returnValue;
}

/// Generic method to set a cookie name and value pair.<br>
/// The expiration date is set to 1 year from now 
ClientMethod setCookieValue(cookieName, cookieValue) As %String [ Language = javascript ]
{
	let date = new Date(Date.now() + (86400e3 * 365));
	date = date.toUTCString();
	var expires = '; expires=' + date + ';'
	document.cookie = cookieName + "=" + cookieValue + ";path=/;" + expires;
}

/// Draw the contents of the title area.
/// Dispatch to application class.
Method DrawHSTitle(pSeed As %String) As %Status [ Final ]
{
	Set tSC = $$$OK
	Try {
		If $IsObject($G(%application)) {
 			i $ZS<$$$MAXBBSZ { d $ZU(163,$$$MAXBBSZ) }
 			Set tTitle=$$$Text("Welcome")_", "_$UserName
			Set tSC = %application.DrawHSTitle(tTitle,"Portal",..ManageEnsemble)
		}
		Else {
			&html<No Application Defined for Page!>
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// This method rebuilds context menu on the top left corner.
Method BuildMenu() As %Status
{
	#; Set the homePage and aboutPage links properly
	Set %page.aboutPage = ##class(%CSP.Page).Link("/csp/sys/UtilSysHome.csp")
	Set %page.homePage = ##class(%CSP.Page).Link(..#HOMEPAGE)
	Quit $$$OK
}

/// Go to the home page.
ClientMethod goMenu(link) [ Language = javascript ]
{
	self.document.location = link;
	return false;
}

/// Go to the home page.
ClientMethod showAbout() [ Language = javascript ]
{
	self.document.location = this.aboutPage;
	return false;
}

/// End the current session.
ClientMethod logout() [ Language = javascript ]
{
	this.DoLogout();
	this.goHome();
	return false;
}

ClassMethod DoLogout() As %Boolean [ ZenMethod ]
{
	// Logout removes the security context from the session and cleans up login and security token cookies.
	// It calls OnLogout() and leaves the session in existence. 
	Do %session.Logout()
	// Causes OnEndSession() to be called and the session is destroyed
	Set %session.EndSession=1
	Quit 1
}

/// Return the height of the title area (titleBar plus locator).
ClientMethod getTitleAreaHeight() [ Language = javascript ]
{
	var hgt = 0;
	try {
		var titleDiv = zen('title').getEnclosingDiv();
		// var locDiv = zen('locatorBar').getEnclosingDiv();
		var ribbonDiv = zen('toolRibbon').getEnclosingDiv();
		
		// hgt = titleDiv.offsetHeight + locDiv.offsetHeight + ribbonDiv.offsetHeight;
		hgt = titleDiv.offsetHeight + ribbonDiv.offsetHeight;
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in getTitleAreaHeight.');
	}
	
	return hgt;
}

/// Change the current display mode for this page.
/// This is called by the icon buttons on the ribbon.
/// This will call the <method>setViewModeHandler</method> within a subclass.
ClientMethod setViewMode(mode) [ Language = javascript ]
{
	if (mode != this.currViewMode) {
		// update icon
		var el = self.document.getElementById('view_'+this.currViewMode);
		if (el) {
			el.className = 'viewIcon';
		}
		var oldmode = this.currViewMode;
		this.currViewMode = mode;
		var el = self.document.getElementById('view_'+this.currViewMode);
		if (el) {
			el.className = 'viewIconSelected';
			el._oldClass = 'viewIconSelected';
		}
		
		this.setViewModeHandler(mode,oldmode);
	}
}

/// Do the actual work of updating the view to match the current view mode.
ClientMethod setViewModeHandler(mode, oldmode) [ Language = javascript ]
{
	// update finder
	var finder = zen('finder');
	if (finder) {
		finder.setViewType(this.currViewMode);
		//save viewMode to cookie
		this.setCookieValue('viewMode',this.currViewMode);
	}
	this.showSearchResults(false);
}

/// Change the current sort mode for the page.
ClientMethod setSortMode(mode) [ Language = javascript ]
{
	if (mode != this.currSortMode) {
		var el = self.document.getElementById('sort_'+this.currSortMode);
		if (el) {
			el.className = 'ribbonSortOption';
		}
		this.currSortMode = mode;
		var el = self.document.getElementById('sort_'+this.currSortMode);
		if (el) {
			el.className = 'ribbonSortOptionSelected';
		}
		this.setSortModeHandler(mode);
	}
}

/// Start all Productions.
ClientMethod startProductions() [ Language = javascript ]
{
	if (confirm($$$Text('Do you wish to start all Productions?'))) {
		zenPage.updateProductions('start');
	}
}

/// Stop all Productions.
ClientMethod stopProductions() [ Language = javascript ]
{
	if (confirm($$$Text("Do you wish to stop all Productions?"))) {
		zenPage.updateProductions('stop');
	}
}

ClientMethod updateProductions(action) [ Language = javascript ]
{
	var parms = {
			ACTION: action
	};
	zenLaunchPopupWindow('HS.UI.StartStop.cls','UpdateProduction','status,scrollbars,resizable=yes,width=1000,height=700',parms);
}

/// Add any customized menu options for a product
Method AddProductsMenu(args...)
{
	Set tSC = $$$OK
	Set tConfigItem = ##class(HS.Util.Installer.ConfigItem).%OpenId($namespace,0,.tSC)
	If $$$ISERR(tSC) {
		Quit tSC
	}
	Set tKey = ""
	For {
		Set tProduct = tConfigItem.Products.GetNext(.tKey)
		If (tKey = "") {
			Quit
		}
		If (tProduct = "HSLIB") {
			Set tContext("HSLIB") = 1
			Continue
		}
		Set tMenuClass = tConfigItem.GetUIMenuClass(tProduct)
		Try {
			// At this time, we are not going to require that the class extend HS.HC.Util.AbstractUIMenuClass
			If (tMenuClass '= "") {
				Set tSC = $classMethod(tMenuClass,"addMenu",args...)
			}
		}
		Catch ex {
			Set tSC = ex.AsStatus()
		}
		If $$$ISERR(tSC) {
			Quit
		}
	}
	Quit tSC
}

}
