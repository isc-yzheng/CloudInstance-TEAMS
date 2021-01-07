Class HS.FHIRServer.Storage.Json.SearchTableVersion Extends %Persistent [ StorageStrategy = "" ]
{

// Property ResourceType As %String; 

Property RepoKey As %String;

Property TableName As %String;

Property Version As %Integer;

Property FieldList As %List;

Index MainIdx On (RepoKey, TableName);

ClassMethod getCurrentVer(repoKey As %String, tableName As %String) As %Integer
{
	&sql(select max(Version) into :ver from HS_FHIRServer_Storage_Json.SearchTableVersion where Repokey = :repoKey and TableName =:tableName)
	return ver
}

ClassMethod incrementVersion(repoKey As %String, tableName As %String, fieldList As %List)
{
	&sql(select count(*) into :count from HS_FHIRServer_Storage_Json.SearchTableVersion where Repokey = :repoKey and TableName =:tableName)
	set obj = ..%New()
	set obj.FieldList = fieldList
	set obj.RepoKey = repoKey
	set obj.TableName = tableName
	set obj.Version = count+1
	set sc = obj.%Save()
	$$$ThrowOnError(sc)
}

Storage Default
{
<Data name="SearchTableVersionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RepoKey</Value>
</Value>
<Value name="3">
<Value>TableName</Value>
</Value>
<Value name="4">
<Value>Version</Value>
</Value>
<Value name="5">
<Value>FieldList</Value>
</Value>
</Data>
<DataLocation>^HS.FHIRSer7AAF.SearchTableE00FD</DataLocation>
<DefaultData>SearchTableVersionDefaultData</DefaultData>
<IdLocation>^HS.FHIRSer7AAF.SearchTableE00FD</IdLocation>
<IndexLocation>^HS.FHIRSer7AAF.SearchTableE00FI</IndexLocation>
<StreamLocation>^HS.FHIRSer7AAF.SearchTableE00FS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
