Class HS.UI.Registry.Services Extends HS.HC.UI.Util
{

/// Displayed name of this page.
Parameter PAGENAME = "Service Registry";

/// Security requirement
Parameter RESOURCE = "%HSAdmin_InstallationManagement";

/// When running Foundation, this will be part of the docbook link, i.e. DocBook.UI.PortalHelpPage.cls?Key=thisvalue
Parameter FOUNDATIONHELPKEY = "FADM_ch_service_registry";

Property msgdelete As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Do you wish to delete this entry?")} ];

Property TypeFile As %ZEN.Datatype.string [ InitialExpression = "FileType.Filename,FileType.FilePath,FileType.Overwrite.chkbox" ];

Property TypeTCP As %ZEN.Datatype.string [ InitialExpression = "TCP.Host,TCP.Port,TCP.SSLConfig.comboValue" ];

Property TypeTCPSpecific As %ZEN.Datatype.string [ InitialExpression = "TCP.StayConnected.chkbox,TCP.ReceivingApplication,TCP.ReceivingFacility" ];

Property TypeUDP As %ZEN.Datatype.string [ InitialExpression = "UDP.Host,UDP.Port,UDP.UDPSenderCommand" ];

Property TypeFTP As %ZEN.Datatype.string [ InitialExpression = "FTP.Host,FTP.Port,FTP.UserCredentialsConfig.comboValue,FTP.UsePassive.chkbox" ];

Property TypeHTTP As %ZEN.Datatype.string [ InitialExpression = "HTTP.ProxyHost,HTTP.ProxyPort,HTTP.URL,HTTP.HTTPCredentialsConfig.comboValue,HTTP.ProxyHTTPS.chkbox,HTTP.ProxyHTTPTunnel.chkbox,HTTP.ProxyHTTPSSLConnect.chkbox,SOAP.SignX509TokenProfile.comboValue" ];

Property TypeSOAP As %ZEN.Datatype.string [ InitialExpression = {$S($SYSTEM.Version.GetMajor()>=2014:"SOAP.SOAPVersion,SOAP.UsernameTokenProfileConfig.comboValue,SOAP.EncryptX509TokenProfile.comboValue,SOAP.SignX509TokenProfile.comboValue,SOAP.MTOM,SOAP.XUAConfiguration.comboTable,SOAP.SendSAMLAssertion.comboValue,SOAP.SecurityClass,SOAP.SSLCheckServerIdentity.chkbox",1:"SOAP.SOAPVersion,SOAP.UsernameTokenProfileConfig.comboValue,SOAP.EncryptX509TokenProfile.comboValue,SOAP.SignX509TokenProfile.comboValue,SOAP.MTOM,SOAP.XUAConfiguration.comboTable,SOAP.SendSAMLAssertion.comboValue,SOAP.SecurityClass")} ];

Property saveNameTypeError As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Name and Type are required fields.")} ];

Property portInvalidError As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Port must be between 1 and 65535")} ];

Property hostError As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Host must be defined")} ];

Property urlError As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("URL must be defined")} ];

Property timeoutError As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Timeout must be a number")} ];

Property ServiceID As %String;

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
/* style for table pane */
#table {
	width: 100%;
	overflow: auto;
	border: solid gray 1px;	
}
#gp1 {
	background: #FFFFCC;
	width:400;
	border: solid gray 1px;
}
.patStyle {
	color: blue;
	font-size: 1.0em;
	font-weight: bold;
}

</style>
}

/// This XML block defines the contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="#(%page.StdTitle)#">
<text id="HideMenu" hidden="true"/>
<html OnDrawContent="DrawTitle" id="title" seed=""/>
<spacer height="10" />
<hgroup>
<spacer width="20"/>
<vgroup cellVAlign="top">
<vgroup>
<pane paneName="detailPane"/>
</vgroup>
<spacer width="50"/>
<vgroup id="formGroup">
<pane paneName="formPane"/>
</vgroup>
</vgroup>
</hgroup>
</page>
}

/// This XML block defines the contents of this page.
XData detailPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<spacer height="5" />

<vgroup>
<hgroup id="gp1" labelPosition="left" containerStyle="padding-top:4px;" cellStyle="padding-left:4px;padding-top:4px;">
<select id="cmbServiceType" label="Service Type" onchange="zenPage.refreshTable();"/>
<text id="txtSearch" label="Search" onchange="zenPage.refreshTable();"/>
</hgroup>
<tableNavigatorBar tablePaneId="table" showPageSize="true"/>
<tablePane id="table"
pageSize="10"
caption="Services currently defined:"
fixedHeaders="false"
queryClass="HS.Registry.Service.Abstract" 
queryName="Services" 

maxRows="10000"
showZebra="true"
valueColumn="ID"
onselectrow="zenPage.rowSelected(zenThis);"
useSnapshot="true"
>
<column colName="Name" />
<column colName="ID" hidden="true"/>
<column colName="Info"/>
<parameter value="SOAP"/>
<parameter value=""/>
</tablePane>

</vgroup>

</pane>
}

XData formPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<hgroup>
<button id="btnAddService" caption="Add Service" onclick="zenPage.showObject('');"/>
<button id="btnParseURL" caption="Parse WebService URL" onclick="zenPage.parseURL();"/>
</hgroup>
<form id="frmServiceType" labelPosition="left" hidden="true">
<text id="Name" label="Name *" size="60" onchange="zenPage.changeSetting();"/>
<textarea id="ServiceAliases" label="Aliases" onchange="zenPage.changeSetting();"/>
<text id="Timeout" label="Timeout" size="5" onchange="zenPage.changeSetting();"/>
<dataCombo size='60' id="DeviceID" label="Device" title="Code from OID Registry" onchange="zenPage.changeSetting();"
 sql="SELECT IdentityCode as Value,IdentityCode,OID FROM HS_Data.OIDMAP WHERE IdentityCode %STARTSWITH ? and ID in (select oidmap from hs_data.OIDMap_IdentityTypes where identityTypes='Device' ) ORDER BY IdentityCode"
 editable="true"
 unrestricted="true"
 searchKeyLen="10"
 maxRows="10000"
 />

<dataCombo size='60' id="HomeCommunityID" label="Home Community" title="Code from OID Registry" onchange="zenPage.changeSetting();"
 sql="SELECT IdentityCode as Value,IdentityCode,OID FROM HS_Data.OIDMAP WHERE IdentityCode %STARTSWITH ? and ID in (select oidmap from hs_data.OIDMap_IdentityTypes where identityTypes='HomeCommunity' ) ORDER BY IdentityCode"
 editable="true"
 unrestricted="true"
 searchKeyLen="10"
 maxRows="10000"
 />
<dataCombo size='60' id="AssigningAuthorityID" label="Assigning Authority" title="Code from OID Registry" onchange="zenPage.changeSetting();"
 sql="SELECT IdentityCode as Value,IdentityCode,OID FROM HS_Data.OIDMAP WHERE IdentityCode %STARTSWITH ? and ID in (select oidmap from hs_data.OIDMap_IdentityTypes where identityTypes='AssigningAuthority' ) ORDER BY IdentityCode"
 editable="true"
 unrestricted="true"
 searchKeyLen="10"
 maxRows="10000"
 />
<dataCombo size='60' id="RepositoryID" label="Repository" title="Code from OID Registry" onchange="zenPage.changeSetting();"
 sql="SELECT IdentityCode as Value,IdentityCode,OID FROM HS_Data.OIDMAP WHERE IdentityCode %STARTSWITH ? and ID in (select oidmap from hs_data.OIDMap_IdentityTypes where identityTypes='Repository' ) ORDER BY IdentityCode"
 editable="true"
 unrestricted="true"
 searchKeyLen="10"
 maxRows="10000"
 />
<dataCombo size='60' id="DeviceFunction" label="Device Function" labelClass="caption" onchange="zenPage.changeSetting();"
	queryClass="HS.UI.Registry.Services"
	queryName="GenericQuery"
	editable="true"
	unrestricted="true"
	searchKeyLen="10"
	OnExecuteResultSet="ExecuteRS"
	maxRows="10000">
	<parameter value = 'DeviceFunction'/>
</dataCombo>
<dataCombo id="TCP.ReceivingApplication" label="Receiving Application" size="60" title="Code - may be from OID Registry" onchange="zenPage.changeSetting();"
 sql="SELECT IdentityCode as Value,IdentityCode,OID FROM HS_Data.OIDMAP WHERE IdentityCode %STARTSWITH ? ORDER BY IdentityCode"
 editable="true"
 unrestricted="true"
 searchKeyLen="10"
 maxRows="10000"
/>
<dataCombo id="TCP.ReceivingFacility" label="Receiving Facility" size="60" title="Code - may be from OID Registry" onchange="zenPage.changeSetting();"
 sql="SELECT IdentityCode as Value,IdentityCode,OID FROM HS_Data.OIDMAP WHERE IdentityCode %STARTSWITH ? ORDER BY IdentityCode"
 editable="true"
 unrestricted="true"
 searchKeyLen="10"
 maxRows="10000"
/>
<checkbox id="Push" label="Delivery Destination" aux="chkbox" onchange="zenPage.changeSetting();"/>
<select id="cmbFormServiceType" label="Service Type *" onchange="zenPage.updateFormFields();zenPage.changeSetting();"/>
<fieldSet id="fldAll" label="Type Specific Settings" labelPosition="left" hidden="false" >
<!-- File -->
<text id="FileType.Filename" label="File Name" size="60" hidden="true" onchange="zenPage.changeSetting();"/>
<text id="FileType.FilePath" label="File Path" size="60" hidden="true" onchange="zenPage.changeSetting();"/>
<checkbox id="FileType.Overwrite.chkbox" label="Overwrite Existing File" hidden="true" aux="chkbox" onchange="zenPage.changeSetting();"/>

<!-- FTP -->
<text id="FTP.Host" label="Host *" size="60" hidden="true" onchange="zenPage.changeSetting();"/>
<text id="FTP.Port" label="Port *" size="5" hidden="true" onchange="zenPage.changeSetting();"/>
<dataCombo id="FTP.UserCredentialsConfig.comboValue" label="User Credentials Config" size="60" hidden="true" onchange="zenPage.changeSetting();"
	queryClass="HS.UI.Registry.Services"
	queryName="GenericQuery"
	editable="true"
	unrestricted="true"
	searchKeyLen="10"
	OnExecuteResultSet="ExecuteRS"
	maxRows="10000">
	<parameter value = 'Username'/>
</dataCombo>

<checkbox id="FTP.UsePassive.chkbox" label="Use Passive" hidden="true" aux="chkbox" onchange="zenPage.changeSetting();"/>

<!-- TCP -->
<text id="TCP.Host" label="Host *" size="60" hidden="true" onchange="zenPage.changeSetting();"/>
<text id="TCP.Port" label="Port" size="5" hidden="true" onchange="zenPage.changeSetting();"/>
<dataCombo size='60' id="TCP.SSLConfig.comboValue" label="SSL Configuration" hidden="true" labelClass="caption" onchange="zenPage.changeSetting();"
	queryClass="HS.UI.Registry.Services"
	queryName="GenericQuery"
	editable="true"
	unrestricted="true"
	searchKeyLen="10"
	OnExecuteResultSet="ExecuteRS"
	maxRows="10000">
	<parameter value = 'SSL'/>
</dataCombo>

<checkbox id="TCP.StayConnected.chkbox" label="Stay Connected" aux="chkbox" hidden="true" onchange="zenPage.changeSetting();"/>

<!-- HTTP URL -->
<text id="HTTP.URL" label="URL *" size="60" hidden="true" onchange="zenPage.changeSetting();"/>

<!-- SOAP -->
<text id="SOAP.SOAPVersion" label="Soap Version" size="60" hidden="true" onchange="zenPage.changeSetting();"/>

<dataCombo size='60' id="SOAP.UsernameTokenProfileConfig.comboValue" label="Username Token Profile" hidden="true" onchange="zenPage.changeSetting();"
	queryClass="HS.UI.Registry.Services"
	queryName="GenericQuery"
	editable="true"
	unrestricted="true"
	searchKeyLen="10"
	OnExecuteResultSet="ExecuteRS"
	maxRows="10000">
	<parameter value = 'Username'/>
</dataCombo>

<dataCombo size='60' id="SOAP.EncryptX509TokenProfile.comboValue" label="X509 Token Profile for Encryption"  hidden="true" onchange="zenPage.changeSetting();"
	queryClass="HS.UI.Registry.Services"
	queryName="GenericQuery"
	editable="true"
	unrestricted="true"
	searchKeyLen="10"
	OnExecuteResultSet="ExecuteRS"
	maxRows="10000">
	<parameter value = 'X509'/>
</dataCombo>

<dataCombo size='60' id="SOAP.SignX509TokenProfile.comboValue" label="X509 Token Profile for Digital Signing"  hidden="true" onchange="zenPage.changeSetting();"
	queryClass="HS.UI.Registry.Services"
	queryName="GenericQuery"
	editable="true"
	unrestricted="true"
	searchKeyLen="10"
	OnExecuteResultSet="ExecuteRS"
	maxRows="10000">
	<parameter value = 'X509'/>
</dataCombo>

<!--<text id="SOAP.KerberosTokenProfileConfig" label="Kerberos Token Profile" size="60" hidden="true" onchange="zenPage.changeSetting();"/>-->
<checkbox id="SOAP.MTOM" label="MTOM" hidden="true" aux="chkbox" onchange="zenPage.changeSetting();"/>
<dataCombo maxRows="10000" size='60' id="SOAP.XUAConfiguration.comboTable" label="XUA Configuration" hidden="true" queryClass="HS.IHE.XUA.Config" queryName="Items" onchange="zenPage.changeSetting();" displayColumns="2,3" sqlLookup="Select Name from HS_IHE_XUA.Config where ID=?"/>
<select id="SOAP.SendSAMLAssertion.comboValue" label="Send SAML Assertion" aux="combo" hidden="true" onchange="zenPage.changeSetting();"/>
<text id="SOAP.SecurityClass" label="Security Class" title="Optional, to override default security (signing and encryption). See HS.Util.SOAPClient.Base:AddSecurity for more information." size="60" hidden="true" onchange="zenPage.changeSetting();"/>
<checkbox id="SOAP.SSLCheckServerIdentity.chkbox" label="Check Server Identity" hidden="true" aux="chkbox" title="Validate certificate identity matches server name" onchange="zenPage.changeSetting();"/>

<!-- HTTP -->
<text id="HTTP.ProxyHost" label="Proxy Host" size="60" hidden="true" onchange="zenPage.changeSetting();"/>
<text id="HTTP.ProxyPort" label="Proxy Port" size="5" hidden="true" onchange="zenPage.changeSetting();"/>
<dataCombo id="HTTP.HTTPCredentialsConfig.comboValue" size="60" label="HTTPCredentialsConfig" hidden="true" onchange="zenPage.changeSetting();"
	queryClass="HS.UI.Registry.Services"
	queryName="GenericQuery"
	editable="true"
	unrestricted="true"
	searchKeyLen="10"
	OnExecuteResultSet="ExecuteRS"
	maxRows="10000">
	<parameter value = 'Username'/>
</dataCombo>

<checkbox id="HTTP.ProxyHTTPS.chkbox" label="Proxy HTTPS" hidden="true" aux="chkbox" onchange="zenPage.changeSetting();"/>
<checkbox id="HTTP.ProxyHTTPTunnel.chkbox" label="Proxy Tunnel" hidden="true" aux="chkbox" onchange="zenPage.changeSetting();"/>
<checkbox id="HTTP.ProxyHTTPSSLConnect.chkbox" label="Proxy HTTPS SSLConnect" hidden="true" aux="chkbox" onchange="zenPage.changeSetting();"/>

<!-- UDP -->
<text id="UDP.Host" label="Host *" size="60" hidden="true" onchange="zenPage.changeSetting();"/>
<text id="UDP.Port" label="Port *" size="5" hidden="true" onchange="zenPage.changeSetting();"/>
<text id="UDP.UDPSenderCommand" label="UDP Sender Command" size="60" hidden="true" onchange="zenPage.changeSetting();"/>

</fieldSet>
<hgroup id="btnGroup" cellAlign="right" width="100%">
<button id="btnNew" caption="New" title="Create a new item" onclick="zenPage.showObject('');"/>
<spacer width="10"/>
<button id="btnSave" caption="Save" title="Save the current item" disabled="true" onclick="zenPage.saveItem();"/>
<spacer width="10"/>
<button id="btnCancel" caption="Cancel" title="Cancel the current edit operation" onclick="zenPage.hideService(true);"/>
<spacer width="10"/>
<button id="btnDelete" caption="Delete" title="Delete the current item" onclick="zenPage.deleteItem();"/>
<spacer width="10"/>
<button id="btnCopy" caption="Copy" title="Copy the current item" onclick="zenPage.copyItem();"/>
<spacer width="10"/>
</hgroup>
<hgroup labelPosition="left" cellStyle="padding-right:10px;">
<label label="* indicates required field" labelStyle="font-size:10px;" align="left"/>
</hgroup>
<spacer height="2"/>

</form>
</pane>
}

Method DrawTitle(pSeed As %String) As %Status
{
	If ..%GetComponentById("HideMenu").value Quit $$$OK
	Set tTitle = $ZCVT($$$FormatText($$$Text("Service Registry"),$namespace),"O","HTML")	
	do %application.DrawTitle(tTitle,0)
	Quit $$$OK
}

/// User updated something enable the save
ClientMethod changeSetting() [ Language = javascript ]
{
	var flag=0;
	var serviceType = zenPage.getComponentById("cmbFormServiceType").getValue();
	var name = zenPage.getComponentById('Name').getValue();
	if (serviceType=="" || name=="") { var flag=1;}

	this.disableSave(flag);
}

ClientMethod getFieldlist() [ Language = javascript ]
{
	try {
		var serviceTypeObject = zenPage.getComponentById("cmbFormServiceType");
		var serviceType = serviceTypeObject.getValue();
		var fields = "";
		var fieldlist = "";
		switch (serviceType) {
			case "FileType":
				fields = this.TypeFile;
				break;
			case "FTP":
				fields = this.TypeFile+","+this.TypeFTP;
				break;			
			case "TCP":
				fields = this.TypeTCP +","+ this.TypeTCPSpecific
				break;					
			case "HTTP":
				fields = this.TypeTCP + "," + this.TypeHTTP;
				break;					
			case "SOAP":
				fields = this.TypeTCP + "," + this.TypeHTTP + "," + this.TypeSOAP;
				break;					
			case "UDP":	
				fields = this.TypeUDP;
				break;					
		}
	} catch (ex) {
		alert("Error: " + ex);	
	}
	return fields;
}

ClientMethod updateFormFields() [ Language = javascript ]
{
	try {
		var serviceTypeObject = zenPage.getComponentById("cmbFormServiceType");
		var serviceType = serviceTypeObject.getValue();
		var serviceTypeIndex = serviceTypeObject.getSelectedIndex;
		var form = zenPage.getComponentById("frmServiceType")
		var fieldlist = this.getFieldlist();
		var fields = fieldlist.split(",");
		var allTypes = this.TypeFile+","+this.TypeFTP+","+this.TypeTCP+","+this.TypeTCPSpecific+","+this.TypeHTTP+","+this.TypeSOAP+","+this.TypeUDP;
		var all = allTypes.split(",");
		var len = all.length;
		for (var i=0;i<len;i++) {
			zenPage.getComponentById(all[i]).setValue('');
			zenPage.getComponentById(all[i]).setHidden(true);
		}
		
		len = fields.length;
		if(fieldlist!='') {
			for (var i=0;i<len;i++) {
				zenPage.getComponentById(fields[i]).setHidden(false);
			}
		}
		if(serviceType=='SOAP') {
			zenPage.getComponentById('btnParseURL').setHidden(false);
		} else {
			zenPage.getComponentById('btnParseURL').setHidden(true);
		}
		if(serviceType=='TCP'){//TCP requires a non-empty port
			zenPage.getComponentById('TCP.Port').setProperty("label","Port *");
		}
		else{//HTML and SOAP use the same field but the port may be empty
			zenPage.getComponentById('TCP.Port').setProperty("label","Port");
		}
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

ClientMethod refreshTable() [ Language = javascript ]
{
	try {
		var table = zenPage.getComponentById('table');
		table.parameters[0].value = zenPage.getComponentById("cmbServiceType").getValue();
		table.parameters[1].value = zenPage.getComponentById("txtSearch").getValue();
		table.executeQuery();
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// Show/hide Service form. 
ClientMethod hideService(flag) [ Language = javascript ]
{
	zenPage.getComponentById("frmServiceType").setHidden(flag);
}

ClientMethod copyItem() [ Language = javascript ]
{
	try {
		if(this.ServiceID=='') return;
		this.ServiceID='';
		zenPage.getComponentById('Name').setValue("Copy."+zenPage.getComponentById('Name').getValue());
		this.changeSetting();
		zenPage.getComponentById('btnDelete').setProperty('disabled',true);
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

ClientMethod deleteItem() [ Language = javascript ]
{
	try {
		if (confirm(this.msgdelete)) {
			var ok = this.DeleteData(this.ServiceID);
			if (ok == 1) {
				zenPage.hideService(true);
				var table = zenPage.getComponentById("table");	
				table.executeQuery();
			} else {
				alert(ok);
			}
		}
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

ClassMethod DeleteData(id) As %String [ ZenMethod ]
{
	
	try {
		Set tSC=##class(HS.Registry.Service.Abstract).%DeleteId(id)
	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	Quit +tSC
}

/// User selected a row in the table. 
ClientMethod rowSelected(table) [ Language = javascript ]
{
	if (table.getValue() > 0) {
		zenPage.showObject(table.getValue());
	}
}

ClientMethod parseURL() [ Language = javascript ]
{
	var url = prompt("What is the URL", "");
	if(url == null) return;
	this.ServiceID = '';
	this.UpdateDetailsSync('');
	this.disableSave(1);
	this.ServerParseURL(url);
}

ClientMethod showObject(id) [ Language = javascript ]
{
	// update the property for later use
	this.ServiceID = id;
	this.UpdateDetails(id);
	this.disableSave(1);
}

Method ServerParseURL(pURL) As %String [ ZenMethod ]
{
	Set tWS = ##class(HS.Registry.Service.SOAP).%New()
	Do tWS.ParseURL(pURL)
	&js<zenPage.getComponentById("HTTP.URL").setValue('#($ZCVT(tWS.URL,"O","JS"))#');>
	&js<zenPage.getComponentById("TCP.Host").setValue('#($ZCVT(tWS.Host,"O","JS"))#');>
	&js<zenPage.getComponentById("TCP.Port").setValue('#($ZCVT(tWS.Port,"O","JS"))#');>
	Quit ""
}

Method UpdateDetailsSync(pID, pService As HS.Registry.Service.SOAP = "") As %String [ ZenMethod ]
{
		Do ..UpdateDetails(pID,pService)
		Quit ""
}

Method UpdateDetails(PID, pService As HS.Registry.Service.SOAP = "") [ ZenMethod ]
{
	try {
		#; Typical usage is service, so we want the defaults (particularly SSLCheckServerIdentity)
		Set:pService="" pService=##class(HS.Registry.Service.SOAP).%New()
		#dim tObj As HS.Registry.Service.Abstract
		// try to open the object
		
		Set tAliasList=""
		
		&js<zenPage.getComponentById('frmServiceType').setProperty("hidden",false);>
		If PID '= "",##class(HS.Registry.Service.Abstract).%ExistsId(PID) {
			Set tObj = ##class(HS.Registry.Service.Abstract).%OpenId(PID)
			&js<zenPage.getComponentById('btnDelete').setProperty('disabled',false);>
			&js<zenPage.getComponentById('btnCopy').setProperty('disabled',false);>
			&js<zenPage.getComponentById('cmbFormServiceType').setProperty("disabled",true);>
			
			For tI=1:1:tObj.ServiceAliases.Count() {
				Set tAlias=tObj.ServiceAliases.GetAt(tI)
				If tAliasList'="" {
					Set tAliasList=tAliasList_$Char(10)_tAlias
				} Else {
					Set tAliasList=tAliasList_tAlias
				}
			}
			Set tObjType=tObj.%ClassName(0)
		} ElseIf $isObject(pService) {
			Set tObj=pService
			&js<zenPage.getComponentById('btnDelete').setProperty('disabled',true);>
			&js<zenPage.getComponentById('btnCopy').setProperty('disabled',true);>
			&js<zenPage.getComponentById('cmbFormServiceType').setProperty("disabled",false);>
			Set tObjType=tObj.%ClassName(0)
		} Else {
			Set tObj = ##class(HS.Registry.Service.FileType).%New()
			&js<zenPage.getComponentById('btnDelete').setProperty('disabled',true);>
			&js<zenPage.getComponentById('btnCopy').setProperty('disabled',true);>
			&js<zenPage.getComponentById('cmbFormServiceType').setProperty("disabled",false);>
			Set tObjType=""
		}
		
		&js<zenPage.getComponentById('cmbFormServiceType').setValue('#($S(tObjType="Abstract":"",1:tObjType))#');>
		&js<zenPage.updateFormFields();>
		&js<zenPage.getComponentById('Name').setValue('#($ZCVT(tObj.Name,"O","JS"))#');>
		&js<zenPage.getComponentById('ServiceAliases').setValue('#($ZCVT(tAliasList,"O","JS"))#');>
		&js<zenPage.getComponentById('Timeout').setValue('#($ZCVT(tObj.Timeout,"O","JS"))#');>
		&js<zenPage.getComponentById('DeviceID').setValue('#($ZCVT(tObj.OIDMapCode.GetAt("Device"),"O","JS"))#');>
		&js<zenPage.getComponentById('HomeCommunityID').setValue('#($ZCVT(tObj.OIDMapCode.GetAt("HomeCommunity"),"O","JS"))#');>
		&js<zenPage.getComponentById('AssigningAuthorityID').setValue('#($ZCVT(tObj.OIDMapCode.GetAt("AssigningAuthority"),"O","JS"))#');>
		&js<zenPage.getComponentById('RepositoryID').setValue('#($ZCVT(tObj.OIDMapCode.GetAt("Repository"),"O","JS"))#');>
		&js<zenPage.getComponentById('DeviceFunction').setValue('#($ZCVT(tObj.DeviceFunction,"O","JS"))#');>
		&js<zenPage.getComponentById('Push').setValue('#($S(tObj.Push="":1,1:tObj.Push))#');>
		Set tFields=""
		if (tObjType="TCP") || (tObjType="HTTP") || (tObjType="SOAP") {
			Set tFields=..TypeTCP
			If (tObjType="HTTP") || (tObjType="SOAP") Set tFields=tFields_","_..TypeHTTP
			If (tObjType="SOAP") Set tFields=tFields_","_..TypeSOAP 
			If tObjType="TCP" Set tFields=tFields_","_..TypeTCPSpecific
		} ElseIf (tObjType="FileType") || (tObjType="FTP") {
			Set tFields=..TypeFile
			If (tObjType="FTP") Set tFields=tFields_","_..TypeFTP
		} ElseIf tObjType="UDP" { 
			Set tFields=..TypeUDP
		}
		For tIdx=1:1:$l(tFields,",") {
			Set tField=$p(tFields,",",tIdx)
			Continue:tField=""
			Set tDBField=$p(tField,".",2)
			If $p(tField,".",3)]"" {
				If $p(tField,".",3)="chkbox" {
					Set tValue=$zobjProperty(tObj,tDBField)
					&js<zenPage.getComponentById('#(tField)#').setValue('#($S(tValue=1:"true",1:"false"))#');>	
				} ElseIf $p(tField,".",3)="comboValue" {
					Set tValue=$zobjProperty(tObj,tDBField)
					&js<zenPage.getComponentById('#(tField)#').setValue('#($zcvt(tValue,"O","JS"))#');>	
				} ElseIf $p(tField,".",3)="comboTable" {
					Set tValue=$zobjProperty(tObj,tDBField)
					Set tValue=$S($isObject(tValue):tValue.%Id(),1:"")
					&js<zenPage.getComponentById('#(tField)#').setValue('#(tValue)#');>	
				}
			} ElseIf tField="TCP.ReceivingApplication"!(tField="TCP.ReceivingFacility") {
				&js<zenPage.getComponentById('#(tField)#').setValue('#($ZCVT(tObj.OIDMapCode.GetAt(tDBField),"O","JS"))#');>
			} Else {
				&js<zenPage.getComponentById('#(tField)#').setValue('#($ZCVT($zobjProperty(tObj,tDBField),"O","JS"))#');>	
			}
		}
		
	}Catch eException {
		Set tSC=eException.DisplayString()
		&js<alert('#(tSC)#');>
	}
	Quit
}

ClientMethod validPort(port) [ Language = javascript ]
{
	// port is valid as "" when SOAP or HTTP
	var type = zenPage.getComponentById("cmbFormServiceType").getValue()
	if((type=='SOAP' || type=='HTTP') && port=='') return true;
	var valid = false;
	if(!isNaN(port)) {
		if(Math.max(port,65535)==65535) {
			if(Math.min(port,1)==1) {
				valid=true;
			}
		}
	}
	return valid
}

ClientMethod validate() [ Language = javascript ]
{
	var msg='';

	
	var serviceType = zenPage.getComponentById("cmbFormServiceType").getValue();
	var name = zenPage.getComponentById('Name').getValue();
	if (serviceType=="" || name=="") { msg=msg+zenPage.saveNameTypeError+"\n";}

	var timeout = zenPage.getComponentById('Timeout').getValue();
	if(timeout!="" && (isNaN(timeout))) {
		msg=msg+zenPage.timeoutError+"\n";
	}
		
	if(serviceType=='TCP' || (serviceType=='SOAP') || (serviceType=='HTTP')) {
		if(!zenPage.validPort(zenPage.getComponentById("TCP.Port").getValue())) {
			msg=msg+zenPage.portInvalidError+"\n";
		}
		if(zenPage.getComponentById("TCP.Host").getValue()=='') {
			msg=msg+zenPage.hostError+"\n";
		}
	}

	if(serviceType=='FTP') {
		if(!zenPage.validPort(zenPage.getComponentById("FTP.Port").getValue())) {
			msg=msg+zenPage.portInvalidError+"\n";
		}
		if(zenPage.getComponentById("FTP.Host").getValue()=='') {
			msg=msg+zenPage.hostError+"\n";
		}
	}

	if(serviceType=='UDP') {
		if(!zenPage.validPort(zenPage.getComponentById("UDP.Port").getValue())) {
			msg=msg+zenPage.portInvalidError+"\n";
		}
		if(zenPage.getComponentById("UDP.Host").getValue()=='') {
			msg=msg+zenPage.hostError+"\n";
		}
	}


	if((serviceType=='SOAP') || (serviceType=='HTTP')) {
		var proxyPort = zenPage.getComponentById("HTTP.ProxyPort").getValue();
		if (proxyPort!='' && !zenPage.validPort(proxyPort)) {
			msg=msg+zenPage.portInvalidError+"\n";
		}

		if(zenPage.getComponentById("HTTP.URL").getValue()=='') {
			msg=msg+zenPage.urlError+"\n";
		}
	}

	if (msg == '') {
		return true;
	} else {
		alert(msg);
		return false;
	}
}

/// Get user selection and send to server to save
ClientMethod saveItem() [ Language = javascript ]
{
	try {
	  if (zenPage.validate()) {
		
		var delim="_|_|_|";
		var type = zenPage.getComponentById("cmbFormServiceType").getValue();
		var name = zenPage.getComponentById('Name').getValue();
		var Aliases = zenPage.getComponentById("ServiceAliases").getValue();
		if (type=="" || name=="") { alert(this.saveNameTypeError);return;}
		var submit = type + delim + this.ServiceID + delim + name + delim + Aliases;
		submit = submit + delim + zenPage.getComponentById('Timeout').getValue();
		submit = submit + delim + zenPage.getComponentById('DeviceID').getValue();
		submit = submit + delim + zenPage.getComponentById('DeviceFunction').getValue();
		submit = submit + delim + zenPage.getComponentById('HomeCommunityID').getValue();
		submit = submit + delim + zenPage.getComponentById('AssigningAuthorityID').getValue();
		submit = submit + delim + zenPage.getComponentById('RepositoryID').getValue();
		var push=zenPage.getComponentById('Push').getValue()?'1':'0';
		submit = submit + delim + push
		submit = submit + delim + '';  // status
		submit = submit + delim + '';  // charset
	
		var fieldlist = this.getFieldlist();
		var fields = fieldlist.split(",");
		len = fields.length;
		for (var i=0;i<len;i++) {
			var component = zenPage.getComponentById(fields[i]);
			var value = component.getValue();
			if (component.aux=="chkbox") {
				if (value==true) {value=1;}
				else { value=0;}
			}
			submit=submit+delim+value;
		}
		var ok = this.SaveData(submit,fieldlist);
		if (ok == 1) {
			zenPage.getComponentById("table").setProperty("selectedIndex",-1);
			this.refreshTable();
			zenPage.hideService(true);
		} else {
			alert(ok);
		}
		
	  }		
	}catch(ex) {
	alert("ERROR: " + ex);
	}
}

/// Save data to server
Method SaveData(submit, fields) As %String [ ZenMethod ]
{
	#define item(%var,%item) $p(%var,"_|_|_|",$i(%item))
	Set tSC=$$$OK
	try {
		Set idx=0
		#; idx is a $i of the counter (next value) for every time it is run
		Set tType=$$$item(submit,idx)  //$p(submit,tDelim,1)
		Set tID = $$$item(submit,idx)
		If tID ]"" {
			Set tOBJ=$zobjclassmethod("HS.Registry.Service."_tType,"%OpenId",tID)
		} Else {
			Set tOBJ=$zobjclassmethod("HS.Registry.Service."_tType,"%New")
		}
		/// the order of the properties is determined strictly by the order assigned in js submit variable
		Set tOBJ.Type=tType
		Set tOBJ.Name=$$$item(submit,idx)
		Set tAliases=$$$item(submit,idx)
		Set tOBJ.Timeout=$$$item(submit,idx)
		Set tDeviceID=$$$item(submit,idx)
		Set tOBJ.DeviceFunction=$$$item(submit,idx)
		Set tHomeCommunityID=$$$item(submit,idx)
		Set tAssigningAuthority=$$$item(submit,idx)
		Set tRepositoryID=$$$item(submit,idx)
		Set tOBJ.Push=$$$item(submit,idx)
		If tDeviceID]"" {Do tOBJ.OIDMapCode.SetAt(tDeviceID,"Device")} Else {Do tOBJ.OIDMapCode.RemoveAt("Device")}
		If tHomeCommunityID]"" {Do tOBJ.OIDMapCode.SetAt(tHomeCommunityID,"HomeCommunity")} Else {Do tOBJ.OIDMapCode.RemoveAt("HomeCommunity")}
		If tAssigningAuthority]"" {Do tOBJ.OIDMapCode.SetAt(tAssigningAuthority,"AssigningAuthority")} Else {Do tOBJ.OIDMapCode.RemoveAt("AssigningAuthority")}
		If tRepositoryID]"" {Do tOBJ.OIDMapCode.SetAt(tRepositoryID,"Repository")} Else {Do tOBJ.OIDMapCode.RemoveAt("Repository")}
		Set tStatus=$$$item(submit,idx)
		Set tCharset=$$$item(submit,idx)
		For tIdx = 1:1:$l(fields,",") {
			Set tField=$p($p(fields,",",tIdx),".",2)
			Set tType=$p($p(fields,",",tIdx),".",3)
			Set tItem = $$$item(submit,idx)
			If tType="comboTable" {
				 Do $method(tOBJ,tField_"SetObjectId",tItem)
			} ElseIf tField="ReceivingApplication"!(tField="ReceivingFacility") {
				If tItem]"" {Do tOBJ.OIDMapCode.SetAt(tItem,tField)} Else {Do tOBJ.OIDMapCode.RemoveAt(tField)}
			} Else {
				Set $property(tOBJ,tField)=tItem
			}
		}
		
		Do tOBJ.ServiceAliases.Clear()
		Set count=$L(tAliases,$Char(10))
		For tI=1:1:count {
			Set tAlias=$P(tAliases,$Char(10),tI)
			Do:tAlias'="" tOBJ.ServiceAliases.Insert(tAlias)
		}
		
		Set tExistingID = ##class(HS.Registry.Service.Abstract).IDForNameType(tOBJ.Name,tOBJ.Type)
		If tExistingID'="",tID'=tExistingID Set tSC = "Service with this Name and Service Type already exists" Quit
		Set tSC=tOBJ.%Save()
		If $$$ISERR(tSC) Set tSC = $system.Status.GetErrorText(tSC)
		Set ..ServiceID=tOBJ.%Id()
	} Catch eException {
		Set tSC=eException.DisplayString()
	}

	Quit tSC
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	#; when called from HS.Test.UI.Main don't show the main menu as we're in a tab
	If $G(%request.Data("HideMenu",1)) {
		Set ..%GetComponentById("HideMenu").value = 1
	}
	Set cmbServiceType = ..%GetComponentById("cmbServiceType")
	Set vl="FileType,FTP,HTTP,SOAP,TCP,UDP"
	Set dl="File,FTP,HTTP,SOAP,TCP,UDP"
	Set cmbServiceType.valueList=vl
	Set cmbServiceType.displayList=dl
	Set cmbFormServiceType=..%GetComponentById("cmbFormServiceType")
	Set cmbFormServiceType.valueList=vl
	Set cmbFormServiceType.displayList=dl
	Set cmbServiceType.value="SOAP"
	Set dl=",No,Forward,Create,Create then Forward,Forward then Create,Forward or Create"
	Set vl=",0,1,2,3,4,5"
	Set cmbSendSAML=..%GetComponentById("SOAP.SendSAMLAssertion.comboValue")
	Set cmbSendSAML.valueList=vl
	Set cmbSendSAML.displayList=dl
	Quit $$$OK
}

ClassMethod GetSSL(pArray, StartsWith As %String) As %Status
{
	Set tSC= ##class(Ens.ContextSearch).SSLConfigs(,,.tResults)
	If $$$ISERR(tSC) Quit tSC
	Set (tList,tI)=""
	For {
		Set tI=$O(tResults(tI)) Quit:tI=""
		Set tValue=tResults(tI)
		If StartsWith]"",$E($zcvt(tValue,"U"),1,$L(StartsWith))'=StartsWith Continue
		Set pArray($i(pArray))=$lb(tValue,tValue)
	}
	Quit tSC
}

ClassMethod GetDeviceFunction(pArray, StartsWith As %String) As %Status
{
	For tValue="PDQv2.Supplier","PDQv3.Supplier","PIXv2.Consumer","PIXv2.Manager","PIXv3.Consumer","PIXv3.Manager",
				"XCA.Query","XDSb.NotifyAndQueryEdge","XDSb.Query","XDSb.Retrieve","PIXm.Manager","PDQm.Supplier",
				"MHD.Query","MHD.Retrieve","XCAI.Retrieve","XDSI.Retrieve","RMU","RMD" {
		If StartsWith]"",$E($zcvt(tValue,"U"),1,$L(StartsWith))'=StartsWith Continue
		Set tArray(tValue)=""
	}
	Set tValue=""
	For  {
		Set tValue=$O(tArray(tValue)) Quit:tValue=""
		Set pArray($i(pArray))=$lb(tValue,tValue)
	}
	Quit $$$OK
}

ClassMethod GetUsernameTokenProfile(pArray, StartsWith) As %Status
{
	Set tSC= ##class(Ens.ContextSearch).Credentials(,,.tResults)
	If $$$ISERR(tSC) Quit tSC
	Set (tList,tI)=""
	For {
		Set tI=$O(tResults(tI)) Quit:tI=""
		Set tValue=tResults(tI)
		If StartsWith]"",$E($zcvt(tValue,"U"),1,$L(StartsWith))'=StartsWith Continue
		Set pArray($i(pArray))=$lb(tValue,tValue)
	}
	Quit tSC
}

/// Get a list of SSL/TLS Configurations
ClassMethod GetX509Configs(pArray, StartsWith) As %Status
{
	Set tSC=$$$OK
	Try {
		S tRS=##class(%ResultSet).%New("%SYS.X509Credentials:ListDetails")
		If '$IsObject(tRS) Set tSC = %objlasterror Quit
		Set (tList,tI)=""
		Set tSC = tRS.%Execute()  Quit:$$$ISERR(tSC)
		While (tRS.%Next(.tSC)) {
			Set tValue=tRS.Get("Alias")
			If StartsWith]"",$E($zcvt(tValue,"U"),1,$L(StartsWith))'=StartsWith Continue
			Set pArray($i(pArray))=$lb(tValue,tValue)
		}
	}
	Catch {
		Set tSC = $$$ERROR($$$ObjectScriptError,$ZE)
	}
	Quit tSC
}

ClassMethod GetOIDs(myRS As %ResultSet, Output pSC As %Status, pInfo As %ZEN.Auxiliary.QueryInfo) As %Boolean
{
	Set pSC = myRS.Execute("",pInfo.parms(1))
	Quit +pSC
}

Method ExecuteRS(myRS As %ResultSet, Output pSC As %Status, pInfo As %ZEN.Auxiliary.QueryInfo) As %Boolean
{
	/// execute query code with uppercase startswith and the type
	Quit myRS.%Execute($zcvt(pInfo.parms(1),"U"),pInfo.parms(2))
}

Query GenericQuery(StartsWith As %String, Type As %String) As %Query(ROWSPEC = "ID:%String,Description:%String")
{
}

ClassMethod GenericQueryExecute(ByRef qHandle As %Binary, StartsWith As %String, Type As %String) As %Status
{
	If Type="SSL" {
		Set tSC = ..GetSSL(.qHandle,StartsWith)
	} ElseIf Type="Username" {
		Set tSC = ..GetUsernameTokenProfile(.qHandle,StartsWith)
	} ElseIf Type="DeviceFunction" {
		Set tSC = ..GetDeviceFunction(.qHandle,StartsWith)
	} Else {
		Set tSC = ..GetX509Configs(.qHandle,StartsWith)
	}
	Set qHandle=""
	Quit $$$OK
}

ClassMethod GenericQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GenericQueryExecute ]
{
	Quit $$$OK
}

ClassMethod GenericQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GenericQueryExecute ]
{
	Set qHandle = $o(qHandle(qHandle))
	Set AtEnd=(qHandle="")
	Set Row=$S(AtEnd=1:"",1:qHandle(qHandle))
	Set:'AtEnd AtEnd=($o(qHandle(qHandle))="")
	Quit $$$OK
}

}
