/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Stores the URIs for different Services exposed by a Consumer. This is used when ITK sends a Web Request to a Consumer.
Class EnsLib.ITK.Setup.ConsumerServiceRegistry Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

/******************************************************************************
$Id$

Description: Stores the URIs for different Services exposed by a Consumer. This is used when ITK sends a Web Request to a Consumer.
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Property ConsumerName As %String [ Required ];

Property ServiceName As %String [ Required ];

Property PartialLogicalEndpoint As %String(MAXLEN = 250) [ Required ];

Property InvocationPattern As %String(VALUELIST = ",Asynchronous,Synchronous") [ Required ];

Property PartialPhysicalEndpoint As %String(MAXLEN = 250);

Index ConsumerEventIndex On (ConsumerName, ServiceName) [ IdKey, Unique ];

ClassMethod GetEndpoint(pAppName As %String, pServiceName As %String, pLogical As %Boolean = 0)
{
	Set tDeviceURL = ""
	
 Set $ZTRAP = "OnError"
	Set tAppName = $P(pAppName, ":", 1)
	Set tDeviceName = $P(pAppName, ":", 2)
	
	If (tDeviceName = "") {
		Set tConsumer = ##class(EnsLib.ITK.Setup.ConsumerServiceRegistry).%OpenId(tAppName _"||"_ pServiceName)
		If $ISOBJECT(tConsumer) {
			Set:pLogical=0 tDeviceURL = tConsumer.PartialPhysicalEndpoint
			Set:pLogical=1 tDeviceURL = tConsumer.PartialLogicalEndpoint
		}
	} Else {
		Set tConsumer = ##class(EnsLib.ITK.Setup.ConsumerServiceRegistry).%OpenId(tDeviceName _"||"_ pServiceName)
		If $ISOBJECT(tConsumer) {
			Set:pLogical=0 tDeviceURL = tConsumer.PartialPhysicalEndpoint
			Set:pLogical=1 tDeviceURL = tConsumer.PartialLogicalEndpoint
		}
	}
	
	Set $ZT = ""
	
Exit
	Quit tDeviceURL
	
OnError
	Set $ZT = ""
	GoTo Exit
}

Storage Default
{
<Data name="ConsumerServiceRegistryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ConsumerName</Value>
</Value>
<Value name="3">
<Value>EventType</Value>
</Value>
<Value name="4">
<Value>ServiceName</Value>
</Value>
<Value name="5">
<Value>ServiceURL</Value>
</Value>
<Value name="6">
<Value>RouteURL</Value>
</Value>
<Value name="7">
<Value>PartialLogicalEndpoint</Value>
</Value>
<Value name="8">
<Value>InvocationPattern</Value>
</Value>
<Value name="9">
<Value>PartialPhysicalEndpoint</Value>
</Value>
</Data>
<DataLocation>^EnsITK.ConsumerSvcRegistryD</DataLocation>
<DefaultData>ConsumerServiceRegistryDefaultData</DefaultData>
<IdLocation>^EnsITK.ConsumerSvcRegistryD</IdLocation>
<IndexLocation>^EnsITK.ConsumerSvcRegistryI</IndexLocation>
<StreamLocation>^EnsITK.ConsumerSvcRegistryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
