Class HS.Test.UI.AU.XDSbRSQ Extends HS.Test.UI.XDSbRSQ
{

Parameter SERVICEREGISTRYENTRY = "AU.Query";

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
<spacer height="5"/>
<text label="IHI Number:" id="txtIHINumber" size="30" onchange="zenPage.updatePatientID();"/>
<text label="HPII Number:" id="txtHPII" size="30"/>
<text label="HPIO Number:" id="txtHPIO" size="30"/>
<text label="Organisation Name:" id="txtHPIOName" size="30"/>
<text label="User Name:" id="txtUserName" size="30"/>
<text label="User Role:" id="txtUserRole" size="30"  />
<spacer height="15"/>

<combobox id="cmbPatientID" label=" Select Patient:" size="90" valueList="" displayList="" value="" onchange="zenPage.selectPatient();" hidden="true" />

<text label="Full Patient ID:" name="patientID" id="txtPatientID" size="80" />
<text label="Document Unique ID:" name="txtDocumentUniqueID" id="txtDocumentUniqueID" size="80" />
<combobox id="cmbDocStatus" label="Document Status:" size="22" valueList="Approved,Deprecated,Approved/Deprecated" displayList="Approved,Deprecated,Approved &amp; Deprecated" value="Approved" />
<spacer height="15"/>
<checkbox caption="Search for Stable documents" name="docTypeStable" id="chkDocTypeStable" hidden="true"/>
<checkbox caption="Search for OnDemand documents" name="docTypeOnDemand" id="chkDocTypeOnDemand" hidden="true"/>
<checkbox caption="Execute CrossGateway Query" id="chkCrossGateway" onchange="zenPage.checkCrossGateway(zenThis.getValue());"  title="Route transaction to either XDSb host or XCA host.  Update endpoint appropriately." hidden="true" />

<spacer height="15"/>

<dataCombo id="cmbServiceRegistry" size='80' label="EndPoint: *" dropdownWidth="800" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	OnCreateResultSet="CreateServiceRegistryRS"
	maxRows="10000">
	<parameter/>
</dataCombo>

<text hidden="true" label="Host:" name="txtHost" id="txtHost" value="HS.AU.IHE.XDSb.Consumer.Operations" size="80" />

<hgroup width="40%" cellAlign="right">
<button id="btnSend" caption=" Submit Request " onclick="zenPage.StartSend('btnSend',1)" />
<spacer width="5" />
<button id="btnClear" caption=" Clear " onclick="zenPage.Clear();" />
<spacer width="5" />
<button id="btnDemoData" caption=" Demo Data " onclick="zenPage.DemoData();" />
</hgroup>

</form>
<vgroup>
<pane paneName="asyncPane"/>
</vgroup>

<pane id="paneResults"/>

</pane>
</page>
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

		//Put together a HS.AU.Message.IHE.XDSb.QueryRequest
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
		/*
		Set:tPatientId]"" %session.Data("IHE.Test","PatientID")=tPatientId
		Set %session.Data("IHE.Test",..%ClassName(0),"DocumentUniqueId")=tDocumentUniqueId
		Set %session.Data("IHE.Test",..%ClassName(0),"DocStatus")=tDocStatus
		Set %session.Data("IHE.Test",..%ClassName(0),"DocTypeStable")=tDocTypeStable
		Set %session.Data("IHE.Test",..%ClassName(0),"DocTypeOnDemand")=tDocTypeOnDemand
		Set %session.Data("IHE.Test",..%ClassName(0),"Host")=tHost
		Set %session.Data("IHE.Test",..%ClassName(0),"CrossGateway")=tCrossGateway
		*/
		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Do tGroup.AdditionalInfo.SetAt(tPatientId,"PatientID")
		Do tGroup.AdditionalInfo.SetAt(tDocumentUniqueId,"DocumentUniqueId")
		
		Do tGroup.AdditionalInfo.SetAt(tDocStatus,"DocStatus")
		Do tGroup.AdditionalInfo.SetAt(tDocTypeStable,"DocTypeStable")
		Do tGroup.AdditionalInfo.SetAt(tDocTypeOnDemand,"DocTypeOnDemand")
		Do tGroup.AdditionalInfo.SetAt(tCrossGateway,"CrossGateway")
		Do tGroup.AdditionalInfo.SetAt(tServiceRegistry,"ServiceRegistryAU")
		If tHost]"" Do tRequest.AdditionalInfo.SetAt(tHost,"Host"),tGroup.AdditionalInfo.SetAt(tHost,"Host")
		
		Set tRequest.SAMLData.IHINumber=%page.%GetValueById("txtIHINumber")
		Set tRequest.SAMLData.NPI=%page.%GetValueById("txtHPII")
		Set tRequest.SAMLData.OrganizationID=%page.%GetValueById("txtHPIO")
		Set tRequest.SAMLData.Organization=%page.%GetValueById("txtHPIOName")
		Set tRequest.SAMLData.UserName=%page.%GetValueById("txtUserName")
		Set tRequest.SAMLData.Role=%page.%GetValueById("txtUserRole")
		Set tRequest.SAMLData.UseRoleForAudit=1
		
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
	//Do ##super(pTest,pGroupTest,pClear)
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
    			Set label.label=tDocument.UniqueId_" ["_tRepo_"] "_tCT_" Status: "_tDocument.AvailabilityStatus_" Type: "_tDocument.TypeCode.Description
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
		Set tServiceRegistry=tGroup.AdditionalInfo.GetAt("ServiceRegistryAU")
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

Method AddRecentDocuments(pResponse = "", pCombo = "", pPatientID = "")
{
	try {
		Set tPatientName=""
		For tIdx=1:1:%session.Data("IHE.Test","RecentPatients") {
			Set tPatientID=$lg($g(%session.Data("IHE.Test","RecentPatients",tIdx)),1)
			Set:tPatientID]"" tPatients(tPatientID)=%session.Data("IHE.Test","RecentPatients",tIdx)
		}
		Merge tSVRecentDocuments = %session.Data("IHE.Test","RecentDocuments")
		Set tRecentDocuments=0,(tValueList,tDisplayList)=""
		If $isObject(pResponse) {
			For tIdx = 1:1:pResponse.Documents.Count() {
				Set tDocument = pResponse.Documents.GetAt(tIdx)
				Set tRepoID = tDocument.RepositoryUniqueId
				If '((($Extract(tRepoID,1,2)="1.")||($Extract(tRepoID,1,2)="2."))&&($Translate(tRepoID,"0123456789.")="")) Set tRepoID = ##class(HS.Data.OIDMap).GetOIDForCode(tRepoID, tRepoID)
				Set tPatientID = tDocument.PatientId
				Set tPatientID = $S(tDocument.PatientId]"":tDocument.PatientId,1:pPatientID)
				Set tPatientName=$S(tPatientID]"":$lg($G(tPatients(tPatientID)),2),1:"")
				Set tRepo=##class(HS.Data.OIDMap).GetCodeForOID(tRepoID,"Unknown Repo")
				Set tDocID=tDocument.UniqueId
				Set tCT=tDocument.CreationTime
			    Set tMime=tDocument.MimeType
				set tDisplayList = tDisplayList_","_"@"_tCT_" ("_..%EscapeComma(tPatientName)_")"_tDocID_" ["_tRepo_"]" 
				set tValueList = tValueList_","_"DOCID="_tDocID_"&REPOID="_tDocument.RepositoryUniqueId_"&HOMEID="_tDocument.HomeCommunityId
				Set tPatientName=""
				Set tRecentDocuments($i(tRecentDocuments))=$lb(tPatientID,tPatientName,tDocID,tRepoID,tRepo,tDocument.HomeCommunityId,tCT,tMime)
				Set tSeen(tDocID_tRepoID)=tRecentDocuments
			}
		}
		For tIdx=1:1:+$g(tSVRecentDocuments) {
			Set tItem = tSVRecentDocuments(tIdx)
			Set tSeen=$li(tItem,3)_$li(tItem,4)
			If $D(tSeen(tSeen)) Continue
			Set tRecentDocuments($i(tRecentDocuments))=tItem
			Set tSeen(tSeen)="",tValueList=tValueList_",DOCID="_$li(tItem,3)_"&REPOID="_$li(tItem,4)_"&HOMEID="_$li(tItem,6)
			Set tPatientID=$lg(tItem)
			Set tPatientName=$S(tPatientID="":"",1:$lg($G(tPatients(tPatientID)),2))
		    Set tDisplayList=tDisplayList_","_"@"_$lg(tItem,7)_" ("_tPatientName_") "_$lg(tItem,3)_" ["_$lg(tItem,5)_"]"
		}
		Merge %session.Data("IHE.Test","RecentDocuments")=tRecentDocuments
		set:pCombo]"" %page.%GetComponentById(pCombo).displayList=$e(tDisplayList,2,*)
		set:pCombo]"" %page.%GetComponentById(pCombo).valueList=$e(tValueList,2,*)
	} catch ex {
	}
}

Method GetRequestMessage() As HS.Message.IHE.XDSb.QueryRequest
{
	Set tRequest=##class(HS.AU.Message.IHE.XDSb.QueryRequest).%New()
	/*
	Set tRequest.SAMLData.IHINumber=$P(%page.%GetValueById("txtPatientID"),"^")
	// Pull in demo values
	Set tRequest.SAMLData.NPI="8003616566666809"
	Set tRequest.SAMLData.OrganizationID="8003629900019452"
	Set tRequest.SAMLData.Organization="DHS5504"
	Set tRequest.SAMLData.UseRoleForAudit=1
	Set tRequest.SAMLData.UserName="NEHTA_Test_User"
	Set tRequest.SAMLData.Role="HealthcareProvider"
	Set %session.Data("IHETest.AU","LastIHINumber")=tRequest.SAMLData.IHINumber
	*/
	Quit tRequest
}

ClientMethod Clear() [ Language = javascript ]
{
	this.getComponentById('txtIHINumber').setValue("");
	this.getComponentById('txtHPII').setValue("");
	this.getComponentById('txtHPIO').setValue("");
	this.getComponentById('txtHPIOName').setValue("");
	this.getComponentById('txtUserName').setValue("");
	this.getComponentById('txtUserRole').setValue("");
	
	zen('cmbPatientID').setValue("");
	zen('txtPatientID').setValue("");
	zen('chkDocTypeStable').setValue("");
	zen('chkDocTypeOnDemand').setValue("");
	zen('cmbDocStatus').setValue("Approved");
	zenPage.ClearResultsPane();
}

ClientMethod DemoData() [ Language = javascript ]
{
	this.getComponentById('txtIHINumber').setValue("8003608500128236");
	this.getComponentById('txtHPII').setValue("8003616566666809");
	this.getComponentById('txtHPIO').setValue("8003629900019452");
	this.getComponentById('txtHPIOName').setValue("DHS5504");
	this.getComponentById('txtUserName').setValue("NEHTA_Test_User");
	this.getComponentById('txtUserRole').setValue("HealthcareProvider");
	this.updatePatientID();
}

/// Override for AU to set PatientID based on IHI Number
ClientMethod updatePatientID() [ Language = javascript ]
{
	var value = zenPage.getComponentById('txtIHINumber').getValue();
	var AAOID = "1.2.36.1.2001.1003.0"
	var newvalue = value+"^^^&"+AAOID+"&ISO"
	zenPage.getComponentById('txtPatientID').setValue(newvalue);
}

}
