/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This class maps the follow SequenceManager global:
///  ^EnsHL7.SM(ConfigName,"output",Type,Facility,Application) = next sequence number to be used for output messages
/// 
///    Type is derived from OutputSequenceNumberIndexField.
///    If OutputSequenceNumberIndexField is Sender, SendingFacility or SendingApplication, then Type is Sender
///    If OutputSequenceNumberIndexField is Receiver, ReceivingFacility or ReceivingApplication, then Type is Receiver
///    If OutputSequenceNumberIndexField is Auto, then we look at PerformOutputTransformationOn
///        If PerformOutputTransformationOn is Sender or SequenceNumberOnly, then Type is Sender
///        If PerformOutputTransformationOn is Receiver, then Type is Receiver
///        If PerformOutputTransformationOn is None, then we do not increment the outbound sequence number.
/// 
Class EnsLib.HL7.SM.RuntimeData.Outbound Extends %Persistent [ Final, System = 4 ]
{

/// Configuration parent object
Relationship ConfigName As EnsLib.HL7.SM.RuntimeData.Configuration [ Cardinality = parent, Inverse = Outbound ];

/// Type is either Sender or Receiver
Property Type As %String;

/// Facility name
Property Facility As %String;

/// Application name
Property Application As %String;

/// The next output sequence number
Property NextSequenceNumber;

Index IdIndex On (Type, Facility, Application) [ IdKey ];

Storage Default
{
<Data name="NextSequenceNumber">
<Attribute>NextSequenceNumber</Attribute>
<Structure>node</Structure>
</Data>
<DataLocation>{%%PARENT}("output")</DataLocation>
<IdLocation>^HL7.SM.id("Thread")</IdLocation>
<IndexLocation>^HL7.SM.index</IndexLocation>
<StreamLocation>^HL7.SM.stream</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
