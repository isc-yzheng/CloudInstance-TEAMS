/// 
Class HS.IHE.ATNA.Repository.DICOMData.AuditSourceTypeCodeContent Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "AuditSourceTypeCodeContent";

/// dicom cp1362 tells us to use "code" as the property.
Property code As %String(MAXLEN = "", XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE");

/// dicom cp1638 tells us to use "cdscode" as the property, contradicting 1362.  We'll accept either
Property csdcode As %String(MAXLEN = "", XMLNAME = "csd-code", XMLPROJECTION = "ATTRIBUTE");

Property codeSystemName As %String(MAXLEN = "", XMLNAME = "codeSystemName", XMLPROJECTION = "ATTRIBUTE");

Property displayName As %String(MAXLEN = "", XMLNAME = "displayName", XMLPROJECTION = "ATTRIBUTE");

Property originalText As %String(MAXLEN = "", XMLNAME = "originalText", XMLPROJECTION = "ATTRIBUTE");

Storage Default
{
<Data name="AuditSourceTypeCodeContentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>code</Value>
</Value>
<Value name="3">
<Value>csdcode</Value>
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
<DataLocation>^HS.IHE.ATN494C.AuditSource41D9D</DataLocation>
<DefaultData>AuditSourceTypeCodeContentDefaultData</DefaultData>
<IdLocation>^HS.IHE.ATN494C.AuditSource41D9D</IdLocation>
<IndexLocation>^HS.IHE.ATN494C.AuditSource41D9I</IndexLocation>
<StreamLocation>^HS.IHE.ATN494C.AuditSource41D9S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
