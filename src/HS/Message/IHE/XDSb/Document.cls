Class HS.Message.IHE.XDSb.Document Extends (%SerialObject, HS.IHE.XDSb.Types.Document) [ Inheritance = right ]
{

Parameter XMLTYPE = "ProvidedDocument";

/// HealthShare Foundation
Parameter FOUNDATION = 1;

/// Key Value pair of items to locate the existing document
/// Valid values include 
/// 	$XDSDocumentEntryEntryUUID
/// 		$XDSDocumentEntryUniqueId
/// 		$XDSDocumentEntryPracticeSettingCode
/// 		$XDSDocumentEntryClassificationNode
/// 		$XDSDocumentEntryClassCode
/// 		$XDSDocumentEntryConfidentialityCode
/// 		$XDSDocumentEntryEventCodeList
/// 		$XDSDocumentEntryFormatCode
/// 		$XDSDocumentEntryHealthcareFacilityTypeCode
/// 		$XDSDocumentEntryTypeCode
/// 		$XDSDocumentEntryType
/// 		$XDSDocumentEntryPatientId
/// 		$XDSDocumentEntryAuthorPerson
/// 		$XDSDocumentEntryServiceStartTimeFrom
/// 		$XDSDocumentEntryServiceStartTimeTo
/// 		$XDSDocumentEntryServiceStopTimeFrom
/// 		$XDSDocumentEntryServiceStopTimeTo
/// 		$XDSDocumentEntryStatus (will default to Approved)
Property ReplacementContext As list Of HS.Message.IHE.XDSb.QueryItem;

/// if the document uuid is known assign it to the ReplaceSource, otherwise the ReplacementContext can be used to locate the document
Property ReplaceSource As %String(MAXLEN = 75);

/// calculated UUID for the document
Property EntryUUID As %String(MAXLEN = "", XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE") [ InitialExpression = {##class(HS.Util.XSLTHelper).createUUID()} ];

/// logicalUUID is the common id for documents when using metadata update - no default
Property LogicalUUID As %String(MAXLEN = "", XMLNAME = "lid", XMLPROJECTION = "ATTRIBUTE");

/// calculated OID for the document (based on the UUID)
Property UniqueId As %String(MAXLEN = "") [ InitialExpression = {##class(HS.Util.XSLTHelper).uuid2oid(..EntryUUID)} ];

Storage Default
{
<Data name="DocumentState">
<Value name="1">
<Value>Context</Value>
</Value>
<Value name="2">
<Value>ReplaceSource</Value>
</Value>
<Value name="3">
<Value>Body</Value>
</Value>
<Value name="4">
<Value>BodyCharacter</Value>
</Value>
<Value name="5">
<Value>Author</Value>
</Value>
<Value name="6">
<Value>AvailabilityStatus</Value>
</Value>
<Value name="7">
<Value>ClassCode</Value>
</Value>
<Value name="8">
<Value>Comments</Value>
</Value>
<Value name="9">
<Value>ConfidentialityCode</Value>
</Value>
<Value name="10">
<Value>CreationTime</Value>
</Value>
<Value name="11">
<Value>EventCodeList</Value>
</Value>
<Value name="12">
<Value>FormatCode</Value>
</Value>
<Value name="13">
<Value>Hash</Value>
</Value>
<Value name="14">
<Value>HealthcareFacilityTypeCode</Value>
</Value>
<Value name="15">
<Value>LanguageCode</Value>
</Value>
<Value name="16">
<Value>LegalAuthenticator</Value>
</Value>
<Value name="17">
<Value>MimeType</Value>
</Value>
<Value name="18">
<Value>ObjectType</Value>
</Value>
<Value name="19">
<Value>PatientId</Value>
</Value>
<Value name="20">
<Value>PracticeSettingCode</Value>
</Value>
<Value name="21">
<Value>RepositoryUniqueId</Value>
</Value>
<Value name="22">
<Value>ServiceStartTime</Value>
</Value>
<Value name="23">
<Value>ServiceStopTime</Value>
</Value>
<Value name="24">
<Value>Size</Value>
</Value>
<Value name="25">
<Value>SourcePatientId</Value>
</Value>
<Value name="26">
<Value>SourcePatientInfo</Value>
</Value>
<Value name="27">
<Value>Title</Value>
</Value>
<Value name="28">
<Value>TypeCode</Value>
</Value>
<Value name="29">
<Value>URI</Value>
</Value>
<Value name="30">
<Value>XOP</Value>
</Value>
<Value name="31">
<Value>EntryUUID</Value>
</Value>
<Value name="32">
<Value>HomeCommunityId</Value>
</Value>
<Value name="33">
<Value>ReplacementContext</Value>
</Value>
<Value name="34">
<Value>Snapshot</Value>
</Value>
<Value name="35">
<Value>UniqueId</Value>
</Value>
<Value name="36">
<Value>DocumentSlots</Value>
</Value>
<Value name="37">
<Value>ZipItems</Value>
</Value>
<Value name="38">
<Value>LogicalUUID</Value>
</Value>
<Value name="39">
<Value>Version</Value>
</Value>
<Value name="40">
<Value>Availability</Value>
</Value>
</Data>
<State>DocumentState</State>
<StreamLocation>^HS.Message.IHE.XDSb.DocumentS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
