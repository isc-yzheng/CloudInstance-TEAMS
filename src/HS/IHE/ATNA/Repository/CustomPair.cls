Class HS.IHE.ATNA.Repository.CustomPair Extends (%Persistent, %XML.Adaptor)
{

Relationship AggregationID As HS.IHE.ATNA.Repository.Aggregation [ Cardinality = parent, Inverse = CustomPairs ];

Property Name As %String(MAXLEN = "");

Property Value As %String(MAXLEN = "");

Index NameIndex On (Name, Value);

Storage Default
{
<Data name="CustomPairDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Value</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("CustomPairs")</DataLocation>
<DefaultData>CustomPairDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.IHE.Audit("CustomPairs")</IdLocation>
<IndexLocation>^HS.IHE.Audit("CustomPairsI")</IndexLocation>
<StreamLocation>^HS.IHE.Audit("CustomPairsS")</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
