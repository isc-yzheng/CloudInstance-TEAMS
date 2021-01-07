/// Persistent data used for session verification by <class>HSMOD.REST.Base</class>.  
Class HSMOD.REST.ApplicationConfig Extends %Persistent
{

Property RestApplication As %String(MAXLEN = 64) [ Required ];

Property XCSRFTokenChecking As %Boolean [ Required ];

Property XCSRFLoginPaths As list Of HSMOD.REST.ConfigPathItem;

Index ApplicationIndex On RestApplication [ PrimaryKey ];

Storage Default
{
<Data name="ApplicationConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RestApplication</Value>
</Value>
<Value name="3">
<Value>XCSRFTokenChecking</Value>
</Value>
<Value name="4">
<Value>XCSRFLoginPaths</Value>
</Value>
</Data>
<DataLocation>^HSMOD.REST.ApplicationConfigD</DataLocation>
<DefaultData>ApplicationConfigDefaultData</DefaultData>
<IdLocation>^HSMOD.REST.ApplicationConfigD</IdLocation>
<IndexLocation>^HSMOD.REST.ApplicationConfigI</IndexLocation>
<StreamLocation>^HSMOD.REST.ApplicationConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
