Class HS.FHIRServer.RepoInstance Extends (%Persistent, ServiceInstance) [ StorageStrategy = "" ]
{

Property metadataSetKey As %String(COLLATION = "EXACT", MAXLEN = 128);

Property isEnabled As %Boolean;

Property cspUrl As %String(COLLATION = "EXACT", MAXLEN = "");

Property serviceConfigData As %String(COLLATION = "EXACT", MAXLEN = "");

Property serviceId As %Integer [ Required ];

/// Transient copies of the RepoInstance data
Property strategyClass As %String(MAXLEN = 128) [ Calculated ];

Property globalRoot As %String(MAXLEN = 512) [ Calculated ];

Property globalTempRoot As %String(MAXLEN = 512) [ Calculated ];

Property resourceClassesPackage As %String(MAXLEN = 512) [ Calculated ];

Property versionClassesPackage As %String(MAXLEN = 512) [ Calculated ];

Property searchClassesPackage As %String(MAXLEN = 512) [ Calculated ];

/// Flags whether this repo has be decommissioned, meaning that it should
/// no longer be attachable to an endpoint.  It remains available for historical
/// access (as in audit data)
Property IsDecommissioned As %Boolean;

Relationship repo As Repo [ Cardinality = parent, Inverse = Instances ];

Index UrlIdx On cspUrl [ Unique ];

ClassMethod getNextServiceId() As %Integer
{
	&sql(select max(serviceId) into :maxId from HS_FHIRServer.RepoInstance)
	return maxId+1
}

Method %OnNew() As %Status [ Private, ServerOnly = 1 ]
{
	set ..serviceId = ..getNextServiceId()
	Quit $$$OK
}

ClassMethod existsServiceId(id) As %Boolean
{
	return ..ServiceIdIdxExists(id)
}

ClassMethod deleteByServiceId(serviceId)
{
	set obj = ..getByServiceId(serviceId)
	do ..%DeleteId(obj.%Id())
}

ClassMethod getByServiceId(serviceId, ByRef sc As %Status) As HS.FHIRServer.RepoInstance
{
	return ..ServiceIdIdxOpen(serviceId,.sc)
}

Method globalRootGet() As %String [ CodeMode = expression ]
{
..repo.globalRoot
}

Method parentRepoGet() As %String [ CodeMode = expression ]
{
..repo
}

Method globalTempRootGet() As %String [ CodeMode = expression ]
{
..repo.globalTempRoot
}

Method resourceClassesPackageGet() As %String [ CodeMode = expression ]
{
..repo.resourceClassesPackage
}

Method versionClassesPackageGet() As %String [ CodeMode = expression ]
{
..repo.versionClassesPackage
}

Method searchClassesPackageGet() As %String [ CodeMode = expression ]
{
..repo.searchClassesPackage
}

Method strategyClassGet() As %String [ CodeMode = expression ]
{
..repo.strategyClass
}

Storage Default
{
<Data name="RepoInstanceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>metadataSetKey</Value>
</Value>
<Value name="3">
<Value>isEnabled</Value>
</Value>
<Value name="4">
<Value>cspUrl</Value>
</Value>
<Value name="5">
<Value>serviceConfigData</Value>
</Value>
<Value name="6">
<Value>IsDecommissioned</Value>
</Value>
<Value name="7">
<Value>serviceId</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Instances")</DataLocation>
<DefaultData>RepoInstanceDefaultData</DefaultData>
<IdLocation>^HS.FHIRServer.RepoC("Instances")</IdLocation>
<IndexLocation>^HS.FHIRServer.RepoInstanceI</IndexLocation>
<StreamLocation>^HS.FHIRServer.RepoInstanceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index ServiceIdIdx On serviceId [ Unique ];

}
