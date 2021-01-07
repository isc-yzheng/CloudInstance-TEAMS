/// Define MPI SNO Consent
Class HS.UI.OIDRegistry Extends HS.HC.UI.Util
{

/// Displayed name of this page.
Parameter PAGENAME = "OID Registry";

/// Security requirement
Parameter RESOURCE = "%HSAdmin_InstallationManagement";

/// When running Foundation, this will be part of the docbook link, i.e. DocBook.UI.PortalHelpPage.cls?Key=thisvalue
Parameter FOUNDATIONHELPKEY = "FADM_ch_OID_registry";

Property saveRequiredError As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Code and at least one of OID or URL are required.")} ];

Property msgcancelItem As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Do you wish to discard changes and reset form?")} ];

Property msgdelete As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Do you wish to delete this entry?")} ];

Property OIDID As %String;

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
/* style for table pane */
#table {
	width: 100%;
	overflow: auto;
	border: solid gray 1px;	
}
#gp1 {
	background: #FFFFCC;
	width:400;
	border: solid gray 1px;
}
.patStyle {
	color: blue;
	font-size: 1.0em;
	font-weight: bold;
}
.multiStyle {
	color: black;
	text-decoration: none;
	font-size: .8em;
	width: 8em;
}
</style>
}

/// This XML block defines the contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="#(%page.StdTitle)#">
<html OnDrawContent="DrawTitle" id="title" seed=""/>
<spacer height="10" />
<hgroup>
<spacer width="20"/>
<vgroup cellVAlign="top">
<vgroup>
<pane paneName="detailPane"/>
</vgroup>
<spacer width="50"/>
<vgroup id="formGroup">
<pane paneName="formPane"/>
</vgroup>
</vgroup>
</hgroup>
</page>
}

/// This XML block defines the contents of this page.
XData detailPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<spacer height="5" />

<vgroup>
<hgroup id="gp1" labelPosition="left" containerStyle="padding-top:4px;" cellStyle="padding-left:4px;padding-top:4px;">
<select id="cmbIdentityType" label="Identity Type" onchange="zenPage.refreshTable();" queryClass="HS.Data.OIDType" queryName="DistinctTypes"/>
<text id="txtSearch" label="Search" onchange="zenPage.refreshTable();"/>
</hgroup>
<tableNavigatorBar tablePaneId="table" showPageSize="true"/>
<tablePane id="table"
caption="OID Registry items currently defined:"
fixedHeaders="false"
queryClass="HS.Data.OIDMap" 
queryName="OIDItems" 

maxRows="10000"
showZebra="true"
valueColumn="ID"
onselectrow="zenPage.rowSelected(zenThis);"
useSnapshot="true"
pageSize="15"
>
<column colName="Name" />
<column colName="ID" hidden="true"/>
<column colName="OID"/>
<column colName="Description"/>
<column colName="URL"/>
<parameter value=""/>
<parameter value=""/>
</tablePane>

</vgroup>

</pane>
}

XData formPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<button id="btnAddOID" caption="Add OID" onclick="zenPage.showObject('');"/>
<form id="frmIdentity" labelPosition="left" hidden="true" cellStyle="padding: 2px;">
<text id="IdentityCode" label="Code *" size="60"/>
<textarea id="IdentityCodeAliases" label="Aliases" />
<text id="OID" label="OID *" size="60"/>
<text id="URL" label="URL *" size="60"/>
<text id="Description" label="Description" size="60"/>
<multiSelectSet id="IdentityTypeList" captionClass="multiStyle" width="250" height="190" label="Types"
	enclosingStyle="border:1px inset gray; background-color:white;overflow:auto;"
	 queryClass="HS.Data.OIDType" queryName="DistinctTypes"/>
<spacer height="1"/>
<hgroup id="btnGroup" cellAlign="right" width="100%">
<button id="btnNew" caption="New" title="Create a new item" onclick="zenPage.showObject('');"/>
<spacer width="10"/>
<button id="btnSave" caption="Save" title="Save the current item" onclick="zenPage.saveItem();"/>
<spacer width="10"/>
<button id="btnCancel" caption="Cancel" title="Cancel the current edit operation" onclick="zenPage.cancelItem();"/>
<spacer width="10"/>
<button id="btnDelete" caption="Delete" title="Delete the current item" onclick="zenPage.deleteItem();"/>
<spacer width="10"/>
</hgroup>
<spacer height="1"/>
<hgroup labelPosition="left" cellStyle="padding-right:10px;">
<label label="* indicates required field.  At least one of OID or URL are required." labelStyle="font-size:10px;" align="left"/>
<label id="LastUpdate" label="Last update:" labelStyle="font-size:10px;" controlClass="zenLabel" value=""/>
</hgroup>
<spacer height="1"/>

</form>
</pane>
}

Method DrawTitle(pSeed As %String) As %Status
{
	Set tTitle = $$$TextHTML("OID Registry")
	do %application.DrawTitle(tTitle,0)
	Quit $$$OK
}

ClientMethod getFieldlist() [ Language = javascript ]
{
	try {
		var serviceTypeObject = zenPage.getComponentById("cmbFormServiceType");
		var serviceType = serviceTypeObject.getValue();
		var fields = "";
		var fieldlist = "";
	} catch (ex) {
		alert("Error: " + ex);	
	}
	return fields;
}

ClientMethod refreshTable() [ Language = javascript ]
{
	try {
		var table = zenPage.getComponentById('table');
		table.parameters[0].value = zenPage.getComponentById("cmbIdentityType").getValue();
		table.parameters[1].value = zenPage.getComponentById("txtSearch").getValue();
		table.executeQuery();
		zenPage.hideService(true);
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// Show/hide Service form. 
ClientMethod hideService(flag) [ Language = javascript ]
{
	zenPage.getComponentById("frmIdentity").setHidden(flag);
}

/// Cancel current Facility edit.
ClientMethod cancelItem() [ Language = javascript ]
{
	if (confirm(this.msgcancelItem) == true) {
		this.showObject('');
	}
}

ClientMethod deleteItem() [ Language = javascript ]
{
	try {
		if (confirm(this.msgdelete)) {
			// Variable names originally defined are a bit confusing, notes marked down as below:
 			// IdentityCode in OID Registry is equivalent to OrganizationOID in XUA.
 			// However, IdentityCode together with OID will all be mapped to an ID(this.OIDID) in HS_Data.OIDMap, which instead of IdentityCode will be recognized as OrganizationOID field in HS_IHE_XUA.Config.
 			var isLinkedToXUA = this.CheckAssociation(this.OIDID);
 			if (isLinkedToXUA) { // Check whether the OrganizationOID is associated with XUA entry, if Yes, the OID registry cannot be deleted
 				alert($$$Text("Unable to delete this item as it is associated with an XUA registry entry"));
 			} else {
				var ok = this.DeleteData(this.OIDID);
				if (ok == 1) {
					zenPage.hideService(true);
					var table = zenPage.getComponentById("table");	
					table.executeQuery();
				} else {
					alert(ok);
				}
 			}
		}
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// Return whether OID is associated with XUA registry entry
ClassMethod CheckAssociation(pID As %String) As %Boolean [ ZenMethod ]
{
	Quit ##class(HS.IHE.XUA.Config).OrganizationOIDIndexExists(pID)
}

ClassMethod DeleteData(id) As %String [ ZenMethod ]
{
	
	try {
		Set tSC=##class(HS.Data.OIDMap).%DeleteId(id)
	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	Quit +tSC
}

/// User selected a row in the table. 
ClientMethod rowSelected(table) [ Language = javascript ]
{
	if (table.getValue() > 0) {
		zenPage.showObject(table.getValue());
	}
}

ClientMethod showObject(id) [ Language = javascript ]
{
	// update the property for later use
	this.OIDID = id;
	this.UpdateDetails(id);
}

Method UpdateDetails(PID) [ ZenMethod ]
{
	#dim eException as %Exception.AbstractException
	try {
		
		#dim tObj As HS.Data.OIDMap
		// try to open the object
		
		Set tAliasList=""
		
		&js<zenPage.getComponentById('frmIdentity').setProperty("hidden",false);>
		If PID '= "",##class(HS.Data.OIDMap).%ExistsId(PID) {
			Set tObj = ##class(HS.Data.OIDMap).%OpenId(PID)
			&js<zenPage.getComponentById('btnDelete').setProperty('disabled',false);>
			Set tSelectList=""
			For tI=1:1:tObj.IdentityTypes.Count() {
				Set tType=tObj.IdentityTypes.GetAt(tI)
				Set:$IsObject(tType) tSelectList=tSelectList_","_tType.%Id()
			}
			For tI=1:1:tObj.IdentityCodeAliases.Count() {
				Set tAlias=tObj.IdentityCodeAliases.GetAt(tI)
				If tAliasList'="" {
					Set tAliasList=tAliasList_$Char(10)_tAlias
				} Else {
					Set tAliasList=tAliasList_tAlias
				}
			}
			//&js<zenPage.getComponentById('cmbFormIdentityType').setProperty("disabled",true);>
			
		} Else {
			Set tObj = ##class(HS.Data.OIDMap).%New()
			&js<zenPage.getComponentById('btnDelete').setProperty('disabled',true);>
			Set tSelectList=..%GetComponentById("cmbIdentityType").value
			//&js<zenPage.getComponentById('cmbFormIdentityType').setProperty("disabled",false);>
			
		}
		

		&js<zen("IdentityTypeList").setValue('#($ZCVT(tSelectList,"O","JS"))#');>
		&js<zenPage.getComponentById('OID').setValue('#($ZCVT(tObj.OID,"O","JS"))#');>
		&js<zenPage.getComponentById('IdentityCode').setValue('#($ZCVT(tObj.IdentityCode,"O","JS"))#');>
		&js<zenPage.getComponentById('Description').setValue('#($ZCVT(tObj.Description,"O","JS"))#');>
		&js<zenPage.getComponentById('URL').setValue('#($ZCVT(tObj.URL,"O","JS"))#');>
		&js<zenPage.getComponentById('IdentityCodeAliases').setValue('#($ZCVT(tAliasList,"O","JS"))#');>
		
	}Catch eException {
		Set tError=eException.DisplayString()
		&js<alert('#($zcvt(tError,"O","JS"))#');>
	}
	Quit
}

/// Get user selection and send to server to save
ClientMethod saveItem() [ Language = javascript ]
{
	try {
		var IdentityTypes = zen('IdentityTypeList').getValue();
		var OID = zenPage.getComponentById("OID").getValue();
		var IdentityCode = zenPage.getComponentById("IdentityCode").getValue();
		var Description = zenPage.getComponentById("Description").getValue();
		var URL = zenPage.getComponentById("URL").getValue();
		var Aliases = zenPage.getComponentById("IdentityCodeAliases").getValue();
		
		if ((OID=="")&&(URL=="") || (IdentityCode=="")) { alert(this.saveRequiredError);return;}
		var ok = this.SaveData(this.OIDID, IdentityTypes, IdentityCode, OID, Description, URL, Aliases);
		if (ok == 1) {
			zenPage.getComponentById("table").setProperty("selectedIndex",-1);
			this.refreshTable();
		} else {
			alert(ok);
		}
	} catch(ex) {
	alert("ERROR: " + ex);
	}
}

/// Save data to server
Method SaveData(pID, pIdentityTypes, pIdentityCode, pOID, pDescription, pURL, pAliases) As %String [ ZenMethod ]
{
	Set tSC=$$$OK
	try {
		Set idx=0
		If pID ]"" {
			Set tOBJ=##class(HS.Data.OIDMap).%OpenId(pID)
		} Else {
			Set tOBJ=##class(HS.Data.OIDMap).%New()
		}
		Set tOBJ.IdentityCode=pIdentityCode
		Set tOBJ.OID=$zstrip(pOID,"<>W")
		Set tOBJ.Description=pDescription
		Set tOBJ.URL=$zstrip(pURL,"<>W")
		
		Do tOBJ.IdentityTypes.Clear()
		For tI=1:1:$L(pIdentityTypes,",") {
			Set tID=$P(pIdentityTypes,",",tI)
			Set tType=##Class(HS.Data.OIDType).%OpenId(tID)
			Do:tType'="" tOBJ.IdentityTypes.Insert(tType)
		}
		
		Do tOBJ.IdentityCodeAliases.Clear()
		Set count=$L(pAliases,$Char(10))
		For tI=1:1:count {
			Set tAlias=$P(pAliases,$Char(10),tI)
			Do:tAlias'="" tOBJ.IdentityCodeAliases.Insert(tAlias)
		}
		
		Set tSC=tOBJ.%Save()
		If $$$ISERR(tSC) Set tSC = $system.Status.GetErrorText(tSC)
		Set ..OIDID=tOBJ.%Id()
	} Catch eException {
		Set tSC=eException.DisplayString()
	}

	Quit tSC
}

}
