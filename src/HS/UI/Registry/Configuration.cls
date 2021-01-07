/// Define and manage key/value pairs from HS.Registry.Config
Class HS.UI.Registry.Configuration Extends HS.HC.UI.Util
{

Parameter PAGENAME = "Configuration Registry";

Parameter RESOURCE = "%HSAdmin_InstallationManagement";

/// When running Foundation, this will be part of the docbook link, i.e. DocBook.UI.PortalHelpPage.cls?Key=thisvalue
Parameter FOUNDATIONHELPKEY = "FADM_ch_configuration_registry";

Property msgdelete As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Do you wish to delete this entry?")} ];

Property saveRequiredError As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Key is required.")} ];

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
caption="Configuration Registry items currently defined:"
fixedHeaders="false"
queryClass="HS.Registry.Config" 
queryName="ConfigItems" 

maxRows="10000"
showZebra="true"
valueColumn="ID"
onselectrow="zenPage.rowSelected(zenThis);"
useSnapshot="true"
>
<column colName="RegKey" />
<column colName="ID" hidden="true"/>
<column colName="RegValue"/>
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
<text id="RegKey" label="Key *" size="60"/>
<text id="RegValue" label="Value" size="60"/>
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
	Set tTitle = $$$TextHTML("Configuration Registry")
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
		Set tSC=##class(HS.Registry.Config).%DeleteId(id)
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
		
		#dim tObj As HS.Registry.Config
		// try to open the object
		
		&js<zenPage.getComponentById('frmConfig').setProperty("hidden",false);>
		If PID '= "",##class(HS.Registry.Config).%ExistsId(PID) {
			Set tObj = ##class(HS.Registry.Config).%OpenId(PID)
			&js<zenPage.getComponentById('btnDelete').setProperty('disabled',false);>
		} Else {
			Set tObj = ##class(HS.Registry.Config).%New()
			&js<zenPage.getComponentById('btnDelete').setProperty('disabled',true);>
		}
		
		&js<zenPage.getComponentById('RegKey').setValue('#($ZCVT(tObj.RegKey,"O","JS"))#');>
		&js<zenPage.getComponentById('RegValue').setValue('#($ZCVT(tObj.RegValue,"O","JS"))#');>
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
		
		var RegKey = zenPage.getComponentById("RegKey").getValue();
		var RegValue = zenPage.getComponentById("RegValue").getValue();

		if (RegKey=="") { alert(this.saveRequiredError);return;}
		var ok = this.SaveData(this.ConfigID, RegKey, RegValue);
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
Method SaveData(pID, pRegKey, pRegValue) As %String [ ZenMethod ]
{
	Set tSC=$$$OK
	try {
		Set idx=0
		If pID ]"" {
			Set tOBJ=##class(HS.Registry.Config).%OpenId(pID)
		} Else {
			Set tOBJ=##class(HS.Registry.Config).%New()
		}
		Set tOBJ.RegKey = $zstrip(pRegKey,"<>W")
		Set tOBJ.RegValue = pRegValue
		Set tSC=tOBJ.%Save()
		Set ..ConfigID=tOBJ.%Id()
	} Catch eException {
		Set tSC=eException.DisplayString()
	}
	Quit tSC
}

}
