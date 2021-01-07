/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7

Class EnsPortal.HL7.SchemaSegmentStructure Extends EnsPortal.HL7.Template [ System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "HL7 Schema Segment Structure";

Parameter CSSINCLUDES = "ensemble/Ensemble_Wizards.css,ensemble/Ensemble_EDI.css";

Property segStruct As %String(MAXLEN = "", ZENURL = "SS");

Property mStruct As %String(MAXLEN = "", ZENURL = "MS");

Property segPath As %String(MAXLEN = "", ZENURL = "PATH");

Property scCategory As %String(MAXLEN = "") [ Calculated, Internal ];

Method scCategoryGet() As %String [ ServerOnly = 1 ]
{
	Quit $P(..segStruct,":",2)
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
	set category=$p(..segStruct,":",2)
	set structname=$p(..segStruct,":",3)

	If ((category'="")&&(structname'="")) {
		set description=..EscapeHTML($G($$$vaSchemaDescGbl(category,"SS",structname)))
		if '$D($$$vaSchemaGbl(category,"SS",structname)) {
			quit ..DrawError(..segStruct)
		}
		If $L(..segPath) {
			set catText = $$$Text("Schema Category:")
			set catLink = ..Link("EnsPortal.HL7.SchemaMain.zen?CAT="_$$$URLENCODE(category))
			set msgText = $$$Text("Message Structure:")
			set msgLink = ..Link("EnsPortal.HL7.SchemaDocumentStructure.zen?MS="_$$$URLENCODE($P(..mStruct,":",1,3)))
			set segText = $$$Text("Segment Structure:")
			set pathText = $$$Text("Path you followed to get to this Segment Structure: ")
			&html<
				<div>
					<p>
					<i>#(catText)#</i>&nbsp;<b><a href="#(catLink)#">#($zconvert(category,"O","HTML"))#</a></b><br/>
					<i>#(msgText)#</i>&nbsp;<b><a href="#(msgLink)#">#($zconvert($P(..mStruct,":",3),"O","HTML"))#</a></b><br/>
					<i>#(segText)#</i>&nbsp;<b>#($zconvert(structname,"O","HTML"))#</b>
					</p>
					<p>
					<i>#(pathText)#</i>&nbsp;<b>#($zconvert(..segPath,"O","HTML"))#</b>
					</p>
				</div>
			>
		}
		&html<
			<div>
				<p>#($zconvert(category_":"_structname,"O","HTML"))# #($G(description))#</p>
			</div>
			<table class="tpTable" cellpadding=4 cellspacing=2>
				<tr class="headers">
								<th>#($$$Text("Field"))#</th>
								<th>#($$$Text("Description"))#</th>
								<th>#($$$Text("Property Name"))#</th>
								<th>#($$$Text("Data Structure"))#</th>
								<th>#($$$Text("Symbol"))#</th>
								<th>#($$$Text("Repeat Count"))#</th>
								<th>#($$$Text("Minimum Length"))#</th>
								<th>#($$$Text("Maximum Length"))#</th>
								<th>#($$$Text("Required"))#</th>
								<th>#($$$Text("Repeating"))#</th>
								<th>#($$$Text("Code Table"))#</th>
								<th class="altDesc">#($$$Text("Alternate Description"))#</th>
				</tr>
		>

		set struct=$$$vaSchemaGbl(category,"SS",structname)
		kill names set name="" for { set name=$O($$$vaSchemaGbl(category,"SS",structname,"names",name))  quit:name=""
			set names($$$vaSchemaGbl(category,"SS",structname,"names",name))=name
		}
		for i=1:1:$LL(struct) { set one=$LI(struct,i)
			set rowClass=$S(i#2=0:"tpEven", 1:"tpOdd")
			&html<<tr class="#(rowClass)#"><td>#(i)#</td>>

			; description
			set description=..EscapeHTML($G($$$vaSchemaDescGbl(category,"SS",structname,i)))
			&html<<td>#($s(description="":"&nbsp;",1:description))#</td>>

			; property name
			set tPropPath=$S(""=$G(names(i)):"",1:..segPath_":"_$G(names(i)))_$S($li(one,6):"()",1:"")

			set label = $G(names(i),"&nbsp")
			if (..segPath="") {
				&html<<td>#($zconvert(label,"O","HTML"))#</td>>
			} else {
				set segmentLink = ..Link("EnsPortal.HL7.SchemaPath.cls?PATH="_$$$URLENCODE(tPropPath)_"&FIELD="_i_"&MS="_$$$URLENCODE(..mStruct)_"&SS="_$$$URLENCODE(..segStruct))
				&html<<td><a title='#($zconvert(tPropPath,"O","HTML"))#' href='#(segmentLink)#'>#($zconvert(label,"O","HTML"))#</a></td>>
			}

			; data type
			set value=$li(one,1), dt =0, ds=0
			if (value="") {
				&html<<td>&nbsp;</td>>
			} else {
				set:($D($$$vaSchemaGbl($P(value,":",1),"DT",$P(value,":",2)))) dt = 1, description = ..EscapeHTML($G($$$vaSchemaDescGbl($P(value,":",1),"DT",$P(value,":",2))))
				set:(('dt) && ($D($$$vaSchemaGbl($P(value,":",1),"DS",$P(value,":",2))))) ds=1, description = ..EscapeHTML($G($$$vaSchemaDescGbl($P(value,":",1),"DS",$P(value,":",2))))
				if ((dt) && ($LL($$$vaSchemaGbl($P(value,":",1),"DT",$P(value,":",2)))=1)&&(""=$LG($LG($$$vaSchemaGbl($P(value,":",1),"DT",$P(value,":",2)),1),1))){
					&html<<td>#($S(description'="":"<a title='"_description_"' style='color:black'>",1:"")_$zconvert(value,"O","HTML"))#</td>>
				} elseif ((ds) && ($LL($$$vaSchemaGbl($P(value,":",1),"DS",$P(value,":",2)))=1)&&(""=$LG($$$vaSchemaGbl($P(value,":",1),"DS",$P(value,":",2)),1))){
					&html<<td>#($S(description'="":"<a title='"_description_"' style='color:black'>",1:"")_$zconvert(value,"O","HTML"))#</td>>
				} else {
					set valueLink = ..Link("EnsPortal.HL7.SchemaDataStructure.cls?DS=DS:"_$$$URLENCODE(value)_"&PATH="_$$$URLENCODE(tPropPath)_"&FIELD="_i_"&MS="_$$$URLENCODE(..mStruct)_"&SS="_$$$URLENCODE(..segStruct))
					&html<<td><a #($S(description'="":"title='"_description_"'",1:""))# href='#(valueLink)#'>#($zconvert(value,"O","HTML"))#</a></td>>
				}
			}

			; symbol column
			set value=$li(one,2)
			if (value ="") {
				&html<<td>&nbsp;</td>>
			} else {
				set annotate=$Case(value,"*":"zero or more", "+":"one or more", "!":"exactly one&nbsp;required", "?":"conditional", "&":"conditional", :"")
				set value = $zconvert(value,"O","HTML")_" ("_annotate_")"
				&html<<td>#(value)#</td>>
			}

			; repeat count column
			set value=$li(one,3) &html<<td>#($s(value="":"&nbsp;",1:$zconvert(value,"O","HTML")))#</td>>

			; min length
			set value=$lg(one,7) &html<<td class="lengthCol">#($s(value="":"&nbsp;",1:$zconvert(value,"O","HTML")))#</td>>

			; max length
			set value=$li(one,4) &html<<td class="lengthCol">#($s(value="":"&nbsp;",1:$zconvert(value,"O","HTML")))#</td>>

			; required
			set value=$li(one,5) &html<<td class="requiredCol">#($s(value="":"&nbsp;",1:$zconvert(value,"O","HTML")))#</td>>

			; if repeating
			set value=$li(one,6) &html<<td class="repeatCol">#($s(value="":"&nbsp;",1:$zconvert(value,"O","HTML")))#</td>>

			; code table
			set value=$g($$$vaSchemaGbl(category,"SS",structname,"tables",i))
			&html<<td>#($s(value="":"&nbsp;",1:"<a href='"_..Link("EnsPortal.HL7.SchemaCodeTable.cls?CT=CT:"_$$$URLENCODE(value))_"'>"_$zconvert(value,"O","HTML")_"</a>"))#</td>>

			; alternate description
			set altdesc=..EscapeHTML($G($$$vaSchemaDescGbl(category,"SS",structname,i,"alt")))
			&html<<td>#($s(altdesc="":"&nbsp;",1:altdesc))#</td>>
		}
	}
	&html<</table>>
	Quit $$$OK
}

ClientMethod doDelete() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }
	value = zenPage.segStruct.split(":"); // value[0] is just "SS"
	if (!confirm($$$FormatText($$$Text("Are you sure you want to delete segment structure %1 from schema category %2?"), value[2], value[1]))) {
		return;
	}
	msg = zenPage.DeleteSegment(value[1], value[2]);
	if (msg.length > 0) {
		alert(msg);
	}
	zenPage.gotoPage("EnsPortal.HL7.SchemaMain.zen?CAT=" + value[1]);
}

Method DeleteSegment(pSchema As %String, pSegmentStructure As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	If '..canEdit Quit ..msgNotPermitted
	#dim tMsg = ""

	If ..sourceControlEnabled {

		If ..IsSchemaSCReadOnly() Quit ..msgSCReadOnly

		Set tMsg = ..OnSchemaSave("before")
		If tMsg '= "" Quit $$$FormatText($$$Text("Error calling source control OnBeforeSave for schema category %1. %2"),..scCategory, tMsg)

	}

	Set tKilled=$D($$$vaSchemaGbl(pSchema, "SS", pSegmentStructure))
	Kill $$$vaSchemaGbl(pSchema, "SS", pSegmentStructure)
	Kill $$$vaSchemaDescGbl(pSchema, "SS", pSegmentStructure)

	If tKilled {
		Set $$$vaSchemaGbl(pSchema,"time")=$ZTS
		If ..sourceControlEnabled {
			Set tMsg = ..OnSchemaSave("after")
			If tMsg '= "" Set tMsg = $$$FormatText($$$Text("Error calling source control OnAfterSave for schema category %1. %2"),..scCategory, tMsg)
		}
		Set tSC2 = $$$AuditModifySchema("HL7 "_pSchema,"Deleted segment structure "_pSegmentStructure)
		Quit tMsg
	}
	Quit $$$FormatText($$$Text("Could not find segment structure %1 to delete in schema category %2."), pSegmentStructure, pSchema)
}

ClientMethod doEdit() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }

	var value = zenPage.segStruct.split(":"); // value[0] is just "SS"
	parms = {
		CAT : value[1],
		BASE : "", // unknown; we will calculate in the popup
		SS : value[2],
		TYPE : "edit" 
	}
	zenLaunchPopupWindow(zenLink('EnsPortal.HL7.Dialog.CustomSegmentStructure.zen'),this.addPopupSuffix('HL7EditSegmentStructure'),'status,scrollbars,resizable,top=50,left=50,width=1300,height=720',parms);
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("HL7 Schema Segment Structure")
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	If (##class(EnsPortal.HL7.Utils).IsCustomSchema($P(..segStruct,":",2))) {
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

		Set pCommands(1) = $LB("cmdEdit",$$$Text("Edit"),$$$Text("Edit this custom schema segment structure"),tEditJSFunction)
		Set pCommands(2) = $LB("cmdDelete",$$$Text("Delete"),$$$Text("Delete this custom schema segment structure"),tDeleteJSFunction)
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
		case 'HL7EditSegmentStructure':
			if (value.length > 0) { // format is "SS:schema:messageStruct" 
				if ((value.charAt(0) == 'S') && (value.charAt(1) == 'S')) {
					zenPage.gotoPage("EnsPortal.HL7.SchemaSegmentStructure.zen?SS=" + value);
				}
			}
			else {
				setTimeout('alert("' + $$$Text("Unable to save changes to custom segment structure.") + '");', 50);
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
					"DeleteSegment": ..#EDITRESOURCE,
					: "")
}

}
