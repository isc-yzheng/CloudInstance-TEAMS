/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Purges Callback Log.
Class EnsLib.ITK.Framework.Process.CallBackPurgeRoutine Extends Ens.BusinessProcess [ System = 4 ]
{

/******************************************************************************
$Id$

Description: Purges Callback Log.
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

/// Number of days Call Back items are held for before being purged.
/// Change Log:
/// Base Release: Rajiv Bhatia
Property PurgeDays As %Integer [ InitialExpression = 14 ];

Parameter SETTINGS = "PurgeDays";

Method OnRequest(request As %Library.Persistent, Output response As %Library.Persistent) As %Status
{
	Set tStatus = $$$OK
 	Set $ZT="OnError"

	//Purge Call Back Log where the difference between CallBackLogCreated and sysdate is > PurgeDays
	SET myquery = "DELETE FROM EnsLib_ITK_Framework.CallBackLog where DATEDIFF('d',CallBackLogCreated,SYSDATE) > " _ ..PurgeDays
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
<Data name="CallBackPurgeRoutineDefaultData">
<Subscript>"CallBackPurgeRoutine"</Subscript>
<Value name="1">
<Value>PurgeCallBackLogAfterDays</Value>
</Value>
<Value name="2">
<Value>PurgeSuspendedItemsAfterDays</Value>
</Value>
<Value name="3">
<Value>PurgeDays</Value>
</Value>
</Data>
<DefaultData>CallBackPurgeRoutineDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
