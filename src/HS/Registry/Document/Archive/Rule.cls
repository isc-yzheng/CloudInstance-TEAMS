/// 
/// This is the list of documents to archive
Class HS.Registry.Document.Archive.Rule Extends (%Persistent, %XML.Adaptor)
{

Property SourceIDS As list Of %String(STORAGEDEFAULT = "array");

Property PurgeDefaultDays As %Integer [ InitialExpression = {365*3} ];

Property Items As list Of HS.Registry.Document.Archive.RuleItem;

Index SourceIDSIndex On (SourceIDS(ELEMENTS), SourceIDS(KEYS));

Storage Default
{
<Data name="RuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PurgeDefaultDays</Value>
</Value>
<Value name="3">
<Value>Items</Value>
</Value>
</Data>
<Data name="SourceIDS">
<Attribute>SourceIDS</Attribute>
<Structure>subnode</Structure>
<Subscript>"SourceIDS"</Subscript>
</Data>
<DataLocation>^HS.Registry.Document66AD.RuleD</DataLocation>
<DefaultData>RuleDefaultData</DefaultData>
<IdLocation>^HS.Registry.Document66AD.RuleD</IdLocation>
<IndexLocation>^HS.Registry.Document66AD.RuleI</IndexLocation>
<StreamLocation>^HS.Registry.Document66AD.RuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
