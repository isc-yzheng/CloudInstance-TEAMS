/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This class is used for responsible for recording the log of incoming control and data files.
Class EnsLib.ITK.DTS.Framework.FileLog Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

Property FileName As %String(MAXLEN = "");

Property Sender As %String;

Property Destination As %String;

Property WorkflowId As %String;

Property TrackingId As %String;

Property DTSId As %String;

Property AddressType As %String;

Property MessageType As %String;

Property Version As %String;

Property Compress As %String;

Property Encrypted As %String;

Property Payload As %GlobalCharacterStream;

Index FileNameIdx On FileName [ IdKey, Unique ];

Storage Default
{
<Data name="FileLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FileId</Value>
</Value>
<Value name="3">
<Value>FileName</Value>
</Value>
<Value name="4">
<Value>Sender</Value>
</Value>
<Value name="5">
<Value>Destination</Value>
</Value>
<Value name="6">
<Value>WorkflowId</Value>
</Value>
<Value name="7">
<Value>TrackingId</Value>
</Value>
<Value name="8">
<Value>DTSId</Value>
</Value>
<Value name="9">
<Value>AddressType</Value>
</Value>
<Value name="10">
<Value>MessageType</Value>
</Value>
<Value name="11">
<Value>Version</Value>
</Value>
<Value name="12">
<Value>Compress</Value>
</Value>
<Value name="13">
<Value>Encrypted</Value>
</Value>
<Value name="14">
<Value>Payload</Value>
</Value>
</Data>
<DataLocation>^EnsITK.DTSFileLogD</DataLocation>
<DefaultData>FileLogDefaultData</DefaultData>
<IdLocation>EnsITK.DTSFileLogD</IdLocation>
<IndexLocation>EnsITK.DTSFileLogI</IndexLocation>
<StreamLocation>EnsITK.DTSFileLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
