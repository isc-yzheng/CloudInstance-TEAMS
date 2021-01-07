/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7

Class EnsPortal.HL7.SchemaDocumentStructure Extends EnsPortal.HL7.Template [ System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "HL7 Schema Message Structure";

Parameter CSSINCLUDES = "ensemble/Ensemble_Wizards.css,ensemble/Ensemble_EDI.css,ensemble/Ensemble_SchemaStruct.css,bootstrap-4-4-1/dist/css/bootstrap.min.css";

/// Comma-delimited list of additional .js files.
Parameter JSINCLUDES = "ensschemazen.js,fontawesome-5.12.0.all.js,jquery-2.0.3.min.js,bootstrap-4-4-1/dist/js/bootstrap.min.js";

Property docStruct As %String(MAXLEN = "", ZENURL = "MS");

Property CopyFromBase As %Boolean(ZENURL = "COPY") [ InitialExpression = "false" ];

Property Category As %String;

Property DocType As %String;

Property viewMode As %String(VALUELIST = "SVG,RAW") [ InitialExpression = "SVG" ];

Property rawDefinition As %String;

Property lastSaved As %String;

Property listViewMode As %String(VALUELIST = "All,Custom") [ InitialExpression = "All" ];

Property scCategory As %String(MAXLEN = "") [ Calculated, Internal ];

Method scCategoryGet() As %String [ ServerOnly = 1 ]
{
	Quit ..Category
}

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
	.col-form-label-sm {
	    font-weight: bold;
	}
	#title2 {
		height: 100px;
		position: absolute;
		background-color: blue;
	}	
	.list-group {
 		overflow-y:scroll;
	}
	.list-group-item-secondary.list-group-item-action:hover {
		cursor: default;
	}
	.syntax-div {
		background-color: lightgray;
		padding: 10px;
	}
	.syntax-label {
		width: inherit;
	}
	.isc-green {
		background-color: #00999D;
	}
	.isc-blue {
		background-color: #333399;
	}
	.bg-green {
		background-color: #18a99e !important;
	}
	.isc-link {
		color: #00999D;
	}
	.form-group .row {
		margin-bottom: 0em;
	}
		
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<vgroup id="main" valign="top" width="100%">
<spacer height="15"/>
<pane id="theContainer" enclosingClass="container-fluid" width="90%">
<html id="header" OnDrawContent="DrawHTMLForm"/>
<spacer height="30"/>
<html id="titlesHTML" OnDrawContent="DrawTitles"/>
<html id="iconsHTML" OnDrawContent="DrawIcons"/>
<spacer height="5"/>
<group id="schemaPane" valign="top" width="100%" layout="none" enclosingStyle="position:relative;top:0px;left:0px;">
<spacer width="40" />
<html id="svgGroup" OnDrawContent="DrawSVG"/>
<hgroup id="rawContentGroup" hidden="true" width="100%" enclosingStyle="position:absolute;height:100%;display:none;top:0px;left:0px;z-index:10;background:white;">
<html id="rawLeftColumn" OnDrawContent="DrawSegList"/>
<html><div id="spacer"></div></html>
<html id="rawRightColumn" OnDrawContent="DrawRaw"/>
</hgroup>
</group>
</pane>
</vgroup>
</pane>
}

Method DrawSVG(pSeed As %String) As %Status
{
	Set msgLoading = $$$Text("Loading...")
	Set isCustom = ##class(EnsPortal.HL7.Utils).IsCustomSchema(..Category)

	&html<
		<svg id="zenRoot" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0" y="0" width="100%" height="100%" zoomAndPan="disable">
		<!-- canvas -->
		<svg id="canvasSVG" x="0" y="0" width="100%" height="100%">
		<g id="canvas" 
			onmousemove="canvasMouseMove(evt);"
			onmouseup="canvasMouseUp(evt);"
			onmouseout="canvasMouseOut(evt);"
		>

		<!-- this allows the mousemove event to register in the entire canvas -->
		<rect class="clearBackground" x="0" y="0" width="100%" height="100%" />
	>

	If isCustom {
		&html<
			<g id="listFrame" name="listFrame" x="0" y="0" width="40%" height="100%">
			</g>
			<rect class="containerBox" id="listBox" name="listBox" rx="5" ry="5" x="0" y="1" width="100%" height="100%"/>
			
			<g id="listScrollBtn">
			<rect id="listScrollRect" class="scrollBtnBg" rx="2" x="5" y="5" width="12" height="40" transform="translate(2,0)"/>
			<polygon id="listScrollArrowUp" class="scrollBtn" points="5,6 15,12 5,18" transform="translate(3,0) rotate(-90,10,12)" onclick="canvas_scrollList(50);" onmouseover="evt.target.setAttribute('class','scrollBtnHover');" onmouseout="evt.target.setAttribute('class','scrollBtn');"/>
			<rect id="listScrollBox" class="scrollBox" x="8" y="20" width="10" height="10" onmousedown="listScrollStart(evt);" onmouseover="evt.target.setAttribute('class','scrollBtnHover');" onmouseout="evt.target.setAttribute('class','scrollBtn');"/>
			<polygon id="listScrollArrowDown" class="scrollBtn" points="5,6 15,12 5,18" transform="translate(3,26) rotate(90,10,12)" onclick="canvas_scrollList(-50);" onmouseover="evt.target.setAttribute('class','scrollBtnHover');" onmouseout="evt.target.setAttribute('class','scrollBtn');"/>
			</g>
		>
	}
	
	&html<
		<!-- diagram box -->
		<g id="diagramFrame" name="diagramFrame" x="0" y="0" width="80%" height="100" onmouseout="diagramMouseOut(evt)">
		</g>
		<rect class="containerBox" id="diagramBox" name="diagramBox" rx="5" ry="5" x="0" y="1" width="100%" height="100%"/>
		
		<g id="diagramScrollBtn">
		<rect id="diagramScrollRect" class="scrollBtnBg" rx="2" x="5" y="5" width="12" height="40" transform="translate(2,0)"/>
		<polygon id="diagramScrollArrowUp" class="scrollBtn" points="5,6 15,12 5,18" transform="translate(3,0) rotate(-90,10,12)" onclick="canvas_scrollSchema(50);" onmouseover="evt.target.setAttribute('class','scrollBtnHover');" onmouseout="evt.target.setAttribute('class','scrollBtn');"/>
		<rect id="diagramScrollBox" class="scrollBox" x="8" y="20" width="10" height="10" onmousedown="diagramScrollStart(evt);" onmouseover="evt.target.setAttribute('class','scrollBtnHover');" onmouseout="evt.target.setAttribute('class','scrollBtn');"/>
		<polygon id="diagramScrollArrowDown" class="scrollBtn" points="5,6 15,12 5,18" transform="translate(3,26) rotate(90,10,12)" onclick="canvas_scrollSchema(-50);" onmouseover="evt.target.setAttribute('class','scrollBtnHover');" onmouseout="evt.target.setAttribute('class','scrollBtn');"/>
		</g> 

		</g>
		<!-- status bar -->
		<g id="StatusBar" style="display: none;">
		<rect class="StatusBar" x="0" y="0" width="100" height="20" rx="2" />
		<text class="StatusText" x="3" y="16" text-anchor="left">#(msgLoading)#</text>
		</g>

		</svg>
		</svg>
	>
	Quit $$$OK
}

Method DrawHTMLForm(pSeed As %String) As %Status
{
	Set tIsCustom = ..IsCustomSchema(..Category)
	Set tCatLink = ..Link("EnsPortal.HL7.SchemaMain.zen?CAT="_$$$URLENCODE(..Category))
	If (tIsCustom) {
		Set tBase = ##class(EnsPortal.HL7.Utils).GetImmediateBaseSchema(..Category)
		Set tBaseLink = ..Link("EnsPortal.HL7.SchemaMain.zen?CAT="_$$$URLENCODE(tBase))
	}
	Set tClass = "form-control "_$S(tIsCustom:"form-control-sm",1:"form-control-plaintext")
	Set tDesc = ""
	If ((..Category'="")&&(..DocType'="")) {
		If ''$D($$$vaSchemaGbl(..Category,"MS",..DocType)) {
			Set tDesc=$zconvert(##class(EnsLib.HL7.Schema).GetDescription(..docStruct),"O","HTML")
		}
	}
	Set tMsgStructLbl = $$$Text("Message Structure Name")
	Set tMsgCatLbl = $S(tIsCustom:$$$Text("Custom Schema Category"),1:$$$Text("Schema Category"))
	Set tCopyLbl = $$$Text("Message Structure to Copy")
	Set tBaseLbl = $$$Text("Base Schema Category")
	Set tDescLbl = $$$Text("Description (optional)")

	&html<
	<div class="row">
		<div class="col col-lg-10">
			<form>
	  			<div class="form-group row" style="margin-bottom:0em;">
	    			<label for="msgStruct" class="col-lg-2 col-form-label-sm">#(tMsgStructLbl)#</label>
	    			<div class="col-sm-9">
	    				<input type="text" readonly disabled class="#(tClass)#" id="msgStruct" placeholder="#(tMsgStructLbl)#" value="#($zconvert(..DocType,"O","HTML"))#" required>
	    				<div id="invalidMsgStruct" class="invalid-feedback"></div>
	    			</div>
	  			</div>
	  			<div class="form-group row" style="margin-bottom:0em;">
	  				<label id="msgCatLbl" for="msgCat" class="col-sm-2 col-form-label-sm">#(tMsgCatLbl)#</label>
	 				<div class="col-sm-9">
	 					<a id="msgCat" class="isc-link" href="#(tCatLink)#">#($zconvert(..Category,"O","HTML"))#</a>
	    			</div>
	  			</div>
	  >
	If tIsCustom {
		&html<
	  			<div class="form-group row" id="baseCatGrp" style="margin-bottom:0em;">
	  				<label for="baseCat" class="col-sm-2 col-form-label-sm">#(tBaseLbl)#</label>
	  				<div class="col-sm-9">
	  					<a id="baseCat" class="isc-link" href="#(tBaseLink)#">#($zconvert(tBase,"O","HTML"))#</a>
	     			</div>
	  			</div>
	  >
	}
	If ..CopyFromBase {
		Do ..GetSchemaSelectList(.tStructArray)
		&html<
			<div class="form-group row" id="msgStructToCopy" style="margin-bottom:0em;">
				<label for="copyStructSelector" class="col-sm-2 col-form-label-sm">#(tCopyLbl)#</label>
				<div class="col-sm-9">
					<select id="copyStructSelector" onchange="zenPage.updateCopyStruct(this.options[this.selectedIndex].value);">
					<option value="" selected disabled hidden>#($$$Text("Select a structure"))#</option>
		>
					
		Set tOption = ""
		For {
			Set tOption = $O(tStructArray(tOption))
			Quit:(tOption="")
			Set tCat = tStructArray(tOption)
			&html<
				<option value="#($zconvert(tCat_":"_tOption,"O","HTML"))#">#($zconvert(tOption_" ("_tCat_")","O","HTML"))#</option>
			>
		}
				
		&html<
					</select>
				</div>
			</div>
		>
	}	

	&html<
  				<div class="form-group row">
   					<label for="msgDesc" class="col-sm-2 col-form-label-sm">#(tDescLbl)#</label>
    				<div class="col-sm-9">
    					<textarea readonly disabled class="#(tClass)#" id="msgDesc" rows="2" placeholder="#(tDescLbl)#">#(tDesc)#</textarea>
    				</div>
	  			</div>
			</form>
		</div>
	>
	If ..IsCustomSchema(..Category) {
		
		Set tEditLbl = $$$Text("Edit")
		Set tEditHover = $$$Text("Edit this custom schema message structure")
		Set tSaveLbl = $$$Text("Save")	
		Set tSaveHover = $$$Text("Save changes to this custom schema message structure")
		Set tDeleteLbl = $$$Text("Delete")
		Set tDeleteHover = $$$Text("Delete this custom schema message structure")

		#dim tEditJSFunction = "zenPage.doEdit();"
		#dim tSaveJSFunction = "zenPage.doSave();"
		#dim tDeleteJSFunction = "zenPage.doDelete();"

		If ..canEdit && ..sourceControlEnabled && ..IsSchemaSCReadOnly() {
			Set tEditJSFunction = "zenPage.scDisabled();"
			Set tSaveJSFunction = tEditJSFunction
			Set tDeleteJSFunction = tEditJSFunction
		}

		&html<
		<div class="col col-2">
			<button id="btnEdit" type="button" class="commandButton" onclick="#(tEditJSFunction)#" title="#(tEditHover)#">#(tEditLbl)#</button>
			<button id="btnSave" type="button" class="commandButton" hidden onclick="#(tSaveJSFunction)#" title="#(tSaveHover)#">#(tSaveLbl)#</button>
			<button id="btnDelete" type="button" class="commandButtonRemove" onclick="#(tDeleteJSFunction)#" title="#(tDeleteHover)#">#(tDeleteLbl)#</button>
		</div>
		>
	}
	
	&html<</div>>

	Quit $$$OK
}

Method GetSchemaSelectList(ByRef pArray)
{
	Set tList = ##class(EnsPortal.HL7.Utils).GetSchemaInheritanceList(..Category)
	For i=1:1:$L(tList,",") {
		Set tCat = $P(tList,",",i)
		Set tRS = ##class(%ResultSet).%New("EnsLib.HL7.Message:EnumerateDocTypes")
		Do tRS.Execute(tCat,0)
		While (tRS.Next()) {
			Set tDoc = tRS.Data("Type")
			Set tName = $P(tDoc,":",2)
			Set:'$D(pArray(tName)) pArray(tName) = tCat
		}
	}
}

ClientMethod updateCopyStruct(docType) [ Language = javascript ]
{
	var raw = zenPage.GetRawContent(docType);
	zenPage.rawDefinition = raw;
	
	if (zenPage.viewMode == "SVG") {
		zenPage.loadTopSegmentsFromServer(true);
		selectItem(null);
	} else {
		self.document.getElementById('rawContent').value = raw;
	}
}

ClassMethod GetRawContent(pDocType) As %String [ ZenMethod ]
{
	Set tStruct=$$$vaSchemaGbl($P(pDocType,":",1),"MS",$P(pDocType,":",2))
	Quit ..GetRawNoPrefixes(tStruct)
}

ClassMethod GetRawNoPrefixes(pRaw) As %String
{
	Set tMsg = ""
	Set tLen = $L(pRaw, "~")
	For n=1:1:tLen {
		Set tToken = $P(pRaw, "~", n)
		If (tToken [ ":") {
			Set tToken = $P(tToken, ":", 2)
		}
		Set tMsg = tMsg _ tToken _ $S(n=tLen:"",1:"~")
	}
	Quit tMsg
}

ClientMethod doEdit() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }
	
	setReadOnly(false);
	self.document.getElementById('rawContent').readOnly = false;
	self.document.getElementById('msgStruct').readOnly = false;
	self.document.getElementById('msgDesc').readOnly = false;
	self.document.getElementById('rawContent').disabled = false;
	self.document.getElementById('msgStruct').disabled = false;
	self.document.getElementById('msgDesc').disabled = false;
	self.document.getElementById('btnUndo').hidden = false;
	self.document.getElementById('btnRedo').hidden = false;

	self.document.getElementById('btnEdit').hidden = true;
	self.document.getElementById('btnSave').hidden = false;
}

ClientMethod doSave() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }
	
	if (zenPage.viewMode == "SVG") {
		zenPage.setRawFromSVG();	
	} else {
		zenPage.rawDefinition = self.document.getElementById('rawContent').value;
	}
	
	var msg = zenPage.validateAll();
	if (msg.length > 0) {
		alert(msg);
		return false;
	}
	
	var structName = self.document.getElementById('msgStruct').value;
	
	if ((zenPage.DocType != "") && (structName != zenPage.DocType)) {
		msg = zenPage.DeleteStructure(zenPage.Category, zenPage.DocType);
		if (msg.length > 0) {
			alert(msg);
		}
	}
	
	var descTxt = self.document.getElementById('msgDesc').value;
	
	msg = zenPage.PutNewMessageOnServer(zenPage.Category, structName, zenPage.rawDefinition, descTxt);
	if (msg.length > 0) {
		alert(msg);
		return false;
	}
	zenPage.lastSaved = zenPage.rawDefinition;
	zenPage.DocType = structName;
	zenPage.setModified();
	
	setReadOnly(true);
	selectItem(null);
	self.document.getElementById('rawContent').readOnly = true;
	self.document.getElementById('msgStruct').readOnly = true;
	self.document.getElementById('msgDesc').readOnly = true;
	self.document.getElementById('rawContent').disabled = true;
	self.document.getElementById('msgStruct').disabled = true;
	self.document.getElementById('msgDesc').disabled = true;
	self.document.getElementById('btnUndo').hidden = true;
	self.document.getElementById('btnRedo').hidden = true;

	self.document.getElementById('btnEdit').hidden = false;
	self.document.getElementById('btnDelete').hidden = false;
	self.document.getElementById('btnSave').hidden = true;
}

Method PutNewMessageOnServer(pCategory As %String, pStructure As %String, pRawDescription As %String, pTextDescription As %String) As %String [ ZenMethod ]
{
	If '..canEdit Quit ..msgNotPermitted

	If ..sourceControlEnabled && ..IsSchemaSCReadOnly() Quit ..msgSCReadOnly

	Set tMsg = ""
	Try {
		If ..sourceControlEnabled {
			Set tMsg = ..OnSchemaSave("before")
			If tMsg '= "" Quit
		}
		TSTART
		Set $$$vaSchemaGbl(pCategory, "MS", pStructure) = pRawDescription
		Set:""'=pTextDescription $$$vaSchemaDescGbl(pCategory, "MS", pStructure) = pTextDescription
		Set tSC = ##class(EnsLib.HL7.SchemaXML).addDefaultCategories(pCategory, $$$Text("Custom Schema Editor"))
		If $$$ISERR(tSC) {
			Set tMsg = $$$FormatText($$$Text("Unable to store message structure modifications to %1 schema due to error: %2"), pCategory, $$$StatusDisplayString(tSC))
		}
		Set tSC = ##class(EnsLib.HL7.Schema).BuildCategoryMaps(pCategory)
		If $$$ISERR(tSC) {
			Set tMsg = $$$FormatText($$$Text("Unable to store message structure modifications to %1 schema due to error: %2"), pCategory, $$$StatusDisplayString(tSC))
		}
		If (tMsg = "") {
			Set $$$vaSchemaGbl(pCategory, "time") = $ZTS
			TCOMMIT
		}
		Else {
			TROLLBACK
		}
	}
	Catch (ex) {
	}
	If ..sourceControlEnabled {
		#; Only call OnSchemaSave if not errored
		If tMsg = "" Set tMsg = ..OnSchemaSave("after")
	}
	Set tSC2 = $$$AuditModifySchema("HL7 "_pCategory,"Saved message structure "_pStructure_$S(tMsg'="":" (ERROR)",1:""))
	Quit tMsg
}

ClientMethod doDelete() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }
	if (zenPage.DocType == "") {
		if (!confirm($$$Text("Are you sure you want to cancel work on this new message structure?"))) {
			this.pageModified = false;
			return;
		}
	} else {
		if (!confirm($$$FormatText($$$Text("Are you sure you want to delete message structure %1 from schema category %2?"), zenPage.DocType, zenPage.Category))) {
			return;
		}
		msg = zenPage.DeleteStructure(zenPage.Category, zenPage.DocType);
		if (msg.length > 0) {
			alert(msg);
		}
	}
	zenPage.gotoPage("EnsPortal.HL7.SchemaMain.zen?CAT=" + zenPage.Category);
}

Method DeleteStructure(pSchema As %String, pMessageStructure As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	If '..canEdit Quit ..msgNotPermitted
	#dim tMsg = ""

	If ..sourceControlEnabled {

		If ..IsSchemaSCReadOnly() Quit ..msgSCReadOnly

		Set tMsg = ..OnSchemaSave("before")
		If tMsg '= "" Quit $$$FormatText($$$Text("Error calling source control OnBeforeSave for schema category %1. %2"),..scCategory, tMsg)

	}

	Set tKilled=$D($$$vaSchemaGbl(pSchema, "MS", pMessageStructure))
	Kill $$$vaSchemaGbl(pSchema, "MS", pMessageStructure)
	Kill $$$vaSchemaDescGbl(pSchema, "MS", pMessageStructure)

	If tKilled {
		Set $$$vaSchemaGbl(pSchema,"time")=$ZTS
		If ..sourceControlEnabled {
			Set tMsg = ..OnSchemaSave("after")
			If tMsg '= "" Set tMsg = $$$FormatText($$$Text("Error calling source control OnAfterSave for schema category %1. %2"),..scCategory, tMsg)
		}
		Set tSC2 = $$$AuditModifySchema("HL7 "_pSchema,"Deleted message structure "_pMessageStructure)
		Quit tMsg
	}
	Quit $$$FormatText($$$Text("Could not find message structure %1 to delete in schema category %2."), pMessageStructure, pSchema)
}

Method DrawTitles(pSeed As %String) As %Status
{
	&html<
		<div class="row">
		<div class="col col-1"></div>
	>
	If ..IsCustomSchema(..Category) {
		&html<
			<div class="col col-2">
				<h5>#($$$Text("Available Segments"))#</h5>
			</div>
			<div class="col col-1"></div>
			>
		}
	&html<
			<div class="col col-4"></div>
			<div class="col col-1">
				<h5>#($$$Text("Structure"))#</h5>
			</div>
		</div>
	>
	Quit $$$OK
}

Method DrawIcons(pSeed As %String) As %Status
{
	&html<
	<div class="row">
		<div class="col col-3">
		</div>
		<div class="col col-1">
		>
		if (..IsCustomSchema(..Category)) {
			&html<
			<div class="btn-group" role="group">
			  <button id="btnNewSeg" type="button" class="btn btn-secondary btn-sm" aria-label="Create New Segment" title="Create a new segment structure" onclick="zenPage.doNewSS();">
			  	<div style="font-size:1em; color:white">
			  	<icon class="fas fa-plus"></icon>
			  	</div>
			  </button>
			  <button id="btnFilter" type="button" class="btn btn-secondary btn-sm" aria-label="Filter" title="Show only custom segments" onclick="zenPage.doFilter();">
			  	<div style="font-size:1em; color:white">
			  	<icon class="fas fa-filter"></icon>
			  	</div>
			  </button>
			 </div>
			 >
		}
		&html<
		</div>
		<div class="col col-7">
		</div>
		<div class="col col-1">
			<div class="btn-group" role="group">
			  <button id="btnUndo" type="button" class="btn btn-secondary btn-sm" aria-label="Undo" disabled="true" title="Undo the last change" onclick="zenPage.decrementKeyBuffer();zenPage.setModified();" hidden="true">
			  	<div id="imgUndo" style="font-size:1em; color:DimGray">
			  	<icon class="fas fa-reply"></icon>
			  	</div>
			  </button>
			  <button id="btnRedo" type="button" class="btn btn-secondary btn-sm" aria-label="Redo" disabled="true" title="Redo the last undo change" onclick="zenPage.decrementKeyRedoBuffer();zenPage.setModified();" hidden="true">
			  	<div id="imgRedo" style="font-size:1em; color:DimGray">
			  	<icon class="fas fa-share"></icon>
			  	</div>
			  </button>
			  <button id="btnViewMode" type="button" class="btn btn-secondary btn-sm" aria-label="Switch View Mode" title="View raw definition" onclick="zenPage.switchViewMode();">
			  	<div style="font-size:1em; color:white">
			  	<icon id="viewModeIcon" class="fas fa-exchange-alt"></icon>
			  	</div>
			  </button>
			</div>
			
		</div>
	</div>
	>
	Quit $$$OK
}

ClientMethod doNewSS() [ Language = javascript ]
{
	if (!this.canUserModify()) { return false; }

	var base = zenPage.GetBase(this.Category);
	parms = {
		CAT : zenPage.Category,
		BASE : base,
		TYPE : "newORcopy"
	}
	if (zenIsChrome) {
		var details = 'status,scrollbars,resizable,top=10,left=10,width=1500,height=720';
	}
	else {
		var details = 'status,scrollbars,resizable,top=10,left=10,width=1600,height=720';
	}
	zenLaunchPopupWindow(zenLink('EnsPortal.HL7.Dialog.CustomSegmentStructure.zen'),this.addPopupSuffix('newCustomSegment'),details,parms);
}

Method GetBase(pCategory) As %String [ ZenMethod ]
{
	Quit ##class(EnsPortal.HL7.Utils).GetImmediateBaseSchema(pCategory)
}

ClientMethod doFilter() [ Language = javascript ]
{
	var btn = self.document.getElementById('btnFilter');
	if (zenPage.listViewMode == "Custom") {
		zenPage.listViewMode = "All";
		btn.title = $$$Text("Show only custom segments");
	} else {
		zenPage.listViewMode = "Custom";
		btn.title = $$$Text("Show all segments");
	}
	
	if (zenPage.viewMode == "SVG") {
		zenPage.loadSegListFromServer();
	} else {
		zen('rawLeftColumn').refreshContents(true);
		zenPage.adjustSizes();
	}
}

ClientMethod switchViewMode() [ Language = javascript ]
{
	var svg = zen('svgGroup');
	var raw = zen('rawContentGroup');
	if (zenPage.viewMode == "SVG") {
		zenPage.viewMode = "RAW";
		zenPage.setRawFromSVG();
		var val = zenPage.rawDefinition;
		self.document.getElementById('rawContent').value = val;
		raw.setHidden(false);
		self.document.getElementById('btnViewMode').title = $$$Text('View visual representation');
		if (zenPage.IsCustomSchema(zenPage.Category)) {
			zen('rawLeftColumn').refreshContents(true);
			zenPage.adjustSizes();
		}
	} else {
		var ok = zenPage.validateContentToDisplay(true);
		if (ok) {
			zenPage.viewMode = "SVG";
			zenPage.rawDefinition = self.document.getElementById('rawContent').value;
			raw.setHidden(true);
			
			zenPage.loadTopSegmentsFromServer(true);
			self.document.getElementById('btnViewMode').title = $$$Text('View raw definition');
			selectItem(null);
			
			if (zenPage.IsCustomSchema(zenPage.Category)) {
				zenPage.loadSegListFromServer();
			}
		}
	}
}

ClientMethod setRawFromSVG() [ Language = javascript ]
{
	var raw = getRawStruct();
	zenPage.rawDefinition = raw;
}

ClientMethod validateContentToDisplay(doAlert) As %Boolean [ Language = javascript ]
{
	var ok = true;
	var raw = self.document.getElementById('rawContent').value;
	if (raw.length > 0) {
		temp = raw.replace(/\s/g, "");	
		temp = temp.replace(/\t/g, "");
		if (temp.length != raw.length) {
			raw = temp;
			self.document.getElementById('rawContent').value = raw;
		}
		var msg = zenPage.validateRaw(raw);
		if (msg.length > 0) {
			ok = false;
			var finalMsg = (msg);
		}

		if ((ok == false) && (doAlert == true)) {
		 	finalMsg = ($$$Text("ERRORS:") + '\n' + finalMsg);
			finalMsg += '\n' + $$$Text("NOTE: Because there were errors, your changes cannot be displayed.");
			alert(finalMsg);
		}
	}
	return ok;
}

ClientMethod validateRaw(raw) [ Language = javascript ]
{
	var diff;
	var msg = "";
	
	if (raw.length <= 0) {
		msg += ('  ' + $$$Text("No raw description was entered.") + '\n');
	}
	if (raw.match(/[`@#$%^&*()-+=\\;"',?\/]/)) {
		msg += ('  ' + $$$Text("Stray punctuation found.") + '\n');
	}
	if (raw.match("~~")) {
		msg += ('  ' + $$$Text("Consecutive ~ characters found.") + '\n');
	}
	
	if (raw.match(/[^~]+\[/)) {
		msg += ('  ' + $$$Text("Left square bracket [ found without preceding ~ character.") + '\n');
	}
	if (raw.match(/\[[^~]/)) {
		msg += ('  ' + $$$Text("Left square bracket [ found without following ~ character.") + '\n');
	}
	if (raw.match(/[^~]\]/)) {
		msg += ('  ' + $$$Text("Right square bracket ] found without preceding ~ character.") + '\n');
	}
	if (raw.match(/\][^~]+/)) {
		msg += ('  ' + $$$Text("Right square bracket ] found without following ~ character.") + '\n');
	}
	if (raw.match(/[^~]+{/)) {
		msg += ('  ' + $$$Text("Left curly bracket { found without preceding ~ character.") + '\n');
	}
	if (raw.match(/{[^~]/)) {
		msg += ('  ' + $$$Text("Left curly bracket { found without following ~ character.") + '\n');
	}
	if (raw.match(/[^~]}/)) {
		msg += ('  ' + $$$Text("Right curly bracket } found without preceding ~ character.") + '\n');
	}
	if (raw.match(/}[^~]+/)) {
		msg += ('  ' + $$$Text("Right curly bracket } found without following ~ character.") + '\n');
	}
	if (raw.match(/[^~]+</)) {
		msg += ('  ' + $$$Text("Left angle bracket < found without preceding ~ character.") + '\n');
	}
	if (raw.match(/<[^~]/)) {
		msg += ('  ' + $$$Text("Left angle bracket < found without following ~ character.") + '\n');
	}
	if (raw.match(/[^~]>/)) {
		msg += ('  ' + $$$Text("Right angle bracket > found without preceding ~ character.") + '\n');
	}
	if (raw.match(/>[^~]+/)) {
		msg += ('  ' + $$$Text("Right angle bracket > found without following ~ character.") + '\n');
	}
	if (raw.match(/\|[^~]/)) {
		msg += ('  ' + $$$Text("Pipe character | found without following ~ character.") + '\n');
	}
	if (raw.match(/[^~]\|/)) {
		msg += ('  ' + $$$Text("Pipe character | found without preceding ~ character.") + '\n');
	}

	countLeftSquare = 0;
	countRightSquare = 0;
	countLeftCurly = 0;
	countRightCurly = 0;
	countLeftAngle = 0;
	countRightAngle = 0;
	for (i=0; i < raw.length; i++) {
		switch (raw.charAt(i)) {
			case '[' : countLeftSquare++; break;
			case ']' : countRightSquare++; break;
			case '{' : countLeftCurly++; break;
			case '}' : countRightCurly++; break;
			case '<' : countLeftAngle++; break;
			case '>' : countRightAngle++; break;
			default  : break;
		}
	}
	if (countLeftSquare != countRightSquare) {
		diff = Math.abs(countRightSquare - countLeftSquare);
		if (countLeftSquare < countRightSquare) {
			if (diff == 1) {
				msg += ('  ' + $$$FormatText($$$Text("%1 unmatched right square bracket ] found."), diff) + '\n');
			}
			else {
				msg += ('  ' + $$$FormatText($$$Text("%1 unmatched right square brackets ] found."), diff) + '\n');
			}
		}
		else {
			if (diff == 1) {
				msg += ('  ' + $$$FormatText($$$Text("%1 unmatched left square bracket [ found."), diff) + '\n');
			}
			else {
				msg += ('  ' + $$$FormatText($$$Text("%1 unmatched left square brackets [ found."), diff) + '\n');
			}
		}
	}
	if (countLeftCurly != countRightCurly) {
		diff = Math.abs(countRightCurly - countLeftCurly);
		if (countLeftCurly < countRightCurly) {
			if (diff == 1) {
				msg += ('  ' + $$$FormatText($$$Text("%1 unmatched right curly bracket } found."), diff) + '\n');
			}
			else {
				msg += ('  ' + $$$FormatText($$$Text("%1 unmatched right curly brackets } found."), diff) + '\n');
			}
		}
		else {
			if (diff == 1) {
				msg += ('  ' + $$$FormatText($$$Text("%1 unmatched left curly bracket { found."), diff) + '\n');
			}
			else {
				msg += ('  ' + $$$FormatText($$$Text("%1 unmatched left curly brackets { found."), diff) + '\n');
			}
		}
	}
	if (countLeftAngle != countRightAngle) {
		diff = Math.abs(countRightAngle - countLeftAngle);
		if (countLeftAngle < countRightAngle) {
			if (diff == 1) {
				msg += ('  ' + $$$FormatText($$$Text("%1 unmatched right angle bracket > found."), diff) + '\n');
			}
			else {
				msg += ('  ' + $$$FormatText($$$Text("%1 unmatched right angle brackets > found."), diff) + '\n');
			}
		}
		else {
			if (diff == 1) {
				msg += ('  ' + $$$FormatText($$$Text("%1 unmatched left angle bracket < found."), diff) + '\n');
			}
			else {
				msg += ('  ' + $$$FormatText($$$Text("%1 unmatched left angle brackets < found."), diff) + '\n');
			}
		}
	}
	if (msg.length > 0) {
		msg = $$$Text("Raw definition notes: \n") + msg;
	}
		
	return msg;
}

ClientMethod validateAll() [ Language = javascript ]
{
	var ok = true;
	var msg = '';
	var finalMsg = '';
	var list = '';
	var temp = '';
	var val = '';

	// validate the new message structure name
	var name = self.document.getElementById('msgStruct').value;
	var temp = name.replace(/\s/g, "");	
	temp = temp.replace(/\t/g, "");
	if (temp.length != name.length) {
		name = temp;
		self.document.getElementById('msgStruct').value = name;
	}
	// separate out the message structure schema and name, if a schema is provided to mimic our drop-downs
	var MSName = zenPage.sortOutEntityName(name, $$$Text("Too many space characters in the message structure name."));

	// run through validation of the usual name issues
	var len = MSName.length;
	if (len <= 0) {
		self.document.getElementById('msgStruct').classList.add( "is-invalid");
		var msg = $$$Text("Please enter a valid message structure name.");
		self.document.getElementById('invalidMsgStruct').innerHTML = msg;
		ok = false;
	}
	else {
		if (MSName.match(/[`~@#$%^&*()-+={}\[\]|\\:;"'<,>?\/]/) || MSName.match(/\s/) || MSName.match(/\t/)) {
			var msg = $$$Text("Please enter a valid message structure name.  Do not use any whitespace characters, or any punctuation characters other than _ (underscore) or . (period).");
			self.document.getElementById('invalidMsgStruct').innerHTML = msg;
			self.document.getElementById('msgStruct').classList.add('is-invalid');
			ok = false;
		}
		else {
			if (MSName != zenPage.DocType) {
				// does the proposed new message type already exist in the schema?
				var exists = zenPage.GetValidationDataFromServer(zenPage.Category, MSName);
				if (exists == "1") {
					if (zenPage.DocType == "" ) { 
						var msg = $$$FormatText($$$Text("The specified new message structure %2 already exists in the custom schema %1."), zenPage.Category, MSName);
						msg += (" " + $$$Text("If you want to create a new message structure, use a different name."));
						msg += (" " + $$$FormatText($$$Text("If you want to edit the message structure %1, dismiss this message, click Cancel in this dialog, click through to the message structure description, and click Edit."), MSName));
						
					} else {
						var msg = $$$FormatText($$$Text("The specified message structure %2 already exists in the custom schema %1."), zenPage.Category, MSName);
						msg += (" " + $$$FormatText($$$Text("If you want to edit the message structure %1, dismiss this message, click Cancel in this dialog, click through to the message structure description, and click Edit."), MSName));
						
					}
					self.document.getElementById('invalidMsgStruct').innerHTML = msg;
					self.document.getElementById('msgStruct').classList.add('is-invalid');
					ok = false;
				}
			}
		}
	}
	if (ok == true) {
		self.document.getElementById('msgStruct').classList.remove('is-invalid');
	}

	// validate the raw message definition text
	var raw = zenPage.rawDefinition;
	temp = raw.replace(/\s/g, "");	
	temp = temp.replace(/\t/g, "");
	if (temp.length != raw.length) {
		raw = temp;
		self.document.getElementById('rawContent').value = raw;
	}
	var msg = zenPage.validateRaw(raw);
	if (msg.length > 0) {
		ok = false;
		self.document.getElementById('rawContent').classList.add('is-invalid');
		self.document.getElementById('invalidRawContent').innerHTML = msg;
	} else {
		self.document.getElementById('rawContent').classList.remove('is-invalid');
	}

	if (ok == false) {
	 	finalMsg += ($$$Text("Because there were errors, your changes have not been saved.") + ' ' 
		        + $$$Text("To save your work, click OK in this alert box, correct the reported problems, and then click OK in the dialog.")
		        + '\n');
	}
	
	return finalMsg;
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

/// Get all the necessary data from the server in one call and use it later.
/// pCustomSchema and pNewMS are without prefix or suffix. 
/// <p>
/// Here is the format of the semi-colon separated string (values shown in angle brackets which are not really there): <br/>
/// <is pNewMS existing in pCustomSchema>
ClassMethod GetValidationDataFromServer(pCustomSchema As %String, pNewMS As %String) As %String [ ZenMethod ]
{
	Set tMsg = ""
	Try {
		Set tMsg = ##class(EnsPortal.HL7.Utils).SchemaEntityAlreadyExists(pCustomSchema, pNewMS, "MS")
	}
	Catch (ex) {
	}
	Quit tMsg
}

Method DrawSegList(pSeed As %String) As %Status
{
	If ..IsCustomSchema(..Category) {
		
		&html<
			<div id="rawSegList" class="list-group">
		>
		
		If ..listViewMode = "All" {
			Set tList = ","_##class(EnsPortal.HL7.Utils).GetSchemaInheritanceList(..Category)_","
		} Else {
			Set tList = ","_..Category_","
		}
		
		Set tRS = ##class(%ResultSet).%New("EnsLib.HL7.Message:EnumerateSegTypes")
		Do tRS.Execute("", 0, 0)
		While (tRS.Next()) {
			Set tDoc = tRS.Data("SegType")
			Set tSchema = $P(tDoc, ":", 1)
			If $F(tList,","_tSchema_",") {
				Set tDict($P(tDoc,":",2)) = tSchema
			}
		}
		Set tSeg = ""
		For {
			Set tSeg = $O(tDict(tSeg), 1, tCat)  Quit:""=tSeg
			Set tText = tSeg _ " (" _ tCat _ ")"
			Set tValue = tSeg
			&html<
				<a href="#" class="list-group-item list-group-item-action list-group-item-secondary" style="line-height:0.5;display:inline-block;">#(tText)#</a>
				>
		}
		&html<
			</div>
		>
	}
			
	Quit $$$OK
}

/// Load the list of available segements from the server
ClientMethod loadSegListFromServer() [ Language = javascript ]
{
	var filter = zenPage.listViewMode;
	this.GetSegmentsList(filter);
}

Method GetSegmentsList(pFilter As %String = "All") As %Boolean [ ZenMethod ]
{
	Write "setSegsList("
	
	If (pFilter = "Custom") {
		Set tList = ","_..Category_","
	} Else {
		Set tList = ","_##class(EnsPortal.HL7.Utils).GetSchemaInheritanceList(..Category)_","
	}
	
	Set tRS = ##class(%ResultSet).%New("EnsLib.HL7.Message:EnumerateSegTypes")
	Do tRS.Execute("", 0, 0)
	
	Write "["
	Set tCount = 0
	While (tRS.Next()) {
		Set tDoc = tRS.Data("SegType")
		Set tSchema = $P(tDoc, ":", 1)
		If $F(tList,","_tSchema_",") {
			Set tSegName = $P(tDoc,":",2)
			If '$D(tSegList(tSegName),tSegSchema) || ($F(tList,","_tSchema_",") < $F(tList,","_tSegSchema_",")) {
				Set tSegList(tSegName) = tSchema
			}
		}
	}
	Set tSegName = ""
	For {
		Set tSegName = $O(tSegList(tSegName)) Quit:tSegName=""
		Set tSchema = tSegList(tSegName)
		Set tCount = tCount + 1
		Write $S(tCount>1:",",1:"")_"[ '"_$zconvert(tSegName,"O","JS")_"','"_tSchema_"' ]"_$C(13,10)
	}
	
	Write " ] );"_$C(13,10)

	Quit 1
}

Method DrawRaw(pSeed As %String) As %Status
{
	
	//  add labels for syntax rules helper box
	Set tSegLbl = $$$Text("Use simple segment names")
	Set tTildeLbl = $zcvt($$$FormatText($$$Text("%1 separates the parts of the definition"), "~"),"O","HTML")
	Set tSquareLbl = $zcvt($$$FormatText($$$Text("%1 encloses an optional segment"), "[]"),"O","HTML") 
	Set tCurlyLbl = $zcvt($$$FormatText($$$Text("%1 encloses a repeating segment"), "{}"),"O","HTML") 
	Set tAngleLbl = $zcvt($$$FormatText($$$Text("%1 encloses a set of choices"), "<>"),"O","HTML") 
	Set tPipeLbl = $zcvt($$$FormatText($$$Text("%1 separates the choices inside %2"), "|", "<>"),"O","HTML")
	Set tSyntaxLbl = $$$Text("Syntax Rules")
	
	&html<
		<form>
	  		<div class="form-group row">
	  			<textarea id="rawContent" class="form-control" rows="4" onkeyup="zenPage.textKeyUp();" disabled readonly></textarea>
	  			<div id="invalidRawContent" class="invalid-feedback"></div>
	  		</div>
	  	</form>
	  	
	  	<div class="syntax-div">
	  	<p>
	  	<label id="labelRules" >#(tSyntaxLbl)#</label>
	  	</p>
	  	<p>
		<label id="labelSeg" class="syntax-label">#(tSegLbl)#</label>
		</p>
		<p>
		<label id="labelTilde" class="syntax-label">#(tTildeLbl)#</label>
		</p>
		<p>
		<label id="labelSquare" class="syntax-label">#(tSquareLbl)#</label>
		</p>
		<p>
		<label id="labelCurly" class="syntax-label">#(tCurlyLbl)#</label>
		</p>
		<p>
		<label id="labelAngle" class="syntax-label">#(tAngleLbl)#</label>
		</p>
		<p>
		<label id="labelPipe" class="syntax-label">#(tPipeLbl)#</label>
		</p>
	  	</div>
	  	
		<div style="height:5px;">
		</div>
	>
	Quit $$$OK
}

/// Load top-level document segments from the server and populate
/// part of the diagram.<br/>
ClientMethod loadTopSegmentsFromServer(reload) As %Boolean [ Language = javascript ]
{
	// get contents from server
	return this.GetTopSegments(reload);
}

/// Generate JS to populate list of top-level segment
Method GetTopSegments(pDyn As %Boolean = 0) As %Boolean [ ZenMethod ]
{
	Write "setSegments("_pDyn_","_$C(13,10)
	
	Set tSchema = ..rawDefinition
	Do ##class(EnsLib.HL7.Schema).getSegsContentArray(.tContents,"","",tSchema,"",1,.tSC)
	
	// walk over contents list
	Write "[ "
	Set n=0,k="" For { Set k=$O(tContents(k))  Quit:""=k  Continue:+k'=k  Set n=n+1
		Set tName = $G(tContents(k,"name"))
		If $Case($E(tName),".":0, ":":0, :1) Set tName = "." _ tName
		Set tChildCount = +$G(tContents(k))
		Set tOptional = +$G(tContents(k,"opt"))
		Set tGroup = $S($E(tName,*-2,*)="grp":1,$E(tName,*-4,*)="grp()":1,1:0)
		Set tUnion = $S($E(tName,*-4,*)="union":1,$E(tName,*-6,*)="union()":1,1:0)
		Write $S(n>1:",",1:"")_"[ '"_$zconvert(tName,"O","JS")_"',"_n,","_tChildCount_","_tOptional_","_tGroup_","_tUnion_" ]"_$C(13,10)
	}
	Write " ] );"_$C(13,10)

	Quit 1
}

/// Load specified segments from the server.
ClientMethod loadSegmentsFromServer(origName, idlist) [ Language = javascript ]
{
	// get contents from server
	this.GetSegments(origName,idlist);
}

/// Called from client to get list of subsegments
/// pNodeAddr is csv-list of id numbers
Method GetSegments(pSegment As %String, pNodeAddr As %String = "") As %Boolean [ ZenMethod ]
{
	Set start=0, $ZT="Trap"
	Set:""=pNodeAddr pNodeAddr=-1
	Write $c(9)_"insertSegments('"_(pSegment)_"',"_$C(13,10)
	Set start=1
	
	Set tSchema = ..rawDefinition
	Do ##class(EnsLib.HL7.Schema).getSegsContentArray(.tContents,"","",tSchema,"",1,.tSC)

	Set dots = ""
	
	Set tNodesLen=$S(+pNodeAddr<=0:0, 1:$L(pNodeAddr,","))
	
	For p = 1:1:tNodesLen {
		Set tNode = +$P(pNodeAddr,",",p)
		#; scan the current tree level up to the given node position
		Set tID=0, k=""
		For {
			Set k=$O(tContents(k)) Quit:""=k  Continue:+k'=k
			Set tID=tID+1 Quit:tID=tNode
		}
		Set:tID'=tNode k="_"
		Merge tTemp = tContents(k)
		Kill tContents
		Merge tContents = tTemp
		Kill tTemp
		Set dots = dots _ $S(":"=$E($G(tContents("name"))):":",1:".")
	}
	Write " [ "
	Set n=0,k="" For { Set k=$O(tContents(k))  Quit:""=k  Continue:+k'=k  Set n=n+1
		Set tName = $G(tContents(k,"name"))
		Set tName = dots _ $S($E(tName)=":":"", 1:".") _ tName
		Set tChildCount = +$G(tContents(k))
		Set tOptional = +$G(tContents(k,"opt"))
		Set tGroup = $S($E(tName,*-2,*)="grp":1,$E(tName,*-4,*)="grp()":1,1:0)
		Set tUnion = $S($E(tName,*-4,*)="union":1,$E(tName,*-6,*)="union()":1,1:0)

		Write $S(n>1:",",1:"")_" [ '"_$zconvert(tName,"O","JS")_"',"_n_","_tChildCount_","_tOptional_","_tGroup_","_tUnion_" ]"_$C(13,10)
	}
	Write " ] );",!

Exit
	Quit 1
Trap
	Set $ZT=""
	Write:start """"");",!
	&js<alert('Error in GetSegments: #($ZCVT($ZE,"O","JS"))#');>
	Goto Exit
}

ClientMethod textKeyUp() [ Language = javascript ]
{
 
	var raw = self.document.getElementById('rawContent').value;
	if (raw != zenPage.rawDefinition) {
		zenPage.incrementKeyBuffer(raw);
	}
	zenPage.setModified();
}

ClientMethod incrementKeyBuffer(raw, inRedo) [ Language = javascript ]
{
	if ((this._undoingKey) || (zenPage.nextKey == 0) || (!(this._keyBuffer)) || (this._keyBuffer.length == 0)) { 
		zenPage.clearKeyBuffer();
		self.document.getElementById('btnUndo').disabled = false;
		self.document.getElementById('imgUndo').style.color = 'white';
	}
	if (!inRedo) {
		zenPage.clearKeyRedoBuffer();
	}
	
	this._keyBuffer.push(zenPage.rawDefinition);
	zenPage.nextKey++;
	zenPage.rawDefinition = raw;
}

ClientMethod doUndoKey() [ Language = javascript ]
{
	var msg = zenPage.decrementKeyBuffer();
	if (msg.length > 0) {
		alert(msg);
	}
}

ClientMethod decrementKeyBuffer() [ Language = javascript ]
{
	if (!zenPage.nextKey || (zenPage.nextKey == 0)) {
		self.document.getElementById('btnUndo').disabled = true;
		self.document.getElementById('imgUndo').style.color = 'DimGray';
		return($$$Text("No more key strokes to undo."));
	}
	else {
		this._undoingKey = true;
		zenPage.nextKey--;
		var raw = this._keyBuffer.pop();
		self.document.getElementById('rawContent').value = raw;

		if (!this._keyRedoBuffer){
			zenPage.clearKeyRedoBuffer();
		}
		this._keyRedoBuffer.push(zenPage.rawDefinition);
		self.document.getElementById('btnRedo').disabled = false;
		self.document.getElementById('imgRedo').style.color = 'white';
		zenPage.rawDefinition = raw;
		if (zenPage.nextKey == 0) {
			self.document.getElementById('btnUndo').disabled = true;
			self.document.getElementById('imgUndo').style.color = 'DimGray';
		}
		if (zenPage.viewMode == "SVG") {
			if (zenPage.validateContentToDisplay(false)) {
				zenPage.loadTopSegmentsFromServer(true);
			} else {
				var svg = zen('svgGroup');
				var raw = zen('rawContentGroup');
				svg.setHidden(true);
				raw.setHidden(false);
				self.document.getElementById('btnViewMode').title = $$$Text('View visual representation');
				zenPage.viewMode = "RAW";
			}
		}
		return "";
	}
}

ClientMethod decrementKeyRedoBuffer() [ Language = javascript ]
{
	if (this._keyRedoBuffer && (this._keyRedoBuffer.length != 0)) {
		var raw = this._keyRedoBuffer.pop();
		self.document.getElementById('rawContent').value = raw;
		zenPage.incrementKeyBuffer(zenPage.rawDefinition,true);
		zenPage.rawDefinition = raw;
	}
	if (!this._keyRedoBuffer || (this._keyRedoBuffer.length == 0)) {
		self.document.getElementById('btnRedo').disabled = true;
		self.document.getElementById('imgRedo').style.color = 'DimGray';
	}
	if (zenPage.viewMode == "SVG") {
		if (zenPage.validateContentToDisplay(false)) {
			zenPage.loadTopSegmentsFromServer(true);
		} else {
			var svg = zen('svgGroup');
			var raw = zen('rawContentGroup');
			svg.setHidden(true);
			raw.setHidden(false);
			self.document.getElementById('btnViewMode').title = $$$Text('View visual representation');
			zenPage.viewMode = "RAW";
		}
	}
}

ClientMethod clearKeyBuffer() [ Language = javascript ]
{
	this._keyBuffer = [];
	zenPage.nextKey = 0;
	this._undoingKey = false;
	self.document.getElementById('btnUndo').disabled = true;
	self.document.getElementById('imgUndo').src = 'DimGray';
}

ClientMethod clearKeyRedoBuffer() [ Language = javascript ]
{
	this._keyRedoBuffer = [];
	self.document.getElementById('btnRedo').disabled = true;
	self.document.getElementById('imgRedo').style.color = 'DimGray';
}

ClientMethod setModified() [ Language = javascript ]
{
	var isModified = (zenPage.rawDefinition != zenPage.lastSaved);
	this.invokeSuper('setModified',[isModified]);
}

Method IsCustomSchema(pCategory) As %Boolean [ ZenMethod ]
{
	Quit ##class(EnsPortal.HL7.Utils).IsCustomSchema(pCategory)
}

/// User double-clicked on a property box in the diagram.
ClientMethod propertyClick(prop) [ Language = javascript ]
{
	var link = zenPage.GetSegPage(prop);
	if (link != "") {
		window.open(link);
	}
}

Method GetSegPage(pSegName As %String) As %String [ ZenMethod ]
{
	Set tSegName = $P(pSegName,".",*)
	Set:($E(tSegName,*-1,*) = "()") tSegName=$E(tSegName,1,*-2)
	Set tSegName = ..GetFullSegName(tSegName,..Category)
	Quit:""=tSegName ""
		
	Set link = ##class(%CSP.Page).Link("EnsPortal.HL7.SchemaSegmentStructure.zen?SS="_$$$URLENCODE("SS:"_tSegName))
	Quit link
}

ClassMethod GetFullSegName(pSegName As %String, pCategory As %String) As %String
{
	Quit:$D($$$vaSchemaGbl(pCategory,"SS",pSegName)) pCategory_":"_pSegName
	Set tBaseCat=$G($$$vaSchemaGbl(pCategory,"base"))
	Quit:(""=tBaseCat) ""
	Quit ..GetFullSegName(pSegName,tBaseCat)
}

Method GetSegmentDescription(pName) [ ZenMethod ]
{
	Set:($E(pName,*-1,*) = "()") pName=$E(pName,1,*-2)
	set tDesc = ##class(EnsLib.HL7.Schema).GetDescription("SS:"_..Category_":"_pName)
	Quit $S(tDesc="":"",1:pName_" - "_tDesc)
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
		case 'switchNamespace':
			zenPage.changeURLNamespace(value);
		case 'newCustomSegment':
			zenPage.loadSegListFromServer();
			zen('rawLeftColumn').refreshContents(true);
			zenPage.adjustSizes();
		break;
	}
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	Quit:$$$ISERR(tSC)
	
	Set ..Category = $P(..docStruct,":",2)
	Set ..DocType = $P(..docStruct,":",3)
	
	If ..DocType'="" {
		Set tStruct=$$$vaSchemaGbl(..Category,"MS",..DocType)
		Set tRaw = ..GetRawNoPrefixes(tStruct)
	} Else {
		Set tRaw = ""
	}
	Set ..rawDefinition = tRaw
	Set ..lastSaved = tRaw
	
	Quit tSC
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	self.document.addEventListener('mouseup',function(evt) { zenPage.doMouseUp(evt); } );
	self.document.addEventListener('mousemove',function(evt) { zenPage.doMouseMove(evt); } );
	if (zenPage.DocType == "") {
		zenPage.doEdit();
		self.document.getElementById('btnDelete').hidden = true;
	}
}

ClientMethod doMouseUp(evt) [ Language = javascript ]
{
	if (evt.button != 0) return;
	var operation = getOperation();
	if (operation == 'move') {
		moveCancelled();
	} else if ((operation == 'listScroll') || (operation == 'diagramScroll')) {
		setOperation(null);
	}
}

ClientMethod doMouseMove(evt) [ Language = javascript ]
{
	if (getOperation() == 'move') {
		// position locator line to where the current move item started, indicating that no move will occur if mouse released here
		locLineToOrigPos();
	} else if (getOperation() == 'diagramScroll') {
		doDiagramScroll(evt);
	}
}

/// Adjust sizes of components on the page.
ClientMethod onlayoutHandler(load) [ Language = javascript ]
{
	try {
		if (load) {
			this.initializeSVG(true);
		}
		
		if (load) {
			zenPage.initUIConstraints();
		}
		
		this.adjustSizes();
	} catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in onlayoutHandler');
	}
}

ClientMethod initializeSVG(noAdjust) [ Language = javascript ]
{
	if (!noAdjust) this.adjustSizes();
	
	// important for avoiding what appears to be a timing issue in IE
	if (zenPage) {
		zenPage.loadTopSegmentsFromServer(false);
		
		if (zenPage.IsCustomSchema(zenPage.Category)) {
			zenPage.loadSegListFromServer();
		}
	}
}

/// Adjust sizes of components on the page.
ClientMethod adjustSizes() [ Language = javascript ]
{
	try {
		this.initUIConstraints();
		
		var svg = zen('svgGroup');
		var svgDiv = svg.getEnclosingDiv();
		
		//find size of window
		var winHeight = zenGetWindowHeight();
		var winWidth = zenGetWindowWidth() * 0.9;
		
		var th = this.getTitleAreaHeight() + 11;
		var headHgt = self.document.getElementById('header').clientHeight;
		var titleHgt = self.document.getElementById('titlesHTML').clientHeight;
		var iconsHgt = self.document.getElementById('iconsHTML').clientHeight;
		var hgt = winHeight - th - headHgt - titleHgt - iconsHgt;
		var svgHgt = hgt - 60;
		
		var svgWid = winWidth;
		
		svgHgt = Math.max(this._mins.SVG.height,svgHgt);
		svgWid = Math.max(this._mins.SVG.width,svgWid);
		
		var svgCanvasWid = Math.max(this._mins.SVG.canvasWidth,svgWid);

		svgDiv.height = svgHgt;
		svgDiv.width = svgWid;
		
		var root = document.getElementById('zenRoot');
		root.setAttribute('height',svgHgt);
		root.setAttribute('width',svgWid);
		root.setAttribute('svgWidth',svgCanvasWid);
		root.setAttribute('svgHeight',svgHgt);

		// set size of svg components in the diagram
		// test for minimum size
		setCanvasWidth(svgCanvasWid);
		var diagram = document.getElementById('diagramFrame');
		var diagramBox = document.getElementById('diagramBox');
		var diagramScrollGrp = document.getElementById('diagramScrollBtn');
		var diagramScrollBar = document.getElementById('diagramScrollRect');
		var diagramScrollArrow = document.getElementById('diagramScrollArrowDown');
		var rHgt = document.getElementById('rawRightColumn').getAttribute('height');
		var rawHeight = Math.max(this._mins.RAW.height,svgHgt,rHgt);
		if (zenPage.IsCustomSchema(zenPage.Category)) {
			var list = document.getElementById('listFrame');
			var listBox = document.getElementById('listBox');
			var listScrollGrp = document.getElementById('listScrollBtn');
			var listScrollBar = document.getElementById('listScrollRect');
			var listScrollArrow = document.getElementById('listScrollArrowDown');
			list.setAttribute('width',(svgCanvasWid*0.3)-40);
			list.setAttribute('x',20);
			list.setAttribute('height',svgHgt-5);
			listBox.setAttribute('width',(svgCanvasWid*0.3));
			listBox.setAttribute('height',svgHgt-2);
			listBox.setAttribute('x',1);
			document.getElementById('rawLeftColumn').parentElement.width = (svgCanvasWid*0.32);
			document.getElementById('rawSegList').setAttribute('style','max-height:'+rawHeight+'px;overflow-y:auto;display:inline-block;');
			
			diagram.setAttribute('width',(svgCanvasWid*0.5)-30);
			diagram.setAttribute('x',(svgCanvasWid*0.5)-20);
			diagram.setAttribute('height',svgHgt-5);
			diagramBox.setAttribute('width',(svgCanvasWid*0.5)+30);
			diagramBox.setAttribute('x',(svgCanvasWid*0.5)-30-20);
			diagramBox.setAttribute('height',svgHgt-2);
			diagramScrollGrp.setAttribute('transform',"translate("+(svgCanvasWid-20)+",5)");
			diagramScrollBar.setAttribute('height',svgHgt-17);
			diagramScrollArrow.setAttribute('transform',"translate(3,"+(parseInt(svgHgt)-17-14)+") rotate(90,10,12)");
			document.getElementById('spacer').parentElement.width = (svgCanvasWid*0.05);
			document.getElementById('rawRightColumn').parentElement.width = (svgCanvasWid*0.63);
			
			listScrollGrp.setAttribute('transform',"translate("+((svgCanvasWid*0.3))+",5)");
			listScrollBar.setAttribute('height',svgHgt-17);
			listScrollArrow.setAttribute('transform',"translate(3,"+(parseInt(svgHgt)-17-14)+") rotate(90,10,12)");
			zenPage.adjustListScrollBox();
			layoutSegList();
		} else {
			diagram.setAttribute('width',(svgCanvasWid-60)-20);
			diagram.setAttribute('height',svgHgt-5);
			diagramBox.setAttribute('width',svgCanvasWid-20);
			diagram.setAttribute('x',31);
			diagramBox.setAttribute('x',1);
			diagramBox.setAttribute('height',svgHgt-2);
			
			diagramScrollGrp.setAttribute('transform',"translate("+(svgCanvasWid-20)+",5)");
			diagramScrollBar.setAttribute('height',svgHgt-17);
			diagramScrollArrow.setAttribute('transform',"translate(3,"+(parseInt(svgHgt)-17-14)+") rotate(90,10,12)");
			document.getElementById('rawRightColumn').parentElement.width = (svgCanvasWid-20);
		}
		document.getElementById('rawContentGroup').style.height = rawHeight + 'px';
		document.getElementById('rawContentGroup').style.width = svgCanvasWid + 'px';
		zenPage.adjustDiagramScrollBox();
		layoutBoxes(false);
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in adjustSizes');
	}
}

ClientMethod adjustListScrollBox() [ Language = javascript ]
{
	var box = document.getElementById('listScrollBox');
	var barHgt = document.getElementById('listScrollRect').getAttribute('height') - 28 - 2; // subtract 28 for arrows and 2 as buffer
	var wholeHgt = getSegListHgt();
	if (barHgt < wholeHgt) {
		var percent = barHgt / wholeHgt;
		box.setAttribute('height',(percent * barHgt));
	} else {
		box.setAttribute('height',barHgt);
	}
	setListScroll(getListScrollTop());
}

ClientMethod adjustDiagramScrollBox() [ Language = javascript ]
{
	var box = document.getElementById('diagramScrollBox');
	var barHgt = document.getElementById('diagramScrollRect').getAttribute('height') - 28 - 2;
	var wholeHgt = getDiagramHgt();
	if (barHgt < wholeHgt) {
		var hgtPercent = barHgt / wholeHgt;
		box.setAttribute('height',(hgtPercent * barHgt));
	} else {
		box.setAttribute('height',barHgt);
	}
	setScroll(getDiagramScrollTop());
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("HL7 Schema Message Structure")
}

/// Callback to return a list of resources required for a specific HyperEvent.
/// The user must have sufficient privileges on one of the resource/permission pairs
/// to be permitted to execute the hyperevent. An empty string implies the user already
/// has sufficient privileges for the ZenMethod specified in <var>pMethod</var>.
ClassMethod GetHyperEventResources(pMethod As %String = "") As %String
{
	Quit $case(pMethod,
					"DeleteStructure": ..#EDITRESOURCE,
					"PutNewMessageOnServer": ..#EDITRESOURCE,
					: "")
}

ClientMethod initUIConstraints() [ Language = javascript ]
{
	if (!this._mins) {
		this._mins = {
				"SVG": {
					"height": 300,
					"width": 300,
					"canvasWidth": 500
				},
				"RAW": {
					"height": 482
				}
			};
	}
}

}
