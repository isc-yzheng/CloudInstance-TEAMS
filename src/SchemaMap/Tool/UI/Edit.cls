Include SchemaMap

/// Dialog for viewing or editing the from:to mappings for a specific "from" path
/// to paths in the current "to" schema. The input PAIR value specifies from and to.
Class SchemaMap.Tool.UI.Edit Extends %ZEN.Dialog.standardDialog
{

Parameter RESOURCE = "%Ens_EDISchemaAnnotations:READ";

Parameter APPLYBUTTON = 1;

Property EditEnabled As %Boolean;

Property Path As %String(ZENURL = "PATH");

Property Row As %String(ZENURL = "ROW");

Property Resource As %String;

Property Element As %String;

/// The "likely" values are used by the UI to pre-populate choices in select drop-downs in an intuitive way.
Property LikelyResource As %String;

/// The "likely" values are used by the UI to pre-populate choices in select drop-downs in an intuitive way.
Property LikelyElement As %String;

Property FromType As %String;

Property FromCard As %String;

Property FromIsObject As %String;

Property InverseOld As %String;

Property InverseRow As %String;

Property ToPath As %String;

Property ToXF As %String;

Property SourceXF As %String;

Property ToIssues As %String;

Property ToNotes As %String;

Property DefaultValue As %String;

Property SubTransform As %String;

Property ClassMethod As %String;

Property Extension As %String;

Property SourceValue As %String(ZENURL = "VALUE");

Property MapSource As %ZEN.Datatype.boolean(ZENURL = "SOURCE");

Property DependsOn As %String;

Property Append As %Boolean;

Property ExcludeList As %String;

Property Pair As %String(ZENURL = "PAIR");

Property From As %String;

Property To As %String;

/// Contents of the dialog body.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" >
<spacer height="15px"/>
<hgroup valign="top">
<spacer width="20px"/>
<vgroup valign="top">
<html id="fromField" valign="top" OnDrawContent="DrawTypeDetails" seed="" />
<hgroup valign="top">
<vgroup valign="top">
<html id="listTo" valign="top" OnDrawContent="DrawTo" seed="" />
<html id="listToFields" valign="top" OnDrawContent="DrawToFields" seed="" />
</vgroup>
<spacer width="50px"/>
<vgroup valign="top">
<html id="listToMulti" valign="top" OnDrawContent="DrawToMulti" seed="" />
</vgroup>
</hgroup>
<html id="mappingFields" valign="top" OnDrawContent="DrawMapping" seed="" />
</vgroup>
<spacer width="20px"/>
</hgroup>
<spacer height="15px"/>
</pane>
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
}

/// Finds the mapping entry for any non-empty ..Row value;
/// when ..Row is empty, finds the first mapping entry for the current ..Path;
/// in either case, populates all the class properties for the Zen dialog
Method GetCurrentValues() As %Status
{
}

Method DrawTypeDetails(seed As %String) As %Status
{
}

Method DrawToMulti(seed As %String) As %Status
{
}

Method DrawMapping(seed As %String) As %Status
{
}

Method DrawTo(seed As %String) As %Status
{
}

Method DrawToFields(seed As %String) As %Status
{
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	return this.returnValue;
}

/// This callback, if defined, is called when the user presses the OK or Apply action buttons.
/// If this returns false, then the action is cancelled.<br>
ClientMethod ondialogFinish(action) As %Boolean [ Language = javascript ]
{
	if (!zenPage.EditEnabled) {
		this.returnValue = { };
		return true;
	}
	var msg = ""
	var input = self.document.getElementById('MappingText');
	if (input) {
		// get the values
		var target = zenPage.strip(input.value);
		var toXF = zenPage.strip(self.document.getElementById('TargetTransform').value);
		if (target.length > 0 && toXF.length === 0) {
			toXF = zenPage.GetAncestorTransformDefault(zenPage.Path, target, 'target');
		}
		var sourceXF = zenPage.strip(self.document.getElementById('SourceTransform').value);
		if (sourceXF.length === 0) {
			sourceXF = zenPage.GetAncestorTransformDefault(zenPage.Path, target, 'source');
		}
		var srcVal = zenPage.undoSmartTyping(zenPage.strip(self.document.getElementById('SourceValue').value));
		var defVal = zenPage.undoSmartTyping(zenPage.strip(self.document.getElementById('DefaultValue').value));
		var subXF = zenPage.undoSmartTyping(zenPage.strip(self.document.getElementById('SubTransform').value));
		var util = zenPage.undoSmartTyping(zenPage.strip(self.document.getElementById('ClassMethod').value));
		var dependsOn = zenPage.undoSmartTyping(zenPage.strip(self.document.getElementById('DependsOn').value));
		var extn = zenPage.undoSmartTyping(zenPage.strip(self.document.getElementById('Extension').value));
		var notes = zenPage.undoSmartTyping(zenPage.strip(self.document.getElementById('MapNotes').value));
		var check = self.document.getElementById('Append');
		var append = (check && check.checked);
		var exclude = '';
		check = self.document.getElementById('ExcludeODS');
		if (check && check.checked) {
			exclude += 'ODS';
		}
		check = self.document.getElementById('ExcludeHC');
		if (check && check.checked) {
			if (exclude.length > 0) {
				exclude += ',';
			}
			exclude += 'HC';
		}
		check = self.document.getElementById('ApplyAllTargetTransform');
		var applyAllToXF = (check && check.checked);
		
		// final validation before save
		// MAINTENANCE NOTE: checking every field is not necessary, but stopping obvious, predictable errors saves time
		//alert('ondialogFinish calling getValidationMessage: target=' + target + ', srcVal=' + srcVal + ', toXF=' + toXF + ', sourceXF=' + sourceXF + ', defVal=' + defVal + ', subXF=' + subXF + ', util=' + util + ', dependsOn='+ dependsOn + ', extn=' + extn);
		msg = zenPage.getValidationMessage(target, srcVal, toXF, sourceXF, defVal, subXF, util, dependsOn, extn);
		// only validate applyAllToXF here, in ondialogFinish; prepend the resulting message to any other validation messages
		if (applyAllToXF && toXF.length === 0) {
			msg = "If you want to apply a Target Transformation to all mapping targets for this source, it must not be empty.\n" + msg;
		}
		// only validate SourceValue here, in ondialogFinish; prepend the resulting message to any other validation messages
		if (zenPage.MapSource && srcVal.length === 0) {
			msg = "If you want to define a mapping from a Source Value to a target, the Source Value must not be empty.\n" + msg;
		}
		if (msg.length > 0) {
			alert(msg);
			return false;
		}
		if (target.indexOf(':RESOURCEONLY') >= 0) {
			target = target.split(':')[0];
		}
		
		// complete the save
		this.returnValue = { 
			path:zenPage.Path, mapSource:zenPage.MapSource, row:zenPage.Row, column:"TargetPath", target:target, 
			toXF:toXF, sourceXF:sourceXF, srcVal:srcVal, util:util, subXF:subXF, defVal:defVal, dependsOn:dependsOn, extn:extn, notes:notes,
			append:append, exclude:exclude, applyAllToXF:applyAllToXF
			};
			
		// for the Apply action, prepare to redisplay UI.Edit
		zenPage.ToPath = target; // chooseFromPath() in dialogApply() needs this value to be set
		zenPage.ToXF = toXF; // chooseFromPath() in dialogApply() needs this value to be set
		zenPage.SourceXF = sourceXF; // chooseFromPath() in dialogApply() needs this value to be set
		zenPage.SourceValue = srcVal; // chooseFromPath() in dialogApply() needs this value to be set
		
		return true;
	}
	return false;
}

ClientMethod getValidationMessage(target, srcVal, toXF, sourceXF, defVal, subXF, util, dependsOn, extn) [ Language = javascript ]
{
	// MAINTENANCE NOTE: checking every field is not necessary, but stopping obvious, predictable errors saves time
	var msg = "";
	if (typeof target === 'undefined' || 
		typeof srcVal === 'undefined' || 
		typeof toXF === 'undefined' || 
		typeof sourceXF === 'undefined' || 
		typeof defVal === 'undefined' || 
		typeof subXF === 'undefined' || 
		typeof util === 'undefined' || 
		typeof dependsOn === 'undefined' || 
		typeof extn === 'undefined'
		) {
		msg += "The field-to-field mapping detail dialog has experienced an unexpected internal error.\n";
		return;
	}
	
	// messages regarding source and target transformations: revert and return as soon as there is an issue
	
	if ((zenPage.Path.length > 0) && (target.length > 0)) {
		if (toXF.length > 0) {
			msg = zenPage.GetAncestorTransformMessage(target, toXF, 'target');
			if (msg.length > 0) {
				var input = self.document.getElementById('TargetTransform');
				if (input) {
					toXF = zenPage.GetAncestorTransformDefault(zenPage.Path, target, 'target');
					input.value = toXF;
				}
				return msg;
			}
		} 
		if (sourceXF.length > 0) {
			msg = zenPage.GetAncestorTransformMessage(zenPage.Path, sourceXF, 'source');
			if (msg.length > 0) {
				var input = self.document.getElementById('SourceTransform');
				if (input) {
					sourceXF = zenPage.GetAncestorTransformDefault(zenPage.Path, target, 'source');
					input.value = sourceXF;
				}
				return msg;
			}
		}
	}
	
	// simple messages: collect all of the issues, and return them together as a group
	
	if (util.length === 0 && subXF.length === 0) {
		if (target.indexOf(':RESOURCEONLY') >= 0) {
			subXF = zenPage.GetSubTransformClassName(zenPage.Path, target.split(':')[0]);
			if (subXF.length > 0) {
				var input = self.document.getElementById('SubTransform');
				if (input) {
					input.value = subXF;
				}
			}
			else {
				msg += "When mapping to a resource generally, with no field specified, either a Class Method or a Sub-Transformation must be identified. Provide one or the other before saving.\n";
			}
		}
	}
	if (util.length > 0 && subXF.length > 0) {
		msg += "Both a Class Method and a Sub-Transformation are identified. A mapping entry cannot use both. Clear one or the other before saving.\n";
	}
	if (subXF.length > 0 && !zenPage.IsClassNameValid(subXF)) {
		msg += "The Sub-Transformation class need not exist yet, but if you enter a value in this field, you must use valid ObjectScript class name syntax.\n";
	}
	//if (util.length > 0 && !((util.indexOf('##class(') === 0 || util.indexOf('$classmethod(') === 0 || util.indexOf('$method(') === 0) && util.charAt(util.length - 1) === ')')) {
	//	msg += "A Class Method entry must be a method call using ##class() or $classmethod() or $method() and must be valid syntax for the value attribute of a DTL assign element.\n";
	//}
	return msg;
}

/// value is a colon-separated path with two parts, resource and field path,
/// but if it consists of only a resource, the method deals with that.
ClientMethod reviseToFields(value, toXF) [ Language = javascript ]
{
	// get value, toXF, resource, target

	if (typeof value === 'undefined' || value === null) {
		value = '';
	}
	if (typeof toXF === 'undefined' || toXF === null) {
		toXF = '';
	}
	var valueSeed = value;
	if (value.length === 0) {
		valueSeed = ':';
	}
	else if (value === ':') {
		value = '';
	}
	var resource = valueSeed.split(':')[0];
	var target = value;
	if (value.indexOf(':RESOURCEONLY') >= 0) {
		target = resource;
		toXF = resource;
	}

	// apply value, toXF, resource, target
	//alert('reviseToFields (after input cleanup): value=' + value + ', toXF=' + toXF + ', resource=' + resource + ', target=' + target);

	// these elements are Zen
	var select = zen('listTo'); // MAINTENANCE NOTE: zen=listTo method=DrawTo id=listToSelect
	if (select) {
		select.seed = resource;
		select.refreshContents(true);
	}
	select = zen('listToFields'); // MAINTENANCE NOTE: zen=listToFields method=DrawToFields method=GetPathsFieldsText id=listToFieldsSelect
	if (select) {
		select.seed = value;
		select.refreshContents(true);
	}
	// these elements are HTML
	var input = self.document.getElementById('TargetTransform');
	if (input) {
		if (toXF.length > 0) { // use the toXF value, if provided
			input.value = toXF;
		}
		else { // otherwise, derive the value from the target
			input.value = zenPage.GetAncestorTransformDefault(zenPage.Path, target, 'target');
		}
	}
	// now finish the rest
	zenPage.chooseToPath(value);
}

/// Replaces current mapping target text with new value, then calls validateMappingText to re-validate and re-display the mapping.
ClientMethod chooseToPath(value) [ Language = javascript ]
{
	//alert('chooseToPath: value=' + value);
	var target = self.document.getElementById('MappingText');
	if (target) {
		target.value = zenPage.strip(value);
		var fields = self.document.getElementById('listToFieldsSelect'); // MAINTENANCE NOTE: zen=listToFields method=DrawToFields method=GetPathsFieldsText id=listToFieldsSelect
		if (fields) {
			var currentField = fields.value;
			if (currentField !== value) {
				fields.value = value;
			}
		}
		zenPage.validateMappingText();
	}
}

/// Validates the current (proposed new) mapping that is visible in the UI.Edit dialog.
ClientMethod validateMappingText() [ Language = javascript ]
{
	var final = "";
	var mapping = "";
	var container = zen('mappingFields'); // MAINTENANCE NOTE: zen=mappingFields method=DrawMapping
	if (container) {
		var target = zenPage.strip(self.document.getElementById('MappingText').value);
		var toXF = zenPage.strip(self.document.getElementById('TargetTransform').value);
		var sourceXF = zenPage.strip(self.document.getElementById('SourceTransform').value);
		var srcVal = zenPage.strip(self.document.getElementById('SourceValue').value);
		var defVal = zenPage.strip(self.document.getElementById('DefaultValue').value);
		var subXF = zenPage.strip(self.document.getElementById('SubTransform').value);
		var util = zenPage.strip(self.document.getElementById('ClassMethod').value);
		var dependsOn = zenPage.strip(self.document.getElementById('DependsOn').value);
		var extn = zenPage.strip(self.document.getElementById('Extension').value);
		var notes = zenPage.strip(self.document.getElementById('MapNotes').value);
		var check = self.document.getElementById('Append');
		var append = (check && check.checked);
		var exclude = '';
		check = self.document.getElementById('ExcludeODS');
		if (check && check.checked) {
			exclude += 'ODS';
		}
		check = self.document.getElementById('ExcludeHC');
		if (check && check.checked) {
			if (exclude.length > 0) {
				exclude += ',';
			}
			exclude += 'HC';
		}
		// MAINTENANCE NOTE: checking every field is not necessary, but stopping obvious, predictable errors saves time
		//alert('validateMappingText calling getValidationMessage: target=' + target + ', srcVal=' + srcVal + ', toXF=' + toXF + ', sourceXF=' + sourceXF + ', defVal=' + defVal + ', subXF=' + subXF + ', util=' + util + ', dependsOn='+ dependsOn + ', extn=' + extn);
		msg = zenPage.getValidationMessage(target, srcVal, toXF, sourceXF, defVal, subXF, util, dependsOn, extn);
		if (msg.length > 0) {
			alert(msg);
			return;
		}
		else {
			if (target.indexOf(':RESOURCEONLY') >= 0) {
				subXF = zenPage.strip(self.document.getElementById('SubTransform').value);
			}
		}
		final = target;
		final += ('\u0002' + toXF);
		final += ('\u0002' + sourceXF);
		final += ('\u0002' + util);
		final += ('\u0002' + subXF);
		final += ('\u0002' + defVal);
		final += ('\u0002' + extn);
		final += ('\u0002' + srcVal);
		final += ('\u0002' + dependsOn);
		final += ('\u0002' + notes);
		final += ('\u0002' + ((append === true) ? '1' : '0'));
		final += ('\u0002' + exclude);
		container.seed = final;
		container.refreshContents(true);
	}
}

ClientMethod chooseFromPath(path, sourceValue, row, toPath, toXF, sourceXF) [ Language = javascript ]
{
	//alert('chooseFromPath (incoming args): path=' + path + ', sourceValue=' + sourceValue + ', row=' + row + ', toPath=' + toPath + ', toXF=' + toXF  + ', sourceXF=' + sourceXF);

	if (typeof sourceValue === 'undefined' || sourceValue === null) {
		sourceValue = "";
	}
	if (typeof row === 'undefined' || row === null) {
		row = "";
	}
	if (typeof toPath === 'undefined' || toPath === null) {
		toPath = "";
	}
	if (typeof toXF === 'undefined' || toXF === null) {
		toXF = "";
	}
	if (toXF.length === 0 && toPath.length > 0) {
		toXF = zenPage.parseLeaf(toPath);
	}
	if (typeof sourceXF === 'undefined' || sourceXF === null) {
		sourceXF = "";
	}
	if (sourceXF.length === 0) {
		sourceXF = zenPage.parseLeaf(path);
	}
	var resource = "";
	var container = self.document.getElementById('listToSelect'); // MAINTENANCE NOTE: zen=listTo method=DrawTo id=listToSelect
	if (container) {
		var index = container.selectedIndex;
		resource = (index >= 0) ? container.options[index].value : '';
	}
	
	//alert('chooseFromPath (after arg cleanup): path=' + path + ', sourceValue=' + sourceValue + ', row=' + row + ', toPath=' + toPath + ', toXF=' + toXF  + ', sourceXF=' + sourceXF + ' and resource=' + resource);

	var titleText = zenPage.SetPathValue(path, sourceValue, row, resource);
	var container = self.document.getElementsByClassName('stdTitle');
	if (container) {
		var titleDiv = container[0].getElementsByTagName('div');
		titleDiv[0].innerHTML = titleText;
	}
	
	container = zen('fromField'); // MAINTENANCE NOTE: zen=fromField method=DrawTypeDetails method=GetFieldText
	if (container) {
		// GetCurrentValues() will reset all class properties based on the path and row 
		container.seed = zenPage.From + '\u0002' + path + '\u0002' + sourceValue + '\u0002' + row + '\u0002' + toXF + '\u0002' + sourceXF;
		//alert('chooseFromPath seed input to DrawTypeDetails: ' + container.seed);
		container.refreshContents(true);
		
		// remaining calls will reset display fields using the newly reset class properties
		container = zen('listToMulti'); // MAINTENANCE NOTE: zen=listToMulti method=DrawToMulti
		if (container) {
			container.refreshContents(true);
		}
		container = zen('mappingFields'); // MAINTENANCE NOTE: zen=mappingFields method=DrawMapping
		if (container) {
			container.seed = '';
			container.refreshContents(true);
		}
		zenPage.reviseToFields(toPath, toXF);
	}
}

/// Clears all current values in mapping fields and then calls validateMappingText to re-validate.
ClientMethod clearMappingText(validate) [ Language = javascript ]
{
	if (typeof validate === 'undefined') {
		validate = true;
	}
	var container = zen('mappingFields'); // MAINTENANCE NOTE: zen=mappingFields method=DrawMapping
	if (container) {
		target = self.document.getElementById('MappingText');
		if (target) {
			target.value = "";
		}
		zenPage.reviseToFields("");
		var allInputFields = ['MapNotes', 'ClassMethod', 'SubTransform', 'DefaultValue', 'Extension', 'SourceValue', 'DependsOn', 'TargetTransform', 'SourceTransform'];
		for (var i = 0; i < allInputFields.length; i++) {
			zenPage.clearInput(allInputFields[i]);
		}
		var check = self.document.getElementById('Append');
		if (check) {
			check.checked = false;
		}
		check = self.document.getElementById('ExcludeODS');
		if (check) {
			check.checked = false;
		}
		check = self.document.getElementById('ExcludeHC');
		if (check) {
			check.checked = false;
		}
		check = self.document.getElementById('ApplyAllTargetTransform');
		if (check) {
			check.checked = false;
		}
		if (validate) {
			zenPage.validateMappingText();
		}
	}
}

ClientMethod clearInput(id, userPrompt) [ Language = javascript ]
{
	if (typeof userPrompt === 'undefined') {
		userPrompt = false;
	}
	var input = self.document.getElementById(id);
	if (input) {
		if (userPrompt && ((id === 'ClassMethod') || (id === 'SubTransform'))) {
			if (zenPage.strip(input.value).length > 0) {
				alert("If you clear a Class Method or Sub-Transformation that is an automatically assigned value, and do not replace it with new text, the automatic value will be restored when you save the mapping.");
			}
		}
		input.value = "";
	}
}

ClientMethod insertInputValue(id, value) [ Language = javascript ]
{
	var input = self.document.getElementById(id);
	if (input) {
		input.value = zenPage.strip(value);
	}
}

ClientMethod addRow(path, sourceValue) [ Language = javascript ]
{
	//alert('addRow: ' + path + ',' + sourceValue);
	var error = zenPage.CreateEmptyMappingEntry(path, sourceValue);
	if (error.length > 0) {
		alert(error);
	}
	else {
		// refresh the display of currently saved rows
		container = zen('listToMulti'); // MAINTENANCE NOTE: zen=listToMulti method=DrawToMulti
		if (container) {
			container.refreshContents(true);
		}
	}
}

ClientMethod strip(text) [ Language = javascript ]
{
	return text.replace(/^\s+|\s+$/g, "").replace(/^\t+|\t+$/g, "");
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
}

Method SetPathValue(path As %String, sourceValue As %String, row As %String, likelyResource As %String) As %String [ ZenMethod ]
{
}

/// This method creates and displays a new, empty mapping table entry for a given "from" path, 
/// after one mapping table entry already exists for that same "from" path.
/// <p>
/// Running this method creates a new row that is empty. The user edits this row to add the mapping.
/// <p>
/// There can be a lot of ways to handle this UX case, but this way turned out to be 
/// the simplest to implement when both back end and front end code are considered.
/// <p>
/// TO DO: The back end method checks to see if there is already at least 1 mapping for this path.
/// If not, it does nothing and returns a message. In practice, this case should not happen because
/// the Add Row icon does not display in the row when there are 0 existing mappings for the path.
/// Instead the Add Row icon is hidden and the user must click the Edit icon to add the first mapping for that row.
Method CreateEmptyMappingEntry(path As %String, sourceValue As %String) As %String [ ZenMethod ]
{
}

/// Delete a mapping table entry
Method DeleteMappingEntry(row) As %String [ ZenMethod ]
{
}

XData Style
{
<style type="text/css">

body {
	background: #FFFFFF;
	font-family: arial, sans-serif;
	font-size: 11pt;
}

li {
	padding-bottom:10px;
}

</style>
}

/// Apply the value for this dialog and keep it open.
/// After the ondialogFinish actions are completed successfully, 
/// update the display of current mapping table rows in UI.Edit.
ClientMethod dialogApply() [ Language = javascript ]
{
	try {
		// we are already processing a request
		if (this._callingParent) return;
		
		// check for callback
		var ok = true;
		if (this.ondialogFinish) {
			ok = this.ondialogFinish('apply');
		}
	
		if (ok) {
			// tell our parent window that OK was pressed.
			// do not close this window.
			this._callingParent = true;
			this.disableButtons(true);
			this.firePopupAction('apply',this.getDialogValue(),false);
			try {
				this.disableButtons(false);
				this._callingParent = false;
			}
			catch (closedEx) {}
			
			// update display of current mapping table info, with setTimeout so that UI.View (parent) can't block execution
			//alert("dialogApply: chooseFromPath args = ('" + zenPage.Path + "','" + zenPage.SourceValue + "','" + zenPage.Row + "','" + zenPage.ToPath + "','" + zenPage.ToXF + "','" + zenPage.SourceXF + "')");
			setTimeout("zenPage.chooseFromPath('" + zenPage.Path + "','" + zenPage.SourceValue + "','" + zenPage.Row + "','" + zenPage.ToPath + "','" + zenPage.ToXF + "','" + zenPage.SourceXF + "');", 15);
		}
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments);
	}
}

ClientMethod viewInfo(dataName) [ Language = javascript ]
{
	if (dataName && dataName.length > 0) {
		var parms = { DATA:dataName };
		var options = 'status, scrollbars, resizable=yes, top=25, left=500, width=850, height=800, modal=no';
		zenLaunchPopupWindow(zenLink('SchemaMap.Tool.UI.File.zen'), 'ViewInfo', options, parms);
	}
}

ClientMethod configureLookup(pair, source, target) [ Language = javascript ]
{
	var parms = { PAIR:pair, SOURCE:source, TARGET:target };
	var widthValue = zenPage.EditEnabled ? '850' : '770';
	var heightValue = zenPage.EditEnabled ? '930' : '700';
	var options = 'status, scrollbars, resizable=yes, top=50, left=50, width=' + widthValue + ', height=' + heightValue;
	zenLaunchPopupWindow(zenLink('SchemaMap.Tool.UI.Lookup.zen'), 'ConfigLookup', options, parms);
}

ClientMethod undoSmartTyping(text) [ Language = javascript ]
{
	if (!text || typeof text === 'undefined' || text.length === 0) {
		return '';
	}
	// https://stackoverflow.com/questions/2826191/converting-ms-word-quotes-and-apostrophes
	if (text.indexOf('\u2013') > -1) text = text.replace('\u2013', '-');
	if (text.indexOf('\u2014') > -1) text = text.replace('\u2014', '-');
	if (text.indexOf('\u2015') > -1) text = text.replace('\u2015', '-');
	if (text.indexOf('\u2017') > -1) text = text.replace('\u2017', '_');
	if (text.indexOf('\u2018') > -1) text = text.replace('\u2018', '\'');
	if (text.indexOf('\u2019') > -1) text = text.replace('\u2019', '\'');
	if (text.indexOf('\u201a') > -1) text = text.replace('\u201a', ',');
	if (text.indexOf('\u201b') > -1) text = text.replace('\u201b', '\'');
	if (text.indexOf('\u201c') > -1) text = text.replace('\u201c', '\"');
	if (text.indexOf('\u201d') > -1) text = text.replace('\u201d', '\"');
	if (text.indexOf('\u201e') > -1) text = text.replace('\u201e', '\"');
	if (text.indexOf('\u2026') > -1) text = text.replace("\u2026", "...");
	if (text.indexOf('\u2032') > -1) text = text.replace('\u2032', '\'');
	if (text.indexOf('\u2033') > -1) text = text.replace('\u2033', '\"');
	return text;
}

ClientMethod parseLeaf(path) [ Language = javascript ]
{
	var leaf = path.split(':')[0];
	var leafName = leaf.split('.');
	var len = leafName.length;
	if (len > 1) {
		leaf = leafName[len - 1];
	}
	return leaf;
}

Method IsClassNameValid(className As %String) As %ZEN.Datatype.boolean [ ZenMethod ]
{
}

Method GetAncestorTransformDefault(source As %String = "", target As %String = "", type As %String(VALUELIST=",target,source") = "") As %String [ ZenMethod ]
{
}

Method GetAncestorTransformMessage(toPath As %String = "", toXF As %String = "", type As %String(VALUELIST=",target,source") = "") As %String [ ZenMethod ]
{
}

Method GetSubTransformClassName(source As %String = "", target As %String = "") As %String [ ZenMethod ]
{
}

}
