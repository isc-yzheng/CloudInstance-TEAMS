Class HS.SDA3.HealthConcern Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.HealthConcernExtension;

/// Textual description of a health concern.
Property Description As %String(MAXLEN = "");

/// Health concern status (coded in CCDA).
Property Status As HS.SDA3.CodeTableDetail.HealthConcernStatus;

/// Priority of health concern
Property Priority As HS.SDA3.CodeTableDetail.Priority;

/// Who is expressing this concern. May be Patient, Practitioner, Related Person or Organization.
Property Authors As list Of HS.SDA3.DocumentProvider;

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
<Value>Description</Value>
</Value>
<Value name="15">
<Value>Status</Value>
</Value>
<Value name="16">
<Value>Priority</Value>
</Value>
<Value name="17">
<Value>Authors</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
