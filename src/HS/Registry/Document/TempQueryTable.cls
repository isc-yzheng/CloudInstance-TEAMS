Class HS.Registry.Document.TempQueryTable Extends %Persistent
{

Index DocumentIDIndex On DocumentID [ Type = bitmap ];

Index IDKeyIndex On DocumentID [ IdKey ];

Property DocumentID As %Integer(MINVAL = 1);

Property DocumentIID As %String;

Storage Default
{
<Data name="TempQueryTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocumentIID</Value>
</Value>
</Data>
<DataLocation>^||ISC.HS.Reg.TempQueryTableD</DataLocation>
<DefaultData>TempQueryTableDefaultData</DefaultData>
<ExtentSize>1000</ExtentSize>
<IdLocation>^||ISC.HS.Reg.TempQueryTableD</IdLocation>
<IndexLocation>^||ISC.HS.Reg.TempQueryTableI</IndexLocation>
<StreamLocation>^||ISC.HS.Reg.TempQueryTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
