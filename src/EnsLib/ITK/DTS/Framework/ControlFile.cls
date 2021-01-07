/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// DTS XML Class to represent structure of DTS Control file
Class EnsLib.ITK.DTS.Framework.ControlFile Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, CompileAfter = , Inheritance = right, ProcedureBlock, System = 4 ]
{

Parameter XMLNAME = "DTSControl";

Property Version As %String(MAXLEN = "", XMLNAME = "Version") [ Required ];

Property AddressType As %String(MAXLEN = "", XMLNAME = "AddressType") [ Required ];

Property MessageType As %String(MAXLEN = "", XMLNAME = "MessageType") [ Required ];

Property FromESMTP As %String(MAXLEN = "", XMLNAME = "From_ESMTP");

Property ToESMTP As %String(MAXLEN = "", XMLNAME = "To_ESMTP");

Property FromDTS As %String(MAXLEN = "", XMLNAME = "From_DTS");

Property ToDTS As %String(MAXLEN = "", XMLNAME = "To_DTS");

Property Subject As %String(MAXLEN = "", XMLNAME = "Subject");

Property LocalId As %String(MAXLEN = "", XMLNAME = "LocalId");

Property DTSId As %String(MAXLEN = 100, XMLNAME = "DTSId");

Property PartnerId As %String(MAXLEN = "", XMLNAME = "PartnerId");

Property Compress As %String(MAXLEN = "", XMLNAME = "Compress");

Property Encrypted As %String(MAXLEN = "", XMLNAME = "Encrypted");

Property WorkflowId As %String(MAXLEN = 32, XMLNAME = "WorkflowId");

Property ProcessId As %String(MAXLEN = "", XMLNAME = "ProcessId");

Property DataChecksum As %String(MAXLEN = "", XMLNAME = "DataChecksum");

Property IsCompressed As %String(MAXLEN = "", XMLNAME = "IsCompressed");

Property StatusRecord As EnsLib.ITK.DTS.Framework.Status;

Storage Default
{
<Data name="ControlFileDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Version</Value>
</Value>
<Value name="3">
<Value>AddressType</Value>
</Value>
<Value name="4">
<Value>MessageType</Value>
</Value>
<Value name="5">
<Value>FromESMTP</Value>
</Value>
<Value name="6">
<Value>ToESMTP</Value>
</Value>
<Value name="7">
<Value>FromDTS</Value>
</Value>
<Value name="8">
<Value>ToDTS</Value>
</Value>
<Value name="9">
<Value>Subject</Value>
</Value>
<Value name="10">
<Value>LocalId</Value>
</Value>
<Value name="11">
<Value>DTSId</Value>
</Value>
<Value name="12">
<Value>PartnerId</Value>
</Value>
<Value name="13">
<Value>Compress</Value>
</Value>
<Value name="14">
<Value>Encrypted</Value>
</Value>
<Value name="15">
<Value>WorkflowId</Value>
</Value>
<Value name="16">
<Value>ProcessId</Value>
</Value>
<Value name="17">
<Value>DataChecksum</Value>
</Value>
<Value name="18">
<Value>IsCompressed</Value>
</Value>
<Value name="19">
<Value>StatusRecord</Value>
</Value>
</Data>
<DataLocation>^EnsITK.DTSControlFileDefDataD</DataLocation>
<DefaultData>ControlFileDefaultData</DefaultData>
<IdLocation>^EnsITK.DTSControlFileDefDataD</IdLocation>
<IndexLocation>^EnsITK.DTSControlFileDefDataI</IndexLocation>
<StreamLocation>^EnsITK.DTSControlFileDefDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
