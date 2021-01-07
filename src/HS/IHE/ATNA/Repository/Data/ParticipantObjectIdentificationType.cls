/// Created from: c:/temp/healthcare-security-audit2.xsd
Class HS.IHE.ATNA.Repository.Data.ParticipantObjectIdentificationType Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter XMLNAME = "ParticipantObjectIdentificationType";

Parameter XMLSEQUENCE = 0;

/// The <var>MANAGEDEXTENT</var> parameter can be set to 0 (zero) to cause the Extent Manager
/// to ignore this class. If set to 1 then the Extent Manager will register globals used by
/// the class and detect collisions. Unmanaged extents (MANAGEDEXTENT = 0) are not checked.
/// Currently, only classes using default storage (%Storage.Persistent) can be managed.
Parameter MANAGEDEXTENT As INTEGER [ Constraint = "0,1", Flags = ENUM ] = 0;

Property ParticipantObjectIDTypeCode As HS.IHE.ATNA.Repository.Data.CodedValueType(XMLNAME = "ParticipantObjectIDTypeCode") [ Required ];

Property ParticipantObjectName As %String(MAXLEN = "", XMLNAME = "ParticipantObjectName");

Property ParticipantObjectQuery As %xsd.base64Binary(XMLNAME = "ParticipantObjectQuery");

Property ParticipantObjectDetail As list Of HS.IHE.ATNA.Repository.Data.TypeValuePairType(XMLNAME = "ParticipantObjectDetail", XMLPROJECTION = "ELEMENT") [ SqlListType = SUBNODE ];

Property ParticipantObjectID As %String(MAXLEN = "", XMLNAME = "ParticipantObjectID", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property ParticipantObjectTypeCode As %xsd.unsignedByte(VALUELIST = ",1,2,3,4", XMLNAME = "ParticipantObjectTypeCode", XMLPROJECTION = "ATTRIBUTE");

Property ParticipantObjectTypeCodeRole As %xsd.unsignedByte(VALUELIST = ",1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24", XMLNAME = "ParticipantObjectTypeCodeRole", XMLPROJECTION = "ATTRIBUTE");

Property ParticipantObjectDataLifeCycle As %xsd.unsignedByte(VALUELIST = ",1,2,3,4,5,6,7,8,9,10,11,12,13,14,15", XMLNAME = "ParticipantObjectDataLifeCycle", XMLPROJECTION = "ATTRIBUTE");

Property ParticipantObjectSensitivity As %String(MAXLEN = "", XMLNAME = "ParticipantObjectSensitivity", XMLPROJECTION = "ATTRIBUTE");

Storage Default
{
<Data name="ParticipantObjectDetail">
<Attribute>ParticipantObjectDetail</Attribute>
<Structure>subnode</Structure>
<Subscript>"ParticipantObjectDetail"</Subscript>
</Data>
<Data name="ParticipantObjectIdentificationTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ParticipantObjectIDTypeCode</Value>
</Value>
<Value name="3">
<Value>ParticipantObjectName</Value>
</Value>
<Value name="4">
<Value>ParticipantObjectQuery</Value>
</Value>
<Value name="5">
<Value>ParticipantObjectID</Value>
</Value>
<Value name="6">
<Value>ParticipantObjectTypeCode</Value>
</Value>
<Value name="7">
<Value>ParticipantObjectTypeCodeRole</Value>
</Value>
<Value name="8">
<Value>ParticipantObjectDataLifeCycle</Value>
</Value>
<Value name="9">
<Value>ParticipantObjectSensitivity</Value>
</Value>
</Data>
<DataLocation>^HS.IHE.Audit("ParticipantObjectIdentificationTypeD")</DataLocation>
<DefaultData>ParticipantObjectIdentificationTypeDefaultData</DefaultData>
<IdLocation>^HS.IHE.Audit("ParticipantObjectIdentificationTypeD")</IdLocation>
<IndexLocation>^HS.IHE.Audit("ParticipantObjectIdentificationTypeI")</IndexLocation>
<StreamLocation>^HS.IHE.Audit("ParticipantObjectIdentificationTypeS")</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
