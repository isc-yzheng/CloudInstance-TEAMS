Class HS.Registry.Document.SerialClassification Extends (%SerialObject, %XML.Adaptor)
{

Property IID As %String(MAXLEN = 256, XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

Property Code As %String;

Property CodingScheme As %String;

Property DisplayName As %String(MAXLEN = "");

Storage Default
{
<Data name="SerialClassificationState">
<Value name="1">
<Value>IID</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CodingScheme</Value>
</Value>
<Value name="4">
<Value>DisplayName</Value>
</Value>
</Data>
<State>SerialClassificationState</State>
<StreamLocation>^HS.Registr50B9.SerialClassE18CS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
