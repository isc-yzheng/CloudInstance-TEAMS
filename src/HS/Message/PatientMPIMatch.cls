Class HS.Message.PatientMPIMatch Extends (%Persistent, HS.Types.PatientInfo, HS.Types.RequestInfo) [ Inheritance = right ]
{

/// The best rank for all patient search matches (including ones filtered out) for this MPIID
Property Rank As %Numeric;

/// This points into the index for the list of PatientSearchMatch results for all matches for this MPIID
/// Note - it is possible for this list to be empty, in cases where all rows have been filtered out by consent
Property SearchMatches As list Of %Integer;

/// True if any records have been filtered by consent
Property ConsentFiltered As %Boolean;

/// The list of relationships that exist between this patient and the clinician
Property Relationships As list Of %String;

/// For program membership, is this MPI a member of the program being maintained
Property IsMember As %Boolean;

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"CustomAuditInfo"</Subscript>
</Data>
<Data name="PatientMPIMatchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Rank</Value>
</Value>
<Value name="3">
<Value>Facility</Value>
</Value>
<Value name="4">
<Value>AssigningAuthority</Value>
</Value>
<Value name="5">
<Value>FirstName</Value>
</Value>
<Value name="6">
<Value>MPIID</Value>
</Value>
<Value name="7">
<Value>ControlledIDList</Value>
</Value>
<Value name="8">
<Value>Street</Value>
</Value>
<Value name="9">
<Value>City</Value>
</Value>
<Value name="10">
<Value>State</Value>
</Value>
<Value name="11">
<Value>Zip</Value>
</Value>
<Value name="12">
<Value>SSN</Value>
</Value>
<Value name="13">
<Value>Telephone</Value>
</Value>
<Value name="14">
<Value>BusinessPhone</Value>
</Value>
<Value name="15">
<Value>Race</Value>
</Value>
<Value name="16">
<Value>CityOfBirth</Value>
</Value>
<Value name="17">
<Value>DriversLicenseNumber</Value>
</Value>
<Value name="18">
<Value>MothersMaidenSurname</Value>
</Value>
<Value name="19">
<Value>BirthOrder</Value>
</Value>
<Value name="20">
<Value>DOB</Value>
</Value>
<Value name="21">
<Value>LastName</Value>
</Value>
<Value name="22">
<Value>MRN</Value>
</Value>
<Value name="23">
<Value>MiddleName</Value>
</Value>
<Value name="24">
<Value>SearchMatches</Value>
</Value>
<Value name="25">
<Value>Sex</Value>
</Value>
<Value name="26">
<Value>ConsentFiltered</Value>
</Value>
<Value name="27">
<Value>Relationships</Value>
</Value>
<Value name="28">
<Value>Prefix</Value>
</Value>
<Value name="29">
<Value>Suffix</Value>
</Value>
<Value name="30">
<Value>Identifiers</Value>
</Value>
<Value name="31">
<Value>BirthPlace</Value>
</Value>
<Value name="32">
<Value>MaritalStatus</Value>
</Value>
<Value name="33">
<Value>ReligiousAffiliation</Value>
</Value>
<Value name="34">
<Value>EthnicGroup</Value>
</Value>
<Value name="35">
<Value>Language</Value>
</Value>
<Value name="36">
<Value>VIP</Value>
</Value>
<Value name="37">
<Value>Telecoms</Value>
</Value>
<Value name="38">
<Value>Addresses</Value>
</Value>
<Value name="39">
<Value>IsMember</Value>
</Value>
<Value name="40">
<Value>Names</Value>
</Value>
<Value name="41">
<Value>CustomClassName</Value>
</Value>
<Value name="42">
<Value>CustomXMLString</Value>
</Value>
<Value name="43">
<Value>CommunicationPreference</Value>
</Value>
<Value name="44">
<Value>CreatedBy</Value>
</Value>
<Value name="45">
<Value>CreatedOn</Value>
</Value>
<Value name="46">
<Value>LastEnteredBy</Value>
</Value>
<Value name="47">
<Value>LastEnteredOn</Value>
</Value>
<Value name="48">
<Value>DeathTime</Value>
</Value>
<Value name="49">
<Value>FathersName</Value>
</Value>
<Value name="50">
<Value>MothersName</Value>
</Value>
<Value name="51">
<Value>SpousesName</Value>
</Value>
<Value name="52">
<Value>AuthBy</Value>
</Value>
<Value name="53">
<Value>AuthType</Value>
</Value>
<Value name="54">
<Value>BTGReason</Value>
</Value>
<Value name="55">
<Value>RequestingUser</Value>
</Value>
<Value name="56">
<Value>RequestingUserRoles</Value>
</Value>
<Value name="57">
<Value>RequestingForProxyUserID</Value>
</Value>
<Value name="58">
<Value>RequestingForProxyID</Value>
</Value>
<Value name="59">
<Value>Signature</Value>
</Value>
<Value name="60">
<Value>RequestId</Value>
</Value>
<Value name="61">
<Value>RequestingGateway</Value>
</Value>
<Value name="62">
<Value>Type</Value>
</Value>
<Value name="63">
<Value>SAMLData</Value>
</Value>
<Value name="64">
<Value>BreakTheGlass</Value>
</Value>
<Value name="65">
<Value>ClinicalTypes</Value>
</Value>
<Value name="66">
<Value>Consent</Value>
</Value>
<Value name="67">
<Value>DeathStatus</Value>
</Value>
<Value name="68">
<Value>Extension</Value>
</Value>
</Data>
<DataLocation>^CacheTemp.HS.PatMPIMatchD($Namespace)</DataLocation>
<DefaultData>PatientMPIMatchDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HSTempCounter("MPIMatch")</IdLocation>
<IndexLocation>^CacheTemp.HS.PatMPIMatchI($Namespace)</IndexLocation>
<StreamLocation>^CacheTemp.HS.PatMPIMatchS($Namespace)</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
