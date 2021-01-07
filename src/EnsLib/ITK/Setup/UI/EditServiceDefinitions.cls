/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Created using the page template: Default
Class EnsLib.ITK.Setup.UI.EditServiceDefinitions Extends EnsPortal.Template.standardPage [ System = 4 ]
{

Parameter RESOURCE = "%Ens_ITK:READ";

Parameter EDITRESOURCE = "%Ens_ITK:WRITE";

/// Class name of application this page belongs to.
Parameter APPLICATION = "EnsPortal.Application";

/// Displayed name of this page.
Parameter PAGENAME = "Edit Service Definitions";

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
queryClass="EnsLib.ITK.Setup.ServiceDefinition"
queryName="GetServiceListUI"
showZebra="true"
valueColumn="ServiceName"
onselectrow="zenPage.rowSelected(zenThis);"
onunselectrow="zenPage.rowSelected(zenThis);"
>
<column colName="ServiceName" header="Service Name" />
<column colName="SOAPAction" header="SOAP Action"/>
<column colName="BehaviourType" header="Behaviour Type" />
<!--<column colName="HasDistributionEnvelope" header="Has DE?" />-->
<column colName="RequestClass" header="Request Class" hidden="false"/>
<column colName="ResponseClass" header="Response Class" hidden="false"/>
<column colName="WebClientClass" header="Web Client Class" hidden="false"/>
<column colName="WebServiceClass" header="Web Service Class" hidden="false"/>
</tablePane>
</vgroup>
<vgroup id="detailGroup">
<form id="svcForm" cellStyle="padding:3px;">
<text label="Service Name" name="ServiceName" id="txtServiceName" size="50" hint="Identifier for this service" required="true" onvalidate="return zenPage.checkUniqueServiceName()" invalidMessage="must be unique."/>
<text label="SOAP Action" name="SOAPAction" id="txtSOAPAction" size="50" hint="SOAP Action for this service" required="true" onvalidate="return zenPage.checkUniqueSOAPAction()" invalidMessage="must be unique."/>
<select label="Behaviour Type" name="BehaviourType" id="selBehaviourType" valueList="Request-Response,Post,Queue Collection,Fault Handler,Asynch Response Handler" 
	required="true"/>
<!--<checkbox name="HasDistributionEnvelope" id="cbDE" hint="" label="Has Distribution Envelope?" />-->
<hgroup cellVAlign="top" label="Request Class" >
<text name="RequestClass" id="txtRequestClass" size="45" hint=""/>
<image src="deepsee/zoom_16.png" id="btnFinder1" title="Open the Class finder dialog" onclick="zenPage.showFinder('RequestClass');"/>
</hgroup>
<hgroup cellVAlign="top" label="Response Class" >
<text name="ResponseClass" id="txtResponseClass" size="45" hint=""/>
<image src="deepsee/zoom_16.png" id="btnFinder2" title="Open the Class finder dialog" onclick="zenPage.showFinder('ResponseClass');"/>
</hgroup>
<hgroup cellVAlign="top" label="Web Client Class" >
<text name="WebClientClass" id="txtWebClientClass" size="45" hint=""/>
<image src="deepsee/zoom_16.png" id="btnFinder3" title="Open the Class finder dialog" onclick="zenPage.showFinder('WebClientClass');"/>
</hgroup>
<hgroup cellVAlign="top" label="Web Service Class" >
<text name="WebServiceClass" id="txtWebServiceClass" size="45" hint=""/>
<image src="deepsee/zoom_16.png" id="btnFinder4" title="Open the Class finder dialog" onclick="zenPage.showFinder('WebServiceClass');"/>
</hgroup>
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
	Write $$$Text("Services correspond to ITK SOAP messages and their behaviour characteristics.  Define those available for senders and consumers here.")
	Write "<br/>"
	Write "<br/>"

	Write $$$Text("The table shows all the services currently defined for this namespace.")
	Write $$$Text("You can use the form on the right to create, edit, or delete services.")

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
	Quit $$$Text("ITK Service Definitions","Ensemble")
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
	return zenPage.IsSOAPActionUnique(zen('txtSOAPAction').getValue(), zen('txtServiceName').getValue());
}

Method IsSOAPActionUnique(action As %String, serviceName As %String) As %Boolean [ ZenMethod ]
{
	&sql(SELECT count(SOAPAction) INTO :count FROM EnsLib_ITK_Setup.ServiceDefinition
		WHERE SOAPAction = :action AND ServiceName != :serviceName)
		
	Quit (count=0)
}

/// Check that the SOAPAction entered is unique
ClientMethod checkUniqueServiceName() [ Language = javascript ]
{
	return zenPage.IsServiceNameUnique(zen('txtServiceName').getValue());
}

Method IsServiceNameUnique(name As %String) As %Boolean [ ZenMethod ]
{
	&sql(SELECT count(ServiceName) INTO :count FROM EnsLib_ITK_Setup.ServiceDefinition
		WHERE ServiceName = :name)
		
	Quit (count=0)
}

/// User selected a row in the table
ClientMethod rowSelected(table) [ Language = javascript ]
{
	// Undo any failed validation formatting
	var form = zen('svcForm');
	var controls = form.getControlList();
	for (var n = 0; n < controls.length; n++) {
		var child = controls[n];
		child.setProperty('invalid',false);
	}
	// update details pane using ID value from table
	var idx = table.selectedIndex
	if (idx != null && idx >= 0) {
		var id = table.getProperty('value');
		this.UpdateDetails(id);
	} else {
		this.resetForm(); // this deletes the src value from the <image> component on more than one browser
		for (var i = 1; i<5;i++) {
			zen('btnFinder'+i).setProperty('src','deepsee/zoom_16.png'); // reset the deleted src value
		}
	}
	zen('txtServiceName').setProperty('disabled',idx!=null&&idx>=0);
}

/// UpdateDetails:
/// Update contents of details pane.
ClassMethod UpdateDetails(id) [ ZenMethod ]
{
	// try to open the object
	Set tObj = ##class(EnsLib.ITK.Setup.ServiceDefinition).%OpenId(id)
	If $IsObject(tObj) {
		&js<zen('txtServiceName').setValue('#($ZCVT(id,"O","JS"))#');>
		&js<zen('txtSOAPAction').setValue('#($ZCVT(tObj.SOAPAction,"O","JS"))#');>
		&js<zen('selBehaviourType').setValue('#($ZCVT(tObj.BehaviourType,"O","JS"))#');>
		//&js<zen('cbDE').setValue('#($ZCVT(tObj.HasDistributionEnvelope,"O","JS"))#');>
		&js<zen('txtRequestClass').setValue('#($ZCVT(tObj.RequestClass,"O","JS"))#');>
		&js<zen('txtResponseClass').setValue('#($ZCVT(tObj.ResponseClass,"O","JS"))#');>
		&js<zen('txtWebClientClass').setValue('#($ZCVT(tObj.WebClientClass,"O","JS"))#');>
		&js<zen('txtWebServiceClass').setValue('#($ZCVT(tObj.WebServiceClass,"O","JS"))#');>
	}
	Else {
		&js<alert("Cannot open object!");>
	}
	Quit
}

/// Reset the form programmatically
ClientMethod resetForm() [ Language = javascript ]
{
	var form = zen('svcForm');
	form.reset();
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
		if (confirm($$$Text('Related Subscriptions, Distribution Rules, Senders and Consumers will also be deleted.\n\nAre you sure you want to delete this item?'))) {
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
	try {
		Set tMsg = ""
		//NEW SQLCODE
		// Start a transaction
		TSTART
		// Delete all subscriptions for this service
		&sql(DELETE FROM EnsLib_ITK_Setup.SubscriptionRules
			WHERE SourceService = :id)
		
		If (SQLCODE < 0) {
			TRollback
			Set tSC = $$$ERROR($$$GeneralError,$SYSTEM.SQL.SQLCODE(SQLCODE))
			Quit
		}

		// Delete all distribution rules for this service
		&sql(DELETE FROM EnsLib_ITK_Setup.DistributionRules 
			WHERE ServiceName = :id)
		
		If (SQLCODE < 0) {
			TRollback
			Set tSC = $$$ERROR($$$GeneralError,$SYSTEM.SQL.SQLCODE(SQLCODE))
			Quit
		}

		// Delete all consumer registry items for this service
		&sql(DELETE FROM EnsLib_ITK_Setup.ConsumerServiceRegistry 
			WHERE ServiceName = :id)
		
		If (SQLCODE < 0) {
			TRollback
			Set tSC = $$$ERROR($$$GeneralError,$SYSTEM.SQL.SQLCODE(SQLCODE))
			Quit
		}
		
		// Delete all senders for this system
		&sql(DELETE FROM EnsLib_ITK_Setup.SenderRegistry
			WHERE WebServiceName = :id)
		
		If (SQLCODE < 0) {
			TRollback
			Set tSC = $$$ERROR($$$GeneralError,$SYSTEM.SQL.SQLCODE(SQLCODE))
			Quit
		}
		
		// Finally remove the service definition
		Set tSC = ##class(EnsLib.ITK.Setup.ServiceDefinition).%DeleteId(id)
				
		// Commit
		TCommit
	} Catch (ex) {
		// rollback
		TRollback
		Set tSC = ex.AsStatus()
	}
	
	If $$$ISERR(tSC) {
		Set tMsg = $System.Status.GetErrorText(tSC)
	}
	Quit tMsg
}

/// Save the contents of the form.
ClientMethod save() [ Language = javascript ]
{
	if (!this.checkEdit()) { return; }
	
	var ok = zen('svcForm').validate();
	if (!ok) return;
	/*
	
	//var id = zen('txtServiceName').getValue();
	var name = zen('txtServiceName').getValue();
	//var type = zen('selBehaviourType').getValue();

	if (name == '') {
		alert($$$Text("Please provide an name for this service"));
		return;
	}

	
	if ((id!='')&&(id!=name)) {
		if (!confirm($$$Text("Do you wish to rename this item? This will not rename references to this item."))) {
			return;
		}
	}*/

	var form = zen('svcForm');
	var data = form.getValuesAsObject();
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
		Set id = pItem.ServiceName
		Set name = id
		If ((id'="")&&##class(EnsLib.ITK.Setup.ServiceDefinition).%ExistsId(id)) {
			If (name'=id) {
				// rename: delete old item
				Set tSC = ##class(EnsLib.ITK.Setup.ServiceDefinition).%DeleteId(id)
				Set tClsDef = ##class(EnsLib.ITK.Setup.ServiceDefinition).%New()
			}
			Else {
				// modify old item
				Set tClsDef = ##class(EnsLib.ITK.Setup.ServiceDefinition).%OpenId(name)
			}
		}
		Else {
			// should be new!
			If (##class(EnsLib.ITK.Setup.ServiceDefinition).%ExistsId(name)) {
				Set tMsg = $$$Text("This id is already in use")
				Quit
			}
			Set tClsDef = ##class(EnsLib.ITK.Setup.ServiceDefinition).%New()
		}

		Set tClsDef.ServiceName = pItem.ServiceName
		Set tClsDef.SOAPAction = pItem.SOAPAction
		Set tClsDef.BehaviourType = pItem.BehaviourType
		//Set tClsDef.HasDistributionEnvelope = pItem.HasDistributionEnvelope
		Set tClsDef.RequestClass = pItem.RequestClass
		Set tClsDef.ResponseClass = pItem.ResponseClass
		Set tClsDef.WebClientClass = pItem.WebClientClass
		Set tClsDef.WebServiceClass = pItem.WebServiceClass
		
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
	// Set the dropdown for behaviour type to the valuelist in service definitions
	Set property = ##class(%Dictionary.PropertyDefinition).%OpenId("EnsLib.ITK.Setup.ServiceDefinition||BehaviourType")
	If $IsObject(property) {
		Set comp = %page.%GetComponentById("selBehaviourType")
		Set comp.valueList = property.Parameters.GetAt("VALUELIST")
	}
	
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
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

ClientMethod showFinder(compName) [ Language = javascript ]
{
	zenPage.launchPopupWindow(zenLink('%ZEN.Dialog.finderDialog.zen?MODE=classes'),
 	this.addPopupSuffix(compName),
 	'status,scrollbars,resizable=yes,width=800,height=600');
}

ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if (action != "ok") {
		return false;
	}
	popupName = this.removePopupSuffix(popupName);
	var textField = zen('txt' + popupName);
	if (textField) {
		var className = textField.getValue();
		switch(popupName) {
	 		case 'RequestClass':
	 		case 'ResponseClass':
	 		case 'WebClientClass':
	 		case 'WebServiceClass':
	 			if (value != '') {
	 				// value is name plus extension
	 				// pull extension off of name
	 				var s = value.toString().split('.');
	 				if ('cls' == s[s.length-1]) {
	 					s.length = s.length-1;
	 					className = s.join('.');
	 				}
	 			}
	 			break;
	 	}
		textField.setValue(className);
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
		"DeleteID":..#EDITRESOURCE,
		:"")
}

}
