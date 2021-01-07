/// Map OID to type / endpoint
Class HS.Data.OIDType Extends (%Persistent, %XML.Adaptor, HS.Sync.BaseClass) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter SYNCORDER = 60;

Property Description As %String [ Required ];

Index IDKEY On Description [ IdKey, Unique ];

Query DistinctTypes() As %SQLQuery
{
SELECT ID,Description FROM OIDType
}

Storage Default
{
<Data name="OIDTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^HS.Data.OIDTypeD</DataLocation>
<DefaultData>OIDTypeDefaultData</DefaultData>
<IdLocation>^HS.Data.OIDTypeD</IdLocation>
<IndexLocation>^HS.Data.OIDTypeI</IndexLocation>
<StreamLocation>^HS.Data.OIDTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
