/// An outcome of a care plan activity
Class HS.SDA3.Outcome Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.OutcomeExtension;

/// Textual description of an outcome observation	
Property Description As %String(MAXLEN = "");

/// The coded form of this outcome, including <br><br>
/// -Standard medical code for this outcome, if applicable.<br>
/// - If applicable, desired outcome expressed in terms of unit, amount etc. An observation record may be used in capturing this info. (e.g., HbA1C "< 6.5") or a range ("5 - 10"), behaves like ResultNormalRange field of LabResultItem
/// - Unit for desired outcome<br>
Property Observation As HS.SDA3.Observation;

/// ExternalId of Intervention which this is an outcome of.
Property InterventionId As %String;

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
<Value>Observation</Value>
</Value>
<Value name="16">
<Value>InterventionId</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
