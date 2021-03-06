Include SchemaMap

Class SchemaMap.Tool.UI.Prompt Extends %ZEN.Dialog.standardDialog
{

Parameter RESOURCE = "%Ens_EDISchemaAnnotations:READ";

Parameter APPLYBUTTON = 0;

Property Path(ZENURL = "PATH");

Property Resource As %String;

Property Element As %String;

Property Pair(ZENURL = "PAIR");

Property From As %String;

Property To As %String;

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

Method GetCurrentValues() As %Status
{
}

Method DrawPromptContent(seed As %String) As %Status
{
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	return this.returnValue;
}

ClientMethod recheckAuto(value) [ Language = javascript ]
{
	var checkManual = self.document.getElementById('ClearManualMap');
	var checkAuto = self.document.getElementById('ClearAutoMap');
	if (checkManual && checkAuto) {
		if (value === 'Manual' && checkManual.checked) {
			checkAuto.checked = !checkManual.checked;
		}
		else if (value === 'Auto' && checkAuto.checked) {
			checkManual.checked = !checkAuto.checked;
		}
		else if (value === 'Auto' && !checkAuto.checked) {
			checkManual.checked = false;
		}
	}
}

/// This callback, if defined, is called when the user presses the OK or Apply action buttons.
/// If this returns false, then the action is cancelled.<br>
ClientMethod ondialogFinish(action) As %Boolean [ Language = javascript ]
{
	var boolAutoMap = false;
	var boolManualMap = false;
	var check = self.document.getElementById('ClearAutoMap');
	if (check) {
		boolAutoMap = (check && check.checked);
		check = self.document.getElementById('ClearManualMap');
		if (check) {
			boolManualMap = (check && check.checked);
		}
	}
	this.returnValue = { 
		clearAutoMap:boolAutoMap, 
		clearManualMap:boolManualMap
	};
	return true;
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
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

}
