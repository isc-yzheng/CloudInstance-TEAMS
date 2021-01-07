Class HS.Registry.Patient.Name Extends (%Persistent, HS.Types.PersonName, %Populate)
{

Parameter XMLTYPE = "PatName";

Relationship Patient As HS.Registry.Patient [ Cardinality = parent, Inverse = Names ];

// Note: Not looking up these names for now

Index NameIndex On (Family, Given);

Index IDIndex On Idx [ IdKey ];

Property Idx As %Integer;

Method %OnAddToSaveSet(depth As %Integer, insert As %Integer, callcount As %Integer) As %Status [ Private, ServerOnly = 1 ]
{
	// To guarantee ordering per patient
	Set:..Idx="" ..Idx=$I(^HS.Registry.Patient.MainC("Names"))
		
	Quit $$$OK
}

Storage Default
{
<Data name="NameDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Family</Value>
</Value>
<Value name="3">
<Value>Given</Value>
</Value>
<Value name="4">
<Value>Middle</Value>
</Value>
<Value name="5">
<Value>Prefix</Value>
</Value>
<Value name="6">
<Value>Suffix</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Names")</DataLocation>
<DefaultData>NameDefaultData</DefaultData>
<IdLocation>^HS.Registry.PatientC("Names")</IdLocation>
<IndexLocation>^HS.Registry.Patient.NameI</IndexLocation>
<StreamLocation>^HS.Registry.Patient.NameS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
