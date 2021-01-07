/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsITK

/// Created using the page template: Default
Class EnsLib.ITK.Setup.UI.EditFaultMap Extends EnsPortal.Template.standardPage [ System = 4 ]
{

Parameter RESOURCE = "%Ens_ITK:READ";

Parameter EDITRESOURCE = "%Ens_ITK:WRITE";

/// Class name of application this page belongs to.
Parameter APPLICATION = "EnsPortal.Application";

/// Displayed name of this page.
Parameter PAGENAME = "Edit Fault Map";

Property errorMsg As %String;

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
.zenLabel {
	color: #404040;
	font-size: 10pt;
}

.tnbrTable {
	border: 1px solid #808080;
	background: #D0D0D0;
	background-image: none;
}

.ribbonTitle {
	color: rgb(71,72,67);
	background: lightblue;
}

#tableGroup {
	overflow: hidden;
	border-right: 1px solid #F0F0F0;
	border-left: 1px solid #F0F0F0;
	border-bottom: 1px solid #F0F0F0;
}

#descriptionPanel {
	width: 150px;
	background: white;
	font-size: 11pt;
	color: #404040;
	padding: 8px;
	overflow: auto;
}

#detailGroup {
	width: 350px;
	background: #E0E0D0;
	overflow: auto;
	border-right: 1px solid #F0F0F0;
	border-bottom: 1px solid #F0F0F0;
}

#tableGroup {
	overflow: auto;
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

/// This XML block defines the contents of this pane.
XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane id="pane" hidden="true">
<hgroup cellVAlign="top">
<html id="descriptionPanel" OnDrawContent="DrawDescription" />
<vgroup id="tableGroup">
<tablePane id="table" 
useSnapshot="true"
maxRows="10000"
pageSize="10000"
tableName="EnsLib_ITK_Framework.FaultVocabularyMap"
onselectrow="zenPage.rowSelected(zenThis);"
onunselectrow="zenPage.rowSelected(zenThis);"
valueColumn="ID"
>
<column colName="ITKFaultCode" header="ITK Fault Code" />
<column colName="VocabularyId" header="Vocabulary Id"/>
<column colName="VocabularyCode" header="Vocabulary Code" />
<column colName="ID" hidden="true"/>
</tablePane>
</vgroup>
<vgroup id="detailGroup">
<form id="mapForm" cellStyle="padding:3px;">
<combobox id="comboITKCode" label="ITK Fault Code" editable="true" size="38"
 required="true" unrestricted="true"
  name="ITKFaultCode"/>
<dataCombo id="comboVocab" label="Vocabulary Id" size="38" required="true" name="VocabularyId"
  sql="SELECT VocabularyOID FROM EnsLib_ITK_Framework.FaultVocabulary" onchange="zenPage.changeCodeParams()">
</dataCombo>
<dataCombo id="comboCode" label="Vocabulary Code" size="38" required="true" name="VocabularyCode"
  sql="SELECT FaultCode,FaultCode||': '||FaultText FROM EnsLib_ITK_Framework.FaultCode
  		WHERE CodeSystem = ?">
  		<parameter id="codeParam1"/>
</dataCombo>
<spacer height="5"/>
<hgroup>
<button controlClass="commandButton" id="btnSave" caption="Save" onclick="zenPage.save();"/>
<spacer width="5" />
<button controlClass="commandButton" id="btnReset" caption="Reset" onclick="zenPage.resetForm();"/>
<spacer width="5" />
<button controlClass="commandButtonRemove" id="btnRemove" caption="Remove" onclick="zenPage.deleteItem();" />
</hgroup>
</form>
</vgroup>
</hgroup>
</pane>
}

/// Draw the contents of the description panel.
Method DrawDescription(pSeed As %String) As %Status
{
	Write $$$Text("Map definied fault vocabularies to faults generated in the switchboard")
	Write "<br/>"
	Write "<br/>"

	Write $$$Text("The table shows all the mappings currently defined for this namespace.")
	Write $$$Text("You can use the form on the right to create, edit, or delete fault mappings")

	Quit $$$OK
}

/// Get the (localized) title string for the page.
Method %OnGetTitle() As %String
{
	Quit ..%OnGetPageName()
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("ITK Fault Vocabulary Map","Ensemble")
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	/*
	// commands: $LB(id,caption,help,onclick)
	Set pCommands(1) = $LB("btnNew",$$$Text("New"),$$$Text("Start the Production Wizard to create a new Production."),"zenPage.doNew();")
	Set pCommands(2) = $LB("btnConfig",$$$Text("Open"),$$$Text("Configure the currently selected Production."),"zenPage.doConfigure();")
	Set pCommands(3) = $LB("btnDocument",$$$Text("Document"),$$$Text("Document the currently selected Production."),"zenPage.doDocument();")
	Set pCommands(4) = $LB("btnDelete",$$$Text("Delete"),$$$Text("Delete the currently selected Production from the namespace."),"zenPage.doDelete();")
	*/
	
	Quit $$$OK
}

ClientMethod changeCodeParams() [ Language = javascript ]
{
	
	zen('codeParam1').setProperty('value',zen('comboVocab').getValue());
	zen('comboCode').refreshContents()
}

/// User selected a row in the table
ClientMethod rowSelected(table) [ Language = javascript ]
{
	// Undo any failed validation formatting
	var form = zen('mapForm');
	var controls = form.getControlList();
	for (var n = 0; n < controls.length; n++) {
		var child = controls[n];
		child.setProperty('invalid',false);
	}
	// update details pane using ID value from table
	var idx = table.selectedIndex
	if (idx!=null&&idx>=0) {
		var id = table.getProperty('value');
		this.UpdateDetails(id);
	} else {
		this.resetForm(); // this deletes the src value from the <image> component on more than one browser
		//zen('btnBusinessPartner').setProperty('src','deepsee/zoom_24.png'); // reset the deleted src value
	}
	zen('comboITKCode').setProperty('disabled',idx!=null&&idx>=0);
	zen('comboVocab').setProperty('disabled',idx!=null&&idx>=0);
}

/// UpdateDetails:
/// Update contents of details pane.
ClassMethod UpdateDetails(id) [ ZenMethod ]
{
	// try to open the object
	Set tObj = ##class(EnsLib.ITK.Framework.FaultVocabularyMap).%OpenId(id)
	If $IsObject(tObj) {
		&js<zen('comboITKCode').setValue('#($ZCVT(tObj.ITKFaultCode,"O","JS"))#');>
		&js<zen('comboVocab').setValue('#($ZCVT(tObj.VocabularyId,"O","JS"))#');>
		&js<zen('comboCode').setValue('#($ZCVT(tObj.VocabularyCode,"O","JS"))#');>
		&js<zenPage.changeCodeParams();>
	}
	Else {
		&js<alert("Cannot open object!");>
	}
	Quit
}

/// Reset the form programmatically
ClientMethod resetForm() [ Language = javascript ]
{
	var form = zen('mapForm');
	form.reset();
	this.changeCodeParams();
	var table = zen('table')
	table.selectRow(null);
}

/// User clicked Delete button.
ClientMethod deleteItem() [ Language = javascript ]
{
	if (!this.checkEdit()) { return; }
	var idx = zen('table').selectedIndex;
	var id = (idx >= 0) ? zen('table').getProperty('value') : '';
	if (id!='') {
		if (confirm($$$Text('Are you sure you want to delete this item?'))) {
			var msg = this.DeleteID(id);
			if (''!=msg) {
				alert(msg);
			}
			//zen('table').executeQuery(); // causes page to hang several seconds
			self.document.location = self.document.location; // this works instead
		}
	} else {
		alert($$$Text('Please select a service to delete'));
	}
}

/// Delete the given id.
ClassMethod DeleteID(id) As %String [ ZenMethod ]
{
	Set tMsg = ""
	Set tSC = ##class(EnsLib.ITK.Framework.FaultVocabularyMap).%DeleteId(id)
	If $$$ISERR(tSC) {
		Set tMsg = $System.Status.GetErrorText(tSC)
	}
	Quit tMsg
}

/// Save the contents of the form.
ClientMethod save() [ Language = javascript ]
{
	if (!this.checkEdit()) { return; }
	
	var ok = zen('mapForm').validate();
	if (!ok) return;

	var form = zen('mapForm');
	var data = form.getValuesAsObject();
	data.selectedIndex = zen('table').selectedIndex;
	var msg = this.SaveItem(data);
	if (msg != '') {
		alert(msg);
	}
	else {
		//zen('table').executeQuery(); // causes page to hang several seconds
		self.document.location = self.document.location; // this works instead
	}
}

/// Save the given item.
ClassMethod SaveItem(pItem As %ZEN.proxyObject) As %String [ ZenMethod ]
{
	Set tMsg = ""
	Set tSC = $$$OK
	Try {
		// test to see if we are replacing an old item, modifying an old item, or creating a new item
		Set vocId = pItem.VocabularyId
		Set itkCode = pItem.ITKFaultCode
		Set id = itkCode_"||"_vocId
		Set name = id
		Set idx = pItem.selectedIndex
		If ((id'="")&&##class(EnsLib.ITK.Framework.FaultVocabularyMap).%ExistsId(id)) {
			If (idx="") || (idx<0) {
				// Trying to create a 'new' item that already exists
				Set tMsg = $$$Text("A mapping with this ITK Fault Code and Vocabulary Id already exists.")
				Quit
				// rename: delete old item
				//Set tSC = ##class(EnsLib.ITK.Framework.FaultVocabularyMap).%DeleteId(id)
				//Set tClsDef = ##class(EnsLib.ITK.Framework.FaultVocabularyMap).%New()
			}
			Else {
				// modify old item
				Set tClsDef = ##class(EnsLib.ITK.Framework.FaultVocabularyMap).%OpenId(name)
			}
		}
		Else {
			// should be new!
			If (##class(EnsLib.ITK.Framework.FaultVocabularyMap).%ExistsId(name)) {
				Set tMsg = $$$Text("This id is already in use")
				Quit
			}
			Set tClsDef = ##class(EnsLib.ITK.Framework.FaultVocabularyMap).%New()
		}

		Set tClsDef.ITKFaultCode = pItem.ITKFaultCode
		Set tClsDef.VocabularyId = pItem.VocabularyId
		Set tClsDef.VocabularyCode = pItem.VocabularyCode
		
		Set tSC = tClsDef.%Save()

		// return new id value
		//&js<zen('txtServiceName').setValue('#($ZCVT(tClsDef.%Id(),"O","JS"))#')>

	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}

	If $$$ISERR(tSC) {
		Set tMsg = $System.Status.GetErrorText(tSC)
	}
	Quit tMsg
}

/// This client event is fired when the page is resized.
ClientMethod onlayoutHandler(load) [ Language = javascript ]
{
	this.adjustSizes();
}

/// Adjust sizes of components on the page.
ClientMethod adjustSizes() [ Language = javascript ]
{
	try {
		zen('pane').setHidden(false);

		var descDiv = zen('descriptionPanel').getEnclosingDiv();
		var tgDiv = zen('tableGroup').getEnclosingDiv();
		var tableDiv = zen('table').getEnclosingDiv();
		var detailDiv = zen('detailGroup').getEnclosingDiv();

		// find size of window
		var winHeight = zenGetWindowHeight();
		var winWidth = zenGetWindowWidth();

		var th = this.getTitleAreaHeight();
		var hgt = winHeight - th - 25;

		var tableHgt = hgt;
		var tableWid = winWidth - descDiv.offsetWidth - detailDiv.offsetWidth;

		descDiv.style.height = tableHgt + 'px';
		detailDiv.style.height = tableHgt + 'px';
		tgDiv.style.height = tableHgt + 'px';
		tgDiv.style.width = tableWid + 'px';
		tableDiv.style.width = tableWid + 'px';
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in adjustSizes');
	}
}

/// Decorate the page.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	/*
	Set %page.idExists = 0
	If %page.credentialsId '= "" { // try to match the provided id to an existing credential
		If ##class(Ens.Config.Credentials).%ExistsId(%page.credentialsId) {
			Set %page.idExists = 1
			Set tObj = ##class(Ens.Config.Credentials).%OpenId(%page.credentialsId)
			Set ..%GetComponentById("txtID").value = %page.credentialsId
			Set ..%GetComponentById("txtSystemName").value = %page.credentialsId
			Set ..%GetComponentById("txtUsername").value = tObj.Username
			Set ..%GetComponentById("txtPassword").value = tObj.Password
			Set ..%GetComponentById("selBusinessPartner").value = tObj.BusinessPartner
			Kill tObj
		}
	}*/

	Quit tSC
}

ClassMethod GetITKCodes() As %String [ ZenMethod ]
{
	Set list = $LB($$$ITKUnauthorisedRequest,$$$ITKInvalidRequest,$$$ITKInvalidAddressing,$$$ITKInvalidSecurity,$$$ITKGeneralError,$$$ITKRetryableError,$$$ITKNonRetryableError,$$$ITKSOAPError)
	set newList = ""
	For code = 1:1:$LL(list) {
		Set newList = newList_$LB($E($Li(list,code),2,*-1))
	}
	Quit $LTS(newList)
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	if (zenPage.idExists) { // a valid id value was supplied
		var tab = zen('table');
        var rowCount = parseInt(tab.rowCount); // table.rowCount can be a string value
		for (i = 0; i < rowCount; i++) { // highlight the row for the currently selected id
            var rowData = tab.getRenderedRowData(i);
            if (rowData && rowData.ID && (rowData.ID == zenPage.credentialsId))  {
                tab.setProperty('selectedIndex',i);
                return true;
            }		
        }
	}
	zen('comboITKCode').setProperty('valueList',zenPage.GetITKCodes());
}

/// Callback to return a list of resources required for a specific HyperEvent.
/// The user must have sufficient privileges on one of the resource/permission pairs
/// to be permitted to execute the hyperevent. An empty string implies the user already
/// has sufficient privileges for the ZenMethod specified in <var>pMethod</var>.
ClassMethod GetHyperEventResources(pMethod As %String = "") As %String
{
	Quit $CASE(pMethod, 
		"SaveItem":..#EDITRESOURCE,
		"DeleteID":..#EDITRESOURCE,
		:"")
}

}
