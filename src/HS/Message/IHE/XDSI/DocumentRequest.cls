Class HS.Message.IHE.XDSI.DocumentRequest Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property HomeCommunityId As %String(MAXLEN = 255);

Property RepositoryUniqueId As %String(MAXLEN = 255);

Property DocumentUniqueId As %String(MAXLEN = 255);

Storage Default
{
<Data name="DocumentRequestState">
<Value name="1">
<Value>HomeCommunityId</Value>
</Value>
<Value name="2">
<Value>RepositoryUniqueId</Value>
</Value>
<Value name="3">
<Value>DocumentUniqueId</Value>
</Value>
<Value name="4">
<Value>AdditionalInfo</Value>
</Value>
</Data>
<State>DocumentRequestState</State>
<StreamLocation>^HS.MessageDBE8.DocumentReqC5FFS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
