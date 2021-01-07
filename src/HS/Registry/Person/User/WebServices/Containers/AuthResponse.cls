Class HS.Registry.Person.User.WebServices.Containers.AuthResponse Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property UserID As %String;

Property Roles As %String(MAXLEN = "");

Property ErrMessage As %String(MAXLEN = "");

Property FullName As %String;

/// must change password at this login
Property ChangePassword As %Boolean;

/// used by change password for internal domains - the token will be the internal ID of the login record
Property Token As %String(MAXLEN = "");

Property LoginDomain As %String;

Property LoginID As %String;

/// This will be non-null if the user entered a bad password and all conditions are OK
/// to ask them if they forgot their password
Property ChallengeQuestion As %String(MAXLEN = 256);

/// If the domain uses two factor authentication, this will be the phone provider
Property PhoneProvider As %String;

/// If the domain uses two factor authentication, this will be the phone number (usually a mobile phone)
Property PhoneNumber As %String;

/// Pass back whatever custom additional info stuff there is, to allow use by login page, etc.
Property AdditionalInfo As array Of HS.Types.AdditionalInfoItem;

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"AdditionalInfo"</Subscript>
</Data>
<Data name="AuthResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>Roles</Value>
</Value>
<Value name="4">
<Value>ErrMessage</Value>
</Value>
<Value name="5">
<Value>FullName</Value>
</Value>
<Value name="6">
<Value>ChangePassword</Value>
</Value>
<Value name="7">
<Value>Token</Value>
</Value>
<Value name="8">
<Value>LoginDomain</Value>
</Value>
<Value name="9">
<Value>LoginID</Value>
</Value>
<Value name="10">
<Value>ChallengeQuestion</Value>
</Value>
<Value name="11">
<Value>PhoneProvider</Value>
</Value>
<Value name="12">
<Value>PhoneNumber</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.P1585.AuthResponseD</DataLocation>
<DefaultData>AuthResponseDefaultData</DefaultData>
<IdLocation>^HS.Registry.P1585.AuthResponseD</IdLocation>
<IndexLocation>^HS.Registry.P1585.AuthResponseI</IndexLocation>
<StreamLocation>^HS.Registry.P1585.AuthResponseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
