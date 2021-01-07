/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include %products

/// Base class for generic InterSystems IRIS Interoperability pages.<br/>
/// This is used for pages that do fit into one of the other base class
/// categories.
Class EnsPortal.Template.standardPage Extends (%CSP.Portal.Template, EnsPortal.Template.base) [ Abstract, System = 4 ]
{

Parameter JSINCLUDES = "zenMenusSMPEns.js";

// ZHJ037: SMP Reskin - Menu Style Overriden for Interoperability Pages

Parameter DOMAIN = "Ensemble";

/// Do not switch namespace for the page based on $NAMESPACE; will stay in the original namespace.
Parameter AUTONS As %Boolean = 0;

/// Set this to the appropriate application class.
Parameter APPLICATION = "EnsPortal.Application";

/// favorite icon.
Parameter FAVORITEICON As COSEXPRESSION = "$$$ISCFAVORITEICON";

/// Resource for subclasses to indicate whether further resources are needed to perform actions on pages.
Parameter EDITRESOURCE;

/// The help address that links to the "Help" (next to the "Logout" link) documentation
Property HelpAddress As %ZEN.Datatype.string [ InitialExpression = {$select(..#PAGENAME '= "": "Ensemble, "_..#PAGENAME, 1: "")} ];

/// Flag to indicate whether the user is permitted to make any changes on a given page.
Property canEdit As %ZEN.Datatype.boolean [ InitialExpression = {##class(EnsPortal.Utils).CheckResourceList(..#EDITRESOURCE)} ];

/// Message to inform the user they may not perform a given action.
Property msgNotPermitted As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("You are not permitted to perform this action")} ];

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
.zenLabel {
	color: rgb(67,67,67);
	font-size: 10pt;
}
.zenHint {
	color: rgb(67,67,67);
	font-size: 8pt;
}
.detailLabel {
	font-weight: bold;
	color: rgb(71,72,67);
	font-size: 10pt;
}

#zenBody {
	background: white;
}
#editorPane {
	position: relative;
	padding-left:4px;
	border-bottom:1px solid black;
}
#propertyPane {
	position: relative;
	background: #edece4;
	height: 449px;
	width: 400px;
	border: 1px solid rgb(156,154,141);
	border-bottom: 1px solid black;
}

#propertyTitle {
	background:rgb(156,154,141);
	color: white;
}

#propertyCommands {
	color: white;
}

.helpCommand {
	text-decoration: none;
	color: white;
	font-size: 9pt;
}

.helpCommand:hover {
	text-decoration: none;
	color: darkred;
}
/* generic button style*/
.button {
	background-color: #346C8D;
	color: #E0E0E0;
	font-size: 9pt;
}
.button:hover {
	color: white;
	background: #808080;
}

.helpArrow {
	font-size:18pt;
	color:white;
	padding-left: 4px;
	padding-right: 4px;
	background: rgb(53,107,141);
}

#helpPane {
	position: relative;
	background: white;
	height: 449px;
	width: 300px;
	border-right: 1px solid black;
	border-bottom: 1px solid black;
	display: none;
	overflow-x: hidden;
	overflow-y: auto;
}
.hdrLink {
	font-size: 10pt;
	font-weight: normal;
	color: #78b6dc;
	text-decoration: none;
	padding-left: 6px;
	padding-right: 6px;
}

.hdrLinkDisabled {
	font-size: 10pt;
	font-weight: normal;
	color: gray;
	text-decoration: none;
	padding-left: 6px;
	padding-right: 6px;
}

.hdrLink:hover {
	color: orange;
}

/* styles for tabs */
td.tabGroupButtonOff:hover {
	color: #FFEEAA;
}

.tabGroupBody {
	background: #E0E0D0;
	width: 399px;
	min-height: 100px;
}

td.tabGroupButtonOn {
	height: 30px;
	color: #404040;
	background: #E0E0D0;
	font-size: 10pt;
}

td.tabGroupButtonOn {
background: -moz-linear-gradient(top, #F8F8FF, #E0E0D0);
background: -webkit-linear-gradient(top, #F8F8FF, #E0E0D0);
	background: linear-gradient(top, #F8F8FF, #E0E0D0);
	border-top-left-radius: 4px;
	border-top-right-radius: 4px;
}

/* @doc="Individual tab bar button in Off state." */
td.tabGroupButtonOff,
td.tabGroupButtonDisabled {
	height: 30px;
	color: #404040;
	background: #C0C0C0;
	font-size: 10pt;
	background-image: none;
	background-repeat: repeat-x;
}
td.tabGroupButtonOff:hover {
	background: #C0C0C0;
}

td.tabGroupButtonDisabled {
	color: gray;
}

td.tabGroupButtonOff {
background: -moz-linear-gradient(top, #B0B0B0, #D0D0D0);
background: -webkit-linear-gradient(top, #B0B0B0, #D0D0D0);
	background: linear-gradient(top, #B0B0B0, #D0D0D0);
	border-top-left-radius: 4px;
	border-top-right-radius: 4px;
}

td.tabGroupButtonDisabled {
background: -moz-linear-gradient(top, #B0B0B0, #D0D0D0);
background: -webkit-linear-gradient(top, #B0B0B0, #D0D0D0);
	background: linear-gradient(top, #B0B0B0, #D0D0D0);
	border-top-left-radius: 4px;
	border-top-right-radius: 4px;
}

.tabGroupGap {
	width: 0px;
}

.fullMessageLink {
	font-size: 10pt;
	padding-left: 12px;
	padding-right: 12px;
}
</style>
}

/// Return the array of links to show in the locator bar.<br/>
/// pLink(n)=$LB(caption,link) 
Method %GetLocatorLinks(Output pLink) As %Status
{
	Do ..%GetRootLink(.pLink)

	// default: add *this* page to list
	Set tPageName = ..%OnGetPageName()
	Set tURL = $ZCVT($classname(),"O","URL")_".zen"
	Set pLink(2) = $LB(tPageName,tURL)
	Quit $$$OK
}

Method %GetRootLink(Output pLink) As %Status
{
	Set tPageName = $$$PRODUCT2
	Set pLink($I(pLink)) = $LB(tPageName,..homePage)
}

/// Define any context links for the page. Sub-class to override.
ClassMethod GetContextLinks(Output pLinks) As %Status
{
	Set tSC = $$$OK
	// create list of jump targets and associated URL

	Set pLinks($I(n)) = $LB($$$Text("Monitor"),##class(%CSP.Page).Link("/csp/sys/%25CSP.UI.Portal.EnsembleMonitor.zen"),"")
	Set pLinks($I(n)) = $LB($$$Text("Production"),"EnsPortal.ProductionConfig.zen","")
	Set pLinks($I(n)) = $LB($$$Text("Message Viewer"),"EnsPortal.MessageViewer.zen","")
	Set pLinks($I(n)) = $LB($$$Text("Event Log"),"EnsPortal.EventLog.zen","")
	Set pLinks($I(n)) = $LB($$$Text("Queues"),"EnsPortal.Queues.zen","")
	Set pLinks($I(n)) = $LB($$$Text("Workflow"),"EnsPortal.WFWorklist.zen","")

	Quit ..CheckContextLinks(.pLinks)
}

/// *******************************************************************///
///                  
/// Used to move an item from one listbox to the other. The listboxes are side-by-side.
/// The action moves a list item from one box to the next, then remove it from the original box.
/// This method was originally in CSPX.Portal.Template which is no longer used.
/// 
/// *******************************************************************///
ClientMethod arrowClick(from, to) [ Language = javascript ]
{
	var fromCtl = zenPage.getComponentById(from);
	var currIndex = fromCtl.selectedIndex;
	if ( (currIndex < 0) || (currIndex >= fromCtl.getOptionCount()) ) return;	
	var optionValue = fromCtl.getOptionValue(currIndex);
	var optionText = fromCtl.getOptionText(currIndex);
	var toCtl = zenPage.getComponentById(to);
	toCtl.appendOption(optionValue,optionText);
	
	fromCtl.removeOption(currIndex);
	return optionValue;
}

ClientMethod checkEdit() [ Language = javascript ]
{
	if (!this.canEdit) {
		alert(this.msgNotPermitted);
	}
	return this.canEdit;
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	this.startKeepAlive();
	this.initPopupSuffix();
}

/// Returning from dialogs 
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if (action != "ok") {
		return false;
	}
	popupName = this.removePopupSuffix(popupName);
	switch(popupName) {
		case 'switchNamespace': // change namespace but keep the same page
			zenPage.changeURLNamespace(value);
			break;
	}
	return true;
}

/// The input value is the name of the new namespace to switch to.
/// This method only works for EnsPortal classes whose URL is simple (no URL parameters).
/// This method will need to be overridden for classes such as EnsPortal.EDIDocumentView 
/// which cannot work without a URL parameter provided.
ClientMethod changeURLNamespace(nsVal) [ Language = javascript ]
{
	var newUrl = '';
	var oldUrl = self.document.location.toString();
	var start = oldUrl.indexOf("EnsPortal.");
	if (start >= 0) { // we found the start of the EnsPortal part of the URL
		var end = oldUrl.indexOf("?");
		if (end >= 0) { 
			newUrl = oldUrl.substring(start, end);
		} else {
			newUrl = oldUrl.substring(start);
		}
		var newUrl = zenPage.GetNewURL(nsVal, newUrl);
	//} else { // this is not an EnsPortal class
	}
	if (newUrl == '') newUrl = zenPage.GetNewURL(nsVal);
	self.document.location = newUrl;
}

/// Invoke the base OnPreHyperEvent() method, and then check whether the user
/// is permitted to invoke the specified method by checking the resource returned
/// by the <method>GetHyperEventResources</method> callback.
ClassMethod OnPreHyperEvent(class As %String, method As %String) As %Status [ ServerOnly = 1 ]
{
	Set tSC = ##super(.class,.method)
	If $$$ISERR(tSC) Quit tSC
	
	Set tClass = class
	Set tMethod = method
	If (tClass=$classname()){
		Set tContext = $get(%request.Data("WARG_1",1))
		If (tMethod = "InvokeInstanceMethod") && (tContext = 1) {
			Set tMethod = $get(%request.Data("WARG_2",1))
		}	
		ElseIf (tMethod = "InvokeClassMethod") && (tContext = $classname()) {
			Set tMethod = $get(%request.Data("WARG_2",1))
		}
		If tMethod = "" Set tMethod = method
	}
	Set tResourceList = ..GetHyperEventResources(.tMethod)
	If tResourceList = "" Quit $$$OK
	If '##class(EnsPortal.Utils).CheckResourceList(tResourceList) {
		Set %response.Status = "403 Forbidden"
		Quit $$$ERROR($$$InsufficientPrivilegeForOperation)
	}
	Quit $$$OK
}

/// Callback to return a list of resources required for a specific HyperEvent.
/// The user must have sufficient privileges on one of the resource/permission pairs
/// to be permitted to execute the hyperevent. An empty string implies the user already
/// has sufficient privileges for the ZenMethod specified in <var>pMethod</var>.
ClassMethod GetHyperEventResources(pMethod As %String = "") As %String
{
	Quit ""
}

/// Get the contents of the small menu in the title area.
Method %OnGetSmallMenu(Output pMenu)
{
	// $LB(caption,title,script)
	Set tI=0
	Set pMenu($I(tI)) = $LB($$$TextHTML("Home"),$$$TextHTML("Go to the Home page"),"return zenPage.goHome();")
	If ##class(%Library.EnsembleMgr).IsHealthShareInstalled() {
		Set tURL = ##class(%ZHSLIB.SessionEventUtil).GetHealthSharePortalLink()
		#; Default for HealthShare and other:
		Set tText1 = $$$TextHTML("HealthShare"), tText2 = $$$TextHTML("Go to HealthShare Management")
		#; For IRIS for Health and Health Connect:
		If '##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance() {
			Set tText1 = $$$TextHTML("Health"), tText2 = $$$TextHTML("Go to Health Management")
		}
		Set pMenu($I(tI)) = $LB(tText1,tText2,"document.location='"_tURL_"';")
	}
	Set pMenu($I(tI)) = $LB($$$TextHTML("About"),$$$TextHTML("Display the About page"),"return zenPage.showAbout();")
	Set pMenu($I(tI)) = $LB($$$TextHTML("Help"),$$$TextHTML("Display help for this page"),"return zenPage.showHelp();")
	Set pMenu($I(tI)) = $LB($$$TextHTML("Logout"),$$$TextHTML("End this session"),"return zenPage.logout();")
}

/// Ensure that the user has the required privileges for the Portal application.
ClassMethod %OnPreHTTP() As %Boolean
{
	If '##class(EnsPortal.Application).CheckPrivileges() {
		Set %zenPageError = $$$ERROR($$$AccessDenied)
		Set %zenStatsTime = $zh
		Set %response.Status = "403 Forbidden"
	}
	Quit 1
}

/// Add the EnsException error handling on the client.
Method %OnDrawHTMLHead() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	Quit ..%AddEnsExceptionHandler()
}

/// Override onServerMethodError to funnel HyperEvent errors through the
/// central Ensemble exception handling code.
/// If session pollution occurs while in Studio mode, alert the user to the problem instead of reloading.
/// The method sets zenPage._staleStudioSession to true to ensure that an alert is displayed only once and subsequent
/// hyperevent failures will not trigger a reload of the page.
ClientMethod onServerMethodError(err, errObject) [ Language = javascript ]
{
	if (errObject) {
		if (zenPage && (!zenPage._staleStudioSession) && zenPage.studioMode && ((errObject.serverCode == 5919) || (errObject.serverCode == 5918))) {
			zenPage._staleStudioSession = true;
			alert($$$Text('Your browser session is no longer valid.') + '\n' + $$$Text('Please save changes to any modified documents and restart your IDE to resolve the problem.'));
		}
		if (zenPage && zenPage._staleStudioSession) return true;

		// A session timeout occurred, set the page to unmodified and reload
		if ((errObject.code == 401) && ((errObject.serverCode == 864) || (errObject.serverCode = 5918))) {
			this.setModified(false);
			return false;
		}
		var doAlert = true;
		if ((zenPage.limitPopups)&&(errObject.code<401)) { // check to see if this was refresh timer related
			var refreshRate = 0;
			if (zenPage.keepAliveInterval) {
				refreshRate = zenPage.keepAliveInterval;
			}
			if (zen('chkRefresh') && (!zen('chkRefresh').getValue().match("None"))) {
				if (refreshRate > 0) {
					refreshRate = Math.min(refreshRate,zen('chkRefresh').getValue());
				} else {
					refreshRate = zen('chkRefresh').getValue();
				}
			} else if ((self.document.getElementById('refreshRate')&&(document.getElementById("refreshOn"))&&(document.getElementById("refreshOn").checked))) {
				if (refreshRate > 0) {
					refreshRate = Math.min(refreshRate,self.document.getElementById('refreshRate').value*1000);
				} else {
					refreshRate = self.document.getElementById('refreshRate').value*1000;
				}
			} else if (zenPage.refreshRate && (zenPage.refreshRate > 0)) {  // hard coded value
				if (refreshRate > 0) {
				refreshRate = Math.min(refreshRate,zenPage.refreshRate*1000);
				} else {
					refreshRate = zenPage.refreshRate*1000;
				}
			}
			if (parseInt(refreshRate)) { //page has defined refresh rate
				refreshRate = Math.min(refreshRate,15000);
				zenPage.setConnectivityStatusMsg(err);
				window.setTimeout('zenPage.setConnectivityStatusMsg("Re-trying");',parseInt(refreshRate));
				window.setTimeout('zenPage.testConnectivity();',parseInt(refreshRate));
				doAlert = false;
			}
		}
		if (doAlert) {
			if (errObject.exception && errObject.arguments) {
				EnsException.exceptionHandler(errObject.exception, errObject.arguments, '');
			}
			else {
				if (errObject.code == 403) {
					alert($$$Text('You are not permitted to perform this action'));
				} else { 
					EnsException.hyperEventHandler(errObject,err);
				}
			}
		}
	}
	return true;
}

/// Render the contents trapping for permission issue
ClassMethod OnPage() As %Status
{
	If ($D(%zenPageError)#2) && $$$ISERR(%zenPageError) && $SYSTEM.Status.Equals(%zenPageError,$$$ERRORCODE($$$AccessDenied)) {

		#dim tMessage As %String = $$$TextHTML("Insufficient privileges to access page.")
		&html<<html><body>#(tMessage)#</div></body></html>>
		#; stats
		If (..#SHOWSTATS) {
			Write "<!-- ",$ZH-%zenStatsTime," -->"
		}
		Do %response.Flush()
		Quit $$$OK

	} Else {

		Quit ##super()		
	}
}

/// Overrides super class method to be able to set custom web application if
/// applicable when switching namespace.
ClassMethod GetNewURL(pNS As %String, pPage As %String = "%25CSP.Portal.Home.zen") As %String [ ZenMethod ]
{
	/* Use standard web application if HealthShare or not set custom portal URL */
	If (pPage="")||(pPage["/csp/sys/")||##class(%Library.EnsembleMgr).IsHealthShareInstalled()||($Get(^%SYS("Ensemble","InstalledNamespace",pNS))="") {

		Quit ##super(pNS, pPage)

	}

	#dim tURL As %String
	Set tURL = ##class(%Library.EnsembleMgr).DetermineMgmtURLForNamespace(pNS,0)

	Set tURL = tURL _ pPage
	
	Set tURL = ##class(%CSP.Page).Link(tURL,,1)
	// Strip off $NAMESPACE from existing URL so only one $NAMESPACE will be built into URL.
	Set tquery = $P(tURL,"?",2)
	If tquery '= "" {
		Set tLen = $L(tquery,"&") - 1
		For tI = 1:1:tLen Set p1 = $P(tquery,"&",tI),p2=$P(p1,"=",1),p3=$p(p1,"=",2) if p2'="" s p(p2)=p3
		Set p("$NAMESPACE") = pNS
		Set tquery = ""
		Set p2 = $O(p(""))
		While p2 '= "" {
			Set tquery = tquery _ p2 _ "=" _ p(p2) _ "&"
			Set p2 = $O(p(p2))
		}
		Set tURL = $P(tURL,"?",1) _ "?" _ tquery
	} Else {
		Set tURL = tURL _ "$NAMESPACE="_pNS
	}
	Set %session.Data("$NAMESPACE") = pNS
	Quit tURL
}

}
