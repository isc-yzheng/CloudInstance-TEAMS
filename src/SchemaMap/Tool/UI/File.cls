Include SchemaMap

/// This method checks for %Ens_EDISchemaAnnotations:READ privilege, then displays content in a popup. 
/// Content is expected to be HTML formatted. If it is not, results may be unexpected.
/// <p>
/// DATA (DataName) takes precedence over NAME. It must be the name of a method
/// in the class SchemaMap.Tool.Data.Message that returns a %String value.
/// The entire contents of that %String are displayed without modification.
/// <p>
/// NAME (FileName) must be the name of a file in the local file system.
/// The entire contents of that file are displayed without modification.
Class SchemaMap.Tool.UI.File Extends %ZEN.Dialog.standardDialog
{

Parameter RESOURCE = "%Ens_EDISchemaAnnotations:READ";

Parameter APPLYBUTTON = 0;

Parameter CANCELBUTTON = 0;

Property FileName As %String(ZENURL = "NAME");

Property DataName As %String(ZENURL = "DATA");

/// Contents of the dialog body.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" >
<hgroup>
<spacer width="20px"/>
<vgroup>
<html id="fileContent" valign="top" OnDrawContent="drawFileContent" seed="" />
</vgroup>
<spacer width="20px"/>
</hgroup>
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

Method drawFileContent(seed As %String) As %Status
{
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	return '';
}

/// This callback, if defined, is called when the user presses the OK or Apply action buttons.
/// If this returns false, then the action is cancelled.<br>
ClientMethod ondialogFinish(action) As %Boolean [ Language = javascript ]
{
	return true;
}

XData Style
{
<style type="text/css">

body {
	background: #FFFFFF;
	font-family: arial, sans-serif;
	font-size: 11pt;
}

</style>
}

}
