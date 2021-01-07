/// Request object which will be used with a transformation to produce a valid DeleteDocumentSet transaction for the XDSb.Registry
Class HS.Message.IHE.XDSb.DeleteDocumentSetRequest Extends (HS.Util.EnsRequest, HS.Types.RequestInfo, HS.Message.XMLMessage) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// Default response class
Parameter RESPONSECLASSNAME As %String = "HS.Message.IHE.XDSb.DeleteDocumentSetResponse";

Property ObjectRefs As list Of %String(MAXLEN = 255);

/// for the administrator an array of document unique id's 
/// for the repository an array of document unique id's where the value is the repository unique id 
Property UniqueIdentifiers As array Of %String(MAXLEN = 256, XMLNAME = "UniqueIdentifier", XMLPROJECTION = "ELEMENT");

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.XDSb.DeleteDocumentSetRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.XDSb.DeleteDocumentSetRequest.CustomAuditInfo"</Subscript>
</Data>
<Data name="DeleteDocumentSetRequestDefaultData">
<Subscript>"DeleteDocumentSetRequest"</Subscript>
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
<Value>RequestingUser</Value>
</Value>
<Value name="5">
<Value>RequestingUserRoles</Value>
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
<Value>SAMLData</Value>
</Value>
<Value name="13">
<Value>BreakTheGlass</Value>
</Value>
<Value name="14">
<Value>ClinicalTypes</Value>
</Value>
<Value name="15">
<Value>Consent</Value>
</Value>
<Value name="16">
<Value>ObjectRefs</Value>
</Value>
<Value name="17">
<Value>DocType</Value>
</Value>
<Value name="18">
<Value>Name</Value>
</Value>
<Value name="19">
<Value>ContentStream</Value>
</Value>
<Value name="20">
<Value>StreamCollection</Value>
</Value>
<Value name="21">
<Value>SOAPFault</Value>
</Value>
</Data>
<Data name="UniqueIdentifiers">
<Attribute>UniqueIdentifiers</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.XDSb.DeleteDocumentSetRequest.UniqueIdentifiers"</Subscript>
</Data>
<DefaultData>DeleteDocumentSetRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
