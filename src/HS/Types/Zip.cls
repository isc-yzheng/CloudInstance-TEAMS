Class HS.Types.Zip Extends (%Persistent, %XML.Adaptor)
{

Property Items As list Of HS.Types.ZipItem;

Property File As %Stream.GlobalBinary;

Property Operation As %String(VALUELIST = ",ToZip,FromZip");

Storage Default
{
<Data name="ZipDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Items</Value>
</Value>
<Value name="3">
<Value>File</Value>
</Value>
<Value name="4">
<Value>Operation</Value>
</Value>
</Data>
<DataLocation>^HS.Types.ZipD</DataLocation>
<DefaultData>ZipDefaultData</DefaultData>
<IdLocation>^HS.Types.ZipD</IdLocation>
<IndexLocation>^HS.Types.ZipI</IndexLocation>
<StreamLocation>^HS.Types.ZipS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
