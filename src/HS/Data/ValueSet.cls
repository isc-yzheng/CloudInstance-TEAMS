/// *** THIS CLASS, ALONG WITH ALL OTHER QRDA FUNCTIONALITY INITIALLY INCLUDED IN<br>
/// *** HEALTHSHARE CORE 13, IS DEPRECATED AS OF HEALTH CONNECT / HEALTHSHARE 2018.1.
Class HS.Data.ValueSet Extends (%Persistent, %XML.Adaptor)
{

Property ValueSetName As %String(MAXLEN = 220);

Property ValueSetOID As %String(MAXLEN = 220);

Property ValueSetVersion As %String(MAXLEN = 220);

Property ConceptCode As %String(MAXLEN = 220);

Property ConceptCodeSystem As %String(MAXLEN = 220);

Property ConceptCodeSystemVersion As %String(MAXLEN = 220);

Property ConceptDescription As %String(MAXLEN = 220);

Property MeasureId As %String(MAXLEN = 220);

Index ConceptCodeIndex On (ConceptCode, ConceptCodeSystem);

Storage Default
{
<Data name="ValueSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ValueSetName</Value>
</Value>
<Value name="3">
<Value>ValueSetOID</Value>
</Value>
<Value name="4">
<Value>ValueSetVersion</Value>
</Value>
<Value name="5">
<Value>ConceptCode</Value>
</Value>
<Value name="6">
<Value>ConceptCodeSystem</Value>
</Value>
<Value name="7">
<Value>ConceptCodeSystemVersion</Value>
</Value>
<Value name="8">
<Value>ConceptDescription</Value>
</Value>
<Value name="9">
<Value>MeasureId</Value>
</Value>
</Data>
<DataLocation>^HS.Data.ValueSetD</DataLocation>
<DefaultData>ValueSetDefaultData</DefaultData>
<IdLocation>^HS.Data.ValueSetD</IdLocation>
<IndexLocation>^HS.Data.ValueSetI</IndexLocation>
<StreamLocation>^HS.Data.ValueSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
