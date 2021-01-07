/// User on an Access gateway
Class HS.Types.GatewayUser Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// User ID on a gateway
Property UserId As %String;

/// An access gateway
Property Gateway As HS.Gateway.Config;

Storage Default
{
<Data name="GatewayUserState">
<Value name="1">
<Value>UserId</Value>
</Value>
<Value name="2">
<Value>Gateway</Value>
</Value>
</Data>
<State>GatewayUserState</State>
<StreamLocation>^HS.Types.GatewayUserS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
