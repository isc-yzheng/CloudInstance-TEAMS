/// List of trusted RSA public keys
Class HS.UI.Registry.RSAConfig Extends HS.HC.UI.Template
{

/// Displayed name of this page.
Parameter PAGENAME = "Trusted RSA Key Registry";

/// Security requirement
Parameter RESOURCE = "%HSAdmin_InstallationManagement";

Parameter TABLE = "rsaTable";

Parameter FIELDSET = "rsaFieldSet";

Property aliasRequiredError As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("The alias field is required.")} ];

Property pubKeyRequiredError As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("The public key field is required.")} ];

Property msgcancelItem As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Do you wish to discard changes and reset form?")} ];

Property msgdelete As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Do you wish to delete this entry?")} ];

Property OIDID As %String;

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

<tablePane id="rsaTable"
bodyHeight="200px"
caption="RSA keys currently defined:"
fixedHeaders="false"
queryClass="HS.Registry.RSAKey"
queryName="Items" 

maxRows="10000"
showZebra="true"
valueColumn="ID"
onselectrow="zenPage.rowSelected(zenThis);"
useSnapshot="true"
>
<column colName="ID" hidden="true"/>
<column colName="Alias" width="20%"/>
<column colName="Modulus" width="60%" header="Public Key Modulus (Base64 encoded)"/>
<column colName="Exponent" width="20%" header="Public Key Exponent (Base64 encoded)"/>
</tablePane>

</vgroup>

</pane>
}

XData formPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<button id="btnAdd" caption="Add trusted key" onclick="zenPage.showObject('');"/>
<fieldSet id="rsaFieldSet" hidden="true" labelPosition="left">
<text id="Alias" label="Alias" size="60"/>
<text id="Modulus" label="Public Key Modulus (Base64 encoded) *" size="60"/>
<text id="Exponent" label="Public Key Exponent (Base64 encoded) *" size="30"/>

<hgroup id="btnGroup" cellAlign="right" width="100%">
<button id="btnNew" caption="New" title="Create a new item" onclick="zenPage.showObject(''); zenPage.resetTable();"/>
<spacer width="10"/>
<button id="btnSave" caption="Save" title="Save the current item" onclick="zenPage.saveItem();"/>
<spacer width="10"/>
<button id="btnCancel" caption="Cancel" title="Cancel the current edit operation" onclick="zenPage.cancelItem();"/>
<spacer width="10"/>
<button id="btnDelete" caption="Delete" title="Delete the current item" onclick="zenPage.deleteItem();"/>
<spacer width="10"/>
</hgroup>
<hgroup labelPosition="left" cellStyle="padding-right:10px;">
<label label="* indicates required field" labelStyle="font-size:10px;" align="left"/>
</hgroup>
<spacer height="2"/>

</fieldSet>
</pane>
}

Method DrawTitle(pSeed As %String) As %Status
{
	Set tTitle = $$$TextHTML(..#PAGENAME)
	do %application.DrawTitle(tTitle,0)
	Quit $$$OK
}

ClientMethod resetTable() [ Language = javascript ]
{
	try {
		var table = zenPage.getComponentById('rsaTable');
		table.setProperty("selectedIndex",-1);
		table.executeQuery();
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// Cancel current RSA key edit.
ClientMethod cancelItem() [ Language = javascript ]
{
	if (confirm(this.msgcancelItem) == true) {
		this.resetTable();
		zenPage.getComponentById("rsaFieldSet").setHidden(true);
	}
}

ClientMethod deleteItem() [ Language = javascript ]
{
	try {
		if (confirm(this.msgdelete)) {
			var ok = this.DeleteData(this.OIDID);
			if (ok == 1) {
				zenPage.getComponentById("rsaFieldSet").setHidden(true);
				var table = zenPage.getComponentById("rsaTable");	
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
	Set tSC = ##class(HS.Registry.RSAKey).%DeleteId(id)
	Quit $S($$$ISOK(tSC):tSC,1:$System.Status.GetErrorText(tSC))
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
	this.OIDID = id;
	this.UpdateDetails(id);
}

Method UpdateDetails(PID) [ ZenMethod ]
{
	#dim eException as %Exception.AbstractException
	try {
		
		#dim tObj As HS.Registry.RSAKey
		
		&js<zenPage.getComponentById('rsaFieldSet').setProperty("hidden",false);>
		If PID '= "",##class(HS.Registry.RSAKey).%ExistsId(PID) {
			Set tObj = ##class(HS.Registry.RSAKey).%OpenId(PID)
			&js<zenPage.getComponentById('btnDelete').setProperty('disabled',false);>
			
		} Else {
			Set tObj = ##class(HS.Registry.RSAKey).%New()
			&js<zenPage.getComponentById('btnDelete').setProperty('disabled',true);>
		}
		&js<zenPage.getComponentById('Alias').setValue('#($ZCVT(tObj.Alias,"O","JS"))#');>
		&js<zenPage.getComponentById('Modulus').setValue('#($ZCVT(##class(%Binary).LogicalToXSD(tObj.Modulus),"O","JS"))#');>
		&js<zenPage.getComponentById('Exponent').setValue('#($ZCVT(##class(%Binary).LogicalToXSD(tObj.Exponent),"O","JS"))#');>
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
		
		var Alias = zenPage.getComponentById("Alias").getValue();
		var Modulus = zenPage.getComponentById("Modulus").getValue();
		var Exponent = zenPage.getComponentById("Exponent").getValue();
		var errmsg=""
		if(Alias=="") {errmsg = errmsg + this.aliasRequiredError}
		if((Modulus=="")||(Exponent=="")) {
			if (errmsg!="") { errmsg = errmsg + "\n"}
			errmsg = errmsg + this.pubKeyRequiredError
		}
		if(errmsg!="") { alert(errmsg);return;}
		var ok = this.SaveData(this.OIDID, Alias, Modulus, Exponent);
		if (ok == 1) {
			this.resetTable();
			zenPage.getComponentById("rsaFieldSet").setHidden(true);
		} else {
			alert(ok);
		}
	}catch(ex) {
	alert("ERROR: " + ex);
	}
}

/// Save data to server
Method SaveData(pID, pAlias, pModulus, pExponent) As %String [ ZenMethod ]
{
	Set tSC=$$$OK
	try {
		Set idx=0
		If pID ]"" {
			Set tOBJ=##class(HS.Registry.RSAKey).%OpenId(pID)
		} Else {
			Set tOBJ=##class(HS.Registry.RSAKey).%New()

		}
		Set tOBJ.Alias = pAlias
		Set tOBJ.Modulus = ##class(%Binary).XSDToLogical(pModulus)
		Set tOBJ.Exponent = ##class(%Binary).XSDToLogical(pExponent)
		
		Set tSC=tOBJ.%Save()
		If $$$ISERR(tSC) Set tSC = $system.Status.GetErrorText(tSC)
		Set ..OIDID=tOBJ.%Id()
	} Catch eException {
		Set tSC=eException.DisplayString()
	}

	Quit tSC
}

}
