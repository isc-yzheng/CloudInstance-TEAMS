Class HS.Message.AddPatientRequest Extends (HS.Util.EnsRequest, HS.Types.PatientInfo) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// Default response class
Parameter RESPONSECLASSNAME As %String = "HS.Message.AddPatientResponse";

/// Whether to force an add or update.  Nil value lets MPI decide.  
/// "F"orce also lets the MPI decide, but also forces an overwrite of every field 
Property AddOrUpdate As %String(DISPLAYLIST = ",Add,Update,Force", VALUELIST = ",A,U,F");

Storage Default
{
<Data name="AddPatientRequestDefaultData">
<Subscript>"AddPatientRequest"</Subscript>
<Value name="1">
<Value>City</Value>
</Value>
<Value name="2">
<Value>DOB</Value>
</Value>
<Value name="3">
<Value>Facility</Value>
</Value>
<Value name="4">
<Value>FirstName</Value>
</Value>
<Value name="5">
<Value>Gateway</Value>
</Value>
<Value name="6">
<Value>LastName</Value>
</Value>
<Value name="7">
<Value>MRN</Value>
</Value>
<Value name="8">
<Value>Sex</Value>
</Value>
<Value name="9">
<Value>State</Value>
</Value>
<Value name="10">
<Value>Street</Value>
</Value>
<Value name="11">
<Value>Zip</Value>
</Value>
<Value name="12">
<Value>MPIID</Value>
</Value>
<Value name="13">
<Value>SSN</Value>
</Value>
<Value name="14">
<Value>Telephone</Value>
</Value>
<Value name="15">
<Value>MiddleName</Value>
</Value>
<Value name="16">
<Value>ControlledIDList</Value>
</Value>
<Value name="17">
<Value>AssigningAuthority</Value>
</Value>
<Value name="18">
<Value>Identifiers</Value>
</Value>
<Value name="19">
<Value>BusinessPhone</Value>
</Value>
<Value name="20">
<Value>Race</Value>
</Value>
<Value name="21">
<Value>CityOfBirth</Value>
</Value>
<Value name="22">
<Value>DriversLicenseNumber</Value>
</Value>
<Value name="23">
<Value>MothersMaidenSurname</Value>
</Value>
<Value name="24">
<Value>BirthOrder</Value>
</Value>
<Value name="25">
<Value>BirthPlace</Value>
</Value>
<Value name="26">
<Value>MaritalStatus</Value>
</Value>
<Value name="27">
<Value>ReligiousAffiliation</Value>
</Value>
<Value name="28">
<Value>EthnicGroup</Value>
</Value>
<Value name="29">
<Value>Language</Value>
</Value>
<Value name="30">
<Value>VIP</Value>
</Value>
<Value name="31">
<Value>Telecoms</Value>
</Value>
<Value name="32">
<Value>Addresses</Value>
</Value>
<Value name="33">
<Value>Prefix</Value>
</Value>
<Value name="34">
<Value>Suffix</Value>
</Value>
<Value name="35">
<Value>AddOrUpdate</Value>
</Value>
<Value name="36">
<Value>Names</Value>
</Value>
<Value name="37">
<Value>CustomClassName</Value>
</Value>
<Value name="38">
<Value>CustomXMLString</Value>
</Value>
<Value name="39">
<Value>CommunicationPreference</Value>
</Value>
<Value name="40">
<Value>CreatedBy</Value>
</Value>
<Value name="41">
<Value>CreatedOn</Value>
</Value>
<Value name="42">
<Value>LastEnteredBy</Value>
</Value>
<Value name="43">
<Value>LastEnteredOn</Value>
</Value>
<Value name="44">
<Value>DeathTime</Value>
</Value>
<Value name="45">
<Value>FathersName</Value>
</Value>
<Value name="46">
<Value>MothersName</Value>
</Value>
<Value name="47">
<Value>SpousesName</Value>
</Value>
<Value name="48">
<Value>DeathStatus</Value>
</Value>
<Value name="49">
<Value>Extension</Value>
</Value>
</Data>
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.AddPatientRequest.AdditionalInfo"</Subscript>
</Data>
<DefaultData>AddPatientRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
