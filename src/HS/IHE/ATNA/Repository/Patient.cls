Class HS.IHE.ATNA.Repository.Patient Extends (%Persistent, %XML.Adaptor)
{

Relationship AggregationID As HS.IHE.ATNA.Repository.Aggregation [ Cardinality = parent, Inverse = Patients ];

/// Will contain either one MPIID or one MRN (facility^number^AA)
Property Identifier As %String(MAXLEN = "", SELECTIVITY = ".0001%");

/// Either MRN or MPIID
Property IdentifierType As %String;

Property PatientName As %String(MAXLEN = "");

/// For IHE requests, can record either "MSH-10,"_encoded value of MSH10,
/// or "II,"_$request/hl7:id@root
Property RequestId As %String(MAXLEN = "");

Index IdentIndex On (Identifier, IdentifierType);

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Identifier</Value>
</Value>
<Value name="3">
<Value>IdentifierType</Value>
</Value>
<Value name="4">
<Value>PatientName</Value>
</Value>
<Value name="5">
<Value>RequestId</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Patients")</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.IHE.Audit("Patients")</IdLocation>
<IndexLocation>^HS.IHE.Audit("PatientsI")</IndexLocation>
<StreamLocation>^HS.IHE.Audit("PatientsS")</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
