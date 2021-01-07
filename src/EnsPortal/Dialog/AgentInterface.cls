/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This dialog lets the user create or edit a context propery within a Business Process.
Class EnsPortal.Dialog.AgentInterface Extends EnsPortal.Dialog.standardDialog [ System = 4 ]
{

/// User needs READ permissions on the %Ens_Agents resource to view this page.
Parameter RESOURCE = "%Ens_Agents:READ";

/// User needs WRITE permissions on the %Ens_Agents resource to view this page.
Parameter EDITRESOURCE = "%Ens_Agents:WRITE";

Parameter APPLYBUTTON = 0;

/// name of agent
Property AgentName As %ZEN.Datatype.integer(ZENURL = "NAME");

/// ClientId of this interface
Property ClientID As %ZEN.Datatype.string(ZENURL = "ID");

/// ReadOnly flag.
Property readOnly As %ZEN.Datatype.boolean(ZENURL = "READONLY");

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
<hgroup>
<label id="lblAgent" label="Agent: " labelClass="labelRequired" labelStyle="font-size:1.0em; font-weight:bold;"/>
<spacer width="3" />
<label id="lblAgentName" label="Name" labelClass="labelBold" labelStyle="font-size:1.1em;color:darkgreen;"/>
<spacer width="25" />
<hgroup id="clientIdGroup" hidden="true">
<label id="lblClient" label="Client ID: " labelClass="labelRequired" labelStyle="font-size:1.0em; font-weight:bold;"/>
<spacer width="3" />
<label id="lblClientId" label="ID" labelClass="labelBold" labelStyle="font-size:1.1em;color:darkgreen;"/>
<spacer width="25"/>
<label id="lblAvailability" label="Availability:" labelClass="labelRequired" labelStyle="font-size:1.0em; font-weight:bold;"/>
<spacer width="3"/>
<label id="lblAgentAvailability" label="Init" labelClass="labelBold" labelStyle="font-size:1.1em;color:darkgreen;" title="Availability of Agent as a whole"/>
</hgroup>
</hgroup>
<spacer height="10"/>
<combobox id="int_.type" label="Interface Type"  valueList="File_Drop,File_Pick,TCP_Connect,TCP_Listen" displayList="File_Drop,File_Pick,TCP_Connect,TCP_Listen" value="File_Drop" unrestricted="false" editable="false" onchange="zenPage.revealOptions();" />
<spacer height="3"/>
<group id="OptionsGrp" disabled="true">
<group id="Options_File_Drop">
<vgroup>
<hgroup>
<checkbox id="int_.options.FD_CreateDir" value="0"/>
<spacer width="2"/>
<label label="Create Directory"/>
</hgroup>
<spacer height="9"/>
<text id="int_.options.FD_UseTemp" label="Use Temporary File" hint="Temporary file path to use" 
title="Empty means write directly, * means auto-generate" size="67" value=""/>
</vgroup>
</group>
<group id="Options_File_Pick" hidden="true">
<hgroup>
<checkbox id="int_.options.FP_CreateDir" value="0"/>
<spacer width="2"/>
<label label="Create Directory"/>
<spacer width="30"/>
<checkbox id="int_.options.FP_DeleteWhenDone" value="0"/>
<spacer width="2"/>
<label label="Delete When Done"/>
</hgroup>
<spacer height="10"/>
<hgroup>
<text id="int_.options.FP_MinutesRecent" label="Minutes Recent" value=""
title="Ignore files older than this. (minutes)"/>
<spacer width="30"/>
<text id="int_.options.FP_ConfirmSizeInterval" size="24" label="Confirm Size Interval" value=""
title="Don't send unless size unchanged for this long in seconds"/>
</hgroup>
<spacer height="10"/>
<hgroup>
<text id="int_.options.FP_Wildcard" label="Wildcard" size="34" value=""
title="Wildcard filename to look for; may be a semicolon-separated list of wildcards.  (eg. *.x;*.x?y)"/>
<spacer width="22"/>
<text id="int_.options.FP_DirPollingInterval" size="25" label="Directory Polling Interval" value=""
title="How often to send poll requests to the directory in seconds"/>
</hgroup>
</group>
<group id="Options_TCP_Connect" hidden="true">
<hgroup>
<text id="int_.options.TC_CallInterval" size="18" label="Call Interval" title="Amount of time in seconds between calls" value=""/>
<spacer width="25"/>
<text id="int_.options.TC_IdleDisconnect" size="18" label="Idle Disconnect" 
title="Amount of idle time in seconds to allow before disconnecting; -1 means never" value=""/>
</hgroup>
<spacer height="10"/>
<hgroup>
<text id="int_.options.TC_ConnectTimeout" size="18" label="Connect Timeout" title="How long in seconds to stay connected before timing out " value=""/>
<spacer width="25"/>
<text id="int_.options.TC_ReadTimeout" size="18" label="Read Timeout" title="How long in seconds to wait for a read to complete" value=""/>
</hgroup>
</group>
<group id="Options_TCP_Listen" hidden="true">
<hgroup>
<text id="int_.options.TL_CallInterval" size="18" label="Call Interval" title="Amount of time in seconds between calls" value=""/>
<spacer width="25"/>
<text id="int_.options.TL_IdleDisconnect" size="18" label="Idle Disconnect"  
title="Amount of idle time in seconds to allow before disconnecting; -1 means never" value=""/>
</hgroup>
<spacer height="10"/>
<hgroup>
<text id="int_.options.TL_MaxSockets" size="18" label="Max Sockets" value=""/>
<spacer width="25"/>
<text id="int_.options.TL_ReadTimeout" size="18" label="Read Timeout" title="How long in seconds to wait for a read to complete" value=""/>
</hgroup>
</group>
</group>
<text id="int_.configItem" size="67" label="Configuration Item" hint="Associated configuration item for settings" value=""
title="If this is non-empty then it has an affinity with the named configured Agent.ProxyService; if it is empty the first Agent.ProxyService found will be used."/>
<text id="int_.location" size="67" label="Location" hint="File path or TCP Address/Port for the interface" value=""/>
<textarea id="int_.description" rows="4" cols="50" label="Description" hint="Description of this interface"/>
<hgroup>
<text id="int_.relayPort" label="Relay Port" value="" size="20" title="Local port to use in relaying TCP traffic to the Agent.ProxyService"/>
<spacer width="30"/>
<text id="int_.configTimeout" label="Config Timeout" value="30" size="20"
title="Number of seconds the associated configuration item should wait for a synchronous confirmation from the Agent of outbound traffic on this interface"/>
</hgroup>
<textarea id="int_.credential" label="Credential" value="" rows="1" cols="50" hint="Authentication for the client"/>
<textarea id="int_.notes" rows="4" cols="50" label="Notes" hint="Notes about this interface"/>
</pane>
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit $$$TextHTML("Agent Interface")
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	If (..ClientID="") {
		Quit $$$TextHTML("Add a new interface to the agent.")
	}
	Quit $$$TextHTML("Edit an agent interface.")
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
		if (this.checkEdit() && (!this.readOnly)) {
			var main = this.getOpener();
			if (main && main.zenPage && main.zenPage._currItem) {
				var intr = new Object();
				intr.type = zen('int_.type').getValue();
				intr.location = zen('int_.location').getValue();
				intr.description = zen('int_.description').getValue();
				intr.configItem = zen('int_.configItem').getValue();
				intr.configTimeout = zen('int_.configTimeout').getValue();
				intr.relayPort = zen('int_.relayPort').getValue();
				intr.notes = zen('int_.notes').getValue();
				intr.availability = zen('lblAgentAvailability').label;
				intr.credential = zen('int_.credential').getValue();
				
				var options = new Object();
				if (intr.type == "File_Pick") {
					if (zen('int_.options.FP_DirPollingInterval').getValue() != '') {
						if (isNaN(zen('int_.options.FP_DirPollingInterval').getValue())) {
							alert('Polling Interval should have a numerical value');
							return false;
						}
						options.FP_DirPollingInterval = zen('int_.options.FP_DirPollingInterval').getValue();
					}
					if (zen('int_.options.FP_Wildcard').getValue() != '') {
						options.FP_Wildcard = zenEscapeHTML(zen('int_.options.FP_Wildcard').getValue());
					}
					if (zen('int_.options.FP_CreateDir').getValue()) options.FP_CreateDir = 1;
					else options.FP_CreateDir = 0;
					if (zen('int_.options.FP_MinutesRecent').getValue() != '') {
						if (isNaN(zen('int_.options.FP_MinutesRecent').getValue())) {
							alert('Minutes Recent should have a numerical value');
							return false;
						}
						options.FP_MinutesRecent = zen('int_.options.FP_MinutesRecent').getValue();
					}
					if (zen('int_.options.FP_DeleteWhenDone').getValue()) options.FP_DeleteWhenDone = 1;
					else options.FP_DeleteWhenDone = 0;
					if (zen('int_.options.FP_ConfirmSizeInterval').getValue() != '') {
						if (isNaN(zen('int_.options.FP_ConfirmSizeInterval').getValue())) {
							alert('Confirm Size Interval should have a numerical value');
							return false;
						}
						options.FP_ConfirmSizeInterval = zen('int_.options.FP_ConfirmSizeInterval').getValue();
					}
				}
				if (intr.type == "File_Drop") {
					if (zen('int_.options.FD_CreateDir').getValue()) options.FD_CreateDir=1;
					else options.FD_CreateDir = 0;
					if (zen('int_.options.FD_UseTemp').getValue() != '') {
						options.FD_UseTemp = zenEscapeHTML(zen('int_.options.FD_UseTemp').getValue());
					}					
				}
				if (intr.type == "TCP_Connect") {
					if (zen('int_.options.TC_IdleDisconnect').getValue() != '') {
						if (isNaN(zen('int_.options.TC_IdleDisconnect').getValue())) {
							alert('Idle Disconnect should have a numerical value');
							return false;
						}
						options.TC_IdleDisconnect = zen('int_.options.TC_IdleDisconnect').getValue();
					}
					if (zen('int_.options.TC_ConnectTimeout').getValue() != '') {
						if (isNaN(zen('int_.options.TC_ConnectTimeout').getValue())) {
							alert('Connect Timeout should have a numerical value');
							return false;
						}
						options.TC_ConnectTimeout = zen('int_.options.TC_ConnectTimeout').getValue();
					}
					if (zen('int_.options.TC_ReadTimeout').getValue() != '') {
						if (isNaN(zen('int_.options.TC_ReadTimeout').getValue())) {
							alert('Read Timeout should have a numerical value');
							return false;
						}
						options.TC_ReadTimeout = zen('int_.options.TC_ReadTimeout').getValue();
					}
					if (zen('int_.options.TC_CallInterval').getValue() != '') {
						if (isNaN(zen('int_.options.TC_CallInterval').getValue())) {
							alert('Call Interval should have a numerical value');
							return false;
						}
						options.TC_CallInterval = zen('int_.options.TC_CallInterval').getValue();
					}
				}
				if (intr.type == "TCP_Listen") {
					if (zen('int_.options.TL_MaxSockets').getValue() != '') {
						if (isNaN(zen('int_.options.TL_MaxSockets').getValue())) {
							alert('Max Sockets should have a numerical value');
							return false;
						}
						options.TL_MaxSockets = zen('int_.options.TL_MaxSockets').getValue();
					}
					if (zen('int_.options.TL_IdleDisconnect').getValue() != '') {
						if (isNaN(zen('int_.options.TL_IdleDisconnect').getValue())) {
							alert('Idle Disconnect should have a numerical value');
							return false;
						}
						options.TL_IdleDisconnect = zen('int_.options.TL_IdleDisconnect').getValue();
					}
					if (zen('int_.options.TL_ReadTimeout').getValue() != '') {
						if (isNaN(zen('int_.options.TL_ReadTimeout').getValue())) {
							alert('Read Timeout should have a numerical value');
							return false;
						}
						options.TL_ReadTimeout = zen('int_.options.TL_ReadTimeout').getValue();
					}
					if (zen('int_.options.TL_CallInterval').getValue() != '') {
						if (isNaN(zen('int_.options.TL_CallInterval').getValue())) {
							alert('Call Interval should have a numerical value');
							return false;
						}
						options.TL_CallInterval = zen('int_.options.TL_CallInterval').getValue();
					}
				}
				var item = main.zenPage._currItem;
				var id = this.ClientID;
				if (id.toString() =='') {
					id = item.Interfaces.length.toString();
					id = (id=='0')?'1' : id
				} else {
					delete item.Interfaces[id];
				}
				intr.options = new Object();
				intr.options = options;
				item.Interfaces[id] = new Object();
				item.Interfaces[id] = intr;
			}
			else {
				alert($$$Text('Error: Cannot send interface to main page'));
			}
		}
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments);
	}
	return true;
}

ClientMethod revealOptions() [ Language = javascript ]
{
	var chosen = zen('int_.type').getValue();
	var types = {0:'File_Drop',1:'File_Pick',2:'TCP_Connect',3:'TCP_Listen'}
	for (i in types) {
		if (chosen == types[i]) {
			zen('Options_'+types[i]).setProperty('hidden',false);
			if (!this.readOnly) {
				zen('Options_'+types[i]).setProperty('disabled',false);
			}
		}
		else {
			zen('Options_'+types[i]).setProperty('hidden',true);
		}
	}
}

ClientMethod populateControls(obj, propName) [ Language = javascript ]
{
	if (null == obj || "object" != typeof obj) {
		var int = zen("int"+propName);
		if (int) {
			int.setValue(obj);
			if (this.readOnly) {
				int.setProperty('disabled',true);
			}
		}
		return;
	}
	// Handle Array
	if (obj instanceof Array) {
		for (var i = 0, len = obj.length; i < len; i++) {
			zenPage.populateControls(obj[i]);
		}
		return;
	}

	// Handle Object
	if (typeof obj == "object") {
		for (var attr in obj) {
			if (obj.hasOwnProperty(attr)) zenPage.populateControls(obj[attr], propName+"."+attr);
		}
		return;
	}
	throw new Error("Unable to populate item due to unsupported property type "+(typeof obj));
}

/// This callback, if defined, is called when the dialog page is loaded.
ClientMethod ondialogStart() [ Language = javascript ]
{
	try {
		var main = this.getOpener();
		if (main && main.zenPage && main.zenPage._currItem) {
			var agent = main.zenPage._currItem;
			if (this.ClientID!="") {
				var interface = agent.Interfaces[this.ClientID];
				zen('lblAgentAvailability').setProperty('label',interface.availability); 
				this.populateControls(interface,"_");
				zenPage.revealOptions();
			}
			else if (!this.readOnly) {
				zen('Options_File_Drop').setProperty('disabled',false);
			}
		}
		else { alert($$$Text('Error: Cannot open interface from main page')); }
}
catch(ex){
		zenExceptionHandler(ex,arguments);
}
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	Try {
		Set ..%GetComponentById("lblAgentName").label = ..AgentName
		Set:(..ClientID'="") ..%GetComponentById("lblClientId").label = ..ClientID 
		Set:(..ClientID'="") ..%GetComponentById("clientIdGroup").hidden = "false" 
	}
	Catch(ex) {
			Set tSC = ex.AsStatus()
		}
	Quit tSC
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
