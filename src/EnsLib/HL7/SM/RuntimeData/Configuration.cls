/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Documentation of the Sequence Manager runtime global ^EnsHL7.SM:
/// <pre>
/// 
/// The thread nodes:
/// =================
///  ^EnsHL7.SM(ConfigName,"thread",Type,Facility,Application,Thread,"next") = next message sequence number
///  ^EnsHL7.SM(ConfigName,"thread",Type,Facility,Application,Thread,"list",sequence) = $lb($lb((MessageId,SessionId,PrimaryRequestHeaderId,MessageClassName),...)
///  ^EnsHL7.SM(ConfigName,"thread",Type,Facility,Application,Thread,"wait") = $ZH time we started to wait
/// 
/// The index nodes:
/// ================
///  ^EnsHL7.SM(ConfigName,"wait index","thread",Type,Facility,Application,Thread) ="" Index on waiting threads. 
/// 
/// For Control ID and Sequence number duplication check:
/// 
///  ^EnsHL7.SM(ConfigName,"index","ct",Type,Facility,Application,control_id,message_id) = time
///  ^EnsHL7.SMI("ResendIndex",ConfigName,time,counter)=$LB("tc","Sender",Facility,Application,control_id,message_id)
///  ^EnsHL7.SM(ConfigName,"index","st",Type,Facility,Application,sequence_number) = time
///  ^EnsHL7.SMI("ResendIndex",ConfigName,time,counter)=$LB("ts",Type,Facility,Application,sequence_number)
/// 
/// The outbound sequence number:
/// =============================
///  ^EnsHL7.SM(ConfigName,"output",Type,Facility,Application) = next sequence number to be used for output messages
///    Type is derived from OutputSequenceNumberIndexField.
///    If OutputSequenceNumberIndexField is Sender, SendingFacility or SendingApplication, then Type is Sender
///    If OutputSequenceNumberIndexField is Receiver, ReceivingFacility or ReceivingApplication, then Type is Receiver
///    If OutputSequenceNumberIndexField is Auto, then we look at PerformOutputTransformationOn
///        If PerformOutputTransformationOn is Sender or SequenceNumberOnly, then Type is Sender
///        If PerformOutputTransformationOn is Receiver, then Type is Receiver
///        If PerformOutputTransformationOn is None, then we do not increment the outbound sequence number.
/// 
/// Timer set:
/// ==========
///  ^EnsHL7.SM(ConfigName,"timer",BusinessProcessID) = ""
///    This indicates a timer has been set on behave of a particular BP.
///    The existence of this node would prevent other BP's from setting a duplicated timer.
/// 
/// Legend:
///          Type : "Sender", "Receiver"
///      Facility : runtime variable
///   Application : runtime variable
///        Thread : "main", "resend"
///    ConfigName : runtime variable
/// 
///   
/// Documentation of the Sequence Manager metric global ^EnsHL7.SM.metric:
/// 
///  ^EnsHL7.SM.metric("total")               = total messages processed
///  ^EnsHL7.SM.metric("duplicated")          = total duplicated message count
///  ^EnsHL7.SM.metric("expired")             = total expired messages count
///  ^EnsHL7.SM.metric("outofsequence")       = total out-of-sequence message count
///  ^EnsHL7.SM.metric("duplicated",index)    = duplicated message
///  ^EnsHL7.SM.metric("expired",index)       = expired message
///  ^EnsHL7.SM.metric("outofsequence",index) = out-of-sequence message
/// 
/// </pre>
Class EnsLib.HL7.SM.RuntimeData.Configuration Extends %Persistent [ Final, System = 4 ]
{

/// The name of the configuration
Property Name As %String;

/// The thread sub-objects
Relationship Thread As EnsLib.HL7.SM.RuntimeData.Thread [ Cardinality = children, Inverse = ConfigName ];

/// The outbound sub-objects
Relationship Outbound As EnsLib.HL7.SM.RuntimeData.Outbound [ Cardinality = children, Inverse = ConfigName ];

Index IdIndex On Name [ IdKey ];

Storage Default
{
<DataLocation>^EnsHL7.SM</DataLocation>
<DefaultData>ConfigurationData</DefaultData>
<IdLocation>^EnsHL7.SM.id</IdLocation>
<IndexLocation>^HL7.SM.index</IndexLocation>
<StreamLocation>^EnsHL7.SM.stream</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
