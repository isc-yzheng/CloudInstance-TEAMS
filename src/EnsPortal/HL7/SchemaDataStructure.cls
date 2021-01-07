/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7

Class EnsPortal.HL7.SchemaDataStructure Extends EnsPortal.HL7.Template [ System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "HL7 Data Structure";

Parameter CSSINCLUDES = "ensemble/Ensemble_Wizards.css,ensemble/Ensemble_EDI.css";

Property docStruct As %String(MAXLEN = "", ZENURL = "MS");

Property segPath As %String(MAXLEN = "", ZENURL = "PATH");

Property segStruct As %String(MAXLEN = "", ZENURL = "SS");

Property segField As %String(MAXLEN = "", ZENURL = "FIELD");

/// Component Data Structure
Property cStruct As %String(MAXLEN = "", ZENURL = "DS");

Property cField As %String(MAXLEN = "", ZENURL = "DSFIELD");

Property cStructA As %String(MAXLEN = "", ZENURL = "DS1");

Property cStructAField As %String(MAXLEN = "", ZENURL = "DS1FIELD");

Property scCategory As %String(MAXLEN = "") [ Calculated, Internal ];

Method scCategoryGet() As %String [ ServerOnly = 1 ]
{
	Quit $P(..cStruct,":",2)
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
	set category=$P(..cStruct,":",2)
	set structname=$P(..cStruct,":",3)

	If ((category'="")&&(structname'="")) {
		if (('$D($$$vaSchemaGbl(category,"DS",structname))) && ('$D($$$vaSchemaGbl(category,"DT",structname)))) {
			quit ..DrawError(..cStruct)
		}
		set:($D($$$vaSchemaGbl(category,"DT",structname))) node = "DT"
		set:('$D($$$vaSchemaGbl(category,"DT",structname))) node = "DS"
		set elementary = 0
		set:(($LL($$$vaSchemaGbl(category,node,structname))=1)&&(""=$S(node="DT":$LG($LG($$$vaSchemaGbl(category,"DT",structname),1),1),node="DS":$LG($$$vaSchemaGbl(category,"DS",structname),1),1:""))) elementary = 1
		set description=..EscapeHTML($G($$$vaSchemaDescGbl(category,node,structname)))
		If $L(..segPath) {
			Set catText=$$$Text("Schema Category:")
			set catLink = ..Link("EnsPortal.HL7.SchemaMain.zen?CAT="_$$$URLENCODE(category))
			set preface = $$$TextHTML("Path you followed to get to this Data Structure:")
			set fieldTxt = $$$TextHTML("Field Number:")
			set segmentTxt = $$$TextHTML("Segment Structure:")
			set segmentLink = ..Link("EnsPortal.HL7.SchemaSegmentStructure.zen?SS="_$$$URLENCODE(..segStruct))
			set msgTxt = $$$TextHTML("Message Structure:")
			set msgLink = ..Link("EnsPortal.HL7.SchemaDocumentStructure.zen?MS="_$$$URLENCODE(..docStruct))
			set dsText = $$$TextHTML("Data Structure:")
			set dsLink = ..Link("EnsPortal.HL7.SchemaDataStructure.zen?DS="_$$$URLENCODE(..cStructA))

			&html<
				<div>
				<p>
				<i>#(catText)# </i><b><a href="#(catLink)#">#($zconvert(category,"O","HTML"))#</a></b><br/>
			>
			If (..docStruct '= "") {
				&html<
					<i>#(msgTxt)#</i>&nbsp;<b><a href="#(msgLink)#">#($zconvert($P(..docStruct,":",3),"O","HTML"))#</a></b><br/>
				>
			}
			&html<
				<i>#(segmentTxt)#</i>&nbsp;<b><a href="#(segmentLink)#">#($zconvert($P(..segStruct,":",3),"O","HTML"))#</a></b><br/>
				<i>#(fieldTxt)#</i>&nbsp;<b>#($zconvert(..segField,"O","HTML"))#</b>
			>
			If $L(..cStructAField) {
				&html<
				<br/>
				<i>#(dsText)#</i>&nbsp;<b><a href="#(dsLink)#">#($zconvert($P(..cStructA,":",3),"O","HTML"))#</a></b><br/>
				<i>#(fieldTxt)#</i> <b>#($zconvert(..cStructAField,"O","HTML"))#</b>
				>
			}
			&html<
				<br/>
				<i>#(dsText)#</i>&nbsp;<b>#($zconvert(structname,"O","HTML"))#</b>
				</p>
				<p>
				<i>#(preface)#</i>&nbsp;<b>#($zconvert(..segPath,"O","HTML"))#</b>
				</p>
			>
		}
		Else {
			Set catText=$$$Text("Schema Category:")
			set catLink = ..Link("EnsPortal.HL7.SchemaMain.zen?CAT="_$$$URLENCODE(category))
			set dsText = $$$TextHTML("Data Structure:")
			&html<
				<div>
				<p>
				<i>#(catText)# </i><b><a href="#(catLink)#">#($zconvert(category,"O","HTML"))#</a></b><br/>
				<i>#(dsText)# </i><b>#($zconvert(structname,"O","HTML"))#</b>
				</p>
			>
		}

		if ((node = "DS") && '(elementary))  {
			&html<
				<p>#($zconvert(category_":"_structname,"O","HTML"))# #($G(description))#</p>
				</div>
				<table class="tpTable" width="90%" cellpadding=5 cellspacing=2>
					<tr class="headers">
						<th>#($$$Text("Component"))#</th>
						<th>#($$$Text("Description"))#</th>
						<th>#($$$Text("Property Name"))#</th>
						<th>#($$$Text("Data Structure"))#</th>
						<th>#($$$Text("Code Table"))#</th>
						<th class="altDesc">#($$$Text("Alternate Description"))#</th>
					</tr>
			>
		}
		if ((node = "DS") && (elementary))  {
			&html<
				<p>#($zconvert(category_":"_structname,"O","HTML"))# #($G(description)_" - An Elementary Data Structure")#</p>
				</div>
				<table class="tpTable" width="90%" cellpadding=5 cellspacing=2>
					<tr class="headers">
						<th>#($$$Text("Component"))#</th>
						<th class="altDesc">#($$$Text("Alternate Description"))#</th>
					</tr>
			>
		}

		if ((node = "DT") && '(elementary)){
			&html<
			<p>#($zconvert(category_":"_structname,"O","HTML"))# #($G(description))#</p>
			</div>
			<table class="tpTable" width="90%" cellpadding=5 cellspacing=2>
				<tr class="headers">
					<th>#($$$Text("Component"))#</th>
					<th>#($$$Text("Description"))#</th>
					<th>#($$$Text("Property Name"))#</th>
					<th>#($$$Text("Data Structure"))#</th>
					<th>#($$$Text("Minimum Length"))#</th>
					<th>#($$$Text("Maximum Length"))#</th>
					<th>#($$$Text("Required"))#</th>
					<th>#($$$Text("Code Table"))#</th>
					<th class="altDesc">#($$$Text("Alternate Description"))#</th>
				</tr>
			>
		}
		if ((node = "DT") && (elementary)){
			&html<
			<p>#($zconvert(category_":"_structname,"O","HTML"))# #($G(description))# #(" - An Elementary Data Type")#</p>
			</div>
			<table class="tpTable" width="90%" cellpadding=5 cellspacing=2>
				<tr class="headers">
					<th>#($$$Text("Component"))#</th>
					<th>#($$$Text("Minimum Length"))#</th>
					<th>#($$$Text("Maximum Length"))#</th>
					<th class="altDesc">#($$$Text("Alternate Description"))#</th>
				</tr>
			>
		}

		set struct=$$$vaSchemaGbl(category,node,structname)
		kill names set name="" for { set name=$O($$$vaSchemaGbl(category,node,structname,"names",name))  quit:name=""
			set names($$$vaSchemaGbl(category,node,structname,"names",name))=name
		}
		for i=1:1:$LL(struct) { set one=$LI(struct,i)
			set rowClass=$S(i#2=0:"tpEven", 1:"tpOdd")
			&html<<tr class="#(rowClass)#"><td>#(i)#</td>>

			if 'elementary {
				; description
				set description=..EscapeHTML($G($$$vaSchemaDescGbl(category,node,structname,i)))
				&html<<td>#($s(description="":"&nbsp;",1:description))#</td>> 

				; property name
				set tPropPath=$S(""=..segPath||(""=$G(names(i))):"",1:..segPath_"."_$G(names(i)))
				set label = $G(names(i),"&nbsp")
				if (tPropPath="") {
					&html<<td>#($zconvert(label,"O","HTML"))#</td>>
				} else {
					set segmentLink = ..Link("EnsPortal.HL7.SchemaPath.zen?PATH="_$$$URLENCODE(tPropPath)_"&DS="_$$$URLENCODE(..cStruct)_"&DSFIELD="_i_"&DS1="_$$$URLENCODE(..cStructA)_"&DS1FIELD="_$$$URLENCODE(..cStructAField)_"&FIELD="_$$$URLENCODE(..segField)_"&MS="_$$$URLENCODE(..docStruct)_"&SS="_$$$URLENCODE(..segStruct))
					&html<<td><a title='#($zconvert(tPropPath,"O","HTML"))#' href='#(segmentLink)#'>#($zconvert(label,"O","HTML"))#</a></td>>
				}
				; data structure:
				set:(node = "DS") value = $LG(struct,i)
				set:(node = "DT") value = $LG($LG(struct,i),1)
				if (value="") {
					&html<<td>&nbsp;</td>>
				} else {
					set dt = 0, ds = 0
					set:($D($$$vaSchemaGbl($P(value,":",1),"DT",$P(value,":",2)))) dt = 1, description = ..EscapeHTML($G($$$vaSchemaDescGbl($P(value,":",1),"DT",$P(value,":",2))))
					set:(('dt) && ($D($$$vaSchemaGbl($P(value,":",1),"DS",$P(value,":",2))))) ds=1, description = ..EscapeHTML($G($$$vaSchemaDescGbl($P(value,":",1),"DS",$P(value,":",2))))
					if ((dt) && ($LL($$$vaSchemaGbl($P(value,":",1),"DT",$P(value,":",2)))=1)&&(""=$LG($LG($$$vaSchemaGbl($P(value,":",1),"DT",$P(value,":",2)),1),1))){
						&html<<td>#($S(description'="":"<a title='"_description_"' style='color:black'>",1:"")_$zconvert(value,"O","HTML"))#</td>>
					} elseif ((ds) && ($LL($$$vaSchemaGbl($P(value,":",1),"DS",$P(value,":",2)))=1)&&(""=$LG($$$vaSchemaGbl($P(value,":",1),"DS",$P(value,":",2)),1))){
						&html<<td>#($S(description'="":"<a title='"_description_"' style='color:black'>",1:"")_$zconvert(value,"O","HTML"))#</td>>
					} else {
						set valueLink =..Link("EnsPortal.HL7.SchemaDataStructure.cls?DS=DS:"_$$$URLENCODE(value)_"&PATH="_$$$URLENCODE(tPropPath)_"&DS1="_$$$URLENCODE(..cStruct)_"&DS1FIELD="_i_"&FIELD="_$$$URLENCODE(..segField)_"&MS="_$$$URLENCODE(..docStruct)_"&SS="_$$$URLENCODE(..segStruct))
						&html<<td><a #($S(description'="":"title='"_description_"'",1:""))# href='#(valueLink)#'>#($zconvert(value,"O","HTML"))#</a></td>>
					}
				}
			}

			if node = "DT" {
				; min length:
				set value = $LG($LG(struct,i),2)
				if (value="") {
					&html<<td>&nbsp;</td>>
				} else {
					&html<<td class="lengthCol">#($zconvert(value,"O","HTML"))#</td>>
				}

				; max length:
				set value = $LG($LG(struct,i),3)
				if (value="") {
					&html<<td>&nbsp;</td>>
				} else {
					&html<<td class="lengthCol">#($zconvert(value,"O","HTML"))#</td>>
				}

				; required:
				if 'elementary {
					set value = $LG($LG(struct,i),4)
					if (value=""){
						&html<<td>&nbsp;</td>>
					} else {
						&html<<td class="requiredCol">#($zconvert(value,"O","HTML"))#</td>>
					}
				}
			}

			; code table
			if 'elementary {
				set value=$g($$$vaSchemaGbl(category,node,structname,"tables",i))
				if (value="") {
					&html<<td>&nbsp;</td>>
				} else {
					set valueLink = ..Link("EnsPortal.HL7.SchemaCodeTable.zen?CT=CT:"_$$$URLENCODE(value))
					&html<<td><a href='#(valueLink)#'>#($zconvert(value,"O","HTML"))#</a></td>>
				}
			}
			; alternate description
			set altdesc=..EscapeHTML($G($$$vaSchemaDescGbl(category,node,structname,i,"alt")))
			&html<<td>#($S(altdesc="":"&nbsp;",1:altdesc))#</td>>
		}
	}
	&html<</table>>
	Quit $$$OK
}

ClientMethod doDelete() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }
	value = zenPage.cStruct.split(":"); // value[0] is just "DS"
	if (!confirm($$$FormatText($$$Text("Are you sure you want to delete data structure %1 from schema category %2?"), value[2], value[1]))) {
		return;
	}
	msg = zenPage.DeleteDataStruct(value[1], value[2]);
	if (msg.length > 0) {
		alert(msg);
	}
	zenPage.gotoPage("EnsPortal.HL7.SchemaMain.zen?CAT=" + value[1]);
}

Method DeleteDataStruct(pSchema As %String, pDataStruct As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	If '..canEdit Quit ..msgNotPermitted
	#dim tMsg = ""

	If ..sourceControlEnabled {

		If ..IsSchemaSCReadOnly() Quit ..msgSCReadOnly

		Set tMsg = ..OnSchemaSave("before")
		If tMsg '= "" Quit $$$FormatText($$$Text("Error calling source control OnBeforeSave for schema category %1. %2"),..scCategory, tMsg)

	}

	Set node = "DS"
	Set:$D($$$vaSchemaGbl(pSchema,"DT",pDataStruct)) node = "DT"
	Set tKilled=$D($$$vaSchemaGbl(pSchema, node, pDataStruct))
	Kill $$$vaSchemaGbl(pSchema, node, pDataStruct)
	Kill $$$vaSchemaDescGbl(pSchema, node, pDataStruct)

	If tKilled {
		Set $$$vaSchemaGbl(pSchema,"time")=$ZTS
		If ..sourceControlEnabled {
			Set tMsg = ..OnSchemaSave("after")
			If tMsg '= "" Set tMsg = $$$FormatText($$$Text("Error calling source control OnAfterSave for schema category %1. %2"),..scCategory, tMsg)
		}
		Set tSC2 = $$$AuditModifySchema("HL7 "_pSchema,"Deleted data structure "_pDataStruct)
		Quit tMsg
	}
	Quit $$$FormatText($$$Text("Could not find data structure %1 to delete in schema category %2."), pDataStruct, pSchema)
}

ClientMethod doEdit() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }

	var value = zenPage.cStruct.split(":"); // value[0] is just "DS"
	parms = {
		CAT : value[1],
		BASE : "", // unknown; we will calculate in the popup
		DS : value[2],
		TYPE : "edit" 
	}
	zenLaunchPopupWindow(zenLink('EnsPortal.HL7.Dialog.CustomDataStructure.zen'),this.addPopupSuffix('HL7EditDataStructure'),'status,scrollbars,resizable,top=50,left=50,width=1300,height=720',parms);
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("HL7 Data Structure")
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	If (##class(EnsPortal.HL7.Utils).IsCustomSchema($P(..cStruct,":",2))) {
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

		Set pCommands(1) = $LB("cmdEdit",$$$Text("Edit"),$$$Text("Edit this custom schema data structure"),tEditJSFunction)
		Set pCommands(2) = $LB("cmdDelete",$$$Text("Delete"),$$$Text("Delete this custom schema data structure"),tDeleteJSFunction)
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
		case 'HL7EditDataStructure':
			if (value.length > 0) { // format is "DS:schema:dataStruct" 
				if ((value.charAt(0) == 'D') && (value.charAt(1) == 'S')) {
					zenPage.gotoPage("EnsPortal.HL7.SchemaDataStructure.zen?DS=" + value);
				}
			}
			else {
				setTimeout('alert("' + $$$Text("Unable to save changes to custom data structure.") + '");', 50);
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
					"DeleteDataStruct": ..#EDITRESOURCE,
					: "")
}

}
