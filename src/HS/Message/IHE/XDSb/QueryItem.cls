Class HS.Message.IHE.XDSb.QueryItem Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// HealthShare Foundation
Parameter FOUNDATION = 1;

/// $XDSDocumentEntryPatientId,$XDSDocumentEntryStatus, etc
Property ItemName As %String;

Property Values As list Of %String(MAXLEN = "");

Property CodedValues As list Of HS.IHE.XDSb.Types.CodedValue;

/// if this is a single value field then there should be no () surrounding the value
Property SingleValue As %Boolean [ InitialExpression = 0 ];

/// Helper methods used to add single value items to the query
ClassMethod SingleParam(pParam, pName) As QueryItem
{
	Set tItem=##class(HS.Message.IHE.XDSb.QueryItem).%New()
	Set tItem.ItemName=pName
	Do tItem.Values.Insert(pParam)
	Set tItem.SingleValue=1
	Quit tItem
}

ClassMethod PatientId(pPatientId) As QueryItem
{
	Quit ..SingleParam(pPatientId,"$XDSDocumentEntryPatientId")
}

ClassMethod CreationFrom(pParam) As QueryItem
{
	Quit ..SingleParam(pParam,"$XDSDocumentEntryCreationTimeFrom")
}

ClassMethod CreationTo(pParam) As QueryItem
{
	Quit ..SingleParam(pParam,"$XDSDocumentEntryCreationTimeTo")
}

/// Ability to add status values either one or comma delimited
/// Approved,Deprecated without full name resolution
ClassMethod StatusValues(pValues, pItemName = "$XDSDocumentEntryStatus") As QueryItem
{
	Set tBase="urn:oasis:names:tc:ebxml-regrep:StatusType:"
	Set tItem=##class(HS.Message.IHE.XDSb.QueryItem).%New()
	Set tItem.ItemName=pItemName
	For tIdx=1:1:$l(pValues,",") {
		Do tItem.Values.Insert(tBase_$p(pValues,",",tIdx))
	}
	Quit tItem
}

/// pType=1 - Stable, 2 - OnDemand, 3 - both
ClassMethod DocumentType(pType = 1) As QueryItem
{
	Set tBase="urn:oasis:names:tc:ebxml-regrep:StatusType:"
	Set tItem=##class(HS.Message.IHE.XDSb.QueryItem).%New()
	Set tItem.ItemName="$XDSDocumentEntryType"
	If pType=1 || (pType=3) Do tItem.Values.Insert("urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1")
	If pType=2 || (pType=3) Do tItem.Values.Insert("urn:uuid:34268e47-fdf5-41a6-ba33-82133c465248")
	Quit tItem
}

/// $XDSDocumentEntryEntryUUID
/// $XDSDocumentEntryUniqueId
/// $XDSDocumentEntryPracticeSettingCode
/// $XDSDocumentEntryClassificationNode
/// $XDSDocumentEntryClassCode
/// $XDSDocumentEntryConfidentialityCode
/// $XDSDocumentEntryEventCodeList
/// $XDSDocumentEntryFormatCode
/// $XDSDocumentEntryHealthcareFacilityTypeCode
/// $XDSDocumentEntryTypeCode
/// $XDSDocumentEntryType
/// $XDSDocumentEntryPatientId
/// $XDSDocumentEntryAuthorPerson
/// $XDSDocumentEntryServiceStartTimeFrom
/// $XDSDocumentEntryServiceStartTimeTo
/// $XDSDocumentEntryServiceStopTimeFrom
/// $XDSDocumentEntryServiceStopTimeTo
/// $XDSDocumentEntryStatus 
ClassMethod CodedValue(pName, pCode, pScheme) As QueryItem
{
	Set tItem=..%New()
	Set tItem.ItemName=pName
	Do tItem.CodedValues.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create(pCode,pScheme,""))
	Quit tItem
}

Storage Default
{
<Data name="QueryItemState">
<Value name="1">
<Value>ItemName</Value>
</Value>
<Value name="2">
<Value>Values</Value>
</Value>
<Value name="3">
<Value>SingleValue</Value>
</Value>
<Value name="4">
<Value>CodedValues</Value>
</Value>
</Data>
<State>QueryItemState</State>
<StreamLocation>^HS.Message.IHE.XDSb.QueryItemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
