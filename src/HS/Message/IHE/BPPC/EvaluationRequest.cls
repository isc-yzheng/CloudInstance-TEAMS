/// Request to remove documents from XDSb Query response according to the BPPC domain policies
/// 
/// See class HS.IHE.BPPC.Domain for more information
Class HS.Message.IHE.BPPC.EvaluationRequest Extends HS.Util.EnsRequest
{

/// The original query request, used to get SAML and other information to query the registry for BPPC policy documents
Property QueryRequest As HS.Message.XMLMessage;

/// The original query response to be filtered
Property QueryResponse As HS.Message.XMLMessage;

Storage Default
{
<Data name="EvaluationRequestDefaultData">
<Subscript>"EvaluationRequest"</Subscript>
<Value name="1">
<Value>QueryRequest</Value>
</Value>
<Value name="2">
<Value>QueryResponse</Value>
</Value>
</Data>
<DefaultData>EvaluationRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
