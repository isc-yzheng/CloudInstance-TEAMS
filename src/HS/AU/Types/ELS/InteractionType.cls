/// 
Class HS.AU.Types.ELS.InteractionType Extends (%SerialObject, %XML.Adaptor)
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/els/xsd/DataTypes/2010";

Parameter XMLNAME = "InteractionType";

Parameter XMLSEQUENCE = 1;

Property Target As %xsd.anyURI(XMLNAME = "target");

Property ServiceCategory As %xsd.anyURI(XMLNAME = "serviceCategory");

Property ServiceInterface As %xsd.anyURI(XMLNAME = "serviceInterface");

Property ServiceEndpoint As %xsd.anyURI(XMLNAME = "serviceEndpoint");

Property ServiceProvider As %xsd.anyURI(XMLNAME = "serviceProvider");

Property CertRef As list Of HS.AU.Types.ELS.CertRefType(XMLNAME = "certRef", XMLPROJECTION = "ELEMENT");

Storage Default
{
<Data name="InteractionTypeState">
<Value name="1">
<Value>Target</Value>
</Value>
<Value name="2">
<Value>ServiceCategory</Value>
</Value>
<Value name="3">
<Value>ServiceInterface</Value>
</Value>
<Value name="4">
<Value>ServiceEndpoint</Value>
</Value>
<Value name="5">
<Value>ServiceProvider</Value>
</Value>
<Value name="6">
<Value>CertRef</Value>
</Value>
</Data>
<State>InteractionTypeState</State>
<StreamLocation>^HS.AU.Type83FF.Interaction15AFS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
