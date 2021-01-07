/// Base class for coded properties that can have code history in addition to<br>
/// the current code, description, and code system. Every class that can be<br>
/// translated extends CodeTableTranslated, however not every class that<br>
/// extends CodeTableTranslated can be translated. Currently only the types<br>
/// listed on the Terminology Translation Profiles screen in the HealthShare<br>
/// Management Portal on the Registry can be translated. When HealthShare<br>
/// translates a code, a copy of the original is put in PriorCodes. See the HS<br>
/// documentation for more info on terminology translation.
Class HS.SDA3.CodeTableTranslated Extends HS.SDA3.CodeTableDetail
{

Parameter TRANSLATED = 1;

/// The original text that was available to an automated process or a human<br>
/// before a specific code was assigned. When parsed from HL7 in HL7ToSDA3,<br>
/// this will always come from piece 9 of a coded field (data structure CNE or<br>
/// CWE).<br><br>
/// VIEWERLIB: Not stored
Property OriginalText As %String(MAXLEN = 32000);

/// A list of alternate codes or codes that may have been previously assigned<br>
/// to this property.<br><br>
/// VIEWERLIB: Not stored
Property PriorCodes As list Of HS.SDA3.PriorCode;

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
<Value>EId</Value>
</Value>
<Value name="8">
<Value>OriginalText</Value>
</Value>
<Value name="9">
<Value>PriorCodes</Value>
</Value>
<Value name="10">
<Value>CodeSystemVersionId</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
