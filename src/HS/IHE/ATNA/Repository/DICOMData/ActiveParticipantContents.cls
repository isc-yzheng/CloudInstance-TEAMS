/// Created from: C:\Temp\DICOMSCHEMA2.xsd
Class HS.IHE.ATNA.Repository.DICOMData.ActiveParticipantContents Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "ActiveParticipantContents";

Parameter XMLSEQUENCE = 1;

Property RoleIDCode As list Of HS.IHE.ATNA.Repository.DICOMData.RoleIDCode(XMLNAME = "RoleIDCode", XMLPROJECTION = "ELEMENT", XMLREF = 1);

Property UserID As %String(MAXLEN = "", XMLNAME = "UserID", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property AlternativeUserID As %String(MAXLEN = "", XMLNAME = "AlternativeUserID", XMLPROJECTION = "ATTRIBUTE");

Property UserName As %String(MAXLEN = "", XMLNAME = "UserName", XMLPROJECTION = "ATTRIBUTE");

Property UserIsRequestor As %Boolean(XMLNAME = "UserIsRequestor", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property NetworkAccessPointID As %String(MAXLEN = "", XMLNAME = "NetworkAccessPointID", XMLPROJECTION = "ATTRIBUTE");

Property NetworkAccessPointTypeCode As %String(MAXLEN = "", VALUELIST = ",1,2,3,4,5", XMLNAME = "NetworkAccessPointTypeCode", XMLPROJECTION = "ATTRIBUTE");

Property MediaIdentifier As HS.IHE.ATNA.Repository.DICOMData.MediaIdentifier(XMLNAME = "MediaIdentifier", XMLPROJECTION = "ELEMENT");

Storage Default
{
<Data name="ActiveParticipantContentsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleIDCode</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>AlternativeUserID</Value>
</Value>
<Value name="5">
<Value>UserName</Value>
</Value>
<Value name="6">
<Value>UserIsRequestor</Value>
</Value>
<Value name="7">
<Value>NetworkAccessPointID</Value>
</Value>
<Value name="8">
<Value>NetworkAccessPointTypeCode</Value>
</Value>
<Value name="9">
<Value>MediaIdentifier</Value>
</Value>
</Data>
<DataLocation>^HS.IHE.ATN494C.ActiveParti9DE4D</DataLocation>
<DefaultData>ActiveParticipantContentsDefaultData</DefaultData>
<IdLocation>^HS.IHE.ATN494C.ActiveParti9DE4D</IdLocation>
<IndexLocation>^HS.IHE.ATN494C.ActiveParti9DE4I</IndexLocation>
<StreamLocation>^HS.IHE.ATN494C.ActiveParti9DE4S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
