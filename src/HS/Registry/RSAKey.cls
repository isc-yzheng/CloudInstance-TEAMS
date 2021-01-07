Class HS.Registry.RSAKey Extends (%Persistent, %XML.Adaptor, HS.Util.CopyFrom, HS.Sync.BaseClass) [ Inheritance = right ]
{

Property Alias As %String(MAXLEN = 256);

Property Modulus As %Binary(MAXLEN = "") [ Required ];

Property Exponent As %Binary(MAXLEN = "") [ Required ];

Index PublicKeyIdx On (Modulus, Exponent) [ Unique ];

ClassMethod GetByRSAKeyValue(pModulus As %Binary, pExponent As %Binary) As HS.Registry.RSAKey
{
	Set tKey = ""
	Set tStatement = ##class(%SQL.Statement).%New()
	Do tStatement.%PrepareClassQuery("HS.Registry.RSAKey","GetIDByKey")
	Set tRS = tStatement.%Execute(pModulus,pExponent)
	If tRS.%Next(){
		Set tKey = ##class(HS.Registry.RSAKey).%OpenId(tRS.%Get("ID"))
	}
	Quit tKey
}

Query GetIDByKey(pModulus As %Binary, pExponent As %Binary) As %SQLQuery(ROWSPEC = "ID:%Integer") [ SqlProc ]
{
	SELECT %ID FROM HS_Registry.RSAKey WHERE MODULUS = :pModulus AND EXPONENT = :pExponent
}

Query Items() As %Query(ROWSPEC = "ID:%Integer,Alias:%String,Modulus:%String,Exponent:%String")
{
}

ClassMethod ItemsExecute(ByRef qHandle As %Binary) As %Status
{
	Set tSQL="SELECT %ID, Alias, Modulus, Exponent FROM HS_Registry.RSAKey ORDER BY Alias"
	Set qHandle = ##class(%SQL.Statement).%ExecDirect(,tSQL)
	Quit $$$OK
}

ClassMethod ItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ItemsExecute ]
{
	Set qHandle=""
	Quit $$$OK
}

ClassMethod ItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ItemsExecute ]
{
	Set AtEnd='qHandle.%Next()
	Set Row=$S(AtEnd:"",1:$lb(qHandle.%GetData(1),qHandle.%GetData(2),##class(%Binary).LogicalToXSD(qHandle.%GetData(3)),##class(%Binary).LogicalToXSD(qHandle.%GetData(4))))
	Quit $$$OK
}

Storage Default
{
<Data name="RSAKeyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Alias</Value>
</Value>
<Value name="3">
<Value>PublicKey</Value>
</Value>
<Value name="4">
<Value>Owner</Value>
</Value>
<Value name="5">
<Value>Modulus</Value>
</Value>
<Value name="6">
<Value>Exponent</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.RSAKeyD</DataLocation>
<DefaultData>RSAKeyDefaultData</DefaultData>
<IdLocation>^HS.Registry.RSAKeyD</IdLocation>
<IndexLocation>^HS.Registry.RSAKeyI</IndexLocation>
<StreamLocation>^HS.Registry.RSAKeyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
