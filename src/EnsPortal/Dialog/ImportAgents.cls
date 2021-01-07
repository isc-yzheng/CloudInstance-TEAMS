/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsPortal.Dialog.ImportAgents Extends EnsPortal.Dialog.standardDialog [ System = 4 ]
{

Parameter APPLYBUTTON = 0;

/// User needs WRITE permissions on the %Ens_Agents resource to view this page.
Parameter RESOURCE = "%Ens_Agents:WRITE";

Parameter PAGENAME = "Import Agents";

Parameter CSSINCLUDES = "ensemble/Ensemble_Wizards.css,ensemble/Ensemble_EDI.css";

/// Keeps track of where we are in counting fields, so we can create unique field ids.
Property fieldCount As %Integer;

/// Keeps track of how many fields are currently displaying.
Property currentFields As %Integer;

/// File that items are being imported from
Property File As %ZEN.Datatype.string(ZENURL = "File");

/// Holder for return value.
Property retValue As %ZEN.Datatype.string(MAXLEN = "");

Property incomingData As %ZEN.Datatype.list(MAXLEN = "");

XData Style
{
<style type="text/css">
.labelTiny {
	font-size: 8pt;
}
.contentTiny {
	font-size: 8pt;
}
.lineClass {
	position: absolute;
	height: 50px;
	width: 100%;
	left: 0px;
	top: 0px;
}
.topLabel {
	font-size: 14pt;
	font-weight: bolder;
	color: black;
}
.importButtonClass {
	position: absolute;
	left: 14px;
	top: 0px;
}
.agentNameClass {
	font-size: 8pt;
	font-weight: normal;
	position: absolute;
	text-overflow: ellipsis;
	white-space: nowrap;
	overflow: hidden;
	left: 85px;
	top: 5px;
	color: black;
	font-weight: 600;
}
.itemInfoClass{
	font-size: 8pt;
	font-weight: normal;
	position: absolute;
	left: 90px;
	top: 23px;
	color: #707070;
	font-weight: 300;
}
.clientTypeClass {
	font-size: 8pt;
	font-weight: normal;
	position: absolute;
	left: 210px;
	top: 5px;
}
.clientConfigItemClass {
	font-size: 8pt;
	font-weight: normal;
	position: absolute;
	text-overflow: ellipsis;
	white-space: nowrap;
	overflow: hidden;
	width: 200px;
	left: 355px;
	top: 5px;
}
</style>
}

/// Contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" width="100%" height="100%" title="#(%page.dialogTitle)#">
<html id="header" OnDrawContent="%DrawTitle" />
<pane paneName="dialogBody" id="body" />
<hgroup id="footer" width="100%">
<hgroup id="leftbuttonHolder" cellAlign="left">
<spacer width="20"/>
<button id="selectAll" caption="Select All" controlClass="commandButton" enclosingClass="position:absolute;bottom:0px;left:0px;" 
onclick="zenPage.doSelectAll(true);"/>
<spacer width="5"/>
<button id="unselectAll" caption="Unselect All" controlClass="commandButton" enclosingClass="position:absolute;bottom:0px;left:30px;" 
onclick="zenPage.doSelectAll(false);"/>
</hgroup>
<hgroup id="buttonHolder" cellAlign="right" hidden="#('%page.hasButtons)#">
<button id="btnApply" hidden="#(%page.hideApplyButton)#" caption="Apply" onclick="zenPage.dialogApply();" />
<spacer width="5" />
<button id="btnCancel" hidden="#(%page.hideCancelButton)#" caption="Cancel" onclick="zenPage.dialogCancel();" />
<spacer width="5" />
<button id="btnOK" hidden="#(%page.hideOKButton)#" caption=" OK " onclick="zenPage.dialogFinish();" />
<spacer width="10" />
</hgroup>
</hgroup>
</page>
}

/// Contents of the dialog body.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane valign="top">
<spacer height="20" />
<vgroup>
<hgroup valign="top">
<spacer width="20" />
<vgroup enclosingClass="wizardBox" valign="top">
<hgroup>
<spacer width="5"/>
<label id="import" enclosingClass="topLabel" label="Import"></label>
<spacer width="35"/>
<label id="name" enclosingClass="topLabel" label="Agent"></label>
<spacer width="85"/>
<label id="type" enclosingClass="topLabel" label=" Interface Type"></label>
<spacer width="50"/>
<label id="config" enclosingClass="topLabel" label="Configuration Item"></label>
</hgroup>
<spacer height="10"/>
<group id="itemsToImport" layout="none" valign="top" labelPosition="top" 
      enclosingStyle="position:relative;top:0px;left:0px;width:675px;height:30px;" >
</group>
</vgroup>
</hgroup>
</vgroup>
</pane>
}

Method DrawContent(pSeed As %String) As %Status
{
	Quit $$$OK
}

/// Get all the necessary data about the items from the server in one call.
Method GetItemUpdateFromServer() As %String [ ZenMethod ]
{
	Set tMsg = ""
	Try {
		Set tMsg = ..PopulateItemsFromGlobals() // get all the items 
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tMsg
}

ClientMethod addAllGroups(incomingData) [ Language = javascript ]
{
	try {
		this._lineArray = [];
		var agents = 0;
		var interfaces =0;
		var len = incomingData.length;
		for (var i=0; i < len; i++) {
			var newGroup = zenPage.makeNewRow(incomingData[i]);
			this._lineArray.push(newGroup);
			var mainGroup = zen('itemsToImport');
			mainGroup.getEnclosingDiv().appendChild(newGroup);
			if (incomingData[i].split('\u0006')[1]=="0") agents = agents + 1;
			else interfaces = interfaces + 1; 
		}
		mainGroup.getEnclosingDiv().style.height = (agents * 35) + (interfaces * 18) + 50 + "px";
		zenPage.updateDisplay();
	}
	catch (ex) {
		alert('Exception in addAllGroups: ' + ex.description + ' Details: ' + ex.extMessage);
	}
}

ClientMethod updateDisplay() [ Language = javascript ]
{
	try {
		var line = this._lineArray;
		if (!line) return;
		var len = line.length;
		var agents = 0;
		var interfaces = 0;
		for (var i = 0; i < len; i++) {
			var style = line[i].style;
			style.position = "absolute";
			//style.height = "30px";
			style.width = "100%";
			style.left = "0px";
			if (document.getElementById('import_'+i)) agents = agents + 1;
			else interfaces = interfaces + 1; 
			style.top = (agents * 35) + (interfaces * 18)  + "px";
		}
	}
	catch (ex) {
		alert('Exception in updateDisplay ' + ex.description + ' Details: ' + ex.extMessage);
	}
}

ClientMethod doSelectAll(select) [ Language = javascript ]
{
	var index;
	for (var i=0; i < zenPage.fieldCount; i++) {
		index = i.toString();
		var checkbox = document.getElementById('import_' + index);
		if (checkbox) {
			checkbox.checked = select;
			this.switchImportTitle(index);
		}
	}
}

ClientMethod switchImportTitle(key) [ Language = javascript ]
{
	var checkbox = document.getElementById('import_' + key);
	if (checkbox) {
		if (checkbox.checked) {
			checkbox.title = "Click to prevent this agent from importing.";
		}
		else {
			checkbox.title = "Click to import this agent.";
		}
	}
}

/// incomingData is a string separated with \u0006 characters that
/// contains the data to use in populating the fields in this row.
/// If not provided, a blank-appearing row (empty of data) is created and returned.
ClientMethod makeNewRow(incomingData) [ Language = javascript ]
{
	try {
		zenPage.currentFields += 1;
		zenPage.fieldCount += 1;
		var key = zenPage.fieldCount -1;
		if (incomingData) {
			value = incomingData.split('\u0006');
		}
		
		var newGroup = document.createElement('div');
		newGroup.id = 'itemGroup_' + key.toString();
		
		var html = [];
		
		if (value[1]=="0") {
			var color = 'black';
			var weight = '600';

			html.push('<input type="checkbox" id="import_'+ key.toString() +
				'" name="import_'+ key.toString() + 
				'" class="importButtonClass"  ' + 'value="' + value[0].toString() +'" checked '+ 
				'title="' + $$$Text("Click to prevent this agent from importing.") + '" onclick="zenPage.switchImportTitle('+key.toString()+');"/>');
			if (value[4]!="new") {
				agentTitle = $$$Text('Importing this agent will overwrite the existing record for Agent '+value[0]);
			}
			else {
				agentTitle = $$$Text('No record currently exists for this agent');
			}
			html.push('<span class="agentNameClass" style="color:'+color+';font-weight:'+weight+'" title="'+agentTitle+'">' + $$$Text(value[0]) + '</span>');
			html.push('<input id="agentInfo_' + key.toString() + '" editable="false" hidden="true" value="' + value[4] + '"/>');
		}
		else {
			var agentTitle="";
			var color = '#707070';
			var weight = '300';
		}
		html.push('<span class="clientTypeClass" style="color: '+color+';font-weight:'+weight+';" title="'+agentTitle+'">' + $$$Text(value[2]) + '</span>');
		html.push('<span class="clientConfigItemClass" style="color: '+color+';font-weight:'+weight+';" title="'+agentTitle+'">' + $$$Text(value[3]) + '</span>');
		newGroup.innerHTML = html.join('');
	}
	catch (ex) {
		alert('Exception in makeNewRow: ' + ex.description + ' Details: ' + ex.extMessage);
	}
	return newGroup;
}

/// This method is invoked when the user completes the Wizard pressing "OK".
/// Returns a null string if it succeeds, or an error message otherwise.
Method OnWizardCompletion() As %String [ ZenMethod ]
{
		Quit ""
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Import","Ensemble")
}

/// Get the (localized) title string for the page.
Method %OnGetTitle() As %String
{
	Quit ..%OnGetPageName()
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit $$$TextHTML("Select agents you wish to import.")
}

/// This callback is called when the user presses the OK button.
/// If this returns false, then the action is canceled.
ClientMethod ondialogFinish(action) As %Boolean [ Language = javascript ]
{
	try {
		var items = []
		var index = ""
		var count = 1;
		items[0] = zenPage.File;
		for (var i=0; i < zenPage.fieldCount; i++) {
			index = i.toString();
			var checkbox = document.getElementById('import_' + index);
			if (checkbox) {
				if (checkbox.checked == true) {
					var agent = checkbox.value;
					var exists = document.getElementById('agentInfo_'+index).value;
					items[count] = exists + '^' + agent;
					count++;
				}
			}
		}
	}
	catch(ex) {
		alert("exception: name: " + ex.name + " message: " + ex.message);
		zenExceptionHandler(ex,arguments);
		this.retValue = "";
		return false;
	}

	this.retValue = [];
	this.retValue = items;
	return true;
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	return encodeURIComponent(this.retValue);
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	Quit:$$$ISERR(tSC)
		
	Set %page.fieldCount = 0
	Set %page.currentFields = 0
	
	Do ..PopulateItemsFromGlobals()
	
	Quit $$$OK
}

Method PopulateItemsFromGlobals() As %String
{
	Try {
		Set tString = ""
		Set agent = ""
		merge Conflicts = ^IRIS.Temp.EnsPortal($UserName,"Skorpius","ImportConflicts")
		For {
			Set agent = $o(Conflicts(agent))
			Quit:""=agent
			Set firstID = $o(Conflicts(agent,""))
			If firstID'="0" {
				Set isConflict = ##class(EnsLib.Agent.Interface).%ExistsId(agent_"||0")
				Set tString = tString _ $S(tString="":"",1:$C(5))  _ agent _ $C(6) _ "0" _ $C(6,6,6) _ $S(isConflict:"clearClients",1:"create")
				Set id = "0" 
			}
			Else {
				Set id=""
			}
			For {
				Set id = $o(Conflicts(agent,id))
				Quit:""=id
				Set regID = Conflicts(agent,id)
				If $p(regID,"^",1)="None" {
					Set conflict = 0
					Set tType = $p(regID,"^",2)
					Set tConfigItem = $p(regID,"^",3)
				}
				Else {
					Set conflict = 1
					Set tItem = ##class(EnsLib.Agent.Interface).%OpenId(agent_"||"_regID)
					Set tType = tItem.Type
					Set tConfigItem = tItem.ConfigItem
				}			
				Set tString = tString _ $S(tString="":"",1:$C(5))  _ agent _ $C(6)  _ id _ $C(6)_ tType _ $C(6) _ tConfigItem _ 
					$C(6)_$S(id="0":$S($p(Conflicts(agent,"0"),"^",1)="None":"new",1:"clear") ,1:"")
			} 
		}
		Set %page.incomingData = tString
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tString
}

/// This callback, if defined, is called when the dialog page is loaded.
ClientMethod ondialogStart() [ Language = javascript ]
{
	if (zenPage.incomingData && (zenPage.incomingData.length > 0)) {
		if (zenIsIE) {
			setTimeout("zenPage.addAllGroups(zenPage.incomingData);", 100);
		}
		else {
			zenPage.addAllGroups(zenPage.incomingData);
		}
	}
}

/// Callback to return a list of resources required for a specific HyperEvent.
/// The user must have sufficient privileges on one of the resource/permission pairs
/// to be permitted to execute the hyperevent. An empty string implies the user already
/// has sufficient privileges for the ZenMethod specified in <var>pMethod</var>.
ClassMethod GetHyperEventResources(pMethod As %String = "") As %String
{
	Quit $case(pMethod,
					: "")
}

}
