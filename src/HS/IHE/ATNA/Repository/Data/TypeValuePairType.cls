/// Created from: c:/temp/healthcare-security-audit2.xsd
Class HS.IHE.ATNA.Repository.Data.TypeValuePairType Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter XMLNAME = "TypeValuePairType";

Parameter XMLSEQUENCE = 1;

Property type As %String(MAXLEN = "", XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property value As %xsd.base64Binary(XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// The <var>MANAGEDEXTENT</var> parameter can be set to 0 (zero) to cause the Extent Manager
/// to ignore this class. If set to 1 then the Extent Manager will register globals used by
/// the class and detect collisions. Unmanaged extents (MANAGEDEXTENT = 0) are not checked.
/// Currently, only classes using default storage (%Storage.Persistent) can be managed.
Parameter MANAGEDEXTENT As INTEGER [ Constraint = "0,1", Flags = ENUM ] = 0;

Storage Default
{
<Data name="TypeValuePairTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>type</Value>
</Value>
<Value name="3">
<Value>value</Value>
</Value>
</Data>
<DataLocation>^HS.IHE.Audit("TypeValuePairD")</DataLocation>
<DefaultData>TypeValuePairTypeDefaultData</DefaultData>
<IdLocation>^HS.IHE.Audit("TypeValuePair")</IdLocation>
<IndexLocation>^HS.IHE.Audit("TypeValuePairI")</IndexLocation>
<StreamLocation>^HS.IHE.Audit("TypeValuePairS")</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
