/// During the SyncRequest we are either requesting transactions or setting the last transaction
/// if SetLastTransaction=1 then we are setting the last transaction and not getting, otherwise
/// we are getting either the latest transactions (GetAllTransaction=0) or all transactions (GetAllTransactions=1)
Class HS.Message.Sync Extends HS.Util.EnsRequest [ ClassType = persistent, ProcedureBlock ]
{

Parameter XMLIGNORENULL = "inputonly";

/// GetAllTransactions =1 will return the sync file with All available records
Property GetAllTransactions As %Boolean [ InitialExpression = 0 ];

/// SetLastTransaction uses the LastTransaction from the response to indicate what has been received and updated
Property SetLastTransaction As %Boolean;

/// Set the value = the value from the response for the transactions just processed.
Property LastTransaction As %Integer;

Property SystemGUID As %String [ InitialExpression = {##class(%SYS.System).InstanceGUID()} ];

Property SystemNamespace As %String [ InitialExpression = {$namespace} ];

/// System making request (allows locating the end point on the Hub)
Property NetworkName As %String(MAXLEN = "");

Property SyncFile As %Stream.GlobalBinary;

/// Used to track the status of send operation, error reporting is being suppressed to reduce logging
/// but the service needs to know whether to stop trying to send.
Property SendStatus As %Status [ InitialExpression = 1 ];

/// Used to prevent looping, when a sync fails issue a full transaction set, but don't want to issue it again if that fails
Property Retry As %Boolean [ InitialExpression = 0 ];

/// With a GetAllTransactions, multiple transactions will likely be sent and the productions should be kept quiesced over the entire set
Property GetAllFinished As %Boolean [ InitialExpression = 1 ];

Storage Default
{
<Data name="SyncDefaultData">
<Subscript>"Sync"</Subscript>
<Value name="1">
<Value>GetAllTransactions</Value>
</Value>
<Value name="2">
<Value>SetLastTransaction</Value>
</Value>
<Value name="3">
<Value>LastTransaction</Value>
</Value>
<Value name="4">
<Value>SystemGUID</Value>
</Value>
<Value name="5">
<Value>SystemNamespace</Value>
</Value>
<Value name="6">
<Value>NetworkName</Value>
</Value>
<Value name="7">
<Value>SyncFile</Value>
</Value>
<Value name="8">
<Value>SendStatus</Value>
</Value>
<Value name="9">
<Value>Retry</Value>
</Value>
<Value name="10">
<Value>GetAllFinished</Value>
</Value>
</Data>
<DefaultData>SyncDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
