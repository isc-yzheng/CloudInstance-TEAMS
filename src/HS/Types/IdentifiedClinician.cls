Class HS.Types.IdentifiedClinician Extends (%SerialObject, HS.Types.IDNumber) [ Inheritance = right ]
{

Property ClinicianType As %String;

Storage Default
{
<Data name="IdentifiedClinicianState">
<Value name="1">
<Value>ClinicianType</Value>
</Value>
<Value name="2">
<Value>AssigningAuthority</Value>
</Value>
<Value name="3">
<Value>Number</Value>
</Value>
</Data>
<State>IdentifiedClinicianState</State>
<StreamLocation>^HS.Types.IdentifiedClinicianS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
