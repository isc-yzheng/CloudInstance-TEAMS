Class HS.Gateway.Config Extends (%Persistent, HS.Types.GatewayInfo, %XML.Adaptor, HS.Sync.BaseClass) [ ClassType = persistent, Inheritance = right ]
{

Parameter RESOURCE As STRING = {$$$HSHubManagement};

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter SYNCORDER = 20;

Property LastSeen As %TimeStamp(ZENREADONLY = 1);

Relationship Facilities As HS.Facility.Config(ZENHIDDEN = 1) [ Cardinality = many, Inverse = Gateway ];

Index NameIndex On Name [ Unique ];

/// To enable us to find the gateway for that URL.
/// We're not requiring the index to be unique, but only one should be active (the last seen)
Index URLIndex On (EndPoint, LastSeen);

ClassMethod FindByName(Name As %String, ByRef ID As %Integer) As %Status
{
	Set tSC = $$$OK
	&SQL(SELECT ID INTO :ID FROM Config WHERE Name=:Name)
	If SQLCODE {
		Set ID=""
		Set tSC = $S(SQLCODE=100:$$$ERROR($$$KeyNotFound,..%ClassName(1),"Name",Name),1:$$$ERROR($$$SQLError,$G(SQLCODE),$G(%msg)))
	}
	Quit tSC
}

Query ListGateways(pName As %String = "", pType As %String = "", pShowDisabled As %Boolean = 0) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 SELECT %ID,Name,Type,Status,LastSeen,EndPoint,CacheType,FeedAnalytics,Version FROM HS_Gateway.Config
 WHERE (Name %STARTSWITH :pName)
 And (Type %STARTSWITH :pType)
 And ((Status <> 'Disabled') OR (:pShowDisabled = 1))
 ORDER BY Type, Name
}

/// Returns the version number for a gateway, for a given URL/Endpoint
ClassMethod FindVersionByURL(pURL As %String, ByRef pVersion) As %Status
{
	Set tSC=$$$OK
	&SQL(Select Version Into :pVersion From Config Where EndPoint=:pURL Order by LastSeen Desc)
	If SQLCODE {
		Set pVersion=""
		Set tSC = $S(SQLCODE=100:$$$ERROR($$$KeyNotFound,..%ClassName(1),"URL",pURL),1:$$$ERROR($$$SQLError,$G(SQLCODE),$G(%msg)))
	}
	Quit tSC
}

/// Returns the version number for a gateway, for a given URL/Endpoint
ClassMethod FindNameByURL(pURL As %String, ByRef pName) As %Status
{
	Set tSC=$$$OK
	&SQL(Select Name Into :pName From Config Where EndPoint=:pURL Order by LastSeen Desc)
	If SQLCODE {
		Set pName=""
		Set tSC = $S(SQLCODE=100:$$$ERROR($$$KeyNotFound,..%ClassName(1),"URL",pURL),1:$$$ERROR($$$SQLError,$G(SQLCODE),$G(%msg)))
	}
	Quit tSC
}

Storage Default
{
<Data name="ConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IP</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Online</Value>
</Value>
<Value name="5">
<Value>Transports</Value>
</Value>
<Value name="6">
<Value>Port</Value>
</Value>
<Value name="7">
<Value>EndPoint</Value>
</Value>
<Value name="8">
<Value>Status</Value>
</Value>
<Value name="9">
<Value>LastSeen</Value>
</Value>
<Value name="10">
<Value>Type</Value>
</Value>
<Value name="11">
<Value>OID</Value>
</Value>
<Value name="12">
<Value>ConsumeAndForward</Value>
</Value>
<Value name="13">
<Value>FeedAnalytics</Value>
</Value>
<Value name="14">
<Value>CacheType</Value>
</Value>
<Value name="15">
<Value>Version</Value>
</Value>
</Data>
<DataLocation>^HS.Gateway.ConfigD</DataLocation>
<DefaultData>ConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.Gateway.ConfigD</IdLocation>
<IndexLocation>^HS.Gateway.ConfigI</IndexLocation>
<StreamLocation>^HS.Gateway.ConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
