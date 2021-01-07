Class HS.Registry.Person.User.WebServices.Containers.Composite Extends (%Persistent, HS.Util.WebServices.ServiceStatus) [ ClassType = persistent ]
{

Property UserContainer As HS.Registry.Person.User.WebServices.Containers.User;

Property FacilityContainer As HS.Registry.Person.User.WebServices.Containers.UserFacility;

Property LoginContainer As HS.Registry.Person.User.WebServices.Containers.UserLoginID;

Storage Default
{
<Data name="CompositeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Status</Value>
</Value>
<Value name="3">
<Value>%User</Value>
</Value>
<Value name="4">
<Value>%Roles</Value>
</Value>
<Value name="5">
<Value>%Gateway</Value>
</Value>
<Value name="6">
<Value>FacilityContainer</Value>
</Value>
<Value name="7">
<Value>LoginContainer</Value>
</Value>
<Value name="8">
<Value>UserContainer</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.Pers1585.CompositeD</DataLocation>
<DefaultData>CompositeDefaultData</DefaultData>
<IdLocation>^HS.Registry.Pers1585.CompositeD</IdLocation>
<IndexLocation>^HS.Registry.Pers1585.CompositeI</IndexLocation>
<StreamLocation>^HS.Registry.Pers1585.CompositeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
