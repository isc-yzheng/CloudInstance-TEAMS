/// Used to correlate <rim:ObjectRef> elements
Class HS.IHE.XDSb.Types.ObjectRef Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property EntryUUID As %String(MAXLEN = "", XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

Property HomeCommunityId As %String(MAXLEN = "", XMLNAME = "home", XMLPROJECTION = "ATTRIBUTE");

Storage Default
{
<Data name="ObjectRefState">
<Value name="1">
<Value>EntryUUID</Value>
</Value>
<Value name="2">
<Value>HomeCommunityId</Value>
</Value>
</Data>
<State>ObjectRefState</State>
<StreamLocation>^HS.IHE.XDSb.Types.ObjectRefS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
