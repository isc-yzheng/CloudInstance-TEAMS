/// Template for maintaining reference tables
/// Includes methods for adding, selecting, and deleting entries
/// Parameters MODELCLASS and ENTITY define the entity being maintained.
/// Parameters TABLE and FIELDSET define the list and detail controls.
Class HS.UI.Template Extends (HS.HC.UI.Template, HS.UI.Util) [ Abstract ]
{

/// Security requirement
Parameter RESOURCE = "%HSAdmin_HubManagement";

/// Name of class that supplies data for the form.
Parameter MODELCLASS As STRING;

/// Display value for the entity being maintained
Parameter ENTITY As STRING;

/// Name of the list table
Parameter TABLE As STRING;

/// Name of the detail field set
Parameter FIELDSET As STRING;

/// Indicates whether internal details are to be displayed in error messages to the UI
Parameter ShowInternalErrorDetails As BOOLEAN = 1;

/// Holds the name of the model class.
Property ModelClass As %String [ InitialExpression = {..#MODELCLASS} ];

/// Holds the display value of the entity being maintained
Property Entity As %String [ InitialExpression = {..#ENTITY} ];

/// Holds the name of the list table
Property Table As %String [ InitialExpression = {..#TABLE} ];

/// Holds the name of the detail field set
Property FieldSet As %String [ InitialExpression = {..#FIELDSET} ];

/// Holds the page title
Property PageTitle As %ZEN.Datatype.caption;

/// Field set header when adding
Property msgAddAction As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Add")} ];

/// Field set header when editting 
Property msgEditAction As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Edit")} ];

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
#gp1 {
	background: #FFFFCC;
	width:100%;
	border: solid gray 1px;
	padding:10px;
}

#table {
	width: 100%;
	height: 250px;
	overflow: auto;
	border: solid gray 1px;	
}

.patStyle {
	color: blue;
	font-size: 1.0em;
	font-weight: bold;
}

.clinStyle {
	color: blue;
	font-size:1.0em;
	font-weight:bold
}

.headerStyle {
	color: blue;
	font-size:1.0em;
	font-weight:bold
}

/* @doc="Item within listBox. Set the font size for this form." */
.listBox {
	border: 1px #77A8D0 solid;
}
.listBoxItem {
	font-size: 13px;
	font-family: verdana;
}
.listBoxItemSelected {
	font-size: 13px;
	font-family: verdana;
}
/* @doc="Selected item within listBox." */
.listBoxItemFocus {
	font-size: 13px;
	font-family: verdana;
}

.comboboxItem {
	font-size: 0.75em;
}

</style>
}

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

/// This XML block defines the links at the top of the page.
XData links [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" id="links" hidden="true"/>
}

/// This XML block defines any selection criteria for the detail below
XData selectionPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" id="selectionPane" hidden="true"/>
}

Method DrawTitle(pSeed As %String) As %Status
{
	Do %application.DrawTitle(..PageTitle,0)
	Quit $$$OK
}

/// Load the object with the given id into the form.
ClientMethod rowSelected(table) [ Language = javascript ]
{
	if (parseInt(table.getProperty('selectedIndex')) >= 0) {
		zenPage.loadDetails(table.getProperty('value'));
		var details=zenPage.getComponentById(this.FieldSet)
		details.setProperty('legend',this.msgEditAction+" "+this.Entity);
		details.setHidden(false);
	}
}

/// Add a record
ClientMethod addRecord() [ Language = javascript ]
{
	zenPage.getComponentById(this.Table).setProperty('selectedIndex',-1);
	var details=zenPage.getComponentById(this.FieldSet)
	details.setProperty('legend',this.msgAddAction+" "+this.Entity);
	zenPage.loadDetails('');
	details.setHidden(false);
}

/// Refresh the display after change, save, or delete
ClientMethod refreshDisplay() [ Language = javascript ]
{
	var table = zenPage.getComponentById(this.Table);
	table.setProperty('selectedIndex',-1);
	mode=zenSynchronousMode;
	zenSynchronousMode=true;
	table.executeQuery();
	zenSynchronousMode=mode;
	table.setProperty('selectedIndex',-1);
	zenPage.getComponentById(this.FieldSet).setHidden(true);
}

/// Delete a record
ClientMethod deleteRecord(id) [ Language = javascript ]
{
	try {
		var ok = this.DeleteId(id);
		if (ok == 1) {
			zenPage.refreshDisplay();
		} else {
			alert(ok);
		}
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// Delete a record, server side
Method DeleteId(pId As %String, pModelClass = "") As %String [ ZenMethod ]
{
	Set:pModelClass="" pModelClass=%page.ModelClass
	Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Hub.HSWS.WebServices","HS.Hub.HSWS.WebServicesClient","DeleteId",.tObj,pModelClass,pId)
	Set tMessage = ..%CheckError(tSC,tObj, ..#ShowInternalErrorDetails, .tWarning)
	If tWarning '= "" {
		&js<alert(#(..QuoteJS(tWarning))#);>
	}
	Quit tMessage
}

/// Get the current clinician from the session and load it into the form
Method %GetCurrentClinician(Output pClinicianId) As %Status
{
	Set tSC=$$$OK
	Set pClinicianId=##Class(HS.Registry.Person.User).SessionUserClinician()
	Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Registry.Person.User.WebServices","HS.Registry.Person.User.WebServicesClient","LoadUser",.tObj,pClinicianId)
	Quit:$$$ISERR(tSC) tSC
	If $D(tObj),$IsObject(tObj) {
		If $$$ISOK(tObj.Status) {
			Set ..%GetComponentById("clinicianId").value = pClinicianId
			Set ..%GetComponentById("clinicianName").value=tObj.LastName_","_tObj.FirstName
		} Else {
			Set tSC=tObj.Status
		}
	} Else {
			Set tSC=$$$ERROR($$$GeneralError,"Clinician not found!")
	}

	Quit tSC
}

/// Descendent can add or remove list items from the database here (instead of deferring filing)
ClientMethod addOrRemove(id, add) [ Language = javascript ]
{
	return 1;
}

/// Returns all possible search terms for a subscription basis
ClassMethod %AllSearchTerms(pBasis As %String, Output pCodes As %ArrayOfDataTypes, Output pNames As %ArrayOfDataTypes) As %Status
{
	Set tSC=$$$OK
	Set tClinTypes("ADM")=$$$Text("Admitting")
	Set tClinTypes("ATT")=$$$Text("Attending")
	Set tClinTypes("CON")=$$$Text("Consulting")
	Set tClinTypes("REF")=$$$Text("Referring")
	Set tClinTypes("ORD")=$$$Text("Ordering")
	Set tClinTypes("PCP")=$$$Text("Primary Care")
	Set tClinTypes("COP")=$$$Text("Copied")
	
	Set pCodes=##class(%ArrayOfDataTypes).%New()
	Set pNames=##class(%ArrayOfDataTypes).%New()
	If (pBasis = "") || (pBasis = "A") {
		//No-op
	} ElseIf (pBasis = "C") { ;Clinician Types
		Set tCode="" For  { 
			Set tCode=$O(tClinTypes(tCode),1,tText) Quit:tCode=""
			Do pCodes.SetAt(tText,tCode)
		}
	} ElseIf (pBasis = "E") { ;Event Types
		Do pCodes.SetAt($$$Text("General"),"GEN")
		Do pCodes.SetAt($$$Text("Referral"),"REF")
		Do pCodes.SetAt($$$Text("Order"),"ORD")
		Do pCodes.SetAt($$$Text("ADT/Demographics"),"ADT")
		Do pCodes.SetAt($$$Text("Result"),"RES")
		Do pCodes.SetAt($$$Text("Document"),"DOC")
		Do pCodes.SetAt($$$Text("Billing"),"BAR")
	} ElseIf (pBasis = "I") { ;Information Types
		Set tStatement = ##class(%SQL.Statement).%New()
		Set tSC = tStatement.%PrepareClassQuery("HS.InfoType.Config","ListAvailableInfoTypes")
		Quit:$$$ISERR(tSC) tSC
		Set tResultSet = tStatement.%Execute()
		Quit:(tResultSet.%SQLCODE<0) $$$ERROR($$$SQLError,tResultSet.%SQLCODE,$SYSTEM.SQL.SQLCODE(tResultSet.%SQLCODE))
		While (tResultSet.%Next()) {
			Do pCodes.SetAt(tResultSet.%Get("PrimaryTypeDisplay"),tResultSet.%Get("PrimaryType"))
		}
		// Add received sub-types to the list of info types
		Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Hub.HSWS.WebServices","HS.Hub.HSWS.WebServicesClient","ListInfoSubTypes",.tList)
		If tSC=$$$OK,tList]"" {
			For tI=1:1:$L(tList,",") {
				Set tItem=$P(tList,",",tI)
				Do pCodes.SetAt(pCodes.GetAt($P(tItem,".",1))_" - "_$P(tItem,".",2,99) ,tItem)
			}
		}
	} ElseIf (pBasis = "PC") { ;Patient Program/Identifiec Clinician
		Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Hub.HSWS.WebServices","HS.Hub.HSWS.WebServicesClient","ListObjects",.tList,"HS_Registry.Program")
		If tSC=$$$OK,$IsObject(tList) {
			Set tCode="" For  { 
				Set tCode=$O(tClinTypes(tCode),1,tText) Quit:tCode=""
				For tIdx=1:1:tList.Items.Count() {
					Set tItem=tList.Items.GetAt(tIdx)
					Do pCodes.SetAt(tItem.Name_" - "_tText,tItem.ID_"|"_tCode)
				}
			}
		}
	} ElseIf (pBasis = "PR") { ;Patient Program/Relationship
		Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Hub.HSWS.WebServices","HS.Hub.HSWS.WebServicesClient","ListObjects",.tRelList,"HS_Push.Relationship")
		If tSC=$$$OK,$IsObject(tRelList) {
			Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Hub.HSWS.WebServices","HS.Hub.HSWS.WebServicesClient","ListObjects",.tProgList,"HS_Registry.Program")
			If tSC=$$$OK,$IsObject(tProgList) {
				For tI=1:1:tRelList.Items.Count() {
					Set tRelation=tRelList.Items.GetAt(tI)
					For tJ=1:1:tProgList.Items.Count() {
						Set tProgram=tProgList.Items.GetAt(tJ)
						Do pCodes.SetAt(tProgram.Name_" - "_tRelation.Name,tProgram.ID_"|"_tRelation.ID)
					}
				}
			}
		}	
	} Else {
		If (pBasis = "S") { ;Source facilities
			Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Hub.HSWS.WebServices","HS.Hub.HSWS.WebServicesClient","ListObjects",.tList,"HS_Facility.Config","IsNull(Name,FacilityCode)")
		} ElseIf (pBasis = "R") { ;Relationships
			Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Hub.HSWS.WebServices","HS.Hub.HSWS.WebServicesClient","ListObjects",.tList,"HS_Push.Relationship")
		} ElseIf (pBasis = "P") { ;Patient Programs
			Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Hub.HSWS.WebServices","HS.Hub.HSWS.WebServicesClient","ListObjects",.tList,"HS_Registry.Program")
		} Else {
			Quit tSC
		}
		If tSC = $$$OK,tList.Status '= $$$OK { Set tSC = tList.Status }
		If tSC=$$$OK,$IsObject(tList) {
			For tIdx=1:1:tList.Items.Count() {
				Set tItem=tList.Items.GetAt(tIdx)
				Do pCodes.SetAt(tItem.Name,tItem.ID)
			}
		}
	}
	
	Set tCode="" 
	For { 
		Set tName = pCodes.GetNext(.tCode) 
		Quit:tCode=""
		Do pNames.SetAt(tCode,tName)
	}

	Quit tSC
}

/// Move a list item from one box to the next, then remove it from the original box
/// after validating that the database updated correctly
ClientMethod arrowClick(from, to, sort) [ Language = javascript ]
{
	var fromCtl = zenPage.getComponentById(from);
	var currIndex = fromCtl.selectedIndex;
	if ( (currIndex < 0) || (currIndex >= fromCtl.getOptionCount()) ) return 0;	
	var optionValue=fromCtl.getOptionValue(currIndex);
	if (zenPage.addOrRemove(optionValue, from=='lst')) {
		var optionText = fromCtl.getOptionText(currIndex);
		var toCtl = zenPage.getComponentById(to);
		toCtl.appendOption(optionValue,optionText);
		fromCtl.removeOption(currIndex);
		fromCtl.selectedIndex=-1;
		if (sort) zenPage.sortList(to);
		return optionValue;
	} else {
		return 0;
	}
}

/// Set filter parameters into UI
ClassMethod %SetFilterParams(pTxtField, pObj) As %Integer
{
	Set tParamCnt=0
	For tIdx=1:1:pObj.ParameterNames.Count() {
		If pObj.ParameterNames.GetAt(tIdx)]"" {
			Set tParamCnt=$I(tParamCnt)
			Set txtParam=pTxtField_tIdx
			Set tParamLabel=pObj.ParameterNames.GetAt(tIdx)_":"
			Set tParamVal=$S(tIdx <= tParamCnt:$ZCVT(pObj.Parameters.GetAt(tIdx),"O","JS"),1:"")
			&js<zen('#(txtParam)#').setValue('#(tParamVal)#');>
			&js<zen('#(txtParam)#').setProperty('label','#(tParamLabel)#');>
		}
	}
	
	Quit tParamCnt
}

}
