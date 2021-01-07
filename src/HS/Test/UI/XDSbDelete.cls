/// Test class for deleting a document set
Class HS.Test.UI.XDSbDelete Extends HS.UI.Base [ DependsOn = HS.Test.UI.Component.patientSelect ]
{

Parameter RESOURCE = "%HS_TestSuite";

XData Contents
{
<page title="HealthShare IHE Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:hs="http://www.intersystems.com/zen/hs" >
	
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:hs="http://www.intersystems.com/zen/hs" >
<spacer height="40"/>
<hs:patientSelect id="patientSelect" />
<text label="Document Unique ID:" name="txtDocumentUniqueID" id="txtDocumentUniqueID" size="80" />
<spacer height="15"/>
<form layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left" enctype="multipart/form-data">
<hgroup cellAlign="right">
<button id="btnDeleteAll" caption=" Delete All " onclick="zen('asyncOperation').execute(zenThis,function(){return zenPage.Send('DeleteAll')});" />
<button id="btnDeleteOne" caption=" Delete One Document " onclick="zen('asyncOperation').execute(zenThis,function(){return zenPage.Send('DeleteOne')});" />
<button id="btnClear" caption=" Clear log " onclick="zenPage.ClearResult();" />
</hgroup>
</form>
<hs:messageLog id="messageLog" />
<spacer height="5"/>
<hs:asyncOperation id="asyncOperation"/>
</pane>
</page>
}

Method Send(type As %String) As %String [ ZenMethod ]
{
	Set patientSelect = %page.%GetComponentById("patientSelect")
	Set tPatientID = patientSelect.PatientID()
	If type="DeleteAll" {
		set tStatus = ..DeleteDocs(tPatientID)
	} Elseif (type = "DeleteOne") {		
		Set docId = %page.%GetValueById("txtDocumentUniqueID")
		Set tStatus = ..DeleteDocs(tPatientID, docId)
	} Else {
		Set tStatus = $$$ERROR($$$GeneralError, "Unsupported request type: "_type)
	}
	if ($$$ISERR(tStatus)) {
		Do ..Logger().LogStatus(tStatus)
	}
	Quit ""
}

ClassMethod MakeRequest(tPatientID As %String, tReturnType As %String) As HS.Message.IHE.XDSb.QueryRequest [ Private ]
{
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tRequest.AddSingleParam(tPatientID,"$patientId")

	Set tRequest.QueryType="GetAll"
	Do tRequest.AddStatusValues("Approved","$XDSDocumentEntryStatus")
	Do tRequest.AddStatusValues("Approved","$XDSFolderStatus")
	Do tRequest.AddStatusValues("Approved","$XDSSubmissionSetStatus")

	//Do tRequest.AddDocumentType(3)  /// Both ondemand and stable
	//Do tRequest.AddStatusValues("Approved")
	//Set tRequest.QueryType="GetDocuments"
	Set tRequest.ReturnType=tReturnType
	quit tRequest
}

/// Delete indicated tDocId, or all docs for patient if tDocId not specified
Method DeleteDocs(tPatientID = "", tDocId) As %Status [ Private ]
{
	Do ..LogMessage("Deleting docs for " _ tPatientID)
	Set:tPatientID="" tPatientID="JeffSmith^^^&"_##class(HS.Data.OIDMap).OIDForType(##class(HS.IHE.Util).GetAffinityDomain(),"AssigningAuthority")_"&ISO"
	Set:tPatientID'["^^^" tPatientID=tPatientID_"^^^&"_##class(HS.Data.OIDMap).OIDForType(##class(HS.IHE.Util).GetAffinityDomain(),"AssigningAuthority")_"&ISO"
	Set tRequest= ..MakeRequest(tPatientID, "OR")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	If tResponse.ObjectRefs.Count()=0  Quit $$$ERROR("No documents found")
	Set m=##class(HS.Message.IHE.XDSb.DeleteDocumentSetRequest).%New()
	if ('$Data(tDocId)) {
		Do ..AddAllUUIDS(tResponse, m)
	} else {
		Do ..AddMatchingUUIDS(tResponse, m, tDocId)	
		if (m.ObjectRefs.Count() = 0) {
			Do ..LogMessage("Did not find any matching docs to id " _ tDocId)
			Set tRequestLC= ..MakeRequest(tPatientID, "LC")
			#dim tResponseLC As HS.Message.IHE.XDSb.QueryResponse
			Set tSCLC = ##class(HS.Test.Service).SendSync(tRequestLC,.tResponseLC)
			Do ..LogAllUUIDS(tResponse)
			Do ..LogAllDocuments(tResponseLC)
		}
	}
	Do ..LogDelete(m)
	Set tStatus =  ##class(HS.Test.Service).SendSync(m,.r)
	if ($$$ISERR(tStatus)) {
		quit tStatus
	} else {
		Set tSC = ##class(HS.IHE.XDSb.Util).ProcessResponse(r)
		quit tSC
	}
}

Method AddAllUUIDS(tResponse, m As HS.Message.IHE.XDSb.DeleteDocumentSetRequest) [ Private ]
{
	For tIdx = 1:1:tResponse.ObjectRefs.Count() {
		Set UUID = tResponse.ObjectRefs.GetAt(tIdx).EntryUUID
		Do m.ObjectRefs.Insert(UUID)
	}
}

Method AddMatchingUUIDS(tResponse, m As HS.Message.IHE.XDSb.DeleteDocumentSetRequest, tDocId As %String) [ Private ]
{
	For tIdx = 1:1:tResponse.ObjectRefs.Count() {
		Set UUID = tResponse.ObjectRefs.GetAt(tIdx).EntryUUID
		if (tDocId = UUID) {
			Do m.ObjectRefs.Insert(UUID)
		}
	}
}

Method LogAllUUIDS(tResponse) [ Private ]
{
	For tIdx = 1:1:tResponse.ObjectRefs.Count() {
		#dim doc As HS.Message.IHE.XDSb.ObjectRef
		Set doc = tResponse.ObjectRefs.GetAt(tIdx)
		Set UUID = doc.EntryUUID
		Do ..LogMessage(UUID)
	}
}

Method LogAllDocuments(tResponse) [ Private ]
{
	For tIdx = 1:1:tResponse.Documents.Count() {
		#dim doc As HS.Message.IHE.XDSb.ObjectRef
		Set doc = tResponse.Documents.GetAt(tIdx)
		Do ..LogMessage("UniqueId=" _ doc.UniqueId _ ", EntryUUID="_doc.EntryUUID_", LogicalUUID="_doc.LogicalUUID)
	}
}

Method LogAllAssociations(tResponse) [ Private ]
{
	For tIdx = 1:1:tResponse.Associations.Count() {
		#dim doc As HS.Message.IHE.XDSb.ObjectRef
		Set doc = tResponse.Associations.GetAt(tIdx)
		Do ..LogMessage("ParentUUID="_doc.ParentUUID_", ChildUUID="_doc.ChildUUID_", Type=" _ doc.Type)
	}
}

Method LogDelete(m As HS.Message.IHE.XDSb.DeleteDocumentSetRequest) [ Private ]
{
	Set UUIDList = ""
	Set maxDisplay = 3
	Set hasMore = m.ObjectRefs.Count() > maxDisplay
	Set toSummarize = m.ObjectRefs.Count()
	if (hasMore) {
		Set toSummarize = maxDisplay
	}
	for tIdx = 1:1:toSummarize {
		if ($L(UUIDList) > 0) {
			Set UUIDList = UUIDList _ ", "
		}
		Set UUIDList = UUIDList _ "'" _ m.ObjectRefs.GetAt(tIdx) _ "'"
	}
	if (hasMore) {
		Do ..LogMessage("Sending DeleteDocumentSetRequest for " _ m.ObjectRefs.Count() _ " including " _ UUIDList)
	} else {
		Do ..LogMessage("Sending DeleteDocumentSetRequest for " _ UUIDList)
	}
}

Method ClearResult() [ ZenMethod ]
{
	Do ..Logger().ClearResult()
}

Method LogMessage(pMsg As %String = "", pGroup = "", pMethod = "", pDateSwitch = 1) [ Private ]
{
	Do ..Logger().LogMessage(pMsg, pGroup, pMethod, pDateSwitch)
}

Method Logger() As HS.Test.UI.Component.messageLog [ Private ]
{
	Quit %page.%GetComponentById("messageLog")
}

Method AsyncOperation() As HS.Test.UI.Component.asyncOperation [ Private ]
{
	Quit %page.%GetComponentById("asyncOperation")
}

Method %OnAfterCreatePage() As %Status
{
	Set ..AsyncOperation().logger = ..Logger()
	Quit $$$OK
}

}
