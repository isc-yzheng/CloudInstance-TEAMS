Class HS.Doc.Utility.SearchNode Extends %Persistent
{

Property FieldId As %Integer;

Property SourceNodeIds As list Of %String;

Property TargetNodeIds As list Of %String;

Storage Default
{
<Data name="SearchNodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FieldId</Value>
</Value>
<Value name="3">
<Value>SourceNodeIds</Value>
</Value>
<Value name="4">
<Value>TargetNodeIds</Value>
</Value>
</Data>
<DataLocation>^HS.Doc.Utility.SearchNodeD</DataLocation>
<DefaultData>SearchNodeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.Doc.Utility.SearchNodeD</IdLocation>
<IndexLocation>^HS.Doc.Utility.SearchNodeI</IndexLocation>
<StreamLocation>^HS.Doc.Utility.SearchNodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
