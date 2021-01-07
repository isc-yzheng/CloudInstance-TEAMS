Class HS.AU.IHI.Management.History Extends HS.AU.HI.Management.History
{

Parameter XMLTYPE = "IHIManagementHistory";

/// Verified, Unverified, Provisional
Property RecordStatus As %String;

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
<Value name="6">
<Value>RecordStatus</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
