/// Created from: c:/temp/healthcare-security-audit2.xsd
Class HS.IHE.ATNA.Repository.Data.CodedValueType Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, CompileAfter = HS.IHE.ATNA.Repository.Data.OID, Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter XMLNAME = "CodedValueType";

Parameter XMLSEQUENCE = 1;

Property code As %String(MAXLEN = "", XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property codeSystem As HS.IHE.ATNA.Repository.Data.OID(XMLNAME = "codeSystem", XMLPROJECTION = "ATTRIBUTE");

Property codeSystemName As %String(MAXLEN = "", XMLNAME = "codeSystemName", XMLPROJECTION = "ATTRIBUTE");

Property displayName As %String(MAXLEN = "", XMLNAME = "displayName", XMLPROJECTION = "ATTRIBUTE");

Property originalText As %String(MAXLEN = "", XMLNAME = "originalText", XMLPROJECTION = "ATTRIBUTE");

/// The <var>MANAGEDEXTENT</var> parameter can be set to 0 (zero) to cause the Extent Manager
/// to ignore this class. If set to 1 then the Extent Manager will register globals used by
/// the class and detect collisions. Unmanaged extents (MANAGEDEXTENT = 0) are not checked.
/// Currently, only classes using default storage (%Storage.Persistent) can be managed.
Parameter MANAGEDEXTENT As INTEGER [ Constraint = "0,1", Flags = ENUM ] = 0;

Index CodeIndex On (code, codeSystem);

Storage Default
{
<Data name="CodedValueTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>code</Value>
</Value>
<Value name="3">
<Value>codeSystem</Value>
</Value>
<Value name="4">
<Value>codeSystemName</Value>
</Value>
<Value name="5">
<Value>displayName</Value>
</Value>
<Value name="6">
<Value>originalText</Value>
</Value>
</Data>
<DataLocation>^HS.IHE.Audit("CodedValueTypeD")</DataLocation>
<DefaultData>CodedValueTypeDefaultData</DefaultData>
<IdLocation>^HS.IHE.Audit("CodedValueTypeD")</IdLocation>
<IndexLocation>^HS.IHE.Audit("CodedValueTypeI")</IndexLocation>
<StreamLocation>^HS.IHE.Audit("CodedValueTypeS")</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
