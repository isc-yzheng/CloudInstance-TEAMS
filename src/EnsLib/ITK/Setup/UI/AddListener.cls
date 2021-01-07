/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

Class EnsLib.ITK.Setup.UI.AddListener Extends EnsPortal.Dialog.standardDialog [ System = 4 ]
{

Parameter RESOURCE = "%Ens_ITK:WRITE";

/// Enable styles that are common to all pages and dialogs for the EnsPortal application.
Parameter APPLICATION = "EnsPortal.Application";

Parameter PAGENAME = "Add System";

Parameter APPLYBUTTON = 0;

Parameter CANCELBUTTON = 1;

Property ProductionName As %ZEN.Datatype.string(ZENURL = "PRODUCTION");

XData Style
{
}

XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>
<hgroup>
<dataController id="listenerData"  
    modelClass="EnsLib.ITK.Setup.UI.ListenerModel" 
    modelId=""
/>
<spacer width="10"/>
<form id="listenerForm"
         layout="vertical"
         cellStyle="padding: 2px; padding-left: 5px; padding-right: 5px;">
         
<text required="true" readOnly="false" hidden="false" 
 	name="ServiceOTHERName" id="ServiceOTHERName" label="Listener / Business Service Name" 
	size="40" enclosingStyle="padding-bottom:4px;" 
	title="Enter a name for this Business Service. Do not use the characters ;,:|!*- or $ in the name."
	/>
</form>
</hgroup>
</pane>
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit "Add a new system to the system registry"
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit "Add System"
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
Method SaveListener(pName As %String) As %String [ ZenMethod ]
{
  Set tSC = $$$OK
  set prod=##class(Ens.Config.Production).%OpenId(..ProductionName)
  if prod="" {
	  Set tSC = $$$ERROR($$$EnsErrGeneral, "Unable to find production "_..ProductionName)
  } else {
	set item = ##class(Ens.Config.Item).%New()
	set item.Production=prod
	set item.Name=pName
	set item.ClassName="EnsLib.ITK.Framework.Service.SOAPRequestHandler"
	set item.Enabled=0

	set targetConfigName = ##class(Ens.Config.Setting).%New()
	set targetConfigName.Target="Host"
	set targetConfigName.Name="TargetConfigName"
	set targetConfigName.Value = "ITKMessageRouter"

	do item.Settings.Insert(targetConfigName)
	do prod.Items.Insert(item)
	
	Set tSC = prod.%Save()
	  
  }  
  
  Quit:$$$ISERR(tSC) $ZCVT($$$StatusDisplayString(tSC),"O","JS")
  Quit ""
}

/// This callback, if defined, is called when the user presses the OK or Apply action buttons.
/// If this returns false, then the action is cancelled.
ClientMethod ondialogFinish(action) [ Language = javascript ]
{
	if (!this.checkEdit()) { return; }
	var name = zenGetProp('ServiceOTHERName','value');
	var ok = zenPage.SaveListener(name);
	
	if (ok != '') {
		alert(ok);
		return false;
	}
	
	return true;
}

}
