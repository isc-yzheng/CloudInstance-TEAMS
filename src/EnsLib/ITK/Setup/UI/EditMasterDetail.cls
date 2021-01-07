/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.ITK.Setup.UI.EditMasterDetail Extends EnsPortal.Dialog.standardDialog [ Abstract, System = 4 ]
{

Parameter RESOURCE = "%Ens_ITK:READ";

Parameter EDITRESOURCE = "%Ens_ITK:WRITE";

/// Enable styles that are common to all pages and dialogs for the EnsPortal application.
Parameter APPLICATION = "EnsPortal.Application";

Parameter APPLYBUTTON = 0;

Parameter CANCELBUTTON = 0;

/// Set this to the DataModel class for the controller model
Property ModelClass As %String;

Property ChangesMade As %Boolean [ InitialExpression = 0 ];

XData Style
{
<style type="text/css"> 
body {
	background: #FFFFFF;
}

#detailGroup {
	width: 300px;
	background: #E0E0D0;
	overflow: auto;
	border-right: 1px solid #F0F0F0;
	border-bottom: 1px solid #F0F0F0;
}

#invocationRadio span { 
        display:block; 
} 

#tableGroup {
	overflow: auto;
	border-right: 1px solid #F0F0F0;
	border-left: 1px solid #F0F0F0;
	border-bottom: 1px solid #F0F0F0;
}

/* style for table pane */
table.tpTable {
	background: white;
}

table.tpTable th {
	color: #404040;
	font-weight: bold;
	text-align: left;
	padding: 2px;
	overflow: hidden;
	background: #D0D0D0;
	background-image: none;
}

table.tpTable th.tpHdrSelected {
	color: #404040;
	font-weight: bold;
	text-align: left;
	padding: 2px;
	overflow: hidden;
	background: #D0D0F0;
	background-image: none;
}
</style>
}

XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane id="pane" hidden="true">
<hgroup cellVAlign="top">
<vgroup id="tableGroup">
<pane paneName="masterPane"/>
</vgroup>
<dataController id="modelData"  
    modelClass="%ZEN.Model.%ZEN.DataModel.DataModel"
    modelId=""
/>
<vgroup id="detailGroup">
<form id="detailForm"
         controllerId="modelData" 
         layout="vertical"
         cellStyle="padding: 2px; padding-left: 5px; padding-right: 5px;">
<pane paneName="detailPane"/>
<hgroup cellVAlign="bottom">
  <button controlClass="commandButton" caption="Save" onclick="zenPage.saveModel();" />
  <spacer width="5"/>
  <button controlClass="commandButton" caption="Reset" onclick="zenPage.resetModel();" />
  <spacer width="5"/>
  <button controlClass="commandButtonRemove" caption="Remove" onclick="zenPage.deleteModel();" />
</hgroup>
</form>
</vgroup>
</hgroup>
</pane>
}

/// Get the value that will be applied when the user presses the OK button.
/// This is implemented by subclasses.
ClientMethod getDialogValue() [ Language = javascript ]
{
	return zenPage.ChangesMade;
}

Method %OnAfterCreatePage() As %Status
{
	Set %page.%GetComponentById("btnCancel").hidden = 1
	Set %page.%GetComponentById("modelData").modelClass = ..ModelClass
	Quit $$$OK
}

/// Override with specifics, but call invokeSuper first
ClientMethod rowSelected(selected) [ Language = javascript ]
{
	
  var id = selected?zen('masterTable').getValue():null;
  var controller = zenPage.getComponentById('modelData');
  controller.setProperty('modelId',id);
  
  return id;
}

/// save contact model to database
ClientMethod saveModel() [ Language = javascript ]
{
  if (!this.checkEdit()) { return; }
  // validate and save form
  var form = zenPage.getComponentById('detailForm');
  var controller = zenPage.getComponentById('modelData');
  var ok = form.save();
  if (!ok) return;
  zenPage.ChangesMade = true;
  var table=zenPage.getComponentById('masterTable');
  // unselect rows
  this.resetModel();
  //refresh data in consumer table
  table.executeQuery();
}

/// insert a new row into the model ready for editing
ClientMethod resetModel() [ Language = javascript ]
{
  zen('masterTable').selectRow(null);
  var controller = zenPage.getComponentById('modelData');
  //this.rowSelected(false);
  controller.createNewObject();
}

/// Delete current item from database
ClientMethod deleteModel() [ Language = javascript ]
{
  if (!this.checkEdit()) { return; }
  var controller = zenPage.getComponentById('modelData');
  var table = zen('masterTable');
  var id = controller.getModelId();
  var msg = '';
  if (id!='') {
	if (confirm('Are you sure you want to delete this item?')) {		
		 if (!controller.deleteId(id)) {
			alert('Failed to delete row');
		  } else {
			  zenPage.ChangesMade = true;
			  //refresh data in contact table
			  table.executeQuery(true);
			  controller.update();
			  this.resetModel();
		  }
	}
  } else {
	  alert('Please select a row to delete');
  }
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	this.resetModel();
}

/// Adjust size and position of components on this page.
ClientMethod adjustSize() [ Language = javascript ]
{
	try {
		zen('pane').setHidden(false);

		var tgDiv = zen('tableGroup').getEnclosingDiv();
		var tableDiv = zen('masterTable').getEnclosingDiv();
		var detailDiv = zen('detailGroup').getEnclosingDiv();
		var headerDiv = zenPage.getComponentById('header').getEnclosingDiv();

		// find size of window
		var winHeight = zenGetWindowHeight();
		var winWidth = zenGetWindowWidth();

		var th = headerDiv.offsetHeight;//this.getTitleAreaHeight();
		var hgt = winHeight - th - 35;

		var tableHgt = hgt;
		var tableWid = winWidth - detailDiv.offsetWidth - 2;

		detailDiv.style.height = tableHgt + 'px';
		tgDiv.style.height = tableHgt + 'px';
		tgDiv.style.width = tableWid + 'px';
		tableDiv.style.width = tableWid + 'px';
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in adjustSizes');
	}
}

}
