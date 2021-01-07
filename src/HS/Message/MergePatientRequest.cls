Class HS.Message.MergePatientRequest Extends (HS.Util.EnsRequest, HS.Types.RequestInfo) [ ClassType = persistent, ProcedureBlock ]
{

/// Default response class
Parameter RESPONSECLASSNAME As %String = "HS.Message.MergePatientResponse";

/// Facility for this patient info
Property Facility As HS.Types.Facility;

/// Assigning Authority for the MRN
Property AssigningAuthority As %String;

/// This patient's MRN (from the above assigning authority)
Property MRN As HS.Types.MRN;

/// Prior Assigning Authority for the MRN
Property PriorAssigningAuthority As %String;

/// This patient's prior MRN (from the above prior assigning authority)
Property PriorMRN As HS.Types.MRN;

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.MergePatientRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.MergePatientRequest.CustomAuditInfo"</Subscript>
</Data>
<Data name="MergePatientRequestDefaultData">
<Subscript>"MergePatientRequest"</Subscript>
<Value name="1">
<Value>Facility</Value>
</Value>
<Value name="2">
<Value>AssigningAuthority</Value>
</Value>
<Value name="3">
<Value>MRN</Value>
</Value>
<Value name="4">
<Value>PriorAssigningAuthority</Value>
</Value>
<Value name="5">
<Value>PriorMRN</Value>
</Value>
<Value name="6">
<Value>AuthBy</Value>
</Value>
<Value name="7">
<Value>AuthType</Value>
</Value>
<Value name="8">
<Value>BTGReason</Value>
</Value>
<Value name="9">
<Value>RequestingUser</Value>
</Value>
<Value name="10">
<Value>RequestingUserRoles</Value>
</Value>
<Value name="11">
<Value>RequestingForProxyUserID</Value>
</Value>
<Value name="12">
<Value>RequestingForProxyID</Value>
</Value>
<Value name="13">
<Value>Signature</Value>
</Value>
<Value name="14">
<Value>RequestId</Value>
</Value>
<Value name="15">
<Value>RequestingGateway</Value>
</Value>
<Value name="16">
<Value>Type</Value>
</Value>
<Value name="17">
<Value>BreakTheGlass</Value>
</Value>
<Value name="18">
<Value>ClinicalTypes</Value>
</Value>
<Value name="19">
<Value>Consent</Value>
</Value>
<Value name="20">
<Value>SAMLData</Value>
</Value>
</Data>
<DefaultData>MergePatientRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
