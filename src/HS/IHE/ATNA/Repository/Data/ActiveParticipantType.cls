/// Created from: c:/temp/healthcare-security-audit2.xsd
Class HS.IHE.ATNA.Repository.Data.ActiveParticipantType Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter XMLNAME = "ActiveParticipantType";

Parameter XMLSEQUENCE = 1;

Property RoleIDCode As list Of HS.IHE.ATNA.Repository.Data.CodedValueType(XMLNAME = "RoleIDCode", XMLPROJECTION = "ELEMENT") [ SqlListType = SUBNODE ];

Property UserID As %String(MAXLEN = "", XMLNAME = "UserID", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property AlternativeUserID As %String(MAXLEN = "", XMLNAME = "AlternativeUserID", XMLPROJECTION = "ATTRIBUTE");

Property UserName As %String(MAXLEN = "", XMLNAME = "UserName", XMLPROJECTION = "ATTRIBUTE");

Property UserIsRequestor As %Boolean(XMLNAME = "UserIsRequestor", XMLPROJECTION = "ATTRIBUTE");

Property NetworkAccessPointID As %String(MAXLEN = "", XMLNAME = "NetworkAccessPointID", XMLPROJECTION = "ATTRIBUTE");

Property NetworkAccessPointTypeCode As %xsd.unsignedByte(VALUELIST = ",1,2,3", XMLNAME = "NetworkAccessPointTypeCode", XMLPROJECTION = "ATTRIBUTE");

/// The <var>MANAGEDEXTENT</var> parameter can be set to 0 (zero) to cause the Extent Manager
/// to ignore this class. If set to 1 then the Extent Manager will register globals used by
/// the class and detect collisions. Unmanaged extents (MANAGEDEXTENT = 0) are not checked.
/// Currently, only classes using default storage (%Storage.Persistent) can be managed.
Parameter MANAGEDEXTENT As INTEGER [ Constraint = "0,1", Flags = ENUM ] = 0;

Storage Default
{
<Data name="ActiveParticipantTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>AlternativeUserID</Value>
</Value>
<Value name="4">
<Value>UserName</Value>
</Value>
<Value name="5">
<Value>UserIsRequestor</Value>
</Value>
<Value name="6">
<Value>NetworkAccessPointID</Value>
</Value>
<Value name="7">
<Value>NetworkAccessPointTypeCode</Value>
</Value>
</Data>
<Data name="RoleIDCode">
<Attribute>RoleIDCode</Attribute>
<Structure>subnode</Structure>
<Subscript>"RoleIDCode"</Subscript>
</Data>
<DataLocation>^HS.IHE.Audit("ActiveParticipantTypeD")</DataLocation>
<DefaultData>ActiveParticipantTypeDefaultData</DefaultData>
<IdLocation>^HS.IHE.Audit("ActiveParticipantTypeD")</IdLocation>
<IndexLocation>^HS.IHE.Audit("ActiveParticipantTypeI")</IndexLocation>
<StreamLocation>^HS.IHE.Audit("ActiveParticipantTypeS")</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
