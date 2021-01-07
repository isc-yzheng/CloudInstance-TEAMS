Class HS.Message.IHE.XDSI.SeriesRequest Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Property SeriesInstanceUID As %String(MAXLEN = 512);

Property DocumentRequests As list Of HS.Message.IHE.XDSI.DocumentRequest;

Storage Default
{
<Data name="SeriesRequestState">
<Value name="1">
<Value>SeriesInstanceUID</Value>
</Value>
<Value name="2">
<Value>DocumentRequests</Value>
</Value>
</Data>
<State>SeriesRequestState</State>
<StreamLocation>^HS.Message.IDBE8.SeriesRequestS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
