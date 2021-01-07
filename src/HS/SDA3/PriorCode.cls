/// PriorCode appears in the SDA as a list property (PriorCodes) of<br>
/// HS.SDA3.CodeTableTranslated and all classes that extend<br>
/// CodeTableTranslated.
Class HS.SDA3.PriorCode Extends HS.SDA3.DataType
{

Property Extension As HS.Local.SDA3.PriorCodeExtension;

Property Code As %String(MAXLEN = 32000);

Property Description As %String(MAXLEN = 32000);

Property CodeSystem As %String(MAXLEN = 32000);

/// Supported values:<br>
/// O - Original<br>
/// A - Alternate<br>
/// N - Normalized<br><br>
/// When a PriorCode is parsed from HL7, Type is set to "A". When a<br>
/// CodeTableTranslated is being translated, if the last entry in the list of<br>
/// PriorCodes has Type="O", then the pre-translation Code, Description, and<br>
/// SDACodingStandard will be inserted into PriorCodes as a PriorCode with<br>
/// Type="N". Else they will be inserted with Type="O".
Property Type As %String(DISPLAYLIST = ",Alternate,Original,Normalized", VALUELIST = ",A,O,N");

/// The coding system version ID<br>
/// For example, HL7v2.x data structure CNE or CWE, piece 8 if Type="A", or<br>
/// piece 7 if Type="O"
Property CodeSystemVersionId As %String(MAXLEN = 32000);

Storage Default
{
<Data name="PriorCodeState">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>CodeSystem</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>CodeSystemVersionId</Value>
</Value>
<Value name="6">
<Value>Extension</Value>
</Value>
</Data>
<State>PriorCodeState</State>
<StreamLocation>^HS.SDA3.PriorCodeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
