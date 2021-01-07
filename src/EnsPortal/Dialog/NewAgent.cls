/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This dialog lets the user create a new Skorpius agent.
Class EnsPortal.Dialog.NewAgent Extends EnsPortal.Dialog.standardDialog [ System = 4 ]
{

/// User needs WRITE permissions on the %Ens_Agents resource to view this page.
Parameter RESOURCE = "%Ens_Agents:WRITE";

Parameter APPLYBUTTON = 0;

XData Style
{
<style type="text/css">

.checkboxCaption {
	color: #404040;
}

a.radioSetCaption {
	vertical-align: text-bottom;
}
.zenHint {
	font-size: 0.75em;
}
</style>
}

/// Contents of the dialog body.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" cellStyle="padding-bottom:8px;">
<text id="name" label="Name" size="50" labelStyle="color:black" value="" hint="The name for this agent" />
<text id="configItem" size="50" label="Configuration Item" hint="Associated configuration item for settings" value=""
title="If this is non-empty then it has an affinity with the named configured Agent.ProxyService; if it is empty the first Agent.ProxyService found will be used."/>
<hgroup>
<text label="Config Timeout" size="18" id="configTimeout" value=""
enclosingStyle="padding-bottom:4px;" 
title="Number of seconds the associated config item should wait for a synchronous confirmation from the Agent of outbound traffic on this interface"/>
<spacer width="18"/>
<text label="Polling Interval" id="pollInterval" size="18" value="" enclosingStyle="padding-bottom:4px;" 
title="How often to send poll requests when idle"/>
<spacer width="18"/>
<text label="Stay Connected" id="stayConnected" size="18" value="" enclosingStyle="padding-bottom:4px;"
title="(Seconds) Controls number of HTTP requests on one socket" />
</hgroup>
<textarea id="description" rows="4" cols="50" label="Description" hint="Description of this agent" value=""/>
<textarea id="notes" rows="4" cols="50" label="Notes" hint="Notes about this agent" value=""/>
</pane>
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit $$$TextHTML("New Agent")
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit $$$TextHTML("Create a new agent.")
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	return '';
}

/// This callback, if defined, is called when the user presses the OK or Apply action buttons.
/// If this returns false, then the action is cancelled.<br>
ClientMethod ondialogFinish(action) As %Boolean [ Language = javascript ]
{

	try {
			var name = zen('name').getValue();
			var desc = zen('description').getValue();
			var config = zen('configItem').getValue();
			var timeout = zen('configTimeout').getValue();
			var notes = zen('notes').getValue();
			var poll = zen('pollInterval').getValue();
			var connected = zen('stayConnected').getValue();
			

			if ('' == name) {
				alert($$$Text('Please enter a name for this agent.'));
				return false;
			}
			if (!zenPage.IsNameValid(name)) {
				alert($$$Text('Name is not valid for this agent.'));
				return false;
			}
			if (!zenPage.IsNameDuplicate(name)) {
				alert($$$FormatText($$$Text("Another agent already has name '%1'.\nPlease select a different name."),name));
				return false;
			}
			
			var msg = zenPage.saveAgent(name,desc,config,timeout,notes,poll,connected)
			if (msg!='') {
				alert($$$Text(msg));
				return false;
			}
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments);
	}
	return true;
}

Method saveAgent(name As %String, desc As %String, config As %String, timeout As %String, notes As %String, poll As %String, connected As %String) As %String [ ZenMethod ]
{
	Set tMsg = ""
	Set tSC = $$$OK
	Set agent = ##class(EnsLib.Agent.Interface).%New()
	Set agent.ClientId=0
	Set agent.Type = "Agent"
	Set agent.AgentName = name
	Set agent.Description = desc
	Set agent.ConfigItem = config
	Set agent.Notes = notes
	Do:poll'="" agent.Options.SetAt(poll,"SA_PollInterval")
	Do:connected'="" agent.Options.SetAt(connected,"SA_StayConnected")
	Set:timeout'="" agent.ConfigTimeout = timeout
	Set tSC = agent.%Save()
	Set:$$$ISERR(tSC) tMsg="Error in save : "_$System.Status.GetErrorText(tSC)
	Quit tMsg
}

/// This callback, if defined, is called when the dialog page is loaded.
ClientMethod ondialogStart() [ Language = javascript ]
{
	var title = "Select a unique name for this agent.\n*required";
	zen('name').setProperty('title',title);
	zen('name').focus();
}

/// Test if the given name is valid.
ClassMethod IsNameValid(pName As %String) As %Boolean [ ZenMethod ]
{
	Quit $ZNAME(pName,3)
}

Method IsNameDuplicate(pName As %String) As %Boolean [ ZenMethod ]
{
	Set valid = 1
	&sql(SELECT AgentName INTO :aName FROM EnsLib_Agent.Interface WHERE AgentName=:pName and ClientId=0)
	If (SQLCODE'=100) {
		Set valid=0
		If SQLCODE {
			&js<alert($$$Text("SQL Error confirming unique name of agent: #(SQLCODE)#"));>
		}
	}
	Quit valid
}

/// Key handler for value edit control.
ClientMethod ctrlKeyDown(evt, escOnly) [ Language = javascript ]
{
	switch(evt.keyCode) {
	case zenENTER:
		if (!escOnly) {
			this.dialogFinish();
		}
		break;
	case zenESC:
		this.dialogCancel();
		break;
	}
	return true;
}

}
