/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7

Class EnsPortal.HL7.SchemaCodeTable Extends EnsPortal.HL7.Template [ System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "HL7 Code Table";

Parameter CSSINCLUDES = "ensemble/Ensemble_Wizards.css,ensemble/Ensemble_EDI.css";

Property cTable As %String(MAXLEN = "", ZENURL = "CT");

Property scCategory As %String(MAXLEN = "") [ Calculated, Internal ];

Method scCategoryGet() As %String [ ServerOnly = 1 ]
{
	Quit $P(..cTable,":",2)
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
	Set category = $P(..cTable,":",2)
	Set structname = $P(..cTable,":",3)
	If ((category'="")&&(structname'="")) {
		If '$D($$$vaSchemaDescGbl(category,"CT",structname)) {
			Quit ..DrawError(..cTable)
		}
		Set description=..EscapeHTML($G($$$vaSchemaDescGbl(category,"CT",structname)))
		Set type=$G($$$vaSchemaGbl(category,"CT",structname))
		Set lblType = $$$Text("Type")
		Set annotate = $Case(type
				, 1:$$$Text("user")
				, 2:$$$Text("HL7")
				, 3:$$$Text("HL7 and user")
				, 4:$$$Text("no longer used")
				, 5:$$$Text("replaced")
				, 6:$$$Text("user group/national defined")
				, :$$$Text("unknown"))

		Set catLink = ..Link("EnsPortal.HL7.SchemaMain.zen?CAT="_$$$URLENCODE(category))

		&html<
		<div>
		<p>
		<i>#($$$Text("Schema Category:"))# </i><b><a href="#(catLink)#">#($zconvert(category,"O","HTML"))#</a></b><br/>
		<i>#($$$Text("Code Table:"))# </i><b>#($zconvert(structname,"O","HTML"))#</b><br/>
		<i>#($$$Text("Description:"))# </i><b>#($G(description))#</b><br/>
		<i>#($$$Text("Type:"))# </i><b>#(type)#</b> (#(annotate)#)
		</p>
		</div>
		<table class="tpTable" cellpadding=4 cellspacing=2>
		<tr><th>#($$$Text("Code"))#</th><th>#($$$Text("Meaning"))#</th></tr>
		>
		Kill indexed
		Set one=""  For { Set one=$O($$$vaSchemaGbl(category,"CT",structname,one))  Quit:one=""
			Set indexed($$$vaSchemaGbl(category,"CT",structname,one))=one
		}
		If '$D(indexed) {
			&html<<tr class="tpEven"><td class="csetName">...</td><td>#($$$Text("No suggested values"))#</td></tr>>
		} Else {
			Set rownum=1
			Set i=""  For { Set i=$O(indexed(i))  Quit:i=""
				set description=..EscapeHTML($G($$$vaSchemaDescGbl(category,"CT",structname,indexed(i))))
				set showDesc = $S(description="":"&nbsp;",1:description)

				#; Make sure that the showDesc is not too long; 88 chars is a good length for one line; put in line breaks if it's too long
				Set showDesc = ..putCarriageReturnsIn(showDesc)

				Set rowClass=$S(rownum#2:"tpOdd",1:"tpEven")
				&html<<tr class="#(rowClass)#"><td class="csetName">#($zconvert(indexed(i),"O","HTML"))#</td><td>#(showDesc)#</td></tr>>
				Set rownum = rownum + 1
			}
		}
	}
	&html<</table>>
	Quit $$$OK
}

ClassMethod putCarriageReturnsIn(line As %String) As %String
{
	set maxLength = 90
	set lineLength =$l(line)
	set charsLeft = lineLength
	set curPosition = 0

	while (charsLeft > maxLength) {
		set brLocation = $F(line," ",curPosition + maxLength) - 1 //-1 offset because this function returns the char *after* the space
		//now, replace that location with a <br>
		quit:(brLocation=-1)
		set $E(line, brLocation) = "<br>"
		//set the current position to the location of the br, and go through the loop
		//until the line length is less than the maximum number of characters
		set curPosition = brLocation
		set charsLeft = lineLength - curPosition  
	}
	quit line
}

ClientMethod doDelete() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }

	value = zenPage.cTable.split(":"); // value[0] is just "CT"
	if (!confirm($$$FormatText($$$Text("Are you sure you want to delete code table %1 from schema category %2?"), value[2], value[1]))) {
		return;
	}
	msg = zenPage.DeleteCodeTable(value[1], value[2]);
	if (msg.length > 0) {
		alert(msg);
	}
	zenPage.gotoPage("EnsPortal.HL7.SchemaMain.zen?CAT=" + value[1]);
}

Method DeleteCodeTable(pSchema As %String, pCodeTable As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	If '..canEdit Quit ..msgNotPermitted
	#dim tMsg = ""

	If ..sourceControlEnabled {

		If ..IsSchemaSCReadOnly() Quit ..msgSCReadOnly

		Set tMsg = ..OnSchemaSave("before")
		If tMsg '= "" Quit $$$FormatText($$$Text("Error calling source control OnBeforeSave for schema category %1. %2"),..scCategory, tMsg)

	}

	Set tKilled=$D($$$vaSchemaGbl(pSchema, "CT", pCodeTable))
	Kill $$$vaSchemaGbl(pSchema, "CT", pCodeTable)
	Kill $$$vaSchemaDescGbl(pSchema, "CT", pCodeTable)

	If tKilled {
		Set $$$vaSchemaGbl(pSchema,"time")=$ZTS
		If ..sourceControlEnabled {
			Set tMsg = ..OnSchemaSave("after")
			If tMsg '= "" Set tMsg = $$$FormatText($$$Text("Error calling source control OnAfterSave for schema category %1. %2"),..scCategory, tMsg)
		}
		Set tSC2 = $$$AuditModifySchema("HL7 "_pSchema,"Deleted code table "_pCodeTable)
		Quit tMsg
	}
	Quit $$$FormatText($$$Text("Could not find code table %1 to delete in schema category %2."), pCodeTable, pSchema)
}

ClientMethod doEdit() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }

	var value = zenPage.cTable.split(":"); // value[0] is just "CT"
	parms = {
		CAT : value[1],
		BASE : "", // unknown; we will calculate in the popup
		CT : value[2],
		TYPE : "edit" 
	}
	var details = 'status,scrollbars,resizable,top=10,left=200,width=650,height=720';
	zenLaunchPopupWindow(zenLink('EnsPortal.HL7.Dialog.CustomCodeTable.zen'),this.addPopupSuffix('HL7EditCodeTable'),details,parms);
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("HL7 Code Table")
}

/// Get information to display in the ribbon bar (the Mac-like choice of UI).
/// For wizards this can simply return $$$OK.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String) As %Status
{
	If (##class(EnsPortal.HL7.Utils).IsCustomSchema($P(..cTable,":",2))) {
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

		Set pCommands(1) = $LB("cmdEdit",$$$Text("Edit"),$$$Text("Edit this custom schema code table"),tEditJSFunction)
		Set pCommands(2) = $LB("cmdDelete",$$$Text("Delete"),$$$Text("Delete this custom schema code table"),tDeleteJSFunction)

	}
	Quit $$$OK
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
		case 'HL7EditCodeTable':
			if (value.length > 0) { // format is "DS:schema:dataStruct" 
				if ((value.charAt(0) == 'C') && (value.charAt(1) == 'T')) {
					zenPage.gotoPage("EnsPortal.HL7.SchemaCodeTable.zen?CT=" + value);
				}
			}
			else {
				setTimeout('alert("' + $$$Text("Unable to save changes to custom code table.") + '");', 50);
			}
		break;
		case 'switchNamespace':
			zenPage.changeURLNamespace(value);
		break;
	}
}

/// Callback to return a list of resources required for a specific HyperEvent.
/// The user must have sufficient privileges on one of the resource/permission pairs
/// to be permitted to execute the hyperevent. An empty string implies the user already
/// has sufficient privileges for the ZenMethod specified in <var>pMethod</var>.
ClassMethod GetHyperEventResources(pMethod As %String = "") As %String
{
	Quit $case(pMethod,
					"DeleteCodeTable": ..#EDITRESOURCE,
					: "")
}

}
