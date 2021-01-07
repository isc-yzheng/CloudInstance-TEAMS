/// Request object which will be used with a transformation to produce a valid query for the XDSb.Registry
Class HS.Message.IHE.XDSb.QueryRequest Extends (HS.Util.EnsRequest, HS.Types.RequestInfo) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// HealthShare Foundation
Parameter FOUNDATION = 1;

/// Default response class
Parameter RESPONSECLASSNAME As %String = "HS.Message.XMLMessage";

Property Parameters As list Of HS.Message.IHE.XDSb.QueryItem;

/// Query Type 
/// FindDocuments,FindDocumentsMultiPatients,FindSubmissionSets,FindFolders,GetAll,GetDocuments,GetFolders,GetAssociations,GetDocsAndAssociations,GetSubmissionSets,GetSubSetsAndContents,GetFolderAndContents,GetFoldersForDocument,GetRelatedDocuments,FindFoldersMultiPatients,FindDocumentsByReferenceId
Property QueryType As %String(DISPLAYLIST = ",14d4debf-8f97-4251-9a74-a90016b0af0d,3d1bdb10-39a2-11de-89c2-2f44d94eaa9f,f26abbcb-ac74-4422-8a30-edb644bbc1a9,958f3006-baad-4929-a4de-ff1114824431,10b545ea-725c-446d-9b95-8aeb444eddf3,5c4f972b-d56b-40ac-a5fc-c8ca9b40b9d4,5737b14c-8a1a-4539-b659-e03a34a5e1e4,a7ae438b-4bc2-4642-93e9-be891f7bb155,bab9529a-4a10-40b3-a01f-f68a615d247a,51224314-5390-4169-9b91-b1980040715a,e8e3cb2c-e39c-46b9-99e4-c12f57260b83,b909a503-523d-4517-8acf-8e5834dfc4c7,10cae35a-c7f9-4cf5-b61e-fc3278ffb578,d90e5407-b356-4d91-a89f-873917b4b0e6,50d3f5ac-39a2-11de-a1ca-b366239e58df,12941a89-e02e-4be5-967c-ce4bfc8fe492", VALUELIST = ",FindDocuments,FindDocumentsMultiPatients,FindSubmissionSets,FindFolders,GetAll,GetDocuments,GetFolders,GetAssociations,GetDocsAndAssociations,GetSubmissionSets,GetSubSetsAndContents,GetFolderAndContents,GetFoldersForDocument,GetRelatedDocuments,FindFoldersMultiPatients,FindDocumentsByReferenceId", XMLLISTPARAMETER = "DISPLAYLIST") [ InitialExpression = "FindDocuments" ];

/// Coded entry for HomeCommunityOID
Property HomeCommunity As %String;

/// The OID value for the Home Community
Property HomeCommunityOID As %String;

Property ReturnType As %String(DISPLAYLIST = ",LeafClass,ObjectRef", VALUELIST = ",LC,OR", XMLLISTPARAMETER = "DISPLAYLIST") [ InitialExpression = "LC" ];

/// Helper methods used to add single value items to the query
Method AddSingleParam(pParam, pName) As %Status
{
	Set tItem=##class(HS.Message.IHE.XDSb.QueryItem).%New()
	Do ..Parameters.Insert(tItem)
	Set tItem.ItemName=pName
	Do tItem.Values.Insert(pParam)
	Set tItem.SingleValue=1
	Quit $$$OK
}

/// Helper methods used to add value items to the query (where the item is a multi-value parameter
Method AddParam(pParam, pName) As %Status
{
	Set tItem=##class(HS.Message.IHE.XDSb.QueryItem).%New()
	Do ..Parameters.Insert(tItem)
	Set tItem.ItemName=pName
	Do tItem.Values.Insert(pParam)
	Set tItem.SingleValue=0
	Quit $$$OK
}

Method AddPatientId(pPatientId, pItemName = "$XDSDocumentEntryPatientId") As %Status
{
	Set tID=$p(pPatientId,"^") If tID="" Quit $$$ERROR($$$GeneralError,"ID portion of patient id is empty format ID^^^&OID&ISO")
	Set tAD=$p(pPatientId,"&",2) If tAD="" Quit $$$ERROR($$$GeneralError,"AffinityDomain portion of patient id is empty format ID^^^&OID&ISO")
	If (tID_"^^^&"_tAD_"&ISO")'=pPatientId Quit $$$ERROR($$$GeneralError,"Patient ID format is ID^^^&OID&ISO")
	Do ..Parameters.Insert(##class(QueryItem).SingleParam(pPatientId,pItemName))
	Quit $$$OK
}

Method AddCreationFrom(pParam) As %Status
{
	Do ..Parameters.Insert(##class(QueryItem).SingleParam(pParam,"$XDSDocumentEntryCreationTimeFrom"))
	Quit $$$OK
}

Method AddCreationTo(pParam) As %Status
{
	Do ..Parameters.Insert(##class(QueryItem).SingleParam(pParam,"$XDSDocumentEntryCreationTimeTo"))
	Quit $$$OK
}

/// Ability to add status values either one or comma delimited
/// Approved,Deprecated without full name resolution
Method AddStatusValues(pValues, pItemName = "$XDSDocumentEntryStatus") As %Status
{
	Do ..Parameters.Insert(##class(QueryItem).StatusValues(pValues,pItemName))
	Quit $$$OK
}

/// pType=1 - Stable, 2 - OnDemand, 3 - both
Method AddDocumentType(pType = 1) As %Status
{
	Do ..Parameters.Insert(##class(QueryItem).DocumentType(pType))
	Quit $$$OK
}

/// A method to configure a query by UUID setting the QueryType and inserting the UUID parameter
Method QueryByEntryUUID(pEntryUUID) As %Status
{
	Set ..QueryType="GetDocuments"
	Set tItem=##class(HS.Message.IHE.XDSb.QueryItem).%New() 
	Set tItem.ItemName="$XDSDocumentEntryEntryUUID"
	Do tItem.Values.Insert(pEntryUUID)
	Do ..Parameters.Insert(tItem)
	Quit $$$OK
}

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.XDSb.QueryRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.XDSb.QueryRequest.CustomAuditInfo"</Subscript>
</Data>
<Data name="QueryRequestDefaultData">
<Subscript>"QueryRequest"</Subscript>
<Value name="1">
<Value>AuthBy</Value>
</Value>
<Value name="2">
<Value>AuthType</Value>
</Value>
<Value name="3">
<Value>BTGReason</Value>
</Value>
<Value name="4">
<Value>QueryType</Value>
</Value>
<Value name="5">
<Value>RequestingUserRoles</Value>
</Value>
<Value name="6">
<Value>RequestingForProxyUserID</Value>
</Value>
<Value name="7">
<Value>RequestingForProxyID</Value>
</Value>
<Value name="8">
<Value>Signature</Value>
</Value>
<Value name="9">
<Value>RequestId</Value>
</Value>
<Value name="10">
<Value>RequestingGateway</Value>
</Value>
<Value name="11">
<Value>Type</Value>
</Value>
<Value name="12">
<Value>BreakTheGlass</Value>
</Value>
<Value name="13">
<Value>ClinicalTypes</Value>
</Value>
<Value name="14">
<Value>Consent</Value>
</Value>
<Value name="15">
<Value>Parameters</Value>
</Value>
<Value name="16">
<Value>RequestingUser</Value>
</Value>
<Value name="17">
<Value>ReturnComposedObjects</Value>
</Value>
<Value name="18">
<Value>ReturnType</Value>
</Value>
<Value name="19">
<Value>MultiPatientQuery</Value>
</Value>
<Value name="20">
<Value>HomeCommunity</Value>
</Value>
<Value name="21">
<Value>SAMLData</Value>
</Value>
<Value name="22">
<Value>HomeCommunityOID</Value>
</Value>
</Data>
<DefaultData>QueryRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
