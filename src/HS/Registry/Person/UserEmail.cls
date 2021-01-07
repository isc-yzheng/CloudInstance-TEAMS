/// Denormalized from  HS.Registry.Person.User, Telecoms list property
/// in order to support an indexed lookup by Email type
Class HS.Registry.Person.UserEmail Extends (%Persistent, %XML.Adaptor)
{

Relationship UserClinician As HS.Registry.Person.User [ Cardinality = parent, Inverse = Emails ];

Property Email As %String(MAXLEN = 500);

Property EmailType As %String;

Property PrimaryFlag As %Boolean;

Index EmailIndex On Email;

Storage Default
{
<Data name="UserEmailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Email</Value>
</Value>
<Value name="3">
<Value>EmailType</Value>
</Value>
<Value name="4">
<Value>PrimaryFlag</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Emails")</DataLocation>
<DefaultData>UserEmailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.Registry.Person.UserC("Emails")</IdLocation>
<IndexLocation>^HS.Registry.Person.UserEmailI</IndexLocation>
<StreamLocation>^HS.Registry.Person.UserEmailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
