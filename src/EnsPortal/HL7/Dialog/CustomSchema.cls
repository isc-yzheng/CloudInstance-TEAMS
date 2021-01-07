/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsHL7)

/// Create a new production and add components to it.
Class EnsPortal.HL7.Dialog.CustomSchema Extends EnsPortal.HL7.Dialog.standardDialog [ System = 4 ]
{

Parameter APPLYBUTTON = 0;

/// User needs WRITE permissions on the %Ens_EDISchema resource to view this page.
Parameter RESOURCE = "%Ens_EDISchema:WRITE";

Parameter PAGENAME = "Custom Schema Wizard";

Parameter CSSINCLUDES = "ensemble/Ensemble_Wizards.css";

Property baseSchema As %String(ZENURL = "CURRENT");

/// Holder for return value.
Property retValue As %ZEN.Datatype.string;

XData Style
{
<style type="text/css">
</style>
}

/// Contents of the dialog body.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>
<spacer height="20" />
<hgroup>
<spacer width="20" />
<vgroup enclosingClass="wizardBox" >
	<form name="customSchemaForm" id="customSchemaForm">
	  <spacer height="10" />
		<vgroup labelPosition="left">
		<spacer height="10" />
		<selector name="baseSchemaName" id="baseSchemaName" label="Base Schema" hidden="false" 
		    enclosingStyle="padding-bottom:4px;" size="47" labelClass="labelRequired" required="true" 
			title="Choose or enter a name for the base schema. Do not use any whitespace characters, or any punctuation characters other than _ (underscore) or . (period) in the name."
		    multiSelect="false" context="Ens.ContextSearch/SchemaCategories?host=EnsLib.HL7.Service.Standard" 
		      /> 
		<spacer height="10" />
		<text label="Schema Name" name="txtSchema" id="txtSchema" labelClass="labelRequired" value="" size="50"
			title="Enter a new schema name in this field. Do not use any whitespace characters, or any punctuation characters including _ (underscore) or . (period) in the name." />
		<spacer height="10" />
		<textarea label="Schema Description" name="txtDescription" id="txtDescription" labelClass="labelNormal" value="" cols="39"
			title="Enter a description of the schema in this field."/>
		<spacer height="10" />
	</vgroup>
</form>
</vgroup>
<spacer width="20" />
<vgroup valign="top">
<spacer height="40" />
<label id="helpSubject" enclosingClass="labelComment" label="Use this form to create a new custom schema category." />
<spacer height="10" />
<label id="helpHover" enclosingClass="labelComment" label="For help with any field in this form, hover the cursor over the field name." />
</vgroup>
</hgroup>
</pane>
}

ClientMethod validateAll() [ Language = javascript ]
{
	var ok = true;
	var msg = $$$Text("ERRORS:") + '\n';
	var temp = '';
	
	// get existing schema as base
	var base = zen('baseSchemaName').getValue();
	temp = base.replace(/^\s+|\s+$/g, "");	
	temp = temp.replace(/^\t+|\t+$/g, "");
	if (temp.length != base.length) {
		base = temp;
		zen('baseSchemaName').setValue(base);
	}
	
	// get new schema name
	var name = zen('txtSchema').getValue();
	temp = name.replace(/^\s+|\s+$/g, "");	
	temp = temp.replace(/^\t+|\t+$/g, "");
	if (temp.length != name.length) {
		name = temp;
		zen('txtSchema').setValue(name);
	}

	// get validation values from the server (combine in one call, returns a comma and semi-colon separated string)
	var val = zenPage.GetValidationDataFromServer(base, name);
	var valid = val.split(";");
	var baseExists = valid[0];
	var customExists = valid[1];

	// validate base schema
	var len = base.length;
	if (len > 0) { // empty base schema name is okay
		if (base.match(/[`~@#$%^&*()-+={}\[\]|\\:;"'<,>?\/]/) || base.match(/\s/) || base.match(/\t/)) {
			msg += '  ' +  $$$Text("Do not use any whitespace characters, or any punctuation characters other than _ (underscore) or . (period) in the base schema name.") + '\n';
			ok = false;
		}
		else {
			if (baseExists == "0") {
				msg += ('  ' + $$$Text("The specified base schema does not exist in this namespace.") + '\n');
				ok = false;
			}
		}
	}
	
	// validate new schema
	len = name.length;
	if (len <= 0) {
		msg += '  ' + $$$Text("Please enter a new schema name.") + '\n';
		ok = false;
	}
	else {
		if (name.match(/[`~@#$%^&*()-+={}\[\]|\\:;"'<,>?\/]/) || name.match(/\s/) || name.match(/\t/)) {
			msg += '  ' + $$$Text("Do not use any whitespace characters, or any punctuation characters other than _ (underscore) or . (period) in the new schema name.") + '\n';
			ok = false;
		}
		else {
			if (customExists == "1") {
				msg += ('  ' + $$$Text("A custom schema with this name already exists in this namespace.") + '\n');
				ok = false;
			}
		}
	}
	
	if (ok == false) {
		msg += ('\n' + $$$Text("NOTE: Because there were errors, your changes have not been saved.") + ' ' 
		        + $$$Text("To save your work, click OK in this alert box, correct the reported problems, and then click OK in the dialog.")
		        + '\n');
		alert(msg);
	}
	return ok;
}

/// Get all the necessary data from the server in one call and use it later.
/// <p>
/// Here is the format of the comma and semi-colon separated string (values shown in angle brackets which are not really there): <br/>
/// <does pCustomSchema exist>,<can I edit pCustomSchema (is it in a custom schema)>;<br/>
/// <does pBaseSchema exist>,<can I edit pBaseSchema (is it in a custom schema)><br/>
ClassMethod GetValidationDataFromServer(pBaseSchema As %String, pCustomSchema As %String) As %String [ ZenMethod ]
{
	Set tMsg = ""
	Try {
		Set tRet = ##class(EnsPortal.HL7.Utils).SchemaEntityAlreadyExists(pBaseSchema, "", "")
		Set tMsg = tRet 
		Set tRet = ##class(EnsPortal.HL7.Utils).SchemaEntityAlreadyExists(pCustomSchema, "", "")
		Set tMsg = tMsg _ ";" _ tRet 
	}
	Catch (ex) {
	}
	Quit tMsg
}

/// This method is invoked when the user completes the Wizard pressing "OK".
/// Returns a null string if it succeeds, or an error message otherwise.
Method OnWizardCompletion(pSchemaBase As %String, pSchemaName As %String, pDescription As %String) As %String [ ZenMethod ]
{
	If '..canEdit Quit ..msgNotPermitted

	If ..sourceControlEnabled && ..IsSchemaSCReadOnly() Quit ..msgSCReadOnly

	Try {
		If ..sourceControlEnabled {
			Set ..category = pSchemaName
			Set tMsg = ..OnSchemaSave("before")
			If tMsg '= "" Quit
		}
		Set tMsg = ""
		If (""'=pSchemaBase) {
			Set $$$vaSchemaGbl(pSchemaName, "base") = pSchemaBase
		}
		If (""'=pDescription) {
			Set $$$vaSchemaDescGbl(pSchemaName) = pDescription
		}
		Set $$$vaSchemaGbl(pSchemaName, "time") = $ZTS
		Set ^EnsPortal.Settings($Username,"HL7","CurrentDrawSchema") = pSchemaName
	}
	Catch ex {
		Set tMsg = $$$Text("Error encountered in creating custom schema.")
	}
	If ..sourceControlEnabled {
		#; Only call OnSchemaSave if not errored
		If tMsg = "" Set tMsg = ..OnSchemaSave("after")
	}
	Set tSC2 = $$$AuditModifySchema("HL7 "_pSchemaName,"Created schema based on "_pSchemaBase_$S(tMsg'="":" (ERROR)",1:""))
	Quit tMsg
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Custom Schema Wizard","Ensemble")
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
	Quit $$$TextHTML("Create a new custom schema definition.")
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	return encodeURIComponent(this.retValue);
}

/// This callback is called when the user presses the OK button.
/// If this returns false, then the action is canceled.
ClientMethod ondialogFinish(action) As %Boolean [ Language = javascript ]
{
	try {
		var isValid = zenPage.validateAll();
		if (isValid) {
			var base = zen('baseSchemaName').getValue();
			var name = zen('txtSchema').getValue();
			var desc = zen('txtDescription').getValue();
			var msg = zenPage.OnWizardCompletion(base, name, desc);
			if (msg != '') {
				isValid = false;
			}
		}
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments);
		isValid = false;
	}

	this.retValue = [];
	if (isValid) {
		this.retValue = name;
		return true;
	}
	else {
		this.retValue = "";
		return false;
	}
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	Quit:$$$ISERR(tSC)
	
	If (..baseSchema '= "") {
		Set sel = ..%GetComponentById("baseSchemaName")
		Set sel.value = ..baseSchema
	}
	
	Quit $$$OK
}

/// Callback to return a list of resources required for a specific HyperEvent.
/// The user must have sufficient privileges on one of the resource/permission pairs
/// to be permitted to execute the hyperevent. An empty string implies the user already
/// has sufficient privileges for the ZenMethod specified in <var>pMethod</var>.
ClassMethod GetHyperEventResources(pMethod As %String = "") As %String
{
	Quit $case(pMethod,
					"OnWizardCompletion": ..#EDITRESOURCE,
					: "")
}

}
