Include Ensemble

/// Dialog to report information during an attempt to update or change the status of a production.
Class HS.UI.StartStop Extends EnsPortal.Dialog.standardDialog [ System = 4 ]
{

/// User needs USE permissions on the %Ens_ProductionRun or the %Ens_ConfigItemRun resource to view this page.
Parameter RESOURCE = "%All";

Parameter APPLYBUTTON = 0;

Parameter CANCELBUTTON = 0;

Parameter CLOSEONESC = 2;

Parameter CLOSEONENTER = 1;

Parameter PAGENAME = "Production Update";

Parameter DOMAIN = "HS";

Property productionId As %ZEN.Datatype.className(ZENURL = "PRODUCTION");

Property action As %ZEN.Datatype.string(ZENURL = "ACTION");

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit $Case(..action,
			"start"  : $$$TextHTML("Start All Productions"),
			"stop"   : $$$TextHTML("Stop All Productions"),
			: $ZCVT($$$FormatText($$$Text("ERROR '%1'"),..action),"O","HTML"))
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit ""
}

ClientMethod applyDetails() [ Language = javascript ]
{
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	return '';
}

/// This XML block defines the contents of this pane.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" align="left" valign="middle" >
<hgroup>
<label id="actionLabel" enclosingClass="labels" />
</hgroup>
<iframe id="outputFrame" frameBorder="false" height="550" width="950"/>
</pane>
}

XData Style
{
<style type="text/css">
#updateText {
	background: white;
	padding: 5px;
	border: 1px solid gray;
}
.labels {
	font-weight: bold;
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
	Set tActionLabel = ..%GetComponentById("actionLabel")
	If $IsObject(tActionLabel) {
		Set tActionLabel.value = $Case(..action, 
										"start"  : $$$TextHTML("Starting All Productions: "),
										"stop"   : $$$TextHTML("Stopping All Productions: "),
										: "-")
	}
	Set tOutputFrame = ..%GetComponentById("outputFrame")
	If $IsObject(tOutputFrame) && (tActionLabel.value'="-") {
		Set tQuery("ACTION") = ..action
		Set tOutputFrame.src = ..Link("HS.UI.StartStopFrame.cls", .tQuery)
	} Else {
		Set tActionLabel.value = "ERROR "_$ZCVT(..action,"O","HTML")
	}
	Quit $$$OK
}

}
