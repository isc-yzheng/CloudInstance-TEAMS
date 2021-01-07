Class HS.Test.UI.AU.XDSbRetrieve Extends HS.Test.UI.XDSbRetrieve
{

Parameter SERVICEREGISTRYENTRY = "AU.Repository";

/// This XML block defines the contents of the ICE IHE test workflow pane.
XData Contents
{
<page title="HealthShare IHE Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
	
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<spacer height="15"/>

<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left" enctype="multipart/form-data">
<checkbox label="Enable logging" id="chkLogging" title="Route traffic through tcp trace utility"/>
<spacer height="5"/>
<text label="IHI Number:" id="txtIHINumber" size="30" />
<text label="HPII Number:" id="txtHPII" size="30"/>
<text label="HPIO Number:" id="txtHPIO" size="30"/>
<text label="Organisation Name:" id="txtHPIOName" size="30"/>
<text label="User Name:" id="txtUserName" size="30"/>
<text label="User Role:" id="txtUserRole" size="30"  />
<spacer height="15"/>
<combobox id="cmbDocID" label=" Select Document for Retrieval:" size="90" valueList="" displayList="" value="" onchange="zenPage.SelectDocument();"/>
<spacer height="5"/>
<textarea label="Home Community Id:" id="txaHomeCommunityID" value="#(%page.HomeCommunityID)#" rows="3" cols="80" />
<textarea label="Repository Unique Id:" id="txaRepoID" value="#(%page.RepositoryID)#" rows="3" cols="80" />
<textarea label="Document Unique Id:" id="txaDocID" value="#(%page.DocumentID)#"  rows="3" cols="80"/>
<dataCombo id="cmbServiceRegistry" size='80' label="EndPoint: *" dropdownWidth="800" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	OnCreateResultSet="CreateServiceRegistryRS"
	maxRows="10000">
	<parameter/>
</dataCombo>
<text hidden="true" label="Host:" name="txtHost" id="txtHost" value="HS.IHE.XDSb.Consumer.Operations" size="80" title="Route transaction to either XDSb host or XCA host."/>
<checkbox hidden="true" caption="Execute CrossGateway Retrieve" id="chkCrossGateway" onchange="zenPage.checkCrossGateway(zenThis.getValue());"  title="Route transaction to either XDSb host or XCA host.  Update endpoint appropriately."/>

<spacer height="15"/>

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
<pane id="paneResults">
</pane>
</pane>
</page>
}

Method Send() As %String [ ZenMethod ]
{
	try {
		set tSC = $$$OK
		//collect document and repository id from tester input
		Set tDelim=$c(10)
		Set tRepoId = %page.%GetValueById("txaRepoID")
		Set tDocId = %page.%GetValueById("txaDocID")
		Set tHomeId = %page.%GetValueById("txaHomeCommunityID")
		//Put together a HS.AU.Message.IHE.XDSb.RetrieveRequest
		Set tRequest = ..GetRequestMessage()
		For tIdx=1:1:$l(tRepoId,tDelim) {
			
			Set tDoc = ##class(HS.Message.IHE.XDSb.Document).%New()
			Set tRepositoryOID = $p(tRepoId,tDelim,tIdx)
			Set tDocumentID = $p(tDocId,tDelim,tIdx)
			If tRepositoryOID="" && (tDocumentID="") Continue
			If tRepositoryOID="" {
				&js<alert('Repository ID [#(tIdx)#] is missing - skipping');>
				continue
			}
			If tDocumentID="" {
				&js<alert('Document ID [#(tIdx)#] is missing - skipping');>
				continue
			}
			Set tDoc.RepositoryUniqueId = tRepositoryOID
			Set tDoc.UniqueId = tDocumentID
			Set tDoc.HomeCommunityId=$p(tHomeId,tDelim,tIdx)
			Do tRequest.Documents.Insert(tDoc)
		}
		If tRequest.Documents.Count()=0 {
			&js<alert('Select one or more documents to retrieve.');>
			Quit
		}
		Set tServiceRegistry= %page.%GetValueById("cmbServiceRegistry")
		Set tHost = %page.%GetValueById("txtHost")
		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Do tGroup.AdditionalInfo.SetAt(tRepoId,"RepositoryID")
		Do tGroup.AdditionalInfo.SetAt(tDocId,"DocumentID")
		Do tGroup.AdditionalInfo.SetAt(tHomeId,"HomeCommunityID")
		Do tGroup.AdditionalInfo.SetAt(%page.%GetValueById("chkCrossGateway"),"CrossGateway")

		Do tGroup.AdditionalInfo.SetAt(tServiceRegistry,"ServiceRegistry")
		If tHost]"" Do tRequest.AdditionalInfo.SetAt(tHost,"Host"),tGroup.AdditionalInfo.SetAt(tHost,"Host")
		Set tTest=tGroup.NewTest(tRequest,%page.%GetValueById("chkLogging"))

		Set %session.Data("IHE.Test",..%ClassName(0),"RepositoryID")=tRepoId
		Set %session.Data("IHE.Test",..%ClassName(0),"DocumentID")=tDocId
		Set %session.Data("IHE.Test",..%ClassName(0),"HomeCommunityID")=tHomeId
		
		Set tRequest.SAMLData.IHINumber=%page.%GetValueById("txtIHINumber")
		Set tRequest.SAMLData.NPI=%page.%GetValueById("txtHPII")
		Set tRequest.SAMLData.OrganizationID=%page.%GetValueById("txtHPIO")
		Set tRequest.SAMLData.Organization=%page.%GetValueById("txtHPIOName")
		Set tRequest.SAMLData.UserName=%page.%GetValueById("txtUserName")
		Set tRequest.SAMLData.Role=%page.%GetValueById("txtUserRole")
		Set tRequest.SAMLData.UseRoleForAudit=1
		
		Set tSessionID = ..ExecuteAsync(tTest,tGroup)
	} catch ex {
		Do ..LogMessage($zcvt(ex.DisplayString(),"O","HTML"),$g(tGroup))
		Set tSessionID=""
	}
	&js<zen('btnSend').setProperty('disabled',false);>
	Quit tSessionID
}

ClientMethod Clear() [ Language = javascript ]
{
	this.getComponentById('txtIHINumber').setValue("");
	this.getComponentById('txtHPII').setValue("");
	this.getComponentById('txtHPIO').setValue("");
	this.getComponentById('txtHPIOName').setValue("");
	this.getComponentById('txtUserName').setValue("");
	this.getComponentById('txtUserRole').setValue("");
	
	zen('cmbDocID').setValue("");
	zen('txaRepoID').setValue("");
	zen('txaDocID').setValue("");
	zen('txaHomeCommunityID').setValue("");
}

ClientMethod DemoData() [ Language = javascript ]
{
	this.getComponentById('txtIHINumber').setValue("8003608500128236");
	this.getComponentById('txtHPII').setValue("8003616566666809");
	this.getComponentById('txtHPIO').setValue("8003629900019452");
	this.getComponentById('txtHPIOName').setValue("DHS5504");
	this.getComponentById('txtUserName').setValue("NEHTA_Test_User");
	this.getComponentById('txtUserRole').setValue("HealthcareProvider");
}

Method GetRequestMessage() As HS.Message.IHE.XDSb.RetrieveRequest
{
	Set tRequest=##class(HS.AU.Message.IHE.XDSb.RetrieveRequest).%New()
	/*
	Set tRequest.SAMLData.IHINumber=$G(%session.Data("IHETest.AU","LastIHINumber"))
	// Pull in demo values
	Set tRequest.SAMLData.NPI="8003616566666809"
	Set tRequest.SAMLData.OrganizationID="8003629900019452"
	Set tRequest.SAMLData.Organization="DHS5504"
	Set tRequest.SAMLData.UseRoleForAudit=1
	Set tRequest.SAMLData.UserName="NEHTA_Test_User"
	Set tRequest.SAMLData.Role="HealthcareProvider"
	Set tRequest.SAMLData.UseRoleForAudit=1
	*/
	Quit tRequest
}

}
