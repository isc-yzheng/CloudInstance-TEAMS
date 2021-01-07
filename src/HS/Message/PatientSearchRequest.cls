Class HS.Message.PatientSearchRequest Extends (HS.Util.EnsRequest, HS.Types.PatientInfo, HS.Types.RequestInfo) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Parameter FOUNDATION = 1;

/// Default response class
Parameter RESPONSECLASSNAME As %String = "HS.Message.PatientSearchResponse";

Parameter XMLIGNORENULL = "inputonly";

/// Maximum number of matches to retrieve
Property MaxMatches As %Integer;

/// Search modes user - regular patient lookup, admin - mpi patient lookup no consent applied,
/// clinician -- mpi patient lookup, no consent applied, limited to patients with a pre-existing relationship with the clinician,
/// PIXPDQ - no consent applied, PIXPDQ_c - consent applied
/// ODS - for internal message from ODS to get a list of patients to load
Property SearchMode As %String(DISPLAYLIST = ",User,Admin,Clinician,Participation,AuditReport,PIXPDQ,PIXPDQ_c,ODS", VALUELIST = ",user,admin,clinician,participation,AuditReport,PIXPDQ,PIXPDQ_c,ODS") [ InitialExpression = "user" ];

/// Once the request gets to the Hub do we also want to query the secondary MPI operations
/// if this is coming in from another system we do not want to query out.
Property IgnoreSecondaryMPI As %Boolean [ InitialExpression = 0 ];

/// If present, this is used to filter the list of patient records to only
/// those who have one of the specified InfoTypes
Property InfoTypes As list Of %String(MAXLEN = "");

/// If present, this will override all other search criteria, and will look instead at the
/// most recently selected MPIIDs for the requesting user, and populate the MPIIDLIST list
Property Recent As %Boolean;

/// for search by relationship - relationship type ID or "Any"
Property Relationship As %String(MAXLEN = 256);

/// The clinician for whom we are looking for a relationship
Property RelationshipClinician As %String;

/// for search by cohort
Property Program As %String(MAXLEN = 256, ZENHIDDEN = 1);

/// For membership maintenance, the cohort whose membership is being maintained
/// This doesn't affect the search, but does affect consent, and causes the results to
/// contain an additional boolean for if the patient is a member of that cohort
Property Membership As %String(MAXLEN = 256, ZENHIDDEN = 1);

Property MPIIDLIST As list Of %String;

/// Minimum rank to consider a match.  If not specified, will use the setting in the MPI Operation.
/// Currently used by Quadramed only.
Property Threshold As %Numeric;

/// For search by Analytics ID - only valid in "user" searchmode, with consent
Property AnalyticsID As %String;

/// Percentage value 0 - 100 for matches, 0 having a linkage weight of 0 and 100 matching the validateThreshold, only used when the request does not contain a value
Property MinMatchPercentage As %Integer;

/// If present, the DOB search range will go from DOB to DOBRangeEnd
Property DOBRangeEnd As %Date(FORMAT = 3);

/// Flag indicating whether or not to call composite view to get demographics while searching for patient
/// Default as 1 and only gets disabled in very specific cases (in push notification cases to avoid racing condition at MPI engine)
Property CallCompositeView As %Boolean [ InitialExpression = 1 ];

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.PatientSearchRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.PatientSearchRequest.CustomAuditInfo"</Subscript>
</Data>
<Data name="PatientSearchRequestDefaultData">
<Subscript>"PatientSearchRequest"</Subscript>
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
<Value>MiddleName</Value>
</Value>
<Value name="14">
<Value>Consent</Value>
</Value>
<Value name="15">
<Value>RequestingFacility</Value>
</Value>
<Value name="16">
<Value>BreakTheGlass</Value>
</Value>
<Value name="17">
<Value>SSN</Value>
</Value>
<Value name="18">
<Value>Telephone</Value>
</Value>
<Value name="19">
<Value>MaxMatches</Value>
</Value>
<Value name="20">
<Value>RequestingUser</Value>
</Value>
<Value name="21">
<Value>RequestingUserRoles</Value>
</Value>
<Value name="22">
<Value>Signature</Value>
</Value>
<Value name="23">
<Value>ClinicalTypes</Value>
</Value>
<Value name="24">
<Value>RequestId</Value>
</Value>
<Value name="25">
<Value>AuthBy</Value>
</Value>
<Value name="26">
<Value>AuthType</Value>
</Value>
<Value name="27">
<Value>AssigningAuthority</Value>
</Value>
<Value name="28">
<Value>SearchMode</Value>
</Value>
<Value name="29">
<Value>RequestingGateway</Value>
</Value>
<Value name="30">
<Value>Type</Value>
</Value>
<Value name="31">
<Value>BTGReason</Value>
</Value>
<Value name="32">
<Value>IgnoreSecondaryMPI</Value>
</Value>
<Value name="33">
<Value>InfoTypes</Value>
</Value>
<Value name="34">
<Value>ControlledIDList</Value>
</Value>
<Value name="35">
<Value>BusinessPhone</Value>
</Value>
<Value name="36">
<Value>Race</Value>
</Value>
<Value name="37">
<Value>CityOfBirth</Value>
</Value>
<Value name="38">
<Value>DriversLicenseNumber</Value>
</Value>
<Value name="39">
<Value>MothersMaidenSurname</Value>
</Value>
<Value name="40">
<Value>BirthOrder</Value>
</Value>
<Value name="41">
<Value>RequestingForProxyUserID</Value>
</Value>
<Value name="42">
<Value>RequestingForProxyID</Value>
</Value>
<Value name="43">
<Value>Recent</Value>
</Value>
<Value name="44">
<Value>MPIIDLIST</Value>
</Value>
<Value name="45">
<Value>Identifiers</Value>
</Value>
<Value name="46">
<Value>Prefix</Value>
</Value>
<Value name="47">
<Value>Suffix</Value>
</Value>
<Value name="48">
<Value>BirthPlace</Value>
</Value>
<Value name="49">
<Value>MaritalStatus</Value>
</Value>
<Value name="50">
<Value>ReligiousAffiliation</Value>
</Value>
<Value name="51">
<Value>EthnicGroup</Value>
</Value>
<Value name="52">
<Value>Language</Value>
</Value>
<Value name="53">
<Value>VIP</Value>
</Value>
<Value name="54">
<Value>Telecoms</Value>
</Value>
<Value name="55">
<Value>Addresses</Value>
</Value>
<Value name="56">
<Value>Relationship</Value>
</Value>
<Value name="57">
<Value>RelationshipClinician</Value>
</Value>
<Value name="58">
<Value>Program</Value>
</Value>
<Value name="59">
<Value>Membership</Value>
</Value>
<Value name="60">
<Value>Names</Value>
</Value>
<Value name="61">
<Value>Threshold</Value>
</Value>
<Value name="62">
<Value>AnalyticsID</Value>
</Value>
<Value name="63">
<Value>SAMLData</Value>
</Value>
<Value name="64">
<Value>MinMatchPercentage</Value>
</Value>
<Value name="65">
<Value>CustomClassName</Value>
</Value>
<Value name="66">
<Value>CustomXMLString</Value>
</Value>
<Value name="67">
<Value>CommunicationPreference</Value>
</Value>
<Value name="68">
<Value>CreatedBy</Value>
</Value>
<Value name="69">
<Value>CreatedOn</Value>
</Value>
<Value name="70">
<Value>LastEnteredBy</Value>
</Value>
<Value name="71">
<Value>LastEnteredOn</Value>
</Value>
<Value name="72">
<Value>DeathTime</Value>
</Value>
<Value name="73">
<Value>FathersName</Value>
</Value>
<Value name="74">
<Value>MothersName</Value>
</Value>
<Value name="75">
<Value>SpousesName</Value>
</Value>
<Value name="76">
<Value>DeathStatus</Value>
</Value>
<Value name="77">
<Value>Extension</Value>
</Value>
<Value name="78">
<Value>DOBRangeEnd</Value>
</Value>
<Value name="79">
<Value>CallCompositeView</Value>
</Value>
</Data>
<DefaultData>PatientSearchRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
