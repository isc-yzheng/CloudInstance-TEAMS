/// Created from: c:/temp/healthcare-security-audit2.xsd
Class HS.IHE.ATNA.Repository.Data.AuditSourceIdentificationType Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter XMLNAME = "AuditSourceIdentificationType";

Parameter XMLSEQUENCE = 1;

Property AuditSourceTypeCode As list Of HS.IHE.ATNA.Repository.Data.CodedValueType(XMLNAME = "AuditSourceTypeCode", XMLPROJECTION = "ELEMENT") [ SqlListType = SUBNODE ];

Property AuditEnterpriseSiteID As %String(MAXLEN = "", XMLNAME = "AuditEnterpriseSiteID", XMLPROJECTION = "ATTRIBUTE");

Property AuditSourceID As %String(MAXLEN = "", XMLNAME = "AuditSourceID", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// The <var>MANAGEDEXTENT</var> parameter can be set to 0 (zero) to cause the Extent Manager
/// to ignore this class. If set to 1 then the Extent Manager will register globals used by
/// the class and detect collisions. Unmanaged extents (MANAGEDEXTENT = 0) are not checked.
/// Currently, only classes using default storage (%Storage.Persistent) can be managed.
Parameter MANAGEDEXTENT As INTEGER [ Constraint = "0,1", Flags = ENUM ] = 0;

Storage Default
{
<Data name="AuditSourceIdentificationTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AuditEnterpriseSiteID</Value>
</Value>
<Value name="3">
<Value>AuditSourceID</Value>
</Value>
</Data>
<Data name="AuditSourceTypeCode">
<Attribute>AuditSourceTypeCode</Attribute>
<Structure>subnode</Structure>
<Subscript>"AuditSourceTypeCode"</Subscript>
</Data>
<DataLocation>^HS.IHE.Audit("AuditSourceIdentificationTypeD")</DataLocation>
<DefaultData>AuditSourceIdentificationTypeDefaultData</DefaultData>
<IdLocation>^HS.IHE.Audit("AuditSourceIdentificationTypeD")</IdLocation>
<IndexLocation>^HS.IHE.Audit("AuditSourceIdentificationTypeI")</IndexLocation>
<StreamLocation>^HS.IHE.Audit("AuditSourceIdentificationTypeS")</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
