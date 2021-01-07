/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsHL7)

/// Create a new production and add components to it.
Class EnsPortal.HL7.Dialog.CustomSegmentStructure Extends EnsPortal.HL7.Dialog.standardDialog [ System = 4 ]
{

Parameter APPLYBUTTON = 0;

/// User needs WRITE permissions on the %Ens_EDISchema resource to view this page.
Parameter RESOURCE = "%Ens_EDISchema:WRITE";

Parameter PAGENAME = "Custom Segment Structure Wizard";

Parameter CSSINCLUDES = "ensemble/Ensemble_Wizards.css,ensemble/Ensemble_EDI.css";

/// Schema being edited
Property category As %ZEN.Datatype.string(ZENURL = "CAT");

/// Immediate base schema of the schema being edited
Property baseSchema As %ZEN.Datatype.string(ZENURL = "BASE");

/// Segment structure being worked on
Property customSeg As %String(ZENURL = "SS");

/// "newFromSchemaMain", "copyFromSchemaMain", and "edit" are the valid values. 
/// Identifies the context in which the dialog is being used.
Property caseType As %ZEN.Datatype.string(ZENURL = "TYPE");

/// Keeps track of where we are in counting fields, so we can create unique field ids.
Property fieldCount As %Integer;

/// Keeps track of how many fields are currently displaying.
Property currentFields As %Integer;

/// Comma-separated string suitable for being used as a valueList for a combobox where the user chooses data structures.
Property chooseDS As %ZEN.Datatype.string;

/// Comma-separated string suitable for being used as a valueList for a combobox where the user chooses code tables.
Property chooseCT As %ZEN.Datatype.string;

/// In the case of "copyFromSchemaMain" or "edit" we have existing data to put onto the screen
Property incomingData As %ZEN.Datatype.list(MAXLEN = "");

/// Holder for return value.
Property retValue As %ZEN.Datatype.string;

/// Array for disambiguation of names
Property %propNames As %String [ MultiDimensional ];

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
.upButtonClass {
	position: absolute;
	left: 0px;
	top: 15px;
}
.downButtonClass {
	position: absolute;
	left: 20px;
	top: 15px;
}
.deleteButtonClass {
	position: absolute;
	left: 40px;
	top: 15px;
}
.segPieceLabel {
	font-size: 8pt;
	font-weight: bold;
	position: absolute;
	left: 60px;
	top: 0px;
}
.segPieceClass {
	width: 40px;
	font-size: 8pt;
	position: absolute;
	left: 60px;
	top: 15px;
}
.segDescLabel {
	font-size: 8pt;
	font-weight: bold;
	position: absolute;
	left: 108px;
	top: 0px;
}
.segDescClass {
	width: 155px;
	font-size: 8pt;
	position: absolute;
	left: 108px;
	top: 15px;
}
.segPropLabel {
	font-size: 8pt;
	font-weight: bold;
	position: absolute;
	left: 271px;
	top: 0px;
}
.segPropClass {
	width: 155px;
	font-size: 8pt;
	position: absolute;
	left: 271px;
	top: 15px;
}
.dataStructLabel {
	font-size: 8pt;
	font-weight: bold;
	position: absolute;
	left: 434px;
	top: 0px;
}
.dataStructClass {
	width: 100px;
	font-size: 9pt;
	position: absolute;
	left: 434px;
	top: 15px;
}
.symbolLabel {
	font-size: 8pt;
	font-weight: bold;
	position: absolute;
	left: 537px;
	top: 0px;
}
.symbolClass {
	width: 45px;
	font-size: 8pt;
	position: absolute;
	left: 537px;
	top: 15px;
}
.repeatLabel {
	font-size: 8pt;
	font-weight: bold;
	position: absolute;
	left: 591px;
	top: 0px;
}
.repeatClass {
	width: 45px;
	font-size: 8pt;
	position: absolute;
	left: 591px;
	top: 15px;
}
.minlengthLabel {
	font-size: 8pt;
	font-weight: bold;
	position: absolute;
	left: 644px;
	top: 0px;
}
.minlengthClass {
	width: 75px;
	font-size: 8pt;
	position: absolute;
	left: 644px;
	top: 15px;
}
.maxlengthLabel {
	font-size: 8pt;
	font-weight: bold;
	position: absolute;
	left: 727px;
	top: 0px;
}
.maxlengthClass {
	width: 75px;
	font-size: 8pt;
	position: absolute;
	left: 727px;
	top: 15px;
}
.requiredLabel {
	font-size: 8pt;
	font-weight: bold;
	position: absolute;
	left: 809px;
	top: 0px;
}
.requiredClass {
	width: 65px;
	font-size: 9pt;
	position: absolute;
	left: 809px;
	top: 15px;
}
.repeatingLabel {
	font-size: 8pt;
	font-weight: bold;
	position: absolute;
	left: 876px;
	top: 0px;
}
.repeatingClass {
	width: 70px;
	font-size: 9pt;
	position: absolute;
	left: 876px;
	top: 15px;
}
.codeTableLabel {
	font-size: 8pt;
	font-weight: bold;
	position: absolute;
	left: 948px;
	top: 0px;
}
.codeTableClass {
	width: 80px;
	font-size: 9pt;
	position: absolute;
	left: 948px;
	top: 15px;
}
.segAltLabel {
	font-size: 8pt;
	font-weight: bold;
	position: absolute;
	left: 1031px;
	top: 0px;
}
.segAltClass {
	width: 160px;
	font-size: 8pt;
	position: absolute;
	left: 1031px;
	top: 15px;
}
</style>
}

/// Contents of the dialog body.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane valign="top">
<spacer height="20" />
<hgroup valign="top">
<spacer width="20" />
<vgroup enclosingClass="wizardBox" valign="top">
<label id="schemaLabel" enclosingClass="labelComment" label=""></label>
<label id="baseLabel" enclosingClass="labelComment" label=""></label>
<spacer height="10" />
<combobox id="copySegName" name="copySegName" label="Segment Structure to Copy" editable="false" 
    enclosingStyle="padding-bottom:4px;" size="47" labelClass="labelRequired" required="true" hidden="false"
	title="Choose a segment structure to copy." onchange="zenPage.chooseCopySeg();"
/>
<text label="New Segment Structure Name" name="txtName" id="txtName" labelClass="labelRequired" value="" size="50"
   hidden="false"
	title="Enter a segment structure name in this field. Do not use any whitespace characters, or any punctuation characters including _ (underscore) or . (period) in the name. There is no need to provide a schema name with the segment structure name; the segment structure will be created in the current custom schema." />
<text label="Description" name="txtDesc" id="txtDesc" labelClass="labelRequired" size="80" />
<label id="txtSubFields" enclosingClass="labelRequired" labelStyle="color:black;"  label="Segment Fields"></label>
<spacer height="10" />
<group id="subFields" layout="none" valign="top" labelPosition="top" 
      enclosingStyle="position:relative;top:0px;left:0px;width:1204px;height:50px;" >
<button id="addSubField" caption="Add Field" controlClass="commandButton" 
      enclosingStyle="position:absolute;bottom:0px;left:0px;"
        onclick="zenPage.addRow();"/>
</group>
</vgroup>
</hgroup>
</pane>
}

Method DrawContent(pSeed As %String) As %Status
{
	Quit $$$OK
}

ClientMethod chooseCopySeg() [ Language = javascript ]
{
	try {
		copyStruct = zen('copySegName').getValue();
		if ((copyStruct.length > 0) && (copyStruct.match(' ') == ' ')) {
			if (this._lineArray) {
				zenPage.deleteAllGroups();
			}
			var temp = copyStruct.split(' ');
			var copySSSchema = temp[1].substring(1, temp[1].length - 1);
			var copySSName = temp[0];
			temp = zenPage.GetSegStructUpdateFromServer(copySSSchema, copySSName);
			var value = temp.split('\u0005'); 
			zen('txtName').setHidden(false); // leave the new name blank
			var desc = zen('txtDesc');
			desc.setValue(value[0]); // use the description
			desc.setHidden(false);
			zen('txtSubFields').setHidden(false); // show the segment header
			zen('subFields').setHidden(false); // show the segment information
			zenPage.addAllGroups(value); // use the segment information
		}
		else {
			alert('Please choose a segment structure to copy.');
		}
	}
	catch (ex) {
		alert('Exception in chooseCopySeg: ' + ex.description + ' Details: ' + ex.extMessage);
	}
}

/// Get all the necessary data about the segment structure from the server in one call.
Method GetSegStructUpdateFromServer(pSchema As %String, pSegStruct As %String) As %String [ ZenMethod ]
{
	Set tMsg = ""
	Try {
		Set tMsg = ..PopulateSegmentFieldsFromSchema(pSchema, pSegStruct) // get all the segments and description
	}
	Catch (ex) {
	}
	Quit tMsg
}

ClientMethod addRow(incomingData) [ Language = javascript ]
{
	try {
		if (!this._lineArray) {
			this._lineArray = [];
		}
		var newGroup;
		if (incomingData) {
			newGroup = zenPage.makeNewRow(incomingData);
		}
		else {
			newGroup = zenPage.makeNewRow();
		}
		this._lineArray.push(newGroup);
		var mainGroup = zen('subFields');
		mainGroup.getEnclosingDiv().appendChild(newGroup);
		mainGroup.getEnclosingDiv().style.height = (((this._lineArray.length) * 70) + 40) + "px";
		zenPage.updateDisplay();
	}
	catch (ex) {
		alert('Exception in addRow: ' + ex.description + ' Details: ' + ex.extMessage);
	}
}

ClientMethod addAllGroups(incomingData) [ Language = javascript ]
{
	try {
		this._lineArray = [];
		var len = incomingData.length;
		for (var i=1; i < len; i++) {
			var newGroup = zenPage.makeNewRow(incomingData[i]);
			this._lineArray.push(newGroup);
			var mainGroup = zen('subFields');
			mainGroup.getEnclosingDiv().appendChild(newGroup);
		}
		mainGroup.getEnclosingDiv().style.height = (((this._lineArray.length) * 70) + 40) + "px";
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
		for (var i = 0; i < len; i++) {
			var n = line[i].id.substring(8);
			text = document.getElementById('segPiece' + n.toString());
			text.value = i + 1;
			var style = line[i].style;
			style.position = "absolute";
			style.height = "70px";
			style.width = "100%";
			style.left = "0px";
			style.top = (i * 70) + "px";
			var upStyle = document.getElementById('upButton' + n.toString()).style;
			var downStyle = document.getElementById('downButton' + n.toString()).style;
			if (i == 0) {
				if (zenPage.currentFields == 1) {
					upStyle.display = "none";
					downStyle.display = "none";
				}
				else {
					upStyle.display = "none";
					downStyle.display = "block";
				}
			}
			else if (i == (len - 1)) {
				upStyle.display = "block";
				downStyle.display = "none";
			}
			else {
				upStyle.display = "block";
				downStyle.display = "block";
			}
		}
	}
	catch (ex) {
		alert('Exception in updateDisplay ' + ex.description + ' Details: ' + ex.extMessage);
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
		var key = zenPage.fieldCount;
		if (incomingData) {
			value = incomingData.split('\u0006');
		}
		
		var newGroup = document.createElement('div');
		newGroup.id = 'segGroup' + key.toString();
		
		var html = [];
		
		html.push('<img id="upButton' + key.toString() + '" class="upButtonClass" src="deepsee/ds_up_16.png" ' +
				  'srcMissing="' + $$$Text("Up") + '" onclick="zenPage.moveRowUp(\'' + key.toString() + '\');" ' +
				  'title="' + $$$Text("Click to move the field up in the field order.") + '"/>');
		html.push('<img id="downButton' + key.toString() + '" class="downButtonClass" src="deepsee/ds_down_16.png" ' +
				  'srcMissing="' + $$$Text("Down") + '" onclick="zenPage.moveRowDown(\'' + key.toString() + '\');" ' +
				  'title="' + $$$Text("Click to move the field down in the field order.") + '"/>');
		html.push('<img id="deleteButton' + key.toString() + '" class="deleteButtonClass" src="images/MacCloseX.png" ' +
				  'srcMissing="' + $$$Text("Delete") + '" onclick="zenPage.deleteOption(\'' + key.toString() + '\');" ' +
				  'title="' + $$$Text("Click to delete the field from the segment definition.") + '"/>');
				  
		html.push('<span class="segPieceLabel">' + $$$Text("Field") + '</span>');
		html.push('<input id="segPiece' + key.toString() + '" class="segPieceClass" readonly="readonly" disabled="disabled" ' +
		          'title="' + $$$Text("This is a number indicating the order of the substructure in the segment") + '"/>');
		          
		html.push('<span class="segDescLabel">' + $$$Text("Description") + '</span>');
		html.push('<input id="segDesc' + key.toString() + '" class="segDescClass" ' + 
				  'title="' + $$$Text("Enter a text description"));
		if (incomingData) html.push('" value="' + value[0] + '"/>');
		else html.push('"/>');
	
		html.push('<span class="segPropLabel">' + $$$Text("Property Name") + '</span>');
		html.push('<input id="segProp' + key.toString() + '" class="segPropClass" readonly="readonly" disabled="disabled" ' +
		          'title="' + $$$Text("This is the name of the property corresponding to this segment substructure; it will be calculated after you save your work"));
		if (incomingData) html.push('" value="' + value[1] + '"/>');
		else html.push('"/>');
		          
		html.push('<span class="dataStructLabel">' + $$$Text("Data Structure") + '</span>');
		html.push('<select id="dataStruct' + key.toString() + '" class="dataStructClass" ' +
				  'title="' + $$$Text("Choose a data structure, or choose blank") + '">');
		var choose = zenPage.chooseDS.split(','); // the blank option is included as the first item in this list
		if (incomingData) {
			var newVal = value[2];
			if ((newVal.length > 0) && (newVal.match(":") == ":")) {
				newVal = newVal.split(':')[1];
			}
		}
		for (var i=0; i < choose.length; i++) {
			html.push('<option value="' + choose[i] + '"');
			if (incomingData) {
				if (choose[i] == newVal) html.push(' selected="selected">' + choose[i] + '</option>');
				else html.push('>' + choose[i] + '</option>');
			}
			else {
				if (choose[i] == "") html.push(' selected="selected">' + choose[i] + '</option>');
				else html.push('>' + choose[i] + '</option>');
			}
		}
		html.push('</select>');
		
		html.push('<span class="symbolLabel">' + $$$Text("Symbol") + '</span>');
		html.push('<input id="symbol' + key.toString() + '" name="symbol' + key.toString() + '" class="symbolClass" ' +
				  'readonly="readonly" disabled="disabled" ' +
				  'title="' + $$$Text("After you save your work, symbols will be calculated based on your other choices. Symbols are:") + 
					" * " + $$$Text("(zero or more)") + 
					", + " + $$$Text("(one or more)") + ", ! " + $$$Text("(exactly one required)") +
					", ? " + $$$Text("(conditional)") + ", & " + $$$Text("(conditional repeating)"))
		if (incomingData) html.push('" value="      ' + value[3] + '"/>');
		else html.push('"/>');
		html.push('<span class="repeatLabel">' + $$$Text("Count") + '</span>');
		html.push('<input id="repeat' + key.toString() + '" class="repeatClass" ' + 
				  'title="' + $$$Text("Enter a number of repeats"));
		if (incomingData) html.push('" value="' + value[4] + '"/>');
		else html.push('"/>');
	
	
		html.push('<span class="minlengthLabel">' + $$$Text("Min Length") + '</span>');
		html.push('<input id="minLength' + key.toString() + '" class="minlengthClass" ' + 
				  'title="' + $$$Text("Enter a minimum number of characters"));
		if (incomingData) html.push('" value="' + value[5] + '"/>');
		else html.push('"/>');
		
		html.push('<span class="maxlengthLabel">' + $$$Text("Max Length") + '</span>');
		html.push('<input id="maxLength' + key.toString() + '" class="maxlengthClass" ' + 
				  'title="' + $$$Text("Enter a maximum number of characters"));
		if (incomingData) html.push('" value="' + value[6] + '"/>');
		else html.push('"/>');
	
		html.push('<span class="requiredLabel">' + $$$Text("Required") + '</span>');
		html.push('<select id="required' + key.toString() + '" class="requiredClass" ' +
				  'title="' + $$$Text("Choose a code. Codes are:") + 
				  " B " + $$$Text("(backward compatible)") + ", C " + $$$Text("(conditional)") + 
				  ", O " + $$$Text("(optional)") + ", R " + $$$Text("(required)") + 
				  ", W " + $$$Text("(withdrawn)") + ", X " + $$$Text("(not supported)") + '">');
		itemString = ",B,C,O,R,W,X"
		choose = itemString.split(','); 
		if (incomingData) {
			newVal = value[7];
			if (newVal.length <= 0) newVal = "O"; 
		}
		for (var i=0; i < choose.length; i++) {
			html.push('<option value="' + choose[i] + '"');
			if (incomingData) {
				if (choose[i] == newVal) html.push(' selected="selected">' + choose[i] + '</option>');
				else html.push('>' + choose[i] + '</option>');
			}
			else {
				if (choose[i] == "O") html.push(' selected="selected">' + choose[i] + '</option>');
				else html.push('>' + choose[i] + '</option>');
			}
		}
		html.push('</select>');
		
		html.push('<span class="repeatingLabel">' + $$$Text("Repeating") + '</span>');
		html.push('<select id="repeating' + key.toString() + '" class="repeatingClass" ' +
				  'title="' + $$$Text("Choose Yes if the substructure may repeat, otherwise No") + '">');
		itemString = $$$Text("Yes") + "," + $$$Text("No")
		choose = itemString.split(','); 
		itemString = "1,0";
		var choiceVal = itemString.split(',');
		for (var i=0; i < choose.length; i++) {
			html.push('<option value="' + choiceVal[i] + '"');
			if (incomingData) {
				if (choiceVal[i] == value[8]) html.push(' selected="selected">' + choose[i] + '</option>');
				else html.push('>' + choose[i] + '</option>');
			}
			else {
				if (choiceVal[i] == "0") html.push(' selected="selected">' + choose[i] + '</option>');
				else html.push('>' + choose[i] + '</option>');
			}
		}
		html.push('</select>');
		
		html.push('<span class="codeTableLabel">' + $$$Text("Code Table") + '</span>');
		html.push('<select id="codeTable' + key.toString() + '" class="codeTableClass" ' +
				  'title="' + $$$Text("Choose a code table, or choose blank") + '">');
		var choose = zenPage.chooseCT.split(','); // the blank option is included as the first item in this list
		if (incomingData) {
			newVal = value[9];
			if ((newVal.length > 0) && (newVal.match(":") == ":")) {
				newVal = newVal.split(':')[1];
			}
		}
		for (var i=0; i < choose.length; i++) {
			html.push('<option value="' + choose[i] + '"');
			if (incomingData) {
				if (choose[i] == newVal) html.push(' selected="selected">' + choose[i] + '</option>');
				else html.push('>' + choose[i] + '</option>');
			}
			else {
				if (choose[i] == "") html.push(' selected="selected">' + choose[i] + '</option>');
				else html.push('>' + choose[i] + '</option>');
			}
		}
		html.push('</select>');
		
		html.push('<span class="segAltLabel">' + $$$Text("Alternative Description") + '</span>');
		html.push('<input id="segAlt' + key.toString() + '" class="segAltClass" ' + 
				  'title="' + $$$Text("Enter an alternate text description"));
		if (incomingData) html.push('" value="' + value[10] + '"/>');
		else html.push('"/>');
	
		newGroup.innerHTML = html.join('');
	}
	catch (ex) {
		alert('Exception in makeNewRow: ' + ex.description + ' Details: ' + ex.extMessage);
	}
	return newGroup;
}

/// Intended for responding to the delete button at the left of a row of fields
ClientMethod deleteOption(n) [ Language = javascript ]
{
	var currentGroup = document.getElementById('segGroup' + n.toString()); 
    zenPage.deleteGroup(currentGroup);
}

/// Intended for a group that contains a row of fields
ClientMethod deleteGroup(currentGroup) [ Language = javascript ]
{
	if (currentGroup) {
		zenPage.currentFields -= 1;
		var mainGroup = zen('subFields');
		mainGroup.getEnclosingDiv().removeChild(currentGroup);
		zenPage.removeLine(currentGroup);
		mainGroup.getEnclosingDiv().style.height = (((this._lineArray.length) * 70) + 40) + "px";
		zenPage.updateDisplay(); 
	}
	else alert('Unable to delete substructure from the structure.');
}

ClientMethod deleteAllGroups() [ Language = javascript ]
{
	zenPage.currentFields = 0;
	var mainGroup = zen('subFields');
	var line = this._lineArray;
	var len = line.length;
	for (var i=0; i < len; i++) {
		mainGroup.getEnclosingDiv().removeChild(line[i]);
	}
	this._lineArray = [];
}

/// Utility method for manipulating the line array when deleting a row of fields
ClientMethod removeLine(currentGroup) [ Language = javascript ]
{
	var line = this._lineArray;
	var len = line.length;
	var found = false;
	for (var i=0; i < (len - 1); i++) {
		if (line[i] == currentGroup) { // found item to remove
			found = true;
		}
		if (found) {
			line[i] = line[i + 1]; // advance items that are still there
		}
	}
	line.pop(); // remove from end
}

ClientMethod moveLine(currentGroup, where) [ Language = javascript ]
{
	var done = false;
	var upperLimit, lowerLimit;
	var line = this._lineArray;
	var len = line.length;
	if (where == "up") {
		if (line[0] == currentGroup) return;
		lowerLimit = 1;
		upperLimit = len;
	}
	else if (where == "down") {
		if (line[len - 1] == currentGroup) return;
		lowerLimit = 0;
		upperLimit = len - 1;
	}
	for (var i=lowerLimit; ((!done) && (i < upperLimit)); i++) {
		if (line[i] == currentGroup) {
			var temp = line[i];
			if (where == "up") {
				line[i] = line[i - 1];
				line[i - 1] = temp;
				done = true;
			}
			else if (where == "down") {
				line[i] = line[i + 1];
				line[i + 1] = temp;
				done = true;
			}
		}
	}
	zenPage.updateDisplay();
}

ClientMethod moveRowUp(n) [ Language = javascript ]
{
	var currentGroup = document.getElementById('segGroup' + n.toString()); 
    if (currentGroup) {
		zenPage.moveLine(currentGroup, "up");
    }
}

ClientMethod moveRowDown(n) [ Language = javascript ]
{
	var currentGroup = document.getElementById('segGroup' + n.toString()); 
    if (currentGroup) {
		zenPage.moveLine(currentGroup, "down");
    }
}

/// Label the fields in the indicated row in order from left to right.
ClientMethod labelFields(n) [ Language = javascript ]
{
}

/// Remove labels from the fields in the indicated row.
ClientMethod unlabelFields(n) [ Language = javascript ]
{
}

ClientMethod validateAll() [ Language = javascript ]
{
	var ok = true;
	var msg = '';
	var finalMsg = '';
	var list = '';
	var temp = '';
	var val = '';

	// validate the copy segment structure if it is there
	if ((zenPage.caseType.match('copy') == 'copy') && (zenPage.caseType != "newORcopy")) {
		temp = zen('copySegName').getValue();
		if (temp.length <= 0) {
			finalMsg += ('  ' + $$$Text("You must choose a segment structure to copy.") + '\n');
			ok = false;
		}
	}

	if (ok) {
		
		// validate the new segment structure name
		var name = zen('txtName').getValue();
		var temp = name.replace(/\s/g, "");	
		temp = temp.replace(/\t/g, "");
		if (temp.length != name.length) {
			name = temp;
			zen('txtName').setValue(name);
		}
		// separate out the segment structure schema and name, if a schema is provided to mimic our drop-downs
		var SSName = zenPage.sortOutEntityName(name, $$$Text("Too many space characters in the segment structure name."));

		// run through validation of the usual name issues
		var len = SSName.length;
		if (len <= 0) {
			finalMsg += ('  ' + $$$Text("You have not entered a new segment structure name."));
			finalMsg += (' ' + $$$Text("For the new segment structure name, do not use any whitespace characters, or any punctuation characters other than _ (underscore) or . (period).") + '\n');
			ok = false;
		}
		else {
			if (SSName.match(/[`~@#$%^&*()-+={}\[\]|\\:;"'<,>?\/]/) || SSName.match(/\s/) || SSName.match(/\t/)) {
				finalMsg += ('  ' +  $$$Text("For the new segment structure name, do not use any whitespace characters, or any punctuation characters other than _ (underscore) or . (period). ") + '\n');
				ok = false;
			}
			else {
				// does the proposed new message type already exist in the schema?
				var exists = zenPage.GetValidationDataFromServer(zenPage.category, SSName);
				if (exists == "1") {
					if ((zenPage.caseType == "newFromSchemaMain") || (zenPage.caseType == "copyFromSchemaMain")) { 
						finalMsg += ('  ' + $$$FormatText($$$Text("The specified new segment structure %2 already exists in the custom schema %1. If you want to create a new segment structure, use a different name."),zenPage.category,SSName));
						finalMsg += (' ' + $$$FormatText($$$Text("If you want to edit the segment structure %1, dismiss this message, click Cancel in this dialog, click through to the segment structure description, and click Edit."),SSName) + '\n');

						ok = false;
					} else if (zenPage.caseType == "newORcopy") {
						// slightly different message
						finalMsg += ('  ' + $$$FormatText($$$Text("The specified new segment structure %2 already exists in the custom schema %1. If you want to create a new segment structure, use a different name."),zenPage.category,SSName));
						finalMsg += (' ' + $$$FormatText($$$Text("If you want to edit the segment structure %1, dismiss this message, click Cancel in this dialog, navigate to the segment structure description, and click Edit."),SSName) + '\n');
						ok = false;
					}
				}
			}
		}

		// validate the fields for each segment
		if (zenPage.currentFields == 0) {
			finalMsg += ('  ' + $$$Text("There are no fields to save.") + '\n');
			ok = false;
		}
		else {
			var n, index;
			var fieldPresent = [];
			var descPtr;
			var count;
			for (var i=1; i <= zenPage.fieldCount; i++) {
				index = i.toString();
				var piece = document.getElementById('segPiece' + index);
				if (piece) {
					n = parseInt(piece.value); // n is between 1 and currentFields, inclusive
					fieldPresent[n] = index;
				}
			}
			for (var i=1; i < fieldPresent.length; i++) {
				index = fieldPresent[i];
				descPtr = document.getElementById('segDesc' + index);
				desc = descPtr.value;
				var temp = desc.replace(/\s/g, "");	
				temp = temp.replace(/\t/g, "");
				if (temp.length == 0) {
					desc = temp;
					descPtr.value = desc;
				}
				if (desc.length <= 0) {
					finalMsg += ('  ' + $$$FormatText($$$Text("Field %1 does not have a description."), i) + '\n');
					ok = false;
				}
				count = document.getElementById('repeat' + index).value;
				if ((count.toString().length > 0) && (isNaN(count))) {
					finalMsg += ('  ' + $$$FormatText($$$Text("Field %1 repeat count is not a number."), i) + '\n');
					ok = false;
				}
				repeating = document.getElementById('repeating' + index).value;
				if ((count.toString().length > 0) && !(isNaN(count)) && (count > 1) && (repeating == 0)) {
					finalMsg += ('  ' + $$$FormatText($$$Text("Field %1 does not repeat, but has repeat count greater than one."),i) + '\n');
					ok = false;
				}
				count = document.getElementById('minLength' + index).value;
				if ((count.toString().length > 0) && (isNaN(count))) {
					finalMsg += ('  ' + $$$FormatText($$$Text("Field %1 min length is not a number."), i) + '\n');
					ok = false;
				}
				count = document.getElementById('maxLength' + index).value;
				if ((count.toString().length > 0) && (isNaN(count))) {
					finalMsg += ('  ' + $$$FormatText($$$Text("Field %1 max length is not a number."), i) + '\n');
					ok = false;
				}
				min_count = document.getElementById('minLength' + index).value;
				if ((count.toString().length > 0) && (min_count.toString().length > 0) && !(isNaN(count)) && !(isNaN(min_count)) && (parseInt(min_count) > parseInt(count))) {
					finalMsg += ('  ' + $$$FormatText($$$Text("Field %1 min length is greater than max length."),i) + '\n');
					ok = false;
				}
			}
		}

		if (ok == false) {
		 	finalMsg = ($$$Text("ERRORS:") + '\n' + finalMsg);
			finalMsg += ('\n' + $$$Text("NOTE: Because there were errors, your changes have not been saved.") + ' ' 
			        + $$$Text("To save your work, click OK in this alert box, correct the reported problems, and then click OK in the dialog.")
			        + '\n');
			alert(finalMsg);
		}
	}
	
	return ok;
}

ClientMethod sortOutEntityName(name, msg) [ Language = javascript ]
{
	if (name.match(' ') == ' ') {
		var temp = name.split(' ');
		if (temp.length > 2) {
			msg += ('  ' + msg + '\n');
			ok = false;
		}
		else if ((temp.length == 2) &&
				(temp[1].charAt(0) == '(') && 
				(temp[1].charAt(temp[1].length - 1) == ')')) { // our drop-down, or user mimicked our drop-downs
					return (temp[0]);
				}
		else {
			return (name);
		}
	}
	else {
		return (name);
	}
}

/// Get all the necessary data from the server in one call and use it later.
/// pCustomSchema and pNewMS are without prefix or suffix. 
/// <p>
/// Here is the format of the semi-colon separated string (values shown in angle brackets which are not really there): <br/>
/// <is pNewSS existing in pCustomSchema>
ClassMethod GetValidationDataFromServer(pCustomSchema As %String, pNewSS As %String) As %String [ ZenMethod ]
{
	Set tMsg = ""
	Try {
		Set tMsg = ##class(EnsPortal.HL7.Utils).SchemaEntityAlreadyExists(pCustomSchema, pNewSS, "SS")
	}
	Catch (ex) {
	}
	Quit tMsg
}

/// This method is invoked when the user completes the Wizard pressing "OK".
/// Returns a null string if it succeeds, or an error message otherwise.
Method OnWizardCompletion(pCustomSchema As %String, pNewSS As %String, pDescription As %String, pDetails As %String) As %String [ ZenMethod ]
{
	If '..canEdit Quit ..msgNotPermitted

	If ..sourceControlEnabled && ..IsSchemaSCReadOnly() Quit ..msgSCReadOnly

	#dim tDefinition As %List
	
	Set tMsg = ""
	Try {
		If ..sourceControlEnabled {
			Set tMsg = ..OnSchemaSave("before")
			If tMsg '= "" Quit
		}
		TSTART
		Kill $$$vaSchemaGbl(pCustomSchema, "SS", pNewSS)
		Kill $$$vaSchemaDescGbl(pCustomSchema, "SS", pNewSS)
		Kill ..%propNames
		For i=1:1:$LENGTH(pDetails, $C(5)) { 
			Set tSegment = $P(pDetails, $C(5), i) 
			Set tRequired = $P(tSegment, $C(6), 6)
			Set tRepeating = $P(tSegment, $C(6), 7)
			Set tSymbol = $S(((tRequired["C")&&(tRepeating="0")) : "?",
							 ((tRequired["R")&&(tRepeating="0")) : "!",
							 ((tRequired["O")&&(tRepeating="1")) : "*",
							 ((tRequired["R")&&(tRepeating="1")) : "+",
							 ((tRequired["C")&&(tRepeating="1")) : "&",
							 1 : "")
			Set tFields = $LB($P(tSegment,$C(6),2),
			                  tSymbol,
							  $P(tSegment, $C(6), 3),
							  $P(tSegment, $C(6), 5),
							  tRequired,
							  tRepeating, $P(tSegment, $C(6), 4))
			If (i = 1) {
				Set tDefinition = $LB(tFields)
			}
			Else {
				Set tDefinition = tDefinition _ $LB(tFields)
			}
			Set tDescription = $P(tSegment, $C(6), 1)
			Set tPropName =  ##class(EnsLib.HL7.Util.Generator).fieldDescToName(tDescription, pNewSS, i)
			Set:$I(..%propNames(tPropName))>1 tPropName=tPropName_..%propNames(tPropName) // disambiguate names
			Set:""'=tDescription $$$vaSchemaDescGbl(pCustomSchema, "SS", pNewSS, i) = tDescription
			Set $$$vaSchemaGbl(pCustomSchema, "SS", pNewSS, "names", tPropName) = i
			Set table = $P(tSegment,$C(6),8)
			Set:""'=table $$$vaSchemaGbl(pCustomSchema, "SS", pNewSS, "tables", i) = table
			Set tAltDesc = $P(tSegment, $C(6), 9)
			Set:""'=tAltDesc $$$vaSchemaDescGbl(pCustomSchema, "SS", pNewSS, i, "alt") = tAltDesc
		}
		Set $$$vaSchemaGbl(pCustomSchema, "SS", pNewSS) = tDefinition
		Set:""'=pDescription $$$vaSchemaDescGbl(pCustomSchema, "SS", pNewSS) = pDescription
		Set $$$vaSchemaGbl(pCustomSchema, "time") = $ZTS
		Set tSC = ##class(EnsLib.HL7.SchemaXML).addDefaultCategories(pCustomSchema, $$$Text("Custom Schema Editor"))
		If $$$ISERR(tSC) {
			Set tMsg = $$$FormatText($$$Text("Unable to store segment structure modifications to %1 schema due to error: %2"), pCustomSchema, $$$StatusDisplayString(tSC))
		}
		Set tSC = ##class(EnsLib.HL7.Schema).BuildCategoryMaps(pCustomSchema)
		If $$$ISERR(tSC) {
			Set tMsg = $$$FormatText($$$Text("Unable to store segment structure modifications to %1 schema due to error: %2"), pCustomSchema, $$$StatusDisplayString(tSC))
		}
		If (tMsg = "") {
			TCOMMIT
		}
		Else {
			TROLLBACK
		}
	}
	Catch ex {
		Set tMsg = $$$Text("Error encountered in creating custom segment structure: ") _ ex.AsStatus()
	}
	If ..sourceControlEnabled {
		#; Only call OnSchemaSave if not errored
		If tMsg = "" Set tMsg = ..OnSchemaSave("after")
	}
	Set tSC2 = $$$AuditModifySchema("HL7 "_pCustomSchema,"Saved segment structure "_pNewSS_$S(tMsg'="":" (ERROR)",1:""))
	Quit tMsg
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Custom Segment Structure Wizard","Ensemble")
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
	Quit $$$TextHTML("Create a new custom segment structure.")
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	return encodeURIComponent(this.retValue);
}

ClientMethod getTextString(index) [ Language = javascript ]
{
	text = document.getElementById(index)
	return text.value.toString();
}

ClientMethod getSelectString(index) [ Language = javascript ]
{
	select = document.getElementById(index);
	if (zenIsIE) {
		return select.options.item(select.selectedIndex).value;
	}
	else {
		return select.options[select.selectedIndex].value;
	}
}

/// This callback is called when the user presses the OK button.
/// If this returns false, then the action is canceled.
ClientMethod ondialogFinish(action) As %Boolean [ Language = javascript ]
{
	try {
		var name = zen('txtName').getValue().split(' ')[0];
		var isValid = zenPage.validateAll();
		if (isValid) {
			if (confirm($$$Text('Are you sure you wish to save your changes to this segment structure?'))) {
				var desc = zen('txtDesc').getValue();
				var segment = [];
				var n, index;
				for (var i=1; i <= zenPage.fieldCount; i++) {
					index = i.toString();
					var piece = document.getElementById('segPiece' + index);
					if (piece) {
						var field = [];
						field.push(zenPage.getTextString('segDesc' + index));
						//field.push(zenPage.getTextString('segProp' + index)); // will be calculated 
						field.push(zenPage.getSelectString('dataStruct' + index));
						//field.push(zenPage.getSelectString('symbol' + index)); // will be calculated
						field.push(zenPage.getTextString('repeat' + index));
						field.push(zenPage.getTextString('minLength' + index));
						field.push(zenPage.getTextString('maxLength' + index));
						field.push(zenPage.getSelectString('required' + index));
						field.push(zenPage.getSelectString('repeating' + index));
						field.push(zenPage.getSelectString('codeTable' + index));
						field.push(zenPage.getTextString('segAlt' + index));
						n = parseInt(piece.value); // n is between 1 and currentFields, inclusive
						segment[n - 1] = field.join('\u0006');
					}
				}
 				var details = segment.join('\u0005');
				var msg = zenPage.OnWizardCompletion(zenPage.category, name, desc, details);
				if (msg != '') {
					alert(msg);
					isValid = false;
				}
			}
		}
	}
	catch(ex) {
		alert("exception: name: " + ex.name + " message: " + ex.message);
		zenExceptionHandler(ex,arguments);
		isValid = false;
	}

	this.retValue = [];
	if (isValid) {
		// set up for redisplaying the page
		if ((zenPage.caseType == "newFromSchemaMain") || (zenPage.caseType == "copyFromSchemaMain")) {
			this.retValue = zenPage.category;
		}
		else {
			this.retValue = "SS:" + zenPage.category + ":" + name; 
		}
		return true;
	}
	else {
		this.retValue = "";
		return false;
	}
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	Quit:$$$ISERR(tSC)
		
	Set %page.fieldCount = 0
	Set %page.currentFields = 0
	
	// Get values for later use in defining comboboxes on the client side
	Set %page.chooseDS = ..GetValueList(..category, "EnsLib.HL7.Schema:DataStructures", "DataStruct", 1)
	Set %page.chooseCT = ..GetValueList(..category, "EnsLib.HL7.Schema:CodeTables", "CodeTable", 1)
	
	If (..caseType = "newORcopy") {
		Set label = ..%GetComponentById("schemaLabel")
		Set label.label = $$$FormatText($$$Text("Custom Schema Category %1"), ..category)
	
		Set label = ..%GetComponentById("baseLabel")
		Set label.label = $$$FormatText($$$Text("Base Schema Category %1"), ..baseSchema)
		
		Set selCopy = ..%GetComponentById("copySegName")
		Do ..SetUpSchemaComboboxList(selCopy, ..category, "EnsLib.HL7.Message:EnumerateSegTypes", "SegType", 0)
		Set selCopy.hidden = 0
	}
	ElseIf (..caseType [ "new") {
		Set label = ..%GetComponentById("schemaLabel")
		Set label.label = $$$FormatText($$$Text("Custom Schema Category %1"), ..category)
	
		Set label = ..%GetComponentById("baseLabel")
		Set label.label = $$$FormatText($$$Text("Base Schema Category %1"), ..baseSchema)
	
		Set tControl = %page.%GetComponentById("copySegName")
		Set tControl.hidden = 1
	}
	ElseIf (..caseType = "edit") {
		Set label = ..%GetComponentById("schemaLabel")
		Set label.label = $$$FormatText($$$Text("Custom Schema Category %1"), ..category)
	
		If (""=..baseSchema) {
			Set ..baseSchema = ##class(EnsPortal.HL7.Utils).GetImmediateBaseSchema(..category)
			Set tControl = %page.%GetComponentById("baseLabel")
			If (""=..baseSchema) {
				Set tControl.label = $$$Text("Base Schema Category (none)")
			}
			Else {
				Set tControl.label = $$$FormatText($$$Text("Base Schema Category %1"), ..baseSchema) 
			}
		}
		Else {
			Set tControl.label = $$$FormatText($$$Text("Base Schema Category %1"), ..baseSchema) 
		}
		
		Set tControl = %page.%GetComponentById("copySegName")
		Set tControl.hidden = 1
		
		Set txtName = ..%GetComponentById("txtName")
		Set txtName.value = ..customSeg
		Set txtName.label = "Segment Structure Name"
		Set txtName.title = "This is the name of the segment structure being edited."
		Set txtName.readOnly = 1
		Set txtName.disabled = 1

		Set tControl = %page.%GetComponentById("txtDesc")
		Set tControl.value = $G($$$vaSchemaDescGbl(..category, "SS", ..customSeg))
		
		Do ..PopulateSegmentFieldsFromSchema(..category, ..customSeg)
	}
	ElseIf (..caseType [ "copy") {
		Set label = ..%GetComponentById("schemaLabel")
		Set label.label = $$$FormatText($$$Text("Custom Schema Category %1"), ..category)
	
		Set label = ..%GetComponentById("baseLabel")
		Set label.label = $$$FormatText($$$Text("Base Schema Category %1"), ..baseSchema)
	
		Set selCopy = ..%GetComponentById("copySegName")
		Do ..SetUpSchemaComboboxList(selCopy, ..category, "EnsLib.HL7.Message:EnumerateSegTypes", "SegType", 0)
		Set selCopy.hidden = 0
		
		Set tControl = %page.%GetComponentById("txtName")
		Set tControl.hidden = 1
		
		Set tControl = %page.%GetComponentById("txtDesc")
		Set tControl.hidden = 1
		
		Set tControl = %page.%GetComponentById("txtSubFields")
		Set tControl.hidden = 1
		
		Set tControl = %page.%GetComponentById("subFields")
		Set tControl.hidden = 1
	}
	
	Quit $$$OK
}

Method GetValueList(pCategory As %String, pQuery As %String, pColumn As %String, pBlankChoice As %Boolean) As %String
{
	Set tMsg = ""
	Set tList = ##class(EnsPortal.HL7.Utils).GetSchemaInheritanceList(pCategory)
	Set tRS = ##class(%ResultSet).%New(pQuery)
	Do tRS.Execute()
	While (tRS.Next()) {
		Set tDoc = tRS.Data(pColumn)
		Set tPrefix = $P(tDoc, ":", 1)
		Set tName = $P(tDoc, ":", 2)
		Set foundNew = 0
		For i=1:1:$L(tList, ",") {
			If (foundNew)  Quit
			If (tPrefix = $P(tList, ",", i)) { // see if the prefix indicates a schema we are interested in
				Set foundNew = 1
				Set indexNew = i
				If ($D(tArray(tName))) { // there is an existing entry for this message type
					Set foundOld = 0
					For j=1:1:$L(tList, ",") { // see if we want to replace an existing entry with this new one
						If (foundOld) Quit
						If ($G(tArray(tName)) = $P(tList, ",", j)) {
							Set foundOld = 1
							Set indexOld = j
						}
					}
					If (indexOld > indexNew) { // use the more "custom" custom schema in the hierarchy
						Set tArray(tName) = tPrefix
					}
				}
				Else { // there was no existing entry so use this one
					Set tArray(tName) = tPrefix
				}
			}
		}
	}
	Set tNext = ""
	For { 
		Set tNext = $O(tArray(tNext), 1, tValue)  Quit:tNext=""
		// Set tMsg = tMsg _ $S(tMsg="":"",1:",") _ tNext _ " (" _ tValue _ ")" 
		Set tMsg = tMsg _ $S(tMsg="":"",1:",") _ tNext 
	}
	If ((pBlankChoice) && (""'=tMsg)) {
		Set tMsg = "," _ tMsg
	}
	Quit tMsg
}

Method SetUpSchemaComboboxList(pCombo As %ZEN.Component.combobox, pCategory As %String, pQuery As %String, pColumn As %String, pBlankChoice As %Boolean)
{
	Try {
		Set tList = ##class(EnsPortal.HL7.Utils).GetSchemaInheritanceList(pCategory)
		Set tRS = ##class(%ResultSet).%New(pQuery)
		Do tRS.Execute("", 0, 0)
		While (tRS.Next()) {
			Set tDoc = tRS.Data(pColumn)
			Set tPrefix = $P(tDoc, ":", 1)
			Set tName = $P(tDoc, ":", 2)
			Set foundNew = 0
			For i=1:1:$L(tList, ",") {
				If (foundNew)  Quit
				If (tPrefix = $P(tList, ",", i)) { // see if the prefix indicates a schema we are interested in
					Set foundNew = 1
					Set indexNew = i
					If ($D(tArray(tName))) { // there is an existing entry for this message type
						Set foundOld = 0
						For j=1:1:$L(tList, ",") { // see if we want to replace an existing entry with this new one
							If (foundOld) Quit
							If ($G(tArray(tName)) = $P(tList, ",", j)) {
								Set foundOld = 1
								Set indexOld = j
							}
						}
						If (indexOld > indexNew) { // use the more "custom" custom schema in the hierarchy
							Set tArray(tName) = tPrefix
						}
					}
					Else { // there was no existing entry so use this one
						Set tArray(tName) = tPrefix
					}
				}
			}
		}
		If (pBlankChoice) {
			Set tOption = ##class(%ZEN.Auxiliary.option).%New()
			Do pCombo.options.Insert(tOption)
			Do ..%AddComponent(tOption)
			Set tOption.text = "" 
			Set tOption.value = ""
		}
		Set tNext = ""
		For { 
			Set tNext = $O(tArray(tNext), 1, tValue)  Quit:tNext=""
			Set tOption = ##class(%ZEN.Auxiliary.option).%New()
			Do pCombo.options.Insert(tOption)
			Do ..%AddComponent(tOption)
			Set tOption.text = tNext _ " (" _ tValue _ ")" 
			Set tOption.value = tNext _ " (" _ tValue _ ")"
		}
	}
	Catch (ex) {
	}
	Quit
}

Method PopulateSegmentFieldsFromSchema(pCategory As %String, pSegStruct As %String) As %String
{
	Try {
		Set tString = ""
		Kill names Set name="" For { Set name=$O($$$vaSchemaGbl(pCategory,"SS",pSegStruct,"names",name))  Quit:name=""
			Set names($$$vaSchemaGbl(pCategory,"SS",pSegStruct,"names",name))=name
		}
		Set tDefinition = $G($$$vaSchemaGbl(pCategory, "SS", pSegStruct))
		For i=1:1:$LL(tDefinition) { 
			Continue:'$LD(tDefinition, i)
			Set tDescription =   ..EscapeHTML($G($$$vaSchemaDescGbl(pCategory, "SS", pSegStruct, i)))
			Set tPropertyName =  names(i)
			Set tDataStruct = 	 $LG($LI(tDefinition, i), 1)
			Set tSymbol = 	  	 $LG($LI(tDefinition, i), 2)
			Set tCount = 	  	 $LG($LI(tDefinition, i), 3)
			Set tMinLength = 	 $LG($LI(tDefinition, i), 7)
			Set tMaxLength =	 $LG($LI(tDefinition, i), 4)
			Set tRequired =   	 $LG($LI(tDefinition, i), 5)
			Set tRepeating =  	 $LG($LI(tDefinition, i), 6)
			Set tCodeTable = 	 $G($$$vaSchemaGbl(pCategory, "SS", pSegStruct, "tables", i))
			Set tAltDesc =		 ..EscapeHTML($G($$$vaSchemaDescGbl(pCategory, "SS", pSegStruct, i, "alt")))
			Set tString = tString _ $S(tString="":"",1:$C(5)) _ 
						  tDescription _ $C(6) _ tPropertyName _ $C(6) _ tDataStruct _ $C(6) _
						  tSymbol _ $C(6) _ tCount _ $C(6)_tMinLength_$C(6) _ tMaxLength _ $C(6) _
						  tRequired _ $C(6) _ tRepeating _ $C(6) _ tCodeTable _ $C(6) _ tAltDesc 
		}
		Set tString = $G($$$vaSchemaDescGbl(pCategory, "SS", pSegStruct),"") _ $C(5) _ tString // get the description
		Set %page.incomingData = tString
	}
	Catch (ex) {
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

/// This callback, if defined, is called when the user presses the Cancel button.
/// If this returns false, then the dialog is not cancelled.
ClientMethod ondialogCancel() [ Language = javascript ]
{
	return (confirm($$$Text('Are you sure you wish to cancel all your work on this segment structure?')));
}

/// Callback to return a list of resources required for a specific HyperEvent.
/// The user must have sufficient privileges on one of the resource/permission pairs
/// to be permitted to execute the hyperevent. An empty string implies the user already
/// has sufficient privileges for the ZenMethod specified in <var>pMethod</var>.
ClassMethod GetHyperEventResources(pMethod As %String = "") As %String
{
	Quit $case(pMethod,
					"OnWizardCompletion": ..#EDITRESOURCE,
					: "")
}

}
