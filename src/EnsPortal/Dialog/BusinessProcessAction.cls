/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This dialog lets the user create or edit a call request or response within a Business Process.
Class EnsPortal.Dialog.BusinessProcessAction Extends EnsPortal.Dialog.standardDialog [ System = 4 ]
{

/// User must have READ permissions on either the %Ens_Code or the %Ens_BPL resource to view this page.
Parameter RESOURCE = "%Ens_Code:READ,%Ens_BPL:READ";

/// User must have WRITE permissions on either the %Ens_Code or the %Ens_BPL resource to make changes on this page.
Parameter EDITRESOURCE = "%Ens_Code:WRITE,%Ens_BPL:WRITE";

Parameter APPLYBUTTON = 0;

/// Index number of action, -1 for new.
Property actionIndex As %ZEN.Datatype.integer(ZENURL = "INDEX");

/// Type of action.
Property actionAction As %ZEN.Datatype.string(ZENURL = "ACTION");

/// Property to assign.
Property actionProperty As %ZEN.Datatype.string(ZENURL = "PROPERTY");

/// Value to assign.
Property actionValue As %ZEN.Datatype.string(ZENURL = "VALUE");

/// Key.
Property actionKey As %ZEN.Datatype.string(ZENURL = "KEY");

/// Indicated Request or Response.
Property which As %ZEN.Datatype.string(ZENURL = "WHICH");

/// Csv list of properties in BP context.
Property contextList As %ZEN.Datatype.string(MAXLEN = 30000, ZENURL = "CONTEXTLIST");

/// Name of context super class.
Property classContextSuper As %ZEN.Datatype.string(ZENURL = "CONTEXTSUPER");

/// Name of response class.
Property classResponse As %ZEN.Datatype.string(ZENURL = "RESPONSE");

/// Name of request class.
Property classRequest As %ZEN.Datatype.string(ZENURL = "REQUEST");

/// Name of callrequest class - specific to editing Call actions.
Property callRequest As %ZEN.Datatype.string(ZENURL = "CALLREQUEST");

/// Name of callresponse class - specific to editing Call actions.
Property callResponse As %ZEN.Datatype.string(ZENURL = "CALLRESPONSE");

XData Style
{
<style type="text/css">

</style>
}

/// Contents of the dialog body.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" cellStyle="padding-bottom:8px;">

<select id="bpAction" label="Action" valueList="set,append,clear,insert,remove"/>

<combobox id="bpProperty" size="40" label="Property" unrestricted="true" editable="true" />

<combobox id="bpValue" size="40" label="Value" unrestricted="true" editable="true" hint="Value to assign to property"/>

<text id="bpKey" size="20" label="Key" onkeydown="return zenPage.ctrlKeyDown(zenEvent);" hint="Key for collection properties"/>

<textarea id="bpAnnotation" rows="4" cols="40" label="Description" onkeydown="return zenPage.ctrlKeyDown(zenEvent);" hint="Description of this action" />

</pane>
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit $$$TextHTML("Business Process Action")
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	If (..actionIndex=-1) {
		Quit $$$TextHTML("Add a new action to an action list.")
	}
	Quit $$$TextHTML("Edit an action in an action list.")
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
		if (this.checkEdit()) {
			var main = this.getOpener();

			var bpAction = zen('bpAction').getValue();
			var bpProperty = zen('bpProperty').getValue();
			var bpValue = zen('bpValue').getValue();
			var bpKey = zen('bpKey').getValue();
			var bpAnnotation = zen('bpAnnotation').getValue();
		
			if (bpAction=='') {
				bpAction = 'set';
			}
			if (bpValue == '') bpValue = '""';
			if (bpKey == '') bpKey = '""';

			// add to main page
			if (main && main.zenPage && main.zenPage.setActionItem) {
				main.zenPage.setActionItem(this.which,this.actionIndex,bpAction,bpProperty,bpValue,bpKey,bpAnnotation);
			}
		}
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments);
	}
	return true;
}

/// This callback, if defined, is called when the dialog page is loaded.
ClientMethod ondialogStart() [ Language = javascript ]
{
	try {
		var opener = this.getOpener();
		if (opener && opener.zenPage && opener.zenPage.getAction) {
			var action = opener.zenPage.getAction(this.which,this.actionIndex);
			if (action) {
				var names = [ 'Action', 'Annotation', 'Key', 'Property', 'Value' ];
				for (var i=0; i < names.length; i++) {
					var propName = names[i];
					if (action[propName]) zen('bp'+propName).setValue(action[propName]);
				}
			}
		}
		zen('bpProperty').focus();
		zen('bpProperty').select();
	}
	catch(ex) {
	}
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	Try {
		Set:..actionAction="" ..actionAction = "set"

		Set tPropList = ..%GetPropertyList()
		Set ..%GetComponentById("bpProperty").valueList = tPropList
		Set ..%GetComponentById("bpValue").valueList = tPropList

		Set ..%GetComponentById("bpAction").value = ..actionAction
		Set ..%GetComponentById("bpProperty").value = ..actionProperty
		Set ..%GetComponentById("bpValue").value = ..actionValue
		Set ..%GetComponentById("bpKey").value = ..actionKey
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// This client event is fired when the a popup page launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	switch(popupName) {
	}
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

/// Build a csv-list of available properties.
Method %GetPropertyList(pIncludeVariable As %Boolean = 1) As %String
{
	Set tList = ""
	Try {
		// context list
		For p=1:1:$L(..contextList,",") {
			Set tProp = $P(..contextList,",",p)
			If (tProp'="") {
				Set tPropList("context",tProp) = ""
			}
		}

		// get properties for classes
		Set tSC = ..%GetPropertiesForClass(..classContextSuper,.tCList)
		Merge tPropList("context") = tCList

		Set tSC = ..%GetPropertiesForClass(..classRequest,.tCList)
		Merge tPropList("request") = tCList

		Set tSC = ..%GetPropertiesForClass(..classResponse,.tCList)
		Merge tPropList("response") = tCList

		If pIncludeVariable {
			Set tPropList("request") = ""
			Set tPropList("response") = ""
			Set tPropList("context") = ""
		}
		
		If ..which = "Request" {
			If ..callRequest '= "" {
				Set tSC = ..%GetPropertiesForClass(..callRequest,.tCList)
				Merge tPropList("callrequest") = tCList
			}
			If pIncludeVariable Set tPropList("callrequest") = ""
		}
		ElseIf ..which = "Response" {
			If ..callResponse '= "" {
				Set tSC = ..%GetPropertiesForClass(..callResponse,.tCList)
				Merge tPropList("callresponse") = tCList
			}
			If pIncludeVariable Set tPropList("callresponse") = ""
		}
		
		Set k = $O(tPropList(""))
		While (k'="") {
			If pIncludeVariable Set tList = tList _ $S(tList="": "", 1: ",") _ k
			Set p = $O(tPropList(k,""))
			While (p'="") {
				Set tList = tList _ $S(tList="":"",1:",") _ k _ "." _ p
				Set p = $O(tPropList(k,p))
			}
			Set k = $O(tPropList(k))
		}

	}
	Catch (ex) {
		Set tList = $ZE
	}
	Quit tList
}

/// Return an array of properties for the given class.
Method %GetPropertiesForClass(pClass As %String, Output pList) As %Status
{
	Set tSC = $$$OK
	Try {
		Kill pList
		If (pClass="") Quit

		Set tSC = ##class(Ens.Rule.Utils).GetPropertyList(.tList,pClass)
		If $$$ISERR(tSC) Quit

		Set k = $O(tList(""))
		While (k'="") {
			Set tName = $LG(tList(k),1)
			Set:tName'="" pList(tName) = ""
			Set k = $O(tList(k))
		}
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
