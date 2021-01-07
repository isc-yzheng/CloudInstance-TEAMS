/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Dialog to let user add basics of a new FFD file.
Class EnsPortal.DICOM.CodeList Extends EnsPortal.Dialog.standardDialog [ System = 4 ]
{

/// User must have READ permissions on the %Ens_EDISchema resource to view this page.
Parameter RESOURCE = "%Ens_EDISchema:READ";

/// Displayed name of this page.
Parameter PAGENAME = "DICOM Code List";

/// If true, then this dialog displays an Apply button.
Parameter APPLYBUTTON As BOOLEAN = 0;

/// DICOM tag name passed in.
Property Tag As %ZEN.Datatype.string(ZENURL = "tag");

/// This XML block defines the contents of this dialog.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" cellStyle="padding-bottom:8px;">
<hgroup>
<spacer width="20"/>
<vgroup labelPosition="left">
<spacer height="5"/>
<vgroup labelPosition="left" >
<label id="sTag" label="Tag:" labelClass="caption" valign="middle" value="#(%page.Tag)#" enclosingStyle="font-size:12px;"/>
<label id="sName" label="Name:" labelClass="caption" valign="middle" value="" enclosingStyle="font-size:12px;"/>
<label id="sVR" label="Type Value Rep:" labelClass="caption" valign="middle" value="" enclosingStyle="font-size:12px;"/>
<label id="sVM" label="Value Multiplicity:" labelClass="caption" valign="middle" value="" enclosingStyle="font-size:12px;"/>
</vgroup>
<spacer height="1"/>
<!--<tableNavigatorBar id="tableBar" showFilter="true" showPageSize="true" tablePaneId="table" onfilterChange="zenPage.filterChanged(value);"/>-->
<tablePane id="table"
cellSpacing="2"
filtersDisabled="true"
fixedHeaders="false"
queryClass="EnsPortal.DICOM.CodeList"
queryName="CodeList"
maxRows="5000"
showZebra="true" 
showFilters="true"
useSnapshot="true"
showRowNumbers="false"
dataSource="columns"
>
<column colName="Code" header="Code"/>
<column colName="Meaning" header="Meaning" OnDrawCell="putCarriageReturnsIn"/>

<parameter id="P1" value="#(%page.Tag)#"/>
<parameter value=""/>

</tablePane>
</vgroup>
<spacer width="20"/>
</hgroup>
</pane>
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	Quit:'tSC tSC
	
 	Set tGrp = $Piece($Piece(%page.Tag,","),"(",2)
	Set tItm = $Piece($Piece(%page.Tag,",",2),")",1)
	Set data = ^EnsDICOM.Dictionary("e","t",tGrp,tItm)
	Set tName = $P(data,"`",1)
	Set tTypeValueRep = $p(data,"`",2)
	Set tValueMultiplicity = $p(data,"`",3)	
	Set ..%GetComponentById("sName").value = tName
	Set ..%GetComponentById("sVR").value = tTypeValueRep
	Set ..%GetComponentById("sVM").value = tValueMultiplicity

	Quit $$$OK
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit $$$TextHTML("DICOM Code List")
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit ""
}

/// User entered something int he filter. Re-load the table with filter value.
ClientMethod filterChanged(value) [ Language = javascript ]
{
	var table = zen("table");
	table.parameters[1].value = value;
	table.executeQuery();
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	return "";
}

/// Query to be used by this page. Tag should be passed in. Filter text may be passed in. Result in matching string (case insensitive) in any column.
Query CodeList(%tag As %Library.String, %text As %Library.String = "") As %Library.Query(ROWSPEC = "Meaning:%Library.String,Code:%Library.String") [ SqlName = DICOMDictionaryCodeList, SqlProc ]
{
}

ClassMethod CodeListExecute(ByRef %q As %Library.Binary, %tag As %Library.String, %text As %Library.String) As %Library.Status [ ProcedureBlock = 1 ]
{
 Set %q=1
 Set %q("tag")=%tag
 Set %q("group")=$Piece($Piece(%q("tag"),","),"(",2)
 Set %q("item")=$Piece($Piece(%q("tag"),",",2),")",1)
 Set %q("%text")=$$$UPPER(%text)
 Set %q("code")=""
 Quit 1
}

ClassMethod CodeListFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
{
	Set AtEnd=0,Row=""
	For {
		Set %q("code")=$o(^EnsDICOM.Dictionary("e","t",%q("group"),%q("item"),"e2v",%q("code")))
		If %q("code")="" { Set AtEnd=1 QUIT }
		Set tMeaning = ^EnsDICOM.Dictionary("e","t",%q("group"),%q("item"),"e2v",%q("code"))
		If (%q("%text")'="")&&($$$UPPER(%q("code"))'[%q("%text"))&&($$$UPPER(tMeaning)'[%q("%text")) Continue
		Set Row=$lb($Case(tMeaning,"":"-",:tMeaning),%q("code"))
		Quit
	}
	QUIT $$$OK
}

ClassMethod CodeListClose(ByRef %q As %Library.Binary) As %Library.Status [ ProcedureBlock = 1 ]
{
 Kill %q
 QUIT $$$OK
}

/// Method borrowed from HL7 Code Schemas page to ensure that column width does not get too big
Method putCarriageReturnsIn(table As %ZEN.Component.tablePane, name As %ZEN.Datatype.string, seed As %ZEN.Datatype.string) As %Status
{
	Set tLine = %query(name)
	Set tOutput = ""
	Set maxLength = 90
	Set tCharsLeft = $L(tLine)
	Set tCurrPosition = 0

	While (tCharsLeft > maxLength) {
		Set tBRLocation = $F(tLine," ",tCurrPosition + maxLength) - 1 //-1 offset because this function returns the char *after* the space
		//now, replace that location with a <br>
		Quit:(tBRLocation=-1)
		Set tOutput = tOutput_..EscapeHTML($E(tLine,tCurrPosition,tBRLocation))_"<br>"
		//set the current position to the location of the br, and go through the loop
		//until the line length is less than the maximum number of characters
		Set tCurrPosition = tBRLocation+1
		Set tCharsLeft = $L(tLine) - tCurrPosition
	}
	Set tOutput = tOutput_..EscapeHTML($E(tLine,tCurrPosition,*))
	Write tOutput
	Quit $$$OK
}

}
