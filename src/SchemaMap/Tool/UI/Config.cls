Include SchemaMap

Class SchemaMap.Tool.UI.Config Extends %ZEN.Dialog.standardDialog
{

Parameter RESOURCE = "%Ens_EDISchemaAnnotations:READ";

Parameter APPLYBUTTON = 0;

Parameter CANCELBUTTON = 0;

Property Mode As %String;

Property Project As %String;

Property SavedProject As %String;

Property Prefix As %String;

Property SavedPrefix As %String;

/// Contents of the dialog body.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" >
<spacer height="15px"/>
<hgroup>
<spacer width="20px"/>
<vgroup>
<html id="promptContent" valign="top" OnDrawContent="DrawPromptContent" seed="" />
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

Method DrawPromptContent(seed As %String) As %Status
{
}

Method GetPrefix(package, prefix) As %String
{
}

Method GetSuffix(package, prefix) As %String
{
}

ClientMethod chooseProject() [ Language = javascript ]
{
	var inputProject = self.document.getElementById('inputProject');
	if (inputProject) {
		var project = inputProject.value;
		var dialogContent = zen('promptContent');
		if (dialogContent) {
			dialogContent.seed = ":" + project + ":";
			dialogContent.refreshContents(true);
		}
	}
}

ClientMethod applyPrefix() [ Language = javascript ]
{
	var dialogContent = zen('promptContent');
	if (dialogContent) {
		dialogContent.seed = zenPage.getInputValues();
		dialogContent.refreshContents(true);
	}
}

ClientMethod resetPrefix() [ Language = javascript ]
{
	dialogContent = zen('promptContent');
	if (dialogContent) {
		dialogContent.seed = ":" + zenPage.SavedProject + ":" + zenPage.SavedPrefix;
		dialogContent.refreshContents(true);
	}
}

ClientMethod getInputValues() [ Language = javascript ]
{
	// get input elements
	
	var inputProject = self.document.getElementById('inputProject');
	if (!inputProject) return;
	var inputPrefix = self.document.getElementById('inputPrefix');
	if (!inputPrefix) return;
	var inputGenDTL = self.document.getElementById('inputGenDTL');
	if (!inputGenDTL) return; 
	// the remaining input elements are present, if inputGenDTL is present
	var inputGenModelFHIR2 = self.document.getElementById('inputGenModelFHIR2');
	var inputGenModelFHIR3 = self.document.getElementById('inputGenModelFHIR3');
	var inputLibDTL = self.document.getElementById('inputLibDTL');
	var inputLibUtil = self.document.getElementById('inputLibUtil');
	var inputLibJSON = self.document.getElementById('inputLibJSON');
	var inputLibXML = self.document.getElementById('inputLibXML');
	var inputLibAPI = self.document.getElementById('inputLibAPI');
	
	// form values from input elements
	
	var project = inputProject.value;
	var prefix = zenPage.cleanPrefix(inputPrefix.value);
	var genDTL = zenPage.appendSuffix(prefix, inputGenDTL.value);
	var genModelFHIR2 = zenPage.appendSuffix(prefix, inputGenModelFHIR2.value);
	var genModelFHIR3 = zenPage.appendSuffix(prefix, inputGenModelFHIR3.value);
	var libDTL = zenPage.appendSuffix(prefix, inputLibDTL.value);
	var libUtil = zenPage.appendSuffix(prefix, inputLibUtil.value);
	var libJSON = zenPage.appendSuffix(prefix, inputLibJSON.value);
	var libXML = zenPage.appendSuffix(prefix, inputLibXML.value);
	var libAPI = zenPage.appendSuffix(prefix, inputLibAPI.value);
	
	var seed = "Input:" + project + ':' + prefix + ':' + genDTL + ':' + genModelFHIR2 + ':' + genModelFHIR3 + ':' + libDTL + ':' + libUtil + ':' + libJSON + ':' + libXML + ':' + libAPI;
	return (seed);
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	return this.returnValue;
}

/// This callback, if defined, is called when the user presses the OK or Apply action buttons.
/// If this returns false, then the action is cancelled.<br>
ClientMethod ondialogFinish(action) As %Boolean [ Language = javascript ]
{
	this.returnValue = { };
	return true;
}

ClientMethod cleanPrefix(prefix) [ Language = javascript ]
{
	while ((prefix.length > 0) && (prefix.charAt(prefix.length - 1) === '.')) {
		prefix = prefix.substring(0, prefix.length - 2);
	}
	return prefix;
}

ClientMethod appendSuffix(prefix, suffix) [ Language = javascript ]
{
	while ((suffix.length > 0) && (suffix.charAt(0) === '.')) {
		suffix = suffix.substring(1);
	}
	if (suffix.length > 0) {
		suffix = '.' + suffix;
	}
	return (prefix + suffix);
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

}
