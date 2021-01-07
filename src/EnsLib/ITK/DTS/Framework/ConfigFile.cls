/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// DTS XML Class to represent structure of DTS Configuration file
Class EnsLib.ITK.DTS.Framework.ConfigFile Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, CompileAfter = , Inheritance = right, ProcedureBlock, System = 4 ]
{

Parameter XMLNAME = "DTSConfig";

Property ClientIdentity As %String(MAXLEN = "", XMLNAME = "ClientIdentity") [ Required ];

Property ClientAuthentication As %String(MAXLEN = "", XMLNAME = "ClientAuthentication") [ Required ];

Property InterfaceRoot As %String(MAXLEN = "", XMLNAME = "InterfaceRoot") [ Required ];

Property CertPath As %String(MAXLEN = "", XMLNAME = "CertPath") [ Required ];

Property LogPath As %String(MAXLEN = "", XMLNAME = "LogPath");

Property WorkPath As %String(MAXLEN = "", XMLNAME = "WorkPath");

Property PrimaryURL As %String(MAXLEN = "", XMLNAME = "PrimaryURL");

Property SecondaryURL As %String(MAXLEN = "", XMLNAME = "SecondaryURL");

Property CollectReport As %String(MAXLEN = "", XMLNAME = "CollectReport");

Property DelayReport As %String(MAXLEN = "", XMLNAME = "DelayReport");

Property TransferReport As %String(MAXLEN = "", XMLNAME = "TransferReport");

Property PollReport As %String(MAXLEN = "", XMLNAME = "PollReport");

Property SaveSent As %String(MAXLEN = "", XMLNAME = "SaveSent");

Property ServerRetry As %String(MAXLEN = "", XMLNAME = "ServerRetry");

Property SignalPath As %String(MAXLEN = "", XMLNAME = "SignalPath");

Property ProxyPath As %String(MAXLEN = "", XMLNAME = "ProxyPath");

Property PollPeriod As %String(MAXLEN = "", XMLNAME = "PollPeriod");

Property FilePoll As %String(MAXLEN = "", XMLNAME = "FilePoll");

Property ServerPoll As %String(MAXLEN = "", XMLNAME = "ServerPoll");

Property MaxMessages As %String(MAXLEN = "", XMLNAME = "MaxMessages");

Property MaxMessagesUp As %String(MAXLEN = "", XMLNAME = "MaxMessagesUp");

Property MaxMessagesDown As %String(MAXLEN = "", XMLNAME = "MaxMessagesDown");

Property PollMode As %String(MAXLEN = "", XMLNAME = "PollMode");

Property ClientLogLevel As %String(MAXLEN = "", XMLNAME = "ClientLogLevel");

Storage Default
{
<Data name="ConfigFileDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClientIdentity</Value>
</Value>
<Value name="3">
<Value>ClientAuthentication</Value>
</Value>
<Value name="4">
<Value>InterfaceRoot</Value>
</Value>
<Value name="5">
<Value>CertPath</Value>
</Value>
<Value name="6">
<Value>LogPath</Value>
</Value>
<Value name="7">
<Value>WorkPath</Value>
</Value>
<Value name="8">
<Value>PrimaryURL</Value>
</Value>
<Value name="9">
<Value>SecondaryURL</Value>
</Value>
<Value name="10">
<Value>CollectReport</Value>
</Value>
<Value name="11">
<Value>DelayReport</Value>
</Value>
<Value name="12">
<Value>TransferReport</Value>
</Value>
<Value name="13">
<Value>PollReport</Value>
</Value>
<Value name="14">
<Value>SaveSent</Value>
</Value>
<Value name="15">
<Value>ServerRetry</Value>
</Value>
<Value name="16">
<Value>SignalPath</Value>
</Value>
<Value name="17">
<Value>ProxyPath</Value>
</Value>
<Value name="18">
<Value>PollPeriod</Value>
</Value>
<Value name="19">
<Value>FilePoll</Value>
</Value>
<Value name="20">
<Value>ServerPoll</Value>
</Value>
<Value name="21">
<Value>MaxMessages</Value>
</Value>
<Value name="22">
<Value>MaxMessagesUp</Value>
</Value>
<Value name="23">
<Value>MaxMessagesDown</Value>
</Value>
<Value name="24">
<Value>PollMode</Value>
</Value>
<Value name="25">
<Value>ClientLogLevel</Value>
</Value>
</Data>
<DataLocation>^EnsITK.DTSConfigFileDefDataD</DataLocation>
<DefaultData>ConfigFileDefaultData</DefaultData>
<IdLocation>^EnsITK.DTSConfigFileDefDataD</IdLocation>
<IndexLocation>^EnsITK.DTSConfigFileDefDataI</IndexLocation>
<StreamLocation>^EnsITK.DTSConfigFileDefDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
