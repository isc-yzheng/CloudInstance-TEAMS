/// HS.SDA3.Medication corresponds to the CDA Medications section, the
/// Medications Administered section, and the Hospital Discharge Medications
/// section.
Class HS.SDA3.Medication Extends (HS.SDA3.AbstractMedication, HS.SDA3.SuperClass)
{

Property Extension As HS.Local.SDA3.MedicationExtension;

Parameter ORDERITEMTYPE = "MED";

/// Optional scope used to qualify ActionCode "I" or "C"<br>
/// May be "ADMISSION", "DISCHARGE", "ADMINISTERED", "MEDICATIONS", or null.<br>
/// For any other value, an error will be logged and the streamlet will not be<br>
/// processed. If a valid, non-null ActionScope is given, then only Medications<br>
/// with a matching (case-insensitive) value for PharmacyStatus will be<br>
/// inactivated or cleared. If ActionScope is null, then every matching<br>
/// Medication will be deleted. See the annotation on the superclass property<br>
/// for more information on how ActionScope is used.<br><br>
/// VIEWERLIB: Not stored
Property ActionScope;

Storage Default
{
<Data name="MedicationState">
<Subscript>"Medication"</Subscript>
<Value name="1">
<Value>ActionCode</Value>
</Value>
<Value name="2">
<Value>ActionScope</Value>
</Value>
<Value name="3">
<Value>EnteredBy</Value>
</Value>
<Value name="4">
<Value>EnteredAt</Value>
</Value>
<Value name="5">
<Value>EnteredOn</Value>
</Value>
<Value name="6">
<Value>ExternalId</Value>
</Value>
<Value name="7">
<Value>DoseQuantity</Value>
</Value>
<Value name="8">
<Value>MaxDoseQuantity</Value>
</Value>
<Value name="9">
<Value>CallbackNumber</Value>
</Value>
<Value name="10">
<Value>DoseUoM</Value>
</Value>
<Value name="11">
<Value>DosageForm</Value>
</Value>
<Value name="12">
<Value>Route</Value>
</Value>
<Value name="13">
<Value>Indication</Value>
</Value>
<Value name="14">
<Value>EndTime</Value>
</Value>
<Value name="15">
<Value>PrescriptionNumber</Value>
</Value>
<Value name="16">
<Value>Frequency</Value>
</Value>
<Value name="17">
<Value>Duration</Value>
</Value>
<Value name="18">
<Value>DosageSteps</Value>
</Value>
<Value name="19">
<Value>Administrations</Value>
</Value>
<Value name="20">
<Value>ComponentMeds</Value>
</Value>
<Value name="21">
<Value>Condition</Value>
</Value>
<Value name="22">
<Value>TextInstruction</Value>
</Value>
<Value name="23">
<Value>OrderGroup</Value>
</Value>
<Value name="24">
<Value>Comments</Value>
</Value>
<Value name="25">
<Value>ConsultationDepartment</Value>
</Value>
<Value name="26">
<Value>AuthorizationTime</Value>
</Value>
<Value name="27">
<Value>ReceivingLocation</Value>
</Value>
<Value name="28">
<Value>VerifiedComments</Value>
</Value>
<Value name="29">
<Value>ResultCopiesTo</Value>
</Value>
<Value name="30">
<Value>ConfidentialityCode</Value>
</Value>
<Value name="31">
<Value>DrugProduct</Value>
</Value>
<Value name="32">
<Value>EncounterNumber</Value>
</Value>
<Value name="33">
<Value>EnteringOrganization</Value>
</Value>
<Value name="34">
<Value>FillerId</Value>
</Value>
<Value name="35">
<Value>NumberOfRefills</Value>
</Value>
<Value name="36">
<Value>OrderItem</Value>
</Value>
<Value name="37">
<Value>OrderQuantity</Value>
</Value>
<Value name="38">
<Value>OrderedBy</Value>
</Value>
<Value name="39">
<Value>PharmacyStatus</Value>
</Value>
<Value name="40">
<Value>PlacerId</Value>
</Value>
<Value name="41">
<Value>Priority</Value>
</Value>
<Value name="42">
<Value>RateAmount</Value>
</Value>
<Value name="43">
<Value>RateTimeUnit</Value>
</Value>
<Value name="44">
<Value>RateUnits</Value>
</Value>
<Value name="45">
<Value>ReassessmentTime</Value>
</Value>
<Value name="46">
<Value>RefillDescription</Value>
</Value>
<Value name="47">
<Value>RefillNumber</Value>
</Value>
<Value name="48">
<Value>Specimen</Value>
</Value>
<Value name="49">
<Value>SpecimenCollectedTime</Value>
</Value>
<Value name="50">
<Value>SpecimenReceivedTime</Value>
</Value>
<Value name="51">
<Value>StartTime</Value>
</Value>
<Value name="52">
<Value>Status</Value>
</Value>
<Value name="53">
<Value>StrengthVolume</Value>
</Value>
<Value name="54">
<Value>StrengthVolumeUnits</Value>
</Value>
<Value name="55">
<Value>VerifiedBy</Value>
</Value>
<Value name="56">
<Value>FromTime</Value>
</Value>
<Value name="57">
<Value>ToTime</Value>
</Value>
<Value name="58">
<Value>Deleted</Value>
</Value>
<Value name="59">
<Value>OrderCategory</Value>
</Value>
<Value name="60">
<Value>UpdatedOn</Value>
</Value>
<Value name="61">
<Value>CustomPairs</Value>
</Value>
<Value name="62">
<Value>GroupId</Value>
</Value>
</Data>
<Data name="SuperClassState">
<Subscript>"SuperClass"</Subscript>
<Value name="1">
<Value>ActionCode</Value>
</Value>
<Value name="2">
<Value>ActionScope</Value>
</Value>
<Value name="3">
<Value>EnteredBy</Value>
</Value>
<Value name="4">
<Value>EnteredAt</Value>
</Value>
<Value name="5">
<Value>EnteredOn</Value>
</Value>
<Value name="6">
<Value>ExternalId</Value>
</Value>
<Value name="7">
<Value>EncounterNumber</Value>
</Value>
<Value name="8">
<Value>PlacerId</Value>
</Value>
<Value name="9">
<Value>FillerId</Value>
</Value>
<Value name="10">
<Value>OrderItem</Value>
</Value>
<Value name="11">
<Value>OrderQuantity</Value>
</Value>
<Value name="12">
<Value>OrderedBy</Value>
</Value>
<Value name="13">
<Value>EnteringOrganization</Value>
</Value>
<Value name="14">
<Value>VerifiedBy</Value>
</Value>
<Value name="15">
<Value>CallbackNumber</Value>
</Value>
<Value name="16">
<Value>Specimen</Value>
</Value>
<Value name="17">
<Value>SpecimenCollectedTime</Value>
</Value>
<Value name="18">
<Value>SpecimenReceivedTime</Value>
</Value>
<Value name="19">
<Value>StartTime</Value>
</Value>
<Value name="20">
<Value>EndTime</Value>
</Value>
<Value name="21">
<Value>ReassessmentTime</Value>
</Value>
<Value name="22">
<Value>Frequency</Value>
</Value>
<Value name="23">
<Value>Duration</Value>
</Value>
<Value name="24">
<Value>Status</Value>
</Value>
<Value name="25">
<Value>Priority</Value>
</Value>
<Value name="26">
<Value>ConfidentialityCode</Value>
</Value>
<Value name="27">
<Value>Condition</Value>
</Value>
<Value name="28">
<Value>TextInstruction</Value>
</Value>
<Value name="29">
<Value>OrderGroup</Value>
</Value>
<Value name="30">
<Value>Comments</Value>
</Value>
<Value name="31">
<Value>ConsultationDepartment</Value>
</Value>
<Value name="32">
<Value>AuthorizationTime</Value>
</Value>
<Value name="33">
<Value>ReceivingLocation</Value>
</Value>
<Value name="34">
<Value>VerifiedComments</Value>
</Value>
<Value name="35">
<Value>ResultCopiesTo</Value>
</Value>
<Value name="36">
<Value>DrugProduct</Value>
</Value>
<Value name="37">
<Value>StrengthVolume</Value>
</Value>
<Value name="38">
<Value>StrengthVolumeUnits</Value>
</Value>
<Value name="39">
<Value>RateAmount</Value>
</Value>
<Value name="40">
<Value>RateUnits</Value>
</Value>
<Value name="41">
<Value>RateTimeUnit</Value>
</Value>
<Value name="42">
<Value>DoseQuantity</Value>
</Value>
<Value name="43">
<Value>MaxDoseQuantity</Value>
</Value>
<Value name="44">
<Value>NumberOfRefills</Value>
</Value>
<Value name="45">
<Value>DoseUoM</Value>
</Value>
<Value name="46">
<Value>DosageForm</Value>
</Value>
<Value name="47">
<Value>Route</Value>
</Value>
<Value name="48">
<Value>Indication</Value>
</Value>
<Value name="49">
<Value>PharmacyStatus</Value>
</Value>
<Value name="50">
<Value>PrescriptionNumber</Value>
</Value>
<Value name="51">
<Value>RefillNumber</Value>
</Value>
<Value name="52">
<Value>RefillDescription</Value>
</Value>
<Value name="53">
<Value>DosageSteps</Value>
</Value>
<Value name="54">
<Value>Administrations</Value>
</Value>
<Value name="55">
<Value>ComponentMeds</Value>
</Value>
</Data>
<State>MedicationState</State>
<Type>%Storage.Serial</Type>
}

}
