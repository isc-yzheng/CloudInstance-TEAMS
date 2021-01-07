/// Base class for CRUD (create, read, update, delete) utility
/// pages for HealthShare.<br/>
/// This class provides a basic template for the look and feel of a
/// series of data entry pages.<br/>
/// To use:
/// <ol>
/// <li>Create a subclass of this template class,</li>
/// <li>Set the MODELCLASS parameter to the name of you DataModel class,</li>
/// <li>Set the LOOKUPTABLE parameter to the SQL table name used to show the pick list of objects,</li>
/// <li>Set the LOOKUPCOLUMN parameter (default is "Name") to the SQL column name used in the pick list</li>
/// </ol>
Class HS.UI.HubCRUDTemplate Extends HS.UI.Base [ Abstract ]
{

/// Displayed name of this page.
Parameter PAGENAME = "HealthShare Hub Administration Template";

/// Name of MVC DataModel class that supplies data for the form.
Parameter MODELCLASS As STRING;

/// SQL name of table that provides contents of the lookup table.
Parameter LOOKUPTABLE As STRING;

/// SQL name of column to display within the lookup table.
Parameter LOOKUPCOLUMN As STRING = "Name";

/// SQL expression to use within the lookup table.
Parameter LOOKUPEXPRESSION As STRING;

/// ID of object to edit.
Property ObjectID As %String(ZENURL = "ID");

/// Holds the name of the model class.
Property ModelClass As %String [ InitialExpression = {..#MODELCLASS} ];

/// Holds the name of the lookup table.
Property LookupTable As %String [ InitialExpression = {..#LOOKUPTABLE} ];

/// Holds the name of the lookup column.
Property LookupColumn As %String [ InitialExpression = {..#LOOKUPCOLUMN} ];

/// Optional: Holds the expression used for the lookup column.
Property LookupExpression As %String [ InitialExpression = {..#LOOKUPEXPRESSION} ];

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">

#formGroup {
	border: 1px solid black;
	padding: 4px;
	background: #C0C0C0;
	background-image: url(images/grad-halfgray-10x500.png);
	background-repeat: repeat-x;
}

#btnGroup {
	padding: 2px;
}

#pickList {
	width: 100%;
}

#pickList table {
	table-layout: auto;
	width: 100%;
}

.zenLabel {
	font-family: arial;
	font-weight: bold;
}

/* Input box of combobox. */
.comboboxInput {
	border: blue 1px solid;
}

a.radioSetCaption,span.checkboxCaption {
}

/* Table around navigator bar. */
.tnbrTable {
	font-family: verdana;
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
<hgroup id="btnGroup" cellAlign="right" width="100%">
<button id="btnNew" caption="New" title="Create a new item" onclick="zenPage.newItem();"/>
<spacer width="10"/>
<button id="btnSave" caption="Save" title="Save the current item" onclick="zenPage.saveItem();"/>
<spacer width="10"/>
<button id="btnCancel" caption="Cancel" title="Cancel the current edit operation" onclick="zenPage.cancelItem();"/>
<spacer width="10"/>
<button id="btnDelete" caption="Delete" title="Delete the current item" onclick="zenPage.deleteItem();"/>
<spacer width="10"/>
</hgroup>
</vgroup>
</vgroup>
</hgroup>
</page>
}

XData detailPane
{
<pane xmlns="http://www.intersystems.com/zen">
<tableNavigatorBar tablePaneId="pickList"/>
<tablePane id="pickList" tableName="#(%page.LookupTable)#"
caption="Items"
showQuery="false"
useKeys="true" useSnapshot="true" showZebra="true"
showFilters="true"
showRowNumbers="true"
valueColumn="ID"
pageSize="15"
maxRows="1000"
headerLayout="headersOnTop"
onselectrow="zenPage.rowSelected(zenThis,which);">
<column colName="ID" hidden="true"/>
<column id="displayColumn"
colName="#(%page.LookupColumn)#" 
colExpression="#(%page.LookupExpression)#" 
filterType="text" filterOp="[" width="200"/>
</tablePane>

</pane>
}

XData formPane
{
<pane xmlns="http://www.intersystems.com/zen">
<dataController id="controller" modelClass="#(%page.ModelClass)#" modelId="#(%page.ObjectID)#"/>
<dynaForm id="form" controllerId="controller" labelPosition="left"
cellStyle="padding: 3px;">
<titleBox id="titleBox" title="#(%page.title)#" titleStyle="border:none;" />
</dynaForm>
</pane>
}

/// Row selected in pick list; update controller.
/// <var>which</var> indicates how this event was fired.
ClientMethod rowSelected(table, which) [ Language = javascript ]
{
	if ('keypress' == which) {
		// defer this action in case the user is arrowing through a number of items
		var id = table.getValue();
		var action = new Function("zenPage.showObject('"+id+"');"); 
		zenSetDeferredAction(action,200);
	}
	else {
		// select immediately
		var id = table.getValue();
		zenPage.showObject(id);
	}
}

/// Load the object with the given id into the form.
ClientMethod showObject(id) [ Language = javascript ]
{
	var controller = zenPage.getComponentById('controller');
	controller.setModelId(id);
}

/// Create a new item to edit.
ClientMethod newItem() [ Language = javascript ]
{
	var controller = zenPage.getComponentById('controller');
	controller.createNewObject();
}

/// Cancel current edit.
ClientMethod cancelItem() [ Language = javascript ]
{
	if (confirm('Do you wish to cancel the current operation?')) {
		var controller = zenPage.getComponentById('controller');
		var id = controller.getModelId();
		controller.setModelId(id);
	}
}

/// Delete current item from database
ClientMethod deleteItem() [ Language = javascript ]
{
	var controller = zenPage.getComponentById('controller');
	var id = controller.getModelId();

	if ('' == id) {
		alert('Nothing selected to delete.');
	}
	else if (confirm('Do you wish to delete this item?')) {
		controller.deleteId(id);

		var table = zenPage.getComponentById('pickList');
		table.executeQuery();
	}
}

ClientMethod saveItem() [ Language = javascript ]
{
	var form = zenPage.getComponentById('form');
	form.save();

	// refresh the table
	var table = zenPage.getComponentById('pickList');
	table.executeQuery();
}

}
