/// 
Class HS.IHE.ATNA.Repository.DICOMData.ParticipantObjectDetail Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "ParticipantObjectDetail";

Parameter XMLSEQUENCE = 1;

Property type As %String(MAXLEN = "", XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property value As %xsd.base64Binary(XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Storage Default
{
<Data name="ParticipantObjectDetailDefaultData">
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
<DataLocation>^HS.IHE.ATN494C.Participant99A7D</DataLocation>
<DefaultData>ParticipantObjectDetailDefaultData</DefaultData>
<IdLocation>^HS.IHE.ATN494C.Participant99A7D</IdLocation>
<IndexLocation>^HS.IHE.ATN494C.Participant99A7I</IndexLocation>
<StreamLocation>^HS.IHE.ATN494C.Participant99A7S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
