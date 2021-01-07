/// Request object which will be used with a transformation to produce valid metadata for the XDSb.Registry Provide and Register Request
Class HS.Message.IHE.XDSb.ProvideAndRegisterRequest Extends (HS.Util.EnsRequest, HS.Types.RequestInfo, HS.IHE.XDSb.Types.Submission) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// HealthShare Foundation
Parameter FOUNDATION = 1;

/// Default response class
Parameter RESPONSECLASSNAME As %String = "HS.Message.XMLMessage";

/// The system will automatically calculate associations, document to submission, additional associations (folders / signs) can be inserted and will be included
Property Associations As list Of HS.Message.IHE.XDSb.Association;

Property Documents As list Of HS.Message.IHE.XDSb.Document;

/// Any folders inserted will also require associations
Property Folders As list Of HS.Message.IHE.XDSb.Folder;

/// One example - when trying to generate a signature, the P&R request is required to generate it and insert as another document
Property GenerateProvideAndRegisterOnly As %Boolean [ InitialExpression = 0 ];

/// Language used for LocalizedString elements
Property Language As %String;

/// optional direct from (email) address when sending to a HISP - which will be inserted into the soap header on a P&R request
Property DirectFrom As %String(MAXLEN = 254);

/// optional direct to (email) address when sending to a HISP - which will be inserted into the soap header on a P&R request
Property DirectTo As list Of %String(MAXLEN = 254);

Method %OnNew(initvalue As %Library.RawString) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set ..EntryUUID=##class(HS.Util.XSLTHelper).createUUID()
	Set ..UniqueId = ##class(HS.Util.XSLTHelper).uuid2oid(..EntryUUID)
	Quit $$$OK
}

Method UpdateAssociations() As %Status
{
	Set tSC=$$$OK
	try {
		#; user may have already created associations track which items and don't create them again
		Set tAssociations=""
		For tIdx =1:1:..Associations.Count() {
			Set tAssociation = ..Associations.GetAt(tIdx)
			If tAssociation.Type="HasMember",tAssociation.ChildUUID]"" Set tAssociations(tAssociation.ChildUUID,tAssociation.ParentUUID)=""
		}
		For tIdx=1:1:..Documents.Count() {
			Set tDocument = ..Documents.GetAt(tIdx)
			#; don't add the association if it is already in there
			If $D(tAssociations(tDocument.EntryUUID,..EntryUUID)) Continue
			Set tAssociation = ##class(HS.Message.IHE.XDSb.Association).Create("HasMember",..EntryUUID,tDocument.EntryUUID)
			If tDocument.Version]"" Set tAssociation.PreviousVersion=tDocument.Version
			Set tAssociation.SubmissionSetStatus="Original"
			Do ..Associations.Insert(tAssociation)
			If tDocument.ReplaceSource]"" {
				Set tReplaceSource=tDocument.ReplaceSource
				If $E(tReplaceSource,1,3)="urn" Set tReplaceSource=$p(tReplaceSource,"urn:uuid:",2)
				Set tAssociation = ##class(HS.Message.IHE.XDSb.Association).Create("Replaces",tDocument.EntryUUID,tReplaceSource)
				Do ..Associations.Insert(tAssociation)
			}
		}
		For tIdx=1:1:..Folders.Count() {
			Set tFolder=..Folders.GetAt(tIdx)
			#; don't add the association if it is already in there

			If $D(tAssociations(tFolder.EntryUUID,..EntryUUID)) Continue
			Set tAssociation = ##class(HS.Message.IHE.XDSb.Association).Create("HasMember",..EntryUUID,tFolder.EntryUUID)
			Do ..Associations.Insert(tAssociation)
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.XDSb.ProvideAndRegisterRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.XDSb.ProvideAndRegisterRequest.CustomAuditInfo"</Subscript>
</Data>
<Data name="ProvideAndRegisterRequestDefaultData">
<Subscript>"ProvideAndRegisterRequest"</Subscript>
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
<Value>Documents</Value>
</Value>
<Value name="5">
<Value>Body</Value>
</Value>
<Value name="6">
<Value>BodyCharacter</Value>
</Value>
<Value name="7">
<Value>RequestingForProxyID</Value>
</Value>
<Value name="8">
<Value>Author</Value>
</Value>
<Value name="9">
<Value>AvailabilityStatus</Value>
</Value>
<Value name="10">
<Value>ClassCode</Value>
</Value>
<Value name="11">
<Value>Comments</Value>
</Value>
<Value name="12">
<Value>ConfidentialityCode</Value>
</Value>
<Value name="13">
<Value>CreationTime</Value>
</Value>
<Value name="14">
<Value>EventCodeList</Value>
</Value>
<Value name="15">
<Value>FormatCode</Value>
</Value>
<Value name="16">
<Value>Hash</Value>
</Value>
<Value name="17">
<Value>HealthcareFacilityTypeCode</Value>
</Value>
<Value name="18">
<Value>LanguageCode</Value>
</Value>
<Value name="19">
<Value>LegalAuthenticator</Value>
</Value>
<Value name="20">
<Value>MimeType</Value>
</Value>
<Value name="21">
<Value>ObjectType</Value>
</Value>
<Value name="22">
<Value>PracticeSettingCode</Value>
</Value>
<Value name="23">
<Value>RepositoryUniqueId</Value>
</Value>
<Value name="24">
<Value>ServiceStartTime</Value>
</Value>
<Value name="25">
<Value>ServiceStopTime</Value>
</Value>
<Value name="26">
<Value>Size</Value>
</Value>
<Value name="27">
<Value>SourcePatientId</Value>
</Value>
<Value name="28">
<Value>SourcePatientInfo</Value>
</Value>
<Value name="29">
<Value>Title</Value>
</Value>
<Value name="30">
<Value>TypeCode</Value>
</Value>
<Value name="31">
<Value>UniqueId</Value>
</Value>
<Value name="32">
<Value>URI</Value>
</Value>
<Value name="33">
<Value>XOP</Value>
</Value>
<Value name="34">
<Value>BreakTheGlass</Value>
</Value>
<Value name="35">
<Value>ClinicalTypes</Value>
</Value>
<Value name="36">
<Value>Consent</Value>
</Value>
<Value name="37">
<Value>ContentTypeCode</Value>
</Value>
<Value name="38">
<Value>Context</Value>
</Value>
<Value name="39">
<Value>EntryUUID</Value>
</Value>
<Value name="40">
<Value>HomeCommunityId</Value>
</Value>
<Value name="41">
<Value>PatientId</Value>
</Value>
<Value name="42">
<Value>RequestId</Value>
</Value>
<Value name="43">
<Value>RequestingForProxyUserID</Value>
</Value>
<Value name="44">
<Value>RequestingGateway</Value>
</Value>
<Value name="45">
<Value>RequestingUser</Value>
</Value>
<Value name="46">
<Value>RequestingUserRoles</Value>
</Value>
<Value name="47">
<Value>Signature</Value>
</Value>
<Value name="48">
<Value>Snapshot</Value>
</Value>
<Value name="49">
<Value>SourceOID</Value>
</Value>
<Value name="50">
<Value>SubmissionEntryUUID</Value>
</Value>
<Value name="51">
<Value>SubmissionUniqueId</Value>
</Value>
<Value name="52">
<Value>Type</Value>
</Value>
<Value name="53">
<Value>IntendedRecipient</Value>
</Value>
<Value name="54">
<Value>SourceId</Value>
</Value>
<Value name="55">
<Value>SubmissionTime</Value>
</Value>
<Value name="56">
<Value>Submissions</Value>
</Value>
<Value name="57">
<Value>Folders</Value>
</Value>
<Value name="58">
<Value>ObjectRefs</Value>
</Value>
<Value name="59">
<Value>Associations</Value>
</Value>
<Value name="60">
<Value>Errors</Value>
</Value>
<Value name="61">
<Value>GenerateProvideAndRegisterOnly</Value>
</Value>
<Value name="62">
<Value>Language</Value>
</Value>
<Value name="63">
<Value>SAMLData</Value>
</Value>
<Value name="64">
<Value>DirectFrom</Value>
</Value>
<Value name="65">
<Value>DirectTo</Value>
</Value>
<Value name="66">
<Value>SubmissionSlots</Value>
</Value>
</Data>
<DefaultData>ProvideAndRegisterRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
