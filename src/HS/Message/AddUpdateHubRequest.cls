Class HS.Message.AddUpdateHubRequest Extends (HS.Util.EnsRequest, HS.Types.PatientInfo, HS.Types.RequestInfo) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNORENULL = "inputonly";

Parameter FOUNDATION = 1;

Parameter RESPONSECLASSNAME As %String = "HS.Message.AddUpdateHubResponse";

Property DoMPIUpdate As %Boolean;

/// Added so that this message can be used instead of the RemovePatientRequest, to support Push
Property DoDelete As %Boolean;

/// Message InfoTypes - this contains the list of InfoTypes found in the message, for use in Push
Property InfoTypes As list Of %String(MAXLEN = "");

Property GatewayName As %String(MAXLEN = "");

Property DoPush As %Boolean;

Property EventType As %String;

Property EncounterTypes As list Of %String;

Property IdentifiedClinicians As list Of HS.Types.IdentifiedClinician;

/// Whether to force an add or update.  Nil value lets MPI decide.  
/// "F"orce also lets the MPI decide, but forces an overwrite of every field 
Property AddOrUpdate As %String(DISPLAYLIST = ",Add,Update,Force", VALUELIST = ",A,U,F");

/// For sending AnalyticsUpdate
Property AAUpdateQ As array Of %String(MAXLEN = "");

/// If true, the MPI Manager on the Registry will use this request to create an entry in
/// HS_IHE_ATNA_Repository.Aggregation which can be used for reporting. The entry will have
/// EventType="InboundMessage" and EventSubType=[MessageType of this request].
Property LogReportingEvent As %Boolean;

/// Like EventType, this property is meant to describe the event that triggered the update.
/// However this property is intended to be more granular. For example, a vaccination
/// message is distinguished from a regular medication.
Property MessageType As %String;

/// The addupdatehub message needs a small subset of encounter info in order to evaluate
/// relationship inference policies that utilize an Encounter entity
Property Encounters As list Of HS.Message.AddUpdateHubEncounterInfo;

/// Passed in for A45 and A50 move/change encounter number
Property PriorEncounterNumber As %String(MAXLEN = 220);

/// Passed in for A45 and A50 move/change encounter number
Property NewEncounterNumber As %String(MAXLEN = 220);

/// Passed in for A45 and A50 move/change encounter number
Property PriorEncounterMRN As HS.Types.MRN;

/// Passed in for A45 and A50 move/change encounter number
Property PriorEncounterAA As %String(MAXLEN = 64);

/// Copied in from production setting, because we are now always sending AAUpdateQ info
Property FeedAnalytics As %Boolean [ InitialExpression = 0 ];

Property DoFlash As %Boolean [ InitialExpression = 0 ];

/* Inherited from HS.Types.RequestInfo:
/// Additional patient information
/// AdditionalInfo("InfoTypes") contains a list of all the InfoTypes for the patient, to be stored
///  and used to display icons
Property AdditionalInfo As array Of HS.Types.AdditionalInfoItem;
*/
Storage Default
{
<Data name="AAUpdateQ">
<Attribute>AAUpdateQ</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.AddUpdateHubRequest.AAUpdateQ"</Subscript>
</Data>
<Data name="AddUpdateHubRequestDefaultData">
<Subscript>"AddUpdateHubRequest"</Subscript>
<Value name="1">
<Value>MPIUpdate</Value>
</Value>
<Value name="2">
<Value>InfoTypes</Value>
</Value>
<Value name="3">
<Value>DoMPIUpdate</Value>
</Value>
<Value name="4">
<Value>Facility</Value>
</Value>
<Value name="5">
<Value>AssigningAuthority</Value>
</Value>
<Value name="6">
<Value>FirstName</Value>
</Value>
<Value name="7">
<Value>MPIID</Value>
</Value>
<Value name="8">
<Value>DOB</Value>
</Value>
<Value name="9">
<Value>Street</Value>
</Value>
<Value name="10">
<Value>City</Value>
</Value>
<Value name="11">
<Value>State</Value>
</Value>
<Value name="12">
<Value>Zip</Value>
</Value>
<Value name="13">
<Value>SSN</Value>
</Value>
<Value name="14">
<Value>Telephone</Value>
</Value>
<Value name="15">
<Value>LastName</Value>
</Value>
<Value name="16">
<Value>MRN</Value>
</Value>
<Value name="17">
<Value>MiddleName</Value>
</Value>
<Value name="18">
<Value>Sex</Value>
</Value>
<Value name="19">
<Value>GatewayName</Value>
</Value>
<Value name="20">
<Value>DoPush</Value>
</Value>
<Value name="21">
<Value>EventType</Value>
</Value>
<Value name="22">
<Value>DeathStatus</Value>
</Value>
<Value name="23">
<Value>EncounterTypes</Value>
</Value>
<Value name="24">
<Value>ControlledIDList</Value>
</Value>
<Value name="25">
<Value>IdentifiedClinicians</Value>
</Value>
<Value name="26">
<Value>BusinessPhone</Value>
</Value>
<Value name="27">
<Value>Race</Value>
</Value>
<Value name="28">
<Value>CityOfBirth</Value>
</Value>
<Value name="29">
<Value>DriversLicenseNumber</Value>
</Value>
<Value name="30">
<Value>MothersMaidenSurname</Value>
</Value>
<Value name="31">
<Value>BirthOrder</Value>
</Value>
<Value name="32">
<Value>Identifiers</Value>
</Value>
<Value name="33">
<Value>BirthPlace</Value>
</Value>
<Value name="34">
<Value>MaritalStatus</Value>
</Value>
<Value name="35">
<Value>ReligiousAffiliation</Value>
</Value>
<Value name="36">
<Value>EthnicGroup</Value>
</Value>
<Value name="37">
<Value>Language</Value>
</Value>
<Value name="38">
<Value>VIP</Value>
</Value>
<Value name="39">
<Value>Telecoms</Value>
</Value>
<Value name="40">
<Value>Addresses</Value>
</Value>
<Value name="41">
<Value>Prefix</Value>
</Value>
<Value name="42">
<Value>Suffix</Value>
</Value>
<Value name="43">
<Value>AddOrUpdate</Value>
</Value>
<Value name="44">
<Value>Names</Value>
</Value>
<Value name="45">
<Value>AuthBy</Value>
</Value>
<Value name="46">
<Value>AuthType</Value>
</Value>
<Value name="47">
<Value>BTGReason</Value>
</Value>
<Value name="48">
<Value>RequestingUser</Value>
</Value>
<Value name="49">
<Value>RequestingUserRoles</Value>
</Value>
<Value name="50">
<Value>RequestingForProxyUserID</Value>
</Value>
<Value name="51">
<Value>RequestingForProxyID</Value>
</Value>
<Value name="52">
<Value>Signature</Value>
</Value>
<Value name="53">
<Value>RequestId</Value>
</Value>
<Value name="54">
<Value>RequestingGateway</Value>
</Value>
<Value name="55">
<Value>Type</Value>
</Value>
<Value name="56">
<Value>BreakTheGlass</Value>
</Value>
<Value name="57">
<Value>ClinicalTypes</Value>
</Value>
<Value name="58">
<Value>Consent</Value>
</Value>
<Value name="59">
<Value>RemovePatient</Value>
</Value>
<Value name="60">
<Value>DoDelete</Value>
</Value>
<Value name="61">
<Value>SAMLData</Value>
</Value>
<Value name="62">
<Value>LogReportingEvent</Value>
</Value>
<Value name="63">
<Value>MessageType</Value>
</Value>
<Value name="64">
<Value>CustomClassName</Value>
</Value>
<Value name="65">
<Value>CustomXMLString</Value>
</Value>
<Value name="66">
<Value>CommunicationPreference</Value>
</Value>
<Value name="67">
<Value>CreatedBy</Value>
</Value>
<Value name="68">
<Value>CreatedOn</Value>
</Value>
<Value name="69">
<Value>LastEnteredBy</Value>
</Value>
<Value name="70">
<Value>LastEnteredOn</Value>
</Value>
<Value name="71">
<Value>DeathTime</Value>
</Value>
<Value name="72">
<Value>FathersName</Value>
</Value>
<Value name="73">
<Value>MothersName</Value>
</Value>
<Value name="74">
<Value>SpousesName</Value>
</Value>
<Value name="75">
<Value>Encounters</Value>
</Value>
<Value name="76">
<Value>PriorEncounterNumber</Value>
</Value>
<Value name="77">
<Value>NewEncounterNumber</Value>
</Value>
<Value name="78">
<Value>PriorEncounterMRN</Value>
</Value>
<Value name="79">
<Value>PriorEncounterAA</Value>
</Value>
<Value name="80">
<Value>Extension</Value>
</Value>
<Value name="81">
<Value>FeedAnalytics</Value>
</Value>
<Value name="82">
<Value>DoFlash</Value>
</Value>
</Data>
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.AddUpdateHubRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.AddUpdateHubRequest.CustomAuditInfo"</Subscript>
</Data>
<DefaultData>AddUpdateHubRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
