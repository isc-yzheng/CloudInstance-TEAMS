Class HS.Message.ECRQueryRequest Extends (HS.Util.EnsRequest, HS.Types.RequestInfo)
{

Parameter XMLIGNORENULL = "inputonly";

/// MPIID of the record we're fetching
Property MPIID As %String;

/// Facility for the record we're fetching
Property Facility As HS.Types.Facility;

/// Patient MRN / Identitifier
Property MRN As HS.Types.MRN;

/// Assigning Authority for the MRN
Property AssigningAuthority As %String;

///  Other identifiers with assigning authority
Property Identifiers As list Of HS.Types.Identifier(STORAGEDEFAULT = "list");

/// This is a message returned by the external system when we last queried this record, which
/// is being passed for this query, so that they can give us selective updates.
/// It typically would have some sort of timestamp.
/// For CacheType=NotifyAndQuery or ExpireAndQuery
Property LastResponseString As %String(MAXLEN = "");

/// If the context in which this request is used it for patient activity (fetching an SDA
/// for viewing, etc.), then this will be set to True.  It interacts with the ECR Manager
/// setting ScheduleQueryRefresh
Property Activity As %Boolean;

/// For a NotifyAndQuery type edge.  This contains a list of all of the Notification properties
/// that have been received on ECRUpdateRequests sent by the data source since the last time
/// an ECRQueryRequest has been completed.  This is a handswhaking mechanism to allow a NotifyAndQuery
/// source to send only incremental updates.
Property Notifications As list Of %String(MAXLEN = "");

/// Used for pure query edges
Property TempAggregationKey As %String;

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.ECRQueryRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.ECRQueryRequest.CustomAuditInfo"</Subscript>
</Data>
<Data name="ECRQueryRequestDefaultData">
<Subscript>"ECRQueryRequest"</Subscript>
<Value name="1">
<Value>AuthBy</Value>
</Value>
<Value name="2">
<Value>AuthType</Value>
</Value>
<Value name="3">
<Value>BTGReason</Value>
</Value>
<Value name="4">
<Value>AssigningAuthority</Value>
</Value>
<Value name="5">
<Value>LastResponseString</Value>
</Value>
<Value name="6">
<Value>RequestingForProxyUserID</Value>
</Value>
<Value name="7">
<Value>RequestingForProxyID</Value>
</Value>
<Value name="8">
<Value>Signature</Value>
</Value>
<Value name="9">
<Value>RequestId</Value>
</Value>
<Value name="10">
<Value>RequestingGateway</Value>
</Value>
<Value name="11">
<Value>Type</Value>
</Value>
<Value name="12">
<Value>BreakTheGlass</Value>
</Value>
<Value name="13">
<Value>ClinicalTypes</Value>
</Value>
<Value name="14">
<Value>Consent</Value>
</Value>
<Value name="15">
<Value>Facility</Value>
</Value>
<Value name="16">
<Value>MRN</Value>
</Value>
<Value name="17">
<Value>RequestingUser</Value>
</Value>
<Value name="18">
<Value>RequestingUserRoles</Value>
</Value>
<Value name="19">
<Value>Activity</Value>
</Value>
<Value name="20">
<Value>SAMLData</Value>
</Value>
<Value name="21">
<Value>Notifications</Value>
</Value>
<Value name="22">
<Value>MPIID</Value>
</Value>
<Value name="23">
<Value>Identifiers</Value>
</Value>
<Value name="24">
<Value>TempAggregationKey</Value>
</Value>
</Data>
<DefaultData>ECRQueryRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
