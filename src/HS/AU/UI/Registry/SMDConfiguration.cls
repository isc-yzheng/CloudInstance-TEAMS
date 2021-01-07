Class HS.AU.UI.Registry.SMDConfiguration Extends HS.UI.Util
{

Parameter PAGENAME = "SMD Configuration Registry";

Parameter RESOURCE = "%HSAdmin_InstallationManagement";

Property msgdelete As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Do you wish to delete this entry?")} ];

Property saveRequiredError As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("All fields are required.")} ];

Property ConfigID As %String;

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
<tablePane id="table"
bodyHeight="200px"
caption="SMD Configuration Registry items currently defined:"
fixedHeaders="false"
queryClass="HS.AU.SMD.Configuration" 
queryName="Items" 

maxRows="1000"
showZebra="true"
valueColumn="ID"
onselectrow="zenPage.rowSelected(zenThis);"
useSnapshot="true"
>
<column colName="ID" hidden="true"/>
<column colName="HPIO" />
<column colName="SigningX509Alias"/>
<column colName="SSLConfig"/>
<parameter value=""/>
</tablePane>

</vgroup>

</pane>
}

XData formPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<button id="btnAddValue" caption="Add Value" onclick="zenPage.showObject('');"/>
<form id="frmConfig" labelPosition="left" hidden="true">
<text id="HPIO" label="HPIO *" size="60"/>
<select id="X509Signing" label="X509 Signing *" />
<select id="SSLConfig" label="SSL Configuration *"/>
<hgroup id="btnGroup" cellAlign="right" width="100%">
<button id="btnNew" caption="New" title="Create a new item" onclick="zenPage.showObject('');"/>
<spacer width="10"/>
<button id="btnSave" caption="Save" title="Save the current item" onclick="zenPage.saveItem();"/>
<spacer width="10"/>
<button id="btnCancel" caption="Cancel" title="Cancel the current edit operation" onclick="zenPage.hideConfig(true);"/>
<spacer width="10"/>
<button id="btnDelete" caption="Delete" title="Delete the current item" onclick="zenPage.deleteItem();"/>
<spacer width="10"/>
</hgroup>
<hgroup labelPosition="left" cellStyle="padding-right:10px;">
<label label="* indicates required field" labelStyle="font-size:10px;" align="left"/>
<label id="LastUpdate" label="Last update:" labelStyle="font-size:10px;" controlClass="zenLabel" value=""/>
</hgroup>
<spacer height="2"/>
</form>
</pane>
}

Method DrawTitle(pSeed As %String) As %Status
{
	Set tTitle = $$$TextHTML("SMD Configuration Registry")
	do %application.DrawTitle(tTitle,0)
	Quit $$$OK
}

ClientMethod refreshTable() [ Language = javascript ]
{
	try {
		var table = zenPage.getComponentById('table');
		table.executeQuery();
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// Show/hide Service form. 
ClientMethod hideConfig(flag) [ Language = javascript ]
{
	zenPage.getComponentById("frmConfig").setHidden(flag);
}

ClientMethod deleteItem() [ Language = javascript ]
{
	try {
		if (confirm(this.msgdelete)) {
			var ok = this.DeleteData(this.ConfigID);
			if (ok == 1) {
				zenPage.hideConfig(true);
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
		Set tSC=##class(HS.AU.SMD.Configuration).%DeleteId(id)
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

ClientMethod showObject(id) [ Language = javascript ]
{
	// update the property for later use
	this.ConfigID = id;
	this.UpdateDetails(id);
}

Method UpdateDetails(PID) [ ZenMethod ]
{
	#dim eException as %Exception.AbstractException
	try {
		
		#dim tObj As HS.AU.SMD.Configuration
		// try to open the object
		
		&js<zenPage.getComponentById('frmConfig').setProperty("hidden",false);>
		If PID '= "" {
			Set tObj = ##class(HS.AU.SMD.Configuration).%OpenId(PID)
			&js<zenPage.getComponentById('btnDelete').setProperty('disabled',false);>
		} Else {
			Set tObj = ##class(HS.AU.SMD.Configuration).%New()
			&js<zenPage.getComponentById('btnDelete').setProperty('disabled',true);>
		}
		
		&js<zenPage.getComponentById('HPIO').setValue('#($ZCVT(tObj.HPIO,"O","JS"))#');>
		&js<zenPage.getComponentById('SSLConfig').setValue('#($ZCVT(tObj.SSLConfig,"O","JS"))#');>
		&js<zenPage.getComponentById('X509Signing').setValue('#($ZCVT(tObj.SigningX509Alias,"O","JS"))#');>
	}Catch eException {
		Set tError=eException.DisplayString()
		&js<alert('#($zcvt(tError,"O","JS"))#');>
	}
	Quit
}

/// Get user selection and send to server to save
ClientMethod saveItem() [ Language = javascript ]
{
	try {
		
		var HPIO = zenPage.getComponentById("HPIO").getValue();
		var SSLConfig = zenPage.getComponentById("SSLConfig").getValue();
		var SigningX509Alias = zenPage.getComponentById("X509Signing").getValue();

		if (HPIO=="" || (SSLConfig=="") || (SigningX509Alias=="")) { alert(this.saveRequiredError);return;}
		var ok = this.SaveData(this.ConfigID, HPIO, SSLConfig,SigningX509Alias);
		if (ok == 1) {
			zenPage.getComponentById("table").setProperty("selectedIndex",-1);
			this.refreshTable();
			zenPage.hideConfig(true);
		} else {
			alert(ok);
		}
	}catch(ex) {
	alert("ERROR: " + ex);
	}
}

/// Save data to server
Method SaveData(pID, pHPIO, pSSLConfig, pSigningX509Alias) As %String [ ZenMethod ]
{
	Set tSC=$$$OK
	try {
		Set idx=0
		If pID ]"" {
			Set tOBJ=##class(HS.AU.SMD.Configuration).%OpenId(pID)
		} Else {
			Set tOBJ=##class(HS.AU.SMD.Configuration).%New()
		}
		Set tOBJ.HPIO = $zstrip(pHPIO,"<>W")
		Set tOBJ.SSLConfig = pSSLConfig
		Set tOBJ.SigningX509Alias=pSigningX509Alias
		Set tSC=tOBJ.%Save()
		Set ..ConfigID=tOBJ.%Id()
	} Catch eException {
		Set tSC=eException.DisplayString()
	}
	Quit tSC
}

Method %OnAfterCreatePage() As %Status
{
	Do ##class(Ens.ContextSearch).SSLConfigs(,,.tList)
	Set cmbSSL = ..%GetComponentById("SSLConfig")
	Set tV=""
	Set tList="" For  Set tList=$O(tList(tList)) Quit:tList=""  Set tV=tV_","_tList(tList) 
	Set cmbSSL.valueList=$e(tV,2,*)
	Set cmbSSL.displayList=$e(tV,2,*)

	Set cmbX509 = ..%GetComponentById("X509Signing")
	Set tRS=##class(%ResultSet).%New("%SYS.X509Credentials:ListAll")
	Set tV=""
	Do tRS.%Execute()
	While tRS.%Next() {
		Set tV=tV_","_tRS.Alias
	}
	Set cmbX509.valueList=$e(tV,2,*)
	Set cmbX509.displayList=$e(tV,2,*)
	Quit $$$OK
}

}
