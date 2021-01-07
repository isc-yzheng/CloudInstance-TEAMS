Include HS.HC

/// HealthShare Install Wizard.<br/>
/// This is a Studio Wizard that creates or updates the Hub, Edge or Access
///  components of a HealthShare system
Class HS.HC.UI.Installer.Welcome Extends HS.UI.Base
{

Parameter PAGENAME = "Installer Wizard";

/// Security requirement
Parameter RESOURCE = "%HSAdmin_InstallationManagement";

Parameter FAVORITEICON As COSEXPRESSION = "$$$ISCFAVORITEICON";

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
table.HSTitle {
	background: #80C9D1;
	width: 100%;
	padding: 0px;
	border-bottom: 2px solid #D7D3CA;
	font-size: 1.4em;
	text-align: center;
}

.labelTitle {
	color: black;
	font-size: 18px;
	font-weight: bold;
	text-decoration: none;
}
.linkBox {
	border: 1px solid black;
	margin:  5px;
	padding: 5px;
	width: 400px;	
}
.button {
	background: #D3E1EE;
	font-size: 12px;
	padding-bottom: 2px;
	width: 220px;
}
/* table */
#table {
	height: 20.0em;
	overflow: auto;
}
/* column header (th) */
table.tpTable th {
	border-right: 1px solid gray;
	border-bottom: 1px solid gray;
	background: #9CB0C8;
	color: black;
	font-weight: bold;
	text-align: left;
	padding: 2px;
}

.modalGroupBody {
	background: white;
	width: 600px ;
}

</style>
}

/// This page display a welcome message and asks user if they want to start configure
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="#(%page.StdTitle)#">

<html id="titleBar" OnDrawContent="DrawTitle"/>
<spacer height="10"/>

<hgroup align="center">
<label id="idWelcome" label="You may start system configurations by clicking an option below:" hidden="false"/>
<hgroup id="idLicense" hidden="true">
<label label="License is not available. Please install and activate a license first." />
<link id="idLicenseLink" href="/csp/docbook/DocBook.UI.Page.cls?KEY=GSA_license#GSA_license_maintain_key" style="color:#336699;" caption="[Click here for Help.]"/>
</hgroup>
</hgroup>
<spacer height="4"/>
<vgroup id="idContent" align="center" cellAlign="center" groupClass="linkBox">
<button caption="Configure Network Host Name" align="center" onclick="zen('mgNetHost').show('','','',200,300);" title="Click to change the network host name"/>
<button caption="Configure Foundation" enclosingClass="button" align="center" onclick="zenPage.addConfig('Foundation');" title="Click to add a new Configuration"/>
<button caption="Configure SSL Access" align="center" onclick="zen('mgSSLConfig').show('','','',200,300);" title="Click to change the SSL host name, port, or prefix"/>
</vgroup>

<spacer height="4"/>
<modalGroup id="mgNetHost" groupTitle="Configure Network Host Name">
<pane paneName="paneNetHost" cellSize="stretch"/>
</modalGroup>
<modalGroup id="mgSSLConfig" groupTitle="Configure SSL Access">
<pane paneName="paneSSLConfig" cellSize="stretch"/>
</modalGroup>
<vgroup id="id_Table" align="center" containerStyle="padding-left:20px;padding-right:20px;">
<tablePane id="table" caption="The following configurations have been defined"
		  queryClass="HS.Util.Installer.ConfigItem"
		  queryName="Configuration"
		  showQuery="false"
		  showZebra="true"
		  showValueInTooltip="true"
		  valueColumn="ID"
		  multiSelect="false"
		  width="100%"
		  >
		<parameter value="B"/>
		<column colName="ID" hidden="true"/>
		<column colName="Name" width="160"/>
		<column colName="Type" width="120"/>
		<column colName="CreatedAt" header="Create Time" width="130" hidden="false"/>
		<column colName="Description" hidden="true"/>
		<column colName="Disabled" width="80"/>
		<column colName="Production" width="250"/>
		<column colName="Activated" width="80"/>
		<column colName="LastActivated" width="80" hidden="true"/>
		<column linkCaption="Edit" link="javascript:zenPage.editConfig('#(%query.ID)#');" width="60"/>
		<column OnDrawCell="DrawDelete" width="60"/>
		<column id="colActivate" linkCaption="Activate" link="javascript:zenPage.activateConfig('#(%query.ID)#');" width="60"/>
		<condition colName="Activated" predicate="EQ" value="1" targetCol="colActivate" cellStyle="background:red;"/>

</tablePane>
</vgroup>
</page>
}

Method DrawTitle(pSeed As %String) As %Status
{
	Set tTitle = $$$TextHTML("Installer Wizard")
	Set tSC = %application.DrawHSTitle(tTitle,"Installer")
	Quit $$$OK
}

ClassMethod OldDrawTitle(pSeed As %String) As %Status
{
	Set LOGOIMAGE1 = ##class(%CSP.Page).Link("/csp/hslib/images/logo-topl-healthshare_01.gif")
	Set LOGOIMAGE2 = ##class(%CSP.Page).Link("/csp/hslib/images/logo-topl-healthshare_02.gif")
	Set LOGOIMAGE3 = ##class(%CSP.Page).Link("/csp/hslib/images/logo-topl-healthshare_03.jpg")

	&html<
<table class="HSTitle" width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td width="205"><a href="http://www.intersystems.com/index.html"><img src="#(LOGOIMAGE1)#" alt="InterSystems HealthShare" width="205" height="78" border="0"></a></td>
    <td width="185"><a href="http://www.intersystems.com/index.html"><img src="#(LOGOIMAGE2)#" alt="Innovations" width="185" height="78" border="0"></a></td>
    <td width="370"><a href="http://www.intersystems.com/index.html"><img src="#(LOGOIMAGE3)#" alt="Health information exchange platform" width="370" height="78" border="0"></a></td>
    <td width="100%" align="right">
    &nbsp;&nbsp;
    </td>
    <td width="20">&nbsp;</td>
  </tr>
</table>	
	>
	Quit $$$OK
}

ClientMethod addConfig(type, component) [ Language = javascript ]
{
	if(type=="PIHub") {
		var url = "HS.UI.Installer.Config.cls?TYPE=Hub&SUBTYPE=PIHub";
	} else {
		var url = "HS.UI.Installer.Config.cls?TYPE="+type;
	}
	if(component!=null) url=url+"&COMPONENT="+component;
	zenLaunchPopupWindow(url,'InstallWizard','status,scrollbars,resizable,width=800,height=700');
}

ClientMethod activateConfig(id) [ Language = javascript ]
{
	zenLaunchPopupWindow("HS.UI.Installer.Activate.cls?ID="+id,'Activate','status,scrollbars,resizable,width=1000,height=500');
}

/// User clicked Delete
ClientMethod deleteConfig(id) [ Language = javascript ]
{
	zenLaunchPopupWindow("HS.UI.Installer.Delete.cls?ID="+id,'Delete','status,scrollbars,resizable,width=1000,height=500');
}

ClientMethod editConfig(id) [ Language = javascript ]
{
	zenLaunchPopupWindow("HS.UI.Installer.Config.cls?ID="+id,'EditConfig','status,scrollbars,resizable,width=800,height=700');
}

ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	var table = zenPage.getComponentById('table');
	table.refreshTable();
}

Method DrawDelete(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
	// Don't offer to delete generic foundation namespaces - they must be removed manually
	If '..IsGenericFoundation(%query("ID")){
		Write "<a href=""javascript:zenPage.deleteConfig('"_%query("ID")_"')"">"
		Write $$$Text("Delete")
		Write "</a>"
	}
	Quit $$$OK
}

Method IsGenericFoundation(pID As %String) As %Boolean
{
	Set tItem = ##class(HS.Util.Installer.ConfigItem).%OpenId(pID)
	Quit tItem.%ClassName(1)="HS.Util.Installer.Foundation"
}

XData paneSSLConfig [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" labelPosition= "left">
<spacer height="10px"/>
<vgroup labelClass="lblNormal" labelPosition="left" enclosingStyle="padding:4px;">
<label enclosingStyle="font-size:14px;color:black;font-weight:bold;padding-bottom:4px" value="SSL Configuration"/>
<text id="SSLHost" label="Enter the SSL Host Name: " size="50" labelClass="lblNormal" 
	onchange="zenPage.changeSSLName();"
	title="Enter the web server host name used to access this instance"
	/>
<text id="SSLPort" label="Enter SSL Port:" size="10" labelClass="lblNormal" onchange="zenPage.changeSSLName();"/>
<text id="SSLPrefix" label="Enter Web Server Prefix:" size="10" labelClass="lblNormal" onchange="zenPage.changeSSLName();"/>
<text name="SSLRoot" id="SSLRoot" label="SSL Root Endpoint:" labelClass="lblNormal" disabled="true" size="50"/>
<spacer height="7px"/>
<checkbox name="SSLActive" id="SSLActive" label="These Settings are Active" labelClass="lblNormal" />

</vgroup>
<hgroup cellAlign="left">
<button caption="Save" onclick="zenPage.saveSSLConfig();"/>
<spacer width="10px"/>
<button caption="Cancel" width="50px" onclick="zenPage.endModal();"/>
<spacer height="7px"/>
</hgroup>
</pane>
}

/// User changed SSL Info for the Hub. Construct SSL Root end point. This will only be possible if config has never been activated.
ClientMethod changeSSLName() [ Language = javascript ]
{
	var SSLHost = zenPage.getComponentById("SSLHost").getValue();
	var SSLPort = zenPage.getComponentById("SSLPort").getValue();
	var portstr = ""
	if ( SSLPort != "" && SSLPort != "443" ) {
		portstr = ":" + SSLPort;
	}
	var WebUrlPrefix = zenPage.getComponentById("SSLPrefix").getValue();

	if (SSLHost!="") {
		var SSLRootEndpoint = "https://"+SSLHost+portstr;
		if ( WebUrlPrefix != "" ) {
			SSLRootEndpoint = SSLRootEndpoint + "/" + WebUrlPrefix
		}
		zenPage.getComponentById("SSLRoot").setValue(SSLRootEndpoint);
	}
}

ClientMethod saveSSLConfig() [ Language = javascript ]
{
	var nh = zenPage.getComponentById("SSLHost").getValue();
	var np = zenPage.getComponentById("SSLPort").getValue();
	var npfx = zenPage.getComponentById("SSLPrefix").getValue();
	var na = zenPage.getComponentById("SSLActive").getValue() ? 1 : 0;
	zenPage.storeSSLConfig(nh, np, npfx,na);
	zenPage.endModal();
}

Method storeSSLConfig(pHost, pPort, pPrefix, pIsActive) [ ZenMethod ]
{
	Do ..SetSSLConfig(pHost, pPort, pPrefix, pIsActive)
	Quit
}

/// Set the globals which hold the SSL configuration
ClassMethod SetSSLConfig(pHost As %String, pPort As %Integer, pPrefix As %String, pActive As %Boolean)
{
	$$$SetHSSecureHostName(pHost)
	$$$SetHSSecurePort(pPort)
	$$$SetHSSecurePrefix(pPrefix)
	$$$SetHSSecureActive(pActive)
}

XData paneNetHost [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" labelPosition= "left">
<spacer height="10px"/>
<text id="txtNetHostName" labelClass="lblNormal" label="Network Host Name: " size="50"
 title="The network host name is used to configure service URLs, etc.  In a mirrored environment this needs to
  be a virtual address that will remain constant after a failover"/>
<spacer height="7px"/>
<hgroup cellAlign="left">
<button caption="Save" onclick="zenPage.saveNetHost();"/>
<spacer width="10px"/>
<button caption="Cancel" onclick="zenPage.endModal();"/>
<spacer height="7px"/>
</hgroup>
</pane>
}

ClientMethod saveNetHost() [ Language = javascript ]
{
	var nh=zenPage.getComponentById("txtNetHostName").value
	if(nh == "") {alert(this.msgNoNetHost) ;
	} else {
		zenPage.StoreNetHost(nh);
		zenPage.endModal();
	}
}

Method StoreNetHost(pNetHost) [ ZenMethod ]
{
	Set ^%SYS("HealthShare","NetworkHostName")=pNetHost Quit
}

/// If license is not in place, show message and hide everything.
Method %OnAfterCreatePage() As %Status
{
	Set LicenseLink = ##class(%CSP.Page).Link("/csp/docbook/DocBook.UI.Page.cls?KEY=GSA_license#GSA_license_maintain_key")
	Set ..%GetComponentById("idLicenseLink").href = LicenseLink
	If $System.License.KeyOrderNumber() = 0 {
		Set ..%GetComponentById("idWelcome").hidden = 1
		Set ..%GetComponentById("idContent").hidden = 1
		Set ..%GetComponentById("id_Table").hidden = 1
		Set ..%GetComponentById("idLicense").hidden = 0
	} Else {
		Set ..%GetComponentById("idWelcome").hidden = 0
		Set ..%GetComponentById("idContent").hidden = 0
		Set ..%GetComponentById("id_Table").hidden = 0
		Set ..%GetComponentById("idLicense").hidden = 1		
	}
	// Initialize the SSL Configuration Pane
	Set ..%GetComponentById("SSLHost").value = $$$HSSecureHostName
	Set ..%GetComponentById("SSLPort").value = $$$HSSecurePort
	Set ..%GetComponentById("SSLPrefix").value = $$$HSSecurePrefix
	Set ..%GetComponentById("SSLActive").value = $$$HSSecureIsActive
	Set ..%GetComponentById("txtNetHostName").value=$$$HSNetworkHostName

	
	Quit $$$OK
}

/// When the page is loaded, put cursor where it belongs.
ClientMethod onloadHandler() [ Language = javascript ]
{
	zenPage.changeSSLName();
}

}
