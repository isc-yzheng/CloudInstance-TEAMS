Class SchemaMap.Schema.FHIR4 Extends HSMOD.CSVTable.AbstractTable [ ProcedureBlock ]
{

Property Cardinality As %String(MAXLEN = 32000) [ SqlColumnNumber = 16 ];

Property FHIRCategory As %String(MAXLEN = 32000) [ SqlColumnNumber = 13 ];

Property DataType As %String(MAXLEN = 32000) [ SqlColumnNumber = 15 ];

Property Description As %String(MAXLEN = 32000) [ SqlColumnNumber = 17 ];

Property FHIRModule As %String(MAXLEN = 32000) [ SqlColumnNumber = 12 ];

Property Path As %String(MAXLEN = 32000) [ SqlColumnNumber = 14 ];

Index PathIndex On Path [ Unique ];

/// This method was generated initially, but it could have been modified since then.
/// It will be overwritten upon regeneration.
ClassMethod ExportFileTo(pFileName As %String = "", pDirName As %String = "", pTimeStampSuffix As %String = "") As %Status
{
}

/// This method was generated initially, but it could have been modified since then.
/// It will be overwritten upon regeneration.
ClassMethod ExportToStream(pStream As %Stream.Object, pAddHeaderRow As %Boolean = 0, ByRef pRowsFound As %Integer) As %Status [ Internal ]
{
}

/// This method was generated initially, but it could have been modified since then.
/// It will be overwritten upon regeneration.
ClassMethod ImportFileFrom(pDirName As %String = "") As %Status
{
}

Storage Default
{
<Data name="FHIR4DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Cardinality</Value>
</Value>
<Value name="3">
<Value>FHIRCategory</Value>
</Value>
<Value name="4">
<Value>DataType</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>FHIRModule</Value>
</Value>
<Value name="7">
<Value>Path</Value>
</Value>
<Value name="8">
<Value>LastModified</Value>
</Value>
<Value name="9">
<Value>UniqueIdentifier</Value>
</Value>
</Data>
<DataLocation>^SchemaMap.Schema.FHIR4D</DataLocation>
<DefaultData>FHIR4DefaultData</DefaultData>
<IdLocation>^SchemaMap.Schema.FHIR4D</IdLocation>
<IndexLocation>^SchemaMap.Schema.FHIR4I</IndexLocation>
<StreamLocation>^SchemaMap.Schema.FHIR4S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
