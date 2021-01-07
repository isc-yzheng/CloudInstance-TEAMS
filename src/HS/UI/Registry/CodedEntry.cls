/// Define HS.IHE.CodedEntry values
Class HS.UI.Registry.CodedEntry Extends HS.HC.UI.Util
{

/// Displayed name of this page.
Parameter PAGENAME = "Coded Entry Registry";

/// Security requirement
Parameter RESOURCE = "%HSAdmin_InstallationManagement";

/// When running Foundation, this will be part of the docbook link, i.e. DocBook.UI.PortalHelpPage.cls?Key=thisvalue
Parameter FOUNDATIONHELPKEY;

Property saveRequiredError As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Fields Code, Scheme and CodeType are required.")} ];

Property saveConfirmExisting As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Are you sure you want to save edits to existing record?")} ];

Property msgcancelItem As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Do you wish to discard changes and reset form?")} ];

Property msgdelete As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Do you wish to delete this entry?")} ];

Property OBJID As %String;

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
.multiStyle {
	color: black;
	text-decoration: none;
	font-size: .8em;
	width: 8em;
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
<hgroup id="gp1" labelPosition="left" containerStyle="padding-top:4px;" cellStyle="padding-left:4px;padding-top:4px;">
<select id="cmbIdentityType" label="Code Type" onchange="zenPage.refreshTable();" queryClass="HS.IHE.CodedEntry" queryName="DistinctTypes"/>
<text id="txtSearch" label="Search" onchange="zenPage.refreshTable();"/>
</hgroup>
<tableNavigatorBar tablePaneId="table" showPageSize="true"/>
<tablePane id="table"
caption="Coded Entry Registry items currently defined:"
fixedHeaders="false"
queryClass="HS.IHE.CodedEntry" 
queryName="Items" 

maxRows="10000"
showZebra="true"
valueColumn="ID"
onselectrow="zenPage.rowSelected(zenThis);"
useSnapshot="true"
pageSize="15"
>
<column colName="ID" hidden="false"/>
<column colName="CodeType"/>
<column colName="Code"/>
<column colName="Scheme"/>
<column colName="Description"/>
<column colName="ToHTML"/>
<column colName="ToOther"/>
<column colName="ToSDA"/>
<parameter value=""/>
<parameter value=""/>
</tablePane>

</vgroup>

</pane>
}

XData formPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<button id="btnAdd" caption="Add Code" onclick="zenPage.showObject('');"/>
<form id="frmIdentity" labelPosition="left" hidden="true" cellStyle="padding: 2px;">
<text id="txtCode" label="Code *" size="60"/>
<text id="txtScheme" label="Scheme *" size="60"/>
<text id="txtDescription" label="Description" size="60"/>
<text id="txtToHTML" label="ToHTML" size="60"/>
<text id="txtToOther" label="ToOther" size="60"/>
<text id="txtToSDA" label="ToSDA" size="60"/>

<select id="cmbCodeType" label="Code Type *" queryClass="HS.IHE.CodedEntry" queryName="DistinctTypes" />

<spacer height="1"/>
<hgroup id="btnGroup" cellAlign="right" width="100%">
<button id="btnNew" caption="New" title="Create a new item" onclick="zenPage.showObject('');"/>
<spacer width="10"/>
<button id="btnSave" caption="Save" title="Save the current item" onclick="zenPage.saveItem();"/>
<spacer width="10"/>
<button id="btnCancel" caption="Cancel" title="Cancel the current edit operation" onclick="zenPage.cancelItem();"/>
<spacer width="10"/>
<button id="btnDelete" caption="Delete" title="Delete the current item" onclick="zenPage.deleteItem();"/>
<spacer width="10"/>
</hgroup>
<spacer height="1"/>
<hgroup labelPosition="left" cellStyle="padding-right:10px;">
<label label="* indicates required field" labelStyle="font-size:10px;" align="left"/>
</hgroup>
<spacer height="1"/>

</form>
</pane>
}

Method DrawTitle(pSeed As %String) As %Status
{
	Set tTitle = $$$TextHTML("Coded Entry Registry")
	do %application.DrawTitle(tTitle,0)
	Quit $$$OK
}

ClientMethod refreshTable() [ Language = javascript ]
{
	try {
		var table = zenPage.getComponentById('table');
		table.parameters[0].value = zenPage.getComponentById("cmbIdentityType").getValue();
		table.parameters[1].value = zenPage.getComponentById("txtSearch").getValue();
		table.executeQuery();
		zenPage.hideEdit(true);
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// Show/hide Service form. 
ClientMethod hideEdit(flag) [ Language = javascript ]
{
	zenPage.getComponentById("frmIdentity").setHidden(flag);
}

/// Cancel current Facility edit.
ClientMethod cancelItem() [ Language = javascript ]
{
	if (confirm(this.msgcancelItem) == true) {
		this.showObject('');
	}
}

ClientMethod deleteItem() [ Language = javascript ]
{
	try {
		if (confirm(this.msgdelete)) {
			var ok = this.DeleteData(this.OBJID);
			if (ok == 1) {
				zenPage.hideEdit(true);
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
		Set tSC=##class(HS.IHE.CodedEntry).%DeleteId(id)
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
	this.OBJID = id;
	this.UpdateDetails(id);
}

Method UpdateDetails(PID) [ ZenMethod ]
{
	#dim eException as %Exception.AbstractException
	try {
		
		#dim tObj As HS.IHE.CodedEntry
		// try to open the object
		
		&js<zenPage.getComponentById('frmIdentity').setProperty("hidden",false);>
		If PID '= "",##class(HS.IHE.CodedEntry).%ExistsId(PID) {
			Set tObj = ##class(HS.IHE.CodedEntry).%OpenId(PID)
			&js<zenPage.getComponentById('btnDelete').setProperty('disabled',false);>
			Set tSelectList=""
		} Else {
			Set tObj = ##class(HS.IHE.CodedEntry).%New()
			&js<zenPage.getComponentById('btnDelete').setProperty('disabled',true);>
			
		}
		Do ..%SetValueById("txtCode",tObj.Code)
		Do ..%SetValueById("txtScheme",tObj.CodingScheme)
		Do ..%SetValueById("txtDescription",tObj.Description)
		Do ..%SetValueById("txtToHTML",tObj.ToHTML)
		Do ..%SetValueById("txtToOther",tObj.ToOther)
		Do ..%SetValueById("txtToSDA",tObj.ToSDA)
		Do ..%SetValueById("cmbCodeType",tObj.CodeType)

		
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
		var Type = zenPage.getComponentById("cmbCodeType").getValue();
		var Code = zenPage.getComponentById("txtCode").getValue();
		var Scheme = zenPage.getComponentById("txtScheme").getValue();
		var Description = zenPage.getComponentById("txtDescription").getValue();
		var ToHTML = zenPage.getComponentById("txtToHTML").getValue();
		var ToOther = zenPage.getComponentById("txtToOther").getValue();
		var ToSDA = zenPage.getComponentById("txtToSDA").getValue();

		if ((Code=="") || (Scheme=="") || (Type=="")) { 
			alert(this.saveRequiredError);
			return;
		}
		if (this.OBJID) {
			if (!confirm(this.saveConfirmExisting)) {
				return;
			}
		}
		var ok = this.SaveData(this.OBJID, Type, Code, Scheme, Description, ToHTML, ToOther, ToSDA );
		if (ok == 1) {
			zenPage.getComponentById("table").setProperty("selectedIndex",-1);
			this.refreshTable();
		} else {
			alert(ok);
		}
	} catch(ex) {
		alert("ERROR: " + ex);
	}
}

/// Save data to server
Method SaveData(pID, pType, pCode, pScheme, pDescription, pToHtml, pToOther, pToSDA) As %String [ ZenMethod ]
{
	Set tSC=$$$OK
	try {
		Set idx=0
		If pID ]"" {
			Set tOBJ=##class(HS.IHE.CodedEntry).%OpenId(pID)
		} Else {
			Set tOBJ=##class(HS.IHE.CodedEntry).%New()
			&sql(select ID INTO :ID FROM HS_IHE.CodedEntry where CodeType=:pType and Code=:pCode and CodingScheme=:pScheme)
			If 'SQLCODE Set tSC = $$$FormatText("A record already exists with this Code, Scheme and CodeType.") Quit
		}
		Set tOBJ.CodeType=pType
		Set tOBJ.Code=pCode
		Set tOBJ.Description=pDescription
		Set tOBJ.CodingScheme=pScheme
		Set tOBJ.ToHTML=pToHtml
		Set tOBJ.ToOther=pToOther
		Set tOBJ.ToSDA=pToSDA
				
		Set tSC=tOBJ.%Save()
		If $$$ISERR(tSC) Set tSC = $system.Status.GetErrorText(tSC)
		Set ..OBJID=tOBJ.%Id()
	} Catch eException {
		Set tSC=eException.DisplayString()
	}

	Quit tSC
}

}
