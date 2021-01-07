Class HS.SDA3.CarePlan Extends HS.SDA3.SuperClass
{

/// VIEWERLIB: Not stored
Property Extension As HS.Local.SDA3.CarePlanExtension;

/// VIEWERLIB: Not stored
Property Type As HS.SDA3.CodeTableDetail.CarePlanType;

/// VIEWERLIB: Not stored
Property SubType As HS.SDA3.CodeTableDetail.CarePlanSubType;

/// The list of individual care providers (along with roles and dates) associated with a care plan
/// VIEWERLIB: Not stored
Property Providers As list Of HS.SDA3.DocumentProvider;

/// The list of individual support contacts (along with roles and dates) associated with a care plan
/// VIEWERLIB: Not stored
Property SupportContacts As list Of HS.SDA3.SupportContact;

/// The authors of a care plan
/// VIEWERLIB: Not stored
Property Authors As list Of HS.SDA3.DocumentProvider;

/// The list of organizations (along with roles and dates) associated with a care plan
/// VIEWERLIB: Not stored
Property Organizations As list Of HS.SDA3.DocumentOrganization;

/// The published care plan set id, taken from CCDA /ClinicalDocument/SetId
/// VIEWERLIB: Not stored
Property SetId As %String;

/// The published care plan version, taken from the document metadata %VersionNumber
/// VIEWERLIB: Not stored
Property Version As %String;

/// Currently, possible values are: "A" - Active, "I" - Inactive
/// Derived from the document %IsActive property
/// VIEWERLIB: Not stored
Property Status As %String;

/// ExternalIds of Health Concerns in this care plan
Property HealthConcernIds As list Of %String;

/// ExternalIds of Goals in this care plan
Property GoalIds As list Of %String;

/// Interventions in this care plan
Property Interventions As list Of HS.SDA3.Intervention;

/// Outcomes in this care plan
Property Outcomes As list Of HS.SDA3.Outcome;

/// VIEWERLIB: Not stored
Property CreatedBy As HS.SDA3.CodeTableDetail.User;

/// VIEWERLIB: Not stored
Property CreatedTime As HS.SDA3.TimeStamp;

/// VIEWERLIB: Not stored
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// Not used.
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// VIEWERLIB: Not stored
Property EnteredOn As HS.SDA3.TimeStamp;

/// VIEWERLIB: Not stored
Property FromTime As HS.SDA3.TimeStamp;

/// VIEWERLIB: Not stored
Property ToTime As HS.SDA3.TimeStamp;

/// Not used.
Property ActionCode As %String;

/// Not used.
Property ActionScope As %String;

/// Not used.
Property UpdatedOn As HS.SDA3.TimeStamp;

/// Used for the care plan identifier
Property ExternalId As %String(MAXLEN = 220);

/// Not used.
Property EncounterNumber As %String(MAXLEN = 220);

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
<Value>FromTime</Value>
</Value>
<Value name="9">
<Value>ToTime</Value>
</Value>
<Value name="10">
<Value>Deleted</Value>
</Value>
<Value name="11">
<Value>UpdatedOn</Value>
</Value>
<Value name="12">
<Value>CustomPairs</Value>
</Value>
<Value name="13">
<Value>Extension</Value>
</Value>
<Value name="14">
<Value>Type</Value>
</Value>
<Value name="15">
<Value>SubType</Value>
</Value>
<Value name="16">
<Value>Providers</Value>
</Value>
<Value name="17">
<Value>Organizations</Value>
</Value>
<Value name="18">
<Value>Version</Value>
</Value>
<Value name="19">
<Value>Status</Value>
</Value>
<Value name="20">
<Value>CreatedBy</Value>
</Value>
<Value name="21">
<Value>CreatedTime</Value>
</Value>
<Value name="22">
<Value>SupportContacts</Value>
</Value>
<Value name="23">
<Value>Authors</Value>
</Value>
<Value name="24">
<Value>SetId</Value>
</Value>
<Value name="25">
<Value>HealthConcernIds</Value>
</Value>
<Value name="26">
<Value>GoalIds</Value>
</Value>
<Value name="27">
<Value>Interventions</Value>
</Value>
<Value name="28">
<Value>Outcomes</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
