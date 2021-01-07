/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7

Class EnsPortal.HL7.SchemaMessageType Extends EnsPortal.HL7.Template [ System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "HL7 Schema Message Type";

Parameter CSSINCLUDES = "ensemble/Ensemble_Wizards.css,ensemble/Ensemble_EDI.css";

Property mType As %String(ZENURL = "MT");

Property category As %String;

Property base As %String;

Property entity As %String;

Property scCategory As %String(MAXLEN = "") [ Calculated, Internal ];

Method scCategoryGet() As %String [ ServerOnly = 1 ]
{
	Quit ..category
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<hgroup valign="top">
<spacer width="20"/>
<html id="content" OnDrawContent="DrawContent"/>
<spacer width="20"/>
</hgroup>
</pane>
}

/// Draw main HTML content for this page.
Method DrawContent(pSeed As %String) As %Status
{
	set initialDesc =##class(EnsLib.HL7.Schema).GetDescription(..mType)
	set description=..EscapeHTML(initialDesc)
	/* not necessary to break the description text
	if ($L(description) > 35) {
		set breakPointPos = $find(description," ", 30)
		set description = $extract(description,1,(breakPointPos-1))_"<br>"_$extract(description,breakPointPos,$l(description))
	}
	*/
	Set tCat=$$$Text("Schema Category:")
	set catLink = ..Link("EnsPortal.HL7.SchemaMain.zen?CAT="_$$$URLENCODE(..category))
	Set tType = "Message Type:"
	Set tNone = $$$Text("(none)")

	&html<
		<div>
		<p>
		<i>#(tCat)# </i><b><a href="#(catLink)#">#($zconvert(..category,"O","HTML"))#</a></b><br/>
		<i>#(tType)# </i><b>#($zconvert(..entity,"O","HTML"))#</b>
		</p>
		<p>#($zconvert(..category_":"_..entity, "O","HTML"))# #(description)#</p>
		</div>
		<table class="tpTable" cellpadding="5" cellspacing="2">
	>

	If (..mType '= "") {
		
		// first row 
		
		&html<<tr class='tpOdd'><td class="label">#($$$Text("Message Structure"))#</td><td>>
		set ms=$get(^EnsHL7.Schema(..category,"MT",..entity))
		if ms="" set ms=..category_":"_$p(..entity,"_",1)
		&html<<a href='#(..Link("EnsPortal.HL7.SchemaDocumentStructure.cls?MS=MS:"_$$$URLENCODE(ms)))#'>#($zconvert(ms,"O","HTML"))#</a></td></tr>>
		
		// second row
		
		set altStruct=$g(^EnsHL7.Schema(..category,"MT",..entity,"altstruct"))
		&html<<tr class="tpEven"><td class="label">#($$$Text("Alternate Message Structure"))#</td>>
		if (altStruct="") {
			&html<<td>#(tNone)#</td></tr>>
		}
		else {
			&html<<td><a href='#(..Link("EnsPortal.HL7.SchemaDocumentStructure.cls?MS=MS:"_$$$URLENCODE(altStruct)))#'>#($zconvert(altStruct,"O","HTML"))#</a></td></tr>>
		}		
		
		// third row
		
		set retType=$g(^EnsHL7.Schema(..category,"MT",..entity,"rettype"))
		&html<<tr class="tpOdd"><td class="label">#($$$Text("Return Message Type"))#</td>>
		if (retType="") {
			&html<<td>#(tNone)#</td></tr>>
		}
		else {
			&html<<td><a href='#(..Link("EnsPortal.HL7.SchemaMessageType.cls?MT=MT:"_$$$URLENCODE(retType)))#'>#($zconvert(retType,"O","HTML"))#</a></td></tr>>
		}
	}
	&html<</table>>

	Quit $$$OK
}

ClientMethod doEdit() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }
	parms = {
		CAT : zenPage.category,
		BASE : zenPage.base,
		MT : zenPage.entity,
		TYPE : "edit" 
	}
	zenLaunchPopupWindow(zenLink('EnsPortal.HL7.Dialog.CustomMessageType.zen'),this.addPopupSuffix('HL7EditMessageType'),'status,scrollbars,resizable,width=700,height=650',parms);
}

ClientMethod doDelete() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }
	if (!confirm($$$FormatText($$$Text("Are you sure you want to delete message type %1 from schema category %2?"), zenPage.entity, zenPage.category))) {
		return;
	}
	msg = zenPage.DeleteType(zenPage.category, zenPage.entity);
	if (msg.length > 0) {
		alert(msg);
	}
	zenPage.gotoPage("EnsPortal.HL7.SchemaMain.zen?CAT=" + zenPage.category);
}

Method DeleteType(pSchema As %String, pMessageType As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	If '..canEdit Quit ..msgNotPermitted
	#dim tMsg = ""

	If ..sourceControlEnabled {

		If ..IsSchemaSCReadOnly() Quit ..msgSCReadOnly

		Set tMsg = ..OnSchemaSave("before")
		If tMsg '= "" Quit $$$FormatText($$$Text("Error calling source control OnBeforeSave for schema category %1. %2"),..scCategory, tMsg)

	}

	Set tKilled=$D($$$vaSchemaGbl(pSchema, "MT", pMessageType))
	Kill $$$vaSchemaGbl(pSchema, "MT", pMessageType)
	Kill $$$vaSchemaDescGbl(pSchema, "MT", pMessageType)


	If tKilled {
		Set $$$vaSchemaGbl(pSchema,"time")=$ZTS
		If ..sourceControlEnabled {
			Set tMsg = ..OnSchemaSave("after")
			If tMsg '= "" Set tMsg = $$$FormatText($$$Text("Error calling source control OnAfterSave for schema category %1. %2"),..scCategory, tMsg)
		}
		Set tSC2 = $$$AuditModifySchema("HL7 "_pSchema,"Deleted message type "_pMessageType)
		Quit tMsg
	}
	Quit $$$FormatText($$$Text("Could not find message type %1 to delete in schema category %2."), pMessageType, pSchema)
}

/// This client event, if present, is fired when the a popup page
/// launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if (action != "ok") {
		return false;
	}
	popupName = this.removePopupSuffix(popupName);
	switch(popupName) {
		case 'HL7EditMessageType':
			if (value.length > 0) { // format is "MT:schema:messageType"
				if ((value.charAt(0) == 'M') && (value.charAt(1) == 'T')) {
					zenPage.gotoPage("EnsPortal.HL7.SchemaMessageType.zen?MT=" + value);
				}
			}
			else {
				setTimeout('alert("' + $$$Text("Unable to save changes to custom message type.") + '");', 50);
			}
		break;
		case 'switchNamespace':
			zenPage.changeURLNamespace(value);
		break;
	}
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("HL7 Schema Message Type")
}

/// Get information to display in the ribbon bar (the Mac-like choice of UI).
/// For wizards this can simply return $$$OK.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String) As %Status
{
	If (##class(EnsPortal.HL7.Utils).IsCustomSchema($P(..mType,":",2))) {
		Set pDisplay = 1
		Set pSearchBox = 0
		Set pRibbonTitle = ..%OnGetPageName()

		// commands: $LB(id,caption,help,onclick)
		#dim tEditJSFunction = "zenPage.doEdit();"
		#dim tDeleteJSFunction = "zenPage.doDelete();"

		If ..canEdit && ..sourceControlEnabled && ..IsSchemaSCReadOnly() {
			Set tEditJSFunction = "zenPage.scDisabled();"
			Set tDeleteJSFunction = tEditJSFunction
		}

		Set pCommands(1) = $LB("cmdEdit",$$$Text("Edit"),$$$Text("Edit this custom schema message type"),tEditJSFunction)
		Set pCommands(2) = $LB("cmdDelete",$$$Text("Delete"),$$$Text("Delete this custom schema message type"),tDeleteJSFunction)
	}
	Quit $$$OK
}

/// Decorate the page.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	Quit:$$$ISERR(tSC)

	set ..category=$p(..mType,":",2)
	set ..entity=$p(..mType,":",3)
	set ..base=##class(EnsPortal.HL7.Utils).GetImmediateBaseSchema(..category)

	Quit tSC
}

/// Callback to return a list of resources required for a specific HyperEvent.
/// The user must have sufficient privileges on one of the resource/permission pairs
/// to be permitted to execute the hyperevent. An empty string implies the user already
/// has sufficient privileges for the ZenMethod specified in <var>pMethod</var>.
ClassMethod GetHyperEventResources(pMethod As %String = "") As %String
{
	Quit $case(pMethod,
					"DeleteType": ..#EDITRESOURCE,
					: "")
}

}
