Include HS.FHIRServer

Class HS.FHIRServer.Repo Extends %Persistent [ StorageStrategy = "" ]
{

Property managerClass As %String(MAXLEN = 128);

Property strategyClass As %String(MAXLEN = 128);

Property strategyKey As %String;

Property globalRoot As %String(MAXLEN = 512);

Property globalTempRoot As %String(MAXLEN = 512);

Property resourceClassesPackage As %String(MAXLEN = 512);

Property versionClassesPackage As %String(MAXLEN = 512);

Property searchClassesPackage As %String(MAXLEN = 512);

Property resourceDBName As %String;

Property versionDBName As %String;

Property resourcePath As %String(MAXLEN = 512);

Property versionPath As %String(MAXLEN = 512);

Relationship Instances As RepoInstance [ Cardinality = children, Inverse = repo ];

ClassMethod getFHIRDbList() As %List
{
	Set SQL = "SELECT resourceDBName,versionDBName FROM HS_FHIRServer.Repo"
	Set statement = ##class(%SQL.Statement).%New()
	Set tSC = statement.%Prepare(SQL)
	$$$ThrowOnError(tSC)
	set ret = ""
	Set rs = statement.%Execute()
	while (rs.%Next()) {
		set ret = ret _$lb(rs.%GetData(1), rs.%GetData(2))
	}
	
	return ret
}

ClassMethod GetById(id As %String) As Repo
{
	Set repo = ##class(HS.FHIRServer.Repo).%OpenId(id,, .sc)
	$$$ThrowOnError(sc)
	return repo
}

/// Get the StrategyKey parameter for the InteractionsStrategy class that manages this Service
Method GetStrategyKey() As %String [ CodeMode = expression ]
{
$Parameter($Parameter(..managerClass, "StrategyClass"), "StrategyKey")
}

Method HasServiceForMetadataSet(pMetadataSetKey As %String) As %Boolean
{
	Set instanceCount = ..Instances.Count()
	for ord=1:1:instanceCount {
		if ..Instances.GetAt(ord).metadataSetKey = pMetadataSetKey {
			return 1
		}
	}
	return 0
}

ClassMethod GetRepoIdList() As %List
{
	Set list = ""
	Set SQL = "SELECT ID FROM HS_FHIRServer.Repo"
	Set statement = ##class(%SQL.Statement).%New()
	Set tSC = statement.%Prepare(SQL)
	$$$ThrowOnError(tSC)
	Set resultSet = statement.%Execute()
	While resultSet.%Next() {
		Set $list(list, *+1) = resultSet.%GetData(1)
	}
	return list
}

ClassMethod GetAllRepos(Output array) As %Integer
{
	Set array = 0
	Set SQL = "SELECT ID FROM HS_FHIRServer.Repo"
	Set statement = ##class(%SQL.Statement).%New()
	Set tSC = statement.%Prepare(SQL)
	$$$ThrowOnError(tSC)
	Set resultSet = statement.%Execute()
	While resultSet.%Next() {
		Set array($I(array)) = ..GetById(resultSet.%GetData(1))
	}
	return array
}

Storage Default
{
<Data name="RepoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>strategyClass</Value>
</Value>
<Value name="3">
<Value>globalRoot</Value>
</Value>
<Value name="4">
<Value>globalTempRoot</Value>
</Value>
<Value name="5">
<Value>resourceClassesPackage</Value>
</Value>
<Value name="6">
<Value>searchClassesPackage</Value>
</Value>
<Value name="7">
<Value>strategyKey</Value>
</Value>
<Value name="8">
<Value>managerClass</Value>
</Value>
<Value name="9">
<Value>versionClassesPackage</Value>
</Value>
<Value name="10">
<Value>resourceDBName</Value>
</Value>
<Value name="11">
<Value>versionDBName</Value>
</Value>
<Value name="12">
<Value>resourcePath</Value>
</Value>
<Value name="13">
<Value>versionPath</Value>
</Value>
</Data>
<DataLocation>^HS.FHIRServer.RepoD</DataLocation>
<DefaultData>RepoDefaultData</DefaultData>
<IdLocation>^HS.FHIRServer.RepoD</IdLocation>
<IndexLocation>^HS.FHIRServer.RepoI</IndexLocation>
<StreamLocation>^HS.FHIRServer.RepoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
