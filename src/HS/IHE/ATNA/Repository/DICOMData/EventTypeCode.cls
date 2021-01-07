/// 
Class HS.IHE.ATNA.Repository.DICOMData.EventTypeCode Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "EventTypeCode";

Parameter XMLSEQUENCE = 1;

Property csdcode As %String(MAXLEN = "", XMLNAME = "csd-code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property codeSystemName As %String(MAXLEN = "", XMLNAME = "codeSystemName", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property displayName As %String(MAXLEN = "", XMLNAME = "displayName", XMLPROJECTION = "ATTRIBUTE");

Property originalText As %String(MAXLEN = "", XMLNAME = "originalText", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Storage Default
{
<Data name="EventTypeCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>csdcode</Value>
</Value>
<Value name="3">
<Value>codeSystemName</Value>
</Value>
<Value name="4">
<Value>displayName</Value>
</Value>
<Value name="5">
<Value>originalText</Value>
</Value>
</Data>
<DataLocation>^HS.IHE.ATNA494C.EventTypeCodeD</DataLocation>
<DefaultData>EventTypeCodeDefaultData</DefaultData>
<IdLocation>^HS.IHE.ATNA494C.EventTypeCodeD</IdLocation>
<IndexLocation>^HS.IHE.ATNA494C.EventTypeCodeI</IndexLocation>
<StreamLocation>^HS.IHE.ATNA494C.EventTypeCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
