/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This class is used for responsible for recording the log of Transfer of DTS files.
Class EnsLib.ITK.DTS.Framework.TransferLog Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

Property FileName As %String(MAXLEN = "");

Property Sender As %String;

Property Destination As %String;

Property WorkflowId As %String;

Property TrackingId As %String;

Property DTSId As %String;

Property Result As EnsLib.ITK.DTS.Framework.Status;

Storage Default
{
<Data name="TransferLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FileName</Value>
</Value>
<Value name="3">
<Value>TransmissionSender</Value>
</Value>
<Value name="4">
<Value>TransmissionDestination</Value>
</Value>
<Value name="5">
<Value>ITKService</Value>
</Value>
<Value name="6">
<Value>ITKTrackingId</Value>
</Value>
<Value name="7">
<Value>TransmissionResult</Value>
</Value>
<Value name="8">
<Value>MessageId</Value>
</Value>
<Value name="9">
<Value>FileId</Value>
</Value>
<Value name="10">
<Value>Sender</Value>
</Value>
<Value name="11">
<Value>Destination</Value>
</Value>
<Value name="12">
<Value>WorkflowId</Value>
</Value>
<Value name="13">
<Value>TrackingId</Value>
</Value>
<Value name="14">
<Value>Result</Value>
</Value>
<Value name="15">
<Value>DTSId</Value>
</Value>
</Data>
<DataLocation>^EnsITK.DTSTransferLogD</DataLocation>
<DefaultData>TransferLogDefaultData</DefaultData>
<IdLocation>^EnsITK.DTSTransferLogD</IdLocation>
<IndexLocation>^EnsITK.DTSTransferLogI</IndexLocation>
<StreamLocation>^EnsITK.DTSTransferLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
