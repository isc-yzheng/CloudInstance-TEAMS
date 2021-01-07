/// Created from: C:\Temp\DICOMSCHEMA2.xsd
Class HS.IHE.ATNA.Repository.DICOMData.ParticipantObjectIdentificationContents Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "ParticipantObjectIdentificationContents";

Parameter XMLSEQUENCE = 0;

Property ParticipantObjectIDTypeCode As HS.IHE.ATNA.Repository.DICOMData.ParticipantObjectIDTypeCode(XMLNAME = "ParticipantObjectIDTypeCode", XMLREF = 1) [ Required ];

Property ParticipantObjectName As %String(MAXLEN = "", XMLNAME = "ParticipantObjectName", XMLREF = 1);

Property ParticipantObjectQuery As %xsd.base64Binary(XMLNAME = "ParticipantObjectQuery", XMLREF = 1);

Property ParticipantObjectDetail As list Of HS.IHE.ATNA.Repository.DICOMData.ParticipantObjectDetail(XMLNAME = "ParticipantObjectDetail", XMLPROJECTION = "ELEMENT", XMLREF = 1);

Property ParticipantObjectDescription As list Of %String(MAXLEN = "", XMLNAME = "ParticipantObjectDescription", XMLPROJECTION = "ELEMENT", XMLREF = 1);

Property Encrypted As %Boolean(XMLNAME = "Encrypted", XMLREF = 1);

Property Anonymized As %Boolean(XMLNAME = "Anonymized", XMLREF = 1);

Property ParticipantObjectID As %String(MAXLEN = "", XMLNAME = "ParticipantObjectID", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property ParticipantObjectTypeCode As %String(MAXLEN = "", VALUELIST = ",1,2,3,4", XMLNAME = "ParticipantObjectTypeCode", XMLPROJECTION = "ATTRIBUTE");

Property ParticipantObjectTypeCodeRole As %String(MAXLEN = "", VALUELIST = ",1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24", XMLNAME = "ParticipantObjectTypeCodeRole", XMLPROJECTION = "ATTRIBUTE");

/// Query?,
Property ParticipantObjectDataLifeCycle As %String(MAXLEN = "", VALUELIST = ",1,2,3,4,5,6,7,8,9,10,11,12,13,14,15", XMLNAME = "ParticipantObjectDataLifeCycle", XMLPROJECTION = "ATTRIBUTE");

/// Permanent erasure, physical destruction
Property ParticipantObjectSensitivity As %String(MAXLEN = "", XMLNAME = "ParticipantObjectSensitivity", XMLPROJECTION = "ATTRIBUTE");

Storage Default
{
<Data name="ParticipantObjectIdentificationContentsDefaultData">
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
<Value>ParticipantObjectDetail</Value>
</Value>
<Value name="6">
<Value>ParticipantObjectDescription</Value>
</Value>
<Value name="7">
<Value>Encrypted</Value>
</Value>
<Value name="8">
<Value>Anonymized</Value>
</Value>
<Value name="9">
<Value>ParticipantObjectID</Value>
</Value>
<Value name="10">
<Value>ParticipantObjectTypeCode</Value>
</Value>
<Value name="11">
<Value>ParticipantObjectTypeCodeRole</Value>
</Value>
<Value name="12">
<Value>ParticipantObjectDataLifeCycle</Value>
</Value>
<Value name="13">
<Value>ParticipantObjectSensitivity</Value>
</Value>
</Data>
<DataLocation>^HS.IHE.ATN494C.Participant716DD</DataLocation>
<DefaultData>ParticipantObjectIdentificationContentsDefaultData</DefaultData>
<IdLocation>^HS.IHE.ATN494C.Participant716DD</IdLocation>
<IndexLocation>^HS.IHE.ATN494C.Participant716DI</IndexLocation>
<StreamLocation>^HS.IHE.ATN494C.Participant716DS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
