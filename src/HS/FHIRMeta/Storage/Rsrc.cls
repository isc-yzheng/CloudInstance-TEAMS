Class HS.FHIRMeta.Storage.Rsrc Extends %Persistent
{

Property packageId As %String(COLLATION = "EXACT", MAXLEN = 128);

Property coreVersion As %String(COLLATION = "EXACT", MAXLEN = 64);

Property id As %String(COLLATION = "EXACT", MAXLEN = 250);

Property url As %String(COLLATION = "EXACT", MAXLEN = 250);

Property resourceType As %String(COLLATION = "EXACT", MAXLEN = 64);

Property version As %String(COLLATION = "EXACT", MAXLEN = 64);

Property kind As %String(COLLATION = "EXACT", MAXLEN = 64);

Property type As %String(COLLATION = "EXACT", MAXLEN = 64);

Property json As %String(MAXLEN = "");

Index TypeIdIndex On (resourceType, id, version);

Index UrlIndex On (url, version) [ Unique ];

Index PkgTypeIndex On (packageId, resourceType);

Index PkgUrlIndex On (packageId, url);

/// Returns a resource given the specified resourceType and id.
ClassMethod GetRsrcById(packageList As %List, resourceType As %String, id As %String) As %DynamicObject
{
	Set SQL = "SELECT json FROM HS_FHIRMeta_Storage.Rsrc where (packageId %INLIST ?) and resourceType = ? and id = ?"
	Set statement = ##class(%SQL.Statement).%New()
	Set tSC = statement.%Prepare(SQL)
	$$$ThrowOnError(tSC)
	Set resultSet = statement.%Execute(packageList, resourceType, id)
	// NOTE: We expect 0 or 1 results.  No checking for multiple at this point
	if resultSet.%Next() {
		return ##class(%DynamicObject).%FromJSON(resultSet.%GetData(1))
	}
	return ""
}

/// Returns a resource given the specified 'url' property value.  Note that the resourceType
/// need not be specified because it is implicit in the URL.
ClassMethod GetRsrcByUrl(packageList As %List, url As %String) As %DynamicObject
{
	Set SQL = "SELECT json FROM HS_FHIRMeta_Storage.Rsrc where (packageId %INLIST ?) and url = ?"
	Set statement = ##class(%SQL.Statement).%New()
	Set tSC = statement.%Prepare(SQL)
	$$$ThrowOnError(tSC)
	Set resultSet = statement.%Execute(packageList, url)
	// NOTE: We expect 0 or 1 results.  No checking for multiple at this point
	if resultSet.%Next() {
		return ##class(%DynamicObject).%FromJSON(resultSet.%GetData(1))
	}
	return ""
}

Storage Default
{
<Data name="RsrcDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>packageId</Value>
</Value>
<Value name="3">
<Value>id</Value>
</Value>
<Value name="4">
<Value>url</Value>
</Value>
<Value name="5">
<Value>resourceType</Value>
</Value>
<Value name="6">
<Value>version</Value>
</Value>
<Value name="7">
<Value>kind</Value>
</Value>
<Value name="8">
<Value>type</Value>
</Value>
<Value name="9">
<Value>json</Value>
</Value>
<Value name="10">
<Value>coreVersion</Value>
</Value>
</Data>
<DataLocation>^HS.FHIRMeta.Storage.RsrcD</DataLocation>
<DefaultData>RsrcDefaultData</DefaultData>
<IdLocation>^HS.FHIRMeta.Storage.RsrcD</IdLocation>
<IndexLocation>^HS.FHIRMeta.Storage.RsrcI</IndexLocation>
<StreamLocation>^HS.FHIRMeta.Storage.RsrcS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
