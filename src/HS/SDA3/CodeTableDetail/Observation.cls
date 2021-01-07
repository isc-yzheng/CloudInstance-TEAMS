/// In the Viewer Cache, Observation CodeTableDetails are matched to<br>
/// MRCObservationItems on Code, Description, SDACodingStandard, and<br>
/// ObservationValueUnits (which is itself subject to code table matching).
Class HS.SDA3.CodeTableDetail.Observation Extends HS.SDA3.CodeTableTranslated
{

Property Extension As HS.Local.SDA3.CodeTableDetail.ObservationExtension;

Parameter XMLTYPE = "ObservationCode";

Parameter XMLNAME = "Observation";

/// VIEWERLIB: User.HS.MRCObservationItem(ITMCode)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.MRCObservationItem(ITMDesc)
Property Description As HS.SDA3.StrippedString(MAXLEN = 32000);

/// SDATableName=UoM, ViewerClass=User.HS.CTUOM<br>
/// VIEWERLIB: User.HS.MRCObservationItem(ITMCTUOMDR)<br>
Property ObservationValueUnits As HS.SDA3.CodeTableDetail.UoM;

Storage Default
{
<Data name="CodeTableDetailState">
<Value name="1">
<Value>SDATableName</Value>
</Value>
<Value name="2">
<Value>SDACodingStandard</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>InternalReference</Value>
</Value>
<Value name="6">
<Value>ErrorStatus</Value>
</Value>
<Value name="7">
<Value>Factor</Value>
</Value>
<Value name="8">
<Value>EId</Value>
</Value>
<Value name="9">
<Value>PriorCodes</Value>
</Value>
<Value name="10">
<Value>OriginalText</Value>
</Value>
<Value name="11">
<Value>Units</Value>
</Value>
<Value name="12">
<Value>ObservationValueUnits</Value>
</Value>
<Value name="13">
<Value>CodeSystemVersionId</Value>
</Value>
<Value name="14">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
