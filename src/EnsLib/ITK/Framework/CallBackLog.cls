/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This is a log of Asynchronous Requests and Responses.
Class EnsLib.ITK.Framework.CallBackLog Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

/******************************************************************************
$Id$

Description: This is a log of Asynchronous Requests and Responses.
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Property RequestMessageId As %String [ Required ];

Property RelatedMessageId As %String [ Required ];

Property RelatedMessageSentTo As %String [ Required ];

Property RequestSessionId As %String [ Required ];

Property ResponseMessageId As %String;

Property FaultMessageId As %String;

Property Status As %Integer(DISPLAYLIST = ",Pending,Complete,Fault", VALUELIST = ",0,1,2");

Index RequestMessageIdIndex On RelatedMessageId [ IdKey, Unique ];

Index RequestToResponseIndex On (RequestMessageId, RelatedMessageSentTo) [ Unique ];

Property CallBackLogCreated As %TimeStamp;

Storage Default
{
<Data name="CallBackLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RequestMessageId</Value>
</Value>
<Value name="3">
<Value>ResponseMessageId</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>FaultMessageId</Value>
</Value>
<Value name="6">
<Value>RequestSessionId</Value>
</Value>
<Value name="7">
<Value>CallBackLogCreated</Value>
</Value>
<Value name="8">
<Value>ITKRequestMessageId</Value>
</Value>
<Value name="9">
<Value>ResponseFrom</Value>
</Value>
<Value name="10">
<Value>RelatedMessageSentTo</Value>
</Value>
</Data>
<DataLocation>^EnsITK.CallBackLogD</DataLocation>
<DefaultData>CallBackLogDefaultData</DefaultData>
<IdLocation>^EnsITK.CallBackLogD</IdLocation>
<IndexLocation>^EnsITK.CallBackLogI</IndexLocation>
<StreamLocation>^EnsITK.CallBackLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
