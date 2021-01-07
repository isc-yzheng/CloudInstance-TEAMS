Class HS.AU.UI.Registry.ELSInteractionCache Extends HS.UI.Util
{

Parameter PAGENAME = "ELS Interaction Cache";

Parameter RESOURCE = "%HSAdmin_InstallationManagement";

Property msgdelete As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Do you wish to delete this entry?")} ];

Property saveRequiredError As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("All fields are required.")} ];

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
caption="ELS Interaction cached items currently defined:"
fixedHeaders="false"
queryClass="HS.AU.ELS.InteractionCache" 
queryName="Items" 

maxRows="1000"
showZebra="true"
valueColumn="ID"
onselectrow="zenPage.rowSelected(zenThis);"
useSnapshot="true"
>
<column colName="ID" hidden="true"/>
<column colName="Target"/>
<column colName="ServiceCategory"/>
<column colName="ServiceInterface"/>
<column colName="ServiceEndpoint"/>
<parameter value=""/>
</tablePane>

</vgroup>

</pane>
}

XData formPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<button id="btnAddValue" caption="Add Value" onclick="zenPage.showObject('');"/>
<form id="frmConfig" labelPosition="left" hidden="true">
<text id="Target" label="Target HPIO *" size="90"/>
<text id="ServiceProvider" label="Service Provider *" size="90"/>
<text id="ServiceCategory" label="Service Category *" size="90"/>
<text id="ServiceInterface" label="Service Interface *" size="90"/>
<text id="ServiceEndPoint" label="Endpoint *" size="90"/>
<textarea id="PayloadCert" cols="64" label="Payload Certificate"/>
<textarea id="TransportCert" cols="64" label="Transport Certificate"/>
<textarea id="PayloadTransportCert" cols="64" label="Payload / Transport Certificate"/>

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
	Set tTitle = $$$TextHTML("ELS Interaction Cache")
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
		Set tSC=##class(HS.AU.ELS.InteractionCache).%DeleteId(id)
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
		
		#dim tObj As HS.AU.ELS.InteractionCache
		// try to open the object
		
		&js<zenPage.getComponentById('frmConfig').setProperty("hidden",false);>
		If PID '= "" {
			Set tObj = ##class(HS.AU.ELS.InteractionCache).%OpenId(PID)
			&js<zenPage.getComponentById('btnDelete').setProperty('disabled',false);>
		} Else {
			Set tObj = ##class(HS.AU.ELS.InteractionCache).%New()
			&js<zenPage.getComponentById('btnDelete').setProperty('disabled',true);>
		}
		
		Set (tCertPayload,tCertTransport,tCertPayloadTransport) = ""
		For tIdx=1:1:tObj.CertRef.Count() {
			Set tCert = tObj.CertRef.GetAt(tIdx)
			Set tType= tCert.UseQualifierLogicalToDisplay(tCert.UseQualifier)
			If tType="P" {
				Set tCertPayload=tCert.QualifiedCertRefValue
			} ElseIf tType="T" {
				Set tCertTransport=tCert.QualifiedCertRefValue
			} ElseIf tType="PT" {
				Set tCertPayloadTransport=tCert.QualifiedCertRefValue
			}
		}

		&js<zenPage.getComponentById('Target').setValue('#($ZCVT(tObj.Target,"O","JS"))#');>
		&js<zenPage.getComponentById('ServiceProvider').setValue('#($ZCVT(tObj.ServiceProvider,"O","JS"))#');>
		&js<zenPage.getComponentById('ServiceCategory').setValue('#($ZCVT(tObj.ServiceCategory,"O","JS"))#');>
		&js<zenPage.getComponentById('ServiceInterface').setValue('#($ZCVT(tObj.ServiceInterface,"O","JS"))#');>
		&js<zenPage.getComponentById('ServiceEndPoint').setValue('#($ZCVT(tObj.ServiceEndpoint,"O","JS"))#');>
		&js<zenPage.getComponentById('PayloadCert').setValue('#($ZCVT(tCertPayload,"O","JS"))#');>
		&js<zenPage.getComponentById('TransportCert').setValue('#($ZCVT(tCertTransport,"O","JS"))#');>
		&js<zenPage.getComponentById('PayloadTransportCert').setValue('#($ZCVT(tCertPayloadTransport,"O","JS"))#');>
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

		ok=1;
		var Target = zenPage.getComponentById("Target").getValue();
		var ServiceProvider = zenPage.getComponentById("ServiceProvider").getValue();
		var ServiceCategory = zenPage.getComponentById("ServiceCategory").getValue();
		var ServiceInterface = zenPage.getComponentById("ServiceInterface").getValue();
		var ServiceEndPoint = zenPage.getComponentById("ServiceEndPoint").getValue();
		var PayloadCert = zenPage.getComponentById("PayloadCert").getValue();
		var TransportCert = zenPage.getComponentById("TransportCert").getValue();
		var PayloadTransportCert = zenPage.getComponentById("PayloadTransportCert").getValue();
		if (Target=="" || (ServiceProvider=="") || (ServiceCategory=="") || (ServiceInterface=="") || (ServiceEndPoint=="")) { alert(this.saveRequiredError);return;}
		var ok = this.SaveData(this.ConfigID, Target, ServiceProvider, ServiceCategory, ServiceInterface, ServiceEndPoint,PayloadCert,TransportCert,PayloadTransportCert);
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
Method SaveData(pID, pTarget, pServiceProvider, pServiceCategory, pServiceInterface, pServiceEndPoint, pPayloadCert, pTransportCert, pPayloadTransportCert) As %String [ ZenMethod ]
{
	Set tSC=$$$OK
	try {
		Set idx=0
		If pID ]"" {
			Set tOBJ=##class(HS.AU.ELS.InteractionCache).%OpenId(pID)
		} Else {
			Set tOBJ=##class(HS.AU.ELS.InteractionCache).%New()
		}
		Do tOBJ.CertRef.Clear()
		Set tOBJ.Target = $zstrip(pTarget,"<>W")
		Set tOBJ.ServiceProvider = pServiceProvider
		Set tOBJ.ServiceCategory=pServiceCategory
		Set tOBJ.ServiceInterface=pServiceInterface
		Set tOBJ.ServiceEndpoint=pServiceEndPoint
		If pPayloadCert]"" {
			Set tCert = ##class(HS.AU.ELS.CertRefCache).%New()
			Set tCert.QualifiedCertRefType="http://ns.electronichealth.net.au/qcr/type/pem/2010"
			Set tCert.UseQualifier=tCert.UseQualifierDisplayToLogical("P")
			Set tCert.QualifiedCertRefValue=pPayloadCert
			Do tOBJ.CertRef.Insert(tCert)
		}
		If pTransportCert]"" {
			Set tCert = ##class(HS.AU.ELS.CertRefCache).%New()
			Set tCert.QualifiedCertRefType="http://ns.electronichealth.net.au/qcr/type/pem/2010"
			Set tCert.UseQualifier=tCert.UseQualifierDisplayToLogical("T")
			Set tCert.QualifiedCertRefValue=pTransportCert
			Do tOBJ.CertRef.Insert(tCert)
		}
		If pPayloadTransportCert]"" {
			Set tCert = ##class(HS.AU.ELS.CertRefCache).%New()
			Set tCert.QualifiedCertRefType="http://ns.electronichealth.net.au/qcr/type/pem/2010"
			Set tCert.UseQualifier=tCert.UseQualifierDisplayToLogical("PT")
			Set tCert.QualifiedCertRefValue=pPayloadTransportCert
			Do tOBJ.CertRef.Insert(tCert)
		}

		Set tSC=tOBJ.%Save()
		Set ..ConfigID=tOBJ.%Id()
	} Catch eException {
		Set tSC=eException.DisplayString()
	}
	Quit tSC
}

Method %OnAfterCreatePage() As %Status
{
	Quit $$$OK
}

}
