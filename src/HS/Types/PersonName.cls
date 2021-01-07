Class HS.Types.PersonName Extends (%SerialObject, %XML.Adaptor, HS.Util.CopyFrom) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property Family As %String(MAXLEN = 64);

Property Given As %String(MAXLEN = 64);

Property Middle As %String(MAXLEN = 64);

Property Prefix As %String(MAXLEN = 64);

Property Suffix As %String(MAXLEN = 64);

Property Type As %String(DISPLAYLIST = ","""",Alias,Adopted Name,Name At Birth,Display Name,Legal Name,Licensing Name,Maiden Name,Nickname,Previous,Indigenous/Tribal,Unspecified", VALUELIST = ","""",Alias,Adopted,Birth,Display,Legal,License,Maiden,Nickname,Previous,Tribal,Unknown");

Storage Default
{
<Data name="PersonNameState">
<Value name="1">
<Value>Family</Value>
</Value>
<Value name="2">
<Value>Given</Value>
</Value>
<Value name="3">
<Value>Middle</Value>
</Value>
<Value name="4">
<Value>Prefix</Value>
</Value>
<Value name="5">
<Value>Suffix</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
</Data>
<State>PersonNameState</State>
<StreamLocation>^HS.Types.PersonNameS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
