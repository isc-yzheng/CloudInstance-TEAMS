Class HS.AU.Types.ELS.QualifiedCertRefType Extends (%SerialObject, %XML.Adaptor)
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/qcr/xsd/QualifiedCertRef/2010";

Parameter XMLNAME = "QualifiedCertRefType";

Parameter XMLSEQUENCE = 1;

Property Type As %xsd.anyURI(XMLNAME = "type");

Property Value As %String(MAXLEN = "", XMLNAME = "value");

Storage Default
{
<Data name="QualifiedCertRefTypeState">
<Value name="1">
<Value>Type</Value>
</Value>
<Value name="2">
<Value>Value</Value>
</Value>
</Data>
<State>QualifiedCertRefTypeState</State>
<StreamLocation>^HS.AU.Type51E6.QualifiedCeC63DS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
