/// Metadata Update tester
Class HS.Test.UI.XDSbMU Extends HS.Test.UI.Main
{

Parameter PAGENAME = "XDSb Metadata Update";

Property HomeCommunityID As %String(ZENURL = "HOMEID");

Property DocumentID As %String(ZENURL = "DOCID");

Property PatientID As %String(ZENURL = "PATID");

Parameter SERVICEREGISTRYENTRY = "XDSb.Registry";

XData Contents
{
<page title="HealthShare IHE Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
	
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<spacer height="40"/>
<form layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left" enctype="multipart/form-data">
<spacer height="5"/>
<checkbox label="Enable logging" id="chkLogging" title="Route traffic through tcp trace utility"/>
<combobox id="cmbDocID" label=" Select Document for Retrieval:" size="80" valueList="" displayList="" value="" onchange="zenPage.SelectDocument();"/>
<spacer height="5"/>
<textarea label="Home Community Id:" id="txaHomeCommunityID" value="#(%page.HomeCommunityID)#" rows="3" cols="80" />
<textarea label="Document Unique Id:" id="txaDocID" value="#(%page.DocumentID)#"  rows="3" cols="80"/>
<textarea label="Patient ID:" id="txaPatID" value="#(%page.PatientID)#"  rows="3" cols="80"/>
<dataCombo id="cmbServiceRegistry" size='80' label="Registry (Update): *" dropdownWidth="800" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	OnCreateResultSet="CreateServiceRegistryRS"
	maxRows="10000">
	<parameter/>
</dataCombo>
<dataCombo id="cmbServiceQuery" size='80' label="Registry (Query): *" dropdownWidth="800" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	OnCreateResultSet="CreateServiceRegistryRS"
	maxRows="10000">
	<parameter/>
</dataCombo>
<text hidden='true' id="txtUpdateType" value=""/>

<spacer height="15"/>

<hgroup cellAlign="right">
<button id="btnUpdate" caption=" Update Test " onclick="zen('txtUpdateType').setValue('Update');zenPage.StartSend('btnUpdate',1);" />
<button id="btnStatus" caption=" Status Test " onclick="zen('txtUpdateType').setValue('Status');zenPage.StartSend('btnStatus',1);" />

</hgroup>
</form>

<vgroup>
<pane paneName="asyncPane"/>
</vgroup>
<pane id="paneResults">
</pane>

<textarea name="RDSRequest" id="txtRequest" hidden="true" />
<textarea name="RDSResponse" id="txtResponse" hidden="true"/>

</pane>
</page>
}

Method SelectDocument() [ ZenMethod ]
{
	try {
		Set val = %page.%GetValueById("cmbDocID")
		Set docID= $p($p(val,"DOCID=",2),"&REPOID=")
		Set repoID=$p($p(val,"REPOID=",2),"&")
		Set tHomeID=$p($p(val,"HOMEID=",2),"&")
		set %page.%GetComponentById("txaDocID").value = docID
		Set cv=%page.%GetComponentById("txaDocID").value Set:cv]"" cv=cv_$c(10)
		Set cv=%page.%GetComponentById("txaHomeCommunityID").value Set:cv]"" cv=cv_$c(10)
		set %page.%GetComponentById("txaHomeCommunityID").value=cv_tHomeID
		
		set %page.%GetComponentById("txaPatID").value="test"
		Set tPatientID = ""
		Merge tSVRecentDocuments = %session.Data("IHE.Test","RecentDocuments")
		For tIdx=1:1:+$g(tSVRecentDocuments) {
			Set tItem = tSVRecentDocuments(tIdx)
			if ($li(tItem,3) = docID) {
				Set tPatientID = $lg(tItem)
			}
		}
		set %page.%GetComponentById("txaPatID").value=tPatientID
			
		/*		
		Set tService = ##class(HS.Registry.Service.Abstract).EndPointForOID(repoID,"Repository","XDSb.Retrieve", "SOAP")
		///Set tID=$S($isObject(tService):tService.%Id(),1:"")
		Set tName = $S($IsObject(tService):tService.Name,1:"")
		Do:tName]"" %page.%SetValueById("cmbServiceRegistry",tName)
		*/
	}	
	 catch ex {
	}
}

Method %OnAfterCreatePage() As %Status
{
	Set tServiceRegistry=$g(%session.Data("IHE.Test",..%ClassName(0),"ServiceRegistry"))
	Set:tServiceRegistry="" tServiceRegistry=..#SERVICEREGISTRYENTRY
	Set tServiceQuery=$g(%session.Data("IHE.Test",..%ClassName(0),"ServiceQuery"))
	Set:tServiceQuery="" tServiceQuery=..#SERVICEREGISTRYENTRY

	Do ..%SetValueById("txaDocID",$g(%session.Data("XDSbMU.lastDocId")))	
	Do ..%SetValueById("txaPatID",$g(%session.Data("XDSbMU.lastPatId")))	
	Do ..%SetValueById("txaHomeCommunityID",$g(%session.Data("XDSbMU.lastHomeId")))	
	Do ..SetLogging()

	If %page.TESTGROUPID]"" {
		Set tGroup = ##class(HS.Test.UI.TestGroup).%OpenId(%page.TESTGROUPID)
		Set tPatientId=tGroup.AdditionalInfo.GetAt("PatientId")
		Set tDocId=tGroup.AdditionalInfo.GetAt("DocumentId")
		Do:tDocId]"" ..%SetValueById("txaDocID",tDocId)
		Do:tPatientId]"" ..%SetValueById("txaPatID",tPatientId)	
		If $isObject(tGroup) Do ..DisplayGroupTestResult(tGroup)
	}
	Do ..%SetValueById("cmbServiceRegistry",tServiceRegistry)
	Do ..%SetValueById("cmbServiceQuery",tServiceQuery)
	Do ..AddRecentDocuments(,"cmbDocID")	


	Quit $$$OK
}

Method Send() As %String [ ZenMethod ]
{
	Set type=%page.%GetValueById("txtUpdateType")
	If type="Update" {
		Set tSessionID = ..RunIHE()
	} Else {
		Set tSessionID = ..RunStatus()
	}
	Quit tSessionID
}

Method RunIHE() As %String [ ZenMethod ]
{
	Try {
		Set tDocId = %page.%GetValueById("txaDocID")
		Set tHomeId = %page.%GetValueById("txaHomeCommunityID")
		Set tPatId = %page.%GetValueById("txaPatID")


		Do ..ClearResultsPane()
		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		
		Set %session.Data("XDSbMU.lastHomeId")=tHomeId
		Set %session.Data("XDSbMU.lastDocId")=tDocId
		Set %session.Data("XDSbMU.lastPatId")=tPatId
		
		Do ..LogMessage("Query for original document",tGroup)
		Set tSC = ..Query(tGroup,tDocId,tHomeId,.tOrigDoc,"cmbServiceQuery") $$$ThrowOnError(tSC)
		
		#dim tDoc,tOrigDoc,tDoc1,tDoc2,tDoc3 As HS.Message.IHE.XDSb.Document
		
		#; FIRST UPDATE:  Document Administration updates the DocumentEntry for version 1 of the document, changing typeCode to :
		#; <Code code="28636-9" display="Initial Evaluation Note" codingScheme="LOINC" />
		// Mike NA2014 - code changed this year 
		/// <Code code="28570-0" codingScheme="2.16.840.1.113883.6.1" display = "Procedure Note" /> 
		Do ..LogMessage("Change 1: typeCode")
		Set tDoc = tOrigDoc.%ConstructClone(1)
		Set tUpdate = ##class(HS.Message.IHE.XDSb.UpdateDocumentSetRequest).%New()
		Set tUpdate.RequestingUser="SFarrell"
		Set tUpdate.RequestingUserRoles="%All"
		Set tUpdate.PatientId = tDoc.PatientId
		Set tUpdate.SourceId = $P(tDoc.PatientId,"&",2)
		//MVH NA2014 - new code 	<Code code="34133-9" codingScheme="2.16.840.1.113883.6.1" 	display = "Summarization of Episode Note" />
		//Set tUpdate.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon contentTypeCodes","Summarization of episode")
		Set tUpdate.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","2.16.840.1.113883.6.1","Summarization of Episode Note")
		Set tDoc.EntryUUID="DocUpdate1"
		Set tDoc.TypeCode.Code = "28570-0"
		Set tDoc.TypeCode.Description = "Procedure Note"
		Set tDoc.TypeCode.Scheme = "LOINC"
		Set tSC = tUpdate.Documents.Insert(tDoc) $$$ThrowOnError(tSC)
		Set tTest=tGroup.NewTest(tUpdate,%page.%GetValueById("chkLogging"))

		Set tSC = ..Execute(tTest,tGroup) $$$ThrowOnError(tSC)
		Do ..DisplayTestResult(tTest,tGroup)
		Set tResponse=tTest.Response
		Set tSC = ##class(HS.IHE.XDSb.Util).ProcessResponse(tResponse) $$$ThrowOnError(tSC)	
		Do ..LogFinished(tGroup)
		
		Do ..LogMessage("Query for version 1 document",tGroup)
		Set tSC = ..Query(tGroup,tDocId,tHomeId,.tDoc1,"cmbServiceQuery") $$$ThrowOnError(tSC)


		#; SECOND UPDATE:  Doc Administrator updates the DocumentEntry for version 2 of the document, changing healthcareFacilityTypeCode to:
		#; <Code code="AMB" display="Ambulance” codingScheme="2.16.840.1.113883.5.11" />
		Do ..LogMessage("Change 2: healthcareFacilityTypeCode")
		Set tDoc = tDoc1.%ConstructClone(1)
		Set tUpdate = ##class(HS.Message.IHE.XDSb.UpdateDocumentSetRequest).%New()
		Set tUpdate.RequestingUser="SFarrell"
		Set tUpdate.RequestingUserRoles="%All"
		Set tUpdate.PatientId = tDoc.PatientId
		Set tUpdate.SourceId = $P(tDoc.PatientId,"&",2)
		Set tUpdate.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","2.16.840.1.113883.6.1","Summarization of Episode Note")
		Set tDoc.EntryUUID="DocUpdate2"
		Set tDoc.HealthcareFacilityTypeCode.Code = "AMB"
		Set tDoc.HealthcareFacilityTypeCode.Description = "Ambulance"
		Set tDoc.HealthcareFacilityTypeCode.Scheme = "2.16.840.1.113883.5.11"
		Set tSC = tUpdate.Documents.Insert(tDoc) $$$ThrowOnError(tSC)

		Set tTest=tGroup.NewTest(tUpdate,%page.%GetValueById("chkLogging"))

		Set tSC = ..Execute(tTest,tGroup) $$$ThrowOnError(tSC)
		Do ..DisplayTestResult(tTest,tGroup)
		Set tResponse=tTest.Response
		Set tSC = ##class(HS.IHE.XDSb.Util).ProcessResponse(tResponse) $$$ThrowOnError(tSC)	
		Do ..LogFinished(tGroup)
		
		Do ..LogMessage("Query for version 2 document")
		Set tSC = ..Query(tGroup,tDocId,tHomeId,.tDoc2,"cmbServiceQuery") $$$ThrowOnError(tSC)
		
		
		#;THIRD UPDATE:  Doc Administrator updates the Document Entry for version 3 of the document, changing  languageCode to a value of en-GB.
		Do ..LogMessage("Change 3: language",tGroup)
		Set tDoc = tDoc2.%ConstructClone(1)
		Set tUpdate = ##class(HS.Message.IHE.XDSb.UpdateDocumentSetRequest).%New()
		Set tUpdate.RequestingUser="SFarrell"
		Set tUpdate.RequestingUserRoles="%All"
		Set tUpdate.PatientId = tDoc.PatientId
		Set tUpdate.SourceId = $P(tDoc.PatientId,"&",2)
		Set tUpdate.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","2.16.840.1.113883.6.1","Summarization of Episode Note")
		Set tDoc.EntryUUID="DocUpdate2"
		Set tDoc.LanguageCode = "en-GB"

		Set tSC = tUpdate.Documents.Insert(tDoc) $$$ThrowOnError(tSC)

		Set tTest=tGroup.NewTest(tUpdate,%page.%GetValueById("chkLogging"))

		Set tSC = ..Execute(tTest,tGroup) 

		Do ..DisplayTestResult(tTest,tGroup)
		$$$ThrowOnError(tSC)
		Set tSC = ##class(HS.IHE.XDSb.Util).ProcessResponse(tResponse) $$$ThrowOnError(tSC)	
		Do ..LogFinished(tGroup)
		
		Do ..LogMessage("Query for version 3 document",tGroup)
		Set tSC = ..Query(tGroup,tDocId,tHomeId,.tDoc3,"cmbServiceQuery") $$$ThrowOnError(tSC)
		
		
		#;  Doc Administrator attempts to update the metadata version 2.  That update should fail.  The Registry should only accept updates to the most recent version.
		Do ..LogMessage("Should fail to update version 2",tGroup)
		Set tDoc = tDoc2.%ConstructClone(1)
		Set tUpdate = ##class(HS.Message.IHE.XDSb.UpdateDocumentSetRequest).%New()
		Set tUpdate.RequestingUser="SFarrell"
		Set tUpdate.RequestingUserRoles="%All"
		Set tUpdate.PatientId = tDoc.PatientId
		Set tUpdate.SourceId = $P(tDoc.PatientId,"&",2)
		Set tUpdate.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","2.16.840.1.113883.6.1","Summarization of Episode Note")
		Set tDoc.EntryUUID="DocUpdate2"
		Set tDoc.Title = "THIS SHOULD FAIL"
		Set tSC = tUpdate.Documents.Insert(tDoc) $$$ThrowOnError(tSC)
		Set tTest=tGroup.NewTest(tUpdate,%page.%GetValueById("chkLogging"))

		Set tSC = ..Execute(tTest,tGroup) $$$ThrowOnError(tSC)
		Do ..DisplayTestResult(tTest,tGroup)
		Set tResponse=tTest.Response
		Set tSC = ##class(HS.IHE.XDSb.Util).ProcessResponse(tResponse)
		If '$$$ISERR(tSC) Do ..LogMessage("ERROR: should have failed to update version 2",tGroup)
		Do ..LogMessage("OK",tGroup)
		Do ..LogFinished(tGroup)
		#; Doc Administrator attempts to change the availabilityStatus of version to Approved.  That update should fail.  The Registry may only update the availabilityStatus of the most recent version.
		#;??? version 1?
		Do ..LogMessage("Should fail to change availability status of version 1",tGroup)
		Set tDoc = tDoc1.%ConstructClone(1)
		Set tUpdate = ##class(HS.Message.IHE.XDSb.UpdateDocumentSetRequest).%New()
		Set tUpdate.RequestingUser="SFarrell"
		Set tUpdate.RequestingUserRoles="%All"
		Set tUpdate.PatientId = tDoc.PatientId
		Set tUpdate.SourceId = $P(tDoc.PatientId,"&",2)
		Set tUpdate.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","2.16.840.1.113883.6.1","Summarization of Episode Note")
		Set tDoc.EntryUUID="DocUpdate2"
		Set tDoc.AvailabilityStatus = "Approved"
		Set tSC = tUpdate.Documents.Insert(tDoc) $$$ThrowOnError(tSC)
		Set tTest=tGroup.NewTest(tUpdate,%page.%GetValueById("chkLogging"))

		Set tSC = ..Execute(tTest,tGroup) $$$ThrowOnError(tSC)
		Do ..DisplayTestResult(tTest,tGroup)
		Set tResponse=tTest.Response
		Set tSC = ##class(HS.IHE.XDSb.Util).ProcessResponse(tResponse)
		If '$$$ISERR(tSC) Do ..LogMessage("ERROR: should have failed to update availibility status of version 1",tGroup)
		Do ..LogMessage("OK",tGroup)
		Do ..LogFinished(tGroup)
		Do ..LogMessage("Success",tGroup)
		Do ..DisplayGroupTestName(tGroup)
		
	} Catch ex {
		Do ..LogException(ex)
		Do ..LogMessage("Failed")
	}
		&js<zen('btnUpdate').setProperty('disabled',false);>
	Quit ""
}

Method RunStatus() As %Status [ ZenMethod ]
{
	#dim tQueryResponse As HS.Message.IHE.XDSb.QueryResponse
	Try {
		Set tPatId = %page.%GetValueById("txaPatID")
		Set tHomeId = %page.%GetValueById("txaHomeCommunityID")
		Set tDocId = %page.%GetValueById("txaDocID")
		Do ..ClearResult()
		Set %session.Data("XDSbMU.lastHomeId")=tHomeId
		Set %session.Data("XDSbMU.lastPatId")=tPatId
		Set %session.Data("XDSbMU.lastDocId")=tDocId

		#dim tDoc As HS.Message.IHE.XDSb.Document
		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1),"RunStatus")
		Do ..LogMessage("Query for original documents",tGroup,"RunStatus")
		Set %session.Data("XDSbMU.GroupId")=tGroup.%Id()
		Do tGroup.AdditionalInfo.SetAt(tPatId,"PatientId")
		///mike na2014 duplicate line - Do tGroup.AdditionalInfo.SetAt(tPatId,"PatientId")
		///mike na2014 Set tSC = ..QueryDoc(tGroup,tDocId,tHomeId,.tQueryResponse,"cmbServiceQuery") $$$ThrowOnError(tSC)
		Set tSC = ..QueryPat(tGroup,tPatId,tHomeId,.tQueryResponse,"cmbServiceQuery") $$$ThrowOnError(tSC)

		#; Deprecate All
		Do ..LogMessage("Sending status updates...",tGroup,"RunStatus")
		Set i="" For { Set tDoc=tQueryResponse.Documents.GetNext(.i) Quit:i=""
			if tDoc.AvailabilityStatus'="Approved" Continue
			Set tUpdate = ##class(HS.Message.IHE.XDSb.UpdateDocumentSetRequest).%New()
			Set tUpdate.RequestingUser="SFarrell"
			Set tUpdate.RequestingUserRoles="%All"
			Set tUpdate.PatientId = tDoc.PatientId
			Set tUpdate.SourceId = $P(tDoc.PatientId,"&",2)
			Set tUpdate.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","2.16.840.1.113883.6.1","Summarization of Episode Note")

			Set tAssociation = ##class(HS.Message.IHE.XDSb.Association).%New()
			Set tAssociation.ParentUUID=tUpdate.EntryUUID
			Set tAssociation.ChildUUID=tDoc.EntryUUID
			Set tAssociation.Type ="UpdateAvailabilityStatus"
			Set tAssociation.OriginalStatus="Approved"
			Set tAssociation.NewStatus="Deprecated"
			
			Do tUpdate.Associations.Insert(tAssociation)
			
			Do ..LogMessage("  Deprecating "_tDoc.EntryUUID,tGroup,"RunStatus")
			Kill tResponse
			Set tTest=tGroup.NewTest(tUpdate,%page.%GetValueById("chkLogging"),"RunStatus:Deprecate","  Deprecating status"_tDoc.UniqueId)
			Set tSC = ..Execute(tTest,tGroup)
			
			//Do ..LogMessage("  Deprecating status"_tDoc.UniqueId_"  "_tSC_"  "_tTest.SessionId,tGroup,"RunStatus")
			Do ..DisplayTestResult(tTest,tGroup) quit:$$$ISERR(tSC)

			Set tResponse=tTest.Response
			
			Set tSC = ##class(HS.IHE.XDSb.Util).ProcessResponse(tResponse) $$$ThrowOnError(tSC)	
		}

		Do ..LogMessage("Query for current documents",tGroup,"RunStatus")
		///mike na2014 Set tSC = ..QueryDoc(tGroup,tDocId,tHomeId,.tQueryResponse,"cmbServiceQuery") $$$ThrowOnError(tSC)
		Set tSC = ..QueryPat(tGroup,tPatId,tHomeId,.tQueryResponse,"cmbServiceQuery") $$$ThrowOnError(tSC)

		#; Approve First
		Set tHighVersion="",tHighDoc=""
		Set i="" For { Set tDoc=tQueryResponse.Documents.GetNext(.i) Quit:i=""
			if tDoc.Version>tHighVersion Set tHighVersion=tDoc.Version,tHighDoc=tDoc
		}

		Do ..LogMessage("Approving latest version ("_tHighVersion_")...",tGroup,"RunStatus")
		Set tDoc = tHighDoc
		Set tUpdate = ##class(HS.Message.IHE.XDSb.UpdateDocumentSetRequest).%New()
		Set tUpdate.RequestingUser="SFarrell"
		Set tUpdate.RequestingUserRoles="%All"
		Set tUpdate.PatientId = tDoc.PatientId
		Set tUpdate.SourceId = $P(tDoc.PatientId,"&",2)
		Set tUpdate.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","2.16.840.1.113883.6.1","Summarization of Episode Note")

		Set tAssociation = ##class(HS.Message.IHE.XDSb.Association).%New()
		Set tAssociation.ParentUUID=tUpdate.EntryUUID
		Set tAssociation.ChildUUID=tDoc.EntryUUID
		Set tAssociation.Type ="UpdateAvailabilityStatus"
		Set tAssociation.OriginalStatus="Deprecated"
		Set tAssociation.NewStatus="Approved"
		Do tUpdate.Associations.Insert(tAssociation)
		
		Do ..LogMessage("  Approving "_tDoc.UniqueId,tGroup,"RunStatus")
		Kill tResponse
		Set tTest=tGroup.NewTest(tUpdate,%page.%GetValueById("chkLogging"))
		Set tSC = ..Execute(tTest,tGroup)
		Do ..DisplayTestResult(tTest,tGroup) quit:$$$ISERR(tSC)
		Set tResponse=tTest.Response

		Set tSC = ##class(HS.IHE.XDSb.Util).ProcessResponse(tResponse) $$$ThrowOnError(tSC)	

		Do ..LogMessage("Query for final documents",tGroup,"RunStatus")
		Set tSC = ..QueryPat(tGroup,tPatId,tHomeId,.tQueryResponse,"cmbServiceQuery") $$$ThrowOnError(tSC)
		
		Do ..LogMessage("Success",tGroup,"RunStatus")
		Do tGroup.%Save()
		Do ..DisplayGroupTestName(tGroup)
	} Catch ex {
		Do ..LogException(ex)
		Do ..LogMessage("Failed",tGroup,"RunStatus")
	}
		&js<zen('btnStatus').setProperty('disabled',false);>
		Quit ""
}

/// Query and return the first approved document
Method Query(pGroup As HS.Test.UI.TestGroup, tDocId, tHomeId = "", Output document As HS.Message.IHE.XDSb.Document, pRegistryCombo = "cmbServiceRegistry") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tRSQ=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
		Set tRSQ.RequestingUser="SFarrell"
		Set tRSQ.RequestingUserRoles="%All"
		Set tRSQ.QueryType="GetDocuments"
		If tHomeId]"" Do tRSQ.AddSingleParam(tHomeId,"$homeCommunityId")
		Do tRSQ.AddParam(tDocId,"$XDSDocumentEntryUniqueId")

		Set tTest=pGroup.NewTest(tRSQ,%page.%GetValueById("chkLogging"))
		Set tSC = ..Execute(tTest,pGroup,pRegistryCombo)
		Do ..DisplayTestResult(tTest,pGroup)

		Set tResponse=tTest.Response
		If tResponse.Errors.Errors.Count()>0 {
			Set tTest=pGroup.NewTest("","","Query","Response returned errors")
			Do ..DisplayTestResult(tTest,pGroup)
			Quit
		}
		If tResponse.Documents.Count()=0 {
			Set tTest=pGroup.NewTest("","","Query","Document not found")
			Do ..DisplayTestResult(tTest,pGroup)
			Quit
			//Do ..LogMessage("Document not found") Quit
		}

		Set i="" For { Set document = tResponse.Documents.GetNext(.i) Quit:i=""
			If document.AvailabilityStatus = "Approved" Quit
		}
		Set tTest=pGroup.NewTest("","","Query","Found document "_document.EntryUUID)
		Do ..DisplayTestResult(tTest,pGroup)
		Do ..LogMessage("Found document "_document.EntryUUID)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Do pGroup.%Save()
		
	Quit tSC
}

/// Query and return all documents for a patient
Method QueryPat(pGroup, tPatId, tHomeId = "", Output tResponse As HS.Message.IHE.XDSb.QueryResponse, pRegistryCombo = "cmbServiceRegistry") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tRSQ=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
		Set tRSQ.RequestingUser="SFarrell"
		Set tRSQ.RequestingUserRoles="%All"
		
		Do tRSQ.AddPatientId(tPatId)
		Do tRSQ.AddStatusValues("Approved,Deprecated")
		Do tRSQ.AddDocumentType(1)
		If tHomeId]"" Do tRSQ.AddSingleParam(tHomeId,"$homeCommunityId")

		Set tTest=pGroup.NewTest(tRSQ,%page.%GetValueById("chkLogging"))
		Set tSC = ..Execute(tTest,pGroup,pRegistryCombo)
		Do ..DisplayTestResult(tTest,pGroup)
		Do pGroup.%Save()
		Do ..DisplayTestResult(tTest,pGroup)

		Set tResponse=tTest.Response
		If tResponse.Errors.Errors.Count()>0 Do ..LogMessage("Response returned errors",pGroup,"QueryPat") Quit
		If tResponse.Documents.Count()=0 Do ..LogMessage("Documents not found",pGroup,"QueryPat") Quit

		Set i="" For { Set document = tResponse.Documents.GetNext(.i) Quit:i=""
		  Do ..LogMessage("."_document.UniqueId_" "_document.AvailabilityStatus,pGroup,"QueryPat")
		  Do ..LogMessage(".."_document.EntryUUID,pGroup,"QueryPat")
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Query and return all documents for a patient
Method QueryDoc(pGroup, pDocId, tHomeId = "", Output tResponse As HS.Message.IHE.XDSb.QueryResponse, pRegistryCombo = "cmbServiceRegistry") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tRSQ=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
		Set tRSQ.RequestingUser="SFarrell"
		Set tRSQ.RequestingUserRoles="%All"

		Set tRSQ.QueryType="GetDocuments"
		Do tRSQ.AddParam(pDocId,"$XDSDocumentEntryUniqueId")
		Do tRSQ.AddStatusValues("Approved,Deprecated")

		Set tTest=pGroup.NewTest(tRSQ,%page.%GetValueById("chkLogging"))
		Set tSC = ..Execute(tTest,pGroup,pRegistryCombo)
		Do ..DisplayTestResult(tTest,pGroup)
		Do pGroup.%Save()
		Do ..DisplayTestResult(tTest,pGroup)

		Set tResponse=tTest.Response
		If tResponse.Errors.Errors.Count()>0 Do ..LogMessage("Response returned errors",pGroup,"QueryPat") Quit
		If tResponse.Documents.Count()=0 Do ..LogMessage("Documents not found",pGroup,"QueryPat") Quit

		Set i="" For { Set document = tResponse.Documents.GetNext(.i) Quit:i=""
		  Do ..LogMessage("."_document.UniqueId_" "_document.AvailabilityStatus,pGroup,"QueryPat")
		  Do ..LogMessage(".."_document.EntryUUID,pGroup,"QueryPat")
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method ClearResult()
{
	#dim results as %ZEN.Component.pane
	set results=%page.%GetComponentById("paneResults")
	Do results.%RemoveChildren()
}

}
