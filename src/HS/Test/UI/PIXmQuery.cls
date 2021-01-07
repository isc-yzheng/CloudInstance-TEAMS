Include HS.HC

Class HS.Test.UI.PIXmQuery Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "PIXm Search";

Parameter SERVICEREGISTRYENTRY = "PIXm.Manager";

Parameter SERVICEDEVICEFUNCTION = "PIXm.Manager";

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
<spacer height="20"/>
<html>Please enter patient identifier</html>
<spacer height="5"/>
<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left">
<checkbox label="Enable logging" id="chkLogging" title="Route traffic through tcp trace utility" hidden="1"/>
<spacer width="5" />
<combobox id="cmbFormat" label="FHIR Format:" size="22" tabIndex="35" title="Value to use for the _format URL parameter" />
<spacer width="5" />
<combobox id="cmbVersion" label="FHIR Version:" size="22" tabIndex="35" title="FHIR version to use" />
<spacer width="5" />
<hgroup>
<radioSet id="version" valueList="PIXm" originalValue="PIXm" captionClass="lblNormal" onclick="zenPage.UpdateSvcParams();" hidden="true"/>
</hgroup>
<spacer height="5"/>
<text label="Domains:" name="Domains" id="txtDomains" size="30" hint="domainCode1,...domainCodeN" hintStyle="font-size:10px;font-weight:bold;" tabIndex="5" />
<dataCombo id="cmbAA" label="AssigningAuthority:" size="80" tabIndex="65"
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreateAssigningAuthorityRS"
	maxRows="10000">
</dataCombo>
<text label="MRN:" name="MRN" id="txtMRN" size="22" readOnly="0" value="#(%page.PatientMRN)#"/>
<dataCombo id="cmbServiceRegistry" size='80' label="EndPoint: *" dropdownWidth="800" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreatePIXPDQServiceRegistryRS"
	maxRows="10000">
	<parameter id="pType" value="HTTP"/>
</dataCombo>
<spacer height="15"/>

<hgroup width="40%" cellAlign="right">
<button id="btnSend" caption=" Generate PIX Query Request " onclick="zenPage.StartSend('btnSend',1)" />
<spacer width="5" />
<button id="btnClearDemo" caption=" Clear " onclick="zenPage.ClearDemographics();zenPage.ClearSessionData();" />
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
	var doms = this.getComponentById('txtDomains');
	var aa = this.getComponentById('cmbAA');
	var mrn = this.getComponentById('txtMRN');
	var aaoid = this.getComponentById('txtAAOID');
	var svc = this.getComponentById('cmbServiceRegistry');
	
	if (null!=doms) doms.setValue("");
	if (null!=aa) aa.setValue("");
	if (null!=mrn) mrn.setValue("");
	if (null!=aaoid) aaoid.setValue("");
	if (null!=svc) svc.setValue("");
}

Method ClearSessionData() [ ZenMethod ]
{
	Set %session.Data("IHE.Test",..%ClassName(0),"Version")=""
	Set %session.Data("IHE.Test",..%ClassName(0),"AA")=""
	Set %session.Data("IHE.Test",..%ClassName(0),"MRN")=""
	Set %session.Data("IHE.Test",..%ClassName(0),"Domains")=""
	Set %session.Data("IHE.Test",..%ClassName(0),"ServiceRegistry")=""
	Set %session.Data("IHE.Test",..%ClassName(0),"ServiceRegistryName")=""
	Set %session.Data("IHE.Test",..%ClassName(0),"FHIRFormat")=""
	Set %session.Data("IHE.Test",..%ClassName(0),"FHIRVersion")=""
	Quit
}

Method Send() As %String [ ZenMethod ]
{
	try {
		Set tSessionID=""
		
		set tFHIRVersion = %page.%GetValueById("cmbVersion")
		If tFHIRVersion="" &js< alert('FHIR Version is required');> Quit
		
		Do ..ClearRecentPatients()
		//collect patient demographics from tester input
		Set pMRN = %page.%GetValueById("txtMRN")
		Set pAA = %page.%GetValueById("cmbAA")
		If pMRN="" || (pAA="") &js< alert('MRN and Assigning Authority are required');> Quit
		
		//Compile PatientSearchRequest using patient demographics
		Set pRequest = ##class(HS.Message.PatientSearchRequest).%New()
		if %page.%GetValueById("txtDomains")'="" {
			set tDomains = %page.%GetValueById("txtDomains")
			for i = 1:1:$Length(tDomains,",") {
				set tDomainCode = $Piece(tDomains,",",i)
				set tDomainCode = $ZStrip(tDomainCode,"<>"," ")
				do pRequest.AdditionalInfo.SetAt("","scopingOrganization_"_tDomainCode)
				do pRequest.AdditionalInfo.SetAt("","ScopingOrganizations")
			}
		}
		Set tFormat = %page.%GetValueById("cmbFormat")
		If tFormat'="" Do pRequest.AdditionalInfo.SetAt($ZConvert(tFormat,"L"),"_format")
		Set tSvcId=%page.%GetValueById("cmbServiceRegistry")
		#dim tSvcReg as %ZEN.Component.combobox = ..%GetComponentById("cmbServiceRegistry")
		Set tSvcName = tSvcReg.%GetDisplayValue(tSvcId)
		
		Set tVersion=%page.%GetValueById("version")
		set pRequest.AssigningAuthority=pAA
		set pRequest.MRN=pMRN
		do pRequest.AdditionalInfo.SetAt("PIXmConsumer"_tFHIRVersion,"FHIRActor")
		
		Set %session.Data("IHE.Test",..%ClassName(0),"Version")=tVersion
		Set %session.Data("IHE.Test",..%ClassName(0),"AA")=pAA
		Set %session.Data("IHE.Test",..%ClassName(0),"MRN")=pMRN
		Set %session.Data("IHE.Test",..%ClassName(0),"Domains")=$g(tDomains)
		Set %session.Data("IHE.Test",..%ClassName(0),"ServiceRegistry")=tSvcId
		Set %session.Data("IHE.Test",..%ClassName(0),"ServiceRegistryName")=tSvcName
		Set %session.Data("IHE.Test",..%ClassName(0),"FHIRFormat")=tFormat
		Set %session.Data("IHE.Test",..%ClassName(0),"FHIRVersion")=tFHIRVersion
		
		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Set tChkLogging = %page.%GetValueById("chkLogging")
		#; Disable logging for FHIR-related options.
		Set tChkLogging = 0
		Set tTest=tGroup.NewTest(pRequest,tChkLogging)
		Do tGroup.AdditionalInfo.SetAt(pAA,"AssigningAuthority")
		Do tGroup.AdditionalInfo.SetAt(pMRN,"MRN")
		Do tGroup.AdditionalInfo.SetAt(tVersion,"Version")
		Do tGroup.AdditionalInfo.SetAt(tSvcId,"ServiceRegistry")
		Do tGroup.AdditionalInfo.SetAt(tSvcName,"ServiceRegistryName")
		If $g(tDomains)]"" Do tGroup.AdditionalInfo.SetAt(tDomains,"Domains")
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
	Set tMRN = %page.%GetValueById("txtMRN")
	Set tAA = %page.%GetValueById("cmbAA")
	Set tAAOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAA)
	Set tIdentifier = tMRN_"^^^&"_tAAOID_"&ISO"
	
	Set tResponse=pTest.Response
	If $isObject(tResponse) {
		If ($$$ISERR(tResponse.ErrStatus))&&(+tResponse.AdditionalInfo.GetAt("HTTPStatus")>399) {
			Set results=%page.%GetComponentById("paneResults")
			Set label=##class(%ZEN.Component.label).%New()
			Set tStatus = tResponse.AdditionalInfo.GetAt("HTTPStatus")
			If tStatus?1N.N {
				Set tSC = ##class(HS.FHIR.Helper).LookupHTTPStatusText(tStatus, .tText)
				Set tStatus = tStatus_" "_tText
			}
			Set label.label = "HTTP Status = "_tStatus
			Do results.%AddChild(label)
			Set label=##class(%ZEN.Component.label).%New()
			Set label.label=" "
			Do results.%AddChild(label)
			Set label=##class(%ZEN.Component.label).%New()
			Set label.label = $system.Status.GetErrorText(tResponse.ErrStatus)
			Do results.%AddChild(label)
		} ElseIf $$$ISOK(pTest.Status) {
			Set results=%page.%GetComponentById("paneResults")
			Set label=##class(%ZEN.Component.label).%New()
			Set tStatus = tResponse.AdditionalInfo.GetAt("HTTPStatus")
			If tStatus?1N.N {
				Set tSC = ##class(HS.FHIR.Helper).LookupHTTPStatusText(tStatus, .tText)
				Set tStatus = tStatus_" "_tText
			}
			Set label.label = "HTTP Status = "_tStatus
			Do results.%AddChild(label)
			Set label=##class(%ZEN.Component.label).%New()
			Set label.label=" "
			Do results.%AddChild(label)
			Set tService = ..GetServiceRegistryEntry()
			Set tAffinityDomain = $$$AffinityDomain
			If $isObject(tService) {
				If tService.OIDMapCode.GetAt("AssigningAuthority")]"" Set tAffinityDomain=tService.OIDMapCode.GetAt("AssigningAuthority")
			}
			Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAffinityDomain)
			If tResponse.Results.Count() {
				For tIdx=1:1:tResponse.Results.Count() {
					Set tMPIID = tResponse.Results.GetAt(tIdx).MPIID
					If tMPIID="" && (tAA=tAffinityDomain) Set tMPIID=tMRN
					Set tPatientId=tMPIID_"^^^&"_tAffinityDomainOID_"&ISO"
					If tIdx=1 {
						Do %page.%SetValueById("txtPatientID", tPatientId)
						Set %session.Data("IHE.Test","PatientID")=tPatientId
						Do ..AddRecentPatients(tResponse,,tAffinityDomainOID)
					}
					Do ..AddRecentPatientMRNAA(tPatientId,tIdentifier)
					Set tItem = tResponse.Results.GetAt(tIdx)
					Set tDisplayPatientId = tMPIID_"  "_##class(HS.Data.OIDMap).GetURIForCode(tAffinityDomain,tAffinityDomain)_"  "_tAffinityDomain
					Set tPatient = tResponse.Results.GetAt(tIdx).FirstName_" "_tResponse.Results.GetAt(tIdx).LastName_" ("_tDisplayPatientId_")"
					Set label=##class(%ZEN.Component.label).%New()
					Set label.label=tPatient
					Do results.%AddChild(label)
					For tIdx2=1:1:tResponse.Results.GetAt(tIdx).Identifiers.Count() {
						Set tIdentifier = tResponse.Results.GetAt(tIdx).Identifiers.GetAt(tIdx2)
						If tIdentifier.Root=tAffinityDomain Continue
						Set label=##class(%ZEN.Component.label).%New()
						If tIdentifier.Type="FHIR" {
							Set label.label = tIdentifier.Extension
						} Else {
							Set label.label = tIdentifier.Extension_"  "_##class(HS.Data.OIDMap).GetURIForCode(tIdentifier.Root,"No Service Registry entry for "_tIdentifier.Root)_"  "_$Select(tIdentifier.Root'="":"  ("_tIdentifier.Root_")",1:"")
						}
						Do results.%AddChild(label)
					}
				}
			} Else {
				Set label=##class(%ZEN.Component.label).%New()
				Set label.label="No Patients Found"
				Do results.%AddChild(label)
			}
		}
		Set label=##class(%ZEN.Component.label).%New()
		Set label.label=" "
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
	Set tCombo=..%GetComponentById("cmbFormat")
	Set tCombo.valueList=",application/fhir+xml,application/fhir+json,xml,json,application/xml+fhir,application/json+fhir"
	Set tCombo.displayList=tCombo.valueList
	
	Set tCombo=..%GetComponentById("cmbVersion")
	Set tCombo.valueList="STU3,DSTU2"
	Set tCombo.displayList=tCombo.valueList
	
	Set tVersion=$g(%session.Data("IHE.Test",..%ClassName(0),"Version"))
	Set tAA=$g(%session.Data("IHE.Test",..%ClassName(0),"AA"))
	Set tMRN=$g(%session.Data("IHE.Test",..%ClassName(0),"MRN"))
	Set tDomains=$g(%session.Data("IHE.Test",..%ClassName(0),"Domains"))
	Set tSvcId=$g(%session.Data("IHE.Test",..%ClassName(0),"ServiceRegistry"))
	Set tSvcName=$g(%session.Data("IHE.Test",..%ClassName(0),"ServiceRegistryName"))
	Set tFHIRFormat=$g(%session.Data("IHE.Test",..%ClassName(0),"FHIRFormat"))
	Set tFHIRVersion=$g(%session.Data("IHE.Test",..%ClassName(0),"FHIRVersion"))
	Do ..%SetValueById("cmbVersion", tFHIRVersion)
	Set:tSvcId="" tSvcId=..#SERVICEREGISTRYENTRY
	Set:tSvcName="" tSvcName=..#SERVICEREGISTRYENTRY
	Do ..SetLogging()
	If %page.TESTGROUPID]"" {
		Set tGroup = ##class(HS.Test.UI.TestGroup).%OpenId(%page.TESTGROUPID)
		Set tSvcId=tGroup.AdditionalInfo.GetAt("ServiceRegistry")
		Set tSvcName=tGroup.AdditionalInfo.GetAt("ServiceRegistryName")
		Set tAA=tGroup.AdditionalInfo.GetAt("AssigningAuthority")
		Set tMRN=tGroup.AdditionalInfo.GetAt("MRN")
		Set tVersion=tGroup.AdditionalInfo.GetAt("Version")
		Set tDomains=tGroup.AdditionalInfo.GetAt("Domains")
		If $isObject(tGroup) Do ..PostAsyncExecuteDisplay(tGroup,1)
	}
	Set:$g(tVersion)="" tVersion="v3"
	Do ..%SetValueById("version",tVersion)
	Do ..%SetValueById("txtMRN",tMRN)
	Do ..%SetValueById("cmbAA",tAA)
	Do ..%SetValueById("txtDomains",tDomains)
	Do ..%SetValueById("cmbServiceRegistry",tSvcId)
	Do ..%SetValueById("version","PIXm")
	Do ..%SetValueById("cmbFormat",tFHIRFormat)

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
