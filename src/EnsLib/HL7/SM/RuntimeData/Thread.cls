/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This class maps the follow SequenceManager global:
///  ^EnsHL7.SM(ConfigName,"thread",Type,Facility,Application,Thread,"next") = next message sequence number
///  ^EnsHL7.SM(ConfigName,"thread",Type,Facility,Application,Thread,"list",sequence) = $lb($lb((MessageId,SessionId,PrimaryRequestHeaderId,MessageClassName),...)
///  ^EnsHL7.SM(ConfigName,"thread",Type,Facility,Application,Thread,"wait") = $ZH time we started to wait
/// 
Class EnsLib.HL7.SM.RuntimeData.Thread Extends %Persistent [ Final, System = 4 ]
{

/// Configuration parent object
Relationship ConfigName As EnsLib.HL7.SM.RuntimeData.Configuration [ Cardinality = parent, Inverse = Thread ];

/// Type is either Sender or Receiver
Property Type As %String;

/// Facility name
Property Facility As %String;

/// Application name
Property Application As %String;

/// Thread is either main or resend
Property Thread As %String;

/// The next expected sequence number
Property NextSequenceNumber;

/// The time we start to wait
Property WaitStartTime As %String;

/// List of waiting sequence numbers
Relationship WaitingSequenceNumbers As EnsLib.HL7.SM.RuntimeData.WaitingSequenceNumbers [ Cardinality = children, Inverse = Thread ];

Index IdIndex On (Type, Facility, Application, Thread) [ IdKey ];

Storage Default
{
<Data name="NextSequenceNumberData">
<Attribute>NextSequenceNumber</Attribute>
<Structure>node</Structure>
<Subscript>"next"</Subscript>
</Data>
<Data name="WaitStartTimeData">
<Attribute>WaitStartTime</Attribute>
<Structure>node</Structure>
<Subscript>"wait"</Subscript>
</Data>
<DataLocation>{%%PARENT}("thread")</DataLocation>
<IdLocation>^HL7.SM.id("Thread")</IdLocation>
<IndexLocation>^HL7.SM.index</IndexLocation>
<StreamLocation>^HL7.SM.stream</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
