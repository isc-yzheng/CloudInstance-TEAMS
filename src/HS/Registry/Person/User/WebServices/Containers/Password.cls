Class HS.Registry.Person.User.WebServices.Containers.Password Extends (%Persistent, HS.Util.WebServices.ListItem) [ ClassType = persistent ]
{

Property Password As %Binary;

Property Salt As %Binary;

Storage Default
{
<Data name="PasswordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ID</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Password</Value>
</Value>
<Value name="5">
<Value>Salt</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.Perso1585.PasswordD</DataLocation>
<DefaultData>PasswordDefaultData</DefaultData>
<IdLocation>^HS.Registry.Perso1585.PasswordD</IdLocation>
<IndexLocation>^HS.Registry.Perso1585.PasswordI</IndexLocation>
<StreamLocation>^HS.Registry.Perso1585.PasswordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
