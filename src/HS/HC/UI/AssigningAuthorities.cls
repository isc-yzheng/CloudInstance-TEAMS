/// Data entry for Assigning Authorities
Class HS.HC.UI.AssigningAuthorities Extends HS.HC.UI.Template
{

/// Page Title
Property PageTitle As %ZEN.Datatype.caption [ InitialExpression = {$$$TextHTML("Assigning Authority Registry")} ];

/// When running Foundation, this will be part of the docbook link, i.e. DocBook.UI.PortalHelpPage.cls?Key=thisvalue
Parameter FOUNDATIONHELPKEY = "FADM_ch_aa";

/// Standard list of number types
Parameter NUMBERTYPELIST = ",NPI,UPIN,TaxID,DEA,AMA,ADA,HospID,CommunityID,Medicaid,Other";

/// Name of class that supplies data for the assigning authority form
Parameter MODELCLASS = "HS.AssignAuth.Config";

/// Name of the entity being maintained
Parameter ENTITY = "Assigning Authority";

/// Name of the list table
Parameter TABLE = "assignAuthTable";

/// Name of the detail field set
Parameter FIELDSET = "assignAuthFieldSet";

Property msgNameIsRequired As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Please enter a Name.")} ];

Property msgCodeIsRequired As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Please enter a Code.")} ];

Property msgInvalidCode As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Invalid Code.  Please remove any spaces or apostrophes.")} ];

Property msgNewAssigningAuthorityCreated As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("A new assigning authority will be created for this code.")} ];

XData selectionPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" id="selectionPane">
<text id="idTypeId" hidden="true"/>
<spacer height="5"/>
<vgroup id="gp1" labelPosition="left" cellStyle="padding: 2px">
<dataCombo id="cmbIDType" 
dropdownWidth="220"
size="28"
label="Select an Identifier Type:"
valueColumn="1"
choiceColumn="2"
multiColumn="false"
queryClass="HS.AssignAuth.IdentifierType"
queryName="ListIdentifierTypes"
showEmpty="false"
valign="bottom"
onchange="zenPage.typeIdentified(zenThis);"
maxRows="10000">
<parameter id="parmActiveOnly" value="1"/>
</dataCombo>
</vgroup>
</pane>
}

XData detailPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<text id="assignAuthId" hidden="true"/>
<text id="assignAuthCode" hidden="true"/>
<tableNavigatorBar showFilter="false" showPageSize="true" tablePaneId="assignAuthTable"/>
<tablePane id="assignAuthTable" 
caption="Assigning authorities currently defined (click a row to edit):"
queryClass="HS.AssignAuth.Config"
queryName="ListAssigningAuthorities"
maxRows="10000"
showZebra="true"
valueColumn="ID"
onselectrow="zenPage.rowSelected(zenThis);"
pageSize="10"
useSnapshot="true"
>
<column colName="ID" header="ID" hidden="true"/>
<column colName="Name" header="Name" width="200"/>
<column colName="Code" header="Code" width="100"/>
<column colName="OtherId" header="Other ID" width="100"/>
<column colName="AllowMultiple" header="Allow Multiple" width="60" style="text-align:center;" OnDrawCell="displayCheck"/>
<column linkCaption="Delete" link="javascript:zenPage.deleteRecord('#(%query.ID)#');" linkConfirm="Are you sure you want to delete this assigning authority?" width="80"/>
<parameter value="" id="paramIDTypeId"/>
</tablePane>
<spacer height="5"/>
<button id="btnAdd" caption="Add Assigning Authority" onclick="zenPage.addRecord();" disabled="true"/>
<spacer height="5"/>
<fieldSet id="assignAuthFieldSet" hidden="true" labelPosition="left" cellStyle="padding: 4px;">
<hgroup align="left" valign="top">
<vgroup align="left" labelPosition="left" cellStyle="padding: 2px; padding-left: 5px; padding-right: 5px;" valign="top">
<text  id="txtName" label="Name:" size="31"/>
<text  id="txtCode" label="Code:" size="31"/>
<combobox id="cmbNumberType" 
label="Number Type:" 
size="31"
/>
</vgroup>
<vgroup align="left" labelPosition="left" cellStyle="padding: 2px; padding-left: 5px; padding-right: 5px;" valign="top">
<text  id="txtOtherId" label="Other ID:" size="31"/>
<checkbox id="chkMultiple" label="Allow Multiple:"/>
</vgroup>
</hgroup>
<spacer height="5"/>
<button name="btnSave" id="btnSave" caption="Save Assigning Authority" align="center" onclick="zenPage.save();"/>
</fieldSet>
</pane>
}

/// This callback is called after the server-side page object and all of its children are created.
Method %OnAfterCreatePage() As %Status
{
	Set ..%GetComponentById("cmbNumberType").valueList=..#NUMBERTYPELIST
	Quit $$$OK
}

/// Load the assigning authorities for the selected identifier type
ClientMethod typeIdentified(cmbType) [ Language = javascript ]
{
	var idType=cmbType.getValue()
	zen('idTypeId').setValue(idType);	
	zen('assignAuthTable').parameters[0].value = idType;
	zenPage.refreshDisplay();
	zen("btnAdd").setProperty('disabled',false);
	zen("cmbNumberType").setHidden(idType=='DN'?0:1);
	zen("txtName").focus();
}

ClientMethod validate() [ Language = javascript ]
{
	var msg='';
	if (zenPage.getComponentById("txtName").getValue() == '') {
		msg=msg+zenPage.msgNameIsRequired+"\n";
	}
	var txtCode=zenPage.getComponentById("txtCode");
	var code=txtCode.getValue();
	if (code == '') {
		msg=msg+zenPage.msgCodeIsRequired+"\n";
	}
	// Validate formatting.  Calls CheckFormatting method in HS.UI.BaseUtil
	if (this.CheckFormatting(code)==1) {
		msg=msg+zenPage.msgInvalidCode+"\n";
	}
	if (msg == '') {
		return true;
	} else {
		alert(msg);
		return false;
	}
}

/// Load an AA
ClientMethod loadDetails(pId) [ Language = javascript ]
{
	zenPage.getComponentById('assignAuthId').setValue(pId);
	this.UpdateDetails(pId)
	zenPage.getComponentById("txtName").focus()
}

/// Load an assigning authority into the UI
ClassMethod UpdateDetails(pId = "") [ ZenMethod ]
{
	Quit:'pId
	Set tObj = ##class(HS.AssignAuth.Config).%OpenId(pId,,.tSC)
	
	//Do ##class(HS.Util.HubServices).InvokeHubService("HS.Hub.HSWS.WebServices","HS.Hub.HSWS.WebServicesClient","LoadAssigningAuthority",.tObj,pId)
	If '$IsObject(tObj) || '$$$ISOK(tSC) {
		&js<alert("Cannot open object!");>
	} Else {
		&js<zen("txtName").setValue('#($ZCVT(tObj.Name,"O","JS"))#');>
		&js<zen("txtCode").setValue('#($ZCVT(tObj.Code,"O","JS"))#');>
		&js<zen("assignAuthCode").setValue('#($ZCVT(tObj.Code,"O","JS"))#');>
		&js<zen("txtOtherId").setValue('#($ZCVT(tObj.OtherId,"O","JS"))#');>
		&js<zen("chkMultiple").setValue('#(tObj.AllowMultiple)#');>
		&js<zen('assignAuthId').setValue('#(tObj.%Id())#');>
		&js<zen('cmbNumberType').setValue('#(tObj.NumberType)#');>
	}
}

/// Save a new or editted assigning authority to the database
ClientMethod save() [ Language = javascript ]
{
	var idTypeId       = zen('idTypeId').getValue();
	var assignAuthId   = zen('assignAuthId').getValue();
	var name           = zen('txtName').getValue();
	var code           = zen("txtCode").getValue();
	var otherId        = zen('txtOtherId').getValue();
	var numberType     = zen('cmbNumberType').getValue();
	if (zenPage.getComponentById("chkMultiple").getValue()) { var multiple = 1; } 
	else { var multiple = 0; }
	if (zenPage.validate()) {
		if ((assignAuthId != "")&&(zen('txtCode').getValue() != zen('assignAuthCode').getValue())) {
			if (confirm(this.msgNewAssigningAuthorityCreated)) {
				assignAuthId="";
			} else {
				return;	
			}
		}
		var ok=this.SaveData(idTypeId,assignAuthId,name,code,otherId,multiple,numberType);
		if (ok == 1) {
			zenPage.refreshDisplay();
		} else {
			alert(ok);
		}
	}
}

/// Save Assigning Authority
ClassMethod SaveData(pIDTypeId, pId, pName, pCode, pOtherId, pMultiple, pNumberType) As %String [ ZenMethod ]
{
	Set $zt="Error"
	If pId {
		Set tAssignAuth = ##class(HS.AssignAuth.Config).%OpenId(pId,,.tSC)
	} Else {
		Set tAssignAuth = ##class(HS.AssignAuth.Config).%New()
	}
		
	Set tAssignAuth.Name = pName
	Set tAssignAuth.Code = pCode
	Set tAssignAuth.OtherId = pOtherId
	Do tAssignAuth.IdentifierTypeSetObjectId(pIDTypeId)
	Set tAssignAuth.AllowMultiple = pMultiple
	Set tAssignAuth.NumberType = pNumberType

	Set tSC = tAssignAuth.%Save()
	Quit $S($$$ISOK(tSC):tSC,1:..%FormatError($System.Status.GetErrorText(tSC)))
Error Set $ZT=""
	Do BACK^%ETN
	Quit $ZE
}

/// Delete a record, server side
Method DeleteId(pId As %String, pModelClass = "") As %String [ ZenMethod ]
{
	Set tSC = ##class(HS.AssignAuth.Config).%DeleteId(pId)
	Quit $S($$$ISOK(tSC):1,1:$System.Status.GetErrorText(tSC))
}

}
