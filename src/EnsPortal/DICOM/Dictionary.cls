/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Zen based DICOM Settings UI
Class EnsPortal.DICOM.Dictionary Extends EnsPortal.Template.standardPage [ System = 4 ]
{

/// User must have READ permissions on the %Ens_EDISchema resource to view this page.
Parameter RESOURCE = "%Ens_EDISchema:READ";

/// Displayed name of this page.
Parameter PAGENAME = "DICOM Dictionary";

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
<tableNavigatorBar id="tableBar" showFilter="true" showPageSize="true" showMaxRows="false" tablePaneId="table" onfilterChange="zenPage.filterChanged(value);" />
<tablePane id="table"
cellSpacing="2"
autoExecute="true"
caption="You may enter a partial string in the Filter then press the Tab key to reload the table with matching strings. Case insensitive."
filtersDisabled="false"
fixedHeaders="false"
pageSize="100"
queryClass="EnsPortal.DICOM.Dictionary"
queryName="List"
maxRows="50000"
showFilters="true"
showRowNumbers="false"
showZebra="true" 
useSnapshot="true"
useKeys="true"
>
<column colName="Tag" header="Tag" title="(GroupNumber,ItemNumber)"/>
<column colName="Name" header="Name" title="Text"/>
<column colName="TypeValueRep" header="VR" title="Type Value Rep"/>
<column colName="ValueMultiplicity" header="VM" title="Value Multiplicity"/>
<column colName="HasCode" hidden="true"/>
<column linkCaption="Code" title="When available, click link 'Code' to view all codes for a tag." link="javascript:zenPage.showCodes('#(%query.Tag)#','#(%query.Name)#');"/>

<parameter id="P1" value=""/>

<condition colName="HasCode" predicate="EQ" value="0" cellStyle="disabled" targetCol="Code"/>
<condition colName="HasCode" predicate="EQ" value="1" rowStyle="background:#90FF90;"/>

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

/// Draw table for the selected group.
ClientMethod showItems(group) [ Language = javascript ]
{
	zen("idCodes").setHidden(true);	
	var table = zen("tableItem");
	table.parameters[0].value = group;
	table.parameters[1].value = "";
	table.executeQuery();
}

/// Draw table for the selected group.
ClientMethod showCodes(tag, name) [ Language = javascript ]
{
	zenLaunchPopupWindow(zenLink('EnsPortal.DICOM.CodeList.zen?tag='+tag+'&itemname='+name),'','resizable,width=800,height=700');
}

/// User entered something in the filter. Re-load the table with filter value.
ClientMethod itemfilterChanged(value) [ Language = javascript ]
{
	var table = zen("tableItem");
	table.parameters[1].value = value;
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
	
	Set msgTable = $$$FormatText($$$Text("The following is a list of items in the DICOM dictionary in namespace %1:"),$namespace)	
	Set ..%GetComponentById("Text1").value = msgTable
	Quit $$$OK
}

/// Query to be used by this page. Filter text may be passed in. Result in matching string (case insensitive) in any column.
Query List(%text As %Library.String = "") As %Library.Query(ROWSPEC = "Tag:%Library.String,Name:%Library.String,TypeValueRep:%Library.String,ValueMultiplicity:%Library.String,HasCode:%Library.Boolean") [ SqlName = DICOMDictionary, SqlProc ]
{
}

ClassMethod ListExecute(ByRef %q As %Library.Binary, %text As %Library.String) As %Library.Status [ ProcedureBlock = 1 ]
{
 Set %q=1
 Set %q("tag") = ""
 Set %q("%text") = $$$UPPER(%text)
 Quit 1
}

ClassMethod ListFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
{
	Set AtEnd=0,Row=""
TOFLoop	Set %q("tag")=$o(^EnsDICOM.Dictionary("e","i",%q("tag")))
	If %q("tag")="" { Set AtEnd=1 QUIT $$$OK }
	Set tGrp=$Piece($Piece(%q("tag"),","),"(",2)
	Set tItm=$Piece($Piece(%q("tag"),",",2),")",1)
	Set data = ^EnsDICOM.Dictionary("e","t",tGrp,tItm)
	If %q("%text")'="",$$$UPPER(%q("tag"))'[%q("%text"),$$$UPPER(data)'[%q("%text") g TOFLoop
	Set tName = $p(data,"`",1)
	Set tTypeValueRep = $p(data,"`",2)
	Set tValueMultiplicity = $p(data,"`",3)	
	Set tHascode = ($o(^EnsDICOM.Dictionary("e","t",tGrp,tItm,"e2v","")) '= "")
	Set Row=$lb(%q("tag"),tName,tTypeValueRep,tValueMultiplicity,tHascode)		
	QUIT $$$OK
}

ClassMethod ListClose(ByRef %q As %Library.Binary) As %Library.Status [ ProcedureBlock = 1 ]
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
	Quit $$$Text("DICOM Dictionary","Ensemble")
}

/// Get information to display in the ribbon bar (the Mac-like choice of UI).
/// For wizards this can simply return $$$OK.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String) As %Status
{
	Quit $$$OK
}

}
