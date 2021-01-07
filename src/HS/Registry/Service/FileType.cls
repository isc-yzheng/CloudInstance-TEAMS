Class HS.Registry.Service.FileType Extends HS.Registry.Service.Abstract
{

Property FilePath As %String(MAXLEN = 512);

Property Filename As %String(MAXLEN = 255);

Property Overwrite As %Boolean [ InitialExpression = 0 ];

Property Info As %String(MAXLEN = 512) [ SqlComputeCode = {	
	Set {*} = {FilePath}
	}, SqlComputed, Transient ];

Storage Default
{
<Data name="FileTypeDefaultData">
<Subscript>"FileType"</Subscript>
<Value name="1">
<Value>FilePath</Value>
</Value>
<Value name="2">
<Value>Filename</Value>
</Value>
<Value name="3">
<Value>Overwrite</Value>
</Value>
</Data>
<DefaultData>FileTypeDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
