Class HS.Test.UI.PIXMerge Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Merge Patient MRNs";

Parameter SERVICEREGISTRYENTRY = "PIXv3.Manager";

Parameter SERVICEDEVICEFUNCTION = "PIXv3.Manager|PIXv2.Manager";

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
.textReadOnly {
	border: 1px inset threedface;
	color:#777777;
	background: #EEEEEE;
}
</style>
}

/// This XML block defines the contents of the ICE IHE test workflow pane.
XData Contents
{
<page title="HealthShare IHE Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<spacer height="15"/>
<html>Please enter patient name and identifiers</html>
<spacer height="5"/>
<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left">
<spacer height="5"/>
<checkbox label="Enable logging" id="chkLogging" title="Route traffic through tcp trace utility"/>
<hgroup>
<radioSet id="version" valueList="v2,v3" captionClass="lblNormal" onclick="zenPage.UpdateSvcParams();"/>
</hgroup>
<text label="First Name:" name="FirstName" id="txtFirstName" size="30" tabIndex="5" />
<text label="Middle Name:" name="MiddleName" id="txtMiddleName" size="30" tabIndex="6" />
<text label="Last Name:" name="LastName" id="txtLastName" size="30" tabIndex="10" />
<dataCombo id="cmbAA" label="AssigningAuthority:" size="80" tabIndex="65" onchange="zenPage.GetNextMRN()"
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreateAssigningAuthorityRS"
	maxRows="10000">
</dataCombo>
<text label="AssigningAuthority OID:" name="aaOID" id="txtAAOID" size="80" readOnly="1" controlClass="textReadOnly" />
<dataCombo id="cmbFacility" label="Facility:" size="80" tabIndex="81"
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreateFacilityRS"
	maxRows="10000">
</dataCombo>
<text label="MRN:" name="MRN" id="txtMRN" size="22" readOnly="0" />
<text label="Prior MRN:" name="PriorMRN" id="txtPriorMRN" size="22" readOnly="0" />
<dataCombo id="cmbServiceRegistry" size='80' label="EndPoint: *" dropdownWidth="800" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreatePIXPDQServiceRegistryRS"
	maxRows="10000">
	<parameter id="pType" value="SOAP"/>
</dataCombo>
<spacer height="15"/>

<hgroup width="40%" cellAlign="right">
<button id="btnSend" caption=" Submit PIX Merge Request " onclick="zenPage.StartSend('btnSend',1);" />
<spacer width="5" />
<button id="btnClearDemo" caption=" Clear " onclick="zenPage.ClearDemographics();" />
<spacer width="5" />
</hgroup>
</form>
<vgroup>
<pane paneName="asyncPane"/>
</vgroup>
<pane id="paneResults"/>
</pane>
</page>
}

ClientMethod ClearDemographics() [ Language = javascript ]
{
	var fname = this.getComponentById('txtFirstName');
	var mname = this.getComponentById('txtMiddleName');
	var lname = this.getComponentById('txtLastName');
	var facility = this.getComponentById('cmbFacility');
	var aa = this.getComponentById('cmbAA');
	var mrn = this.getComponentById('txtMRN');
	var priormrn = this.getComponentById('txtPriorMRN');
	var aaoid = this.getComponentById('txtAAOID');
	var svc = this.getComponentById('cmbServiceRegistry');
	
	fname.setValue("");
	mname.setValue("");
	lname.setValue("");
	facility.setValue("");
	aa.setValue("");
	mrn.setValue("");
	priormrn.setValue("");
	aaoid.setValue("");
	svc.setValue("");
	var results=this.getComponentById("paneResults")
	for (var n = 0; n < results.children.length; n++) {
		results.removeChild(results.children[n]);
	}
}

ClientMethod GoPIXQuery() [ Language = javascript ]
{
	var queryParam = "?PATIENTMRN="+zen('txtMRN').getValue()+"&PATIENTAA="+zen('cmbAA').getValue();
	window.location="HS.Test.UI.PIXQuery.cls"+queryParam;
}

/// Get the next automatically-assigned MRN for the home facility
Method GetNextMRN() [ ZenMethod ]
{
	Set tAA = %page.%GetComponentById("cmbAA").value
	Set tAAOID=##class(HS.Data.OIDMap).OIDForType(tAA,"AssigningAuthority")
	&js<zen('txtAAOID').setValue('#(tAAOID)#');>
	If ##class(HS.Facility.Config).%ExistsId(tAA),%page.%GetComponentById("cmbFacility").value="" {
		&js<zen('cmbFacility').setValue('#(tAA)#');>
	}
}

Method Send() As %String [ ZenMethod ]
{
	try {
		//collect patient demographics from tester input
		Set tFirstName = %page.%GetValueById("txtFirstName")
		Set tMiddleName = %page.%GetValueById("txtMiddleName")
		Set tLastName = %page.%GetValueById("txtLastName")
		Set tFacility = %page.%GetValueById("cmbFacility")
		Set tAA = %page.%GetValueById("cmbAA")
		Set tAAOID = %page.%GetValueById("txtAAOID")
		Set tMRN = %page.%GetValueById("txtMRN")
		Set tPriorMRN = %page.%GetValueById("txtPriorMRN")
		
		set tRequest=##class(HS.Message.MergePatientRequest).%New()
		set tRequest.Facility=tFacility
		set tRequest.AssigningAuthority=tAA
		set tRequest.MRN=tMRN
		set tRequest.PriorMRN=tPriorMRN
		set tRequest.PriorAssigningAuthority=tAA

		Do tRequest.AdditionalInfo.SetAt(tFirstName,"givenName")
		Do tRequest.AdditionalInfo.SetAt(tMiddleName,"middleName")
		Do tRequest.AdditionalInfo.SetAt(tLastName,"familyName")
	
		Set tSvcId=%page.%GetValueById("cmbServiceRegistry")
		#dim tSvcReg as %ZEN.Component.combobox = ..%GetComponentById("cmbServiceRegistry")
		Set tSvcName = tSvcReg.%GetDisplayValue(tSvcId)
		
		Set tVersion=%page.%GetValueById("version")
		Set tHost=$S(tVersion="v3":"HS.IHE.PIXv3.Source.Operations",1:"HS.IHE.PIXv2.Source.Operations")
		
		Set %session.Data("IHE.Test",..%ClassName(0),"LastName")=tLastName
		Set %session.Data("IHE.Test",..%ClassName(0),"FirstName")=tFirstName
		Set %session.Data("IHE.Test",..%ClassName(0),"MiddleName")=tMiddleName
		Set %session.Data("IHE.Test",..%ClassName(0),"Facility")=tRequest.Facility
		Set %session.Data("IHE.Test",..%ClassName(0),"AA")=tRequest.AssigningAuthority
		Set %session.Data("IHE.Test",..%ClassName(0),"AAOID")=tAAOID
		Set %session.Data("IHE.Test",..%ClassName(0),"MRN")=tRequest.MRN
		Set %session.Data("IHE.Test",..%ClassName(0),"PriorMRN")=tRequest.PriorMRN
		Set %session.Data("IHE.Test",..%ClassName(0),"Version")=tVersion
		Set %session.Data("IHE.Test",..%ClassName(0),"ServiceRegistry")=tSvcId
		Set %session.Data("IHE.Test",..%ClassName(0),"ServiceRegistryName")=tSvcName
		
		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Set tTest=tGroup.NewTest(tRequest,%page.%GetValueById("chkLogging"))
		
		If tHost]"" Do tRequest.AdditionalInfo.SetAt(tHost,"Host"),tGroup.AdditionalInfo.SetAt(tHost,"Host")

		Do tGroup.AdditionalInfo.SetAt(tRequest.LastName,"LastName")
		Do tGroup.AdditionalInfo.SetAt(tRequest.FirstName,"FirstName")
		Do tGroup.AdditionalInfo.SetAt(tRequest.MiddleName,"MiddleName")

		Do tGroup.AdditionalInfo.SetAt(tRequest.Facility,"Facility")
		Do tGroup.AdditionalInfo.SetAt(tRequest.AssigningAuthority,"AssigningAuthority")
		Do tGroup.AdditionalInfo.SetAt(tAAOID,"AAOID")
		Do tGroup.AdditionalInfo.SetAt(tRequest.MRN,"MRN")
		Do tGroup.AdditionalInfo.SetAt(tRequest.PriorMRN,"PriorMRN")
		Do tGroup.AdditionalInfo.SetAt(tSvcId,"ServiceRegistry")
		Do tGroup.AdditionalInfo.SetAt(tSvcName,"ServiceRegistryName")
		Do tGroup.AdditionalInfo.SetAt(tVersion,"Version")
		
		Set tSessionID = ..ExecuteAsync(tTest,tGroup)
	} catch ex {
		Do ..LogException(ex,$g(tGroup))
		Set tSessionID = ""
	}
	Quit tSessionID
}

Method DisplayTestResult(pTest As HS.Test.UI.Test, pGroupTest As HS.Test.UI.TestGroup = "", pClear = 0)
{
	Do ##super(pTest,pGroupTest,pClear)
	Set tResponse=pTest.Response
	If $isObject(tResponse) && $$$ISOK(pTest.Status) {
		Set results=%page.%GetComponentById("paneResults")
		Set label=##class(%ZEN.Component.label).%New()
		If tResponse.Accepted=1 {
			Set label.label="Success"
		} Else {
			Set label.label="Merge not accepted"
		}
		Do results.%AddChild(label)
	}
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set tLastName=$g(%session.Data("IHE.Test",..%ClassName(0),"LastName"))
	Set tFirstName=$g(%session.Data("IHE.Test",..%ClassName(0),"FirstName"))
	Set tMiddleName=$g(%session.Data("IHE.Test",..%ClassName(0),"MiddleName"))
	Set tFacility=$g(%session.Data("IHE.Test",..%ClassName(0),"Facility"))
	Set tAA=$g(%session.Data("IHE.Test",..%ClassName(0),"AA"))
	Set tAAOID=$g(%session.Data("IHE.Test",..%ClassName(0),"AAOID"))
	Set tMRN=$g(%session.Data("IHE.Test",..%ClassName(0),"MRN"))
	Set tPriorMRN=$g(%session.Data("IHE.Test",..%ClassName(0),"PriorMRN"))
	Set tVersion=$g(%session.Data("IHE.Test",..%ClassName(0),"Version"))
	Set tSvcId=$g(%session.Data("IHE.Test",..%ClassName(0),"ServiceRegistry"))
	Set tSvcName=$g(%session.Data("IHE.Test",..%ClassName(0),"ServiceRegistryName"))
	Set:tSvcId="" tSvcId=..#SERVICEREGISTRYENTRY
	Set:tSvcName="" tSvcName=..#SERVICEREGISTRYENTRY
	Do ..SetLogging()
	If %page.TESTGROUPID]"" {
		Set tGroup = ##class(HS.Test.UI.TestGroup).%OpenId(%page.TESTGROUPID)
		Set tLastName=tGroup.AdditionalInfo.GetAt("LastName")
		Set tFirstName=tGroup.AdditionalInfo.GetAt("FirstName")
		Set tMiddleName=tGroup.AdditionalInfo.GetAt("MiddleName")
		Set tFacility=tGroup.AdditionalInfo.GetAt("Facility")
		Set tAA=tGroup.AdditionalInfo.GetAt("AssigningAuthority")
		Set tAAOID=tGroup.AdditionalInfo.GetAt("AAOID")
		Set tMRN=tGroup.AdditionalInfo.GetAt("MRN")
		Set tPriorMRN=tGroup.AdditionalInfo.GetAt("PriorMRN")
		Set tVersion=tGroup.AdditionalInfo.GetAt("Version")
		Set tSvcId=tGroup.AdditionalInfo.GetAt("ServiceRegistry")
		Set tSvcName=tGroup.AdditionalInfo.GetAt("ServiceRegistryName")
		
		If $isObject(tGroup) Do ..PostAsyncExecuteDisplay(tGroup,1)
	}
	
	Set:$g(tVersion)="" tVersion="v3"
	Do ..%SetValueById("txtLastName",tLastName)	
	Do ..%SetValueById("txtFirstName",tFirstName)
	Do ..%SetValueById("txtMiddleName",tMiddleName)
	Do ..%SetValueById("cmbAA",tAA)	
	Do ..%SetValueById("txtAAOID",tAAOID)
	Do ..%SetValueById("cmbFacility",tFacility)
	Do ..%SetValueById("txtMRN",tMRN)
	Do ..%SetValueById("txtPriorMRN",tPriorMRN)
	Do ..%SetValueById("version",tVersion)
	Do ..%SetValueById("cmbServiceRegistry",tSvcId)
	
	/*
	Set tSvcReg = ..%GetComponentById("cmbServiceRegistry")
	Set tOption = ##class(%ZEN.Auxiliary.option).%New()
	Set tOption.text = tSvcName
	Set tOption.value = tSvcId
	Do tSvcReg.options.Insert(tOption)
	Do ..%AddComponent(tOption)
	Set tSvcReg.value=tSvcId
	*/
	Quit $$$OK
}

Method AddServiceEntries(pDefaultEntry = "") [ ZenMethod ]
{
	try {
		Set tSC=$$$OK
		Set tEntry=$G(%session.Data("IHE.Test.LastServiceRegistry",..%ClassName(1)))
		#dim tServiceRegistry as %ZEN.Component.combobox = ..%GetComponentById("cmbServiceRegistry")
		#dim tVersion as %ZEN.Component.radioSet = ..%GetComponentById("version")
		Do tServiceRegistry.options.Clear()
		If tVersion.value="v3" {
			Set tType="SOAP",pDefaultEntry="PIXv3.Manager"
			If tEntry="PIXv2.Manager" Set tEntry=""
		} Else {
			Set tType="TCP",pDefaultEntry="PIXv2.Manager"
			If tEntry="PIXv3.Manager" Set tEntry=""
		}

		Set tSelected=""
		Set tResult = ##class(%SQL.Statement).%ExecDirect("","SELECT ID,Name FROM HS_Registry_Service.Abstract WHERE type=? and not(Name LIKE 'SYNC.%' or Name LIKE 'IHE.Test.%') ORDER BY Name",tType)
		While tResult.%Next() {
			If 'tSelected && (tResult.ID=tEntry) Set tSelected=tResult.ID
			If 'tSelected && (tResult.Name=pDefaultEntry) Set tSelected=tResult.ID
			Set tOption = ##class(%ZEN.Auxiliary.option).%New()
			Set tOption.text = tResult.Name
			Set tOption.value = tResult.ID
			Do tServiceRegistry.options.Insert(tOption)
			Do ..%AddComponent(tOption)

		}
		Set tServiceRegistry.value = tSelected
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

}
