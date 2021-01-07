Include HS.HC

/// HealthShare Configure Gateway/Hub/Viewer. This form does not use dynaForm.<br/>
Class HS.UI.Installer.Config Extends (HS.UI.Base, %CSP.Portal.standardDialog)
{

/// Security requirement
Parameter RESOURCE = "%HSAdmin_InstallationManagement";

Property ComponentType As %String(ZENURL = "COMPONENT");

Property modelClass As %String;

Property msgEnterName As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Please enter a Local Name!")} ];

Property msgEnterComponentName As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Please enter a Network Name!")} ];

Property msgEnterTemplate As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Please select a Template!")} ];

Property msgEnterProduction As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Please enter a Production!")} ];

Property msgProductionInvalid As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Production name is not valid!")} ];

Property msgEnterHub As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Please enter a Hub Endpoint!")} ];

Property msgEnterSearch As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Please enter a Patient Search page!")} ];

Property msgEnterAdminURL As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Please enter an MPI Admin URL!")} ];

Property msgEnterPatientIDLabel As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Please enter a Master Patient ID Label!")} ];

Property msgNamespaceName As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("HealthShare namespace names must start with a letter and contain letters and numbers. Also, HSAUDIT is a reserved name and may not be used.")} ];

Property msgSSLConfigRequired As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("SSL Configuration is Required to connect to Hub Securely")} ];

Property msgAlternateDatabaseLocation As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Ensure the mirror member has the same path available for the Alternate Database Location.")} ];

Property titleText As %ZEN.Datatype.caption [ InitialExpression = {$$$TextHTML("Configure Foundation")} ];

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
body {
	background: #ffffff;
	font-family: "Source Sans Pro",Futura,Arial,sans-serif;
}
#header {
	position: relative;
}
.stdTitle {
	color:#000000;
	background: #ffffff;
	border-bottom: none;
	font-family: Montserrat,Futura,Arial,sans-serif; 
	font-size: 16px;
	font-weight: 700;
	letter-spacing: 0.75px;
	margin: 20px 20px 10px 20px;
	text-transform: uppercase;
	white-space: nowrap;
}
.stdSubTitle {
	color:#000000;
	font-family: Montserrat,Futura,Arial,sans-serif;
	font-style: italic;
	font-size: 12px;
	font-weight: normal;
	letter-spacing: 0.75px;
	margin: 4px 20px;	
	white-space: nowrap;
}
.stdTitleBorder {
	border: 1px solid #CBCBCB;
	border-radius: 4px;	
}
.formTitle {
	color:#000000;
	font-size:18px;
	font-weight: bold;
	letter-spacing: 0.75px;
}
.labelTitle {
	color: black;
	font-size: 14px;
	font-weight: bold;
	text-decoration: bold;
}
.warningTitle {
	color: black;
	font-size: 14px;
}
.SSLWarningTitle {
	color: black;
	font-size: 12px;
	background:#d9f2ff;
	padding:2px;
	font-weight: bold;
}
.yellowLabel {
	border: solid #AC7070 1px;
	background: yellow;
	font-size: 0.75em;
	padding: 2px;
}

</style>
}

/// This page allows user to configure Gateway/Hub/Viewer
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" width="100%" height="100%" 
	title="#(%page.dialogTitle)#">
<html id="header" OnDrawContent="%DrawTitle" />
<pane paneName="dialogBody" id="body" />
 </page>
}

XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" cellStyle="padding:20;">
<label id="result" controlClass="redText" value="" containerStyle="padding-left:10px;"/>
<spacer height="2"/>
<label id="lblTitle" align="center" labelClass="labelTitle" label="Configuration"/>
<label id="id_Warning" align="center" label="Note - Since this configuration has been activated, some properties are read-only." labelClass="warningTitle" hidden="true"/>
<label id="id_SSL_Warning" align="center" 
	label="SSL has not been configured for this instance. 
	If you activate this namespace before configuring SSL, 
	OAuth will not be configured and you will have to re-activate this namespace after configuring SSL" 
	labelClass="SSLWarningTitle" hidden="false"/>

<spacer height="4"/>
<form name="form" id="form" layout="horizontal" cellStyle="padding: 2px; padding-left: 10px; padding-right: 5px;">
<text name="Type" id="Type" hidden="true" value=""/>
<text name="ID" id="ID" hidden="true" value=""/>
<text name="DefaultProduction" id="DefaultProduction" hidden="true"/>
<text name="HostName" id="HostName" hidden="true"/>
<spacer width="20"/>
<vgroup align="center" id="centerbox" labelPosition="left">
<text name="Name" id="Name" label="Local Name *" labelClass="lblNormal" size="30" onchange="zenPage.changeName();"/>
<spacer height="2"/>
<text name="ComponentName" id="ComponentName" label="Network Name *" labelClass="lblNormal" size="30"/>
<spacer height="2"/>
<textarea name="Description" id="Description" label="Description" labelClass="lblNormal" cols="50" rows="3"/>
<spacer height="2"/>
<checkbox name="Disabled" id="Disabled" label="Disabled" labelClass="lblNormal"/>
<spacer height="2"/>
<checkbox name="AuditProduction" id="AuditProduction" label="Is this the Audit Production?" labelClass="lblNormal"
 title="The Audit Production needs to run in either the Registry (default) or one Edge Gateway (for a remote setup). *DO NOT SELECT THIS if another Audit Production exists!*  If there is a Registry on this instance, and the Audit database is to be kept on this instance, the Registry MUST be the Audit Production.  If this is checked, it will create an HSAUDIT database on this instance, and include production hosts such as the audit consolidation service."/>
<html id="AuditWarning"><div style="font-size:11px;font-weight:bold;align:left;">The Audit Production needs to run in either the Registry (default) or one Edge Gateway (for a remote setup). <p style="color:red;">*DO NOT SELECT THIS if another Audit Production exists!*</p>  If there is a Registry on this instance, and the Audit database is to be kept on this instance, the Registry MUST be the Audit Production.  If this is checked, it will create an HSAUDIT database on this instance, and include production hosts such as the audit consolidation service.</div></html>
<text name="DefaultReportCode" id="DefaultReportCode" label="Default Report Code " labelClass="lblNormal" size="50"/>
<text name="MasterPatientIDLabel" id="MasterPatientIDLabel" label="Master Patient ID Label *" labelClass="lblNormal" size="50"/>
<text name="MPIAdminURL" id="MPIAdminURL" label="MPI Admin URL *" labelClass="lblNormal" size="65"/>
<spacer height="2"/>
<text name="Production" id="Production" label="Production *" labelClass="lblNormal" size="50"/>
<spacer height="2"/>
<combobox name="Template" id="Template" label="Template *" labelClass="lblNormal" hidden="true" editable="true" size="50" onchange="zenPage.changeTemplate();"/>
<text name="TemplateText" id="TemplateText" label="Template *" labelClass="lblNormal" hidden="true" size="50"/>
<text name="AlternateDatabaseLocation" id="DatabaseLocation" label="Alternate Database Location" labelClass="lblNormal" size="50" onchange="zenPage.changeDatabaseLocation();"/>

<spacer height="2"/>
<multiSelectSet name="KitsList" id="KitsList" hidden="true" label="Kits" labelClass="lblNormal"/>
<spacer height="2"/>
<vgroup id="id_HubEndpoint" labelClass="lblNormal" labelPosition="left" enclosingStyle="background:#d9f2ff;padding:4px;">
<label enclosingStyle="font-size:14px;color:black;font-weight:bold;padding-bottom:4px" value="Configure Hub Access"/>
<text id="HubHost" label="Enter a Hub Host: *" labelClass="lblNormal" onchange="zenPage.changeHubName();"/>
<text id="HubPort" label="Enter a Hub Port: *" labelClass="lblNormal" onchange="zenPage.changeHubName();"/>
<combobox id="HubName" label="Enter a Hub Name: *" labelClass="lblNormal" editable="true" unrestricted="true" onchange="zenPage.changeHubName()"/>
<checkbox id="connectWithSSL" label="Connect to Hub Securely?: " onchange="zenPage.showSSLConfigurations()" />
<dataCombo size='27' id="selectSSL" label="SSL Configuration*" hidden="true" labelClass="caption" required="true"
	queryClass="HS.UI.Installer.Config"
	queryName="GetSSLConfig"
	editable="true"
	searchKeyLen="20"
	maxRows="10000">
</dataCombo>
<label enclosingStyle="font-size:10px;color:#666666;" value="The Hub End Point will be constructed for you once you fill these fields."/>
<label enclosingStyle="font-size:10px;color:#666666;" value="You may change it if needed, below."/>
</vgroup>
<text name="HubEndpoint" id="HubEndpoint" hidden="true" label="Initial Hub End Point *" labelClass="lblNormal" size="80" onchange="zenPage.changeHubName()"/>
<spacer height="2"/>

<spacer height="5"/>
<html><div style="font-size:10px;">* indicates required field</div></html>
<hgroup align="right">
<button id="btnSave" caption="Save" onclick="zenPage.saveForm();"/>
<spacer width="10"/>
<button id="btnClose" caption="Close" onclick="zenPage.cancelPopup();"/>
</hgroup>
</vgroup>
</form>
</pane>
}

Method DrawPageTitle(pSeed As %String) As %Status
{
	Set tPageTitle = ..%OnGetTitle()
	&html<<div class="Description">#(tPageTitle)#</div>
	<hr size="1"/>>
}

ClassMethod DrawTitle(pSeed As %String) As %Status
{
	Do %application.DrawHSTitle($$$Text("Configuration"),"",0,0,0,0)
	Quit $$$OK
}

/// When the page is loaded, put cursor where it belongs.
ClientMethod onloadHandler() [ Language = javascript ]
{
	if (zenPage.getComponentById("Name").getProperty("disabled") == false) {
		zenPage.getComponentById("Name").focus();
	} else {
		zenPage.getComponentById("btnClose").focus();
	}
}

/// User changed name. Construct Production name & Component name. This will only be possible if config has never been activated.
ClientMethod changeName() [ Language = javascript ]
{
	var UpperName = zenPage.getComponentById("Name").getValue().toUpperCase();
	var NSisGood = zenPage.validateName(UpperName);
	if(NSisGood!=1) {
		alert(this.msgNamespaceName);
		zenPage.getComponentById("Name").focus();
		return;	
	}
	var Name=UpperName;
	var DefaultProduction = zenPage.getComponentById("DefaultProduction").getValue();
	var HostName = zenPage.getComponentById("HostName").getValue();
	if (Name != "") {
		zenPage.getComponentById("Production").setValue(Name + DefaultProduction);
		zenPage.getComponentById("ComponentName").setValue(HostName + ":" + Name);
		zenPage.getComponentById("Name").setValue(UpperName);
	}
}

/// User changed template name. Update which kits are selected based upon template parameters
ClientMethod changeTemplate() [ Language = javascript ]
{
	var HubTemplate = zenPage.getComponentById("Template").getValue();
	var SelectedKits = zenPage.GetDefaultKits(HubTemplate)
	zenPage.getComponentById("KitsList").setValue(SelectedKits)
	var AuditProduction = zenPage.getComponentById("AuditProduction");
	if (AuditProduction.getValue()==0 && AuditProduction.hidden==0){
		AuditProduction.setValue(zenPage.GetDefaultAuditProduction(HubTemplate));
	}
}

/// User changed template name. Update which kits are selected based upon template parameters
ClientMethod changeDatabaseLocation() [ Language = javascript ]
{
	var DatabaseLocation = zenPage.getComponentById("DatabaseLocation").getValue();
	var isMirrored = zenPage.isMirrored();
	if (DatabaseLocation!='' && isMirrored){
		alert(this.msgAlternateDatabaseLocation);
	}
}

ClassMethod isMirrored() As %Boolean [ ZenMethod ]
{
	Quit $system.Mirror.IsMember()
}

ClassMethod GetDefaultKits(pClass As %String) As %String [ ZenMethod ]
{
	Set tReturn=""
	try {
		Set tReturn = $parameter(pClass, "DEFAULTKITS")
	} catch ex {}
	Quit tReturn
}

ClassMethod GetDefaultAuditProduction(pClass As %String) As %Boolean [ ZenMethod ]
{
	Set tReturn=""
	try {
		Set tReturn = $parameter(pClass, "DEFAULTAUDITPRODUCTION")
	} catch ex {}
	Quit tReturn
}

/*
	The code below corresponding to getting SSL is adapted from HS.UI.Registry.Services
*/
Query GetSSLConfig(pStartsWith As %String = "") As %Query(ROWSPEC = "ID:%String,Description:%String")
{
}

ClassMethod GetSSLConfigExecute(ByRef qHandle As %Library.Binary, pStartsWith As %String = "") As %Status
{
	Set sc = $$$OK
	Try {
		Kill qHandle
		Set sc = ##class(Ens.ContextSearch).SSLConfigs(,,.qHandle)
		$$$ThrowOnError(sc)
		// Set top level to the current row number to fetch.
		// This will be incremented every time GetSSLConfigFetch is called
		Set qHandle = ""
		
		// Iterate and kill nodes that do not start with pStartsWith
		If (pStartsWith '= "") {
			Set key = ""
			While 1 {
				Set key = $Order(qHandle(key), 1, value)
				If (key = "") {
					Quit
				}
				If ($Extract(value, 1, $Length(pStartsWith)) '= pStartsWith) {
					Kill qHandle(key)
				}
			}
		}
	} Catch ex {
		Set sc =  ex.AsStatus()
	}
	Quit sc
}

ClassMethod GetSSLConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSSLConfigExecute ]
{
	// Set top level to next row
	Set qHandle = $Order(qHandle(qHandle))
	Set AtEnd = (qHandle = "")
	Set Row = $Select((AtEnd = 1): "", 1: $Get(qHandle(qHandle)))
	Set Row = $ListBuild(Row, Row)
	Quit $$$OK
}

ClassMethod GetSSLConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSSLConfigExecute ]
{
	Quit $$$OK
}

/// Display SSL/TLS configurations
ClientMethod showSSLConfigurations() [ Language = javascript ]
{
	var HubHost = zenPage.getComponentById("HubHost").getValue();
	var HubPort = zenPage.getComponentById("HubPort").getValue();
	var HubName = zenPage.getComponentById("HubName").getValue();
	var SSLcheckBoxSelected = zenPage.getComponentById("connectWithSSL").getValue();
	var SSLConfig = zenPage.getComponentById("selectSSL").getValue();
	
	if (SSLcheckBoxSelected !=""){
		zenPage.getComponentById('selectSSL').setHidden(false);
		
		if (HubHost!=""&&HubName!="") {
			zenPage.getComponentById("HubEndpoint").setHidden(false);
		
			if (HubPort!="") {
				var HubEndpoint = "https://"+HubHost+":"+HubPort+"/csp/healthshare/"+HubName+"/services/HS.Hub.HSWS.WebServices.cls";
			}
			else {
				var HubEndpoint = "https://"+HubHost+"/csp/healthshare/"+HubName+"/services/HS.Hub.HSWS.WebServices.cls";			
			}
			zenPage.getComponentById("HubEndpoint").setValue(HubEndpoint);
		}
	}
	else {
		zenPage.getComponentById('selectSSL').setHidden(true);
		zenPage.changeHubName();
	}
}

/// User changed Hub name. Construct hub end point. This will only be possible if config has never been activated.
ClientMethod changeHubName() [ Language = javascript ]
{
	var HubHost = zenPage.getComponentById("HubHost").getValue();
	var HubPort = zenPage.getComponentById("HubPort").getValue();
	var HubName = zenPage.getComponentById("HubName").getValue();
	
	if (HubHost!=""&&HubName!="") {
		zenPage.getComponentById("HubEndpoint").setHidden(false);
		
		if (HubPort!="") {
			var HubEndpoint = "http://"+HubHost+":"+HubPort+"/csp/healthshare/"+HubName+"/services/HS.Hub.HSWS.WebServices.cls";
		}
		else {
			var HubEndpoint = "http://"+HubHost+"/csp/healthshare/"+HubName+"/services/HS.Hub.HSWS.WebServices.cls";			
		}
		zenPage.getComponentById("HubEndpoint").setValue(HubEndpoint);
	}
}

ClientMethod saveForm() [ Language = javascript ]
{

	var ID = zenPage.getComponentById("ID").getValue();
	var Type = zenPage.getComponentById("Type").getValue();
	var Name = zenPage.getComponentById("Name").getValue();
	var ComponentName = zenPage.getComponentById("ComponentName").getValue();
	var Description = zenPage.getComponentById("Description").getValue();
	var Disabled = zenPage.getComponentById("Disabled").getValue();
	var Production = zenPage.getComponentById("Production").getValue();
	var Template = zenPage.getComponentById("Template").getValue();
	var HubEndpoint = zenPage.getComponentById("HubEndpoint").getValue();
	var DefaultReportCode = zenPage.getComponentById("DefaultReportCode").getValue();
	var MasterPatientIDLabel = zenPage.getComponentById("MasterPatientIDLabel").getValue();
	var MPIAdminURL = zenPage.getComponentById("MPIAdminURL").getValue();
	var AuditProduction = zenPage.getComponentById("AuditProduction").getValue();
	var KitsList = zenPage.getComponentById("KitsList").getValue();
	var DatabaseLocation = zenPage.getComponentById("DatabaseLocation").getValue();
	var SSLCheckBoxSelected = zenPage.getComponentById("connectWithSSL").getValue();
	var SSLConfig = zenPage.getComponentById("selectSSL").getValue();
	
	// valid SSL configuration must be selected once the checkbox is selected
	if (SSLCheckBoxSelected != "" && SSLConfig == ""){
		alert(this.msgSSLConfigRequired);
		zenPage.getComponentById("selectSSL").focus();
		return;
	}
	
	// check if user is trying to connect to the hub securely and throw an error
	if (SSLCheckBoxSelected != "" && Type=="Hub") {
		alert("Hub cannot connect to the Hub securely!");
		return;
	}
	
	var NSisGood = zenPage.validateName(Name);
	if(NSisGood!=1) {
		alert(this.msgNamespaceName);
		zenPage.getComponentById("Name").focus();
		return;	
	}

	if (ComponentName == "") {
		alert(this.msgEnterComponentName);
		zenPage.getComponentById("ComponentName").focus();
		return;	
	}
	if ((Type!="Foundation" || (Type=="Foundation" && (zenPage.modelClass=="HS.Util.Installer.Foundation"))) && Template == "") {
		alert(this.msgEnterTemplate);
		zenPage.getComponentById("Template").focus();
		return;	
	}
	if (Production == "") {
		alert(this.msgEnterProduction);
		zenPage.getComponentById("Production").focus();
		return;	
	}
	if (Production.indexOf("%")!=-1 || Production.indexOf("_")!=-1 || Production.indexOf("-")!=-1 ) {
		alert(this.msgProductionInvalid);
		zenPage.getComponentById("Production").focus();
		return;
	}
	if (HubEndpoint == "" && ((Type == "EdgeGateway") || (Type == "AccessGateway") || (Type=="Bus"))) {
		alert(this.msgEnterHub);
		zenPage.getComponentById("id_HubEndpoint").setHidden(false);
		zenPage.getComponentById("HubName").focus();
		return;	
	}
	if (MasterPatientIDLabel == "" && Type == "AccessGateway") {
		alert(this.msgEnterPatientIDLabel);
		zenPage.getComponentById("MasterPatientIDLabel").focus();
		return;	
	}
	
	
	var ok = zenPage.saveID(ID,Type,Name,ComponentName,Description,
			Disabled,Production,Template,HubEndpoint,
			zenPage.modelClass,MPIAdminURL,DefaultReportCode,MasterPatientIDLabel,
			KitsList, AuditProduction,DatabaseLocation, SSLConfig);
	if (ok == 1) {
		this.firePopupAction('saved');
	} else {
		alert(ok);
	}
}

ClassMethod validateName(pName) As %Boolean [ ZenMethod ]
{
	Set tReturn=1
	try {
		If $l(pName)>32 { Set tReturn=0 Quit /*"Name cannot exceed 32 characters" */}
		If $L($Zstrip(pName,"*AN")) { Set tReturn=0 Quit}
		If $ZCVT(pName,"U")="HSAUDIT" { Set tReturn=0 Quit } // HSAUDIT is a reserved name, and cannot be used for a namespace name.
	} catch ex {
		Set tReturn = $system.Status.GetErrorText(ex.AsStatus())
	}
	Quit tReturn
}

ClassMethod saveID(ID, Type, Name, ComponentName, Description, Disabled, Production, Template, HubEndpoint, modelClass, MPIAdminURL, DefaultReportCode, MasterPatientIDLabel, KitsList, AuditProduction, DatabaseLocation, SSLConfig) As %String [ ZenMethod ]
{
	Set tSC = $$$OK
	#; if the item does not already exists, create it
	If ID="" {
		Set tObj = $zobjclassmethod(modelClass,"%New")
		Set tName=""
	} else {
		Set tObj = $zobjclassmethod(modelClass,"%OpenId",ID)
		Set tName=tObj.Name // save the old name for use in cleanup
	}
	
	#; add/overwrite the properties
	Set tObj.Name = $ZCVT(Name,"U")
	Set tObj.Type = Type
	Set tObj.Description = Description
	Set tObj.AuditProduction = (AuditProduction="true")
	Set tObj.DatabaseLocation = DatabaseLocation
	// Only set if the property exists in the obtained subclass of HS.Util.Installer.ConfigItem
	If $$$comMemberDefined($Classname(tObj), $$$cCLASSproperty, "SSLConfig") {
		Set tObj.SSLConfig = SSLConfig
	}
	If (Type="Hub"){
		Set tObj.MPIAdminURL = MPIAdminURL
	}
	If Type="AccessGateway" Set tObj.DefaultReportCode=DefaultReportCode, tObj.MasterPatientIDLabel=MasterPatientIDLabel
	#; Don't change NetworkName, Template, or HubEndpoint
	#;  if (ever) Activated
	if tObj.LastActivated="" {
		Set tObj.HSComponentName = ComponentName
		Set tObj.Template = Template
	}
	// Allow Production to be updated even if configuration was activated.
	Set tObj.Production = Production
	//can fill this in if missing - for upgrades from pre-federated HSAA, etc.
	If tObj.HSComponentName="" {Set tObj.HSComponentName = ComponentName }
	If Type'="Hub" Set tObj.HubEndpoint = HubEndpoint
	#; Set Activated to 0 only if Disabled has been changed
	set disabled=Disabled="true"
	if disabled'=tObj.Disabled {
		Set tObj.Disabled = disabled
	}
	if ("^AccessGateway^Bus^EdgeGateway^Hub^"[("^"_Type_"^")) {
		set tObj.KitsList=$ListFromString(KitsList,",")
	}
	Set tSC = tObj.%Save()
	If $$$ISERR(tSC) Set tSC = $System.Status.GetErrorText(tSC)
	#; Cleanup - if the user changed the Name, delete the old one
	#;  (can only happen if not activated)
	If $l(tName)&&(tObj.Name'=tName) {
		Set tSC=##class(HS.Util.Installer.ConfigItem).%DeleteId(tName)	
	}
	Quit tSC
}

/// For Edit, ID is not null and TYPE is null. Use ID to retrieve existing data.
/// For New, ID is null and TYPE is not null. Use TYPE to construct the appropriate type of configuration.
Method %OnAfterCreatePage() As %Status
{
	Set TYPE = $G(%request.Data("TYPE",1))
	Set ID = $G(%request.Data("ID",1))
	Set tSubType= $G(%request.Data("SUBTYPE",1))
	If TYPE = "",ID = "" Quit $$$OK
	
	#; For Edit
	If TYPE = "" {
		Set (tModel,tObj) = ##class(HS.Util.Installer.ConfigItem).%OpenId(ID)
		Set modelClass=tModel.%ClassName(1)
		Set TYPE = tModel.Type
	}

	#; For New
	Else {
		If TYPE="Foundation" && (..ComponentType]"") {
			If ##class(%Dictionary.CompiledClass).%ExistsId(..ComponentType) && $classmethod(..ComponentType,"%Extends","HS.Util.Installer.FoundationType") {
				Set modelClass = ..ComponentType
			}
			Else {
				Set modelClass = "HS.Util.Installer."_..ComponentType
			}
		} Else {
			Set modelClass = $Case(TYPE,"EdgeGateway":"HS.Util.Installer.EdgeGateway","Hub":"HS.Util.Installer.Hub","Bus":"HS.Util.Installer.Bus","AccessGateway":"HS.Util.Installer.AccessGateway","Foundation":"HS.Util.Installer.Foundation","FlashGateway":"HS.Util.Installer.FlashGateway",:TYPE)
		}
		Set tObj = $classmethod(modelClass,"%New")
		#; values default
	}
	
	#; Display what we have so far
	Set ..%GetComponentById("Name").value = tObj.Name
	Set ..%GetComponentById("ComponentName").value = tObj.HSComponentName
	Set ..%GetComponentById("Description").value = tObj.Description
	Set ..%GetComponentById("Disabled").value = tObj.Disabled
	Set ..%GetComponentById("Production").value = tObj.Production
	Set ..%GetComponentById("ID").value = ID
	Set ..%GetComponentById("DatabaseLocation").value = tObj.DatabaseLocation
	Set tHidden=0,tDisabled=0
	If tObj.LastActivated'="" {
		// the database may have been moved from where it initially was or DatabaseLocation may not have existed so don't show unless it hasn't been activated
		Set tDisabled=1,tHidden=1
	}
	Set ..%GetComponentById("DatabaseLocation").hidden = tHidden
	Set ..%GetComponentById("DatabaseLocation").disabled = tDisabled

	//for hub upgrades, if we already have audit data, mark hub as audit production
	If tObj.LastActivated'="",..%page.modelClass="HS.Util.Installer.Hub",..CheckForAuditData(tObj.Name) {
		Set tObj.AuditProduction=1
	}
	Set ..%GetComponentById("AuditProduction").value = tObj.AuditProduction

	Set ..%page.modelClass = modelClass
	Set ..%GetComponentById("Type").value = TYPE
	If tObj.LastActivated '= "" Set ..%GetComponentById("id_Warning").hidden = 0
	Set lblTitle = ..%GetComponentById("lblTitle")
	If tSubType="PIHub"||(tObj.Template="HS.Sample.Production.Hub.StandAloneProduction") {
		Set typeName=$$$Text("Standalone Patient Index")
	} Else {
		set typeName = $Case(TYPE,"EdgeGateway":$$$Text("Edge Gateway"), "AccessGateway":$$$Text("Access Gateway"),
							    "Foundation":$$$Text("component"), "Hub":$$$Text("Hub"),"Bus":$$$Text("Bus"),"FlashGateway":$$$Text("Flash Gateway"), :TYPE)
	}
	Set tLblTitleText = $$$Text("Configure %1")
	Set lblTitle.label = $$$FormatText(tLblTitleText,typeName)
	Set:TYPE="Foundation" lblTitle.label = $$$Text("Configuration") ; keep previous title for all Foundation components
	
	//Set up tooltip help
	Set tNameTitle = $$$Text("Enter the name of this %1. This will become the namespace that will contain the class definitions for this %1. The maximum length for this string is 50 characters.")
	Set tNameTitle = $$$FormatText(tNameTitle,typeName)
	Set ..%GetComponentById("Name").title=tNameTitle
	Set tComponentNameTitle = $$$Text("This is the network-wide, unique name for this %1. It defaults to host_name:LOCAL_NAME")
	Set tComponentNameTitle = $$$FormatText(tComponentNameTitle,typeName)
	Set ..%GetComponentById("ComponentName").title=tComponentNameTitle
	Set ..%GetComponentById("Description").title=$$$Text("Enter an (optional) short description.")
	Set tDisabledTitle = $$$Text("Check this box if you want this %1 to be disabled (for example in testing or in development). A disabled production does not appear on the HealthShare home page, but it can be accessed through Ensemble.")
	Set tDisabledTitle = $$$FormatText(tDisabledTitle,typeName)
	Set ..%GetComponentById("Disabled").title=tDisabledTitle
	Set tDefaultReportCodeTitle = $$$Text("This field controls controls which Zen report should be the initial default patient summary report at this %1.")
	_$char(13,10)_$$$Text("If you leave this field blank, then the report specified as the default report on the Hub is used as the initial default. If no report is marked as the default on the Hub (not recommended), then the first report listed in the dropdown (alphabetically first by report name) is shown.")
	_$char(13,10)_$$$Text("If you wish to use a different report as the initial default, enter the code of the report (from Hub Manager, Patient Report Definitions) here.")
	_$char(13,10)_$$$Text("Note that once a user selects a report from the dropdown, the selected report becomes that user's default, overriding this setting and the setting at the Hub.")
	Set tDefaultReportCodeTitle = $$$FormatText(tDefaultReportCodeTitle,typeName)
	Set ..%GetComponentById("DefaultReportCode").title=tDefaultReportCodeTitle
	Set ..%GetComponentById("MasterPatientIDLabel").title=$$$Text("This defaults to ""Master Patient ID"".  To use a different label, for example, ""RHIO ID"", enter it here. ")
	set tProductionTitle=$$$Text("Enter the package and class name that you will use for this %1 in the form Package.Class.")
	Set tProductionTitle = $$$FormatText(tProductionTitle,typeName)
	
	if ("^Hub^Bus^EdgeGateway^AccessGateway^FlashGateway^"[("^"_TYPE_"^")) {
		set tProductionTitle=tProductionTitle_$$$Text(" The default is LOCAL_NAMEPKG.%2Production") ; don't say this if it's inaccurate
	Set tProductionTitle = $$$FormatText(tProductionTitle,TYPE)
	}
	Set ..%GetComponentById("Production").title=tProductionTitle
	Set tTemplateTitle = $$$Text("The template controls the initial contents of this %1"_" and some of the default settings.")
	_$char(13,10)_$$$Text("You can edit the specific contents and settings of the production to suit your needs after initialization.")
	_$char(13,10)_$$$Text("Select the appropriate template from the drop-down list.")
	Set tTemplateTitle = $$$FormatText(tTemplateTitle,typeName)
	Set ..%GetComponentById("Template").title=tTemplateTitle
	Set tTemplateTextTitle = $$$Text("The template controls the initial contents of this %1 and some of the default settings.")
	_$char(13,10)_$$$Text("You can edit the specific contents and settings of the production to suit your needs after initialization.")
	Set tTemplateTextTitle = $$$FormatText(tTemplateTextTitle,typeName)
	Set ..%GetComponentById("TemplateText").title=tTemplateTextTitle
	Set ..%GetComponentById("HubHost").title=$$$Text("Enter the name or IP address of the server that is hosting the Hub production.")
	Set ..%GetComponentById("HubPort").title=$$$Text("Enter the port number that the Hub production is using. If the port number is not required, you may leave this blank.")
	Set ..%GetComponentById("HubName").title=$$$Text("Select the name of the Hub from the drop-down list, or type in a name. ")
	Set ..%GetComponentById("KitsList").title=$$$Text("Select any kits you would like to install when the current item is next activated.")
	Set ..%GetComponentById("DatabaseLocation").title=$$$Text("By default databases are created under the mgr directory of the installation.")
	#; Name & ComponentName- disabled if ever activated
	If tObj.LastActivated="" {
		Set ..%GetComponentById("Name").disabled = 0
		Set ..%GetComponentById("ComponentName").disabled = 0
	}
	Else {
		Set ..%GetComponentById("Name").disabled = 1		
		Set ..%GetComponentById("ComponentName").disabled = 1		
	}
	//for upgrade of pre-federated instances, allow null component name to be filled in
	If ..%GetComponentById("ComponentName").value="" {
		Set ..%GetComponentById("ComponentName").disabled = 0
		Set:..%GetComponentById("Name").value'="" ..%GetComponentById("ComponentName").value=$$$HSNetworkHostName_":"_..%GetComponentById("Name").value
	}

	Set tTemplates = $parameter(modelClass,"SAMPLETEMPLATES")
	Set tShowTemplate=1
			
	#; Template - combobox or text
	Set ..%GetComponentById("Template").value = tObj.Template // for %Save
	If tShowTemplate,tObj.LastActivated="" {  // Not (ever) activated - Editable combobox
		Do ..GetProductions(modelClass,tTemplates,tSubType)
		Set ..%GetComponentById("Template").readOnly = 0
		Set ..%GetComponentById("TemplateText").hidden = 1
	}
	ElseIf tShowTemplate { // Activated - Read-only text
		Set ..%GetComponentById("Template").hidden = 1
		Set ..%GetComponentById("TemplateText").value = tObj.Template
		Set ..%GetComponentById("TemplateText").hidden = 0
		Set ..%GetComponentById("TemplateText").disabled = 1
		Set tShowTemplate=0
	}
	Set ..%GetComponentById("Template").hidden = 'tShowTemplate
	

	#; List available kits for new AccessGateway, Bus, EdgeGateway, Hub components
	if (("^AccessGateway^Bus^EdgeGateway^Hub^"[("^"_TYPE_"^"))) {
		set tKitsList=$listtostring(##class(HS.Util.Installer.Kit.Base).AvailableKits(TYPE))
		set ..%GetComponentById("KitsList").displayList=tKitsList
		set ..%GetComponentById("KitsList").valueList=tKitsList
		set ..%GetComponentById("KitsList").value=$listtostring(tObj.KitsList)
		set ..%GetComponentById("KitsList").hidden=1
	}

	#; Extra fields for EdgeGateway
	#;  none
	
	#; Extra fields for AccessGateway
	If TYPE="AccessGateway" {
		Set ..%GetComponentById("DefaultReportCode").value = tObj.DefaultReportCode
		Set ..%GetComponentById("DefaultReportCode").visible = 1
		Set ..%GetComponentById("MasterPatientIDLabel").value = tObj.MasterPatientIDLabel
		Set ..%GetComponentById("MasterPatientIDLabel").visible = 1

	}
	Else {
		Set ..%GetComponentById("DefaultReportCode").visible = 0
		Set ..%GetComponentById("MasterPatientIDLabel").visible = 0
	}
	
	// SSL Warning
	Set ..%GetComponentById("id_SSL_Warning").hidden = $$$HSSecureIsActive
	If TYPE'="AccessGateway",TYPE'="FlashGateway",(TYPE'="Hub"||(tSubType="PIHub")) {
		Set ..%GetComponentById("id_SSL_Warning").hidden = 1
	}


	#; MPIAdminURL no longer used
	Set ..%GetComponentById("MPIAdminURL").visible = 0		

    #; HubEndpoint  (for Edge and Access only)
    #; On initial add (ID=""), allow the user to create the value using the
    #;  Host, Port and Name fields, and then optionally edit the result
    #;  in the (unlabelled) text boz that appears
    #; After that, only display the result text box and only allow
    #;  changes if the component was never activated (LastActivated="")
	If ..%page.modelClass'="HS.Util.Installer.Foundation"&&(%page.modelClass'="HS.Util.Installer.Hub") {
		Set tSSLConfig = ""
		// Only set if the property exists in the obtained subclass of HS.Util.Installer.ConfigItem
		If $$$comMemberDefined($Classname(tObj), $$$cCLASSproperty, "SSLConfig") {
			Set tSSLConfig = tObj.SSLConfig
		}
		Set ..%GetComponentById("connectWithSSL").value = (tSSLConfig '= "")
		Set ..%GetComponentById("selectSSL").value = tSSLConfig
		Set ..%GetComponentById("selectSSL").hidden = (tSSLConfig = "")
		Set ..%GetComponentById("HubEndpoint").value = tObj.HubEndpoint
		Set ..%GetComponentById("HubEndpoint").hidden = 0
		If ID=""||(..%GetComponentById("HubEndpoint").value="") {  // New, use defaults of localhost:port
			Set ..%GetComponentById("id_HubEndpoint").hidden = 0
			Set ..%GetComponentById("HubHost").value = "localhost"
			Set status=##class(%RoutineMgr).GetWebServerPort(.HubPort)
			Set ..%GetComponentById("HubPort").value = HubPort
			Set HasHub = ..GetHubs("",1)  // remove routing through the BUS as this is not a suggested workflow
		}
		Else {
			// Parse HubEndpoint when one already exists
			Do ..ServerParseURL(tObj.HubEndpoint)
		}
	} Else {
		Set ..%GetComponentById("id_HubEndpoint").hidden = 1		
		Set ..%GetComponentById("HubEndpoint").hidden = 1		
	}
	
	If ..%page.modelClass'="HS.Util.Installer.Hub"&&(..%page.modelClass'="HS.Util.Installer.EdgeGateway") {
		Set ..%GetComponentById("AuditProduction").hidden = 1
		Set ..%GetComponentById("AuditWarning").hidden = 1
	} ElseIf $D(^%SYS("HealthShare","AuditNS")) {
		Set ..%GetComponentById("AuditProduction").disabled = 1
	} ElseIf tObj.LastActivated '= "",..AuditRegistryServiceExists() {
		//check the service registry for an audit instance
		Set ..%GetComponentById("AuditProduction").disabled = 1
	}
	// Hide the checkbox and warning if editing an Edge and a Registry is present on instance
	If ..%page.modelClass="HS.Util.Installer.EdgeGateway"&&(..CheckForHub())   
	{
		//Hide the AuditProduction field for an Edge if there is a Registry on this instance
		Set ..%GetComponentById("AuditProduction").hidden = 1
		Set ..%GetComponentById("AuditWarning").hidden = 1
	}

	#; Set default production and hostname (needed in case the user changes the Name
	If tSubType="PIHub" {
		Set ..%GetComponentById("DefaultProduction").value = tObj.GetPackageName()_".PatientIndexProduction"
	} Else {
		Set ..%GetComponentById("DefaultProduction").value = tObj.GetProductionName()
	}
	Set ..%GetComponentById("HostName").value = $$$HSNetworkHostName
	Quit $$$OK
}

ClassMethod CheckForHub() As %Boolean
{
	Set tNS = "",tHaveHub=0
	For  {
		Set tNS=$O(^%SYS("HealthShare","Instances",tNS),1,tInfo) Quit:tNS=""
		Set tType=$g(^%SYS("HealthShare","Instances",tNS,"Type"))
		If tType="Hub" {
			Set tHaveHub=1 Quit
		}
	}
	Quit tHaveHub
}

ClassMethod CheckForAuditData(pNamespace) As %Boolean
{
	New $namespace
	Set $namespace=pNamespace
	Quit $S($D(^HS.IHE.Audit):1,1:0)
}

ClassMethod AuditRegistryServiceExists() As %Boolean
{
	Set tExists=0
	New $NameSpace
	Try {
		Set $NameSpace="HSSYS"
		Set tServ=##class(HS.Registry.Service.Abstract).EndPointForNameType("HSAudit.Repository","SOAP")
		If $IsObject(tServ) Set tExists=1
	} Catch(ex) {
	}
	Quit tExists
}

Method ServerParseURL(pURL) As %String [ ZenMethod ]
{
	Set tWS = ##class(HS.Registry.Service.SOAP).%New()
	Do tWS.ParseURL(pURL)
	// Extract Hub Name from URL
	Set tHubName = $p($p(pURL,"healthshare/",2),"/",1)
	Do ..GetHubs(tHubName,1) // Setup combo box of Hub choices, and give it tHubName as current value
	Set ..%GetComponentById("HubHost").value = tWS.Host
	Set ..%GetComponentById("HubPort").value = tWS.Port
	Quit ""
}

/// Build Template Production list for the Template combo box 
Method GetProductions(pModelClass, pPackage, pSubtype = "") As %Status
{
	If pSubtype="PIHub" {
		Set tSC=$$$OK
		Set tTemplates($I(tTemplates))=$LB("Standalone Patient Index","HS.Sample.Production.Hub.StandAloneProduction")
	} Else {
		Set tSC = $classMethod(pModelClass,"GetSampleTemplates",.tTemplates)
	}
	Set tCombo = ..%GetComponentById("Template")
	If '$G(tTemplates) {
		Set tTemplates($i(tTemplates))=$lb("Generic Production","Ens.Production")
	}
	For tIdx=1:1:tTemplates {
		Set tTemplate = tTemplates(tIdx)
		Set tOption = ##class(%ZEN.Auxiliary.option).%New()
		Set tOption.text = $li(tTemplate)
		Set tOption.value = $li(tTemplate,2)
		Do tCombo.options.Insert(tOption)
		#; when only 1 template set it as the default
		Set:tTemplates=1&&(pSubtype'="PIHub") tCombo.value=$li(tTemplate,2)
		Do ..%AddComponent(tOption)
	}
	Quit $$$OK
}

/// Build Hub namespace list for the Hub namespace combo box
Method GetHubs(HubName, pThisIsBus) As %Boolean
{
	// Note: pThisIsBus = 1 results in this not adding the bus as a choice.  This is passed in whether this is the bus or not, to prevent the option from being available.
	Set tHasHub = 0
	Set tCombo = ..%GetComponentById("HubName")
	Set tRS = ##class(%ResultSet).%New("HS.Util.Installer.ConfigItem:Configuration")
	Do tRS.Execute()
	While tRS.Next() {
		If tRS.Get("Type") = "Hub" || (tRS.Get("Type")="Bus" && 'pThisIsBus) {
			Set tHasHub = 1
			Set tName = tRS.Get("Name")
			Set tOption = ##class(%ZEN.Auxiliary.option).%New()
			Do tCombo.options.Insert(tOption)
			Do ..%AddComponent(tOption)
			Set tOption.text = tName
			Set tOption.value = tName
		}
	}
	Set ..%GetComponentById("HubName").value = $S(HubName'="":HubName,1:"")
	Quit tHasHub
}

Method %OnGetTitle() As %String
{
	Quit $$$TextHTML("Configure Foundation")
}

Method %OnGetSubtitle() As %String
{
	Quit ""
}

}
