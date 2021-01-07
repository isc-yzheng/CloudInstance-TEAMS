/// The logic defining how the <property>DocumentURL</property>,
/// <property>NoteText</property>, <property>FileType</property>, and
/// <property>Stream</property> properties are parsed from an HL7 MDM^T02
/// message in HL7ToSDA3 is as follows:
/// <ol>
/// <li>If OBX-2 (Value Type) of the first OBX is "RP" (for "Reference
///     Pointer"), then OBX-5.1 (Observation Value.Pointer) of that segment is
///     parsed as <property>DocumentURL</property>. If this segment is followed
///     by anything other than an OBX (ie NTE) the remaining segments will not
///     be parsed. If this segment is followed by additional OBXs (possibly
///     with NTEs mixed in), then all the remaining OBX-5 and NTE-3 values will
///     be parsed as <property>NoteText</property>, with each segment being
///     parsed as a new line.</li>
/// <li>Else, if OBX-2 of the first OBX is "ED" (for "Encapsulated
///     Data") then OBX-5.3 (Observation Value.Data Subtype) of that segment
///     will be parsed as <property>FileType</property>. All OBX-5.5 (.Data)
///     and NTE-3 values will be parsed (with each segment being parsed as a
///     new line) as the <property>Stream</property> property, after being
///     Base64-encoded if they are not already. HL7ToSDA3 will look at OBX-5.4
///     (.Encoding) of the first OBX to determine if the data is already
///     Base64-encoded. (OBX-5.4="BASE64" (case-insensitive) -> data is already
///     encoded; else -> data is not encoded)</li>
/// <li>Else, if the first characters of the first OBX-5.1 are "{\rtf",
///     <property>FileType</property> is set to "RTF", and all of the OBX-5 and NTE-3 values are
///     parsed (with each segment being a new line) as the <property>Stream</property> property,
///     after being Base64-encoded.</li>
/// <li>Else each OBX-5 and NTE-3 value is parsed as plaintext (with each
///     segment being parsed as a new line) into the <property>NoteText</property> property.</li>
/// </ol>
Class HS.SDA3.Document Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.DocumentExtension;

/// This contains the date of the activity that the document is reporting.<br>
/// For example, with a Discharge Summary this should be the date/time of the<br>
/// discharge, while TranscriptionTime would be the date/time the summary was<br>
/// put together, and AuthorizationTime the date/time when the doctor signed<br>
/// the summary.<br><br>
/// Streamlet cache:<br>
/// If null, this will be defaulted to TranscriptionTime, then<br>
/// AuthorizationTime, then EnteredOn, and finally to the current time if all<br>
/// of those are null.<br><br>
/// HL7:  TXA-4.1 : ActivityDateTime.Time<br>
/// VIEWERLIB: User.HS.MRNursingNotes(NOTActivityDate) + User.HS.MRNursingNotes(NOTActivityTime)<br>
Property DocumentTime As HS.SDA3.TimeStamp;

/// This property is used when the Note is either plain or marked up text e.g<br>
/// TX, FT, HTML.  CRLF-delimited.<br>
/// Length subject to the total streamlet size limit - 3,000,000<br><br>
/// HL7ToSDA3:<br>
/// See class annotation.<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if the Document does not<br>
/// have a DocumentURL, NoteText, or Stream and FileType, then an error will be<br>
/// logged and the Streamlet will not be saved.<br><br>
/// HL7:  OBX-5 : ObservationValue<br>
/// HL7:  NTE-3 : Comment<br>
/// VIEWERLIB: User.HS.MRNursingNotes(NOTNotes)<br>
Property NoteText As %String(MAXLEN = "");

/// HL7ToSDA3:<br>
/// TXA-2 is parsed to DocumentType.Code. If TXA-2 is "DS", Description is<br>
/// parsed as "DischargeSummary" so that the Document will appear on the<br>
/// Discharge Summaries chart in the default Clinical Viewer layout. Otherwise<br>
/// HL7ToSDA3 does not set the Description.<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if the Document has a DocumentType, and <br>
/// DocumentType.Code is not an OID, set InfoSubType to DocumentType.Code, converted to <br>
/// uppercase.  If DocumentType.Code is an OID and DocumentType.Description is present, <br>
/// set InfoSubType to DocumentType.Description, converted to uppercase.<br><br>
/// HL7:  TXA-2 : DocumentType<br>
/// SDATableName=DocumentType, ViewerClass=User.HS.MRCClinNotesType<br>
/// VIEWERLIB: User.HS.MRNursingNotes(NOTClinNotesTypeDR)
Property DocumentType As HS.SDA3.CodeTableDetail.DocumentType;

/// The name of the clinician who performed the activity and originated the<br>
/// Note. This may not be the same as the EnteredBy if the Note was<br>
/// transcribed.<br><br>
/// HL7ToSDA3:<br>
/// Though TXA-5 is a repeating field, HL7ToSDA3 will only parse the first instance.<br><br>
/// HL7:  TXA-5 : PrimaryActivityProviderCodeName<br>
/// SDATableName=CareProvider, ViewerClass=User.HS.CTCareProv<br>
/// VIEWERLIB: User.HS.MRNursingNotes(NOTNurseIdDR)<br><br>
/// .Code<br>
/// HL7:  TXA-5.1 : IDNumber<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPCode)<br>
/// .Description<br>
/// The name is formatted as "[Family], [Given]" to make the Description.<br>
/// HL7:  TXA-5.2.1 : PrimaryActivityProviderCodeName.FamilyName.Surname<br>
/// HL7:  TXA-5.3 : PrimaryActivityProviderCodeName.GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  TXA-5.9 : PrimaryActivityProviderCodeName.AssigningAuthority<br>
/// VIEWERLIB: Not stored<br>
/// .Name.FamilyName<br>
/// HL7:  TXA-5.2.1 : PrimaryActivityProviderCodeName.FamilyName.Surname<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPSurname)<br>
/// .Name.GivenName<br>
/// HL7:  TXA-5.3 : PrimaryActivityProviderCodeName.GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPFirstName)<br>
/// .Name.MiddleName<br>
/// HL7:  TXA-5.4 : PrimaryActivityProviderCodeName.SecondandFurtherGivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPOtherName)<br>
/// .Name.NamePrefix<br>
/// HL7:  TXA-5.6 : PrimaryActivityProviderCodeName.Prefix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTitle)<br>
/// .Name.NameSuffix<br>
/// HL7:  TXA-5.5 : PrimaryActivityProviderCodeName.Suffix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTextTwo)<br>
/// .Name.ProfessionalSuffix<br>
/// HL7:  TXA-5.21 : PrimaryActivityProviderCodeName.ProfessionalSuffix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTextThree)<br>
Property Clinician As HS.SDA3.CodeTableDetail.CareProvider;

/// The time that the document was transcribed<br><br>
/// HL7:  TXA-7.1 : TranscriptionDateTime.Time<br>
/// VIEWERLIB: User.HS.MRNursingNotes(NOTCreateDate) + User.HS.MRNursingNotes(NOTCreateTime)
Property TranscriptionTime As HS.SDA3.TimeStamp;

/// The time that the document was authorised.<br><br>
/// HL7:  TXA-22.15 : AuthenticationPersonTimeStamp.DateTimeActionPerformed<br>
/// VIEWERLIB: User.HS.MRNursingNotes(NOTDateAuth) + User.HS.MRNursingNotes(NOTTimeAuth)
Property AuthorizationTime As HS.SDA3.TimeStamp;

/// The name of the document.<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if DocumentName is null,<br>
/// it will be defaulted to DocumentURL, then to FileType.<br><br>
/// Viewer cache:<br>
/// If not null, the DocumentName is what will appear in the Clinical Viewer<br>
/// in the Document column, that the user may click to see the document.<br>
/// Otherwise, the first few characters of the NoteText will appear in this<br>
/// column.<br><br>
/// HL7:  TXA-16 : UniqueDocumentFileName<br>
/// VIEWERLIB: User.HS.MRNursingNotes(NOTDocumentName)<br>
Property DocumentName As %String(MAXLEN = 220);

/// The type of data e.g PDF, DOC, RTF, TXT<br><br>
/// HL7ToSDA3:<br>
/// See class annotation.<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if the Document does not<br>
/// have a DocumentURL, NoteText, or Stream and FileType, then an error will be<br>
/// logged and the streamlet will not be saved. Also, if the DocumentName is<br>
/// null, it will be defaulted to the DocumentURL, then to the FileType.<br><br>
/// Viewer cache:<br>
/// The list of FileTypes that the Clinical Viewer supports for Documents is<br>
/// contained in the ValidTypes parameter of the websys.Document class.<br><br>
/// HL7:  OBX-5.3 : ObservationValue.EDDataSubType<br>
/// VIEWERLIB:  User.HS.MRNursingNotes(NOTDocumentDR)->websys.Document(docType)<br>
Property FileType As %String;

/// This property is used when the Note is binary data, e.g DOC, PDF, JPG<br><br>
/// Length subject to the total streamlet size limit - 3,000,000<br><br>
/// Note that because of the type of this property (%GlobalBinaryStream),<br>
/// character data written to it must be single-width, ie, no double-wide<br>
/// Unicode characters. On export, the content will be Base64 encoded, and on<br>
/// import, Base64 decoded.<br><br>
/// HL7ToSDA3:<br>
/// See class annotation.<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if the Document does not<br>
/// have a DocumentURL, NoteText, or Stream and FileType, then an error will be<br>
/// logged and the Streamlet will not be saved.<br><br>
/// Viewer cache:<br>
/// The list of FileTypes that the Clinical Viewer supports for Documents is<br>
/// contained in the ValidTypes parameter of the websys.Document class.<br>
/// Note that the DataId property of websys.Document is not a designative<br>
/// reference (so the COS syntax document.DataId.docData will not work) but<br>
/// rather a string field containing the ID of the linked websys.Documentxxx<br>
/// (where "xxx" is the FileType).<br>
/// If the value of the Configuration Registry key<br>
/// "\Viewer\SDA3DocumentStreamEncoded" is "1", then the content of Stream will<br>
/// be converted from UTF-8 output format (ie, $ZCVT(,"I","UTF8")) before being<br>
/// inserted into the Viewer Cache. This is useful in cases where the original<br>
/// document data contained double-wide Unicode characters that had to be<br>
/// converted to UTF-8 output format before being written to the stream, since<br>
/// it cannot contain double-wide characters.<br><br>
/// HL7:  OBX-5.5 : ObservationValue.EDData<br>
/// HL7:  NTE-3 : Comments<br>
/// VIEWERLIB: User.HS.MRNursingNotes(NOTDocumentDR)->websys.Document(DataId)->websys.Documentxxx(docData)<br>
Property Stream As %GlobalBinaryStream;

/// The full URL where the document can be accessed<br><br>
/// HL7ToSDA3:<br>
/// See class annotation.<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if the Document does not<br>
/// have a DocumentURL, NoteText, or Stream and FileType, then an error will be<br>
/// logged and the streamlet will not be saved. Also, if the DocumentName is<br>
/// null, it will be defaulted to the DocumentURL, then to the FileType.<br><br>
/// HL7:  OBX-5.1 : ObservationValue.Pointer<br>
/// VIEWERLIB: User.HS.MRNursingNotes(NOTDocumentURL)<br>
Property DocumentURL As %String(MAXLEN = 220);

/// Used as an external reference ID.<br><br>
/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the Streamlet class, if DocumentNumber is<br>
/// null, it will be defaulted to the ExternalId.<br><br>
/// HL7:  TXA-12.1 : UniqueDocumentNumber.EntityIdentifier<br>
/// VIEWERLIB: User.HS.MRNursingNotes(NOTExternalRef)<br>
Property DocumentNumber As %String(MAXLEN = 220);

/// List of facilities that have contributed to this document<br><br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.MRNursingNotes(ChildMRNursingNotesHosp)->User.HS.MRNursingNotesHosp(NOTHospitalDR)
Property Facilities As list Of HS.SDA3.CodeTableDetail.Organization;

/// HL7ToSDA3:<br>
/// TXA-19 is parsed as the Status Code. HL7ToSDA3 does not set the<br>
/// Description.<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if the Document has no<br>
/// Status, one will be defaulted with Code="AV" and Description="Available for<br>
/// patient care".<br><br>
/// HL7:  TXA-19 : DocumentAvailabilityStatus<br>
/// SDATableName=DocumentStatus, ViewerClass=User.HS.MRCNursingNotesStatus<br>
/// VIEWERLIB: User.HS.MRNursingNotes(NOTStatusDR)<br>
Property Status As HS.SDA3.CodeTableDetail.DocumentStatus;

/// This is the status of the creation of the Note, such as Incomplete, In Progress,<br>
/// or Authenticated.
/// HL7ToSDA3:<br>
/// TXA-17 is parsed as the Document Completion Status.  HL7ToSDA3 does not set the<br>
/// Description.<br><br>
/// HL7:  TXA-17 : DocumentCompletionStatus<br>
/// SDATableName=DocumentCompletionStatus<br>
/// VIEWERLIB: Not stored
Property DocumentCompletionStatus As HS.SDA3.CodeTableDetail.DocumentCompletionStatus;

/// The time that any action or treatment was instigated.<br><br>
/// VIEWERLIB: User.HS.MRNursingNotes(NOTActionTakenDate) + User.HS.MRNursingNotes(NOTActionTakenTime)
Property ActionTime As HS.SDA3.TimeStamp;

/// D = Delete<br>
/// I = Inactivate All (set Status.Code="UN", Description="Unavailable for patient care")<br>
/// C = Clear All<br>
/// Any other value = Add or Update<br>
/// See the annotation on the superclass property for more information on how<br>
/// ActionCode is used.<br><br>
/// HL7ToSDA3:<br>
/// Two double quotes ("") in TXA-1 is parsed as ActionCode="I", and four<br>
/// double quotes ("""") as ActionCode="C". In either case no further parsing<br>
/// is done on the TXA segment. If the HL7 message is an MDM_T11 (Document<br>
/// cancel notification), ActionCode will be parsed as "D".<br><br>
/// HL7:  TXA-1 : SetIDTXA<br>
/// VIEWERLIB: Not stored
Property ActionCode As %String;

/// This is the person who entered the Note, perhaps from a dictation.<br><br>
/// HL7ToSDA3:<br>
/// Though TXA-9 is a repeating field, HL7ToSDA3 will only use the first<br>
/// instance.<br><br>
/// HL7:  TXA-9 : OriginatorCodeName<br>
/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: User.HS.MRNursingNotes(NOTUserDR)<br><br>
/// .Code<br>
/// HL7:  TXA-9.1 : OriginatorCodeName.IDNumber<br>
/// VIEWERLIB: User.HS.SSUser(SSUSRInitials)<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// The name is formatted as "[Family], [Given]" to make the Description.<br>
/// HL7:  TXA-9.2.1 : OriginatorCodeName.FamilyName.Surname<br>
/// HL7:  TXA-9.3 : GivenName<br>
/// VIEWERLIB: User.HS.SSUser(SSUSRName)<br>
/// .SDACodingStandard<br>
/// HL7:  TXA-9.9 : OriginatorCodeName.AssigningAuthority<br>
/// VIEWERLIB: Not stored<br>
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// HL7ToSDA3:<br>
/// MSH-4.1 is parsed as the EnteredAt Code. HL7ToSDA3 does not set the<br>
/// Description.<br><br>
/// HL7:  MSH-4.1 : SendingFacility.NamespaceID<br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.MRNursingNotes(NOTHospitalDR)<br>
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if EnteredOn is null, it<br>
/// will be defaulted to the current date/time.<br><br>
/// VIEWERLIB: User.HS.MRNursingNotes(NOTDate) + User.HS.MRNursingNotes(NOTTime)
Property EnteredOn As HS.SDA3.TimeStamp;

/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the Streamlet class, if DocumentNumber is<br>
/// null, it will be defaulted to ExternalId.<br><br>
/// VIEWERLIB: User.HS.MRNursingNotes(NOTExternalId)
Property ExternalId As %String(MAXLEN = 220);

/// Not used.
Property ActionScope As %String;

Storage Default
{
<Data name="SuperClassState">
<Subscript>"SuperClass"</Subscript>
<Value name="1">
<Value>ActionCode</Value>
</Value>
<Value name="2">
<Value>ActionScope</Value>
</Value>
<Value name="3">
<Value>EnteredBy</Value>
</Value>
<Value name="4">
<Value>EnteredAt</Value>
</Value>
<Value name="5">
<Value>EnteredOn</Value>
</Value>
<Value name="6">
<Value>ExternalId</Value>
</Value>
<Value name="7">
<Value>EncounterNumber</Value>
</Value>
<Value name="8">
<Value>DocumentTime</Value>
</Value>
<Value name="9">
<Value>NoteText</Value>
</Value>
<Value name="10">
<Value>DocumentType</Value>
</Value>
<Value name="11">
<Value>Clinician</Value>
</Value>
<Value name="12">
<Value>TranscriptionTime</Value>
</Value>
<Value name="13">
<Value>AuthorizationTime</Value>
</Value>
<Value name="14">
<Value>DocumentName</Value>
</Value>
<Value name="15">
<Value>FileType</Value>
</Value>
<Value name="16">
<Value>Stream</Value>
</Value>
<Value name="17">
<Value>DocumentURL</Value>
</Value>
<Value name="18">
<Value>DocumentNumber</Value>
</Value>
<Value name="19">
<Value>Facilities</Value>
</Value>
<Value name="20">
<Value>Status</Value>
</Value>
<Value name="21">
<Value>ActionTime</Value>
</Value>
<Value name="22">
<Value>FromTime</Value>
</Value>
<Value name="23">
<Value>ToTime</Value>
</Value>
<Value name="24">
<Value>Deleted</Value>
</Value>
<Value name="25">
<Value>UpdatedOn</Value>
</Value>
<Value name="26">
<Value>CustomPairs</Value>
</Value>
<Value name="27">
<Value>Extension</Value>
</Value>
<Value name="28">
<Value>DocumentCompletionStatus</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
