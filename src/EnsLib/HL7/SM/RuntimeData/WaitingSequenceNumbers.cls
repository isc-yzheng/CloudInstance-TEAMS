/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This class projects the "list" child node under EnsLib.HL7.SM.RuntimeData.Thread
/// The global structure is:
///  ^EnsHL7.SM(ConfigName,"thread",Type,Facility,Application,Thread,"list",sequencenumber) = $lb($lb((MessageId,SessionId,PrimaryRequestHeaderId,MessageClassName),...)
/// 
Class EnsLib.HL7.SM.RuntimeData.WaitingSequenceNumbers Extends %Persistent [ Final, System = 4 ]
{

/// The sequence number in the waiting list
Property SequenceNumber As %String;

/// List of messages of this sequence number
Property MessageListData As %List;

/// This is the parent Thread object 
Relationship Thread As EnsLib.HL7.SM.RuntimeData.Thread [ Cardinality = parent, Inverse = WaitingSequenceNumbers ];

Index IdIndex On SequenceNumber [ IdKey ];

Storage Default
{
<Data name="WaitingSequenceNumbersData">
<Attribute>MessageListData</Attribute>
<Structure>node</Structure>
</Data>
<DataLocation>{%%PARENT}("list")</DataLocation>
<IdLocation>^EnsHL7.SM.id</IdLocation>
<IndexLocation>^EnsHL7.SM.index</IndexLocation>
<StreamLocation>^EnsHL7.SM.stream</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
