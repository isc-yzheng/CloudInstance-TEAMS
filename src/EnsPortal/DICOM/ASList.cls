/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Zen based DICOM Settings UI
Class EnsPortal.DICOM.ASList Extends EnsPortal.Template.standardPage [ System = 4 ]
{

/// User must have READ permissions on the %Ens_EDISchema resource to view this page.
Parameter RESOURCE = "%Ens_EDISchema:READ";

/// Displayed name of this page.
Parameter PAGENAME = "DICOM AS List";

/// The last selected PID
Property PID As %ZEN.Datatype.string;

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
table.tpTable caption {
    background: #D0D0D0;
    color: #404040;
    border: none;
    font-weight: bold;
    padding: 2px;
    text-align: left;
}

</style>
}

/// This XML block defines the contents of the table pane.
XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane containerStyle="padding:20px">
<label id="Text1" value="" containerStyle="padding-bottom:4px;"/>
<spacer height="10" />
<tableNavigatorBar id="tableBar" showFilter="true" showPageSize="true" tablePaneId="table" onfilterChange="zenPage.filterChanged(value);" />
<tablePane id="table"
cellSpacing="2"
autoExecute="true"
caption="You may enter a partial string in the Filter then press the Tab key to reload the table with matching strings. Case insensitive."
filtersDisabled="false"
fixedHeaders="false"
pageSize="100"
queryClass="EnsPortal.DICOM.ASList"
queryName="AbstractSyntaxList"
maxRows="5000"
showZebra="true" showFilters="true"
useSnapshot="true"
useKeys="true"
>
<column colName="UID" header="UID"/>
<column colName="Text" header="Text"/>
<parameter id="P1" value=""/>
</tablePane>
</pane>
}

/// User entered something int he filter. Re-load the table with filter value.
ClientMethod filterChanged(value) [ Language = javascript ]
{
	var table = zen("table");
	table.parameters[0].value = value;
	table.executeQuery();
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	Quit:'tSC tSC
	
	Set msgTable = $$$FormatText($$$Text("The following is a list of DICOM abstract syntax in namespace %1:"),$namespace)	
	Set ..%GetComponentById("Text1").value = msgTable
	
	Quit $$$OK
}

/// Query for DICOM. <br/>
/// The <b>AbstractSyntaxList</b> query returns a list of abstract syntax
Query AbstractSyntaxList(%text As %Library.String = "") As %Library.Query(ROWSPEC = "UID:%Library.String,Text:%Library.String") [ SqlName = DICOMASList, SqlProc ]
{
}

ClassMethod AbstractSyntaxListExecute(ByRef %q As %Library.Binary, %text As %Library.String) As %Library.Status [ ProcedureBlock = 1 ]
{
 Set %q=1
 Set %q("item")=""
 Set %q("%text")=$$$UPPER(%text)
 Quit 1
}

ClassMethod AbstractSyntaxListFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
{
	Set AtEnd=0,Row=""
TOFLoop	Set %q("item")=$o(^EnsDICOM.Dictionary("as","t",%q("item")))
	If %q("item")="" { Set AtEnd=1 QUIT $$$OK } 
	Set uid=$G(^EnsDICOM.Dictionary("as","t",%q("item"))) g:uid="" TOFLoop
	If %q("%text")'="",$$$UPPER(%q("item"))'[%q("%text"),uid'[%q("%text") g TOFLoop
	Set Row=$lb(uid,$Piece(%q("item"),")",2,99))
	QUIT $$$OK
}

ClassMethod AbstractSyntaxListClose(ByRef %q As %Library.Binary) As %Library.Status [ ProcedureBlock = 1 ]
{
 Kill %q
 QUIT $$$OK
}

/// Get the (localized) title string for the page.
Method %OnGetTitle() As %String
{
	Quit ..%OnGetPageName()
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("DICOM AS List","Ensemble")
}

/// Get information to display in the ribbon bar (the Mac-like choice of UI).
/// For wizards this can simply return $$$OK.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String) As %Status
{
	Quit $$$OK
}

}
