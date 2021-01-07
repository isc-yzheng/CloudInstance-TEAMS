Class HS.Registry.Person.UserPWHistory Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Relationship LoginID As HS.Registry.Person.UserLoginID [ Cardinality = parent, Inverse = PasswordHistory ];

Property WhenEntered As %TimeStamp;

/// %HS* domains, copied from Security.Users
/// PBKDF2 hashed password for Cache Authentication.<br>
/// This is used with a salt function obtained from 
/// $System.Encryption.GenCryptRand. This property is set by the class when the
/// PasswordExternal property is modified. Do not set this property directly.
Property Password As HS.Registry.Person.UserPassword(MAXLEN = 20);

/// %HS* domains, copied from Security.Users
/// Salt value for Hashed password from $System.Encryption.GenCryptRand.<br>
Property Salt As %Binary(MAXLEN = 8);

Storage Default
{
<Data name="UserPWHistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WhenEntered</Value>
</Value>
<Value name="3">
<Value>Password</Value>
</Value>
<Value name="4">
<Value>Salt</Value>
</Value>
</Data>
<DataLocation>^HS.RegistryBAF2.UserPWHistoryD</DataLocation>
<DefaultData>UserPWHistoryDefaultData</DefaultData>
<IdLocation>^HS.RegistryBAF2.UserPWHistoryD</IdLocation>
<IndexLocation>^HS.RegistryBAF2.UserPWHistoryI</IndexLocation>
<StreamLocation>^HS.RegistryBAF2.UserPWHistoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
