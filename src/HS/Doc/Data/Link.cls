/// Stores relationship between FieldTable items.
Class HS.Doc.Data.Link Extends (%Persistent, %XML.Adaptor)
{

Property SourceField As HS.Doc.Data.Field;

Property TargetField As HS.Doc.Data.Field;

// Name attribute of HealthShareMapping

Property MappingName As %String(MAXLEN = 100);

Property Comment As %String(MAXLEN = 4000);

Index SourceField On SourceField [ Type = bitmap ];

Index TargetField On TargetField [ Type = bitmap ];

Storage Default
{
<Data name="LinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SourceField</Value>
</Value>
<Value name="3">
<Value>TargetField</Value>
</Value>
<Value name="4">
<Value>MappingName</Value>
</Value>
<Value name="5">
<Value>Comment</Value>
</Value>
</Data>
<DataLocation>^HS.Doc.Data.LinkD</DataLocation>
<DefaultData>LinkDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.Doc.Data.LinkD</IdLocation>
<IndexLocation>^HS.Doc.Data.LinkI</IndexLocation>
<StreamLocation>^HS.Doc.Data.LinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
