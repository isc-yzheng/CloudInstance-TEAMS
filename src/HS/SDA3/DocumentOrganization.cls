Class HS.SDA3.DocumentOrganization Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.DocumentOrganizationExtension;

/// VIEWERLIB: Not stored
Property Organization As HS.SDA3.CodeTableDetail.Organization;

/// VIEWERLIB: Not stored
Property Role As HS.SDA3.CodeTableDetail.DocumentOrganizationRole;

/// Not used.
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// Not used.
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// Not used.
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

/// Not used.
Property ExternalId As %String(MAXLEN = 220);

/// Not used.
Property EncounterNumber As %String(MAXLEN = 220);

Storage Default
{
<Data name="DocumentOrganizationState">
<Subscript>"DocumentOrganization"</Subscript>
<Value name="1">
<Value>Extension</Value>
</Value>
<Value name="2">
<Value>Organization</Value>
</Value>
<Value name="3">
<Value>Role</Value>
</Value>
<Value name="4">
<Value>ActionCode</Value>
</Value>
<Value name="5">
<Value>ActionScope</Value>
</Value>
<Value name="6">
<Value>EnteredBy</Value>
</Value>
<Value name="7">
<Value>EnteredAt</Value>
</Value>
<Value name="8">
<Value>EnteredOn</Value>
</Value>
<Value name="9">
<Value>UpdatedOn</Value>
</Value>
<Value name="10">
<Value>FromTime</Value>
</Value>
<Value name="11">
<Value>ToTime</Value>
</Value>
<Value name="12">
<Value>ExternalId</Value>
</Value>
<Value name="13">
<Value>EncounterNumber</Value>
</Value>
<Value name="14">
<Value>CustomPairs</Value>
</Value>
</Data>
<State>DocumentOrganizationState</State>
<Type>%Storage.Serial</Type>
}

}
