/// A companion class to hold foelds to be overriden
Class HS.Gateway.X12.X834v5010.SDA3Override Extends HS.Util.EnsResponse
{

Parameter XMLIGNORENULL = "inputonly";

Parameter DOMAIN = "HS";

Property PayerId As %String;

Property MemberLevelDetails As list Of HS.Gateway.X12.X834v5010.MemberLevelDetail;

Storage Default
{
<Data name="SDA3OverrideDefaultData">
<Subscript>"SDA3Override"</Subscript>
<Value name="1">
<Value>PayerId</Value>
</Value>
<Value name="2">
<Value>MemberLevelDetails</Value>
</Value>
</Data>
<DefaultData>SDA3OverrideDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
