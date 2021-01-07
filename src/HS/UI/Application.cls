Include (HS.HC, %ZHSLIB, HS.HC.UI.Home)

/// This is the base class for HealthShare UI. Used by Forms and Installer under UI.
Class HS.UI.Application Extends %ZEN.Portal.Application
{

/// This is the name of this application.
Parameter APPLICATIONNAME = "HealthShare UI";

/// URL of home page (used in links).
Parameter HOMEPAGE = "/csp/sys/%25CSP.Portal.Home.zen";

/// Domain used for localization.
Parameter DOMAIN = "HS";

/// This Style block contains application-wide CSS style definitions.
XData Style
{
<style type="text/css">
/*reskin
body {
	font-family: verdana,Tahoma;
}
.portalTitleMenuBox {
	left: 10px;
}

.portalTitleInfoBox {
	position: absolute;
	bottom: 0px;
	left: 500px;
}

.portalTitleLink {
	  font-family: tahoma,arial,verdana;
}
*/
.HSportalTitleLink {
	color: #3b84bc;
	text-decoration: none;
	font-size: 9pt;
	white-space:nowrap;
}
/*
a.link {
	color: blue;
	font-family: tahoma,arial,verdana;
	font-size: 12px;
	text-decoration: none;
}
a.link:visited {
	color: red;
	text-decoration: none;
}
a.link:hover {
	color: #D36D00;
}
a.link:active {
	color: red;
}
*/
.caption {
	color: #3D2423;
	font-size: 12px;
	font-weight: bold;
	padding-right: 5px;
}

.lblNormal {
	color: black;
	font-size: 12px;
	font-weight: normal;
	padding-right: 5px;
}
.zenLabelDisabled
{
	color: gray;
	font-size: 12px;
	font-weight: normal;
	padding-right: 5px;	
}
.text {
	border: 1px solid #77A8D0;
}

.textarea {
	border: 1px solid #77A8D0;
}

.select {
	border: 1px solid #77A8D0;
}

.comboboxInput {
	border-right: 1px solid #77A8D0;
	border-top: 1px solid #77A8D0;
	border-bottom: 1px solid #77A8D0;
}

.comboboxImgButton {
	border: 1px solid #77A8D0;
}

.HSCenterBox {
	color: darkblue;
	background: #D3E1EE;
	border: 1px solid #D3E1EE;
	height: 280px;
	font-size: 1.0em;
	margin:5px;
	padding: 10px;
	width: 400px;	
}
table.HSTitle {
	color: #3D2423;
	background: #77A8D0;
	border-bottom: 1px solid #7D7D7D;
	font-size: 18pt;
	font-weight: normal;	
	margin: 0px;
	padding: 0px;
	width: 100%;
}


/* status div in PatientSearch page */
.searchStatus {
	border: solid #AC7070 1px;
	background: #FF9900;
	font-size: 0.75em;
	padding: 2px;
}

.searchStatusLabel {
	padding-top: 10px;
	font-size: 0.75em;
}
.ltlabel {
	font-size: 0.8em;
	color: #333333;
	text-align: left;
}
a.midnav1, a.midnavC:visited { padding:7px 0 3px 10px; margin:0 0 0 0; text-transform:uppercase; letter-spacing:2px; font-size:11px; font-weight:bold; text-decoration:none; display:block;background:#CCCCCC; color:#666666; text-align:left; vertical-align:middle;}
a.midnav1:hover{ background:#FF9933; text-decoration:none; color:#FFFFFF;}
a.midnav2, a.midnavR:visited { padding:7px 0 3px 10px; margin:0 0 0 0; text-transform:uppercase; font-size:11px; letter-spacing:2px; font-weight:bold; text-decoration:none; display:block;background:#CCCCCC; color:#666666; text-align:left; vertical-align:middle;}
a.midnav2:hover{ background:#99CC33; text-decoration:none;  color:#FFFFFF;}
a.midnav3,a.midnavD:visited{ padding:7px 0 3px 10px; margin:0 0 0 0; text-transform:uppercase; font-size:11px; letter-spacing:2px; font-weight:bold; text-decoration:none; display:block;background:#CCCCCC; color:#666666; text-align:left;  vertical-align:middle;}
a.midnav3:hover{ background:#99CCFF; text-decoration:none; color:#FFFFFF;}

.expandoNode {
	width: 700;
	padding: 4px; 
	padding-bottom: 6px;
	font-size: 12px;
	font-weight: bold;
	background: url(images/expando_header.gif) repeat-x left bottom;
}
.expandoNode a {
	color: #FFFFFF;
	border: none;
	font-size: 12px;
	text-decoration: none;
}
.expandoNode a:hover {
	color: #FF9933;
	border: none;
	font-size: 12px;
	text-decoration: none;
}

.headerlink {
	background: transparent;
	border:none;
	font-size: 12px;	
}

.zenLabel,.radioSetSpan {
	color: #3D2423;
	font-size: 12px;
	font-weight: bold;
	padding-left: 5px;
	padding-right: 5px;
}
.radioSetSpan {
	font-weight: normal;
}
a.radioButtonCaption {
font-size: 0.9em;	
}
/* Customized table styles */
table.tpTable {
	background: white;
	border: 1px solid black;
	width: 100%;
	font-size: 0.9em;
	
}

/* column header (th) */
table.tpTable th {
	border-right: 1px solid gray;
	border-bottom: 1px solid gray;
	background: #E1C07D;
	color: black;
	font-weight: bold;
	text-align: left;
	padding: 2px;
}

/* selected column header (th) */
table.tpTable th.tpHdrSelected {
	background: #00A0EE;
}

table.tpTable td {
	border-right: 1px solid gray;
	border-bottom: 1px solid gray;
	padding: 2px;
}

table.tpTable tr.tpSelected td {
	border-top: 1px solid black;
	border-bottom: 2px solid black;
	padding-top: 1px;
	padding-bottom: 1px;
}

/* this is a normal, unselected row */
table.tpTable tr {
	color: black;
	white-space: nowrap;
	font-size: 0.9em;
}

/* this is a selected row */
table.tpTable tr.tpSelected {
	background: #FFFF80;
	color: black;
}
/* style for odd-rows when using zebra styling */
.tpOdd {
}

/* style for even-rows when using zebra styling */
.tpEven {
	background: #E6E4D8;
}
.warningBox {
	border: solid #AC7070 1px;
	background: #FF9900;
	font-size: 0.75em;
	padding: 2px;
	width: 520px;
	display: block;
}
#formGroup {
	border: 1px solid black;
	padding: 4px;
	background: #C0C0C0;
	background-image: url(images/grad-halfgray-10x500.png);
	background-repeat: repeat-x;
}

</style>
}

/// If pSeed is null, then no title and help link will be shown
Method DrawTitle(pTitle As %String, pShowLogout As %Boolean = 1, pShowInfo As %Boolean = 1, pShowAccount As %Boolean = 1, pShowHSHelp As %Boolean = 1) As %Status
{
	Quit ..DrawHSTitle(pTitle,"",1, pShowInfo,pShowAccount,1,pShowHSHelp)
}

/// prepare necessary arrays for calling SMP's standard header method
Method DrawStandardTitle(pTitle, pSourcePage As %String = "", pManageEnsemble As %Boolean = 0, pShowInfo As %Boolean = 1, pShowAccount As %Boolean = 1, pShowSmallMenu As %Boolean = 1) As %Status
{
	// Setup product logo for HealthShare	
	Set tProduct = "HealthShare"	
	If $$$EnsMajorVersion_$$$EnsMinorVersion < 20172 {
		Set tProductLogo = "portal/" _ tProduct _ "_Logo.png"
	}
	Else {
		Set tProductLogo = "portal/InterSystems IRIS.png"
		If ##class(%ZHSLIB.HealthShareMgr).InstanceType() '= $$$HSisIRISforHealth {
			Set tProductLogo = "portal/HealthShareLogo210x50.png"
		}
	}
	Set tServerName = $$$HSNetworkHostName
	#if $$$HSDebug
		Set tServerName = tServerName_":"_%session.SessionId
	#endif	

	If pShowSmallMenu {
		Do ..%OnGetSmallMenu(pSourcePage,pManageEnsemble,.tSmallMenu)
	}
	Set tSC = ##class(%ZEN.Portal.Application).%DrawTitleHTML(tProduct_"^"_tProductLogo_"^"_tServerName,pTitle,.tSmallMenu,.tLocatorMenu)
	
	Set tLink=%request.URL
	&html<<label id="idHSLogout" style="display: none;">#(tLink)#</label>>
	Quit $$$OK
}

/// kept for reference for upgrading customers
Method OldDrawTitle(pSeed As %String, pShowLogout As %Boolean = 1, pShowInfo As %Boolean = 1, pShowAccount As %Boolean = 1) As %Status
{
	Set LOGOUTIMAGE = ##class(%CSP.Page).Link("/csp/hslib/images/HS_Icon_Logout.gif")	
	Set HELPIMAGE = ##class(%CSP.Page).Link("/csp/hslib/images/HS_Icon_Help.gif")
	Set LOGOIMAGE = ##class(%CSP.Page).Link("/csp/hslib/images/logo-healthshare.jpg")
	Set InstanceName = $P($zu(86),"*",2)
	Set ServerName = $$$HSNetworkHostName
	#if $$$HSDebug
		Set ServerName = ServerName_":"_%session.SessionId
	#endif	
	Set cmdServer = $$$TextHTML("Server")
	Set cmdInstance = $$$TextHTML("Instance")
	Set cmdNamespace = $$$TextHTML("Namespace")
	Set cmdUser = $$$TextHTML("User")
	Set cmdLogX = $$$TextHTML("Logout")
	Set cmdShow = $$$TextHTML("Show Connection Details")
	Set cmdHide = $$$TextHTML("Hide Connection Details")
	Set cmdAccount = $$$TextHTML("My Account")
	Kill tQuery Set tQuery("FROM")=%request.URL
	Set accountURL = $$$HSUILink("Registry\User\Individual","HS.UI.Registry.User.Individual.cls")
	Set logXURL = ##Class(HS.UI.Util).GetLoginLink(%request.URL)
	&html<<div class="portalTitle">>
	&html<<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
	<td align="left"><img width="300" height="75" src="#(LOGOIMAGE)#" /></td>
	<td width="50%" align="left">
	<div>#($ZCVT(pSeed,"O","HTML"))#</div></td>>
	//&html<<td align="right"><a href="http://www.intersystems.com/index.html" class="link" ><img src="#(HELPIMAGE)#" alt="Help" alt="Help" width="20" height="20" border="0">Help</a></td>>

	&html<<td width="100%" align="right" valign="center" nowrap>>
	If pSeed '= "" {
		&html<<table cellspacing="2"><tr><td align="right"><table>>
		If pShowLogout {
			&html<<tr><td><a href="#(logXURL)#" class="link" ><img src="#(LOGOUTIMAGE)#" alt="Logout" width="20" height="20" border="0" >#(cmdLogX)#</a>&nbsp;&nbsp;</td></tr>>
		}
		If pShowAccount,$namespace'="HSLIB" {
			&html<<tr><td><a href="javascript:zenLaunchPopupWindow('#(accountURL)#','EditUser','modal=no,width=1210,height=630');" class="link" >#(cmdAccount)#</a></td></tr>>
		}
		If pShowInfo {
			&html<<tr><td><a id="idShowConnectionDetails" class="connectionlink" onclick="document.getElementById('idConnectionInfo').style.display='inline';document.getElementById('idShowConnectionDetails').style.display='none';document.getElementById('idHideConnectionDetails').style.display='inline'">#(cmdShow)#</a>
			<a id="idHideConnectionDetails" style="display:none" class="connectionlink" onclick="document.getElementById('idConnectionInfo').style.display='none';document.getElementById('idShowConnectionDetails').style.display='inline';document.getElementById('idHideConnectionDetails').style.display='none'">#(cmdHide)#</a></td></tr>>
		}
		&html<</table>>
		If pShowInfo {
			&html<<td id="idConnectionInfo"  style="display:none"><table><tr><td>>
			&html<<span style="color:white; font-size:8pt; padding-right:5px;">#(cmdNamespace)#:</span></td>
			<td><div class="ltlabel"><b>#($namespace)#</b></div></td>
			<td align="right"><span style="color:white; font-size:8pt; padding-right:5px;">#(cmdServer)#:</span>
			<td><div class="ltlabel"><b>#(ServerName)#</b></div></td>		
			</tr>
			<tr><td align="right"><span style="color:white; font-size:8pt; padding-right:5px;">#(cmdUser)#:</span>
			<td><div class="ltlabel"><b>#(%session.Username)#</b></div></td>
			<td align="right"><span style="color:white; font-size:8pt; padding-right:5px;">#(cmdInstance)#:</span>
			<td><div class="ltlabel"><b>#(InstanceName)#</b></div></td>
			</tr></table>
			>
		}
		&html<
		</tr>
		</table>>
	}

    &html<
    <td width="20">&nbsp;</td></tr>
	</table></div>>
	Quit $$$OK
}

/// Draw the HTML contents of the title area for portal pages.
Method DrawHSTitle(pTitle, pSourcePage As %String = "", pManageEnsemble As %Boolean = 0, pShowInfo As %Boolean = 1, pShowAccount As %Boolean = 1, pShowSmallMenu As %Boolean = 1, pShowHSHelp As %Boolean = 1) As %Status
{
	Set tVersion = $$$EnsMajorVersion_$$$EnsMinorVersion
	If (tVersion > 20191) {
		Quit ..DrawStandardTitle(pTitle,pSourcePage,pManageEnsemble,pShowInfo,pShowAccount,pShowSmallMenu)
	}
	/* below is the original code for drawing HSTitle for kits prior to 2019.2's SMP reskin (need to reset some of the css back to the original)*/
	&html<
	<style type="text/css">
	.portalTitleMenuBox {
		left: 10px;
	}
	.portalTitleInfoBox {
		position: absolute;
		bottom: 0px;
		left: 500px;
	}
	#searchDiv {
		top: 80px;
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
	</style>
	>
	Set LOGOUTIMAGE = ##class(%CSP.Page).Link("/csp/hslib/images/HS_Icon_Logout.gif")	
	Set HELPIMAGE = ##class(%CSP.Page).Link("/csp/hslib/images/HS_Icon_Help.gif")
	Set LOGOIMAGE = ##class(%CSP.Page).Link("/csp/hslib/images/logo-healthshare.jpg")
	Set InstanceName = $P($zu(86),"*",2)
	Set ServerName = $$$HSNetworkHostName
	#if $$$HSDebug
		Set ServerName = ServerName_":"_%session.SessionId
	#endif	
	Set cmdServer = $$$TextHTML("Server")
	Set cmdInstance = $$$TextHTML("Instance")
	Set cmdNamespace = $$$TextHTML("Namespace")
	Set cmdUser = $$$TextHTML("User")
	Set cmdLogX = $$$TextHTML("Logout")
	Set cmdShow = $$$TextHTML("Show Connection Details")
	Set cmdHide = $$$TextHTML("Hide Connection Details")
	Set cmdAccount = $$$TextHTML("My Account")
	Kill tQuery Set tQuery("FROM")=%request.URL
	Set accountURL = $$$HSUILink("Registry\User\Individual","HS.UI.Registry.User.Individual.cls")
	Set tProduct=$$$Text("HealthShare")
	Set tUserName = $UserName
	
	Set tSystemMode = $G(^%SYS("SystemMode"))
	Set tSystemStyle = ""
	Set tSystemMsg = ""
	If (tSystemMode = "LIVE") {
		Set tSystemMsg = $$$TextHTML("This is a Live System")
		Set tSystemStyle = "text-align: center; background: red; color: white; font-size:12pt; padding:2px; border: 1px solid #404040;"
		Set:%page.cssLevel'=3 tSystemStyle = tSystemStyle_" -moz-border-radius: 5px;"
	}
	ElseIf (tSystemMode = "TEST") {
		Set tSystemMsg = $$$TextHTML("This is a Test System")
		Set tSystemStyle = "text-align: center; background: #D0D0D0; color: #404040; font-size:12pt; padding:2px; border: 1px solid #404040;"
		Set:%page.cssLevel'=3 tSystemStyle = tSystemStyle_" -moz-border-radius: 5px;"
	}
	ElseIf (tSystemMode = "DEVELOPMENT") {
		Set tSystemMsg = $$$TextHTML("This is a Development System")
		Set tSystemStyle = "text-align: center; color: #404040; font-size:10pt; padding:2px;"
	}
	ElseIf (tSystemMode '= "") {
		// show value as a string
		Set tSystemMsg = $ZCVT(tSystemMode,"O","HTML")
		Set tSystemStyle = "text-align: center; color: #404040; font-size:10pt; padding:2px;"
	}
	
	// Setup product logo for HealthShare	
	Set tProduct = "HealthShare"
	If $$$EnsMajorVersion_$$$EnsMinorVersion < 20172 {
		Set tProductLogo = "portal/" _ tProduct _ "_Logo.png"
	}
	Else {
		Set tProductLogo = "portal/InterSystems IRIS.png"
		If ##class(%ZHSLIB.HealthShareMgr).InstanceType() '= $$$HSisIRISforHealth {
			Set tProductLogo = "portal/HealthShareLogo210x50.png"
		}
	}
	
	&html<<div class="portalTitle">> 
	#; place holder for menu
	If pShowSmallMenu {
		#; small menu
		Do ..%OnGetSmallMenu(pSourcePage,pManageEnsemble,.tSmallMenu, pShowHSHelp)
		Do ..%DrawSmallMenu(.tSmallMenu, "")
		Set tLink=%request.URL
		&html<<label id="idHSLogout" style="display: none;">#(tLink)#</label>> 
	}
	Set tTitleText = pTitle
	Set msgInstance = $ZCVT($ZV,"O","HTML")
	#; handle long names
	Set tTitleStyle = ""
	If ($L(tTitleText)>28) {
		// smaller font
		Set tTitleStyle = "style=font-size:12px;"
	}
	If ($L(tTitleText)>100) {
		// aaa...bbb
		Set tTitleText = $ZSTRIP($E(tTitleText,1,40),"<>W")_"..."_$ZSTRIP($E(tTitleText,$L(tTitleText)-40,$L(tTitleText)),"<>W")
	}
	&html<
	<div class="portalTitleTabBox" #(tTitleStyle)# id="titleTab" title="#($ZCVT(pTitle,"O","HTML"))#">#($ZCVT(tTitleText,"O","HTML"))#<span id="modifiedIndicator">&nbsp;</span></div>

	<div class="portalTitleInfoBox">>
	
	&html<<table cellspacing="2"><tr><td align="right"><table height="50">>
	If pShowAccount,$namespace'="HSLIB", $G(%session.Data("LoginID"))'="" {
		&html<<tr><td><a href="javascript:zenLaunchPopupWindow('#(accountURL)#','EditUser','modal=no,width=1210,height=630');" class="HSportalTitleLink" >#(cmdAccount)#</a></td></tr>>
	}
	If pShowInfo {
		&html<<tr><td><table>>
		&html<<tr><td><a id="idShowConnectionDetails" class="HSportalTitleLink" onclick="document.getElementById('idConnectionInfo').style.display='inline';document.getElementById('idShowConnectionDetails').style.display='none';document.getElementById('idHideConnectionDetails').style.display='inline'">#(cmdShow)#</a>
		<a id="idHideConnectionDetails" style="display:none" class="HSportalTitleLink" onclick="document.getElementById('idConnectionInfo').style.display='none';document.getElementById('idShowConnectionDetails').style.display='inline';document.getElementById('idHideConnectionDetails').style.display='none'">#(cmdHide)#</a></td></tr>>
		&html<</table></td><td align="left" colspan="4" nowrap="1" class="portalTitleInfoVal" style="#(tSystemStyle)#">#(tSystemMsg)#</td></tr>>
	}
	&html<</table>>
	If pShowInfo {
		&html<<td><div id="idConnectionInfo"  style="display:none"><table><tr><td>>
		&html<<span style="color:#808080; font-size:8pt; padding-right:5px;">#(cmdNamespace)#:</span></td>
		<td><div class="ltlabel"><b>#($namespace)#</b></div></td>
		<td align="right"><span style="color:#808080; font-size:8pt; padding-right:5px;">#(cmdServer)#:</span>
		<td><div class="ltlabel"><b>#(ServerName)#</b></div></td>		
		</tr>
		<tr><td align="right"><span style="color:#808080; font-size:8pt; padding-right:5px;">#(cmdUser)#:</span>
		<td><div class="ltlabel"><b>#(%session.Username)#</b></div></td>
		<td align="right"><span style="color:#808080; font-size:8pt; padding-right:5px;">#(cmdInstance)#:</span>
		<td><div class="ltlabel"><b>#(InstanceName)#</b></div></td>
		</tr></table></div></td>
		>
	}
	&html<
	</tr>
	</table>	
	</div>>
	
	&html<<div class="portalLogoBox">
		<img class="portalLogo" src='#(tProductLogo)#' title='#($$$Text("Powered by Zen"))#' alt='#(tProduct)#'></img>>
	
	&html<</div>>
	Quit $$$OK
}

/// Get the contents of the small menu in the title area.
Method %OnGetSmallMenu(pSourcePage As %Boolean = 0, pManageEnsemble As %Boolean = 0, Output pMenu, pShowHSHelp As %Boolean = 1)
{
	// $LB(caption,title,script)
 	Set tIsHealthShareInstance = ##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance()
    Set tHome = $S(tIsHealthShareInstance:"HS.UI.Home.cls",1:"HS.HC.UI.Home.cls")
	If 'tIsHealthShareInstance {
		Set tMenu1 = $$$TextHTML("Health")
		Set tMenu2 = $$$TextHTML("Interoperability")
		Set tHint = $$$TextHTML("Go to Health Management")
	} Else {
		Set tMenu1 = $$$TextHTML("HealthShare Management")
		Set tMenu2 = $$$TextHTML("Productions")
		Set tHint = $$$TextHTML("Go to the HealthShare Management Portal")
	}	
	Set tI=0, tPortalURL=$$$HSUILink("Home",tHome)
	Set tHQuery("CSPSHARE") = 1
	Set tHQuery("$NAMESPACE")=$S($Roles["%All":$namespace,1:"%SYS"),tHomeLink=##class(%CSP.Page).Link(..#HOMEPAGE,.tHQuery)
	Set:$SYSTEM.Security.Check("%Admin_Manage","USE") pMenu($I(tI)) = $LB($$$Text("Home"),$$$Text("Go to the System Home page"),"document.location='"_tHomeLink_"';")
	If ##class(%ZHSLIB.HealthShareMgr).GetHealthShareNamespaceType()'="" {
		Set tQuery("CSPSHARE") = 1
		Set tURL=..Link("/csp/healthshare/"_tPortalURL)
		Set pMenu($I(tI)) = $LB(tMenu1,tHint,"document.location='"_tURL_"';")
		If pSourcePage="Portal"&&'pManageEnsemble {
			If $SYSTEM.Security.Check("%Ens_Portal","USE") {
				Set tQuery("$ENSEMBLE") = 1
				Set tEnsLink =..Link(tPortalURL,.tQuery)
				Set pMenu($I(tI)) = $LB(tMenu2,tMenu2,"document.location='"_tEnsLink_"';")
			}
		} Else {
			Set tLink=tPortalURL
			Set pMenu($I(tI)) = $LB($Namespace_" "_$$$Text("Management"),$Namespace_" "_$$$Text("Management"),"document.location='"_tLink_"';")
		}
	} Else {
		IF pSourcePage="Installer"||(pSourcePage="Annotations") {
			Set tURL=..Link("/csp/healthshare/"_tPortalURL)
			Set pMenu($I(tI)) = $LB(tMenu1,tHint,"document.location='"_tURL_"';")
		}
		Set tLink=..Link($S(tIsHealthShareInstance:"HS.UI.Installer.Welcome.cls",1:"HS.HC.UI.Installer.Welcome.cls"))
		If $SYSTEM.Security.Check("%HSAdmin_InstallationManagement","USE") {
			//installer wizard not available on non-primary mirror member, unless HSSYS isn't yet mirrored
			If $system.Mirror.IsMember(),'$system.Mirror.IsPrimary(),..IsHSSYSMirrored() {
				//
			} Else {
				Set pMenu($I(tI)) = $LB($$$Text("Installer Wizard"),$$$Text("Use the Installer Wizard to configure components"),"document.location='"_tLink_"';")
			}
			If tIsHealthShareInstance && $system.Mirror.IsMember() {
				Set tLink=..Link("HS.UI.MirrorMonitor.cls")
				Set pMenu($I(tI))=$LB($$$Text("Mirror Agent Monitor"),$$$Text("Monitor the mirrored installation steps"),"document.location='"_tLink_"';")
			}
		}
		 
	}
	Set tAboutLink=..Link("_CSP.UI.Portal.About.zen")
	Set pMenu($I(tI)) = $LB($$$Text("About"),$$$Text("Display the About page"),"document.location='"_tAboutLink_"';")
	//Set tHelpLink=..Link("/csp/docbook/DocBook.UI.HomePageZen.cls")
	//Set pMenu($I(tI)) = $LB($$$TextHTML("Help"),$$$TextHTML("Display help for this page"),"window.open('"_tHelpLink_"','HelpWindow');")
	
	// If it's not HealthShare, show the Help link. Otherwise, we check the pShowHSHelp argument. 
	// In other words, we only hide it if a) it's HealthShare and b) we were told to hide it. 
	If (('tIsHealthShareInstance)||(pShowHSHelp)) {
		Set pMenu($I(tI)) = $LB($$$Text("Help"),$$$Text("Display help for this page"),"zenPage.showHelp();")
	}
	Set logXURL = ##Class(HS.UI.Util).GetLoginLink(%request.URL)
	
	// for onclick, before redirecting to HS.UI.Logout page, clear browser session storage, which is neccesary for child applications using session storage
	Set pMenu($I(tI)) = $LB($$$Text("Logout"),$$$Text("End this session"),"window.sessionStorage.clear();document.location='"_logXURL_"';")
}

ClassMethod IsHSSYSMirrored() As %Boolean
{
	New $Namespace Set $Namespace = "%SYS"
	Try {
		Set tRS = ##class(%ResultSet).%New()
		Set tRS.ClassName = "SYS.Mirror"
		Set tRS.QueryName = "MirroredDatabaseList"
		Set tSC = tRS.Execute("HSSYS")
		$$$ThrowOnError(tSC)
		Set tFound = 0
		If tRS.Next(.tSC) {
			Set tFound = 1
		}
		$$$ThrowOnError(tSC)
		Set tSC = tRS.Close()
		$$$ThrowOnError(tSC)
	} Catch ex {
		Set tFound = 0
	}
	Quit tFound
}

Method DrawCopyright(p As %String) As %Status
{
	&html<<br><br><br>>
	Set years = "1996-" _ $E($ZDT($H,3),1,4)
	Set msgCopyright = $$$TextHTML("Copyright")
	Set msgAllRights = $$$TextHTML("All Rights Reserved.")
	&html<<div align="center" id="footer">
	<a href="http://www.intersystems.com/index.html">
    <font color="#004459">www.InterSystems.com</font></a><br>
 	<a href="http://www.intersystems.com/copyright/index.html"><font color="#333333">&copy; #(msgCopyright)#</font></a> #(years)# InterSystems Corporation. #(msgAllRights)#<br>
  	</div>
	>
	Quit $$$OK
}

/// Subclass can implement this method to return their own search class for HS.Viewer.DefaultSearch
Method GetSearchClass() As %String
{
	Quit ""
}

/// Subclass can implement this method to return their own search class for HS.Viewer.PatientSearch
Method GetPatientSearchClass() As %String
{
	Quit ""
}

/// This will only be used in 2011.1+.  Added per Yan
/// Provide finder contents for the HealthShare pages. Called from %CSP.Portal.Home.
ClassMethod GetHealthShareArray(Output pData) As %Status
{
    //Set pMetaData = $LB("name","title","link","disabled","icon","description")
    Set tDisabled = 0
    Set tHome = $S(##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance():"HS.UI.Home.cls",1:"HS.HC.UI.Home.cls")
    Set pData($I(n)) = $LB($$$Text("HealthShare Management Portal"),,$$$HSUILink("Home",tHome),tDisabled,"portal/architect_48.gif",$$$Text("Goto HealthShare Management Portal home page"))
	Quit $$$OK
}

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	Quit ##class(HS.UI.BaseCSP).OnPreHTTP()
}

}
