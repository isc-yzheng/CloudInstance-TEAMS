Class HS.SDA3.Intervention Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.InterventionExtension;

/// Textual description of an intervention
Property Description As %String;

/// Intervention status. Used to represent planned (active) vs completed.
Property Status As %String;

/// Performers for the intervention
Property Performers As list Of HS.SDA3.DocumentProvider;

/// ExternalId of Goal that is addressed by this intervention
Property GoalIds As list Of %String;

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
<Value>Performers</Value>
</Value>
<Value name="17">
<Value>GoalIds</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
