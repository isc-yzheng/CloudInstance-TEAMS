/// Store source and target fields for LinkField. 
/// Both DocumentType and Path are used as index.
Class HS.Doc.Data.Field Extends (%Persistent, %XML.Adaptor)
{

Property DocumentType As %String(MAXLEN = 10);

Property Path As %String(MAXLEN = 32000);

Property Name As %String(MAXLEN = 510);

/// Use both DocumentType and path to identify an unique FieldTable.
Index FieldTableIndex On (DocumentType, Path) [ Unique ];

Storage Default
{
<Data name="FieldDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocumentType</Value>
</Value>
<Value name="3">
<Value>Path</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^HS.Doc.Data.FieldD</DataLocation>
<DefaultData>FieldDefaultData</DefaultData>
<IdLocation>^HS.Doc.Data.FieldD</IdLocation>
<IndexLocation>^HS.Doc.Data.FieldI</IndexLocation>
<StreamLocation>^HS.Doc.Data.FieldS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
