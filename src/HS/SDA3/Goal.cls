Class HS.SDA3.Goal Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.GoalExtension;

/// Textual description of a goal.
Property Description As %String(MAXLEN = "");

/// The aim of this goal in coded form, including:<br>
/// - Standard medical code for this goal, if applicable.e.g., SNOMED-CT, NIC, NOC, NANDA<br>
/// - If applicable, desired outcome expressed in terms of unit, amount etc. An observation record may be used in capturing this info. (e.g., HbA1C "< 6.5") or a range ("5 - 10"), behaves like ResultNormalRange field of LabResultItem<br>
/// - Unit for desired outcome
Property Target As HS.SDA3.Observation;

/// TargetCode is only used for streamlet matching.
/// Any values set here will be overwritten with Target.ObservationCode by HS.SDA3.Streamlet.Goal OnBeforeMatch.
Property TargetCode As HS.SDA3.CodeTableDetail.Observation [ Internal ];

/// Goal status (coded in CCDA as Progress towards Goal Observation)
Property Status As HS.SDA3.CodeTableDetail.GoalStatus;

/// Goal priority	
Property Priority As HS.SDA3.CodeTableDetail.Priority;

/// Authors of the goal
Property Authors As list Of HS.SDA3.DocumentProvider;

/// ExternalIds of health concerns that this goal addresses
Property HealthConcernIds As list Of %String;

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
<Value>Target</Value>
</Value>
<Value name="16">
<Value>Status</Value>
</Value>
<Value name="17">
<Value>Priority</Value>
</Value>
<Value name="18">
<Value>Authors</Value>
</Value>
<Value name="19">
<Value>TargetCode</Value>
</Value>
<Value name="20">
<Value>HealthConcernIds</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
