/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// A log of messages that are Suspended by Operations that are in Subscription Pull state.
Class EnsLib.ITK.Framework.SubscriptionPullLog Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

/******************************************************************************
$Id$

Description: A log of messages that are Suspended by Operations that are in Subscription Pull state.
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Property MessageHeadId As %Integer;

Property ServiceName As %String;

Property SubscriptionQueueName As %String;

Property SubscriptionPullStatus As %Integer(DISPLAYLIST = ",UnCollected,AwaitingReceiptConfirmation,ReceiptConfirmed", VALUELIST = ",0,1,2");

Property SubscriptionPullMsgSentDate As %TimeStamp;

Property SubscriptionPullMsgStatusUpdatedDate As %TimeStamp;

Property SubscriptionPullMsgCreatedDate As %TimeStamp;

Index QueueIndex On SubscriptionQueueName;

Index ServiceIndex On ServiceName;

Index MessageHeadIdIndex On MessageHeadId [ IdKey, Unique ];

Query GetMessagesForService(pQueueName As %String, pServiceName As %String, pStatus As %Integer) As %SQLQuery
{
SELECT MessageHeadId,ServiceName,SubscriptionPullMsgSentDate,SubscriptionPullStatus,SubscriptionQueueName FROM SubscriptionPullLog
 WHERE (SubscriptionQueueName = :pQueueName AND ServiceName = :pServiceName AND SubscriptionPullStatus = :pStatus)
 ORDER BY MessageHeadId
}

Query GetMessages(pQueueName As %String, pStatus As %Integer) As %SQLQuery
{
SELECT MessageHeadId,ServiceName,SubscriptionPullMsgSentDate,SubscriptionPullStatus,SubscriptionQueueName FROM SubscriptionPullLog
 WHERE (SubscriptionQueueName = :pQueueName AND SubscriptionPullStatus = :pStatus)
 ORDER BY MessageHeadId
}

Storage Default
{
<Data name="SubscriptionPullLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MessageBodyId</Value>
</Value>
<Value name="3">
<Value>SubscriptionPullMsgSentDate</Value>
</Value>
<Value name="4">
<Value>ServiceName</Value>
</Value>
<Value name="5">
<Value>SubscriptionQueueName</Value>
</Value>
<Value name="6">
<Value>SubscriptionPullStatus</Value>
</Value>
<Value name="7">
<Value>MessageHeadId</Value>
</Value>
<Value name="8">
<Value>SubscriptionPullMsgStatusUpdatedDate</Value>
</Value>
<Value name="9">
<Value>SubscriptionPullMsgCreatedDate</Value>
</Value>
</Data>
<DataLocation>^EnsITK.SubscriptionPullLogD</DataLocation>
<DefaultData>SubscriptionPullLogDefaultData</DefaultData>
<IdLocation>^EnsITK.SubscriptionPullLogD</IdLocation>
<IndexLocation>^EnsITK.SubscriptionPullLogI</IndexLocation>
<StreamLocation>^EnsITK.SubscriptionPullLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
