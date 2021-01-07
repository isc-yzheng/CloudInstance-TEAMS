/// Used to pass info from either the TCP or UDP ATNA Adaptors.
/// This will mostly be used for connectathons, where we want to log the inbound IP address
Class HS.Message.IHE.ATNA.InboundSubmission Extends HS.Util.EnsRequest
{

Property StringValue As %String(MAXLEN = "");

Property InboundIP As %String;

Method %OnNew(pStringValue As %String, pInboundIP As %String) As %Status
{
	Set ..StringValue=$g(pStringValue)
	Set ..InboundIP=$g(pInboundIP)
	Quit $$$OK
}

Storage Default
{
<Data name="InboundSubmissionDefaultData">
<Subscript>"InboundSubmission"</Subscript>
<Value name="1">
<Value>StringValue</Value>
</Value>
<Value name="2">
<Value>InboundIP</Value>
</Value>
</Data>
<DefaultData>InboundSubmissionDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
