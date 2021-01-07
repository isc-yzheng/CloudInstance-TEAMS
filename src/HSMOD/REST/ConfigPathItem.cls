/// Persistent data used for session verification by <class>HSMOD.REST.Base</class>.  
Class HSMOD.REST.ConfigPathItem Extends %SerialObject
{

Property HTTPMethod As %String(VALUELIST = ",GET,POST,PUT,HEAD,CONNECT");

Property Path As %String;

Storage Default
{
<Data name="ConfigPathItemState">
<Value name="1">
<Value>HTTPMethod</Value>
</Value>
<Value name="2">
<Value>Path</Value>
</Value>
</Data>
<State>ConfigPathItemState</State>
<StreamLocation>^HSMOD.REST.ConfigPathItemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
