Class HS.AU.HI.Management.History Extends (%SerialObject, %XML.Adaptor)
{

Property Number As %String(MAXLEN = 255);

/// Active, Deceased, Retired, Expired, Resolved
Property Status As %String;

/// List of values sent $lb($lb(Sex,M),$lb(GivenName,Bob),...)
Property RequestValues As %String(CONTENT = "MIXED", MAXLEN = "");

Property RequestStatus As %Status;

Property Validation As %TimeStamp [ InitialExpression = {$ZDateTime($ZTimeStamp, 3, 1, 2)} ];

Storage Default
{
<Data name="HistoryState">
<Value name="1">
<Value>Number</Value>
</Value>
<Value name="2">
<Value>Status</Value>
</Value>
<Value name="3">
<Value>RequestValues</Value>
</Value>
<Value name="4">
<Value>RequestStatus</Value>
</Value>
<Value name="5">
<Value>Validation</Value>
</Value>
</Data>
<State>HistoryState</State>
<StreamLocation>^HS.AU.HI.Management.HistoryS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
