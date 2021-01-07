Class HS.Registry.Patient.Address Extends (%Persistent, HS.Types.Address, %Populate)
{

Parameter XMLTYPE = "PatAddress";

Parameter XMLIGNORENULL = "inputonly";

Relationship Patient As HS.Registry.Patient [ Cardinality = parent, Inverse = Addresses ];

Index CityIndex On City;

Index ZipIndex On PostalCode;

Index IDIndex On Idx [ IdKey ];

Property Idx As %Integer;

Method %OnAddToSaveSet(depth As %Integer, insert As %Integer, callcount As %Integer) As %Status [ Private, ServerOnly = 1 ]
{
	// To guarantee ordering per patient
	Set:..Idx="" ..Idx=$I(^HS.Registry.Patient.MainC("Addresses"))
		
	Quit $$$OK
}

Storage Default
{
<Data name="AddressDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StreetLine</Value>
</Value>
<Value name="3">
<Value>StreetNumber</Value>
</Value>
<Value name="4">
<Value>StreetName</Value>
</Value>
<Value name="5">
<Value>StreetType</Value>
</Value>
<Value name="6">
<Value>UnitNumber</Value>
</Value>
<Value name="7">
<Value>POBox</Value>
</Value>
<Value name="8">
<Value>County</Value>
</Value>
<Value name="9">
<Value>City</Value>
</Value>
<Value name="10">
<Value>State</Value>
</Value>
<Value name="11">
<Value>PostalCode</Value>
</Value>
<Value name="12">
<Value>Precinct</Value>
</Value>
<Value name="13">
<Value>Country</Value>
</Value>
<Value name="14">
<Value>Use</Value>
</Value>
<Value name="15">
<Value>Idx</Value>
</Value>
<Value name="16">
<Value>PrimaryFlag</Value>
</Value>
<Value name="17">
<Value>Active</Value>
</Value>
<Value name="18">
<Value>Status</Value>
</Value>
<Value name="19">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Addresses")</DataLocation>
<DefaultData>AddressDefaultData</DefaultData>
<IdLocation>^HS.Registry.Patient.MainC("Addresses")</IdLocation>
<IndexLocation>^HS.Registry.Patient.AddressI</IndexLocation>
<StreamLocation>^HS.Registry.Patient.AddressS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
