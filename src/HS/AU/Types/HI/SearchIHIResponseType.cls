Class HS.AU.Types.HI.SearchIHIResponseType Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/svc/ConsumerSearchIHIBatchSyncRequest/3.0";

Parameter XMLNAME = "SearchIHIRequestType";

Parameter XMLSEQUENCE = 1;

Property SearchIHI As HS.AU.Message.HI.SearchIHIResult(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/SearchIHI/3.0", XMLNAME = "searchIHIResult", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Property RequestIdentifier As %String(MAXLEN = 36, MINLEN = 36, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/SearchIHIBatch/3.0", XMLNAME = "requestIdentifier", XMLREF = 1) [ Required ];

Storage Default
{
<Data name="SearchIHIResponseTypeState">
<Value name="1">
<Value>SearchIHI</Value>
</Value>
<Value name="2">
<Value>RequestIdentifier</Value>
</Value>
</Data>
<State>SearchIHIResponseTypeState</State>
<StreamLocation>^HS.AU.Type3554.SearchIHIReF00CS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
