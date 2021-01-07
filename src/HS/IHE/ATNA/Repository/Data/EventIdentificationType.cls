/// Created from: c:/temp/healthcare-security-audit2.xsd
Class HS.IHE.ATNA.Repository.Data.EventIdentificationType Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter XMLNAME = "EventIdentificationType";

Parameter XMLSEQUENCE = 1;

Property EventID As HS.IHE.ATNA.Repository.Data.CodedValueType(XMLNAME = "EventID") [ Required ];

Property EventTypeCode As list Of HS.IHE.ATNA.Repository.Data.CodedValueType(XMLNAME = "EventTypeCode", XMLPROJECTION = "ELEMENT") [ SqlListType = SUBNODE ];

Property EventActionCode As %String(MAXLEN = "", VALUELIST = ",C,R,U,D,E", XMLNAME = "EventActionCode", XMLPROJECTION = "ATTRIBUTE");

Property EventDateTime As %TimeStamp(XMLNAME = "EventDateTime", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property EventOutcomeIndicator As %Integer(VALUELIST = ",0,4,8,12", XMLNAME = "EventOutcomeIndicator", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// The <var>MANAGEDEXTENT</var> parameter can be set to 0 (zero) to cause the Extent Manager
/// to ignore this class. If set to 1 then the Extent Manager will register globals used by
/// the class and detect collisions. Unmanaged extents (MANAGEDEXTENT = 0) are not checked.
/// Currently, only classes using default storage (%Storage.Persistent) can be managed.
Parameter MANAGEDEXTENT As INTEGER [ Constraint = "0,1", Flags = ENUM ] = 0;

Storage Default
{
<Data name="EventIdentificationTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EventID</Value>
</Value>
<Value name="3">
<Value>EventActionCode</Value>
</Value>
<Value name="4">
<Value>EventDateTime</Value>
</Value>
<Value name="5">
<Value>EventOutcomeIndicator</Value>
</Value>
</Data>
<Data name="EventTypeCode">
<Attribute>EventTypeCode</Attribute>
<Structure>subnode</Structure>
<Subscript>"EventTypeCode"</Subscript>
</Data>
<DataLocation>^HS.IHE.Audit("EventIdentificationTypeD")</DataLocation>
<DefaultData>EventIdentificationTypeDefaultData</DefaultData>
<IdLocation>^HS.IHE.Audit("EventIdentificationTypeD")</IdLocation>
<IndexLocation>^HS.IHE.Audit("EventIdentificationTypeI")</IndexLocation>
<StreamLocation>^HS.IHE.Audit("EventIdentificationTypeS")</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
