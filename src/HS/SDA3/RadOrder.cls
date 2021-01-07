/// For Radiology Orders
Class HS.SDA3.RadOrder Extends (HS.SDA3.AbstractResultOrder, HS.SDA3.SuperClass)
{

Property Extension As HS.Local.SDA3.RadOrderExtension;

Parameter ORDERITEMTYPE = "RAD";

Storage Default
{
<Data name="RadOrderState">
<Subscript>"RadOrder"</Subscript>
<Value name="1">
<Value>Result</Value>
</Value>
<Value name="2">
<Value>PlacerId</Value>
</Value>
<Value name="3">
<Value>FillerId</Value>
</Value>
<Value name="4">
<Value>OrderItem</Value>
</Value>
<Value name="5">
<Value>OrderQuantity</Value>
</Value>
<Value name="6">
<Value>OrderedBy</Value>
</Value>
<Value name="7">
<Value>EnteringOrganization</Value>
</Value>
<Value name="8">
<Value>VerifiedBy</Value>
</Value>
<Value name="9">
<Value>CallbackNumber</Value>
</Value>
<Value name="10">
<Value>Specimen</Value>
</Value>
<Value name="11">
<Value>SpecimenCollectedTime</Value>
</Value>
<Value name="12">
<Value>SpecimenReceivedTime</Value>
</Value>
<Value name="13">
<Value>StartTime</Value>
</Value>
<Value name="14">
<Value>EndTime</Value>
</Value>
<Value name="15">
<Value>ReassessmentTime</Value>
</Value>
<Value name="16">
<Value>Frequency</Value>
</Value>
<Value name="17">
<Value>Duration</Value>
</Value>
<Value name="18">
<Value>Status</Value>
</Value>
<Value name="19">
<Value>Priority</Value>
</Value>
<Value name="20">
<Value>ConfidentialityCode</Value>
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
<State>RadOrderState</State>
<Type>%Storage.Serial</Type>
}

}
