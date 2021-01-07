Class HS.Types.IHE.XDSb.Submission Extends (%SerialObject, %XML.Adaptor, HS.Util.CopyFrom) [ Inheritance = right ]
{

/// If XMLIGNORENULL is set = "inputonly", then both missing tags in the XML and empty
/// strings are input as "".  Output of "" and $c(0) are for XMLIGNORENULL = 0:
/// $c(0) is output as an empty tag (i.e. &lt;tag&gt;&lt;/tag&gt;) and "" is output as no tag.<br><br>
Parameter XMLIGNORENULL As STRING [ Constraint = ",0,1,inputonly,runtime", Flags = ENUM ] = "inputonly";

/// Property DocumentSlots As list Of HS.IHE.XDSb.Types.Slot;
Property Slots As list Of HS.Types.IHE.XDSb.Slot(XMLNAME = "Slot", XMLPROJECTION = "ELEMENT");

/// Authors of this submission set
Property Author As list Of HS.Types.IHE.XDSb.Author(XMLPROJECTION = "ELEMENT");

/// Optional list of recipient
Property IntendedRecipient As list Of HS.Types.IHE.XDSb.SlotValue(XMLITEMNAME = "Value");

Property SourceId As %String(MAXLEN = "");

/// Patient ID
/// Property PatientId As %String(CONTENT = "ESCAPE", MAXLEN = "");
/// Source OID
/// When submission was generated, UTC, HL7v2 format
Property SubmissionTime As %String(MAXLEN = "") [ InitialExpression = {$TR($zdt($h,8),": ")} ];

// Property Title As %String(MAXLEN = "");

// Property SubmissionSlots As list Of HS.IHE.XDSb.Types.Slot;

/// Free text title
/// OID assigned by the source
/// Property UniqueId As %String(MAXLEN = "");
/// Collection of slots from submission set
Property Classifications As list Of HS.Types.IHE.XDSb.SerialClassification(XMLNAME = "Classification", XMLPROJECTION = "ELEMENT");

Property ExternalIdentifiers As list Of HS.Types.IHE.XDSb.SerialExternalIdentifierFull(XMLNAME = "ExternalIdentifier", XMLPROJECTION = "ELEMENT");

Property ContentTypeCode As HS.Types.IHE.XDSb.SerialClassification;

Property PatientIdentifier As HS.Types.IHE.XDSb.SerialExternalIdentifier;

Property SourceIdentifier As HS.Types.IHE.XDSb.SerialExternalIdentifier;

Property UniqueIdentifier As HS.Types.IHE.XDSb.SerialExternalIdentifier;

Property Node As HS.Types.IHE.XDSb.SerialClassification;

// Property SubmissionTime As %String;

/// Type of registry package value is type
/// For submission sets
Property EntryUUID As %String(MAXLEN = 256, XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

Property LogicalUUID As %String(MAXLEN = 256, XMLNAME = "lid", XMLPROJECTION = "ATTRIBUTE");

// Property Version As %Integer;

Property AvailabilityStatus As HS.Types.IHE.Status(XMLNAME = "AvailabilityStatus", XMLPROJECTION = "Element") [ InitialExpression = "Submitted" ];

Property Names As list Of HS.Types.IHE.XDSb.ValueType(XMLNAME = "Name", XMLPROJECTION = "ELEMENT");

Property Descriptions As list Of HS.Types.IHE.XDSb.ValueType(XMLNAME = "Description", XMLPROJECTION = "ELEMENT");

Method %OnNew() As %Status [ Private, ServerOnly = 1 ]
{
	Set tEntryUUID=##class(HS.Util.XSLTHelper).createUUID()
	Set ..UniqueIdentifier.Value=##class(HS.Util.XSLTHelper).uuid2oid(tEntryUUID)
	Set ..UniqueIdentifier.IID="urn:uuid:"_##class(HS.Util.XSLTHelper).createUUID()
	Set ..EntryUUID="urn:uuid:"_tEntryUUID
	Quit $$$OK
}

Storage Default
{
<Data name="SubmissionState">
<Value name="1">
<Value>Slots</Value>
</Value>
<Value name="2">
<Value>Author</Value>
</Value>
<Value name="3">
<Value>IntendedRecipient</Value>
</Value>
<Value name="4">
<Value>SubmissionTime</Value>
</Value>
<Value name="5">
<Value>Classifications</Value>
</Value>
<Value name="6">
<Value>ContentTypeCode</Value>
</Value>
<Value name="7">
<Value>PatientIdentifier</Value>
</Value>
<Value name="8">
<Value>SourceIdentifier</Value>
</Value>
<Value name="9">
<Value>UniqueIdentifier</Value>
</Value>
<Value name="10">
<Value>EntryUUID</Value>
</Value>
<Value name="11">
<Value>LogicalUUID</Value>
</Value>
<Value name="12">
<Value>AvailabilityStatus</Value>
</Value>
<Value name="13">
<Value>Title</Value>
</Value>
<Value name="14">
<Value>Comments</Value>
</Value>
<Value name="15">
<Value>SourceId</Value>
</Value>
<Value name="16">
<Value>ExternalIdentifiers</Value>
</Value>
<Value name="17">
<Value>Node</Value>
</Value>
<Value name="18">
<Value>Names</Value>
</Value>
<Value name="19">
<Value>Descriptions</Value>
</Value>
</Data>
<State>SubmissionState</State>
<StreamLocation>^HS.Types.IHE.XDSb.SubmissionS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
