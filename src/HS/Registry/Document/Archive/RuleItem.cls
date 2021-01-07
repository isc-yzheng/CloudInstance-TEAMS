/// 
/// This is the list of documents to archive
Class HS.Registry.Document.Archive.RuleItem Extends (%SerialObject, %XML.Adaptor)
{

Property SlotNameValue As array Of %String(MAXLEN = "");

/// PracticeSettingCode value=@Code="Dialysis"@CodingScheme="Connect-a-thon practiceSettingCodes"
Property MetaDataNameValue As array Of %String(MAXLEN = "");

Property ExtensionDays As %Integer;

Storage Default
{
<Data name="RuleItemState">
<Value name="1">
<Value>SlotNameValue</Value>
</Value>
<Value name="2">
<Value>ExtensionDays</Value>
</Value>
<Value name="3">
<Value>MetaDataNameValue</Value>
</Value>
</Data>
<State>RuleItemState</State>
<StreamLocation>^HS.Registry.Docum66AD.RuleItemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
