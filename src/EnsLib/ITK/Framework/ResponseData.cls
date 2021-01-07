/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Response class to carry a Deferred Response to Synchronous requests.
Class EnsLib.ITK.Framework.ResponseData Extends EnsLib.ITK.Framework.ResponseBase [ System = 4 ]
{

/// Original message ID in case we need to send a technical ack
Property RequestMessageId As %String;

Property RequestInvocationPattern As %String;

Property ResponseInvocationPattern As %String;

Property BehaviourType As %String;

Property SourceApplication As %String;

Property FaultCode As %String;

Storage Default
{
<Data name="ResponseDataDefaultData">
<Subscript>"ResponseData"</Subscript>
<Value name="1">
<Value>ResponseBody</Value>
</Value>
<Value name="2">
<Value>Status</Value>
</Value>
<Value name="3">
<Value>InvocationPattern</Value>
</Value>
<Value name="4">
<Value>RequestInvocationPattern</Value>
</Value>
<Value name="5">
<Value>ResponseInvocationPattern</Value>
</Value>
<Value name="6">
<Value>BehaviourType</Value>
</Value>
<Value name="7">
<Value>MessageId</Value>
</Value>
<Value name="8">
<Value>SourceApplication</Value>
</Value>
<Value name="9">
<Value>FaultCode</Value>
</Value>
<Value name="10">
<Value>RequestMessageId</Value>
</Value>
</Data>
<DefaultData>ResponseDataDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
