/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Documents a change in status of an Agent Interface
Class EnsLib.Agent.StatusEvent Extends %Persistent [ System = 4 ]
{

Property Interface As %String;

/// Status code from Agent
Property Status As %String;

/* Off,Init,Ready,Error,Busy */
Property Description As %String(MAXLEN = "");

Property EventTime As Ens.DataType.UTC [ InitialExpression = {$$$timeUTC} ];

Index Interface On Interface [ Type = bitmap ];

Storage Default
{
<Data name="StatusEventDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Interface</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>EventTime</Value>
</Value>
</Data>
<DataLocation>^EnsLib.Agent.StatusEventD</DataLocation>
<DefaultData>StatusEventDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EnsLib.Agent.StatusEventD</IdLocation>
<IndexLocation>^EnsLib.Agent.StatusEventI</IndexLocation>
<StreamLocation>^EnsLib.Agent.StatusEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
