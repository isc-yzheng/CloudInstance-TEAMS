/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Created using the page template: Default
Class EnsLib.ITK.Setup.UI.EditFaultCodes Extends EnsPortal.Template.standardPage [ System = 4 ]
{

Parameter RESOURCE = "%Ens_ITK:READ";

Parameter EDITRESOURCE = "%Ens_ITK:WRITE";

/// Class name of application this page belongs to.
Parameter APPLICATION = "EnsPortal.Application";

/// Displayed name of this page.
Parameter PAGENAME = "Edit Fault Codes";

Property SelectedVocabulary As %String;

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
tableName="EnsLib_ITK_Framework.FaultVocabulary"
showZebra="true"
valueColumn="ID"
onselectrow="zenPage.rowSelected(zenThis);"
onunselectrow="zenPage.rowSelected(zenThis);"
>
<column colName="VocabularyOID" header="Vocabulary OID" />
<column colName="ID" hidden="true" />
</tablePane>
</vgroup>
<spacer width="5"/>
<vgroup id="faultTableGroup">
<tablePane id="faultTable" 
useSnapshot="true"
tableName="EnsLib_ITK_Framework.FaultCode"
whereClause="CodeSystem = ?"
showZebra="true"
valueColumn="ID"
onselectrow="zenPage.faultRowSelected(zenThis);"
onunselectrow="zenPage.faultRowSelected(zenThis);"
>
<parameter value="#(%page.SelectedVocabulary)#"/>
<column colName="FaultCode" header="Fault Code" />
<column colName="FaultText" header="Fault Text"/>
<column colName="ID" hidden="true" />
</tablePane>
</vgroup>
<vgroup id="detailGroup">
<vgroup>
<form id="vocForm" cellStyle="padding:3px;">
<text label="Vocabulary OID" name="VocabularyOID" id="txtVocOid" size="50" hint="OID for Fault Vocabulary / Code System" required="true"/>
<hidden name="ID" id="vocID"/>
<spacer height="5"/>
<hgroup>
<button controlClass="commandButtonRemove" id="btnVocRemove" caption="Remove All" onclick="zenPage.deleteVoc();" />
</hgroup>
</form>
</vgroup>
<vgroup>
<form id="faultForm" cellStyle="padding:3px;">
<text label="Fault Code" name="FaultCode" id="txtFaultCode" size="10" hint="" required="true"/>
<text label="Fault Text" name="FaultText" id="txtFaultText" size="50" hint="" required="true"/>
<hidden name="CodeSystem" id="hdnCodeSystem"/>
<hidden name="ID" id="txtID"/>
<spacer height="5"/>
<hgroup>
<button controlClass="commandButton" id="btnSave" caption="Save" onclick="zenPage.saveFault();"/>
<spacer width="5" />
<button controlClass="commandButton" id="btnReset" caption="Reset" onclick="zenPage.resetForm();"/>
<spacer width="5" />
<button controlClass="commandButtonRemove" id="btnRemove" caption="Remove" onclick="zenPage.deleteFault();" />
</hgroup>
</form>
</vgroup>
</vgroup>
</hgroup>
</pane>
}

/// Draw the contents of the description panel.
Method DrawDescription(pSeed As %String) As %Status
{
	Write $$$Text("Manage the Fault Vocabularies and Fault Codes here.")
	Write "<br/>"
	Write "<br/>"

	Write $$$Text("The first table shows the fault vocabularies in use.  The second table shows the fault codes for the selected vocabulary.")
	Write $$$Text("You can use the form on the right to create, edit, or delete fault codes")

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
	Quit $$$Text("ITK Fault Codes","Ensemble")
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

/// Check that the SOAPAction entered is unique
ClientMethod checkUniqueSOAPAction() [ Language = javascript ]
{
	return zenPage.IsSOAPActionUnique(zen('txtSOAPAction').getValue());
}

Method IsSOAPActionUnique(action As %String) As %Boolean [ ZenMethod ]
{
	&sql(SELECT count(SOAPAction) INTO :count FROM EnsLib_ITK_Setup.ServiceDefinition
		WHERE SOAPAction = :action)
		
	Quit (count=0)
}

/// User selected a row in the table
ClientMethod rowSelected(table) [ Language = javascript ]
{
	// Undo any failed validation formatting
	var form = zen('vocForm');
	var controls = form.getControlList();
	for (var n = 0; n < controls.length; n++) {
		var child = controls[n];
		child.setProperty('invalid',false);
	}
	// update details pane using ID value from table
	var idx = table.selectedIndex
	var id = '';
	if (idx!=null && idx >= 0) {
		id = table.getProperty('value');
		this.UpdateVocabulary(id);
		this.resetFaultForm();
	} else {
		//this.resetForm(); // this deletes the src value from the <image> component on more than one browser
		//zen('btnBusinessPartner').setProperty('src','deepsee/zoom_24.png'); // reset the deleted src value
	}
	zen('txtVocOid').setProperty('disabled',idx!=null&&idx>=0);
	zenPage.SelectedVocabulary = id;
	zen('faultTable').executeQuery();
}

/// User selected a row in the table
ClientMethod faultRowSelected(table) [ Language = javascript ]
{
	// Undo any failed validation formatting
	var form = zen('faultForm');
	var controls = form.getControlList();
	for (var n = 0; n < controls.length; n++) {
		var child = controls[n];
		child.setProperty('invalid',false);
	}
	// update details pane using ID value from table
	var idx = table.selectedIndex
	if (idx != null && idx >= 0) {
		var id = table.getProperty('value');
		this.UpdateFault(id);
	} else {
		//this.resetForm(); // this deletes the src value from the <image> component on more than one browser
		//zen('btnBusinessPartner').setProperty('src','deepsee/zoom_24.png'); // reset the deleted src value
	}
	zen('txtFaultCode').setProperty('disabled',idx!=null&&idx>=0);
}

/// UpdateDetails:
/// Update contents of details pane.
ClassMethod UpdateVocabulary(id) [ ZenMethod ]
{
	// try to open the object
	Set tObj = ##class(EnsLib.ITK.Framework.FaultVocabulary).%OpenId(id)
	If $IsObject(tObj) {
		&js<zen('vocID').setValue('#($ZCVT(id,"O","JS"))#');>
		&js<zen('txtVocOid').setValue('#($ZCVT(tObj.VocabularyOID,"O","JS"))#');>
	}
	Else {
		&js<alert("Cannot open vocabulary object!");>
	}
	Quit
}

/// UpdateDetails:
/// Update contents of details pane.
ClassMethod UpdateFault(id) [ ZenMethod ]
{
	// try to open the object
	Set tObj = ##class(EnsLib.ITK.Framework.FaultCode).%OpenId(id)
	If $IsObject(tObj) {
		&js<zen('txtID').setValue('#($ZCVT(id,"O","JS"))#');>
		&js<zen('txtFaultCode').setValue('#($ZCVT(tObj.FaultCode,"O","JS"))#');>
		&js<zen('txtFaultText').setValue('#($ZCVT(tObj.FaultText,"O","JS"))#');>
		&js<zen('hdnCodeSystem').setValue('#($ZCVT(tObj.CodeSystem,"O","JS"))#');>
	}
	Else {
		&js<alert("Cannot open object!");>
	}
	Quit
}

/// Reset the form programmatically
ClientMethod resetForm() [ Language = javascript ]
{
	zenPage.resetFaultForm();
	var form = zen('vocForm');
	form.reset();
	var table = zen('table')
	table.selectRow(null);
}

/// Reset the form programmatically
ClientMethod resetFaultForm() [ Language = javascript ]
{
	var form = zen('faultForm');
	form.reset();
	var table = zen('faultTable')
	table.selectRow(null);
}

/// User clicked Delete button.
ClientMethod deleteVoc() [ Language = javascript ]
{
	if (!this.checkEdit()) { return; }
	var idx = zen('table').selectedIndex;
	var id = (idx >= 0) ? zen('table').getProperty('value') : '';
	if (id!='') {
		if (confirm($$$Text('This will delete all associated fault codes.  Are you sure?'))) {
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

/// User clicked Delete button.
ClientMethod deleteFault() [ Language = javascript ]
{
	if (!this.checkEdit()) { return; }
	var idx = zen('faultTable').selectedIndex;
	var id = (idx >= 0) ? zen('faultTable').getProperty('value') : '';
	if (id!='') {
		if (confirm($$$Text('Are you sure you want to delete this item?'))) {
			var msg = this.DeleteFaultID(id);
			if (''!=msg) {
				alert(msg);
			} else {
				// Get the selected index from both tables to reset after reloadinf
				var vocIdx = zen('table').selectedIndex;
				zenSynchronousMode = true;
		
				zenPage.resetForm();
				//zen('table').executeQuery(); // causes page to hang several seconds
				//self.document.location = self.document.location; // this works instead
				zen('table').selectRow(vocIdx);
				zenSynchronousMode = false;	
			}
		}
	} else {
		alert($$$Text('Please select a service to delete'));
	}
}

/// Delete the given id.
ClassMethod DeleteID(id) As %String [ ZenMethod ]
{
	Set tMsg = ""
	Set tSC = ##class(EnsLib.ITK.Framework.FaultVocabulary).%DeleteId(id)
	If $$$ISERR(tSC) {
		Set tMsg = $System.Status.GetErrorText(tSC)
	}
	Quit tMsg
}

/// Delete the given id.
ClassMethod DeleteFaultID(id) As %String [ ZenMethod ]
{
	Set tMsg = ""
	Set tSC = ##class(EnsLib.ITK.Framework.FaultCode).%DeleteId(id)
	If $$$ISERR(tSC) {
		Set tMsg = $System.Status.GetErrorText(tSC)
	}
	Quit tMsg
}

/// Save the contents of the form.
ClientMethod saveFault() [ Language = javascript ]
{
	if (!this.checkEdit()) { return; }
	var form = zen('vocForm');
	var ok = form.validate();
	if (!ok) return;
	form = zen('faultForm');
	var ok = form.validate();
	if (!ok) return;
	// Copy the vocab ID into the fault form
	zen('hdnCodeSystem').setValue(zen('vocID').getValue());
	var data = form.getValuesAsObject();
	data.VocabularyOID = zen('txtVocOid').getValue()
	var msg = this.SaveItem(data);
	if (msg != '') {
		alert(msg);
	}
	else {
		// Get the selected index from both tables to reset after reloadinf
		var vocIdx = zen('table').selectedIndex;
		var faultIdx = zen('faultTable').selectedIndex;
		zenSynchronousMode = true;
		zenPage.resetForm();
		//zen('table').executeQuery(); // causes page to hang several seconds
		//self.document.location = self.document.location; // this works instead
		zen('table').selectRow(vocIdx);
		if (vocIdx != null) {
			zen('faultTable').selectRow(faultIdx);
		}
		zenSynchronousMode = false;
		if (vocIdx == null || vocIdx < 0) self.document.location = self.document.location;
	}
}

/// Save the given item.
ClassMethod SaveItem(pItem As %ZEN.proxyObject) As %String [ ZenMethod ]
{
	Set tMsg = ""
	Set tVocDef = $$$NULLOREF
	Set tSC = $$$OK
	Try {
		// test to see if we are replacing an old item, modifying an old item, or creating a new item
		Set voc = pItem.CodeSystem
		If ((voc '="") && ##class(EnsLib.ITK.Framework.FaultVocabulary).%ExistsId(voc)) {
			// Vocab exists
			Set id = pItem.ID
			Set fc = voc_"||"_pItem.FaultCode
			If ((id'="")&&##class(EnsLib.ITK.Framework.FaultCode).%ExistsId(id)) {
				// Fault code exists - so is an update
				Set tClsDef = ##class(EnsLib.ITK.Framework.FaultCode).%OpenId(id)
			} Else {
				// New Fault Code - 
				If (##class(EnsLib.ITK.Framework.FaultCode).%ExistsId(fc)) {
					Set tMsg = $$$Text("This Fault Code is already in use")
					Quit
				}
				Set tClsDef = ##class(EnsLib.ITK.Framework.FaultCode).%New()
				Set tVocDef = ##class(EnsLib.ITK.Framework.FaultVocabulary).%OpenId(voc)
				Do tVocDef.VocabularyRef.Insert(tClsDef)
			}
		} else {
			If ##class(EnsLib.ITK.Framework.FaultVocabulary).%ExistsId(pItem.VocabularyOID) {
				Set tMsg = $$$Text("This Fault Vocabulary is already in use")
				Quit
			} Else {
				Set tVocDef = ##class(EnsLib.ITK.Framework.FaultVocabulary).%New()
				Set tVocDef.VocabularyOID = pItem.VocabularyOID
				Set tClsDef = ##class(EnsLib.ITK.Framework.FaultCode).%New()
				Do tVocDef.VocabularyRef.Insert(tClsDef)
			}
		}

		Set tClsDef.FaultCode = pItem.FaultCode
		Set tClsDef.FaultText = pItem.FaultText
				
		Set tSC = tClsDef.%Save()

		// return new id value
		&js<zen('txtID').setValue('#($ZCVT(tClsDef.%Id(),"O","JS"))#')>
		If $IsObject(tVocDef) {
			&js<zen('vocID').setValue('#($ZCVT(tVocDef.%Id(),"O","JS"))#')>
		}

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
		var fgDiv = zen('faultTableGroup').getEnclosingDiv();
		var tableDiv = zen('table').getEnclosingDiv();
		var faultDiv = zen('faultTable').getEnclosingDiv();
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
		fgDiv.style.height = tableHgt + 'px';
		tgDiv.style.width = tableWid * 0.4 + 'px';
		fgDiv.style.width = tableWid * 0.6 + 'px';
		tableDiv.style.width = tableWid * 0.4 + 'px';
		faultDiv.style.width = tableWid * 0.6 + 'px';
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
}

/// Callback to return a list of resources required for a specific HyperEvent.
/// The user must have sufficient privileges on one of the resource/permission pairs
/// to be permitted to execute the hyperevent. An empty string implies the user already
/// has sufficient privileges for the ZenMethod specified in <var>pMethod</var>.
ClassMethod GetHyperEventResources(pMethod As %String = "") As %String
{
	Quit $CASE(pMethod, 
		"SaveItem":..#EDITRESOURCE,
		"DeleteFaultID":..#EDITRESOURCE,
		"DeleteID":..#EDITRESOURCE,
		:"")
}

}
