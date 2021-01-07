/// Define and manage FHIR CSP application behaviors that are not covered in CSP application maintenance.
Class HS.UI.Registry.FHIRCSPConfig Extends HS.UI.Util
{

Parameter PAGENAME = "FHIR CSP Configuration Registry";

Parameter RESOURCE = "%HSAdmin_InstallationManagement";

/// When running Foundation, this will be part of the docbook link, i.e. DocBook.UI.PortalHelpPage.cls?Key=thisvalue
Parameter FOUNDATIONHELPKEY = "FADM_ch_configuration_registry";

Property msgdelete As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Do you wish to delete this entry?")} ];

Property saveURLRequiredError As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("URL is required.")} ];

Property saveServiceNameRequiredError As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Service Config Name is required.")} ];

Property saveServiceClassRequiredError As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Service Class Name is required.")} ];

Property saveConformanceRequiredError As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Conformance or CapabilityStatement Resource Id is required.")} ];

Property saveFHIRVersionRequiredError As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("FHIR Version is required.")} ];

Property saveRSClientRequiredError As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Resource server OAuth client is required when using OAuth.")} ];

Property ConfigID As %String;

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
<tablePane id="table"
bodyHeight="200px"
caption="FHIR CSP Configuration Registry items currently defined:"
fixedHeaders="false"
queryClass="HS.Registry.FHIRCSPConfig" 
queryName="FHIRCSPConfigItems" 

maxRows="1000"
showZebra="true"
valueColumn="ID"
onselectrow="zenPage.rowSelected(zenThis);"
useSnapshot="true"
>
<column colName="URL" header="URL"/>
<column colName="ID" hidden="true"/>
<column colName="ServiceConfigName" header="Service Config Name"/>
<column colName="ServiceClassName" header="Service Class Name"/>
<column colName="ConformanceId" header="Capability Resource Id"/>
<column colName="FHIRVersion" header="FHIR Version"/>
<column colName="DisableCORS" header="Disable CORS"/>
<column colName="UseOAuth" header="Use OAuth"/>
<column colName="ResourceServerOAuthClient" header="OAuth Client"/>
<parameter value=""/>
</tablePane>

</vgroup>

</pane>
}

XData formPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<button id="btnAdd" caption="Add" onclick="zenPage.showObject('');"/>
<form id="frmConfig" labelPosition="left" hidden="true">
<text id="txtURL" label="URL *" size="60" title="(required) CSP application name"/>
<text id="txtServiceConfigName" label="Service Config Name *" size="60" title="(required) Ensemble business service config item name to which to dispatch FHIR requests on this URL"/>
<text id="txtServiceClassName" label="Service Class Name *" size="60" title="(required) Class name of business service config item"/>
<text id="txtConformanceId" label="Capability Resource Id *" size="60" title="(required) Resource id of FHIR Conformance (DSTU2) or CapabilityStatement (STU3 or later) resource for this URL"/>
<combobox size='60' id="cmbFHIRVersion" label="FHIR Version *" title="(required) Version of FHIR that this end point handles"
 displayList=",DSTU2,STU3" valueList=",DSTU2,STU3" />
<checkbox id="chkDisableCORS" label="Disable CORS" title="Disable handling of CORS headers for FHIR requests on this URL"/>
<hgroup id="grpOAuth" label="Use OAuth" labelPosition="left" title="Require OAuth 2.0 and/or OpenID Connect tokens for FHIR requests on this URL">
<checkbox id="chkUseOAuth"/>
<text id="txtRSOAuthClient" label="Client" title="OAuth 2.0 Client name for resource server" size="48" />
</hgroup>
<hgroup id="btnGroup" cellAlign="right" width="100%">
<button id="btnNew" caption="New" title="Create a new item" onclick="zenPage.showObject('');"/>
<spacer width="10"/>
<button id="btnSave" caption="Save" title="Save the current item" onclick="zenPage.saveItem();"/>
<spacer width="10"/>
<button id="btnCancel" caption="Cancel" title="Cancel the current edit operation" onclick="zenPage.hideConfig(true);"/>
<spacer width="10"/>
<button id="btnDelete" caption="Delete" title="Delete the current item" onclick="zenPage.deleteItem();"/>
<spacer width="10"/>
</hgroup>
<hgroup labelPosition="left" cellStyle="padding-right:10px;">
<label label="* indicates required field" labelStyle="font-size:10px;" align="left"/>
<label id="LastUpdate" label="Last update:" labelStyle="font-size:10px;" controlClass="zenLabel" value=""/>
</hgroup>
<spacer height="2"/>
</form>
</pane>
}

Method DrawTitle(pSeed As %String) As %Status
{
	Set tTitle = $$$TextHTML("FHIR CSP Configuration Registry")
	do %application.DrawTitle(tTitle,0)
	Quit $$$OK
}

ClientMethod refreshTable() [ Language = javascript ]
{
	try {
		var table = zenPage.getComponentById('table');
		table.executeQuery();
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// Show/hide Service form. 
ClientMethod hideConfig(flag) [ Language = javascript ]
{
	zenPage.getComponentById("frmConfig").setHidden(flag);
}

ClientMethod deleteItem() [ Language = javascript ]
{
	try {
		if (confirm(this.msgdelete)) {
			var ok = this.DeleteData(this.ConfigID);
			if (ok == 1) {
				zenPage.hideConfig(true);
				var table = zenPage.getComponentById("table");	
				table.executeQuery();
			} else {
				alert(ok);
			}
		}
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

ClassMethod DeleteData(id) As %String [ ZenMethod ]
{
	
	try {
		Set tSC=##class(HS.Registry.FHIRCSPConfig).%DeleteId(id)
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
	this.ConfigID = id;
	this.UpdateDetails(id);
}

Method UpdateDetails(PID) [ ZenMethod ]
{
	#dim eException as %Exception.AbstractException
	try {
		
		#dim tObj As HS.Registry.FHIRCSPConfig
		// try to open the object
		
		&js<zenPage.getComponentById('frmConfig').setProperty("hidden",false);>
		If PID '= "",##class(HS.Registry.FHIRCSPConfig).%ExistsId(PID) {
			Set tObj = ##class(HS.Registry.FHIRCSPConfig).%OpenId(PID)
			&js<zenPage.getComponentById('btnDelete').setProperty('disabled',false);>
		} Else {
			Set tObj = ##class(HS.Registry.FHIRCSPConfig).%New()
			&js<zenPage.getComponentById('btnDelete').setProperty('disabled',true);>
		}
		
		#; Disable the OAuth check box if OAuth2 functionality is not present.
		#if '(##class(%Dictionary.ClassDefinition).%ExistsId("%SYS.OAuth2.AccessToken"))
		do ..%DisableControl("chkUseOAuth", 1)
		#endif
		&js<zenPage.getComponentById('txtURL').setValue('#($ZCVT(tObj.URL,"O","JS"))#');>
		&js<zenPage.getComponentById('txtServiceConfigName').setValue('#($ZCVT(tObj.ServiceConfigName,"O","JS"))#');>
		&js<zenPage.getComponentById('txtServiceClassName').setValue('#($ZCVT(tObj.ServiceClassName,"O","JS"))#');>
		&js<zenPage.getComponentById('txtConformanceId').setValue('#($ZCVT(tObj.ConformanceId,"O","JS"))#');>
		&js<zenPage.getComponentById('cmbFHIRVersion').setValue('#($ZCVT(tObj.FHIRVersion,"O","JS"))#');>
		&js<zenPage.getComponentById('chkDisableCORS').setValue('#($ZCVT(tObj.DisableCORS,"O","JS"))#');>
		&js<zenPage.getComponentById('chkUseOAuth').setValue('#($ZCVT(tObj.UseOAuth,"O","JS"))#');>
		&js<zenPage.getComponentById('txtRSOAuthClient').setValue('#($ZCVT(tObj.ResourceServerOAuthClient,"O","JS"))#');>
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
		
		var URL = zenPage.getComponentById("txtURL").getValue();
		var ServiceConfigName = zenPage.getComponentById("txtServiceConfigName").getValue();
		var ServiceClassName = zenPage.getComponentById("txtServiceClassName").getValue();
		var ConformanceId = zenPage.getComponentById("txtConformanceId").getValue();
		var FHIRVersion = zenPage.getComponentById("cmbFHIRVersion").getValue();
		var DisableCORS = zenPage.getComponentById("chkDisableCORS").getValue()?1:0;
		var UseOAuth = zenPage.getComponentById("chkUseOAuth").getValue()?1:0;
		var RSOAuthClient = zenPage.getComponentById("txtRSOAuthClient").getValue();

		if (URL=="") { alert(this.saveURLRequiredError);return;}
		if (ServiceConfigName=="") { alert(this.saveServiceNameRequiredError);return;}
		if (ServiceClassName=="") { alert(this.saveServiceClassRequiredError);return;}
		if (ConformanceId=="") { alert(this.saveConformanceRequiredError);return;}
		if (FHIRVersion=="") { alert(this.saveFHIRVersionRequiredError);return;}
		if (UseOAuth==1 && RSOAuthClient=="") { alert(this.saveRSClientRequiredError);return;}
		var ok = this.SaveData(this.ConfigID, URL, ServiceConfigName, ServiceClassName, ConformanceId, FHIRVersion, DisableCORS, UseOAuth, RSOAuthClient);
		if (ok == 1) {
			zenPage.getComponentById("table").setProperty("selectedIndex",-1);
			this.refreshTable();
			zenPage.hideConfig(true);
		} else {
			alert(ok);
		}
	}catch(ex) {
	alert("ERROR: " + ex);
	}
}

/// Save data to server
Method SaveData(pID, pURL, pServiceConfigName, pServiceClassName, pConformanceId, pFHIRVersion, pDisableCORS, pUseOAuth, pRSOAuthClient) As %String [ ZenMethod ]
{
	Set tSC=$$$OK
	try {
		If pID ]"" {
			Set tOBJ=##class(HS.Registry.FHIRCSPConfig).%OpenId(pID)
		} Else {
			Set tOBJ=##class(HS.Registry.FHIRCSPConfig).%New()
		}
		#; URL is required (already checked by saveItem), must start with slash, must not end with slash.
		Set tURL = $zstrip(pURL,"<>W")
		If (tURL'="")&&($Extract(tURL)'="/") Set tURL = "/"_tURL
		If ($Extract(tURL,*)="/")&&(tURL'="/") Set tURL = $Extract(tURL,1,*-1)
		Set tOBJ.URL = tURL
		Set tOBJ.ServiceConfigName = $zstrip(pServiceConfigName,"<>W")
		Set tOBJ.ServiceClassName = $zstrip(pServiceClassName,"<>W")
		Set tOBJ.ConformanceId = $zstrip(pConformanceId,"<>W")
		Set tOBJ.FHIRVersion = $zstrip(pFHIRVersion,"<>W")
		Set tOBJ.DisableCORS = pDisableCORS
		Set tOBJ.UseOAuth = pUseOAuth
		Set tOBJ.ResourceServerOAuthClient = pRSOAuthClient
		Set tSC=tOBJ.%Save()
		Set ..ConfigID=tOBJ.%Id()
	} Catch eException {
		Set tSC=eException.DisplayString()
	}
	Quit tSC
}

}
