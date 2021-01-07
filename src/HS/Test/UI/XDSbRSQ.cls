Class HS.Test.UI.XDSbRSQ Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Query Patient CCD";

Property PatientMRN As %String(ZENURL = "PATIENTMRN");

Property PatientAA As %String(ZENURL = "PATIENTAA");

Parameter SERVICEREGISTRYENTRY = "XDSb.Registry";

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
<html>Please specify document search criteria for patient</html>
<spacer height="5"/>
<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left" enctype="multipart/form-data">
<spacer height="5"/>
<checkbox label="Enable logging" id="chkLogging" title="Route traffic through tcp trace utility"/>
<combobox id="cmbPatientID" label=" Select Patient:" size="90" valueList="" displayList="" value="" onchange="zenPage.selectPatient();" />

<text label="Full Patient ID:" name="patientID" id="txtPatientID" size="80" value="#(%page.PatientMRN)#^^^&amp;#(%page.PatientAA)#&amp;ISO" onchange="zenPage.updatePatientID(zenThis);"/>
<text label="Document Unique ID:" name="txtDocumentUniqueID" id="txtDocumentUniqueID" size="80" />
<combobox id="cmbDocStatus" label="Document Status:" size="22" valueList="Approved,Deprecated,Approved/Deprecated" displayList="Approved,Deprecated,Approved &amp; Deprecated" value="Approved" />
<spacer height="15"/>
<checkbox caption="Search for Stable documents" name="docTypeStable" id="chkDocTypeStable"/>
<checkbox caption="Search for OnDemand documents" name="docTypeOnDemand" id="chkDocTypeOnDemand"/>
<checkbox caption="Execute CrossGateway Query" id="chkCrossGateway" onchange="zenPage.checkCrossGateway(zenThis.getValue());"  title="Route transaction to either XDSb host or XCA host.  Update endpoint appropriately."/>

<spacer height="15"/>

<dataCombo id="cmbServiceRegistry" size='80' label="EndPoint: *" dropdownWidth="800" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	OnCreateResultSet="CreateServiceRegistryRS"
	maxRows="10000">
	<parameter/>
</dataCombo>
<text hidden="true" label="Host:" name="txtHost" id="txtHost" value="HS.IHE.XDSb.Consumer.Operations" size="80" title="Route transaction to either XDSb host or XCA host."/>

<hgroup width="40%" cellAlign="right">
<button id="btnSend" caption=" Submit Request " onclick="zenPage.StartSend('btnSend',1)" />
<spacer width="5" />
<button id="btnClear" caption=" Clear " onclick="zenPage.Clear();" />
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

ClientMethod checkCrossGateway(value) [ Language = javascript ]
{
	if(value == true) {
		zenPage.getComponentById("txtHost").setValue("HS.IHE.XCA.InitiatingGateway.Operations");
	} else {
		zenPage.getComponentById("txtHost").setValue("HS.IHE.XDSb.Consumer.Operations");
	}
}

ClientMethod selectPatient() [ Language = javascript ]
{
	patientID = zenPage.getComponentById("cmbPatientID").getValue();
	zenPage.getComponentById("txtPatientID").setValue(patientID);
}

ClientMethod Clear() [ Language = javascript ]
{
	zen('cmbPatientID').setValue("");
	zen('txtPatientID').setValue("");
	zen('chkDocTypeStable').setValue("");
	zen('chkDocTypeOnDemand').setValue("");
	zen('cmbDocStatus').setValue("Approved");
	zenPage.ClearResultsPane();
}

Method Send() As %String [ ZenMethod ]
{
	try {
		Set tSessionID=""
		Set tQueryType="FindDocuments"

		Set tHost = %page.%GetValueById("txtHost")
		
		//collect patient id from tester input
		Set tPatientId = %page.%GetValueById("txtPatientID")
		Set tDocumentUniqueId=%page.%GetValueById("txtDocumentUniqueID") 
		If tDocumentUniqueId]"" {
			Set:tDocumentUniqueId tQueryType="GetDocuments"
		}
		Set tDocStatus= %page.%GetValueById("cmbDocStatus")
		Set tServiceRegistry= %page.%GetValueById("cmbServiceRegistry")
			
		Set tDocTypeStable = %page.%GetValueById("chkDocTypeStable")
		Set tDocTypeOnDemand = %page.%GetValueById("chkDocTypeOnDemand")
		If tPatientId="" && (tDocumentUniqueId="") {
			Do ..LogMessage("Select a patient or document unique id")
			quit
		}

		//Put together a HS.Message.IHE.XDSb.QueryRequest
		Set tRequest = ..GetRequestMessage()
		If tQueryType="FindDocuments" {
			Do tRequest.AddPatientId(tPatientId)
			Do tRequest.AddStatusValues($tr(tDocStatus,"/",","))
			if tDocTypeStable && tDocTypeOnDemand {
				Do tRequest.AddDocumentType(3)
			}
			elseif (tDocTypeStable) {
				Do tRequest.AddDocumentType(1)
			}
			elseif (tDocTypeOnDemand) {
				Do tRequest.AddDocumentType(2)
			}
		} Else {
			Set tRequest.QueryType=tQueryType
			Do tRequest.AddParam(tDocumentUniqueId,"$XDSDocumentEntryUniqueId")
		}
		Set tCrossGateway=%page.%GetValueById("chkCrossGateway")
		Set:tPatientId]"" %session.Data("IHE.Test","PatientID")=tPatientId
		Set %session.Data("IHE.Test",..%ClassName(0),"DocumentUniqueId")=tDocumentUniqueId
		Set %session.Data("IHE.Test",..%ClassName(0),"DocStatus")=tDocStatus
		Set %session.Data("IHE.Test",..%ClassName(0),"DocTypeStable")=tDocTypeStable
		Set %session.Data("IHE.Test",..%ClassName(0),"DocTypeOnDemand")=tDocTypeOnDemand
		Set %session.Data("IHE.Test",..%ClassName(0),"Host")=tHost
		Set %session.Data("IHE.Test",..%ClassName(0),"CrossGateway")=tCrossGateway
		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Do tGroup.AdditionalInfo.SetAt(tPatientId,"PatientID")
		Do tGroup.AdditionalInfo.SetAt(tDocumentUniqueId,"DocumentUniqueId")
		
		Do tGroup.AdditionalInfo.SetAt(tDocStatus,"DocStatus")
		Do tGroup.AdditionalInfo.SetAt(tDocTypeStable,"DocTypeStable")
		Do tGroup.AdditionalInfo.SetAt(tDocTypeOnDemand,"DocTypeOnDemand")
		Do tGroup.AdditionalInfo.SetAt(tCrossGateway,"CrossGateway")
		Do tGroup.AdditionalInfo.SetAt(tServiceRegistry,"ServiceRegistry")
		If tHost]"" Do tRequest.AdditionalInfo.SetAt(tHost,"Host"),tGroup.AdditionalInfo.SetAt(tHost,"Host")
		//Set tSC = tGroup.%Save()
		Set tTest=tGroup.NewTest(tRequest,%page.%GetValueById("chkLogging"))

		Set tSessionID = ..ExecuteAsync(tTest,tGroup)
	} catch ex {
		Do ..LogException(ex,$g(tGroup))
		Set tSessionID=""
	}
	Quit tSessionID
}

Method DisplayTestResult(pTest As HS.Test.UI.Test, pGroupTest As HS.Test.UI.TestGroup = "", pClear = 0)
{
	Do ##super(pTest,pGroupTest,pClear)
	Set tResponse=pTest.Response
	If $IsObject(tResponse) && $$$ISOK(pTest.Status) {
		Set tPatientId = %page.%GetValueById("txtPatientID")
		Set (tDisplayList,tValueList)=""
		#dim results as %ZEN.Component.pane
		set results=%page.%GetComponentById("paneResults")
	 	if $IsObject(tResponse) && (tResponse.Documents.Count()) {
			Do ..AddRecentDocuments(tResponse,"",tPatientId)
			For tIdx = 1:1:tResponse.Documents.Count() {
				#dim tDocument as HS.Message.IHE.XDSb.Document
				Set tDocument = tResponse.Documents.GetAt(tIdx)
				Set tRepo = tDocument.RepositoryUniqueId
				Set tPatientId = tDocument.PatientId
				Set tRepo=##class(HS.Data.OIDMap).GetCodeForOID(tDocument.RepositoryUniqueId,"Unknown Repo")

				Set label=##class(%ZEN.Component.label).%New()
				Set tCT=$E(tDocument.CreationTime,1,4)_"/"_$E(tDocument.CreationTime,5,6)_"/"_$E(tDocument.CreationTime,7,8)_" "_$E(tDocument.CreationTime,9,10)_":"_$E(tDocument.CreationTime,11,12)_":"_$E(tDocument.CreationTime,13,14)
    			Set label.label=tDocument.UniqueId_" ["_tRepo_"] "_tCT_" "_tDocument.MimeType
				Set title="version:"_tDocument.Version_
					$c(13,10)_"availability:"_tDocument.AvailabilityStatus_
					$c(13,10)_"typecode:"_tDocument.TypeCode.Code_"["_tDocument.TypeCode.Description_"]"_
					$c(13,10)_"healthcarefacilitytype"_tDocument.HealthcareFacilityTypeCode.Code_"["_tDocument.HealthcareFacilityTypeCode.Description_"]"_
					$c(13,10)_"language"_tDocument.LanguageCode
					
				Set label.title=title
				Do results.%AddChild(label)
			}
	 	}
	}
}

Method GetRequestMessage() As HS.Message.IHE.XDSb.QueryRequest
{
	If %page.%GetValueById("chkCrossGateway") { 
		Quit ##class(HS.Message.IHE.XCA.QueryRequest).%New()
	} Else {
		Quit ##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	}
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set tPatientId=$g(%session.Data("IHE.Test","PatientID"))
	Set tDocumentUniqueId=$g(%session.Data("IHE.Test",..%ClassName(0),"DocumentUniqueId"))
	Set tDocStatus=$g(%session.Data("IHE.Test",..%ClassName(0),"DocStatus"))
	Set tDocTypeStable=$g(%session.Data("IHE.Test",..%ClassName(0),"DocTypeStable"))
	Set tDocTypeOnDemand=$g(%session.Data("IHE.Test",..%ClassName(0),"DocTypeOnDemand"))
	Set tHost=$g(%session.Data("IHE.Test",..%ClassName(0),"Host"))
	Set tCrossGateway=$g(%session.Data("IHE.Test",..%ClassName(0),"CrossGateway"))
	Set tServiceRegistry=$g(%session.Data("IHE.Test",..%ClassName(0),"ServiceRegistry"))
	Set:tServiceRegistry="" tServiceRegistry=..#SERVICEREGISTRYENTRY
	
	//Set tSC= ..AddServiceEntries(..#SERVICEREGISTRYENTRY) 
	Do ..SetLogging()
	Do ..AddRecentPatients("","cmbPatientID")
	If %page.TESTGROUPID]"" {
		Set tGroup = ##class(HS.Test.UI.TestGroup).%OpenId(%page.TESTGROUPID)
		Set tPatientId=tGroup.AdditionalInfo.GetAt("PatientID")
		Set tDocumentUniqueId=tGroup.AdditionalInfo.GetAt("DocumentUniqueId")
		Set tDocStatus=tGroup.AdditionalInfo.GetAt("DocStatus")
		Set tDocTypeStable=tGroup.AdditionalInfo.GetAt("DocTypeStable")
		Set tDocTypeOnDemand=tGroup.AdditionalInfo.GetAt("DocTypeOnDemand")
		Set tHost=tGroup.AdditionalInfo.GetAt("Host")
		Set tServiceRegistry=tGroup.AdditionalInfo.GetAt("ServiceRegistry")
		Set tCrossGateway=tGroup.AdditionalInfo.GetAt("CrossGateway")
		If $isObject(tGroup) Do ..PostAsyncExecuteDisplay(tGroup,1)
	}
	Do ..%SetValueById("txtPatientID",tPatientId)
	Do ..%SetValueById("txtDocumentUniqueID",tDocumentUniqueId)
	Do ..%SetValueById("txtHost",tHost)
	Do:tDocStatus]"" ..%SetValueById("cmbDocStatus",tDocStatus)
	Do ..%SetValueById("chkDocTypeStable",tDocTypeStable)
	Do ..%SetValueById("chkDocTypeOnDemand",tDocTypeOnDemand)
	Do ..%SetValueById("cmbServiceRegistry",tServiceRegistry)
	Do ..%SetValueById("chkCrossGateway",tCrossGateway)
	Quit $$$OK
}

}
