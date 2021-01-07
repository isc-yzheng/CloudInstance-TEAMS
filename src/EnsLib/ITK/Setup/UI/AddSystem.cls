/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.ITK.Setup.UI.AddSystem Extends EnsPortal.Dialog.standardDialog [ System = 4 ]
{

Parameter RESOURCE = "%Ens_ITK:WRITE";

/// Enable styles that are common to all pages and dialogs for the EnsPortal application.
Parameter APPLICATION = "EnsPortal.Application";

Parameter PAGENAME = "Add System";

Parameter APPLYBUTTON = 0;

Parameter CANCELBUTTON = 1;

Property Type As %String(ZENURL = "TYPE");

XData Style
{
}

XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>
<hgroup id="detailGroup">
<dataController id="systemData"  
    modelClass="EnsLib.ITK.Setup.SystemDefinition" 
    modelId=""
/>
<spacer width="10"/>
<dynaForm id="systemForm"
         controllerId="systemData" 
         layout="vertical"
         cellStyle="padding: 2px; padding-left: 5px; padding-right: 5px;">
</dynaForm>
</hgroup>
</pane>
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit "Add a new "_..Type_" to the "_..Type_" registry"
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit "Add "_$ZCVT(..Type,"T")
}

/// Get the value that will be applied when the user presses the OK button.
/// This is implemented by subclasses.
ClientMethod getDialogValue() [ Language = javascript ]
{
	//alert('getDialogValue method is unimplemented');
	return '';
}

Method %OnAfterCreatePage() As %Status
{
	Quit $$$OK
}

/// save contact model to database
ClientMethod saveSystem() [ Language = javascript ]
{
  if (!this.checkEdit()) { return; }
  // validate and save form
  var form = zenPage.getComponentById('systemForm');
  return form.save();
}

/// This callback, if defined, is called when the user presses the OK or Apply action buttons.
/// If this returns false, then the action is cancelled.
ClientMethod ondialogFinish(action) [ Language = javascript ]
{
	return (this.saveSystem() != "")
}

}
