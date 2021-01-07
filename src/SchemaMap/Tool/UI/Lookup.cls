Include SchemaMap

Class SchemaMap.Tool.UI.Lookup Extends %ZEN.Dialog.standardDialog
{

Parameter RESOURCE = "%Ens_EDISchemaAnnotations:READ";

Parameter APPLYBUTTON = 1;

Parameter CANCELBUTTON = 1;

Property EditEnabled As %Boolean;

Property Pair As %String(ZENURL = "PAIR");

Property From As %String;

Property To As %String;

Property Source As %String(ZENURL = "SOURCE");

Property Target As %String(ZENURL = "TARGET");

Property ForReference As %Boolean;

/// Contents of the dialog body.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" >
<spacer height="15px"/>
<hgroup>
<spacer width="20px"/>
<vgroup>
<html id="codeTable" valign="top" OnDrawContent="DrawCodeTable" seed="" />
</vgroup>
<spacer width="20px"/>
</hgroup>
<spacer height="15px"/>
</pane>
}

ClientMethod enterKeyTable(event) [ Language = javascript ]
{
    var e = window.event || event;
	var key = (e.keyCode) ? e.keyCode : e.which;
	if (key == zenENTER) {
		zenPage.addCodeTable('input_newFromTable','input_newToTable');
	}
}

ClientMethod enterKeyCode(event, inputFrom, inputTo) [ Language = javascript ]
{
    var e = window.event || event;
	var key = (e.keyCode) ? e.keyCode : e.which;
	if (key == zenENTER) {
		var fromInput = self.document.getElementById('selectFromTable');
		var toInput = self.document.getElementById('selectToTable');
		if (fromInput && toInput) {
			var fromTable = zenPage.strip(fromInput.value);
			var toTable = zenPage.strip(toInput.value);
			zenPage.addCodeMapping(fromTable, toTable, inputFrom, inputTo);
		}
	}
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

Method DrawCodeTable(seed As %String) As %Status
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
	if (zenPage.EditEnabled) {
		zenPage.getInputValues();
	}
	this.returnValue = { };
	return true;
}

ClientMethod getInputValues() [ Language = javascript ]
{
	var fromInput = self.document.getElementById('selectFromTable');
	var toInput = self.document.getElementById('selectToTable');
	if (fromInput && toInput) {
		var fromTable = zenPage.strip(fromInput.value);
		var toTable = zenPage.strip(toInput.value);
		if (fromTable && fromTable.length > 0 && toTable && toTable.length > 0) {
			var fromCode = '';
			var toCode = '';
			var fromList = self.document.getElementsByClassName('codeFrom');
			var toList = self.document.getElementsByClassName('codeTo');
			if (fromList && toList) {
				zenPage.deleteLookupTable(fromTable, toTable, false);
				for (var i = 0; i < fromList.length; i++) {
					zenPage.addCodeMapping(fromTable, toTable, fromList[i].id, toList[i].id, false);
				}
			}
			var select = zen('codeTable');
			if (select) {
				select.seed = fromTable + ',' + toTable;
				select.refreshContents(true);
			}
		}
	}
}

Method NewCodeTable(fromTable As %String, toTable As %String) As %Status [ ZenMethod ]
{
}

Method DeleteCodeTable(fromTable As %String, toTable As %String) As %String [ ZenMethod ]
{
}

Method NewCodeTableEntry(fromTable As %String, toTable As %String, fromCode As %String, toCode As %String) As %String [ ZenMethod ]
{
}

Method DeleteCodeTableEntry(fromTable As %String, toTable As %String, fromCode As %String) As %String [ ZenMethod ]
{
}

/// When you select an option from the selectToTable list,
/// the "New" fields (if visible) disappear and 
/// the code mapping display fields change to show the code-to-code mappings for 
/// the current selectFromTable and selectToTable choices.
ClientMethod changeToTable(fromTable, toTable) [ Language = javascript ]
{
	if (fromTable.length > 0) {
		var select = zen('codeTable');
		if (select) {
			select.seed = fromTable + ',' + toTable;
			select.refreshContents(true);
		}
	}
}

/// Delete this lookup table and all of the code-to-code mappings it contains.
/// Arguments 1 and 2 give the data values of the from and to table names that are the nodes to remove.
ClientMethod deleteLookupTable(fromTable, toTable, prompt) [ Language = javascript ]
{
	if (typeof prompt === 'undefined') {
		prompt = true;
	}
	if (fromTable.length > 0 && toTable.length > 0) {
		if (!prompt || confirm("Are you sure you want to delete this lookup table?")) {
			var error = zenPage.DeleteCodeTable(fromTable, toTable);
			if (prompt) {
				if (error.length > 0) {
					alert(error);
				}
				else {
					var select = zen('codeTable');
					if (select) {
						select.seed = ',';
						select.refreshContents(true);
					}
				}
			}
		}
	}
}

/// Add this new lookup table. The display is refreshed and it becomes the currently selected table.
/// Arguments 1 and 2 give the HTML id values of the input fields that
/// contain the new from and to table names to write as nodes in the new entry in the lookup table.
ClientMethod addCodeTable(fromTable, toTable) [ Language = javascript ]
{
	var fromInput = self.document.getElementById(fromTable);
	var toInput = self.document.getElementById(toTable);
	if (fromInput && toInput) {
		var fromValue = zenPage.strip(fromInput.value);
		var toValue = zenPage.strip(toInput.value);
		if (fromValue.length > 0 && toValue.length > 0) {
			if (zenPage.isDuplicateTable(fromValue, toValue)) {
				alert('There is already a lookup table for ' + fromValue + ' mapped to ' + toValue + '. You may edit or delete that table.');
			}
			else {
				var error = zenPage.NewCodeTable(fromValue, toValue);
				if (error.length > 0) {
					alert(error);
				}
				else {
					var select = zen('codeTable');
					if (select) {
						select.seed = fromValue + ',' + toValue;
						select.refreshContents(true);
					}
				}
			}
		}
		else {
			alert('Please supply both values for the new lookup table.');
		}
	}
}

ClientMethod isDuplicateTable(fromTable, toTable) [ Language = javascript ]
{
	var input = self.document.getElementById('listAllTables');
	if (input) {
		var value = zenPage.strip(input.value);
		var compareValue = fromTable + '|' + toTable;
		if (value && (typeof value != 'undefined') && value.indexOf(',' + compareValue + ',') >= 0) {
			return true;
		}
	}
	return false;
}

/// Delete this code-to-code mapping from this lookup table.
/// Arguments 1 and 2 give the data values of the from and to table names that are the nodes to modify.
/// Argument 3 gives the data value of the from code in the pair to remove from the table.
ClientMethod deleteCodeMapping(fromTable, toTable, fromCode) [ Language = javascript ]
{
	if (fromCode.length > 0) {
		if (confirm("Are you sure you want to delete this code-to-code mapping?")) {
		var error = zenPage.DeleteCodeTableEntry(fromTable, toTable, fromCode);
			if (error.length > 0) {
				alert(error);
			}
			else {
				var select = zen('codeTable');
				if (select) {
					select.seed = fromTable + ',' + toTable;
					select.refreshContents(true);
				}
			}
		}
	}
}

ClientMethod isDuplicateCode(fromCode) [ Language = javascript ]
{
	var input = self.document.getElementById('listAllCodes');
	if (input) {
		var value = zenPage.strip(input.value);
		if (value && (typeof value != 'undefined') && value.indexOf(',' + fromCode + ',') >= 0) {
			return true;
		}
	}
	return false;
}

/// Add this new code-to-code mapping to this lookup table. 
/// Arguments 1 and 2 give the data values of the from and to table names that are the nodes to modify.
/// Arguments 3 and 4 give the HTML id values of the input fields that
/// contain the new from and to code values to write to the new entry in the lookup table.
/// The method derives the lookup table from and to nodes to write these code values to,
/// by reading the current values in the select lists at the top of the form.
ClientMethod addCodeMapping(fromTable, toTable, fromCode, toCode, prompt) [ Language = javascript ]
{
	if (typeof prompt === 'undefined') {
		prompt = true;
	}
	var fromInput = self.document.getElementById('selectFromTable');
	var toInput = self.document.getElementById('selectToTable');
	if (fromInput && toInput) {
		var fromTable = zenPage.strip(fromInput.value);
		var toTable = zenPage.strip(toInput.value);
		if (fromTable.length > 0 && toTable.length > 0) {
			fromInput = self.document.getElementById(fromCode);
			toInput = self.document.getElementById(toCode);
			if (fromInput && toInput) {
				var fromValue = zenPage.strip(fromInput.value);
				var toValue = zenPage.strip(toInput.value);
				if (fromValue.length > 0 && toValue.length > 0) {
					if (prompt && zenPage.isDuplicateCode(fromValue, toValue)) {
						alert('There is already a code-to-code mapping defined for ' + fromValue + '. You may edit or delete that mapping.');
					}
					else {
						//alert('addCodeMapping: ' + fromValue + ' ' + toValue);
						var error = zenPage.NewCodeTableEntry(fromTable, toTable, fromValue, toValue);
						if (prompt) {
							if (error.length > 0) {
								alert(error);
							}
							else {
								var select = zen('codeTable');
								if (select) {
									select.seed = fromTable + ',' + toTable;
									select.refreshContents(true);
								}
							}
						}
					}
				}
				else {
					if (prompt) {
						alert('Please supply both values for the new code-to-code mapping.');
					}
				}
			}
		}
	}
}

ClientMethod strip(text) [ Language = javascript ]
{
	return text.replace(/^\s+|\s+$/g, "").replace(/^\t+|\t+$/g, "");
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
table.docTable {
	border-collapse: collapse;
}
table.docTable tr th {
	text-align: left;
	padding: 4px 8px 4px 4px;
	overflow-x: hidden;
	font-size: 11pt;
}
table.docTable tr td {
	text-align: left;
	padding: 4px 8px 4px 4px;
	vertical-align: bottom;
	font-size: 11pt;
}
</style>
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
}

}
