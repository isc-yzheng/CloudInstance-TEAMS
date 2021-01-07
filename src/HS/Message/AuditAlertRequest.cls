Class HS.Message.AuditAlertRequest Extends (HS.Util.EnsRequest, HS.Types.AuditAggregateInfo) [ Inheritance = right ]
{

Property AggregationId As %String;

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.AuditAlertRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="AuditAlertRequestDefaultData">
<Subscript>"AuditAlertRequest"</Subscript>
<Value name="1">
<Value>AggregationId</Value>
</Value>
<Value name="2">
<Value>EventDateTime</Value>
</Value>
<Value name="3">
<Value>UserName</Value>
</Value>
<Value name="4">
<Value>Roles</Value>
</Value>
<Value name="5">
<Value>InitiatingLogId</Value>
</Value>
<Value name="6">
<Value>InitiatedAt</Value>
</Value>
<Value name="7">
<Value>RecordedLogId</Value>
</Value>
<Value name="8">
<Value>RecordedAt</Value>
</Value>
<Value name="9">
<Value>EnsembleSessionId</Value>
</Value>
<Value name="10">
<Value>ATNAAuditMessageId</Value>
</Value>
<Value name="11">
<Value>MPIIDs</Value>
</Value>
<Value name="12">
<Value>MRNs</Value>
</Value>
<Value name="13">
<Value>EventType</Value>
</Value>
<Value name="14">
<Value>ProxyUserName</Value>
</Value>
<Value name="15">
<Value>Criteria</Value>
</Value>
<Value name="16">
<Value>DocumentId</Value>
</Value>
<Value name="17">
<Value>PatientName</Value>
</Value>
<Value name="18">
<Value>SourceURI</Value>
</Value>
<Value name="19">
<Value>DestinationURI</Value>
</Value>
<Value name="20">
<Value>EventSubType</Value>
</Value>
<Value name="21">
<Value>ProviderName</Value>
</Value>
<Value name="22">
<Value>ProviderId</Value>
</Value>
<Value name="23">
<Value>ActionCode</Value>
</Value>
<Value name="24">
<Value>Outcome</Value>
</Value>
<Value name="25">
<Value>SourceNetworkAccess</Value>
</Value>
<Value name="26">
<Value>DestinationNetworkAccess</Value>
</Value>
<Value name="27">
<Value>UserFullName</Value>
</Value>
<Value name="28">
<Value>AuditSourceID</Value>
</Value>
<Value name="29">
<Value>SubmissionSetUniqueID</Value>
</Value>
<Value name="30">
<Value>QueryRequestID</Value>
</Value>
<Value name="31">
<Value>ATNAMessage</Value>
</Value>
<Value name="32">
<Value>IsSource</Value>
</Value>
<Value name="33">
<Value>EventInfo</Value>
</Value>
<Value name="34">
<Value>ATNAMessageType</Value>
</Value>
</Data>
<DefaultData>AuditAlertRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
