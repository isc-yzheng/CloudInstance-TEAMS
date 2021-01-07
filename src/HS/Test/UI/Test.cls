Class HS.Test.UI.Test Extends (%SerialObject, %XML.Adaptor)
{

Property Request As %Persistent(CLASSNAME = 1);

Property Response As %Persistent(CLASSNAME = 1);

Property Status As %Status [ InitialExpression = 1 ];

Property SessionId As %String;

Property RunTime As %TimeStamp [ InitialExpression = {$ZDT($H,3)} ];

Property LogTransaction As %Boolean [ InitialExpression = 1 ];

/// In multi-step actions, specify which code method was being executed
Property Code As %String;

/// In multi-step actions, specify a comment related to the test
Property Comment As %String(MAXLEN = 255);

/// if logging the transaction this is the entry from TCPTrace.Log
Property TransactionLogID As %String;

Property Service As HS.Registry.Service.Abstract;

Method %OnNew(pRequest As %RegisteredObject, pLogTransaction As %Boolean = 1) As %Status [ Private, ServerOnly = 1 ]
{
	Set i%Request=$G(pRequest)
	Set i%LogTransaction=pLogTransaction
	
	Quit $$$OK
}

Storage Default
{
<Data name="TestState">
<Value name="1">
<Value>Request</Value>
</Value>
<Value name="2">
<Value>Response</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
<Value name="4">
<Value>SessionId</Value>
</Value>
<Value name="5">
<Value>LogTransaction</Value>
</Value>
<Value name="6">
<Value>TransactionLogID</Value>
</Value>
<Value name="7">
<Value>Code</Value>
</Value>
<Value name="8">
<Value>Comment</Value>
</Value>
<Value name="9">
<Value>RunTime</Value>
</Value>
<Value name="10">
<Value>Service</Value>
</Value>
</Data>
<State>TestState</State>
<StreamLocation>^HS.Test.UI.TestS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
