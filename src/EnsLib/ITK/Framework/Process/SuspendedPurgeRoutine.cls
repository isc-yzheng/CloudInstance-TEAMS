/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Purges SubscriptionPullLog.
Class EnsLib.ITK.Framework.Process.SuspendedPurgeRoutine Extends Ens.BusinessProcess [ System = 4 ]
{

/******************************************************************************
$Id$

Description: Purges SubscriptionPullLog.
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

/// Number of days suspended messages are held for before being purged.
/// Change Log:
/// Base Release: Rajiv Bhatia
Property PurgeDays As %Integer [ InitialExpression = 14 ];

/// Number of days suspended messages with an "Await Receipt Confirmation" status are held before being changed back to an "Un-Collected" status.
/// Change Log:
/// Base Release: Rajiv Bhatia
Property ReSetToUnCollectedInNoDays As %Integer [ InitialExpression = 14 ];

Parameter SETTINGS = "PurgeDays,ReSetToUnCollectedInNoDays";

Method OnRequest(request As %Library.Persistent, Output response As %Library.Persistent) As %Status
{
	Set tStatus = $$$OK

 	Set $ZT="OnError"

	//Purge Suspended items which hae a status of ReceiptConfirmed  
	SET myquery = "DELETE FROM EnsLib_ITK_Framework.SubscriptionPullLog where SubscriptionPullStatus = '2'"
	SET tStatement = ##class(%SQL.Statement).%New()
	SET tStatus = tStatement.%Prepare(myquery)
	SET rset = tStatement.%Execute()

	//Purge Suspended items where which are older than No of PurgeDays
	SET myquery = "DELETE FROM EnsLib_ITK_Framework.SubscriptionPullLog where DATEDIFF('d',SubscriptionPullMsgCreatedDate,SYSDATE) > " _ ..PurgeDays
	SET tStatement = ##class(%SQL.Statement).%New()
	SET tStatus = tStatement.%Prepare(myquery)
	SET rset = tStatement.%Execute()
	
	//Change status back to Un-Collected if left in an Await Receipt Confirmation state after X No of days
	SET myquery = "UPDATE EnsLib_ITK_Framework.SubscriptionPullLog SET SubscriptionPullStatus = '0' where SubscriptionPullStatus = '1' AND DATEDIFF('d',SubscriptionPullMsgStatusUpdatedDate,SYSDATE) > " _ ..ReSetToUnCollectedInNoDays
	SET tStatement = ##class(%SQL.Statement).%New()
	SET tStatus = tStatement.%Prepare(myquery)
	SET rset = tStatement.%Execute()
  
OnExit
	If $$$ISERR(tStatus) $$$LOGERROR(tStatus)
  	Quit tStatus
  
OnError
	$$$LOGERROR($ZERROR)
	Set $ZT=""
	Goto OnExit
}

Storage Default
{
<Data name="SuspendedPurgeRoutineDefaultData">
<Subscript>"SuspendedPurgeRoutine"</Subscript>
<Value name="1">
<Value>PurgeSuspendedItemsAfterDays</Value>
</Value>
<Value name="2">
<Value>PurgeDays</Value>
</Value>
<Value name="3">
<Value>ReSetToUnCollectedInNoDays</Value>
</Value>
</Data>
<DefaultData>SuspendedPurgeRoutineDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
