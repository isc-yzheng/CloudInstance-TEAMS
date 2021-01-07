/// 
Class HS.Message.IHE.PatientSearchMatch Extends HS.Message.PatientSearchMatch
{

Property IDs As list Of HS.Message.IHE.Match;

/// This parameter provides the default XMLTYPE for the class. If it is
/// empty then the class name will be used to construct a default XML type.
/// 
/// The default XMLTYPE is used when naming and referencing this type 
/// in a schema and the schema context did not provide an XML type name.
Parameter XMLTYPE = "PDQv3PatientSearchMatch";

Storage Default
{
<Data name="PatientSearchMatchDefaultData1">
<Subscript>"PatientSearchMatch"</Subscript>
<Value name="1">
<Value>IDs</Value>
</Value>
</Data>
<DefaultData>PatientSearchMatchDefaultData1</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
