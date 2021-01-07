/// Created from: C:\Temp\DICOMSCHEMA2.xsd
Class HS.IHE.ATNA.Repository.DICOMData.AuditSourceIdentificationContents Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "AuditSourceIdentificationContents";

Parameter XMLSEQUENCE = 1;

/// dicom cp1362 changed this - it was a list of %String
Property AuditSourceTypeCode As list Of HS.IHE.ATNA.Repository.DICOMData.AuditSourceTypeCodeContent(XMLNAME = "AuditSourceTypeCode", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Property code As %String(MAXLEN = "", XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property codeSystemName As %String(MAXLEN = "", XMLNAME = "codeSystemName", XMLPROJECTION = "ATTRIBUTE");

Property displayName As %String(MAXLEN = "", XMLNAME = "displayName", XMLPROJECTION = "ATTRIBUTE");

Property originalText As %String(MAXLEN = "", XMLNAME = "originalText", XMLPROJECTION = "ATTRIBUTE");

/// If these are present, they define the meaning of code
Property AuditEnterpriseSiteID As %String(MAXLEN = "", XMLNAME = "AuditEnterpriseSiteID", XMLPROJECTION = "ATTRIBUTE");

Property AuditSourceID As %String(MAXLEN = "", XMLNAME = "AuditSourceID", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Storage Default
{
<Data name="AuditSourceIdentificationContentsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AuditSourceTypeCode</Value>
</Value>
<Value name="3">
<Value>code</Value>
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
<Value name="7">
<Value>AuditEnterpriseSiteID</Value>
</Value>
<Value name="8">
<Value>AuditSourceID</Value>
</Value>
</Data>
<DataLocation>^HS.IHE.ATN494C.AuditSourceD821D</DataLocation>
<DefaultData>AuditSourceIdentificationContentsDefaultData</DefaultData>
<IdLocation>^HS.IHE.ATN494C.AuditSourceD821D</IdLocation>
<IndexLocation>^HS.IHE.ATN494C.AuditSourceD821I</IndexLocation>
<StreamLocation>^HS.IHE.ATN494C.AuditSourceD821S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
