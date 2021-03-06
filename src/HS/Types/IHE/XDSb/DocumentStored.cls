Class HS.Types.IHE.XDSb.DocumentStored Extends (%SerialObject, %XML.Adaptor, HS.Util.CopyFrom)
{

Parameter XMLIGNORENULL = "INPUTONLY";

/// known as lid in the provide and register / register
Property LogicalUUID As %String(MAXLEN = 256, XMLNAME = "lid", XMLPROJECTION = "ATTRIBUTE");

/// known as id in the provide and register / register
Property EntryUUID As %String(MAXLEN = 256, XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

/// 1 - online, 0 - Offline 
Property Availability As HS.Types.IHE.XDSb.OnlineStatus;

/// Document status, generated by the registry Approved;Deprecated;Submitted
Property AvailabilityStatus As HS.Types.IHE.Status;

// Property ClassCode As HS.IHE.XDSb.Types.CodedValue;

/// The kind of document
Property ClassCode As HS.Types.IHE.XDSb.SerialClassification;

Property Classifications As list Of HS.Types.IHE.XDSb.SerialClassification(XMLNAME = "Classification", XMLPROJECTION = "ELEMENT");

/// previously known as comments
Property Descriptions As list Of HS.Types.IHE.XDSb.ValueType(XMLNAME = "Description", XMLPROJECTION = "ELEMENT");

/// Time the author created the document
Property CreationTime As %String(MAXLEN = "");

Property DocumentUniqueIdentifier As HS.Types.IHE.XDSb.SerialExternalIdentifier;

/// Document format
/// Property FormatCode As HS.IHE.XDSb.Types.CodedValue;
Property FormatCode As HS.Types.IHE.XDSb.SerialClassification;

/// Hash key of the document, computed by the repository
Property Hash As %String(MAXLEN = "");

/// Type of organizational setting of the encounter during which the document act occurred
/// Property HealthcareFacilityTypeCode As HS.IHE.XDSb.Types.CodedValue;
Property HealthCareFacilityTypeCode As HS.Types.IHE.XDSb.SerialClassification(XMLPROJECTION = "ELEMENT");

/// The language of character data in the document
Property LanguageCode As %String(MAXLEN = "");

/// Who has legally authenticated the document (optional)
Property LegalAuthenticator As %String(MAXLEN = "");

/// MIME type
Property MimeType As %String(MAXLEN = "");

/// ObjectType
Property ObjectType As %String(DISPLAYLIST = ",urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1,urn:uuid:34268e47-fdf5-41a6-ba33-82133c465248", VALUELIST = ",Stable,OnDemand", XMLLISTPARAMETER = "DISPLAYLIST", XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ InitialExpression = "Stable" ];

Property PatientIdentifier As HS.Types.IHE.XDSb.SerialExternalIdentifier;

/// The clinical specialty where the act that resulted in the document was performed
/// Property PracticeSettingCode As HS.IHE.XDSb.Types.CodedValue;
Property PracticeSettingCode As HS.Types.IHE.XDSb.SerialClassification;

/// Repository OID of where the document is stored
Property RepositoryUniqueId As %String(MAXLEN = "");

/// Start time, UTC, HL7v2 format
Property ServiceStartTime As %String(MAXLEN = "");

/// Stop time, UTC, HL7v2 format
Property ServiceStopTime As %String(MAXLEN = "");

/// Document size, computed by repository
Property Size As %String;

/// Property DocumentSlots As list Of HS.IHE.XDSb.Types.Slot;
Property Slots As list Of HS.Types.IHE.XDSb.Slot(XMLNAME = "Slot", XMLPROJECTION = "ELEMENT");

/// Patient MRN
Property SourcePatientId As %String(CONTENT = "ESCAPE", MAXLEN = "");

/// Patient demographics
Property SourcePatientInfo As list Of HS.Types.IHE.XDSb.SlotValue(XMLITEMNAME = "Value");

/// SourceIdentifier is from the submission set, carried forward to the document
Property SourceIdentifier As HS.Types.IHE.XDSb.SerialExternalIdentifier;

Property SubmissionTime As %String;

/// Document Name (previously title)
Property Names As list Of HS.Types.IHE.XDSb.ValueType(XMLNAME = "Name", XMLPROJECTION = "ELEMENT");

/// The precise kind of document
/// Property TypeCode As HS.IHE.XDSb.Types.CodedValue;
Property TypeCode As HS.Types.IHE.XDSb.SerialClassification;

/// URI used for retrieval, computed by repository
/// Used to maintain the XOP href when imported
Property Version As %String;

Property ExternalIdentifiers As list Of HS.Types.IHE.XDSb.SerialExternalIdentifierFull(XMLNAME = "ExternalIdentifier", XMLPROJECTION = "ELEMENT");

Storage Default
{
<Data name="DocumentStoredState">
<Value name="1">
<Value>LogicalUUID</Value>
</Value>
<Value name="2">
<Value>EntryUUID</Value>
</Value>
<Value name="3">
<Value>Availability</Value>
</Value>
<Value name="4">
<Value>AvailabilityStatus</Value>
</Value>
<Value name="5">
<Value>ClassCode</Value>
</Value>
<Value name="6">
<Value>Classifications</Value>
</Value>
<Value name="7">
<Value>Comments</Value>
</Value>
<Value name="8">
<Value>CreationTime</Value>
</Value>
<Value name="9">
<Value>DocumentUniqueIdentifier</Value>
</Value>
<Value name="10">
<Value>FormatCode</Value>
</Value>
<Value name="11">
<Value>Hash</Value>
</Value>
<Value name="12">
<Value>HealthCareFacilityTypeCode</Value>
</Value>
<Value name="13">
<Value>LanguageCode</Value>
</Value>
<Value name="14">
<Value>LegalAuthenticator</Value>
</Value>
<Value name="15">
<Value>MimeType</Value>
</Value>
<Value name="16">
<Value>ObjectType</Value>
</Value>
<Value name="17">
<Value>PatientIdentifier</Value>
</Value>
<Value name="18">
<Value>PracticeSettingCode</Value>
</Value>
<Value name="19">
<Value>RepositoryUniqueId</Value>
</Value>
<Value name="20">
<Value>ServiceStartTime</Value>
</Value>
<Value name="21">
<Value>ServiceStopTime</Value>
</Value>
<Value name="22">
<Value>Size</Value>
</Value>
<Value name="23">
<Value>Slots</Value>
</Value>
<Value name="24">
<Value>SourcePatientId</Value>
</Value>
<Value name="25">
<Value>SourcePatientInfo</Value>
</Value>
<Value name="26">
<Value>SourceIdentifier</Value>
</Value>
<Value name="27">
<Value>SubmissionTime</Value>
</Value>
<Value name="28">
<Value>Title</Value>
</Value>
<Value name="29">
<Value>TypeCode</Value>
</Value>
<Value name="30">
<Value>Version</Value>
</Value>
<Value name="31">
<Value>ExternalIdentifiers</Value>
</Value>
<Value name="32">
<Value>Descriptions</Value>
</Value>
<Value name="33">
<Value>Names</Value>
</Value>
</Data>
<State>DocumentStoredState</State>
<StreamLocation>^HS.Types.IH3C1E.DocumentStoredS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
