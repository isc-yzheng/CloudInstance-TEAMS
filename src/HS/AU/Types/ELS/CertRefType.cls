Class HS.AU.Types.ELS.CertRefType Extends (%SerialObject, %XML.Adaptor)
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/els/xsd/DataTypes/2010";

Parameter XMLNAME = "ElsCertRefType";

Parameter XMLSEQUENCE = 1;

Property UseQualifier As %xsd.anyURI(XMLNAME = "useQualifier");

Property QualifiedCertRef As HS.AU.Types.ELS.QualifiedCertRefType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/qcr/xsd/QualifiedCertRef/2010", XMLNAME = "qualifiedCertRef", XMLREF = 1);

Storage Default
{
<Data name="ElsCertRefTypeState">
<Value name="1">
<Value>UseQualifier</Value>
</Value>
<Value name="2">
<Value>QualifiedCertRef</Value>
</Value>
</Data>
<State>ElsCertRefTypeState</State>
<StreamLocation>^HS.AU.Types83FF.ElsCertRefTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
