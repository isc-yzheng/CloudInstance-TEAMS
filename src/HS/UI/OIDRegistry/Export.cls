/// Utility to Import OID Registry items
Class HS.UI.OIDRegistry.Export Extends HS.HC.UI.Template
{

/// Displayed name of this page.
Parameter PAGENAME = "OID Registry Export";

/// Security requirement
Parameter RESOURCE = "%HSAdmin_InstallationManagement";

/// When running Foundation, this will be part of the docbook link, i.e. DocBook.UI.PortalHelpPage.cls?Key=thisvalue
Parameter FOUNDATIONHELPKEY = "FADM_ch_OID_registry";

/// Page title
Property PageTitle As %ZEN.Datatype.caption [ InitialExpression = {$$$TextHTML("OID Registry Export")} ];

Property HomeApplication As %ZEN.Datatype.string [ InitialExpression = {$S(##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance():"HS.UI.Home.cls",1:"HS.HC.UI.Home.cls")} ];

/// This XML block defines the contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="#(%page.StdTitle)#">
<html id="titleBar" OnDrawContent="DrawTitle"/>
<text id="id" hidden="true"/>
<pane paneName="links"/>
<hgroup>
<spacer width="20"/>
<vgroup>
<pane paneName="selectionPane"/>
<pane paneName="detailPane" enclosingStyle="background: #D3E1EE;font-size: 1.0em;font-family: verdana,arial;margin:5px;padding:5px;"/>
</vgroup>
</hgroup>

</page>
}

XData detailPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<tableNavigatorBar showFilter="false" showPageSize="true" tablePaneId="table"/>
<tablePane id="table"
caption="OID Registry items currently defined:"
fixedHeaders="false"
queryClass="HS.Data.OIDMap" 
queryName="OIDItems" 
multiSelect="true"
maxRows="10000"
showZebra="true"
valueColumn="ID"
useSnapshot="true"
pageSize="15"
>
<column colName="Name" />
<column colName="ID" hidden="true"/>
<column colName="OID"/>
<column colName="Description"/>
<parameter value=""/>
<parameter value=""/>
</tablePane>
<spacer height="5"/>
 <hgroup cellAlign="even" width="450px" cellSize="stretch" >
 <button caption="Select Export Destination" onclick="zenPage.launchPopupWindow('%ZEN.Dialog.fileSelect.cls','FileSelectWindow','status,scrollbars,resizable,width=660,height=700');"/>
 <spacer width="10px"/>
 <label id="lblDirectory" controlClass="lblNormal" enclosingStyle="width:400px" />
 </hgroup>
<spacer height="5"/>
<hgroup>
<button id="btnExportSelected" caption="Export Selected" onclick="zenPage.doExport();"/>
<button id="btnExportAll" caption="Export All" onclick="zenPage.doExport(1);"/>
<button id="btnCancel" caption="Cancel" onclick="zenPage.goHome();" />
</hgroup>
</pane>
}

ClientMethod goHome() [ Language = javascript ]
{
parent.document.location=this.HomeApplication;
}

/// This callback is called after the server-side page object and all of its children are created.<br>
Method %OnAfterCreatePage() As %Status
{
	Quit $$$OK
}

ClientMethod doExport(doAll) [ Language = javascript ]
{
	var table = zen("table");
	var total = table.getProperty("rowCount");	
	if (total < 1) {
		alert($$$Text("Nothing to export."));
		return;	
	}
	//alert('Total: '+total);
	var selectedRows = table.selectedRows;
	var exportAll = doAll;
	//alert("selectedRows before Prepare: "+selectedRows);
	var ok = this.PrepareSelection(selectedRows);
	
	if ((ok == 0) && (exportAll != 1)){
		alert($$$Text("No items were selected for export."));
		return;
	}
	
	// Retrieve path
	var exportPath = zenPage.getComponentById('lblDirectory').value;

	//
	var ok = this.Export(exportAll,exportPath);
}

ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if(popupName=="FileSelectWindow") {
		if(action!="ok") {return}
		zenPage.getComponentById('lblDirectory').setProperty("value",value);
		return;
	}
}

/// Pad selected items into string delimited by "^" then call PrepareAction to store into session variable
ClassMethod PrepareSelection(pSelectedRows) As %String [ ZenMethod ]
{
	Set selectedRows = ""
	For n = 1:1:$L(pSelectedRows,",") If $P(pSelectedRows,",",n) '= "" Set selectedRows = selectedRows _ $S(selectedRows'="":"^",1:"") _ $P(pSelectedRows,",",n)
	Quit ..PrepareAction(selectedRows)
}

ClassMethod PrepareAction(selectedRows) As %String [ ZenMethod ]
{
	KILL %session.Data($Username,"selectedRows")
	Set ok = 0
	Set tDelimiter = "^"
	Set %session.Data($Username,"selectedRows",1)  = selectedRows
	Set n = 1
	Set %session.Data($Username,"selectedRows") = n
	Set n = $O(%session.Data($Username,"selectedRows",""))
	Set tTotal = 0
	While n '= "" {
		Set tRow = %session.Data($Username,"selectedRows",n)
		For m=1:1:$L(tRow,tDelimiter) Set tItem = $P(tRow,tDelimiter,m) If tItem'="" Set tTotal = tTotal + 1
		Set n = $O(%session.Data($Username,"selectedRows",n))
	}
	Set %session.Data($Username,"TotalSelected") = tTotal
	If tTotal > 0 Quit 1
	Else  Quit 0
}

ClassMethod Export(pExportAll, pTargetPath) As %String [ ZenMethod ]
{
	Set tDefaultFilename = "OIDRegistryExport_"_$ZDATE($H,3)_".xml"
	Set tFilename = ##class(%File).GetFilename(pTargetPath)
	Set tDirectory = ##class(%File).GetDirectory(pTargetPath)
	If (tFilename = "") || (tFilename = tDefaultFilename) {
		// Set a default filename if none is specified
		// Also allows overwrite of default filename
		Set tFilename = tDefaultFilename
	} ElseIf ##class(%Library.File).Exists(tDirectory_tFilename) {
		&js<alert(#(..QuoteJS($$$FormatText($$$Text("Cannot overwrite existing file: %1"),pTargetPath)))#)>
		Quit 0
	}
	Set tPath = tDirectory_tFilename
	
	// Retrieve the list of selected rows from the session data.
	Set selectedRows = %session.Data($Username,"selectedRows",1)
	
	// queryString is a list of items to use in the SQL Query when looking only for specific items.  
	// It is in a ('A','B','C') format for SQL
	Set queryString = ""
	If pExportAll="" {
		for i=1:1:$l(selectedRows,"^") {
			// Convert from ^ delimited string to ('A','B','C')
			Set queryString = $S(i=1:"(",1:queryString_",")_"'"_$ZCVT($p(selectedRows,"^",i),"U")_"'"
		}
		Set queryString=queryString_")"
	}
	
	Set tSC = $ClassMethod("HS.Data.OIDMap","ExportToFile",tPath,queryString)	
	
	If $$$ISERR(tSC) {
		&js<alert('#($ZCVT($system.Status.GetErrorText(tSC),"O","JS"))#');>
	}
	Else {
		&js<alert('Export completed successfully.');>
	}
	
	Quit tSC
}

}
