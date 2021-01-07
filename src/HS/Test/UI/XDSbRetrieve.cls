Class HS.Test.UI.XDSbRetrieve Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Retrieve Patient CCD";

Property HomeCommunityID As %String(ZENURL = "HOMEID");

Property RepositoryID As %String(ZENURL = "REPOID");

Property DocumentID As %String(ZENURL = "DOCID");

/// Dynamically determine repository
Parameter SERVICEREGISTRYENTRY;

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

<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left" enctype="multipart/form-data">
<checkbox label="Enable logging" id="chkLogging" title="Route traffic through tcp trace utility"/>
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
<checkbox caption="Execute CrossGateway Retrieve" id="chkCrossGateway" onchange="zenPage.checkCrossGateway(zenThis.getValue());"  title="Route transaction to either XDSb host or XCA host.  Update endpoint appropriately."/>

<spacer height="15"/>

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
<pane id="paneResults">
</pane>
</pane>
</page>
}

ClientMethod Clear() [ Language = javascript ]
{
	zen('cmbDocID').setValue("");
	zen('txaRepoID').setValue("");
	zen('txaDocID').setValue("");
	zen('txaHomeCommunityID').setValue("");
}

ClientMethod checkCrossGateway(value) [ Language = javascript ]
{
	if(value == true) {
		zenPage.getComponentById("txtHost").setValue("HS.IHE.XCA.InitiatingGateway.Operations");
	} else {
		zenPage.getComponentById("txtHost").setValue("HS.IHE.XDSb.Consumer.Operations");
	}
}

Method SelectDocument() [ ZenMethod ]
{
	try {
		Set val = %page.%GetValueById("cmbDocID")
		Set docID= $p($p(val,"DOCID=",2),"&REPOID=")
		Set repoID=$p($p(val,"REPOID=",2),"&")
		Set tHomeID=$p($p(val,"HOMEID=",2),"&")
		Set cv=%page.%GetComponentById("txaDocID").value Set:cv]"" cv=cv_$c(10)
		set %page.%GetComponentById("txaDocID").value=cv_ docID
		Set cv=%page.%GetComponentById("txaRepoID").value Set:cv]"" cv=cv_$c(10)
		set %page.%GetComponentById("txaRepoID").value=cv_repoID
		Set cv=%page.%GetComponentById("txaHomeCommunityID").value Set:cv]"" cv=cv_$c(10)
		set %page.%GetComponentById("txaHomeCommunityID").value=cv_tHomeID
		
		Set tService = ##class(HS.Registry.Service.Abstract).EndPointForOID(repoID,"Repository","XDSb.Retrieve", "SOAP")
		///Set tID=$S($isObject(tService):tService.%Id(),1:"")
		Set tName = $S($IsObject(tService):tService.Name,1:"")
		Do:tName]"" %page.%SetValueById("cmbServiceRegistry",tName)
	}	
	 catch ex {
	}
}

Method ViewDocument(objID, docNum) [ ZenMethod ]
{
	Set tObject = ##class(HS.Message.IHE.XDSb.RetrieveResponse).%OpenId(objID)
	If '$IsObject(tObject) &js< alert('retrieve object not found');> Quit
	Set tMime = tObject.StreamCollection.GetAt(docNum) 
	Set tTestServiceName=$g(%session.Data("IHE.Test","TestServiceName"),..#TESTSERVICENAME)
	Set ^CacheTemp.TestUI(tTestServiceName)=""
	Set size=3000000 do tMime.Body.Rewind()
	For  {
		Set tString=tMime.Body.Read(.size)
		Quit:size<1
		Set ^CacheTemp.TestUI(tTestServiceName)=^CacheTemp.TestUI(tTestServiceName)_tString
	}
	Set tURL="HS.Test.UI.XMLViewer.cls?ID="_tTestServiceName_"&Type="_tMime.ContentType
	&js<window.open("#(tURL)#");>
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
		//Put together a HS.Message.IHE.XDSb.RetrieveRequest
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

		Set tSessionID = ..ExecuteAsync(tTest,tGroup)
	} catch ex {
		Do ..LogMessage($zcvt(ex.DisplayString(),"O","HTML"),$g(tGroup))
		Set tSessionID=""
	}
	&js<zen('btnSend').setProperty('disabled',false);>
	Quit tSessionID
}

Method DisplayTestResult(pTest As HS.Test.UI.Test, pGroupTest As HS.Test.UI.TestGroup = "", pClear = 0)
{
	Do ##super(pTest,pGroupTest,pClear)
	Set tResponse=pTest.Response
	If $IsObject(tResponse) && $$$ISOK(pTest.Status) {
		#dim results as %ZEN.Component.pane
		set results=%page.%GetComponentById("paneResults")
		For tIdx=1:1:tResponse.Documents.Count() {
			Set tButton = ##class(%ZEN.Component.button).%New()
			Set tButton.onclick="zenPage.ViewDocument("_tResponse.%Id()_","_tIdx_")"
			Set tButton.caption="View Document"
			Do results.%AddChild(tButton)
		}

	}
}

Method GetRequestMessage() As HS.Message.IHE.XDSb.RetrieveRequest
{
	If %page.%GetValueById("chkCrossGateway") { 
		Quit ##class(HS.Message.IHE.XCA.RetrieveRequest).%New()
	} Else {
		Quit ##class(HS.Message.IHE.XDSb.RetrieveRequest).%New()
	}
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set tServiceRegistry=$g(%session.Data("IHE.Test",..%ClassName(0),"ServiceRegistry"))
	Set:tServiceRegistry="" tServiceRegistry=..#SERVICEREGISTRYENTRY
	Set tCrossGateway=$g(%session.Data("IHE.Test",..%ClassName(0),"CrossGateway"))
	Set tHost=$g(%session.Data("IHE.Test",..%ClassName(0),"Host"))
	Set tRepositoryID=$g(%session.Data("IHE.Test",..%ClassName(0),"RepositoryID"))
	Set tDocumentID=$g(%session.Data("IHE.Test",..%ClassName(0),"DocumentID"))
	Set tHomeCommunityID=$g(%session.Data("IHE.Test",..%ClassName(0),"HomeCommunityID"))

	Set tRepositoryService = ..#SERVICEREGISTRYENTRY
	Set tRepositoryOID=%page.RepositoryID
	If tRepositoryOID]"" Set tRepositoryService=##class(HS.Registry.Service.SOAP).EndPointForOID(tRepositoryOID,"Repository","XDSb.Retrieve") Set:$isObject(tRepositoryS) tRepositoryService=tRepositoryS.Name
	Set tSC= ..AddServiceEntries(tRepositoryService) 
	Do ..SetLogging()
	#; lookup the repository endpoint based on the oid
	//Set tSC= ..AddServiceRegistryEntries(tRepositoryService) 
	If %page.TESTGROUPID]"" {
		Set tGroup = ##class(HS.Test.UI.TestGroup).%OpenId(%page.TESTGROUPID)
		If $isObject(tGroup) {
			Do ..PostAsyncExecuteDisplay(tGroup,1)
			Set tRepositoryID=tGroup.AdditionalInfo.GetAt("RepositoryID")
			Set tDocumentID=tGroup.AdditionalInfo.GetAt("DocumentID")
			Set tHomeCommunityID=tGroup.AdditionalInfo.GetAt("HomeCommunityID")
			Set tHost=tGroup.AdditionalInfo.GetAt("Host")
			Set tServiceRegistry=tGroup.AdditionalInfo.GetAt("ServiceRegistry")
			Set tCrossGateway=tGroup.AdditionalInfo.GetAt("CrossGateway")
		}
	}

	Do ..AddRecentDocuments(,"cmbDocID")	
	Do ..%SetValueById("txtHost",tHost)
	Do:tServiceRegistry]"" ..%SetValueById("cmbServiceRegistry",tServiceRegistry)
	Do ..%SetValueById("chkCrossGateway",tCrossGateway)
	Do ..%SetValueById("txaRepoID",tRepositoryID)
	Do ..%SetValueById("txaDocID",tDocumentID)
	Do ..%SetValueById("txaHomeCommunityID",tHomeCommunityID)

	Quit $$$OK
}

}
