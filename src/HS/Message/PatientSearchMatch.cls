Class HS.Message.PatientSearchMatch Extends (%Persistent, HS.Types.PatientInfo, HS.Types.RequestInfo) [ Inheritance = right ]
{

Parameter XMLIGNORENULL = "inputonly";

/// The source gateway for this patient match
Property Gateway As HS.Types.EndPoint;

/// The fetch/search status for this gateway
Property GatewayStatus As %Status;

/// The match rank or score (optional)
Property RankOrScore As %Numeric;

/// The list of information/document types, as a comma separated string
Property InfoTypes As %String(MAXLEN = "");

/// Does this match support infotype filtering?
/// The primary MPI always does, since the InfoTypes are stored in the hub
/// Secondary MPIs may or may not supply InfoTypes - if they do, then they
/// can set this to true
Property CanFilterInfoTypes As %Boolean [ InitialExpression = 0 ];

/// Problem with lookup
Property LookupError As %Boolean [ InitialExpression = 0 ];

/// Back pointer into the MPIIDList item associated with this search match item
Property MPIIDListItem As %Integer;

/// THis property is reserved for future use
Property Sensitive As %Boolean;

/// Index the MPIID for ordering
Index MPIIDIdx On MPIID;

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
<Data name="PatientSearchMatchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>City</Value>
</Value>
<Value name="3">
<Value>DOB</Value>
</Value>
<Value name="4">
<Value>Facility</Value>
</Value>
<Value name="5">
<Value>FirstName</Value>
</Value>
<Value name="6">
<Value>Gateway</Value>
</Value>
<Value name="7">
<Value>LastName</Value>
</Value>
<Value name="8">
<Value>MRN</Value>
</Value>
<Value name="9">
<Value>Sex</Value>
</Value>
<Value name="10">
<Value>State</Value>
</Value>
<Value name="11">
<Value>Street</Value>
</Value>
<Value name="12">
<Value>Zip</Value>
</Value>
<Value name="13">
<Value>MPIID</Value>
</Value>
<Value name="14">
<Value>MiddleName</Value>
</Value>
<Value name="15">
<Value>Consent</Value>
</Value>
<Value name="16">
<Value>Telephone</Value>
</Value>
<Value name="17">
<Value>GatewayStatus</Value>
</Value>
<Value name="18">
<Value>SSN</Value>
</Value>
<Value name="19">
<Value>BreakTheGlass</Value>
</Value>
<Value name="20">
<Value>RequestingFacility</Value>
</Value>
<Value name="21">
<Value>RequestingUser</Value>
</Value>
<Value name="22">
<Value>RequestingUserRoles</Value>
</Value>
<Value name="23">
<Value>Signature</Value>
</Value>
<Value name="24">
<Value>ClinicalTypes</Value>
</Value>
<Value name="25">
<Value>RequestId</Value>
</Value>
<Value name="26">
<Value>AssigningAuthority</Value>
</Value>
<Value name="27">
<Value>Type</Value>
</Value>
<Value name="28">
<Value>Rank</Value>
</Value>
<Value name="29">
<Value>AuthBy</Value>
</Value>
<Value name="30">
<Value>AuthType</Value>
</Value>
<Value name="31">
<Value>BTGReason</Value>
</Value>
<Value name="32">
<Value>RequestingGateway</Value>
</Value>
<Value name="33">
<Value>RankOrScore</Value>
</Value>
<Value name="34">
<Value>InfoTypes</Value>
</Value>
<Value name="35">
<Value>LookupError</Value>
</Value>
<Value name="36">
<Value>CanFilterInfoTypes</Value>
</Value>
<Value name="37">
<Value>ControlledIDList</Value>
</Value>
<Value name="38">
<Value>BusinessPhone</Value>
</Value>
<Value name="39">
<Value>Race</Value>
</Value>
<Value name="40">
<Value>CityOfBirth</Value>
</Value>
<Value name="41">
<Value>DriversLicenseNumber</Value>
</Value>
<Value name="42">
<Value>MothersMaidenSurname</Value>
</Value>
<Value name="43">
<Value>BirthOrder</Value>
</Value>
<Value name="44">
<Value>RequestingForProxyUserID</Value>
</Value>
<Value name="45">
<Value>RequestingForProxyID</Value>
</Value>
<Value name="46">
<Value>MPIIDListItem</Value>
</Value>
<Value name="47">
<Value>Prefix</Value>
</Value>
<Value name="48">
<Value>Suffix</Value>
</Value>
<Value name="49">
<Value>Identifiers</Value>
</Value>
<Value name="50">
<Value>BirthPlace</Value>
</Value>
<Value name="51">
<Value>MaritalStatus</Value>
</Value>
<Value name="52">
<Value>ReligiousAffiliation</Value>
</Value>
<Value name="53">
<Value>EthnicGroup</Value>
</Value>
<Value name="54">
<Value>Language</Value>
</Value>
<Value name="55">
<Value>VIP</Value>
</Value>
<Value name="56">
<Value>Telecoms</Value>
</Value>
<Value name="57">
<Value>Addresses</Value>
</Value>
<Value name="58">
<Value>Names</Value>
</Value>
<Value name="59">
<Value>SAMLData</Value>
</Value>
<Value name="60">
<Value>Sensitive</Value>
</Value>
<Value name="61">
<Value>CustomClassName</Value>
</Value>
<Value name="62">
<Value>CustomXMLString</Value>
</Value>
<Value name="63">
<Value>CommunicationPreference</Value>
</Value>
<Value name="64">
<Value>CreatedBy</Value>
</Value>
<Value name="65">
<Value>CreatedOn</Value>
</Value>
<Value name="66">
<Value>LastEnteredBy</Value>
</Value>
<Value name="67">
<Value>LastEnteredOn</Value>
</Value>
<Value name="68">
<Value>DeathTime</Value>
</Value>
<Value name="69">
<Value>FathersName</Value>
</Value>
<Value name="70">
<Value>MothersName</Value>
</Value>
<Value name="71">
<Value>SpousesName</Value>
</Value>
<Value name="72">
<Value>DeathStatus</Value>
</Value>
<Value name="73">
<Value>Extension</Value>
</Value>
</Data>
<DataLocation>^CacheTemp.HS.PatSearchMatchD($Namespace)</DataLocation>
<DefaultData>PatientSearchMatchDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HSTempCounter("PatMatch")</IdLocation>
<IndexLocation>^CacheTemp.HS.PatSearchMatchI($Namespace)</IndexLocation>
<StreamLocation>^CacheTemp.HS.PatSearchMatchS($Namespace)</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
