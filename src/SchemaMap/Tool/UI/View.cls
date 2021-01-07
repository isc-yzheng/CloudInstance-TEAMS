Include SchemaMap

/// This tool is a data viewing, validation, analysis, and 
/// editing tool that helps developers understand and create 
/// mappings between complete patient data schemas
/// such as FHIR, SDA3, Trak, and HL7. 
/// <p>
/// A code generation framework behind this tool generates  
/// the data transformations that execute these mappings. 
/// This framework includes a library of supporting utilities
/// and sub-transformations that handle known issues and 
/// differences between schemas. Features of the front end tool are:
/// <p>
/// View: 
/// <p>
/// Choose an item of interest (resource, object, 
/// or data type) from the source schema to be mapped. 
/// You see a table with one row per field in the source item. 
/// In columns at left is data defined by the schema itself:
/// Data type, list vs. single, object vs. value, required vs. optional. 
/// <p>
/// View-Only:
/// <p>
/// The UI has a view-only mode, which is shipped with the product.
/// In this mode, the UI serves as documentation of field-to-field 
/// mappings from one schema to another. The remainder of this
/// description text concerns the read-write mode used in development
/// to create and modify those mappings. Ignore for view-only mode.
/// <p>
/// Edit: 
/// <p>
/// In columns at right, you can add/edit/save a mapping
/// from each field in the source item to some field in the 
/// target schema. As you work, the tool validates potential 
/// issues and flags them for you automatically. 
/// <p>
/// Generate: 
/// <p>
/// Generated code executes the transformations you defined in the 
/// tool. The generated code is InterSystems DTL, well known to 
/// customers. About 80% of the code for a project is generated 
/// from mappings defined in Schema Mapper. The other 20% must be 
/// hand-written to complete the project.
/// <p>
/// Import: 
/// <p>
/// For each new schema added to this framework, the team writes 
/// code that reads the specification published by the schema 
/// authority, transforms its contents into this code generation 
/// framework's own schema-agnostic notation, then writes the result 
/// out to rows in a CSV file.
/// <p>
/// To start work on a project, one command imports the full
/// code generation framework, plus the schema and mapping 
/// CSV files to be shared by the project. Upon import, these CSV 
/// files become usable as both SQL tables and ObjectScript classes.
/// <p>
/// Data: 
/// <p>
/// Starting from the imported schema and mapping tables, import 
/// generates a structured set of lookup tables and other reference
/// data that drive code generation and other tool features. 
/// <p>
/// Import also generates full class model of each FHIR schema, 
/// for use by DTL, which requires a class model to exist, in order
/// to perform transformations between properties in the objects.
/// <p>
/// Export: 
/// <p>
/// Export is one button click. Exported schema and mapping CSV files 
/// are archived in the project branch, for reference, but not shipped. 
/// Only the generated transformations and supporting code are shipped.
/// <p>
/// Delivery:
/// <p>
/// Delivery of project code is more complex than export, and less 
/// frequent. Delivery involves an automated refactoring of all 
/// delivered code to match the package structure of the project 
/// branch receiving the code. This package structure and its naming 
/// conventions may vary between projects. 
/// <p>
/// Report: 
/// <p>
/// Validation of each mapping entry flags issues, outputs notices in 
/// the editing UI, sends annotations to the output DTL code, and fuels 
/// "percent done" calculations for online progress reports.
/// <p>
/// More detailed reports on the technical issues detected can be 
/// exported for study. Documents for review with expert advisers 
/// also exist; the development team can export these for review 
/// cycles as needed.
/// <p>
/// Link: 
/// <p>
/// The tool automatically creates links in the view,
/// and in its generated reports,
/// whenever the data contains any item of interest, such as  
/// the name of another resource, class, data type, or field. 
/// <p>
/// When you click one of these automatic links, the tool
/// navigates to the source of information. This may be
/// an alternate view in the tool, or it may be a reference
/// site, such as a FHIR specification on HL7.org, an
/// InterSystems class documentation page, or an IETF RFC.
/// 
Class SchemaMap.Tool.UI.View Extends %ZEN.Component.page
{

Parameter RESOURCE = "%Ens_EDISchemaAnnotations:READ";

/// Class name of application this page belongs to.
Parameter APPLICATION;

/// Displayed name of this page.
Parameter PAGENAME = "View Mapping";

/// Domain used for localization.
Parameter DOMAIN;

Property EditEnabled As %Boolean;

Property PairInProject As %Boolean;

Property Path(ZENURL = "PATH");

Property Pair(ZENURL = "PAIR");

Property From As %String;

Property To As %String;

Property Mode(ZENURL = "MODE") [ InitialExpression = "table" ];

Property Sort(ZENURL = "SORT");

Property Package [ InitialExpression = {$$$MapGenDTLPackage} ];

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
body {
	font-size: 12px;
	font-family: Arial;
}
#docContainer {
	overflow-y:scroll;
	border-bottom: 1px solid black;
	border-right: 1px solid black;
}
table.docTable {
	border-collapse: collapse;
}
table.docTable tr th {
	text-align: left;
	padding: 4px;
	overflow-x: hidden;
}
table.docTable tr td {
	text-align: left;
	padding: 4px;
	vertical-align: top;
}
table.docTable tr td.tdTotal {
	text-align: left;
	padding: 4px;
	vertical-align: top;
	border-top: 2px solid black;
}
table tr th.thHeader {
	border-bottom: 1px solid gray;
}
table tr th.tdSpacer {
	width: 20px;
	min-width: 20px;
	max-width: 20px;
}
table tr td.tdSpacer {
	width: 20px;
	min-width: 20px;
	max-width: 20px;
}
</style>
}

/// This XML block defines the contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="View Mapping" >
<spacer height="15px"/>
<hgroup>
<spacer width="20px"/>
<vgroup>
<html id="guideContainer" valign="top" OnDrawContent="DrawGuide" seed="" />
<html id="mapContainer" valign="top" OnDrawContent="DrawContent" seed="" />
</vgroup>
<spacer width="40px"/>
</hgroup>
<spacer height="15px"/>
</page>
}

Method GetCurrentValues(seed As %String) As %Status
{
}

Method DrawGuide(seed As %String) As %Status
{
}

Method DrawContent(seed As %String) As %Status
{
}

Method DrawHelp() As %Status
{
}

Method DrawFAQ() As %Status
{
}

Method DrawSyntax() As %Status
{
}

Method DrawIssueKey() As %Status
{
}

Method DrawClinicalKey() As %Status
{
}

/// SDA3
Method DrawCodeTableDetail(schema As %String) As %Status
{
}

/// FHIR
Method DrawTypeDetail(schema As %String) As %Status
{
}

Method DrawSelector() As %Status
{
}

Method GetSDAExtensionMappingsURL(Output pExtensionURL As %String = "")
{
}

Method DrawPairSelector() As %Status
{
}

Method DrawModeButton() As %Status
{
}

Method DrawClassResource(schema, path, displaySide, order) As %Status
{
}

Method DrawFHIRLevel(schema, path, displaySide, order) As %Status
{
}

Method DrawFHIRResource(schema, path, displaySide, order) As %Status
{
}

Method DrawReport(excludePrimitives As %Boolean = 1) As %Status
{
}

Method SumValuesForPath(titleRow As %Boolean = 0, mapIssues, haveMapping As %Boolean = 0, mapNotes, ByRef difficulty As %Numeric, ByRef mappedNoIssues As %Numeric, ByRef mappedWithIssues As %Numeric, ByRef notMappedWithIssues As %Numeric, ByRef notAnalyzed As %Numeric) As %Status
{
}

Method CalculateDisplayForPath(Output displayList As %List, count As %Numeric, isResourceInProject As %Boolean, isMostImportant As %Boolean, mappedNoIssues As %Numeric, mappedWithIssues As %Numeric, notMappedWithIssues As %Numeric, notAnalyzed As %Numeric) As %Status
{
}

Method DrawTable() As %Status
{
}

Method DrawTableRow(resource As %String, fromPath As %String, index, groupIndex, subIndex, subGroupIndex, totalGroupSize, groupHeaderRow As %Boolean = 0, listFromPath, isSubpath As %Boolean = 0, highlight As %String, ByRef wroteHeader, ByRef wroteMapping, ByRef wroteSourceValue, ByRef wroteFooter) As %Status
{
}

/// Provide action icons for the Actions column in the mapping display table.
Method EditIcon(path, row, column, value, lowlight As %Boolean = 0, table As %Boolean = 0, utility As %String = "", dependsOn As %String = "", extension As %String = "", haveMapping As %Boolean = 0, subObjects As %Boolean = 0, topLevelItem As %Boolean = 0, sourceValue As %String = "", mapSource As %Boolean = 0, defaultValue As %String = "", append As %Boolean = 0) As %String
{
}

ClientMethod onloadHandler(load) [ Language = javascript ]
{
	zenPage.initializeLayout();
	zenPage._firstPage = load;
	
	// handle Back/Forward on client side
	window.addEventListener('popstate', function(evt) { 
		if (evt && evt.state) { 
			var state = evt.state.PROXY;
			var proxy = new zenProxy();
			proxy.firstPage = state.firstPage;
			proxy.Path = state.Path;
			proxy.Pair = state.Pair;
			proxy.Mode = state.Mode;
			proxy.Sort = state.Sort;
			zenPage.redrawPage(proxy, false);
		}
	}, false);
	zenPage.initializeCurrentState();
}

ClientMethod initializeLayout() [ Language = javascript ]
{
	zenPage.setSelector();
	zenPage.showDiv('selectorDiv');
	zenPage.adjustActive();
	zenPage.doResize();
	if (zenPage.Mode === 'report') {
		var div = self.document.getElementById('bottomLine');
		if (div) {
			div.scrollIntoView();
		}
	}
}

ClientMethod initializeCurrentState() [ Language = javascript ]
{
	if (window.history && (typeof window.history.replaceState == 'function')) {
		var state = zenPage.getProxyForState();
		var currentState = { PROXY : state };
		var optionalURL = zenLink("SchemaMap.Tool.UI.View.zen");
		if ((window.history == null) || (window.history.state == null)) { 
			// newly arrived at the page
			window.history.replaceState(currentState, "View Mapping", optionalURL);
		}
		else {
			// we did a refresh on the page
			if ((window.history.state != null) && (window.history.state.PROXY != null) &&
				(window.history.state.PROXY.firstPage == false)) {
				zenPage.pushCurrentState(state);
			}
		}
	}
}

ClientMethod adjustActive(value) [ Language = javascript ]
{
	var check = self.document.getElementById('ActiveAll');
	if (check) {
		if (typeof value === 'undefined') {
			var div = self.document.getElementById('activeStatus');
			if (div) {
				var activeStatus = div.getAttribute('activeStatus');
				switch (activeStatus) {
					case 'true':
						value = true;
						break;
					case 'false':
						value = false;
						break;
					default:
						value = true;
						break;	
				}
			}
		}
		else { // process a boolean or %Boolean value if it is input 
			value = ((value === 1) || (value === true)) ? true : false;
		}
		check.checked = value;
	}
}

ClientMethod getProxyForState(seed) [ Language = javascript ]
{
	var state = new zenProxy();
	state.firstPage = zenPage._firstPage;
	if (seed && typeof seed != 'undefined') {
		var part = seed.split(',');
		if (part.length >= 4) {
			state.Path = part[0];
			state.Pair = part[1];
			state.Mode = part[2];
			state.Sort = part[3];
		}
	}
	else {
		state.Path = zenPage.Path;
		state.Pair = zenPage.Pair;
		state.Mode = zenPage.Mode;
		state.Sort = zenPage.Sort;
	}
	return state;
}

/// handle Back/Forward on client side
ClientMethod pushCurrentState(seed) [ Language = javascript ]
{
	var proxy = zenPage.getProxyForState(seed);
	if (window.history && (typeof window.history.pushState == 'function')) {
		var currentState = { PROXY : proxy };
		var optionalURL = zenLink("SchemaMap.Tool.UI.View.zen");
		window.history.pushState(currentState, "View Mapping", optionalURL);
	}
}

ClientMethod redrawPage(proxy, pushstate) [ Language = javascript ]
{
	if (proxy == null) return;
	var seed = proxy.Path + ',' + proxy.Pair + ',' + proxy.Mode + ',' + proxy.Sort;
	zenPage.reviseDisplay(seed, pushstate);
}

ClientMethod reinitDisplay() [ Language = javascript ]
{
	container = zen('mapContainer');
	if (container) {
		container.refreshContents(true);
		container = zen('guideContainer');
		if (container) {
			container.refreshContents(true);
		}
		zenPage.initializeLayout();
	}
}

ClientMethod reviseDisplay(seed, pushstate) [ Language = javascript ]
{
	zenPage.reviseSelector(seed);
	container = zen('mapContainer');
	if (container) {
		container.seed = seed;
		container.refreshContents(true);
		zenPage.initializeLayout();
		if (typeof pushstate == 'undefined' || pushstate === true) {
			zenPage.pushCurrentState(seed);
		}
	}
	zenPage.setSelector();
}

ClientMethod reviseSelector(seed) [ Language = javascript ]
{
	container = zen('guideContainer');
	if (container) {
		container.seed = seed;
		container.refreshContents(true);
	}
	zenPage.setSelector();
}

ClientMethod setSelector() [ Language = javascript ]
{
	var controls = self.document.getElementsByTagName('select');
	for (var i = 0; i < controls.length; i++) {
		var control = controls[i];
		var schema = control.getAttribute('schema');
		if (schema === 'PAIR') {
			for (var k = 0; k < control.options.length; k++) {
				var option = control.options[k];
				if (option.value === zenPage.Pair) {
					control.selectedIndex = k;
					break;
				}
			}
		}
		else if (schema === zenPage.From) {
			for (var j = 0; j < control.options.length; j++) {
				var option = control.options[j];
				if (option.value.split(',')[0] === zenPage.Path) {
					control.selectedIndex = j;
					break;
				}
			}
		}
		else {
			control.selectedIndex = -1;
		}
	}
	var button = self.document.getElementById("modeButtonGenResource");
	if (button) {
		var onclick = "alert('Please select a resource, then click the Generate button');";
		if (zenPage.Path.length > 0) {
			onclick = "zenPage.transform('" + zenPage.From + "','" + zenPage.To + "','" + zenPage.Path + "');";
		}
		button.setAttribute('onclick', onclick);	
	}
}

ClientMethod adjustHeight() [ Language = javascript ]
{
	var div = self.document.getElementById("docContainer");
	if (div) {
		var n = (zenPage.Mode == "report") ? 320 : 290;
		var adjust = zenGetWindowHeight() - n;
		if (div.offsetHeight > adjust) {
			var text = adjust.toString() + "px";
			div.style.height = text;
			div.style.maxHeight = text;
			div.style.minHeight = text;
			zenPage.pathScrollIntoView(zenPage.Path, zenPage.SourceValue);
		}
		else {
			div.style.height = "";
			div.style.maxHeight = "";
			div.style.minHeight = "";
		}
	}
}

ClientMethod correctHeader() [ Language = javascript ]
{
	var from = zenPage.From;
	var to = zenPage.To;
	var fromFHIR = (from && (typeof from != 'undefined') && (from.length > 0) && from.indexOf('FHIR') >= 0)
	var adjust= {};
	var name= [];
	if (zenPage.Mode == "report") {
		name.push("Path");
		name.push("Rating");
		name.push("Clinical");
		name.push("Project");
		name.push("Dev");
		name.push("Count");
		name.push("WMNI");
		name.push("WMWI");
		name.push("NMWI");
		// end the row here
		name.push("NMNITh");
		name.push("NMNITd");
	}
	else { 
		// handle the last column to the right in a special way, to leave room for vertical scroll bar without introducing a horizontal scroll bar
		name.push(from + "Path");
		name.push(from + "DataType");
		if (zenPage.PairInProject) {
			name.push(from + "Cardinality");
			name.push(to + "MappingIcon");
			name.push(to + "MapIssues");
			name.push(to + "Mapping");
			name.push(to + "Active");
			// end the row here
			name.push(to + "MapNotesTh");
			name.push(to + "MapNotesTd");
		}
		else {
			if (fromFHIR) { 
				name.push(from + "Cardinality");
				// end the row here
				name.push(to + "MappingIconTh");
				name.push(to + "MappingIconTd");
			}
			else {
				// end the row here
				name.push(from + "CardinalityTh");
				name.push(from + "CardinalityTd");
			}
		}
	}
	var item = "";
	var text = "";
	for (var i = 0; i < name.length; i++) {
		item = name[i];
		text = item;
		
		// handle the last column to the right in a special way, to leave room for vertical scroll bar without introducing a horizontal scroll bar
		if (zenPage.PairInProject) {
			if (item.indexOf("MapNotes") >= 0) {
				text = item.substring(0, item.length-2);
			}
		}
		else {
			if (fromFHIR) { 
				if (item.indexOf("MappingIcon") >= 0) {
					text = item.substring(0, item.length-2);
				}
			}
			else {
				if (item.indexOf("Cardinality") >= 0) {
					text = item.substring(0, item.length-2);
				}
			}
		}
		
		var th = self.document.getElementById("th_" + text);
		var tdList = self.document.getElementsByClassName("td_" + text);
		if (th && tdList && tdList.length > 0) {
			var td = tdList[0];
			var value = td.offsetWidth;
			value = (value < 40) ? 40 : value;
			if (item.indexOf("Path") >= 0) {
				var altValue = th.offsetWidth;
				value = (value < altValue) ? altValue : value;
			}
			adjust[item] = value.toString() + "px";
		}
	}
	var item = "";
	for (var j = 0; j < name.length; j++) {
		item = name[j];
		var th = self.document.getElementById("th_" + item);
		var tdList = self.document.getElementsByClassName("td_" + item);
		if (th && tdList && tdList.length > 0) {
			var td = tdList[0];
			th.style.width = adjust[item];
			th.style.minWidth = adjust[item];
			th.style.maxWidth = adjust[item];
			td.style.width = adjust[item];
			td.style.minWidth = adjust[item];
			td.style.maxWidth = adjust[item];
		}
	}
	var header = self.document.getElementById("docHeaderContent");
	if (header) {
		var newWidth = (header.offsetWidth - 1).toString() + "px";
		var div = self.document.getElementById("docContainer");
		if (div) {
			div.style.width = newWidth;
			div.style.minWidth = newWidth;
			div.style.maxWidth = newWidth;
		}
	}
}

/// This client event, if present, is fired when the page is resized.
ClientMethod onresizeHandler() [ Language = javascript ]
{
	zenPage.reinitDisplay();
}

ClientMethod doResize() [ Language = javascript ]
{
	zenPage.adjustHeight();
	zenPage.correctHeader();
}

ClientMethod changePair(pair) [ Language = javascript ]
{
	var seed = ',' + pair + ',' + zenPage.Mode + ',' + zenPage.Sort;
	zenPage.reviseDisplay(seed);
}

ClientMethod getWeightsAndGotoPage(path, pair, mode, sort) [ Language = javascript ]
{
	zenPage.reviseDisplay(path + ',' + pair + ',' + mode + ',' + sort);
}

ClientMethod showDiv(id) [ Language = javascript ]
{
	// we create this div and leave it hidden until this method is called by client
	var div = self.document.getElementById(id);
	if (div) {
		div.style.display = "block";
		div.scrollIntoView();
	}
}

ClientMethod hideDiv(id) [ Language = javascript ]
{
	// we create this div and leave it hidden until this method is called by client
	var div = self.document.getElementById(id);
	if (div) {
		div.style.display = "none";
	}
}

ClientMethod editRowColumnValue(path, sourceValue, mapSourceBoolean, row, column) [ Language = javascript ]
{
	//alert('editRowColumnValue: ' + path + ',' + sourceValue + ',' + mapSourceBoolean + ',' + row + ',' + column);
	var parms = { PATH:path, VALUE:sourceValue, SOURCE:mapSourceBoolean, ROW:row, PAIR:zenPage.Pair };
	var widthValue = zenPage.EditEnabled ? '1180' : '1100';
	var options = 'status, scrollbars, resizable=yes, width=' + widthValue + ', height=900, top=50, left=50';
	zenLaunchPopupWindow(zenLink('SchemaMap.Tool.UI.Edit.zen'), 'EditMapping', options, parms);
}

ClientMethod addRow(path, sourceValue, mapSourceBoolean) [ Language = javascript ]
{
	//alert('UI.View addRow: ' + path + ',' + sourceValue + ',' + mapSourceBoolean);
	var error = zenPage.CreateEmptyMappingEntry(path, sourceValue, mapSourceBoolean);
	if (error.length > 0) {
		alert(error);
	}
	zenPage.refreshAndScrollIntoView(path, sourceValue, mapSourceBoolean);
}

ClientMethod deleteMapping(path, sourceValue, mapSourceBoolean, row, target, promptUser) [ Language = javascript ]
{
	if (typeof promptUser === 'undefined') {
		promptUser = true;
	}
	var source = (typeof sourceValue !== 'undefined' && sourceValue.length > 0) ? sourceValue : path;
	if (!promptUser || confirm('OK to remove this mapping?\n\n  ' + source + ' to ' + target + '\n')) {
		var error = zenPage.DeleteMappingEntry(row);
		if (error.length > 0) {
			alert(error);
		}
		zenPage.refreshAndScrollIntoView(path, sourceValue, mapSourceBoolean);
	}
}

ClientMethod updateActive(path, sourceValue, mapSourceBoolean, row, target, id) [ Language = javascript ]
{
	//alert('updateActive: id=' + id);
	var check = self.document.getElementById(id);
	if (!check) {
		return;
	}
	var error = '';
	var checked = check.checked;
	var setting = checked ? 'active' : 'inactive';
	var checkedBoolean = checked ? 1 : 0;
	
	if (id === 'ActiveAll') {
		if (confirm('Are you sure you want to mark all of the mappings from this resource ' + setting + '?\n\n  ' + zenPage.From + ' ' + path + '\n')) {
			error = zenPage.SetMappingEntryActive(checkedBoolean, path);
		}
		if (error.length > 0) {
			alert(error);
		}
		zenPage.refreshCurrentTable();
	}
	else {	
		var source = (typeof sourceValue !== 'undefined' && sourceValue.length > 0) ? sourceValue : path;
		if (confirm('Are you sure you want to mark this mapping ' + setting + '?\n\n  ' + source + ' to ' + target + '\n')) {
			error = zenPage.SetMappingEntryActive(checkedBoolean, '', row);
		}
		if (error.length > 0) {
			alert(error);
		}
		zenPage.refreshAndScrollIntoView(path, sourceValue, mapSourceBoolean);
	}
}

ClientMethod openTable(path) [ Language = javascript ]
{
	zenPage.reviseDisplay(path + ',' + zenPage.Pair + ',' + zenPage.Mode + ',' + zenPage.Sort);
}

ClientMethod refreshCurrentTable() [ Language = javascript ]
{
	zenPage.reviseDisplay(zenPage.Path + ',' + zenPage.Pair + ',' + zenPage.Mode + ',' + zenPage.Sort);
}

ClientMethod autoMap() [ Language = javascript ]
{
	if (zenPage.HasTarget()) {
		var error = zenPage.ResourceMap();
		if (error.length > 0) {
			alert(error);
		}
	}
	else {
		var parms = { PATH:zenPage.Path, PAIR:zenPage.Pair };
		zenLaunchPopupWindow(zenLink('SchemaMap.Tool.UI.AutoTarget.zen'), 'Target', 'status, scrollbars, resizable=yes, width=560, height=300', parms);
	}
	zenPage.refreshCurrentTable();
}

ClientMethod clear() [ Language = javascript ]
{
	var div = self.document.getElementById('mappingStatus');
	if (div) {
		var manualMappings = div.getAttribute('manualMappings');
		if (manualMappings === 'true') {
			var parms = { PATH:zenPage.Path, PAIR:zenPage.Pair };
			zenLaunchPopupWindow(zenLink('SchemaMap.Tool.UI.Prompt.zen'), 'PromptClear', 'status, scrollbars, resizable=yes, width=560, height=300', parms);
		}
		else {
			zenPage.applyClearAll(false);
		}
	}
}

/// The columns and values input arguments may contain multiple values separated by the \u0002 character.
/// If so, these arguments are parallel collections of column names, and values to place into those columns.
ClientMethod applyValues(path, mapSourceBoolean, row, columns, values, applyAllToXF) [ Language = javascript ]
{
	//alert('applyValues: ' + path + ',' + mapSourceBoolean + ',' + row + ',' + columns + ',' + values + ',' + applyAllToXF);
	var error = '';
	if (values !== null) {
		var action = "EditValue"
		if (typeof row === 'undefined' || row === null) {
			row = '';
		}
		if (row.length > 0 && values.length === 0) {
			error = zenPage.DeleteMappingEntry(row);
		}
		else {
			error = zenPage.SaveRowColumnValue(path, mapSourceBoolean, row, columns, values, applyAllToXF);
		}
		if (error.length > 0) {
			alert(error);
		}
		// if it happens that the server experiences any delay in side actions (such as for mapping objects) 
		// adding this call corrects the refresh timing, so that applyEditPopup can experience its refresh
		var valueList = values.split('\u0002');
		var sourceValue = (valueList && valueList.length > 6) ? valueList[6] : ''; // 0-based position 6 from onPopupAction
		zenPage.refreshAndScrollIntoView(path, sourceValue, mapSourceBoolean);
	}
}

ClientMethod applyEditPopup(path, mapSourceBoolean, row, columns, values, applyAllToXF) [ Language = javascript ]
{
	//alert('applyEditPopup: ' + path + ',' + mapSourceBoolean + ',' + row + ',' + columns + ',' + values + ',' + applyAllToXF);
	zenPage.applyValues(path, mapSourceBoolean, row, columns, values, applyAllToXF);
	var valueList = values.split('\u0002');
	var sourceValue = (valueList && valueList.length > 6) ? valueList[6] : ''; // 0-based position 6 from onPopupAction
	zenPage.refreshAndScrollIntoView(path, sourceValue, mapSourceBoolean);
}

ClientMethod refreshAndScrollIntoView(path, sourceValue, mapSourceBoolean) [ Language = javascript ]
{
	//alert('refreshAndScrollIntoView: ' + path + ',' + sourceValue + ',' + mapSourceBoolean);
	zenPage.refreshCurrentTable();
	zenPage.pathScrollIntoView(path, sourceValue, mapSourceBoolean);
}

/// When scrolling to view path, scroll to view ALL the rows that display the same path value.
ClientMethod pathScrollIntoView(path, sourceValue, mapSourceBoolean) [ Language = javascript ]
{
	//alert('pathScrollIntoView: ' + path + ',' + sourceValue + ',' + mapSourceBoolean);
	var sourceItem = path; // path is mapped to target
	if (typeof mapSourceBoolean === 'undefined') {
		if (typeof sourceValue !== 'undefined' && sourceValue.length > 0) {
			mapSourceBoolean = true;
		}
		else {
			mapSourceBoolean = false;
		}
	}
	if (mapSourceBoolean) {
		sourceItem = 'zzz'; // existing sourceValue row
	}
	var rows = self.document.getElementsByClassName(sourceItem);
	if (rows && rows.length > 0) {
		var viewRow = rows[0];
		if (viewRow) {
			viewRow.scrollIntoView();
		}
	}
}

ClientMethod applyClearAll(value) [ Language = javascript ]
{
	var error = zenPage.ClearResource(value);
	if (error.length > 0) {
		alert(error);
	}
	zenPage.refreshCurrentTable();
}

/// This client event is fired when the a popup page launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if ((action != 'ok') && (action != 'apply')) return false;
	switch(popupName) {
	case 'EditMapping':
		if (value !== null && typeof value.target !== 'undefined') {
			var columns = 'TargetPath\u0002TargetTransform\u0002SourceTransform\u0002MapNotes\u0002ClassMethod\u0002SubTransform\u0002SourceValue\u0002DefaultValue\u0002DependsOn\u0002Extension\u0002Append\u0002ExcludeList\u0002Active';
			var values = zenEscapeJS(value.target); // position 0 when checked in applyValues and applyEditPopup
			values += ('\u0002' + zenEscapeJS(value.toXF));
			values += ('\u0002' + zenEscapeJS(value.sourceXF));
			values += ('\u0002' + zenEscapeJS(value.notes));
			values += ('\u0002' + zenEscapeJS(value.util));
			values += ('\u0002' + zenEscapeJS(value.subXF));
			values += ('\u0002' + zenEscapeJS(value.srcVal)); // position 6 when checked in applyValues and applyEditPopup
			values += ('\u0002' + zenEscapeJS(value.defVal));
			values += ('\u0002' + zenEscapeJS(value.dependsOn));
			values += ('\u0002' + zenEscapeJS(value.extn));
			values += ('\u0002' + ((value.append === true) ? '1' : '0'));
			values += ('\u0002' + zenEscapeJS(value.exclude));
			values += ('\u0002' + '1'); // Active is true by default and is not edited in, or returned by, UI.Edit
			var mapSourceBoolean = (value.mapSource === true) ? '1' : '0'; // this string is written into the args string, where it becomes an integer argument
			var applyAllToXF = (value.applyAllToXF === true) ? '1' : '0'; // this string is written into the args string, where it becomes an integer argument
			var args = "'" + value.path + "'," + mapSourceBoolean + ",'" + value.row + "','" + columns + "','" + values + "'," + applyAllToXF;
			//alert('onPopupAction: applyEditPopup args: ' + args);
			setTimeout("zenPage.applyEditPopup(" + args + ");", 0);
		}
		break;
	case 'PromptClear':
		if (value !== null) {
			if (value.clearAutoMap || value.clearManualMap) {
				setTimeout("zenPage.applyClearAll(" + value.clearManualMap + ");", 0);
			}
		}
		break;
	case 'Target':
	case 'ConfigDelivery':
		setTimeout("zenPage.refreshCurrentTable();", 0);
		break;
	default:
		break;
	}
}

/// Save a mapping table entry.
Method SaveRowColumnValue(path, mapSource As %Boolean = 0, row, columns, values, applyAllToXF As %Boolean = 0) As %String [ ZenMethod ]
{
}

/// Map from the source to a target that shares the same name as the source
Method ResourceMap() As %String [ ZenMethod ]
{
}

/// Returns true if there is a target that shares the same name as the source
Method HasTarget() As %Boolean [ ZenMethod ]
{
}

/// Clears mapping table for the given resource
Method ClearResource(clearAll As %ZEN.Datatype.boolean) As %String [ ZenMethod ]
{
}

/// This method creates and displays a new, empty mapping table entry for a given "from" path, 
/// after one mapping table entry already exists for that same "from" path.
/// <p>
/// Running this method creates a new row that is empty. The user edits this row to add the mapping.
/// <p>
/// There can be a lot of ways to handle this UX case, but this way turned out to be 
/// the simplest to implement when both back end and front end code are considered.
/// <p>
/// TO DO: The back end method checks to see if there is already at least 1 mapping for this path.
/// If not, it does nothing and returns a message. In practice, this case should not happen because
/// the Add Row icon does not display in the row when there are 0 existing mappings for the path.
/// Instead the Add Row icon is hidden and the user must click the Edit icon to add the first mapping for that row.
Method CreateEmptyMappingEntry(path As %String, sourceValue As %String, mapSource As %Boolean = 0) As %String [ ZenMethod ]
{
}

/// Delete a mapping table entry
Method DeleteMappingEntry(row) As %String [ ZenMethod ]
{
}

/// Set only the Active status of a mapping table entry
Method SetMappingEntryActive(status As %Boolean = 1, resource As %String, row As %String) As %String [ ZenMethod ]
{
}

ClientMethod userWillWait() [ Language = javascript ]
{
	return confirm("This operation takes a few seconds to complete. You will see another message when it is done. Proceed?")
}

ClientMethod export(dir) [ Language = javascript ]
{
	var error = zenPage.ExportProjectFiles();
	if (error.length > 0) {
		alert(error);
	}
	else {
		alert('Successfully exported all work from the current project to JSON and CSV files in\n\n' + dir);
	}
}

ClassMethod ExportProjectFiles() As %String [ ZenMethod ]
{
}

ClientMethod exportReports(dir, from, to) [ Language = javascript ]
{
	// If from or to is not supplied, output all reports
	var allReports = false;
	if ((typeof from == 'undefined') || (typeof to == 'undefined')) {
		allReports = true;
		var from = '';
		var to = '';
	}
	if (allReports) {
		var msg = 'This will export mapping issue and progress reports to files in\n\n ' + dir;
		msg += '\n\nOK to begin generating reports in the background now?\nSome UI controls might not respond until this job completes.';
		if (confirm(msg)) {
			zenPage.ExportReportFilesAsync();
		}
	}
	else {
		if (from.length === 0 || to.length === 0) {
			return;
		}
		var error = zenPage.ExportReportFilesSync(from, to);
		if (error.length > 0) {
			alert(error);
		}
		else {
			alert('Successfully exported mapping issue and progress reports to files in\n\n ' + dir);
		}
	}
}

ClassMethod ExportReportFilesSync(from As %String = "", to As %String = "") As %String [ ZenMethod ]
{
}

ClassMethod ExportReportFilesAsync(from, to) [ ZenMethod ]
{
}

ClientMethod configure() [ Language = javascript ]
{
	var parms = { };
	var options = 'status, scrollbars, resizable=yes, top=50, left=50, width=1000, height=930';
	zenLaunchPopupWindow(zenLink('SchemaMap.Tool.UI.Config.zen'), 'ConfigDelivery', options, parms);
}

ClientMethod configureLookup(pair) [ Language = javascript ]
{
	var parms = { PAIR:pair };
	var widthValue = zenPage.EditEnabled ? '850' : '770';
	var heightValue = zenPage.EditEnabled ? '930' : '700';
	var options = 'status, scrollbars, resizable=yes, top=50, left=50, width=' + widthValue + ', height=' + heightValue;
	zenLaunchPopupWindow(zenLink('SchemaMap.Tool.UI.Lookup.zen'), 'ConfigLookup', options, parms);
}

ClientMethod viewReport(fileName) [ Language = javascript ]
{
	// CSP and Zen security restrictions do not allow window.open on a report file using a file:/// URL
	// however, we can read the report file from the server and display it as HTML content in a Zen dialog
	var parms = { NAME:fileName };
	var options = 'status, scrollbars, resizable=yes, top=50, left=50, width=850, height=930';
	zenLaunchPopupWindow(zenLink('SchemaMap.Tool.UI.File.zen'), 'ViewReport', options, parms);
}

ClientMethod transform(from, to, resource) [ Language = javascript ]
{
	if (typeof resource == 'undefined') {
		var resource = '*';
	}
	if (resource && resource.length > 0) {
		var prefix = "";
		if (resource === '*') {
			var error = zenPage.GetResourceCount(from, to);
			if (error && (typeof error != 'undefined') && error.length > 0) {
				if (error.indexOf("ERROR") >= 0) {
					alert(error);
				}
				else {
					prefix = error;
				}
			}
			if (prefix.length > 0) {
				if (confirm(prefix + 'OK to begin generating transformation code in the background now?\nSome UI controls might not respond until this job completes.')) {
					zenPage.GenerateTransformsAsync(zenPage.Package, from, to);
				}
			}
		}
		else {
			var error = zenPage.GenerateTransformsSync(zenPage.Package, from, to, resource);
			if (error.length === 0) {
				alert('Successfully generated code in the ' + zenPage.Package + '.' + from + '.' + to + '.' + resource + ' package that transforms ' + resource + ' from ' + from + ' to ' + to);
				zenPage.refreshCurrentTable();
			}
			else {
				alert(error);
			}
		}
	}
}

ClassMethod GenerateTransformsSync(package, from, to, resource) As %String [ ZenMethod ]
{
}

ClassMethod GenerateTransformsAsync(package, from, to) [ ZenMethod ]
{
}

ClassMethod GetResourceCount(from As %String, to As %String) As %String [ ZenMethod ]
{
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
}

}
