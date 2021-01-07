/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsHL7)

/// Create a new production and add components to it.
Class EnsPortal.HL7.Dialog.CustomDataStructure Extends EnsPortal.HL7.Dialog.standardDialog [ System = 4 ]
{

Parameter APPLYBUTTON = 0;

/// User needs WRITE permissions on the %Ens_EDISchema resource to view this page.
Parameter RESOURCE = "%Ens_EDISchema:WRITE";

Parameter PAGENAME = "Custom Data Structure Wizard";

Parameter CSSINCLUDES = "ensemble/Ensemble_Wizards.css,ensemble/Ensemble_EDI.css";

/// Schema being edited
Property category As %ZEN.Datatype.string(ZENURL = "CAT");

/// Immediate base schema of the schema being edited
Property baseSchema As %ZEN.Datatype.string(ZENURL = "BASE");

/// Data structure being worked on
Property customDS As %String(ZENURL = "DS");

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
	left: 109px;
	top: 0px;
}
.segDescClass {
	width: 230px;
	font-size: 8pt;
	position: absolute;
	left: 109px;
	top: 15px;
}
.segPropLabel {
	font-size: 8pt;
	font-weight: bold;
	position: absolute;
	left: 348px;
	top: 0px;
}
.segPropClass {
	width: 230px;
	font-size: 8pt;
	position: absolute;
	left: 348px;
	top: 15px;
}
.dataStructLabel {
	font-size: 8pt;
	font-weight: bold;
	position: absolute;
	left: 587px;
	top: 0px;
}
.dataStructClass {
	width: 100px;
	font-size: 9pt;
	position: absolute;
	left: 587px;
	top: 15px;
}
.minLengthLabel {
	font-size: 8pt;
	font-weight: bold;
	position: absolute;
	left: 691px;
	top: 0px;
}
.minLengthClass {
	width: 80px;
	font-size: 8pt;
	position: absolute;
	left: 691px;
	top: 15px;
}
.maxLengthLabel {
	font-size: 8pt;
	font-weight: bold;
	position: absolute;
	left: 780px;
	top: 0px;
}
.maxLengthClass {
	width: 80px;
	font-size: 8pt;
	position: absolute;
	left: 780px;
	top: 15px;
}
.requiredLabel {
	font-size: 8pt;
	font-weight: bold;
	position: absolute;
	left: 868px;
	top: 0px;
}
.requiredClass {
	width: 80px;
	font-size: 9pt;
	position: absolute;
	left: 868px;
	top: 15px;
}
.codeTableLabel {
	font-size: 8pt;
	font-weight: bold;
	position: absolute;
	left: 951px;
	top: 0px;
}
.codeTableClass {
	width: 100px;
	font-size: 9pt;
	position: absolute;
	left: 951px;
	top: 15px;
}
.segAltLabel {
	font-size: 8pt;
	font-weight: bold;
	position: absolute;
	left: 1055px;
	top: 0px;
}
.segAltClass {
	width: 230px;
	font-size: 8pt;
	position: absolute;
	left: 1055px;
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
<combobox id="copyDSName" name="copyDSName" label="Data Structure to Copy" editable="false" 
    enclosingStyle="padding-bottom:4px;" size="47" labelClass="labelRequired" required="true" hidden="false"
	title="Choose a data structure to copy." onchange="zenPage.chooseCopyDS();"
/>
<text label="New Data Structure Name" name="txtName" id="txtName" labelClass="labelRequired" value="" size="50"
   hidden="false"
	title="Enter a data structure name in this field. Do not use any whitespace characters, or any punctuation characters including _ (underscore) or . (period) in the name. There is no need to provide a schema name with the data structure name; the data structure will be created in the current custom schema." />
<text label="Description" name="txtDesc" id="txtDesc" labelClass="labelRequired" size="80" />
<label id="txtSubFields" enclosingClass="labelRequired" labelStyle="color:black;"  label="Data Structure Fields"></label>
<spacer height="10" />
<group id="subFields" layout="none" valign="top" labelPosition="top" 
      enclosingStyle="position:relative;top:0px;left:0px;width:1298px;height:50px;" >
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

ClientMethod chooseCopyDS() [ Language = javascript ]
{
	try {
		copyStruct = zen('copyDSName').getValue();
		if ((copyStruct.length > 0) && (copyStruct.match(' ') == ' ')) {
			if (this._lineArray) {
				zenPage.deleteAllGroups();
			}
			var temp = copyStruct.split(' ');
			var copyDSSchema = temp[1].substring(1, temp[1].length - 1);
			var copyDSName = temp[0];
			temp = zenPage.GetDataStructUpdateFromServer(copyDSSchema, copyDSName);
			var value = temp.split('\u0005'); 
			zen('txtName').setHidden(false); // leave the new name blank
			var desc = zen('txtDesc');
			desc.setValue(value[0]); // use the description
			desc.setHidden(false);
			zen('txtSubFields').setHidden(false); // show the fields header
			zen('subFields').setHidden(false); // show the fields information
			zenPage.addAllGroups(value); // use the fields information
		}
		else {
			alert('Please choose a data structure to copy.');
		}
	}
	catch (ex) {
		alert('Exception in chooseCopyDS: ' + ex.description + ' Details: ' + ex.extMessage);
	}
}

/// Get all the necessary data about the data structure from the server in one call.
Method GetDataStructUpdateFromServer(pSchema As %String, pDataStruct As %String) As %String [ ZenMethod ]
{
	Set tMsg = ""
	Try {
		Set tMsg = ..PopulateDataFieldsFromSchema(pSchema, pDataStruct) // get all the fields and description
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
		
		var newGroup = self.document.createElement('div');
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
				  'title="' + $$$Text("Click to delete the field from the data structure definition.") + '"/>');
				  
		html.push('<span class="segPieceLabel">' + $$$Text("Field") + '</span>');
		html.push('<input id="segPiece' + key.toString() + '" class="segPieceClass" readonly="readonly" disabled="disabled" ' +
		          'title="' + $$$Text("This is a number indicating the order of the field in the data structure") + '"/>');
		          
		html.push('<span class="segDescLabel">' + $$$Text("Description") + '</span>');
		html.push('<input id="segDesc' + key.toString() + '" class="segDescClass" ' + 
				  'title="' + $$$Text("Enter a text description"));
		if (incomingData) html.push('" value="' + value[0] + '"/>');
		else html.push('"/>');
	
		html.push('<span class="segPropLabel">' + $$$Text("Property Name") + '</span>');
		html.push('<input id="segProp' + key.toString() + '" class="segPropClass" readonly="readonly" disabled="disabled" ' +
		          'title="' + $$$Text("This is the name of the property corresponding to this data structure field; it will be calculated after you save your work"));
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
		
		html.push('<span class="minLengthLabel">' + $$$Text("Min Length") + '</span>');
		html.push('<input id="minLength' + key.toString() + '" class="minLengthClass" ' + 
				  'title="' + $$$Text("Enter a minimum number of characters"));
		if (incomingData) html.push('" value="' + value[3] + '"/>');
		else html.push('"/>');
		
		html.push('<span class="maxLengthLabel">' + $$$Text("Max Length") + '</span>');
		html.push('<input id="maxLength' + key.toString() + '" class="maxLengthClass" ' + 
				  'title="' + $$$Text("Enter a maximum number of characters"));
		if (incomingData) html.push('" value="' + value[4] + '"/>');
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
			newVal = value[5];
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
		
		
		
		html.push('<span class="codeTableLabel">' + $$$Text("Code Table") + '</span>');
		html.push('<select id="codeTable' + key.toString() + '" class="codeTableClass" ' +
				  'title="' + $$$Text("Choose a code table, or choose blank") + '">');
		var choose = zenPage.chooseCT.split(','); // the blank option is included as the first item in this list
		if (incomingData) {
			newVal = value[6];
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
		if (incomingData) html.push('" value="' + value[7] + '"/>');
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
	else alert('Unable to delete field from the data structure.');
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

	// validate the copy data structure if it is there
	if (zenPage.caseType.match('copy') == 'copy') {
		temp = zen('copyDSName').getValue();
		if (temp.length <= 0) {
			finalMsg += ('  ' + $$$Text("You must choose a data structure to copy.") + '\n');
			ok = false;
		}
	}

	if (ok) {
		
		// validate the new data structure name
		var name = zen('txtName').getValue();
		var temp = name.replace(/\s/g, "");	
		temp = temp.replace(/\t/g, "");
		if (temp.length != name.length) {
			name = temp;
			zen('txtName').setValue(name);
		}
		// separate out the data structure schema and name, if a schema is provided to mimic our drop-downs
		var DSName = zenPage.sortOutEntityName(name, $$$Text("Too many space characters in the data structure name."));

		// run through validation of the usual name issues
		var len = DSName.length;
		if (len <= 0) {
			finalMsg += ('  ' + $$$Text("You have not entered a new data structure name."));
			finalMsg += (' ' + $$$Text("For the new data structure name, do not use any whitespace characters, or any punctuation characters other than _ (underscore) or . (period).") + '\n');
			ok = false;
		}
		else {
			if (DSName.match(/[`~@#$%^&*()-+={}\[\]|\\:;"'<,>?\/]/) || DSName.match(/\s/) || DSName.match(/\t/)) {
				finalMsg += ('  ' +  $$$Text("For the new data structure name, do not use any whitespace characters, or any punctuation characters other than _ (underscore) or . (period).") + '\n');
				ok = false;
			}
			else {
				// does the proposed new message type already exist in the schema?
				var exists = zenPage.GetValidationDataFromServer(zenPage.category, DSName);
				if (exists == "1") {
					if ((zenPage.caseType == "newFromSchemaMain") || (zenPage.caseType == "copyFromSchemaMain")) { 
						finalMsg += ('  ' + $$$FormatText($$$Text("The specified new data structure %2 already exists in the custom schema %1. If you want to create a new data structure, use a different name."), zenPage.category, DSName));
						finalMsg += (' ' + $$$FormatText($$$Text("If you want to edit the data structure %1, dismiss this message, click Cancel in this dialog, click through to the data structure description, and click Edit."), DSName) + '\n');
						ok = false;
					}
				}
			}
		}

		// validate the fields for each data structure
		if (zenPage.currentFields == 0) {
			finalMsg += ('  ' + $$$Text("There are no fields to save.") + '\n');
			ok = false;
		}
		else {
			var n, index;
			var fieldPresent = [];
			var descPtr;
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
				//validate that field has a description
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
				//validate that min length, if present, is a number
				count = document.getElementById('minLength' + index).value;
				if ((count.toString().length > 0) && (isNaN(count))) {
					finalMsg += ('  ' + $$$FormatText($$$Text("Field %1 min length is not a number."), i) + '\n');
					ok = false;
				}
				//validate that max length, if present, is a number
				count = document.getElementById('maxLength' + index).value;
				if ((count.toString().length > 0) && (isNaN(count))) {
					finalMsg += ('  ' + $$$FormatText($$$Text("Field %1 max length is not a number."), i) + '\n');
					ok = false;
				}
				//validate that min length is not greater than max length
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
/// <is pNewDS existing in pCustomSchema>
ClassMethod GetValidationDataFromServer(pCustomSchema As %String, pNewDS As %String) As %String [ ZenMethod ]
{
	Set tMsg = ""
	Try {
		Set tMsg = ##class(EnsPortal.HL7.Utils).SchemaEntityAlreadyExists(pCustomSchema, pNewDS, "DT")
	}
	Catch (ex) {
	}
	Quit tMsg
}

/// This method is invoked when the user completes the Wizard pressing "OK".
/// Returns a null string if it succeeds, or an error message otherwise.
Method OnWizardCompletion(pCustomSchema As %String, pNewDS As %String, pDescription As %String, pDetails As %String) As %String [ ZenMethod ]
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
		Kill $$$vaSchemaGbl(pCustomSchema, "DS", pNewDS)
		Kill $$$vaSchemaDescGbl(pCustomSchema, "DS", pNewDS)
		Kill $$$vaSchemaGbl(pCustomSchema, "DT", pNewDS)
		Kill $$$vaSchemaDescGbl(pCustomSchema, "DT", pNewDS)
		Kill ..%propNames
		Set tDefinition = ""
		For i=1:1:$LENGTH(pDetails, $C(5)) {
			Set tData = $P(pDetails, $C(5), i) 
			Set tDatStruct = $P(tData, $C(6), 2)
			Set tMinLen = $P(tData, $C(6),3)
			Set tMaxLen = $P(tData, $C(6),4)
			Set tOpt = $P(tData, $C(6), 5)
			Set tField = $LB(tDatStruct, tMinLen, tMaxLen, tOpt)
			Set tDefinition = tDefinition _ $LB(tField)
			Set tDescription = $P(tData, $C(6), 1)
			Set tPropName =  ##class(EnsLib.HL7.Util.Generator).componentDescToName(tDescription, pNewDS, i)
			Set:$I(..%propNames(tPropName))>1 tPropName=tPropName_..%propNames(tPropName) // disambiguate names
			Set $$$vaSchemaDescGbl(pCustomSchema, "DT", pNewDS, i) = tDescription
			Set $$$vaSchemaGbl(pCustomSchema, "DT", pNewDS, "names", tPropName) = i
			Set table = $P(tData, $C(6), 6)
			Set:""'=table $$$vaSchemaGbl(pCustomSchema, "DT", pNewDS, "tables", i) = table
			Set tAltDesc = $P(tData, $C(6), 7)
			Set:""'=tAltDesc $$$vaSchemaDescGbl(pCustomSchema, "DT", pNewDS, i, "alt") = tAltDesc
		}
		Set $$$vaSchemaGbl(pCustomSchema, "DT", pNewDS) = tDefinition
		Set $$$vaSchemaDescGbl(pCustomSchema, "DT", pNewDS) = pDescription
		Set $$$vaSchemaGbl(pCustomSchema, "time") = $ZTS
		Set tSC = ##class(EnsLib.HL7.SchemaXML).addDefaultCategories(pCustomSchema, $$$Text("Custom Schema Editor"))
		If $$$ISERR(tSC) {
			Set tMsg = $$$FormatText($$$Text("Unable to store data structure modifications to %1 schema due to error: %2"), pCustomSchema, $$$StatusDisplayString(tSC))
		}
		Set tSC = ##class(EnsLib.HL7.Schema).BuildCategoryMaps(pCustomSchema)
		If $$$ISERR(tSC) {
			Set tMsg = $$$FormatText($$$Text("Unable to store data structure modifications to %1 schema due to error: %2"), pCustomSchema, $$$StatusDisplayString(tSC))
		}
		If (tMsg = "") {
			TCOMMIT
		}
		Else {
			TROLLBACK
		}
	}
	Catch ex {
		Set tMsg = $$$Text("Error encountered in creating custom data structure: ") _ ex.AsStatus()
	}
	If ..sourceControlEnabled {
		#; Only call OnSchemaSave if not errored
		If tMsg = "" Set tMsg = ..OnSchemaSave("after")
	}
	Set tSC2 = $$$AuditModifySchema("HL7 "_pCustomSchema,"Saved data structure "_pNewDS_$S(tMsg'="":" (ERROR)",1:""))
	Quit tMsg
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Custom Data Structure Wizard","Ensemble")
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
	Quit $$$TextHTML("Create a new custom data structure.")
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
			if (confirm($$$Text('Are you sure you wish to save your changes to this data structure?'))) {
				var desc = zen('txtDesc').getValue();
				var dataStruct = [];
				var n, index;
				for (var i=1; i <= zenPage.fieldCount; i++) {
					index = i.toString();
					var piece = document.getElementById('segPiece' + index);
					if (piece) {
						var field = [];
						field.push(zenPage.getTextString('segDesc' + index));
						//field.push(zenPage.getTextString('segProp' + index)); // will be calculated 
						field.push(zenPage.getSelectString('dataStruct' + index));
						field.push(zenPage.getTextString('minLength' + index));
						field.push(zenPage.getTextString('maxLength' + index));
						field.push(zenPage.getSelectString('required' + index));
						field.push(zenPage.getSelectString('codeTable' + index));
						field.push(zenPage.getTextString('segAlt' + index));
						n = parseInt(piece.value); // n is between 1 and currentFields, inclusive
						dataStruct[n - 1] = field.join('\u0006');
					}
				}
				var details = dataStruct.join('\u0005');
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
			this.retValue = "DS:" + zenPage.category + ":" + name; 
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
	
	If (..caseType = "newFromSchemaMain") {
		Set label = ..%GetComponentById("schemaLabel")
		Set label.label = $$$FormatText($$$Text("Custom Schema Category %1"), ..category)
	
		Set label = ..%GetComponentById("baseLabel")
		Set label.label = $$$FormatText($$$Text("Base Schema Category %1"), ..baseSchema)
	
		Set tControl = %page.%GetComponentById("copyDSName")
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
		
		Set tControl = %page.%GetComponentById("copyDSName")
		Set tControl.hidden = 1
		
		Set txtName = ..%GetComponentById("txtName")
		Set txtName.value = ..customDS
		Set txtName.label = "Data Structure Name"
		Set txtName.title = "This is the name of the data structure being edited."
		Set txtName.readOnly = 1
		Set txtName.disabled = 1

		Set tControl = %page.%GetComponentById("txtDesc")
		Set node = "DS"
		Set:($D($$$vaSchemaDescGbl(..category, "DT", ..customDS))) node = "DT"
		Set tControl.value = $$$vaSchemaDescGbl(..category, node, ..customDS)
		
		Do ..PopulateDataFieldsFromSchema(..category, ..customDS)
	}
	ElseIf (..caseType = "copyFromSchemaMain") {
		Set label = ..%GetComponentById("schemaLabel")
		Set label.label = $$$FormatText($$$Text("Custom Schema Category %1"), ..category)
	
		Set label = ..%GetComponentById("baseLabel")
		Set label.label = $$$FormatText($$$Text("Base Schema Category %1"), ..baseSchema)
	
		Set selCopy = ..%GetComponentById("copyDSName")
		Do ..SetUpSchemaComboboxList(selCopy, ..category, "EnsLib.HL7.Schema:DataStructures", "DataStruct", 0)
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
		Do tRS.Execute("", 0)
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

Method PopulateDataFieldsFromSchema(pCategory As %String, pDataStruct As %String) As %String
{
	Try {
		Set tString = ""
		Set node = "DS"
		Set:($D($$$vaSchemaGbl(pCategory,"DT",pDataStruct))) node = "DT"
		Kill names Set name="" For { Set name=$O($$$vaSchemaGbl(pCategory,node,pDataStruct,"names",name))  Quit:name=""
			Set names($$$vaSchemaGbl(pCategory,node,pDataStruct,"names",name))=name
		}
		Set tDefinition = $G($$$vaSchemaGbl(pCategory, node, pDataStruct))
		for i=1:1:$LL(tDefinition) { 
			Set tDescription =   ..EscapeHTML($G($$$vaSchemaDescGbl(pCategory, node, pDataStruct, i)))
			Set tPropertyName =  names(i)
			Set:(node = "DS") tDataStruct =  $LG(tDefinition, i) , tMinLength = "", tMaxLength = "", tReq = ""
			Set:(node = "DT") tDataStruct=$LG($LG(tDefinition, i), 1), tMinLength=$LG($LG(tDefinition,i),2), tMaxLength=$LG($LG(tDefinition,i),3), tReq=$LG($LG(tDefinition,i),4)
			Set tCodeTable = 	 $G($$$vaSchemaGbl(pCategory, node, pDataStruct, "tables", i))
			Set tAltDesc =		 ..EscapeHTML($G($$$vaSchemaDescGbl(pCategory, node, pDataStruct, i, "alt")))
			Set tString = tString _ $S(tString="":"",1:$C(5)) _ 
						  tDescription _ $C(6) _ tPropertyName _ $C(6) _ tDataStruct _ $C(6) _ tMinLength _ $C(6) _ tMaxLength _ $C(6) _
						  tReq _ $C(6) _ tCodeTable _ $C(6) _ tAltDesc 
		}
		Set tString = $G($$$vaSchemaDescGbl(pCategory, node, pDataStruct),"") _ $C(5) _ tString // get the description
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
	return (confirm($$$Text('Are you sure you wish to cancel all your work on this data structure?')));
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
