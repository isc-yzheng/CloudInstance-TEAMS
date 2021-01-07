Class HS.Registry.Service.HTTP Extends HS.Registry.Service.TCP
{

Property ProxyHost As %String(MAXLEN = 150);

Property ProxyPort As %Integer;

Property ProxyHTTPS As %Boolean [ InitialExpression = 0 ];

Property ProxyHTTPTunnel As %Boolean [ InitialExpression = 0 ];

Property ProxyHTTPSSLConnect As %Boolean [ InitialExpression = 0 ];

Property URL As %String(MAXLEN = 1024);

Property HTTPCredentialsConfig As %String;

Property SignX509TokenProfile As %String;

Property EndPoint As %String(MAXLEN = 512) [ SqlComputeCode = {	New tStart,tPort,tURL
	Set tStart=$S({SSLConfig}="":"http://",1:"https://")
	Set tPort=$S({Port}="":"",1:":"_{Port})
	Set tURL=$S($E({URL})="/":"",1:"/")_{URL}
	Set:tURL="/" tURL=""	//For endpoints that have nothing after the port
	Set {*}= tStart_{Host}_tPort_tURL}, SqlComputed, SqlComputeOnChange = (%%INSERT, %%UPDATE, Host, Port, SSLConfig, URL) ];

/// When making an SSL connection check the server identity in the certificate matches the name of the system we are connecting to.
/// This defaults to being on and matches based on the rules layed out in section 3.1 of RFC 2818.
Property SSLCheckServerIdentity As %Boolean [ InitialExpression = 1 ];

Index EndPointIndex On EndPoint;

/// if there is only 1 endpoint with the URL specified return it
ClassMethod EndPointForURL(pURL As %String = "") As HS.Registry.Service.HTTP
{
	&sql(select ID,Count(*) into :ID,:tCount from HS_Registry_Service.HTTP where EndPoint=:pURL )
	Quit $S(SQLCODE:"",tCount=1:..%OpenId(ID),1:"")
}

Method ParseURL(pURL As %String) As %Status
{
	Set tSC=$$$OK
	///http://host:port/url
	Set tHostPort=$p(pURL,"/",3)
	Set ..Host=$p(tHostPort,":") // Required
	Set ..Port=$p(tHostPort,":",2) // Optional
	Set ..URL=$p(pURL,"/",4,9999) Set:..URL]"" ..URL="/"_..URL // Required
	If ..Host="" Set tSC=$$$ERROR(5001,"URL Missing Host")
	If ..URL["//" Set tSC=$System.Status.AppendStatus(tSC,$$$ERROR(5001,"URL Missing Namespace"))
	Quit tSC
}

Storage Default
{
<Data name="HTTPDefaultData">
<Subscript>"HTTP"</Subscript>
<Value name="1">
<Value>ProxyHost</Value>
</Value>
<Value name="2">
<Value>ProxyPort</Value>
</Value>
<Value name="3">
<Value>URL</Value>
</Value>
<Value name="4">
<Value>HTTPCredentialsConfig</Value>
</Value>
<Value name="5">
<Value>EndPoint</Value>
</Value>
<Value name="6">
<Value>ProxyHTTPS</Value>
</Value>
<Value name="7">
<Value>ProxyHTTPTunnel</Value>
</Value>
<Value name="8">
<Value>ProxyHTTPSSLConnect</Value>
</Value>
<Value name="9">
<Value>SSLCheckServerIdentity</Value>
</Value>
<Value name="10">
<Value>SignX509TokenProfile</Value>
</Value>
</Data>
<DefaultData>HTTPDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
