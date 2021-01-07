Class HS.AU.Types.PCEHR.ResponseStatusType Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0";

Parameter XMLNAME = "responseStatusType";

Parameter XMLSEQUENCE = 1;

Property Code As %String(MAXLEN = "", MINLEN = 1, XMLNAME = "code");

Property Description As %String(MAXLEN = "", XMLNAME = "description");

Property Details As %String(MAXLEN = "", XMLNAME = "details");

Storage Default
{
<Data name="ResponseStatusTypeState">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Details</Value>
</Value>
</Data>
<State>ResponseStatusTypeState</State>
<StreamLocation>^HS.AU.Type72D3.ResponseSta23B1S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
