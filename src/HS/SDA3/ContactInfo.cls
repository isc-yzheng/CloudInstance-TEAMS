/// ContactInfo appears in the SDA as properties of the Guarantor, HealthFund,<br>
/// Patient, and SupportContact, as well as CareProvider, FamilyDoctor,<br>
/// HealthFund, Organization, and ReferralDoctor in the HS.SDA3.CodeTableDetail<br>
/// package. How ContactInfo is parsed from HL7 and what fields, if any, are<br>
/// inserted into the Viewer Cache will depend on the specific property the<br>
/// ContactInfo is being used for, and are documented in the annotations for<br>
/// that property.
Class HS.SDA3.ContactInfo Extends HS.SDA3.DataType
{

Property Extension As HS.Local.SDA3.ContactInfoExtension;

Property HomePhoneNumber As %String(MAXLEN = 80);

Property WorkPhoneNumber As %String(MAXLEN = 80);

Property MobilePhoneNumber As %String(MAXLEN = 80);

Property EmailAddress As %String(MAXLEN = 254);

Storage Default
{
<Data name="ContactInfoState">
<Subscript>"ContactInfo"</Subscript>
<Value name="1">
<Value>HomePhoneNumber</Value>
</Value>
<Value name="2">
<Value>WorkPhoneNumber</Value>
</Value>
<Value name="3">
<Value>MobilePhoneNumber</Value>
</Value>
<Value name="4">
<Value>EmailAddress</Value>
</Value>
<Value name="5">
<Value>Extension</Value>
</Value>
</Data>
<State>ContactInfoState</State>
<Type>%Storage.Serial</Type>
}

}
