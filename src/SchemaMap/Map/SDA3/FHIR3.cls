Include SchemaMap

Class SchemaMap.Map.SDA3.FHIR3 Extends HSMOD.CSVTable.AbstractTable [ ProcedureBlock ]
{

Property Active As %Boolean [ SqlColumnNumber = 29 ];

Property Append As %Boolean [ SqlColumnNumber = 27 ];

Property AutoMapped As %Boolean [ SqlColumnNumber = 17 ];

Property ClassMethod As %String(MAXLEN = 32000) [ SqlColumnNumber = 19 ];

Property DefaultValue As %String(MAXLEN = 32000) [ SqlColumnNumber = 20 ];

Property DependsOn As %String(MAXLEN = 32000) [ SqlColumnNumber = 22 ];

Property ExcludeList As %String(MAXLEN = 32000) [ SqlColumnNumber = 28 ];

Property Extension As %String(MAXLEN = 32000) [ SqlColumnNumber = 21 ];

Property MapIssues As %String(MAXLEN = 32000) [ SqlColumnNumber = 25 ];

Property MapNotes As %String(MAXLEN = 32000) [ SqlColumnNumber = 26 ];

Property SourceInfoPath As %String(MAXLEN = 32000) [ SqlColumnNumber = 23 ];

Property SourcePath As %String(MAXLEN = 32000) [ Required, SqlColumnNumber = 12 ];

Property SourceTransform As %String(MAXLEN = 32000) [ SqlColumnNumber = 14 ];

Property SourceValue As %String(MAXLEN = 32000) [ SqlColumnNumber = 13 ];

Property SubTransform As %String(MAXLEN = 32000) [ SqlColumnNumber = 18 ];

Property TargetInfoPath As %String(MAXLEN = 32000) [ SqlColumnNumber = 24 ];

Property TargetPath As %String(MAXLEN = 32000) [ SqlColumnNumber = 15 ];

Property TargetTransform As %String(MAXLEN = 32000) [ SqlColumnNumber = 16 ];

Index SourcePathIndex On SourcePath;

/// This method was generated initially, but it could have been modified since then.
/// It will be overwritten upon regeneration.
Method %OnBeforeSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
}

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
<Data name="FHIR3DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UniqueIdentifier</Value>
</Value>
<Value name="3">
<Value>LastModified</Value>
</Value>
<Value name="4">
<Value>Active</Value>
</Value>
<Value name="5">
<Value>Append</Value>
</Value>
<Value name="6">
<Value>AutoMapped</Value>
</Value>
<Value name="7">
<Value>ClassMethod</Value>
</Value>
<Value name="8">
<Value>DefaultValue</Value>
</Value>
<Value name="9">
<Value>DependsOn</Value>
</Value>
<Value name="10">
<Value>ExcludeList</Value>
</Value>
<Value name="11">
<Value>Extension</Value>
</Value>
<Value name="12">
<Value>MapIssues</Value>
</Value>
<Value name="13">
<Value>MapNotes</Value>
</Value>
<Value name="14">
<Value>SourceInfoPath</Value>
</Value>
<Value name="15">
<Value>SourcePath</Value>
</Value>
<Value name="16">
<Value>SourceTransform</Value>
</Value>
<Value name="17">
<Value>SourceValue</Value>
</Value>
<Value name="18">
<Value>SubTransform</Value>
</Value>
<Value name="19">
<Value>TargetInfoPath</Value>
</Value>
<Value name="20">
<Value>TargetPath</Value>
</Value>
<Value name="21">
<Value>TargetTransform</Value>
</Value>
</Data>
<DataLocation>^SchemaMap.Map.SDA3.FHIR3D</DataLocation>
<DefaultData>FHIR3DefaultData</DefaultData>
<IdLocation>^SchemaMap.Map.SDA3.FHIR3D</IdLocation>
<IndexLocation>^SchemaMap.Map.SDA3.FHIR3I</IndexLocation>
<StreamLocation>^SchemaMap.Map.SDA3.FHIR3S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
