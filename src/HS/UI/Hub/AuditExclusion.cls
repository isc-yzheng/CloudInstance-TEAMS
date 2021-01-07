/// Data entry to list audit evnts to exclude from saving/aggregating
Class HS.UI.Hub.AuditExclusion Extends HS.HC.UI.Template
{

/// Page title
Property PageTitle As %ZEN.Datatype.caption [ InitialExpression = {$$$TextHTML("Excluded Audit Event Types")} ];

/// Security requirement
Parameter RESOURCE = "%HSAdmin_HubManagement";

/// Name of class that supplies data for the form.
Parameter MODELCLASS = "HS.IHE.ATNA.Repository.Exclusion";

/// Name of the list table
Parameter TABLE = "paneEventTable";

/// Name of the detail field set
Parameter FIELDSET = "fsEventType";

Parameter FIELDWIDTHSECTION = 50;

/// Display value of the entity being maintained
Property Entity As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Event Type")} ];

Property msgEventIsRequired As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Please enter an Event Type")} ];

Property msgSaved As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Saved.")} ];

Property msgDeleted As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Deleted.")} ];

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
#scrollGroup {
	height: 300px;
	overflow-x: hidden;
	overflow-y: auto;
	width: 260px;
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
</vgroup>
</hgroup>
</page>
}

XData detailPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<tableNavigatorBar showFilter="false" showPageSize="true" tablePaneId="paneEventTable"/>
<tablePane id="paneEventTable" 
caption="Event Types currently excluded(click a row to edit):"
queryClass="HS.IHE.ATNA.Repository.Exclusion"
queryName="ListExcludedEvents"
maxRows="10000"
showZebra="true"
valueColumn="Code"
pageSize="5"
useSnapshot="true"
>
<!--column colName="ID" header="ID" hidden="true"/>
<column colName="Code" header="Code" width="100"/>
<column colName="Description" header="Description" width="250"/-->
<column colName="EventType" header="Event Type"/>
<column linkCaption="Delete" link="javascript:zenPage.deleteEvent('#(%query.EventType)#');" linkConfirm="Are you sure you want to delete the exclusion for this event type?" width="80"/>
</tablePane>
<spacer height="5"/>
<label label="Add Excluded Event"/>
<!--button id="btnAdd" caption="Add Excluded Event" onclick="zenPage.resetForm(); zen('paneEventTable').setProperty('selectedIndex',-1);"/-->
<spacer height="5"/>
<form id="frmEventType" width="800">
<fieldSet id="fsEventType">
<hgroup>
<vgroup align="left" labelPosition="left" cellStyle="padding: 2px; padding-left: 5px; padding-right: 5px;" valign="top">
<spacer height="5"/>
<combobox id="idEventCombo" buttonCaption="Exclude Event" editable="true" unrestricted="true" dropEnabled="true" size="60" />
<spacer height="5"/>
<hgroup align="left">
<button name="btnSave" id="btnSave" caption="Save Excluded Event Type" align="center" onclick="zenPage.save();"/>
</hgroup>
</vgroup>
</hgroup>
</fieldSet>
</form>
</pane>
}

ClassMethod ListEventTypes() As %String
{
	Set tSQL="select EventType from HS_IHE_ATNA_Repository.Exclusion"
	Set tRS1=##class(%ResultSet.SQL).%Prepare(tSQL,.tSC)
	While tRS1.%Next()  {
		Set tExcluded(tRS1.%Get("EventType"))=""
	}
	#dim tObj As HS.Reports.XMLMessageContainer
	Set tSC=##class(HS.Util.AuditServices).InvokeAuditService("HS.Audit.WebServices","HS.Audit.WebServicesClient","ListEventTypes",.tObj)
	Set:$$$ISOK(tSC) tSC=tObj.Status
	Set tVal="", tDis=""
	If $$$ISOK(tSC) {
		For tNum=1:1:tObj.StringCollection.Count() {
			Set tEv=tObj.StringCollection.GetAt(tNum)
			If '$D(tExcluded(tEv)) Set tVal=tVal_tEv_","
		}
	}
	Quit $E(tVal,1,*-1)
}

/// Load an excluded event Types into the UI
Method LoadEventDropdown() [ ZenMethod ]
{
	Set tList=..ListEventTypes()
	Set ..%GetComponentById("idEventCombo").valueList=tList
	Set ..%GetComponentById("idEventCombo").displayList=tList
}

/// Save a new or editted record to the database
ClientMethod save() [ Language = javascript ]
{
	var event   = zenPage.getComponentById('idEventCombo').getValue();
	
	if (zenPage.validate()) {
		var ok=this.SaveData(event);
		if (ok == 1) {
			var msg=zenPage.msgSaved;
			alert(msg);
			zenPage.resetForm();
		} else {
			alert(ok);
		}
	}
}

/// Save excluded event Type
ClassMethod SaveData(pEvent) As %String [ ZenMethod ]
{
	Set $zt="Error"
	
	Set tEvent = ##class(HS.IHE.ATNA.Repository.Exclusion).%New()
	Set tEvent.EventType=pEvent
	Set tSC=tEvent.%Save()
	Quit:$$$ISOK(tSC) 1
	Quit ..%FormatError($System.Status.GetErrorText(tSC))
Error Set $ZT=""
	Do BACK^%ETN
	Quit $ZE
}

ClientMethod validate() [ Language = javascript ]
{
	var msg='';
	if (zenPage.getComponentById("idEventCombo").getValue() == '') {
		msg=msg+zenPage.msgCodeIsRequired+"\n";
	}
	if (msg == '') {
		return true;
	} else {
		alert(msg);
		return false;
	}
}

/// Delete an event exclusion
ClientMethod deleteEvent(id) [ Language = javascript ]
{
	try {
		var ok = this.DeleteEventId(id);
		if (ok == 1) {
			var msg=zenPage.msgDeleted;
			alert(msg);
			zenPage.resetForm();
		} else {
			alert(ok);
		}
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

Method DeleteEventId(pId) As %String [ ZenMethod ]
{
	Set tSC=##class(HS.IHE.ATNA.Repository.Exclusion).%DeleteId(pId)
	Quit:$$$ISOK(tSC) 1
	Quit ..%FormatError($System.Status.GetErrorText(tSC))
}

ClientMethod resetForm() [ Language = javascript ]
{
	zen('frmEventType').reset();
	var table = zenPage.getComponentById(this.Table);
	table.setProperty('selectedIndex',-1);
	mode=zenSynchronousMode;
	zenSynchronousMode=true;
	table.executeQuery();
	zenSynchronousMode=mode;
	table.setProperty('selectedIndex',-1);
	this.LoadEventDropdown();
}

Method %OnAfterCreatePage() As %Status
{
	Do ..LoadEventDropdown()
	Quit $$$OK
}

}
