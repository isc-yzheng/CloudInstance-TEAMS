/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

/// This holds the list of Web Services that a Consumer subscribes to from different Senders.
Class EnsLib.ITK.Setup.SubscriptionRules Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

/******************************************************************************
$Id$

Description: This holds the list of Web Services that a Consumer subscribes to from different Senders.
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Property SourceApplication As %String [ Required ];

Property SourceService As %String [ Required ];

Property Subscriber As %String [ Required ];

Index EventSourceIndex On (SourceApplication, SourceService);

Index UniqueIndex On (SourceApplication, SourceService, Subscriber) [ Unique ];

ClassMethod GetSubscribers(pSourceApp As %String, pService As %String) As %String
{
	Set tList = ""
 Set $ZTRAP = "OnError"
	Set tResult = ##class(%ResultSet).%New("EnsLib.ITK.Setup.SubscriptionRules:GetSubscriberForEventSource")
	Do tResult.Execute(pSourceApp, pService)
	While (tResult.Next(.sc)) { 
		Set tList = $S(tList="":tResult.Data("Subscriber") ,1:tList_","_ tResult.Data("Subscriber"))
	}
	
	Set $ZTRAP = ""
	
Exit
	Quit tList
	
OnError
	Set $ZTRAP = ""
	$$$LOGERROR($ZERROR)
	Goto Exit
}

ClassMethod GetAllSubscribers() As %String
{
	Set tList = ""
 Set $ZTRAP = "OnError"
	Set tResult = ##class(%ResultSet).%New("EnsLib.ITK.Setup.SubscriptionRules:GetUniqueSubscribers")
	Do tResult.Execute()
	While (tResult.Next(.sc)) { 
		Set tList = $S(tList="":tResult.Data("Subscriber") ,1:tList_","_ tResult.Data("Subscriber"))

	}
	Set $ZTRAP = ""
	
Exit
	Quit tList
	
OnError
	Set $ZTRAP = ""
	$$$LOGERROR($ZERROR)
	Goto Exit
}

Query GetSubscriberForEventSource(pSource As %String = "", pService As %String = "") As %SQLQuery
{
SELECT Subscriber FROM EnsLib_ITK_Setup.SubscriptionRules
 WHERE (SourceService = :pService AND SourceApplication = :pSource)
}

Query GetUniqueSubscribers() As %SQLQuery
{
SELECT Distinct %Exact(Subscriber) As Subscriber FROM EnsLib_ITK_Setup.SubscriptionRules
}

Query GetSubscribedServices(pSource As %String = "", pSubscriber As %String = "") As %SQLQuery
{
	 SELECT SourceService FROM EnsLib_ITK_Setup.SubscriptionRules
	  WHERE (SourceApplication = :pSource AND Subscriber = :pSubscriber)
}

Storage Default
{
<Data name="SubscriptionRulesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EventType</Value>
</Value>
<Value name="3">
<Value>SourceApplication</Value>
</Value>
<Value name="4">
<Value>Subscriber</Value>
</Value>
<Value name="5">
<Value>MessageCount</Value>
</Value>
<Value name="6">
<Value>ServicePattern</Value>
</Value>
<Value name="7">
<Value>SourceService</Value>
</Value>
</Data>
<DataLocation>^EnsITK.Setup.SubscriptionRulesD</DataLocation>
<DefaultData>SubscriptionRulesDefaultData</DefaultData>
<IdLocation>^EnsITK.Setup.SubscriptionRulesD</IdLocation>
<IndexLocation>^EnsITK.Setup.SubscriptionRulesI</IndexLocation>
<StreamLocation>^EnsITK.Setup.SubscriptionRulesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
