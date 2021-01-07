Class SchemaMap.Schema.SDA3 Extends HSMOD.CSVTable.AbstractTable
{

Property Path As %String(MAXLEN = 32000) [ SqlColumnNumber = 14 ];

Index PathIndex On Path [ Unique ];

Property DataType As %String(MAXLEN = 32000) [ SqlColumnNumber = 15 ];

Property Cardinality As %String(MAXLEN = 32000) [ SqlColumnNumber = 16 ];

Property Description As %String(MAXLEN = 32000) [ SqlColumnNumber = 17 ];

ClassMethod ImportFileFrom(pDirName = "") As %Status
{
}

ClassMethod ExportFileTo(pFileName = "", pDirName = "", pTimeStampSuffix = "") As %Status
{
}

/// implementation method for export
ClassMethod ExportToStream(pStream As %Stream.Object, pAddHeaderRow As %Boolean = 0, Output pRowsFound As %Integer) As %Status [ Internal ]
{
}

Storage Default
{
<Data name="SDA3DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Path</Value>
</Value>
<Value name="3">
<Value>LastModified</Value>
</Value>
<Value name="4">
<Value>DataType</Value>
</Value>
<Value name="5">
<Value>Cardinality</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
<Value name="7">
<Value>UniqueIdentifier</Value>
</Value>
</Data>
<DataLocation>^SchemaMap.Schema.SDA3D</DataLocation>
<DefaultData>SDA3DefaultData</DefaultData>
<IdLocation>^SchemaMap.Schema.SDA3D</IdLocation>
<IndexLocation>^SchemaMap.Schema.SDA3I</IndexLocation>
<StreamLocation>^SchemaMap.Schema.SDA3S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
