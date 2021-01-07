/// Used for updating the MPIID 
Class HS.Message.IDUpdateNotificationRequest Extends (HS.Util.EnsRequest, HS.Types.RequestInfo) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNORENULL = "inputonly";

/// A collection of Identifiers (with assigning authority) related to the new MPI ID
Property Identifiers As list Of HS.Types.Identifier(STORAGEDEFAULT = "list");

/// A collection of Identifiers (with assigning authority) before the Update.  Used to identify 
/// systems to send an update.  Interested in AA = XXX but the ID for XXX is being removed need to
/// send an update.  Used by the patient registry for sending to PIX Manager
Property PriorIdentifiers As list Of HS.Types.Identifier(STORAGEDEFAULT = "list");

/// The master/patient index id
Property MPIID As %String;

/// The previous master/patient index id
Property PriorMPIID As %String;

Property PatientDemographics As HS.Message.PatientSearchMatch;

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IDUpdateNotificationRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IDUpdateNotificationRequest.CustomAuditInfo"</Subscript>
</Data>
<Data name="IDUpdateNotificationRequestDefaultData">
<Subscript>"IDUpdateNotificationRequest"</Subscript>
<Value name="1">
<Value>Identifiers</Value>
</Value>
<Value name="2">
<Value>MPIID</Value>
</Value>
<Value name="3">
<Value>PriorMPIID</Value>
</Value>
<Value name="4">
<Value>AuthBy</Value>
</Value>
<Value name="5">
<Value>AuthType</Value>
</Value>
<Value name="6">
<Value>BTGReason</Value>
</Value>
<Value name="7">
<Value>RequestingUser</Value>
</Value>
<Value name="8">
<Value>RequestingUserRoles</Value>
</Value>
<Value name="9">
<Value>RequestingForProxyUserID</Value>
</Value>
<Value name="10">
<Value>RequestingForProxyID</Value>
</Value>
<Value name="11">
<Value>Signature</Value>
</Value>
<Value name="12">
<Value>RequestId</Value>
</Value>
<Value name="13">
<Value>RequestingGateway</Value>
</Value>
<Value name="14">
<Value>Type</Value>
</Value>
<Value name="15">
<Value>BreakTheGlass</Value>
</Value>
<Value name="16">
<Value>ClinicalTypes</Value>
</Value>
<Value name="17">
<Value>Consent</Value>
</Value>
<Value name="18">
<Value>PriorIdentifiers</Value>
</Value>
<Value name="19">
<Value>PatientDemographics</Value>
</Value>
<Value name="20">
<Value>SAMLData</Value>
</Value>
</Data>
<DefaultData>IDUpdateNotificationRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
