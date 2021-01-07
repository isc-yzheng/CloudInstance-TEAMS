/// Define XUA Configuration
Class HS.UI.Registry.XUAConfig Extends HS.HC.UI.Util
{

/// Displayed name of this page.
Parameter PAGENAME = "XUA Registry";

/// Security requirement
Parameter RESOURCE = "%HSAdmin_InstallationManagement";

Property saveRequiredError As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("The name field is required.")} ];

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
caption="Security items currently defined:"
fixedHeaders="false"
queryClass="HS.IHE.XUA.Config" 
queryName="Items" 

maxRows="10000"
showZebra="true"
valueColumn="ID"
onselectrow="zenPage.rowSelected(zenThis);"
useSnapshot="true"
>
<column colName="Name" />
<column colName="ID" hidden="true"/>
<column colName="Organziation"/>
<column colName="CreatorClass"/>
<column colName="ProcessorClass"/>
<parameter value=""/>
</tablePane>

</vgroup>

</pane>
}

XData formPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<button id="btnAdd" caption="Add Configuration" onclick="zenPage.showObject('');"/>
<form id="frmIdentity" labelPosition="left" hidden="true">
<text id="Name" label="Name *" size="60"/>
<text id="CreatorClass" label="CreatorClass" size="60"/>
<text id="Issuer" label="Issuer" size="60"/>
<text id="IssuerX509" label="IssuerX509" size="60"/>
<checkbox id="SignCreatedAssertion" label="Sign Assertion" />
<select id="UseWSSSignature" label="Sign using..." displayList="WSSecuritySignature,Signature" valueList="1,0" showEmpty="false" />
<spacer height="10"/>
<select id="cmbOrganizationOID" label="OrganizationOID" queryClass="HS.Data.OIDMap" queryName="OrganizationItems" maxRows="10000" />
<text id="ProcessorClass" label="ProcessorClass" size="60"/>
<text id="DomainPrefix" label="DomainPrefix" size="60"/>
<text id="DefaultSecurityDomain" label="DefaultSecurityDomain" size="60" />
<text id="OrganizationURL" label="OrganizationURL" size="60" />
<checkbox id="RequireSignature" label="Require Signature" />
<checkbox id="CheckSignerIdentity" label="Check Signer Identity" />

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
<hgroup labelPosition="left" cellStyle="padding-right:10px;">
<label label="* indicates required field" labelStyle="font-size:10px;" align="left"/>
</hgroup>
<spacer height="2"/>

</form>
</pane>
}

Method DrawTitle(pSeed As %String) As %Status
{
	Set tTitle = $$$TextHTML(..#PAGENAME)
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
		table.executeQuery();
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
			var ok = this.DeleteData(this.OIDID);
			if (ok == 1) {
				zenPage.hideService(true);
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
	&sql(SELECT %ID FROM HS_Registry_Service.SOAP WHERE XUAConfiguration = :id)
	If SQLCODE=0 { ;Found, return error.
		Set tSC = $$$HSError($$$HSErrCantDeleteXUAConfig)
	} ElseIf (SQLCODE = 100) { ;Not found, proceed with delete
		Set tSC = ##class(HS.IHE.XUA.Config).%DeleteId(id)
	} Else {
		Set tSC = $$$ERROR($$$SQLError,SQLCODE,$G(%msg))
	}
	Quit $s(tSC:+tSC,1:$system.Status.GetErrorText(tSC))
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
		
		#dim tObj As HS.IHE.XUA.Config
		
		&js<zenPage.getComponentById('frmIdentity').setProperty("hidden",false);>
		If PID '= "",##class(HS.IHE.XUA.Config).%ExistsId(PID) {
			Set tObj = ##class(HS.IHE.XUA.Config).%OpenId(PID)
			&js<zenPage.getComponentById('btnDelete').setProperty('disabled',false);>
			
		} Else {
			Set tObj = ##class(HS.IHE.XUA.Config).%New()
			&js<zenPage.getComponentById('btnDelete').setProperty('disabled',true);>
			
		}
		&js<zenPage.getComponentById('Name').setValue('#($ZCVT(tObj.Name,"O","JS"))#');>
		&js<zenPage.getComponentById('cmbOrganizationOID').setValue('#($S(tObj.OrganizationOID="":"",1:tObj.OrganizationOIDGetObjectId()))#');>
		&js<zenPage.getComponentById('CreatorClass').setValue('#($ZCVT(tObj.SAMLCreatorClass,"O","JS"))#');>
		&js<zenPage.getComponentById('Issuer').setValue('#($ZCVT(tObj.Issuer,"O","JS"))#');>
		&js<zenPage.getComponentById('IssuerX509').setValue('#($ZCVT(tObj.IssuerX509,"O","JS"))#');>
		&js<zenPage.getComponentById('SignCreatedAssertion').setValue('#($ZCVT(tObj.SignCreatedAssertion,"O","JS"))#');>

		&js<zenPage.getComponentById('ProcessorClass').setValue('#($ZCVT(tObj.SAMLProcessorClass,"O","JS"))#');>
		&js<zenPage.getComponentById('DomainPrefix').setValue('#($ZCVT(tObj.DomainPrefix,"O","JS"))#');>
		&js<zenPage.getComponentById('DefaultSecurityDomain').setValue('#($ZCVT(tObj.DefaultSecurityDomain,"O","JS"))#');>
		&js<zenPage.getComponentById('OrganizationURL').setValue('#($ZCVT(tObj.OrganizationURL,"O","JS"))#');>
		&js<zenPage.getComponentById('RequireSignature').setValue('#($ZCVT(tObj.RequireSignature,"O","JS"))#');>
		&js<zenPage.getComponentById('UseWSSSignature').setValue('#($ZCVT(tObj.UseWSSSignature,"O","JS"))#');>
		&js<zenPage.getComponentById('CheckSignerIdentity').setValue('#($ZCVT(tObj.CheckSignerIdentity,"O","JS"))#');>
		
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
		
		var Name = zenPage.getComponentById("Name").getValue();
		var OrganizationOID = zenPage.getComponentById("cmbOrganizationOID").getValue();
		var CreatorClass = zenPage.getComponentById("CreatorClass").getValue();
		var Issuer = zenPage.getComponentById("Issuer").getValue();
		var IssuerX509 = zenPage.getComponentById("IssuerX509").getValue();
		var SignAssertion = zenPage.getComponentById("SignCreatedAssertion").getValue();
		var ProcessorClass = zenPage.getComponentById("ProcessorClass").getValue();

		var DefaultSecurityDomain = zenPage.getComponentById("DefaultSecurityDomain").getValue();
		var DomainPrefix = zenPage.getComponentById("DomainPrefix").getValue();
		var OrganizationURL = zenPage.getComponentById("OrganizationURL").getValue();
		var RequireSignature = zenPage.getComponentById("RequireSignature").getValue();
		var UseWSSSignature = zenPage.getComponentById("UseWSSSignature").getValue();
		var CheckSignerIdentity = zenPage.getComponentById("CheckSignerIdentity").getValue();
	
		if(Name=="") { alert(this.saveRequiredError);return;}
		var ok = this.SaveData(this.OIDID, Name, OrganizationOID, CreatorClass, ProcessorClass, Issuer, IssuerX509, SignAssertion,DomainPrefix,DefaultSecurityDomain,OrganizationURL,RequireSignature,UseWSSSignature,CheckSignerIdentity);
		if (ok == 1) {
			zenPage.getComponentById("table").setProperty("selectedIndex",-1);
			this.refreshTable();
			zenPage.hideService(true);
		} else {
			alert(ok);
		}
	}catch(ex) {
	alert("ERROR: " + ex);
	}
}

/// Save data to server
Method SaveData(pID, pName, pOrganizationOID, pCreatorClass, pProcessorClass, pIssuer, pIssuerX509, pSignAssertion, pDomainPrefix, pDefaultSecurityDomain, pOrganizationURL, pRequireSignature, pUseWSSSignature, pCheckSignerIdentity) As %String [ ZenMethod ]
{
	Set tSC=$$$OK
	try {
		Set idx=0
		If pID ]"" {
			Set tOBJ=##class(HS.IHE.XUA.Config).%OpenId(pID)
		} Else {
			Set tOBJ=##class(HS.IHE.XUA.Config).%New()
			//Set tExistsName = ##class(HS.IHE.XUA.Config).(pOID,pIdentityType,"")
			//If tExistsCode]"" Set tSC = $$$FormatText("This OID already exists for this type") Quit

		}
		Set tOBJ.Name=pName
		Do tOBJ.OrganizationOIDSetObjectId(pOrganizationOID)
		Set tOBJ.SAMLCreatorClass=pCreatorClass
		Set tOBJ.SAMLProcessorClass=pProcessorClass
		Set tOBJ.Issuer=pIssuer
		Set tOBJ.IssuerX509=pIssuerX509
		Set tOBJ.SignCreatedAssertion=$s(pSignAssertion="true":1,1:0)
		Set tOBJ.DomainPrefix=pDomainPrefix
		Set tOBJ.DefaultSecurityDomain=pDefaultSecurityDomain
		Set tOBJ.OrganizationURL=pOrganizationURL
		Set tOBJ.RequireSignature=$s(pRequireSignature="true":1,1:0)
		Set tOBJ.UseWSSSignature=pUseWSSSignature
		Set tOBJ.CheckSignerIdentity=$s(pCheckSignerIdentity="true":1,1:0)
		Set tSC=tOBJ.%Save()
		If $$$ISERR(tSC) Set tSC = $system.Status.GetErrorText(tSC)
		Set ..OIDID=tOBJ.%Id()
	} Catch eException {
		Set tSC=eException.DisplayString()
	}

	Quit tSC
}

}
