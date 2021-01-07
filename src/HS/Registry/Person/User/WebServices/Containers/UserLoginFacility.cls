Class HS.Registry.Person.User.WebServices.Containers.UserLoginFacility Extends (%Persistent, HS.Util.WebServices.ServiceStatus, HS.Util.WebServices.ListItem) [ ClassType = persistent, Inheritance = right ]
{

Property LoginID As %String;

Property Domain As %String;

Property UserClinician As %String;

Property Password As %Binary;

Property Salt As %Binary;

Property ChangePassword As %Boolean;

Property ExpirationDate As %Integer;

Property Roles As list Of %String;

Storage Default
{
<Data name="UserLoginFacilityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ID</Value>
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
<Value>Salt</Value>
</Value>
<Value name="7">
<Value>ChangePassword</Value>
</Value>
<Value name="8">
<Value>ExpirationDate</Value>
</Value>
<Value name="9">
<Value>Roles</Value>
</Value>
<Value name="10">
<Value>Domain</Value>
</Value>
<Value name="11">
<Value>LoginID</Value>
</Value>
<Value name="12">
<Value>Name</Value>
</Value>
<Value name="13">
<Value>Password</Value>
</Value>
<Value name="14">
<Value>Status</Value>
</Value>
<Value name="15">
<Value>UserClinician</Value>
</Value>
</Data>
<DataLocation>^HS.Registr1585.UserLoginFaFABFD</DataLocation>
<DefaultData>UserLoginFacilityDefaultData</DefaultData>
<IdLocation>^HS.Registr1585.UserLoginFaFABFD</IdLocation>
<IndexLocation>^HS.Registr1585.UserLoginFaFABFI</IndexLocation>
<StreamLocation>^HS.Registr1585.UserLoginFaFABFS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
