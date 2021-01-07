/// This class corresponds to a SDA3 container
Class HS.Gateway.X12.X834v5010.MemberLevelDetail Extends (%SerialObject, %XML.Adaptor)
{

Property SubscriberId As %String;

Property MemberGroupOrPolicyNumber As %String;

Property MemberId As %String;

Property Race As %String;

Property PrimaryLanguage As %String;

Property HealthCoverages As list Of HS.Gateway.X12.X834v5010.HealthCoverage;

Storage Default
{
<Data name="MemberLevelDetailState">
<Value name="1">
<Value>SubscriberId</Value>
</Value>
<Value name="2">
<Value>MemberGroupOrPolicyNumber</Value>
</Value>
<Value name="3">
<Value>MemberId</Value>
</Value>
<Value name="4">
<Value>Race</Value>
</Value>
<Value name="5">
<Value>PrimaryLanguage</Value>
</Value>
<Value name="6">
<Value>HealthCoverages</Value>
</Value>
</Data>
<State>MemberLevelDetailState</State>
<StreamLocation>^HS.Gateway3B4E.MemberLevelFDCFS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
