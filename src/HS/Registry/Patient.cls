Class HS.Registry.Patient Extends (%Persistent, HS.Util.UpdateFrom, %Populate, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter DSTIME = "AUTO";

Parameter DSINTERVAL = 5;

Relationship Identifiers As HS.Registry.Patient.Identifier [ Cardinality = children, Inverse = Patient ];

Relationship Addresses As HS.Registry.Patient.Address [ Cardinality = children, Inverse = Patient ];

Relationship Telecoms As HS.Registry.Patient.Telecom [ Cardinality = children, Inverse = Patient ];

Relationship Names As HS.Registry.Patient.Name [ Cardinality = children, Inverse = Patient ];

Index NameIndex On (Name.Family, Name.Given);

Index GenderIndex On Gender [ Type = bitmap ];

Index MRNIndex On (MRN, AssigningAuthority, Facility) [ Unique ];

Index SSNIndex On SSN;

Index StrippedSSNIndex On StrippedSSN;

Index FacilityIndex On Facility;

Index MPIIDIndex On MPIID;

Index DOBIndex On BirthDateTime;

Property Name As HS.Types.PersonName;

Property FullName As %String(MAXLEN = 256) [ SqlComputeCode = {Set {*} = {Name_Given}_" "_$S({Name_Middle}]"":$E({Name_Middle})_". ",1:"")_{Name_Family}_$S({Name_Suffix}]"":" "_{Name_Suffix},1:"") }, SqlComputed, Transient ];

Property BirthDateTime As %TimeStamp(SELECTIVITY = ".05%");

Property BirthMonth As %Integer [ SqlComputeCode = {Set {*} = $P({BirthDateTime},"-",2)}, SqlComputed, Transient ];

Property BirthYear As %Integer [ SqlComputeCode = {Set {*} = $P({BirthDateTime},"-",1)}, SqlComputed, Transient ];

Property BirthPlace As HS.Types.Address;

Property BirthOrder As %Integer;

Property Gender As %String(SELECTIVITY = "50%");

Property MaritalStatus As %String;

Property ReligiousAffiliation As %String;

Property Race As %String;

Property EthnicGroup As %String;

Property Language As %String;

Property VIP As %Boolean;

Property MothersMaidenSurname As %String(MAXLEN = 80);

Property MPIID As %String(SELECTIVITY = ".001%");

/// Facility for this patient
Property Facility As HS.Facility.Config(SELECTIVITY = "5%");

/// Assigning Authority for the MRN
Property AssigningAuthority As %String;

/// This patient's MRN (from the above assigning authority)
Property MRN As HS.Types.MRN(SELECTIVITY = ".004%");

/// Person's social security or government id
///  (made long to support hashed SSNs)
Property SSN As %String(MAXLEN = 220, SELECTIVITY = ".004%");

Property StrippedSSN As %String [ Calculated, SqlComputeCode = { Set {StrippedSSN} = $translate({SSN}," _-") }, SqlComputed ];

Property AdditionalInfo As array Of HS.Types.AdditionalInfoItem;

/// To allow arbitrary custom data to be added - this specifies a classname, whose object contents
/// will be serialed into CustomXMLString
Property CustomClassName As %String(MAXLEN = 64);

/// If a CustomClassName is used, this should represent the XML export of an object of that class.
/// The top tag should be "CustomXML"
Property CustomXMLString As %String(MAXLEN = "");

/// For MU2
Property CommunicationPreference As %String(DISPLAYLIST = ","""",Email,Phone,Mail", VALUELIST = ","""",Email,Phone,Mail");

Property CreatedBy As %String(MAXLEN = 200);

/// This is based on external input, coming from the patient's SDA CreatedOn
Property CreatedOn As %TimeStamp;

Property LastEnteredBy As %String(MAXLEN = 200);

/// This is based on external input, coming from the patient's SDA EnteredOn
Property LastEnteredOn As %TimeStamp;

Property LastEnteredOnC As %TimeStamp [ SqlComputeCode = {Set {*} = $S({LastEnteredOn}="":$ZDT({LastUpdated},3,1),1:{LastEnteredOn})}, SqlComputed, Transient ];

/// Date most recently inserted or updated - this is not based on external input; just on when the data is stored
Property LastUpdated As %Date(XMLPROJECTION = "NONE") [ InitialExpression = {$P($H,",")} ];

Property DeathStatus As %Boolean;

Property DeathTime As %TimeStamp;

Property FathersName As HS.Types.PersonName;

Property MothersName As HS.Types.PersonName;

Property SpousesName As HS.Types.PersonName;

/// Extension class for custom properties
Property Extension As HS.Local.SDA3.PatientExtension;

/// Lists the MRNs for an MPIID
Query MRNsForPatient(pMPIID As %String = "") As %SQLQuery(CONTAINID = 1)
{
	SELECT DISTINCT %exact(MRN) AS MRN,%exact(AssigningAuthority) AS AssigningAuthority FROM Patient WHERE MPIID = :pMPIID
}

/// Returns the best patient record = last updated at the top-tier facility
ClassMethod GetBestRecord(pMPIID As %String) As HS.Registry.Patient
{
	&SQL(SELECT TOP 1 ID INTO :tID FROM HS_Registry.Patient 
	     WHERE MPIID = :pMPIID 
	     ORDER BY IsNull(Facility->Tier,99999),LastEnteredOnC DESC, Facility, AssigningAuthority, MRN)
	Quit $S(SQLCODE:"",1:##class(HS.Registry.Patient).%OpenId(tID))
}

/// Returns the home patient record
ClassMethod GetHomeRecord(pMPIID As %String) As HS.Registry.Patient
{
	&SQL(SELECT ID INTO :tID FROM HS_Registry.Patient WHERE MPIID = :pMPIID AND Facility->HomeFacility = 1 )
	Quit $S(SQLCODE:"",1:##class(HS.Registry.Patient).%OpenId(tID))
}

/// Returns the patient record for AA / MRN
ClassMethod GetRecordForMRN(pAssigningAuthority As %String, pMRN As %String) As HS.Registry.Patient
{
	&SQL(SELECT ID INTO :tID FROM HS_Registry.Patient WHERE MRN = :pMRN AND AssigningAuthority = :pAssigningAuthority )
	Quit $S(SQLCODE:"",1:##class(HS.Registry.Patient).%OpenId(tID))
}

ClassMethod FuzzyDateMatch(pDateh1 As %Date = 0, pDateh2 As %Date = 0) As %Integer [ SqlProc ]
{
	If 'pDateh1||'pDateh2 Quit 1  //OK if either is null
	If pDateh1=pDateh2 Quit 1  //or identical
	If pDateh1>pDateh2 {
		Set tDif=pDateh1 - pDateh2
		Set tAge=$H - pDateh1
	}
	Else {
		Set tDif=pDateh2 - pDateh1
		Set tAge=$H - pDateh2
	}
	If tDif<8 Quit 1  //or within 1 week
	IF tDif<3654, tAge>0, tDif/tAge<.05 Quit 1  //or if different is less than 10 years and less than 5%
	Set tDate1=$ZD(pDateh1,8), tDate2=$ZD(pDateh2,8) //get 'em in YYYYMMDD format
	IF $E(tDate1,1,4)_$E(tDate1,7,8)_$E(tDate1,5,6)=tDate2 Quit 1  //or if transposed M & D
	S tDig=0
	For tI=1:1:8 IF $E(tDate1,tI)=$E(tDate2,tI) Set tDig=tDig+1 //count the number of matching digits
	IF tDig=7 Quit 1  //or if only differ by a single digit
	Quit 0
}

/// log a snapshot of the old version
Method %OnBeforeSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	IF insert Quit $$$OK
	Set tID=..%Id()
	Set tOld=##Class(HS.Registry.Patient).%OpenId(tID)
	Set tSC=tOld.XMLExportToString(.tOldData,"Patient","literal") Quit:$$$ISERR(tSC) tSC
	Set tOldMRN=tOld.FacilityGetObjectId()_"^"_tOld.AssigningAuthority_"^"_tOld.MRN
	Set ^HS.Registry.Patient.OldHistory(tOldMRN,$Now())=tOldData
	Quit $$$OK
}

/// log a complete history of all current and past links
Method %OnAfterSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	Set tMRN=..FacilityGetObjectId()_"^"_..AssigningAuthority_"^"_..MRN,tMPIID=..MPIID
	IF tMRN'="",tMPIID'="" Set ^HS.Registry.Patient.LinkHistory(tMPIID,tMRN)=""
	Quit $$$OK
}

/// Strips common punctuation from a social security number
ClassMethod StripSSN(pSSN As %String) As %String [ SqlProc ]
{
 	Quit $TR(pSSN," _-")
}

/// Strips common punctuation from a telephone number
ClassMethod StripPhone(pPhone As %String) As %String [ SqlProc ]
{
	Quit $TR(pPhone," _-().,/\")
}

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"AdditionalInfo"</Subscript>
</Data>
<Data name="PatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>BirthDateTime</Value>
</Value>
<Value name="4">
<Value>BirthMonth</Value>
</Value>
<Value name="5">
<Value>BirthYear</Value>
</Value>
<Value name="6">
<Value>BirthPlace</Value>
</Value>
<Value name="7">
<Value>Gender</Value>
</Value>
<Value name="8">
<Value>MaritalStatus</Value>
</Value>
<Value name="9">
<Value>ReligiousAffiliation</Value>
</Value>
<Value name="10">
<Value>Race</Value>
</Value>
<Value name="11">
<Value>EthnicGroup</Value>
</Value>
<Value name="12">
<Value>Language</Value>
</Value>
<Value name="13">
<Value>VIP</Value>
</Value>
<Value name="14">
<Value>MothersMaidenSurname</Value>
</Value>
<Value name="15">
<Value>MPIID</Value>
</Value>
<Value name="16">
<Value>Facility</Value>
</Value>
<Value name="17">
<Value>AssigningAuthority</Value>
</Value>
<Value name="18">
<Value>MRN</Value>
</Value>
<Value name="19">
<Value>SSN</Value>
</Value>
<Value name="20">
<Value>LastUpdated</Value>
</Value>
<Value name="21">
<Value>CustomClassName</Value>
</Value>
<Value name="22">
<Value>CustomXMLString</Value>
</Value>
<Value name="23">
<Value>CommunicationPreference</Value>
</Value>
<Value name="24">
<Value>CreatedBy</Value>
</Value>
<Value name="25">
<Value>CreatedOn</Value>
</Value>
<Value name="26">
<Value>LastEnteredBy</Value>
</Value>
<Value name="27">
<Value>LastEnteredOn</Value>
</Value>
<Value name="28">
<Value>DeathTime</Value>
</Value>
<Value name="29">
<Value>FathersName</Value>
</Value>
<Value name="30">
<Value>MothersName</Value>
</Value>
<Value name="31">
<Value>SpousesName</Value>
</Value>
<Value name="32">
<Value>BirthOrder</Value>
</Value>
<Value name="33">
<Value>DeathStatus</Value>
</Value>
<Value name="34">
<Value>Extension</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.Registry.PatientD</IdLocation>
<IndexLocation>^HS.Registry.PatientI</IndexLocation>
<StreamLocation>^HS.Registry.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
