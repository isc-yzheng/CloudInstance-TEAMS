/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsJBH)

Class EnsPortal.Dialog.GenerateJGInitiator Extends EnsPortal.Dialog.standardDialog [ System = 4 ]
{

Parameter APPLYBUTTON = 0;

/// Displayed name of this page.
Parameter PAGENAME = "Java Gateway Initiator Service Wizard";

/// Domain used for localization.
Parameter DOMAIN = "Ensemble";

/// User needs WRITE permissions on the %Ens_ProductionConfig resource to view this page and its subclasses.
Parameter RESOURCE = "%Ens_ProductionConfig:WRITE";

/// Name of the active production.
Property ProductionName As %ZEN.Datatype.string(ZENURL = "PRODUCTION");

/// Holder for return value.
Property retValue As %ZEN.Datatype.string;

Parameter CSSINCLUDES = "ensemble/Ensemble_Wizards.css";

/// Contents of this dialog
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>
<spacer height="5" />
<spacer width="20" />

<form name="formService" id="formService">
<spacer height="20" />
<spacer width="5" />

<vgroup labelPosition="left" >

<text required="false" readOnly="false" hidden="false" 
 	name="ServiceName" id="ServiceName" label="Config Name" labelClass="labelNormal" 
	size="43" enclosingStyle="padding-bottom:4px;" 
	title="Enter a configuration item name for this Business Service. Do not use the characters ;,:|!*-$ or [ in the name. If you do not enter a name, 'EnsLib.JavaGateway.Initiator' is used."
	value="EnsLib.JavaGateway.Initiator"
	/>
<spacer height="10"/>
<text required="true" readOnly="false" hidden="false"
name="ServiceAddress" id="ServiceAddress" label="Address" labelClass="labelNormal"
size="43" enclosingStyle="padding-bottom:4px;"
title="IP address or name of the machine where the JVM to be used by the Java Gateway Server is located."
value="127.0.0.1"
/>
<text required="true" readOnly="false" hidden="false"
name="ServicePort" id="ServicePort" label="Port" labelClass="labelRequired"
size="43" enclosingStyle="padding-bottom:4px;"
title="TCP port number for communication between the Java Gateway Server and the proxy classes in IRIS."
value="55555"
/>
<spacer height="10"/>
<selector name="ServiceCategory" id="ServiceCategory" label="Display Category" labelClass="labelNormal" hidden="false"
enclosingStyle="padding-bottom:4px;" size="40"  
title="To group items together in the production configuration summary, give each item the same Category name. You may choose a name from the list, type in a new Category name, or type in a comma-separated list of names. If there are no Categories defined, the list is empty."
  multiSelect="true" context="Ens.ContextSearch/ProductionCategories" />
<spacer height="3"/>
<textarea required="false" readOnly="false" hidden="false"
    name="ServiceComment" id="ServiceComment" label="Comment"  labelClass="labelNormal"
	rows="3" cols="34" enclosingStyle="padding-bottom:4px;" 
	title="Provide a brief comment about this Business Service. This annotation appears in the configuration summary for the production."
	 />

</vgroup>

</form>

</pane>
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$TextHTML("Java Gateway Initiator Service Wizard")
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
	Quit $$$TextHTML("Add an EnsLib.JavaGateway.Initiator Service to the Active Production")
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	return encodeURIComponent(this.retValue);
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	
	// get the name of the production to which we will be adding this service
	Set ..ProductionName = ##class(Ens.Director).GetActiveProductionName()
	
	// send the production name to the category selector components
	Set sel = ..%GetComponentById("ServiceCategory")
	Set sel.context = sel.context _ "?productionName=" _ ..ProductionName

	Quit tSC
}

/// This callback is called when the user presses the OK button.
/// If this returns false, then the action is canceled.
ClientMethod ondialogFinish(action) As %Boolean [ Language = javascript ]
{
	try {
		var isValid = zenPage.validateAll();
		if (isValid) {
			var msg = zenPage.OnWizardCompletion(zenPage.ProductionName);
			if (msg != '') {
				isValid = false;
				alert(msg);
			}
		}
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments);
		isValid = false;
	}

	if (isValid) {
		this.retValue = 1;
		return true;
	}
	else {
		this.retValue = 0;
		return false;
	}
}

/// Do validation of all fields on the form.
ClientMethod validateAll() [ Language = javascript ]
{
	var ok = true;
	var msg = zenText('msgHostErrorsStart') + '\n';
	
	// Check that Port has a numerical value
	var port = zen('ServicePort').getValue()
	if ('' == port) {
		msg += ('  ' + $$$FormatText($$$Text("Please specify a TCP port number.")) + '\n');
		ok = false;
	} else if (parseInt(port).toString() != port) {
		msg += ('  ' + $$$FormatText($$$Text("Invalid TCP port number.  '%1' is not a numerical value."),port) +'\n');
		ok = false;
	}

	// It is difficult to distinguish configuration items 
	// with the same name and class, so don't create duplicates
	var prod = zenPage.ProductionName;
	var name = zen('ServiceName').getValue();
	if (name !== name.replace(/^\s+|\s+$/g,'')) {
		msg += ('  ' + $$$FormatText($$$Text("Item name '%1' has leading or trailing spaces."),name) + '\n');
		ok = false;	
	}
	var cls = 'EnsLib.JavaGateway.Service';
	var commentOrClass = zen('ServiceComment').getValue();
	if (commentOrClass == '') commentOrClass = cls;
	if (commentOrClass.length > 500) { 
		msg += ('  ' + zenText('msgHostDescLong') + '\n');
		ok = false;
	}
	var nameOrCls = (name == '' ? cls : name);
	var ret = zenPage.ItemAlreadyExists(prod,nameOrCls,commentOrClass);
	var exists = ret.split(":");
	if (exists[0] == "Duplicate") {
		msg += ('  ' + $$$FormatText($$$Text("An item already exists with the name '%1'."),nameOrCls) + '\n');
		ok = false;
	}
	if (exists[1] == "Enabled") {
		msg += ('  ' + $$$FormatText($$$Text("You cannot enable this new host without disabling the other item with name '%1' that is already enabled."),nameOrCls,commentOrClass) + '\n');
		ok = false;
	}
	if (nameOrCls.match(/^[^;,:|[-][^;,:|[]*[^;,:|[!$-]$|^[^*;,:|[!$-]$/) == null) {
		msg += ('  ' + zenText('msgHostBadChar') + '\n');
		ok = false;
	}
	if (nameOrCls.length > 128) { 
		msg += ('  ' + zenText('msgHostLong') + '\n');
		ok = false;
	}
	
	// finish 
	if (ok == false) {
		msg += ('\n' + zenText('msgHostErrorsEnd') + ' ' + zenText('msgHostFixSave') + '\n');
		alert(msg);
	}
	zenPage.retValue = ok;
	return ok;
}

Method %OnGetJSResources(ByRef pResources As %String) As %Status [ Private ]
{
	Set pResources("msgHostErrorsStart") = $$$Text("Errors:")
	Set pResources("msgHostErrorsEnd") = $$$Text("NOTE: Because there were errors, your changes have not been saved.")
	Set pResources("msgHostFixSave") = $$$Text("To save your work, click OK in this alert box, correct the reported problems, and then click OK in the Wizard dialog.")
	Set pResources("msgHostBadChar") = $$$Text("Please do not use the characters ;,:|!*-$ or [ in the host name.")
	Set pResources("msgHostLong") = $$$Text("Please keep the Name length under 100 characters.")
	Set pResources("msgHostDescLong") = $$$Text("Please keep the Comment length under 500 characters.")
	Quit $$$OK
}

ClassMethod ItemAlreadyExists(production As %String, name As %String, cls As %String) As %String [ ZenMethod ]
{
	Set tFoundDuplicate = "" ; No configuration item with this name and class name was found in the package
	Set tFoundEnabled = "" ; No configuration item with this name is currently enabled
	Set tRS = ##class(%ResultSet).%New("Ens.Config.Production:EnumerateConfigItems")
	Do tRS.Execute(production,,0) ; Look through the entire production for this item
	If (tRS) {
		While ((tRS.Next()) && ((tFoundDuplicate="") || (tFoundEnabled=""))) { 
			If (name = tRS.Data("ConfigName")) {
				If ((cls = tRS.Data("CommentOrClassName")) || ($$$eHostTypeService =tRS.Data("BusinessType"))) {
					Set tFoundDuplicate = "Duplicate" ; We found an item that matches
				}
				If (1 = tRS.Data("Enabled")) {
					Set tFoundEnabled = "Enabled"
				}
			}
		}
	}
	Quit tFoundDuplicate _ ":" _ tFoundEnabled
}

/// This method is invoked when the user completes the Wizard pressing "OK".
/// Returns a null string if it succeeds, or an error message otherwise.
Method OnWizardCompletion(pProdId As %String) As %String [ ZenMethod ]
{
	Set tSC = $$$OK
	Set tmsg = ""

	Try {
		Set production = ##class(Ens.Config.Production).%OpenId(pProdId)
		If $IsObject($G(production)) {
			// Add the new host to the Production
			Set tSC = ..AddNewItem(production) Quit:$$$ISERR(tSC)

			// save production (and item), update production class and account for Source Control
			Set tSC = ##class(EnsPortal.Template.prodConfigSCPage).CallProductionUpdateAndSaveToClass(production,"","SaveProduction")

			Quit:$$$ISERR(tSC)
		}

		Else {
			Set tmsg = $$$Text("Unable to open Production object.")
		}
	}
	Catch (ex) {
		Set tmsg = ex.DisplayString()
	}
	If $$$ISERR(tSC) Set tmsg = $System.Status.GetErrorText(tSC)
	Quit tmsg
}

/// Generic method for adding a new host
ClassMethod AddNewItem(production As Ens.Config.Production) As %Status
{
	Try {
		// add new item to production
		Set item = ##class(Ens.Config.Item).%New()
		Set item.ClassName = "EnsLib.JavaGateway.Initiator"
		Set item.Name = %page.%GetValueById("ServiceName")
		Set:item.Name="" item.Name = item.ClassName
		Set item.Category = %page.%GetValueById("ServiceCategory") 
		Set item.Comment = %page.%GetValueById("ServiceComment")
		Set:(item.Comment="") item.Comment = $$$Text("Created by the Java Gateway Initiator Service Wizard")
		Set item.Enabled = 1
		
		Set setting = ##class(Ens.Config.Setting).%New()
		Set setting.Name = "Address"
		Set setting.Target = "Host"
		Set setting.Value = %page.%GetValueById("ServiceAddress")
		Do item.Settings.Insert(setting)
		
		Set setting = ##class(Ens.Config.Setting).%New()
		Set setting.Name = "Port"
		Set setting.Target = "Host"
		Set setting.Value = %page.%GetValueById("ServicePort")
		Do item.Settings.Insert(setting)

		Set tSC = production.Items.Insert(item)
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
