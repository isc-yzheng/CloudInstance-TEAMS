Class HS.SDA3.LabOrder Extends (HS.SDA3.AbstractResultOrder, HS.SDA3.SuperClass)
{

Property Extension As HS.Local.SDA3.LabOrderExtension;

Parameter ORDERITEMTYPE = "LAB";

Parameter CANOVERRIDEPROPLIST = "Result";

Storage Default
{
<Data name="LabOrderState">
<Subscript>"LabOrder"</Subscript>
<Value name="1">
<Value>PlacerId</Value>
</Value>
<Value name="2">
<Value>FillerId</Value>
</Value>
<Value name="3">
<Value>OrderItem</Value>
</Value>
<Value name="4">
<Value>OrderQuantity</Value>
</Value>
<Value name="5">
<Value>OrderedBy</Value>
</Value>
<Value name="6">
<Value>EnteringOrganization</Value>
</Value>
<Value name="7">
<Value>VerifiedBy</Value>
</Value>
<Value name="8">
<Value>CallbackNumber</Value>
</Value>
<Value name="9">
<Value>Specimen</Value>
</Value>
<Value name="10">
<Value>SpecimenCollectedTime</Value>
</Value>
<Value name="11">
<Value>SpecimenReceivedTime</Value>
</Value>
<Value name="12">
<Value>StartTime</Value>
</Value>
<Value name="13">
<Value>EndTime</Value>
</Value>
<Value name="14">
<Value>ReassessmentTime</Value>
</Value>
<Value name="15">
<Value>Frequency</Value>
</Value>
<Value name="16">
<Value>Duration</Value>
</Value>
<Value name="17">
<Value>Status</Value>
</Value>
<Value name="18">
<Value>Priority</Value>
</Value>
<Value name="19">
<Value>ConfidentialityCode</Value>
</Value>
<Value name="20">
<Value>Condition</Value>
</Value>
<Value name="21">
<Value>TextInstruction</Value>
</Value>
<Value name="22">
<Value>OrderGroup</Value>
</Value>
<Value name="23">
<Value>Comments</Value>
</Value>
<Value name="24">
<Value>ConsultationDepartment</Value>
</Value>
<Value name="25">
<Value>AuthorizationTime</Value>
</Value>
<Value name="26">
<Value>ReceivingLocation</Value>
</Value>
<Value name="27">
<Value>VerifiedComments</Value>
</Value>
<Value name="28">
<Value>ResultCopiesTo</Value>
</Value>
<Value name="29">
<Value>Result</Value>
</Value>
<Value name="30">
<Value>ActionCode</Value>
</Value>
<Value name="31">
<Value>ActionScope</Value>
</Value>
<Value name="32">
<Value>EnteredBy</Value>
</Value>
<Value name="33">
<Value>EnteredAt</Value>
</Value>
<Value name="34">
<Value>EnteredOn</Value>
</Value>
<Value name="35">
<Value>FromTime</Value>
</Value>
<Value name="36">
<Value>ToTime</Value>
</Value>
<Value name="37">
<Value>ExternalId</Value>
</Value>
<Value name="38">
<Value>EncounterNumber</Value>
</Value>
<Value name="39">
<Value>Deleted</Value>
</Value>
<Value name="40">
<Value>OrderCategory</Value>
</Value>
<Value name="41">
<Value>UpdatedOn</Value>
</Value>
<Value name="42">
<Value>CustomPairs</Value>
</Value>
<Value name="43">
<Value>GroupId</Value>
</Value>
</Data>
<State>LabOrderState</State>
<Type>%Storage.Serial</Type>
}

}
