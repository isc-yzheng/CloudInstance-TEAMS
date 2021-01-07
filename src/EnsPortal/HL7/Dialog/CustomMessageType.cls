/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsHL7)

/// Create a new production and add components to it.
Class EnsPortal.HL7.Dialog.CustomMessageType Extends EnsPortal.HL7.Dialog.standardDialog [ System = 4 ]
{

Parameter APPLYBUTTON = 0;

/// User needs WRITE permissions on the %Ens_EDISchema resource to view this page.
Parameter RESOURCE = "%Ens_EDISchema:WRITE";

Parameter PAGENAME = "Custom Message Type Wizard";

Parameter CSSINCLUDES = "ensemble/Ensemble_Wizards.css";

/// Schema being edited
Property category As %ZEN.Datatype.string(ZENURL = "CAT");

/// Immediate base schema of the schema being edited
Property baseSchema As %ZEN.Datatype.string(ZENURL = "BASE");

/// In schema:name form, the name of the base message structure to copy to create the custom message structure for the message type.
Property copyStruct As %ZEN.Datatype.string;

/// In schema:name form, the name of the base message structure to copy to create the custom alternate message structure for the message type.
Property copyStructAlt As %ZEN.Datatype.string;

/// In schema:name form, the name of the return message type
Property returnMT As %ZEN.Datatype.string;

/// Whether or not to create a new message structure for this message type.
Property createStruct As %ZEN.Datatype.boolean [ InitialExpression = 1 ];

/// Whether or not to create a new alternate message structure for this message type.
Property createAltStruct As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

/// The name of the message structure for the message type.
Property sendingName As %ZEN.Datatype.string;

/// The name of the alternate message structure for the message type.
Property alternateName As %ZEN.Datatype.string;

/// Name of the message type being edited. Provided only when caseType = "edit".
Property messageType As %ZEN.Datatype.string(ZENURL = "MT");

/// "newFromSchemaMain", "copyFromSchemaMain", and "edit" are the valid values. 
/// Identifies the context in which the dialog is being used.
Property caseType As %ZEN.Datatype.string(ZENURL = "TYPE");

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
<vgroup valign="top">
<label id="schemaLabel" enclosingClass="labelComment" label=""></label>
<label id="baseLabel" enclosingClass="labelComment" label=""></label>
<spacer height="10" />
</vgroup>
</hgroup>
<hgroup>
<spacer width="20" />
<vgroup enclosingClass="wizardBox" >
	<form name="customSchemaForm" id="customSchemaForm">
	  <spacer height="10" />
		<vgroup labelPosition="left">
		<combobox id="copyTypeName" name="copyTypeName" label="Message Type to Copy" editable="false" 
		    enclosingStyle="padding-bottom:4px;" size="47" labelClass="labelRequired" required="true" 
			title="Choose a message type to copy." hidden="true" onchange="zenPage.chooseCopyType();"
		/>
		<spacer height="10" />
		<text label="New Message Type Name" name="txtName" id="txtName" labelClass="labelRequired" value="" size="50"
			title="Enter a message type name in this field. Do not use any whitespace characters, or any punctuation characters including _ (underscore) or . (period) in the name. There is no need to provide a schema name with the message type name; the message type will be created in the current custom schema." />
		<spacer height="10" />
		<textarea label="Message Type Description" name="txtDescription" id="txtDescription" labelClass="labelNormal" value="" cols="39"
			title="Enter a description of the message type in this field."/>
		<spacer height="20" />
		<selector name="structureName" id="structureName" label="Message Structure" 
		    enclosingStyle="padding-bottom:4px;" size="47" labelClass="labelRequired" required="true" 
			title="Choose or enter a name for the sending message structure. Do not use any whitespace characters, or any punctuation characters other than _ (underscore) or . (period) in the name. It is not necessary to enter the schema name, but if you do, use () (parentheses) around the schema name."
		    multiSelect="false" context="" 
		      /> 
		<hgroup id="createStructureGroup">
		<checkbox id="createStructure" value="1" label=""/>
		<html enclosingClass="labelComment">Create this message structure in the Custom Schema if it does not exist there already</html>
		</hgroup>
		<spacer height="20" />
		<selector name="altStructureName" id="altStructureName" label="Alternate Message Structure" 
		    enclosingStyle="padding-bottom:4px;" size="47" labelClass="labelNormal" 
			title="Choose an alternate message if more than one structure allowed.  You may leave this field blank." 
		    multiSelect="false" context="" 
	     	 /> 
		<hgroup id="createAltStructureGroup">
		<checkbox id="createAltStructure" value="1" label=""/>
		<html enclosingClass="labelComment">Create this message structure in the Custom Schema if it does not exist there already</html>
		</hgroup>
		<spacer height="20" />
		<combobox id="rettypeName" name="rettypeName" label="Returning Message Type" editable="true" unrestricted="true" 
		    enclosingStyle="padding-bottom:4px;" size="47" labelClass="labelNormal" 
			title="Choose a returning message type. You may leave this field blank."
		/>
		<spacer height="10" />
	</vgroup>
</form>
</vgroup>
<spacer width="20" />
<vgroup valign="top">
<spacer height="40" />
<label id="helpSubject" enclosingClass="labelComment" label="Use this form to create or edit a custom message type." />
<spacer height="10" />
<label id="helpHover" enclosingClass="labelComment" label="For help with any field in this form, hover the cursor over the field name." />
</vgroup>
</hgroup>
</pane>
}

ClientMethod chooseCopyType() [ Language = javascript ]
{
	copyType = zen('copyTypeName').getValue();
	if ((copyType.length > 0) && (copyType.match(' ') == ' ')) {
		var temp = copyType.split(' ');
		var copyMTSchema = temp[1].substring(1, temp[1].length - 1);
		var copyMTName = temp[0];
		var val = zenPage.GetMessageTypeUpdateFromServer(copyMTSchema, copyMTName);
		var value = val.split(';'); // [0] sending message structure [1] returning message type [2] description [3] alternate message structure
		var firstMS = zen('structureName');
		temp = value[0].split(':');
		firstMS.setValue(temp[1]);
		firstMS.setHidden(false);
		var altMS = zen('altStructureName');
		var newVal = value[3];
		if ((newVal.length > 0) && (newVal.match(":") == ":")) {
			temp = newVal.split(':');
			altMS.setValue(temp[1]);
		} else {
			altMS.setValue("");
		}
		altMS.setHidden(false);
		var secondMT = zen('rettypeName');
		newVal = value[1];
		if ((newVal.length > 0) && (newVal.match(":") == ":")) {
			temp = newVal.split(':');
			secondMT.setValue(temp[1] + " (" + temp[0] + ")");
		}
		else {
			secondMT.setValue("");
		}
		secondMT.setHidden(false);
		var desc = zen('txtDescription');
		desc.setValue(value[2]);
		desc.setHidden(false);
		txt = zen('txtName');
		txt.setValue(copyMTName);
		txt.setHidden(false);
		zen('createAltStructureGroup').setHidden(false);
		zen('createStructureGroup').setHidden(false);
	}
	else {
		alert('Please choose a message type to copy.');
	}
}

ClientMethod validateAll() [ Language = javascript ]
{
	var ok = true;
	var note = false;
	var msg = '';
	var noteMsg = [];
	var noteMsgCount = 0;
	var list = '';
	var temp = '';
	var val = '';
	var tempNoteMsg = '';

	// validate the copy message type if it is there
	if (zenPage.caseType.match('copy') == 'copy') {
		temp = zen('copyTypeName').getValue();
		if (temp.length <= 0) {
			msg += ('  ' + $$$Text("You must choose a message type to copy.") + '\n');
			ok = false;
		}
	}

	if (ok) {
		// get the new message type
		var firstMT = zen('txtName').getValue();
		temp = firstMT.replace(/^\s+|\s+$/g, "");	
		temp = temp.replace(/^\t+|\t+$/g, "");
		if (temp.length != firstMT.length) {
			firstMT = temp;
			zen('txtName').setValue(firstMT);
		}

		// get the first message structure
		var firstMS = zen('structureName').getValue();
		temp = firstMS.replace(/^\s+|\s+$/g, "");	
		temp = temp.replace(/^\t+|\t+$/g, "");
		if (temp.length != firstMS.length) {
			firstMS = temp;
			zen('structureName').setValue(firstMS);
		}
		
		// get the alternate message structure
		var altMS = zen('altStructureName').getValue();
		temp = altMS.replace(/^\s+|\s+$/g, "");	
		temp = temp.replace(/^\t+|\t+$/g, "");
		if (temp.length != altMS.length) {
			altMS = temp;
			zen('altStructureName').setValue(altMS);
		}
		
		// get the return message type
		var secondMT = zen('rettypeName').getValue();
		temp = secondMT.replace(/^\s+|\s+$/g, "");	
		temp = temp.replace(/^\t+|\t+$/g, "");
		if (temp.length != secondMT.length) {
			secondMT = temp;
			zen('rettypeName').setValue(secondMT);
		}

		// will we be creating a new message structure?
		var boxChecked = zen('createStructure').getValue();
		var altBoxChecked = zen('createAltStructure').getValue();
	
		// separate out the new message type schema and name, if a schema is provided to mimic our drop-downs
		var firstMTName = zenPage.sortOutEntityName(firstMT, $$$Text("Too many space characters in the new message type name."));
	
		// separate out the message structure schema and name, if a schema is provided to mimic our drop-downs
		var firstMSName = zenPage.sortOutEntityName(firstMS, $$$Text("Too many space characters in the sending message structure name."));
	
		// separate out the message structure schema and name, if a schema is provided to mimic our drop-downs
		var altMSName = zenPage.sortOutEntityName(altMS, $$$Text("Too many space characters in the alternate message structure name."));
		
		// get validation values from the server (combine in one call, returns a comma and semi-colon separated string)
		var val = zenPage.GetValidationDataFromServer(zenPage.category, firstMTName, firstMSName, altMSName);
		var valid = val.split(";");
	
		// validate the new message type
		var len = firstMTName.length;
		if (len <= 0) {
			msg += ('  ' + $$$Text("You have not entered a new message type name."));
			msg += (' ' + $$$Text("For the new message type name, do not use any whitespace characters, or any punctuation characters other than _ (underscore) or . (period).") + '\n');
			ok = false;
		}
		else {
			if (firstMTName.match(/[`~@#$%^&*()-+={}\[\]|\\:;"'<,>?\/]/) || firstMTName.match(/\s/) || firstMTName.match(/\t/)) {
				msg += ('  ' +  $$$Text("For the new message type name, do not use any whitespace characters, or any punctuation characters other than _ (underscore) or . (period).") + '\n');
				ok = false;
			}
			else {
				// does the proposed new message type already exist in the schema?
				if (valid[0] == "1") {
					if ((zenPage.caseType == "newFromSchemaMain") || (zenPage.caseType == "copyFromSchemaMain")) { 
						msg += ('  ' + $$$FormatText($$$Text("The specified new message type %2 already exists in the custom schema %1. If you want to create a new message type, use a different name."),zenPage.category,firstMTName));
						msg += (' ' + $$$FormatText($$$Text("If you want to edit the message type %1, dismiss this message, click Cancel in this dialog, click through to the message type description, and click Edit."),firstMTName) + '\n');
						ok = false;
					}
				}
			}
		}
	
		// validate the first message structure 
		len = firstMSName.length;
		if (len <= 0) {
			msg += ('  ' + $$$Text("You have not entered a sending message structure name. Do not use any whitespace characters, or any punctuation characters other than _ (underscore) or . (period)."));
			msg += (' ' + $$$Text("It is not necessary to enter the schema name, but if you do, use () (parentheses) around the schema name as shown in the list.") + '\n');
			ok = false;
		}
		else {
			if (firstMSName.match(/[`~@#$%^&*()-+={}\[\]|\\;"'<,>?\/]/) || firstMSName.match(/\s/) || firstMSName.match(/\t/)) {
				msg += ('  ' + $$$Text("For the sending message structure name, do not use any whitespace characters, or any punctuation characters other than _ (underscore) or . (period)."));
				msg += (' ' + $$$Text("It is not necessary to enter the schema name, but if you do, use () (parentheses) around the schema name as shown in the list.") + '\n');
				ok = false;
			}
			else {
				zenPage.sendingName = firstMSName;
				if (boxChecked) { // box is checked
					if (valid[1].length <= 0) { // requested structure is nowhere in schema inheritance tree
						zenPage.createStruct = true;
						zenPage.copyStruct = "";
						noteMsg[noteMsgCount] = ('  ' + $$$FormatText($$$Text("Because you checked the box, a new message structure %1 will be created in the custom schema %2 and will be used as the sending message structure. Is this OK?" + '\n'), zenPage.sendingName, zenPage.category));
						note = true;
						noteMsgCount++;
					}
					else { // a version of the requested structure has turned up in the tree
						zenPage.copyStruct = valid[1];
						temp = valid[1].split(':');
						if (temp[0] == zenPage.category) { // it's already in the custom schema
							zenPage.createStruct = false;
							noteMsg[noteMsgCount] = ('  ' + $$$FormatText($$$Text("Although you checked the box, the sending message structure %1 already exists in the custom schema %2. It will not be recreated. Is this OK?" + '\n'), zenPage.sendingName, zenPage.category));
							note = true;
							noteMsgCount++;
						}
						else { // something to create in the custom schema
							zenPage.createStruct = true;
							tempNoteMsg = ('  ' + $$$FormatText($$$Text("Because you checked the box, a new message structure %1 will be created in the custom schema %2 and will be used as the sending message structure."),zenPage.sendingName,zenPage.category));
							tempNoteMsg += (' ' + $$$FormatText($$$Text("It will copy its structure from %1 in the %2 schema. Is this OK?"), temp[1], temp[0]) + '\n');
							noteMsg[noteMsgCount] = tempNoteMsg;
							note = true;
							noteMsgCount++;
						}
					}
				}
				else { // box is not checked
					zenPage.createStruct = false;
					if (valid[1].length <= 0) { // requested structure is nowhere in schema inheritance tree
						zenPage.copyStruct = "";
						msg += ('  ' + $$$FormatText($$$Text("The sending message structure %1 is not found in the custom schema %2 or any of its base schemas."), zenPage.sendingName, zenPage.category) + '\n');
						ok = false;
					}
					else { // a version of the requested structure has turned up in the tree
						zenPage.copyStruct = valid[1];
						temp = valid[1].split(':');
						noteMsg[noteMsgCount] = ('  ' + $$$FormatText($$$Text("The message structure %1 from the schema category %2 will be used as the sending message structure. Is this OK?"), temp[1], temp[0]) + '\n');
						note = true;
						noteMsgCount++;
					}
				}
			}
		}
		
		// validate the alternate message structure if it has been set
		if (altMSName.length > 0) {
			if (altMSName.match(/[`~@#$%^&*()-+={}\[\]|\\;"'<,>?\/]/) || altMSName.match(/\s/) || altMSName.match(/\t/)) {
				msg += ('  ' + $$$Text("For the alternate message structure name, do not use any whitespace characters, or any punctuation characters other than _ (underscore) or . (period)."));
				msg += (' ' + $$$Text("It is not necessary to enter the schema name, but if you do, use () (parentheses) around the schema name as shown in the list.") + '\n');
				ok = false;
			}
			else {
				zenPage.alternateName = altMSName;
				if (altBoxChecked) { // box is checked
					if (valid[2].length <= 0) { // requested structure is nowhere in schema inheritance tree
						zenPage.createAltStruct = true;
						zenPage.copyStructAlt = "";
						noteMsg[noteMsgCount] = ('  ' + $$$FormatText($$$Text("Because you checked the box, a new message structure %1 will be created in the custom schema %2 and will be used as the alternate message structure. Is this OK?" + '\n'), zenPage.alternateName, zenPage.category));
						note = true;
						noteMsgCount++;
					}
					else { // a version of the requested structure has turned up in the tree
						zenPage.copyStructAlt = valid[2];
						temp = valid[2].split(':');
						if (temp[0] == zenPage.category) { // it's already in the custom schema
							zenPage.createAltStruct = false;
							noteMsg[noteMsgCount] = ('  ' + $$$FormatText($$$Text("Although you checked the box, the alternate message structure %1 already exists in the custom schema %2. It will not be recreated. Is this OK?" + '\n'), zenPage.alternateName, zenPage.category));
							note = true;
							noteMsgCount++;
						}
						else { // something to create in the custom schema
							zenPage.createAltStruct = true;
							tempNoteMsg = ('  ' + $$$FormatText($$$Text("Because you checked the box, a new message structure %1 will be created in the custom schema %2 and will be used as the alternate message structure."),zenPage.alternateName,zenPage.category));
							tempNoteMsg += (' ' + $$$FormatText($$$Text("It will copy its structure from %1 in the %2 schema. Is this OK?"), temp[1], temp[0]) + '\n');
							noteMsg[noteMsgCount] = tempNoteMsg;
							note = true;
							noteMsgCount++;
						}
					}
				}
				else { // box is not checked
					zenPage.createAltStruct = false;
					if (valid[2].length <= 0) { // requested structure is nowhere in schema inheritance tree
						zenPage.copyStructAlt = "";
						msg += ('  ' + $$$FormatText($$$Text("The alternate message structure %1 is not found in the custom schema %2 or any of its base schemas."), zenPage.alternateName, zenPage.category) + '\n');
						ok = false;
					}
					else { // a version of the requested structure has turned up in the tree
						zenPage.copyStructAlt = valid[2];
						temp = valid[2].split(':');
						noteMsg[noteMsgCount] = ('  ' + $$$FormatText($$$Text("The message structure %1 from the schema category %2 will be used as the alternate message structure. Is this OK?"), temp[1], temp[0]) + '\n');
						note = true;
						noteMsgCount++;
					}
				}
			}
		}
	
		// validate the return message type if it has been set
		if (secondMT.length > 0) {
			if (secondMT.match(' ') == ' ') {
				var temp = secondMT.split(' ');
				if (temp.length > 2) {
					msg += ('  ' + $$$Text("Too many space characters in the return message type name.") + '\n');
					ok = false;
				} else if ((temp.length == 2) && (temp[1].charAt(0) == '(') && (temp[1].charAt(temp[1].length - 1) == ')')) { // our drop-down, or user mimicked our drop-downs
					var secondMTSchema = temp[1].substring(1, temp[1].length - 1);
					var secondMTName = temp[0];
				} else {
					var secondMTName = secondMT;
				}
			} else {
				var secondMTName = secondMT;
				var secondMTSchema = zenPage.category;
			}
		}
		if (secondMTName) {			
			if (secondMTName.match(/[`~@#$%^&*()-+={}\[\]|\\:;"'<,>?\/]/) || secondMTName.match(/\s/) || secondMTName.match(/\t/)) {
				msg += ('  ' +  $$$Text("For the return message type name, do not use any whitespace characters, or any punctuation characters other than _ (underscore) or . (period)."));
				msg += (' ' + $$$Text("It is not necessary to enter the schema name, but if you do, use () (parentheses) around the schema name as shown in the list.") + '\n');
				ok = false;
			} else {
				var retMT = zenPage.ValidateReturnMT(secondMTSchema, secondMTName);
				if (retMT != "") {
					zenPage.returnMT = retMT;
				} else {
					msg += ('  '+ $$$FormatText($$$Text("The return message type %1 is not found in schema %2 or any of its base schemas."), secondMTName,secondMTSchema) + '\n');
					ok = false;
				}
			}
		} else {
			zenPage.returnMT = "";
		}
	}
	
	// finish up
	if (ok) {
		if (note) {
			for (var i=0;i<noteMsgCount;i++) {
				if (!confirm($$$Text("NOTE: ") + '\n' + noteMsg[i])) {
					return false;
				}
			}
		}
	}
	else {
		msg = $$$Text("ERRORS:") + '\n' + msg 
			  + ('\n' + $$$Text("NOTE: Because there were errors, your changes have not been saved.") + ' ' 
		      + $$$Text("To save your work, click OK in this alert box, correct the reported problems, and then click OK in the dialog.")
		      + '\n');
		alert(msg);
	}
	
	return ok;
}

ClientMethod sortOutEntityName(name, msg) [ Language = javascript ]
{
	if (name.match(' ') == ' ') {
		var temp = name.split(' ');
		if (temp.length > 2) {
			msg += ('  ' + msg + '\n');
			ok = false;
		}
		else if ((temp.length == 2) &&
				(temp[1].charAt(0) == '(') && 
				(temp[1].charAt(temp[1].length - 1) == ')')) { // our drop-down, or user mimicked our drop-downs
					return (temp[0]);
				}
		else {
			return (name);
		}
	}
	else {
		return (name);
	}
}

/// Get all the necessary data about the message type from the server in one call and use it later.
/// <p>
/// Here is the format of the comma and semi-colon separated string (values shown in angle brackets which are not really there): <br/>
/// <sending message structure in schema:name form>;<br/>
/// <returning message type in schema:name form>;<br/>
/// <description>;<br/>
/// <alternate message structure in schema:name form>
ClassMethod GetMessageTypeUpdateFromServer(pCustomSchema As %String, pMessageType As %String) As %String [ ZenMethod ]
{
	Set tMsg = ""
	Try {
		Set tRet = $G($$$vaSchemaGbl(pCustomSchema, "MT", pMessageType),"")
		Set tMsg = tRet
		Set tRet = $G($$$vaSchemaGbl(pCustomSchema, "MT", pMessageType, "rettype"),"")
		Set tMsg = tMsg _ ";" _ tRet
		Set tRet = ##class(EnsLib.HL7.Schema).GetDescription("MT:"_pCustomSchema_":"_pMessageType)
		Set tMsg = tMsg _ ";" _ tRet
		Set tRet = $G($$$vaSchemaGbl(pCustomSchema, "MT", pMessageType, "altstruct"))
		Set tMsg = tMsg _ ";" _ tRet
	}
	Catch (ex) {
	}
	Quit tMsg
}

/// Get all the necessary data from the server in one call and use it later.
/// pCustomSchema and pNewMT are without prefix or suffix. pFirstMS and pSecondMT are in the form schema:name.
/// <p>
/// Here is the format of the comma separated string (values shown in angle brackets which are not really there): <br/>
/// <is pNewMT existing in pCustomSchema>;<br/>
/// <what is the most custom version of the entity named pFirstMSName relative to the pCustomSchema (this return value is in the form schema:name)>;<br/>
/// <what is the most custom version of the entity named pAltMSName relative to the pCustomSchema (this return value is in the form schema:name)>
ClassMethod GetValidationDataFromServer(pCustomSchema As %String, pNewMT As %String, pFirstMSName As %String, pAltMSName As %String = "") As %String [ ZenMethod ]
{
	Set tMsg = ""
	Try {
		Set tRet = ##class(EnsPortal.HL7.Utils).SchemaEntityAlreadyExists(pCustomSchema, pNewMT, "MT")
		Set tMsg = tRet 
		Set tRet = ##class(EnsPortal.HL7.Utils).GetMostCustomSchemaEntity(pCustomSchema, pFirstMSName, "MS")
		Set tMsg = tMsg _ ";" _ tRet
		If pAltMSName'="" {
			Set tRet = ##class(EnsPortal.HL7.Utils).GetMostCustomSchemaEntity(pCustomSchema, pAltMSName, "MS")
			Set tMsg = tMsg _ ";" _ tRet
		}
	}
	Catch (ex) {
	}
	Quit tMsg
}

/// Check to make sure that the message type <var>pRetMTName</var> is defined in the schema <var>pSchemaName</var> or one of its base schemas.
/// For message types beginning with "ACK_", it is enough for message type ACK to be defined in the schema.  Returns the message type in
/// schema:name format if found or empty string otherwise
ClassMethod ValidateReturnMT(pSchemaName As %String, pRetMTName As %String) As %String [ ZenMethod ]
{
	Set tRetType = ""
	Try {
		Set tBase=pSchemaName
		Set tBase(tBase)=1
		While (""'=tBase) && '$D($$$vaSchemaGbl(tBase,"MT",pRetMTName)) && (("ACK_"'=$E(pRetMTName,1,4)) || '$D($$$vaSchemaGbl(tBase,"MT","ACK"))) {
			set tBase=$G($$$vaSchemaGbl(tBase,"base"))
			#; prevent circular references
			If (""=tBase)||$D(tBase(tBase)) {
				Set tBase=""
				Quit
			}
			Set tBase(tBase)=1
		}
		If ""'=tBase {
			Set tRetType = tBase_":"_pRetMTName
		}

	} Catch (ex) {
	}
	Quit tRetType
}

/// This method is invoked when the user completes the Wizard pressing "OK".
/// Returns a null string if it succeeds, or an error message otherwise.
/// pCopyStructure, pCopyStructureAlt, and pReturnType are in schema:name format.
Method OnWizardCompletion(pSchemaName As %String, pNewTypeName As %String, pDescription As %String, pSendingName As %String, pCreateStructure As %Boolean, pCopyStructure As %String, pReturnType As %String, pAltStructName As %String, pCreateAltStructure As %Boolean, pCopyStructureAlt As %String) As %String [ ZenMethod ]
{
	If '..canEdit Quit ..msgNotPermitted

	If ..sourceControlEnabled && ..IsSchemaSCReadOnly() Quit ..msgSCReadOnly

	Set tMsg = ""
	Try {
		If ..sourceControlEnabled {
			Set tMsg = ..OnSchemaSave("before")
			If tMsg '= "" Quit
		}

		Set tLevelStart = $TLEVEL
		Set tSendingStructure = ""
		If (pCreateStructure) {
			TSTART
			If (""=pCopyStructure) {
				Set $$$vaSchemaGbl(pSchemaName, "MS", pSendingName) = ##class(EnsLib.HL7.SchemaXML).addDefaultCategory("MSH",pSchemaName,"SS",.tSC,$$$Text("Custom Schema Editor"))
				Set tSendingStructure = pSchemaName _ ":" _ pSendingName
			}
			Else {
				Set tCopySchema = $P(pCopyStructure, ":", 1)
				Set tCopyName = $P(pCopyStructure, ":", 2)
				Set $$$vaSchemaDescGbl(pSchemaName, "MS", tCopyName) = $G($$$vaSchemaDescGbl(tCopySchema, "MS", tCopyName))
				
				Set definition = $G($$$vaSchemaGbl(tCopySchema, "MS", tCopyName))
				Set $$$vaSchemaGbl(pSchemaName, "MS", tCopyName)=##class(EnsLib.HL7.SchemaXML).addDefaultCategory(definition,pSchemaName,"SS",.tSC,$$$Text("Custom Schema Editor"))
				
				Set tSendingStructure = pSchemaName _ ":" _ tCopyName
			}
			If $$$ISERR(tSC) {
				Set tMsg = $$$FormatText($$$Text("Unable to store modifications to %1 schema due to error: %2"), pSchemaName, $$$StatusDisplayString(tSC))
				TROLLBACK
				Quit
			} Else {
				TCOMMIT
			}
		}
		Else {
			If (""=pCopyStructure) { // this case was flagged by validation as an error, so should not occur
			}
			Else {
				Set tSendingStructure = pCopyStructure
			}
		}
		Set tAltStructure = ""
		If pAltStructName '= "" {
			If (pCreateAltStructure) {
				TSTART
				If (""=pCopyStructureAlt) {
					Set $$$vaSchemaGbl(pSchemaName, "MS", pAltStructName) = ##class(EnsLib.HL7.SchemaXML).addDefaultCategory("MSH",pSchemaName,"SS",.tSC,$$$Text("Custom Schema Editor"))
					Set tAltStructure = pSchemaName _ ":" _ pAltStructName
				}
				Else {
					Set tCopySchemaAlt = $P(pCopyStructureAlt, ":", 1)
					Set tCopyNameAlt = $P(pCopyStructureAlt, ":", 2)
					Set $$$vaSchemaDescGbl(pSchemaName, "MS", tCopyNameAlt) = $G($$$vaSchemaDescGbl(tCopySchemaAlt, "MS", tCopyNameAlt))
					
					Set definition = $G($$$vaSchemaGbl(tCopySchemaAlt, "MS", tCopyNameAlt))
					Set $$$vaSchemaGbl(pSchemaName, "MS", tCopyNameAlt)=##class(EnsLib.HL7.SchemaXML).addDefaultCategory(definition,pSchemaName,"SS",.tSC,$$$Text("Custom Schema Editor"))
					
					Set tAltStructure = pSchemaName _ ":" _ tCopyNameAlt
				}
				If $$$ISERR(tSC) {
					Set tMsg = $$$FormatText($$$Text("Unable to store modifications to %1 schema due to error: %2"), pSchemaName, $$$StatusDisplayString(tSC))
					TROLLBACK
					Quit
				} Else {
					TCOMMIT
				}
			}
			Else {
				If (""'=pCopyStructureAlt) {
					Set tAltStructure = pCopyStructureAlt
				}
			}
		}
		
		If (pCreateStructure || pCreateAltStructure) {
			Do ##class(EnsLib.HL7.Schema).BuildCategoryMaps(pSchemaName)
			
		}
		Set $$$vaSchemaGbl(pSchemaName, "MT", pNewTypeName) = tSendingStructure
		Set:""'=tAltStructure $$$vaSchemaGbl(pSchemaName, "MT", pNewTypeName, "altstruct") = tAltStructure
		Set:""'=pReturnType $$$vaSchemaGbl(pSchemaName, "MT", pNewTypeName, "rettype") = pReturnType
		Set:""'=pDescription $$$vaSchemaDescGbl(pSchemaName, "MT", pNewTypeName) = pDescription
		Set $$$vaSchemaGbl(pSchemaName, "time") = $ZTS
	}
	Catch ex {
		If ($G(tLevelStart)'="")&&($TLEVEL > tLevelStart) {
			TROLLBACK
		}
		Set tMsg = $$$Text("Error encountered in creating a custom message type.")
	}

	If ..sourceControlEnabled {
		#; Only call OnSchemaSave if not errored
		If tMsg = "" Set tMsg = ..OnSchemaSave("after")
	}

	Set tSC2 = $$$AuditModifySchema("HL7 "_pSchemaName,"Saved messsage type "_pNewTypeName_$S(tMsg'="":" (ERROR)",1:""))
	Quit tMsg
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Custom Message Type Wizard","Ensemble")
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
	Quit $$$TextHTML("Create a custom message type definition")
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
			var name = zen('txtName').getValue().split(' ')[0];
			var desc = zen('txtDescription').getValue();
			var msg = zenPage.OnWizardCompletion(zenPage.category, name, desc, zenPage.sendingName, zenPage.createStruct, zenPage.copyStruct, zenPage.returnMT, zenPage.alternateName, zenPage.createAltStruct, zenPage.copyStructAlt);
			if (msg != '') {
				alert(msg);
				isValid = false;
			}
		}
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments);
	}

	this.retValue = [];
	if (isValid) {
		// set up for redisplaying the page
		if ((zenPage.caseType == "newFromSchemaMain") || (zenPage.caseType == "copyFromSchemaMain")) {
			this.retValue = zenPage.category;
		}
		else {
			this.retValue = "MT:" + zenPage.category + ":" + name; 
		}
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
	
	Set label = ..%GetComponentById("schemaLabel")
	Set label.label = $$$FormatText($$$Text("Custom Schema Category %1"), ..category)
	
	Set label = ..%GetComponentById("baseLabel")
	Set label.label = $$$FormatText($$$Text("Base Schema Category %1"), ..baseSchema)
	
	Set selMS = ..%GetComponentById("structureName")
	Set selMS.context = "EnsLib.HL7.ContextSearch/MessageStructures?cat=" _ ..category
	
	Set selAltMS = ..%GetComponentById("altStructureName")
	Set selAltMS.context = "EnsLib.HL7.ContextSearch/MessageStructures?cat=" _ ..category
	
	Set selMT = ..%GetComponentById("rettypeName")
	Do ..SetUpSchemaComboboxList(selMT, ..category, "EnsLib.HL7.Message:EnumerateMessageTypes", "Type", 1)
	
	If (..caseType [ "new") {
		Set tString = ##class(EnsPortal.HL7.Utils).GetMostCustomSchemaEntity(..category, "ACK", "MT")
		Set selMT.value = $P(tString, ":", 2) _ " (" _ $P(tString, ":", 1) _ ")"
	}
	ElseIf (..caseType = "edit") {
		If (..messageType '= "") {
			Set txtName = ..%GetComponentById("txtName")
			Set txtName.value = ..messageType
			Set txtName.label = "Message Type Name"
			Set txtName.title = "This is the name of the message type being edited."
			Set txtName.readOnly = 1
			Set txtName.disabled = 1
			If ($D($$$vaSchemaGbl(..category, "MT", ..messageType),tString)) {
				Set selMS.value = $P(tString, ":", 2) _ " (" _ $P(tString, ":", 1) _ ")"
			}
			If ($D($$$vaSchemaGbl(..category, "MT", ..messageType, "altstruct"),tString)) {
				If (tString '= "") {
					Set selAltMS.value = $P(tString, ":", 2) _ " (" _ $P(tString, ":", 1) _ ")"
				}
			}
			If ($D($$$vaSchemaGbl(..category, "MT", ..messageType, "rettype"),tString)) {
				If (tString = "") {
					Set selMT.value = ""
				} Else {
					Set selMT.value = $P(tString, ":", 2) _ " (" _ $P(tString, ":", 1) _ ")"
				}
			}
			Set tDesc = ##class(EnsLib.HL7.Schema).GetDescription("MT:"_..category_":"_..messageType)
			If "" '= tDesc {
				Set txtDesc = ..%GetComponentById("txtDescription")
				Set txtDesc.value = tDesc
			}
		}
	}
	ElseIf (..caseType [ "copy") {
		Set selCopy = ..%GetComponentById("copyTypeName")
		Do ..SetUpSchemaComboboxList(selCopy, ..category, "EnsLib.HL7.Message:EnumerateMessageTypes", "Type", 0)
		Set selCopy.hidden = 0
		Set txtName = ..%GetComponentById("txtName")
		Set txtName.hidden = 1
		Set txtDesc = ..%GetComponentById("txtDescription")
		Set txtDesc.hidden = 1
		Set createGrp = ..%GetComponentById("createStructureGroup")
		Set createGrp.hidden = 1
		Set createAltGrp = ..%GetComponentById("createAltStructureGroup")
		Set createAltGrp.hidden = 1
		Set selMS.hidden = 1
		Set selAltMS.hidden = 1
		Set selMT.hidden = 1
	}

	Quit $$$OK
}

Method SetUpSchemaComboboxList(pCombo As %ZEN.Component.combobox, pCategory As %String, pQuery As %String, pColumn As %String, pBlankChoice As %Boolean)
{
	Set tList = ##class(EnsPortal.HL7.Utils).GetSchemaInheritanceList(pCategory)
	Set tRS = ##class(%ResultSet).%New(pQuery)
	Do tRS.Execute()
	While (tRS.Next()) {
		Set tDoc = tRS.Data(pColumn)
		Set tPrefix = $P(tDoc, ":", 1)
		Set tName = $P(tDoc, ":", 2)
		Set foundNew = 0
		For i=1:1:$L(tList, ",") {
			If (foundNew)  Quit
			If (tPrefix = $P(tList, ",", i)) { // see if the prefix indicates a schema we are interested in
				Set foundNew = 1
				Set indexNew = i
				If ($D(tArray(tName))) { // there is an existing entry for this message type
					Set foundOld = 0
					For j=1:1:$L(tList, ",") { // see if we want to replace an existing entry with this new one
						If (foundOld) Quit
						If ($G(tArray(tName)) = $P(tList, ",", j)) {
							Set foundOld = 1
							Set indexOld = j
						}
					}
					If (indexOld > indexNew) { // use the more "custom" custom schema in the hierarchy
						Set tArray(tName) = tPrefix
					}
				}
				Else { // there was no existing entry so use this one
					Set tArray(tName) = tPrefix
				}
			}
		}
	}
	If (pBlankChoice) {
		Set tOption = ##class(%ZEN.Auxiliary.option).%New()
		Do pCombo.options.Insert(tOption)
		Do ..%AddComponent(tOption)
		Set tOption.text = "" 
		Set tOption.value = ""
	}
	Set tNext = ""
	For { 
		Set tNext = $O(tArray(tNext), 1, tValue)  Quit:tNext=""
		Set tOption = ##class(%ZEN.Auxiliary.option).%New()
		Do pCombo.options.Insert(tOption)
		Do ..%AddComponent(tOption)
		Set tOption.text = tNext _ " (" _ tValue _ ")" 
		Set tOption.value = tNext _ " (" _ tValue _ ")"
	}
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
