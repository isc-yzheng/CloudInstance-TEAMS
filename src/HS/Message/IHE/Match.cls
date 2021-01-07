Class HS.Message.IHE.Match Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property MRN As %String;

Property AssigningAuthority As %String;

Property AssigningAuthorityType As %String;

Property AssigningAuthorityScopingOrganization As %String;

Property Facility As %String;

Storage Default
{
<Data name="MatchState">
<Value name="1">
<Value>MRN</Value>
</Value>
<Value name="2">
<Value>AssigningAuthority</Value>
</Value>
<Value name="3">
<Value>Facility</Value>
</Value>
<Value name="4">
<Value>AssigningAuthorityType</Value>
</Value>
<Value name="5">
<Value>AssigningAuthorityScopingOrganization</Value>
</Value>
</Data>
<State>MatchState</State>
<StreamLocation>^HS.Message.IHE.MatchS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
