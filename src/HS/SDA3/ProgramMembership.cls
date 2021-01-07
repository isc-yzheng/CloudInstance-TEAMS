/// This is used to collect data from the patient program memberships that are<br>
/// stored in the registry, and return them as SDA. This should only ever come<br>
/// from the HealthShare registry. It should not be submitted by a data<br>
/// provider.<br><br>
/// In the Viewer Cache, because questionnaire.QPROGRAMS requires an Encounter,<br>
/// it is linked to the patient's silent encounter, creating one if it does not<br>
/// yet exist.
Class HS.SDA3.ProgramMembership Extends HS.SDA3.SuperClass
{

/// VIEWERLIB: questionnaire.QPROGRAMS(QProgramName)
Property ProgramName As %String;

/// VIEWERLIB: questionnaire.QPROGRAMS(QProgramDescription)
Property ProgramDescription As %String(MAXLEN = 220);

Property ProgramID As %String;

Property Clinician As HS.SDA3.CodeTableDetail.CareProvider;

/// Effective time of the membership<br><br>
/// VIEWERLIB: Not stored
Property FromTime As HS.SDA3.TimeStamp;

/// Termination time of the membership<br><br>
/// VIEWERLIB: Not stored
Property ToTime As HS.SDA3.TimeStamp;

/// VIEWERLIB: questionnaire.QPROGRAMS(QUESUserDR)
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// VIEWERLIB: questionnaire.QPROGRAMS(QUESDate) + questionnaire.QPROGRAMS(QUESTime)
Property EnteredOn As HS.SDA3.TimeStamp;

/// Not used.
Property ActionScope As %String;

Property Active As %Boolean [ InitialExpression = 1 ];

ClassMethod GetStreamletClass(pType)
{
	// No extension available
	Quit "HS.SDA3.Streamlet.ProgramMembership"
}

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
<Value>ProgramName</Value>
</Value>
<Value name="13">
<Value>ProgramDescription</Value>
</Value>
<Value name="14">
<Value>CustomPairs</Value>
</Value>
<Value name="15">
<Value>Clinician</Value>
</Value>
<Value name="16">
<Value>ProgramID</Value>
</Value>
<Value name="17">
<Value>Active</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
