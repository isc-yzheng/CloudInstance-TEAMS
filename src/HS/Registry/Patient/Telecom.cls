Class HS.Registry.Patient.Telecom Extends (%Persistent, HS.Types.Telecom, %Populate)
{

Parameter XMLTYPE = "PatTelecom";

Parameter XMLIGNORENULL = "inputonly";

Relationship Patient As HS.Registry.Patient [ Cardinality = parent, Inverse = Telecoms ];

Index IDIndex On Idx [ IdKey ];

Property Idx As %Integer;

Method %OnAddToSaveSet(depth As %Integer, insert As %Integer, callcount As %Integer) As %Status [ Private, ServerOnly = 1 ]
{
	// To guarantee ordering per patient
	Set:..Idx="" ..Idx=$I(^HS.Registry.Patient.MainC("Telecoms"))
		
	Quit $$$OK
}

Storage Default
{
<Data name="TelecomDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PhoneNumberFull</Value>
</Value>
<Value name="3">
<Value>PhoneCountryCode</Value>
</Value>
<Value name="4">
<Value>PhoneAreaCode</Value>
</Value>
<Value name="5">
<Value>PhoneNumber</Value>
</Value>
<Value name="6">
<Value>URL</Value>
</Value>
<Value name="7">
<Value>Email</Value>
</Value>
<Value name="8">
<Value>Type</Value>
</Value>
<Value name="9">
<Value>Use</Value>
</Value>
<Value name="10">
<Value>EmailType</Value>
</Value>
<Value name="11">
<Value>PrimaryFlag</Value>
</Value>
<Value name="12">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Telecoms")</DataLocation>
<DefaultData>TelecomDefaultData</DefaultData>
<IdLocation>^HS.Registry.Patient.MainC("Telecoms")</IdLocation>
<IndexLocation>^HS.Registry.Patient.TelecomI</IndexLocation>
<StreamLocation>^HS.Registry.Patient.TelecomS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
