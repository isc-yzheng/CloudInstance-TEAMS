/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// DTS XML Class to represent structure of Status structure within DTS Control file
Class EnsLib.ITK.DTS.Framework.Status Extends (%SerialObject, %XML.Adaptor) [ ClassType = serial, CompileAfter = , Inheritance = right, ProcedureBlock, System = 4 ]
{

Parameter XMLNAME = "StatusRecord";

Property DateTime As %String(MAXLEN = "", XMLNAME = "DateTime");

Property Event As %String(MAXLEN = "", XMLNAME = "Event");

Property Status As %String(MAXLEN = "", XMLNAME = "Status");

Property StatusCode As %String(MAXLEN = "", XMLNAME = "StatusCode");

Property Description As %String(MAXLEN = "", XMLNAME = "Description");

Storage Default
{
<Data name="StatusState">
<Value name="1">
<Value>DateTime</Value>
</Value>
<Value name="2">
<Value>Event</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
<Value name="4">
<Value>StatusCode</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
</Data>
<State>StatusState</State>
<StreamLocation>^EnsITK.DTSStatusS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
