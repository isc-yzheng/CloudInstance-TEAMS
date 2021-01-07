Class HS.Registry.Person.User.WebServices.Containers.SuperContainer Extends (%Persistent, HS.Util.WebServices.ServiceStatus) [ ClassType = persistent ]
{

Property UserContainer As HS.Registry.Person.User.WebServices.Containers.User;

Property FacilityContainers As list Of HS.Registry.Person.User.WebServices.Containers.UserFacility;

Property LoginContainers As list Of HS.Registry.Person.User.WebServices.Containers.UserLoginID;

Storage Default
{
<Data name="SuperContainerDefaultData">
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
<Value>FacilityContainers</Value>
</Value>
<Value name="7">
<Value>LoginContainers</Value>
</Value>
<Value name="8">
<Value>UserContainer</Value>
</Value>
</Data>
<DataLocation>^HS.Registry1585.SuperContainerD</DataLocation>
<DefaultData>SuperContainerDefaultData</DefaultData>
<IdLocation>^HS.Registry1585.SuperContainerD</IdLocation>
<IndexLocation>^HS.Registry1585.SuperContainerI</IndexLocation>
<StreamLocation>^HS.Registry1585.SuperContainerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
