/// Used for queries of secondary MPIs - contains the results of the primary response
Class HS.Message.PatientSecondarySearchRequest Extends HS.Util.EnsRequest
{

Parameter RESPONSECLASSNAME As %String = "HS.Message.PatientSearchResponse";

Property PrimaryRequest As HS.Message.PatientSearchRequest;

Property PrimaryResponse As HS.Message.PatientSearchResponse;

Storage Default
{
<Data name="PatientSecondarySearchRequestDefaultData">
<Subscript>"PatientSecondarySearchRequest"</Subscript>
<Value name="1">
<Value>PrimaryResponse</Value>
</Value>
<Value name="2">
<Value>PrimaryRequest</Value>
</Value>
</Data>
<DefaultData>PatientSecondarySearchRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
