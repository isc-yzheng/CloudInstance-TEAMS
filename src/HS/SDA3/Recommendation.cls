/// Recommendation appears in the SDA as a list property<br>
/// (RecommendationsProvided) of HS.SDA3.Encounter.
Class HS.SDA3.Recommendation Extends HS.SDA3.DataType
{

Property Extension As HS.Local.SDA3.RecommendationExtension;

/// The text of the recommendation
Property NoteText As %String(MAXLEN = "");

/// The providers to whom the recommendation is forwarded
Property RecipientPersons As list Of HS.SDA3.CodeTableDetail.CareProvider;

/// The organizations to whom the recommendation is forwarded
Property RecipientOrganizations As list Of HS.SDA3.CodeTableDetail.HealthCareFacility;

Storage Default
{
<Data name="RecommendationState">
<Subscript>"Recommendation"</Subscript>
<Value name="1">
<Value>NoteText</Value>
</Value>
<Value name="2">
<Value>RecipientPerson</Value>
</Value>
<Value name="3">
<Value>RecipientOrganization</Value>
</Value>
<Value name="4">
<Value>RecipientPersons</Value>
</Value>
<Value name="5">
<Value>RecipientOrganizations</Value>
</Value>
<Value name="6">
<Value>Extension</Value>
</Value>
</Data>
<State>RecommendationState</State>
<Type>%Storage.Serial</Type>
}

}
