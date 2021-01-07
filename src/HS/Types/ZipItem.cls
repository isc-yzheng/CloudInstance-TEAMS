Class HS.Types.ZipItem Extends (%Persistent, %XML.Adaptor)
{

// MAXLEN set to match the PATH_MAX property of Linux

Property Path As %String(MAXLEN = 4096);

// MAXLEN set to match the NAME_MAX property of Linux

Property Filename As %String(MAXLEN = 256);

Property File As %Stream.GlobalBinary(CONTENT = "MIXED");

Storage Default
{
<Data name="ZipItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Path</Value>
</Value>
<Value name="3">
<Value>Filename</Value>
</Value>
<Value name="4">
<Value>Stream</Value>
</Value>
<Value name="5">
<Value>File</Value>
</Value>
</Data>
<DataLocation>^HS.Types.ZipItemD</DataLocation>
<DefaultData>ZipItemDefaultData</DefaultData>
<IdLocation>^HS.Types.ZipItemD</IdLocation>
<IndexLocation>^HS.Types.ZipItemI</IndexLocation>
<StreamLocation>^HS.Types.ZipItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
