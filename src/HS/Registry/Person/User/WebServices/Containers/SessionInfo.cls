Class HS.Registry.Person.User.WebServices.Containers.SessionInfo Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property UserInternalID As %String;

Property CanProxy As %Boolean;

Property CanChangeFacility As %Boolean;

Property PrimaryFacility As %String;

Property Facilities As %String(MAXLEN = "");

Property UserType As %String;

Property MessageRepository As %String(MAXLEN = 256);

Storage Default
{
<Data name="SessionInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserInternalID</Value>
</Value>
<Value name="3">
<Value>CanProxy</Value>
</Value>
<Value name="4">
<Value>CanChangeFacility</Value>
</Value>
<Value name="5">
<Value>PrimaryFacility</Value>
</Value>
<Value name="6">
<Value>Facilities</Value>
</Value>
<Value name="7">
<Value>UserType</Value>
</Value>
<Value name="8">
<Value>MessageRepository</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.Pe1585.SessionInfoD</DataLocation>
<DefaultData>SessionInfoDefaultData</DefaultData>
<IdLocation>^HS.Registry.Pe1585.SessionInfoD</IdLocation>
<IndexLocation>^HS.Registry.Pe1585.SessionInfoI</IndexLocation>
<StreamLocation>^HS.Registry.Pe1585.SessionInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
