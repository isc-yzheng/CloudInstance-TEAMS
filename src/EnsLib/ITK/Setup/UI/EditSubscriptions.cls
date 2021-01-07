/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

Class EnsLib.ITK.Setup.UI.EditSubscriptions Extends EnsPortal.Dialog.standardDialog [ System = 4 ]
{

Parameter RESOURCE = "%Ens_ITK:READ";

Parameter EDITRESOURCE = "%Ens_ITK:WRITE";

/// Enable styles that are common to all pages and dialogs for the EnsPortal application.
Parameter APPLICATION = "EnsPortal.Application";

Parameter PAGENAME = "Edit Subscriptions";

Parameter APPLYBUTTON = 1;

Parameter CANCELBUTTON = 1;

Property ItemNo As %String(ZENURL = "itemNo");

Property Sender As %String;

Property Consumer As %String;

XData Style
{
<style type="text/css"> 

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
<pane>
<hgroup cellVAlign="top">
<vgroup id="tableGroup">
<tablePane id="subTable" dataSource="query" initialExecute="true" valueColumn="ID" multiSelect="true"
	sql="SELECT DISTINCT w.%ID, w.ServiceName, w.SOAPAction, w.BehaviourType FROM EnsLib_ITK_Setup.ServiceDefinition w
		,EnsLib_ITK_Setup.SenderRegistry s, EnsLib_ITK_Setup.ConsumerServiceRegistry c
		WHERE w.ServiceName = s.WebServiceName
		AND   w.ServiceName = c.ServiceName
		AND   s.SourceAppName = ?
		AND   c.ConsumerName = ?
		ORDER BY ServiceName ASC" 
	showZebra="true"
	onmultiselect="zenPage.rowMultiSelected(zenThis)">
	<parameter value="#(%page.Sender)#"/>
	<parameter value="#(%page.Consumer)#"/>
	<column colName="ID" hidden="true"/>
	<column colName="ServiceName"/>
	<column colName="SOAPAction"/>
	<column colName="BehaviourType"/>
</tablePane>
<spacer height="5"/>
<label id="lblNoService" hidden="true"/>
</vgroup>
</hgroup>
</pane>
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit "Define the subscriptions between the "_..Sender_" sender and the "_..Consumer_" consumer"
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit "Edit Subscription Rules"
}

/// Get the value that will be applied when the user presses the OK button.
/// This is implemented by subclasses.
ClientMethod getDialogValue() [ Language = javascript ]
{
	//alert('getDialogValue method is unimplemented');
	return '';
}

Method %OnAfterCreatePage() As %Status
{
	Set ..Sender = $P(..ItemNo,"|",1)
	Set ..Consumer = $P(..ItemNo,"|",2)
	//Set %page.%GetComponentById("btnCancel").hidden = 1
	
	Quit $$$OK
}

ClassMethod GetSubscriptions(pSender As %String, pConsumer As %String) As %ListOfDataTypes [ ZenMethod ]
{
	Set tList = ##class(%ListOfDataTypes).%New()
	Set tRS = ##class(%ResultSet).%New("EnsLib.ITK.Setup.SubscriptionRules:GetSubscribedServices")
	Set tSC = tRS.Execute(pSender, pConsumer)
	While tRS.Next(.sc) {
		Do tList.Insert(tRS.GetData(1))
	}
	
	Do tRS.Close()
	Quit tList
}

/// User multi-selected a new row in the table
ClientMethod rowMultiSelected(table) [ Language = javascript ]
{
	//var table = this.getComponentById('table');
	//var selectedRows = table.getProperty('selectedRows')
	//ctrl.setValue(table.getProperty('selectedRows'));
	//alert(selectedRows);
}

ClientMethod loadSelectedRows() [ Language = javascript ]
{
	// Get subscriptions and use table.selectMultiRow(index,true) to
	// select appropriate rows
	var subs = zenPage.GetSubscriptions(zenPage.Sender, zenPage.Consumer);
	var table = zen('subTable');
	for(var i=0; i < table.rowCount; i++) {
		var svc = table.getRenderedRowData(i).ServiceName;
		for(var j=0; j < subs.length; j++) {
			if (subs[j] == svc) {
				table.selectMultiRow(i,true);
				break;
			}
		}
	}
	if (table.rowCount == 0) {
		var lbl = zen('lblNoService');
		lbl.setValue('There are no services in common between the ' + zenPage.Sender + ' sender and the ' +
			zenPage.Consumer + ' consumer.');
		lbl.setProperty('hidden',false);
	}
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	this.loadSelectedRows();
}

Method StoreSubscriptions(pSelectedRows As %String) As %Status [ ZenMethod ]
{
	set tSC = $$$OK
	Set tSender = ..Sender
	Set tConsumer = ..Consumer
	try {
		NEW SQLCODE
		// Start a transaction
		&sql(START TRANSACTION %COMMITMODE EXPLICIT)
		// Delete all the existing subscriptions
		&sql(DELETE FROM EnsLib_ITK_Setup.SubscriptionRules 
			  WHERE SourceApplication = :tSender
			  AND Subscriber = :tConsumer)
		If SQLCODE < 0 throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$EnsErrGeneral,"Failed to delete subscription rules ("_tSender_","_tConsumer_")"))	
		// Loop through the selected rows and insert the subscriptions
		For i=1:1:$Length(pSelectedRows,",") {
			Set svc = $PIECE(pSelectedRows,",",i)
			Continue:svc=""
			&sql(INSERT INTO EnsLib_ITK_Setup.SubscriptionRules (SourceApplication, SourceService, Subscriber)
				  VALUES (:tSender, :svc, :tConsumer))
			If SQLCODE < 0 throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$EnsErrGeneral,"Failed to insert subscription rule ("_tSender_","_svc_","_tConsumer_")"))
		}
	
		// Commit
		&sql(COMMIT)
	} catch e {
		&sql(ROLLBACK)
		Set tSC = e.AsStatus()
	}
	
	Quit:$$$ISERR(tSC) $ZCVT($$$StatusDisplayString(tSC),"O","JS")
	Quit ""
}

/// This callback, if defined, is called when the user presses the OK or Apply action buttons.
/// If this returns false, then the action is cancelled.
ClientMethod ondialogFinish(action) [ Language = javascript ]
{
	if (!this.checkEdit())  return false;
	var ok = zenPage.StoreSubscriptions(zen('subTable').getProperty('selectedRows'))
	if (ok != '') {
		alert(ok);
		return false;
	}
	
	if (action != 'ok') alert('Changes saved.');
	return true;
}

/// Callback to return a list of resources required for a specific HyperEvent.
/// The user must have sufficient privileges on one of the resource/permission pairs
/// to be permitted to execute the hyperevent. An empty string implies the user already
/// has sufficient privileges for the ZenMethod specified in <var>pMethod</var>.
ClassMethod GetHyperEventResources(pMethod As %String = "") As %String
{
	Quit $CASE(pMethod, 
		"StoreSubscriptions":..#EDITRESOURCE,
		:"")
}

}
