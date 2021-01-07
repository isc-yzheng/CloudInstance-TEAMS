Class HS.AU.Types.SMD.RouteRecordEntryType Extends (%SerialObject, %XML.Adaptor)
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/smd/xsd/SealedMessage/2010";

Parameter XMLNAME = "RouteRecordEntryType";

Parameter XMLSEQUENCE = 1;

Property SendIntermediateResponses As %Boolean(XMLNAME = "sendIntermediateResponses");

Property Interaction As HS.AU.Types.ELS.InteractionType(XMLNAME = "interaction");

Storage Default
{
<Data name="RouteRecordEntryTypeState">
<Value name="1">
<Value>SendIntermediateResponses</Value>
</Value>
<Value name="2">
<Value>Interaction</Value>
</Value>
</Data>
<State>RouteRecordEntryTypeState</State>
<StreamLocation>^HS.AU.TypesB46.RouteRecord43B0S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
