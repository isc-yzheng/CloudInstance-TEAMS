/// Created from: C:\Temp\DICOMSCHEMA2.xsd
Class HS.IHE.ATNA.Repository.DICOMData.EventIdentificationContents Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "EventIdentificationContents";

Parameter XMLSEQUENCE = 1;

Property EventID As HS.IHE.ATNA.Repository.DICOMData.EventID(XMLNAME = "EventID", XMLREF = 1) [ Required ];

Property EventTypeCode As list Of HS.IHE.ATNA.Repository.DICOMData.EventTypeCode(XMLNAME = "EventTypeCode", XMLPROJECTION = "ELEMENT", XMLREF = 1);

Property EventOutcomeDescription As %String(MAXLEN = "", XMLNAME = "EventOutcomeDescription", XMLREF = 1);

Property PurposeOfUse As list Of HS.IHE.ATNA.Repository.DICOMData.PurposeOfUseCode(XMLNAME = "PurposeOfUse", XMLPROJECTION = "ELEMENT", XMLREF = 1);

Property EventActionCode As %String(MAXLEN = "", VALUELIST = ",C,R,U,D,E", XMLNAME = "EventActionCode", XMLPROJECTION = "ATTRIBUTE");

Property EventDateTime As %TimeStamp(XMLNAME = "EventDateTime", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property EventOutcomeIndicator As %String(MAXLEN = "", VALUELIST = ",0,4,8,12", XMLNAME = "EventOutcomeIndicator", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Storage Default
{
<Data name="EventIdentificationContentsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EventID</Value>
</Value>
<Value name="3">
<Value>EventTypeCode</Value>
</Value>
<Value name="4">
<Value>EventOutcomeDescription</Value>
</Value>
<Value name="5">
<Value>EventActionCode</Value>
</Value>
<Value name="6">
<Value>EventDateTime</Value>
</Value>
<Value name="7">
<Value>EventOutcomeIndicator</Value>
</Value>
<Value name="8">
<Value>PurposeOfUse</Value>
</Value>
</Data>
<DataLocation>^HS.IHE.ATN494C.EventIdenti2422D</DataLocation>
<DefaultData>EventIdentificationContentsDefaultData</DefaultData>
<IdLocation>^HS.IHE.ATN494C.EventIdenti2422D</IdLocation>
<IndexLocation>^HS.IHE.ATN494C.EventIdenti2422I</IndexLocation>
<StreamLocation>^HS.IHE.ATN494C.EventIdenti2422S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
