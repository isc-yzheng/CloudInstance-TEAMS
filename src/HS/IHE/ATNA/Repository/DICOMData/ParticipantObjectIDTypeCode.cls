/// 
Class HS.IHE.ATNA.Repository.DICOMData.ParticipantObjectIDTypeCode Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "ParticipantObjectIDTypeCode";

Parameter XMLSEQUENCE = 1;

Property csdcode As %String(MAXLEN = "", XMLNAME = "csd-code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property codeSystemName As %String(MAXLEN = "", XMLNAME = "codeSystemName", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property displayName As %String(MAXLEN = "", XMLNAME = "displayName", XMLPROJECTION = "ATTRIBUTE");

Property originalText As %String(MAXLEN = "", XMLNAME = "originalText", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Storage Default
{
<Data name="ParticipantObjectIDTypeCodeDefaultData">
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
<DataLocation>^HS.IHE.ATN494C.Participant937DD</DataLocation>
<DefaultData>ParticipantObjectIDTypeCodeDefaultData</DefaultData>
<IdLocation>^HS.IHE.ATN494C.Participant937DD</IdLocation>
<IndexLocation>^HS.IHE.ATN494C.Participant937DI</IndexLocation>
<StreamLocation>^HS.IHE.ATN494C.Participant937DS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
