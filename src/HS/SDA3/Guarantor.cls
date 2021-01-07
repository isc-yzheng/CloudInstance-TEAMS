/// Guarantor appears on three places in the SDA: first, as a list property of<br>
/// HS.SDA3.Encounter. Guarantor also appears as a property <br>
/// of HS.SDA3.MemberEnrollment.  Both of these are supported and may be used.<br>
/// It also appears as a list property of HS.SDA3.Container; <br>
/// however, this property is only present for historical reasons and<br>
/// should not be used.<br><br>
/// Note that while this class does contain HL7 annotations, Guarantor is not<br>
/// parsed from HL7. The annotations are left in for historical reasons. The<br>
/// HealthShare HL7 Annotations do not contain the annotations from this class.<br><br>
/// Guarantor is not loaded into the Viewer Cache.
Class HS.SDA3.Guarantor Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.GuarantorExtension;

/// Primary name for this person (e.g. legal name)<br><br>
/// HL7:  GT1-3 : GuarantorName<br>
/// VIEWERLIB: Not stored<br><br>
/// .FamilyName<br>
/// HL7:  GT1-3.1.1 : FamilyNameSurname<br>
/// .FamilyNamePrefix<br>
/// HL7:  GT1-3.1.2 : FamilyNameOwnSurnamePrefix<br>
/// .GivenName<br>
/// HL7:  GT1-3.2 : GivenName<br>
/// .MiddleName<br>
/// HL7:  GT1-3.3 : SecondandFurtherGivenNames<br>
/// .NameSuffix<br>
/// HL7:  GT1-3.4 : Suffix<br>
/// .NamePrefix<br>
/// HL7:  GT1-3.5 : Prefix<br>
/// .ProfessionalSuffix<br>
/// HL7:  GT1-3.14 : ProfessionalSuffix<br>
Property Name As HS.SDA3.Name;

/// HL7:  GT1-5 : GuarantorAddress<br>
/// VIEWERLIB: Not stored<br><br>
/// .Street<br>
/// HL7:  GT1-5.1.1 : StreetAddressStreetorMailingAddress<br>
/// HL7:  GT1-5.2 : OtherDesignation<br>
/// .City<br>
/// HL7:  GT1-5.3 : City<br>
/// .State<br>
/// HL7:  GT1-5.4 : StateorProvince<br>
/// .Zip<br>
/// HL7:  GT1-5.5 : ZiporPostalCode<br>
/// .Country<br>
/// HL7:  GT1-5.6 : Country<br>
/// .County<br>
/// HL7:  GT1-5.9 : CountyParishCode<br>
/// .StartDate<br>
/// HL7:  GT1-5.13.1 : EffectiveDateTime<br>
/// .EndDate<br>
/// HL7:  GT1-5.14.1 : ExpirationDateTime<br>
Property Address As HS.SDA3.Address;

/// Contact information for the Guarantor<br><br>
/// HL7:  GT1-6 : GuarantorPhNumHome<br>
/// HL7:  GT1-7 : GuarantorPhNumBusiness<br>
/// VIEWERLIB: Not stored<br><br>
/// .HomePhoneNumber<br>
/// HL7:  GT1-6 : GuarantorPhNumHome<br>
/// .WorkPhoneNumber<br>
/// HL7:  GT1-7 : GuarantorPhNumBusiness<br>
/// .MobilePhoneNumber<br>
/// HL7:  GT1-6 : GuarantorPhNumHome<br>
/// HL7:  GT1-7 : GuarantorPhNumBusiness<br>
/// .EmailAddress<br>
/// HL7:  GT1-6 : GuarantorPhNumHome<br>
/// HL7:  GT1-7 : GuarantorPhNumBusiness<br>
Property ContactInfo As HS.SDA3.ContactInfo;

/// Date and time of birth of the guarantor<br><br>
/// HL7: GT1-8.1 : GuarantorDateTimeOfBirth.Time<br>
/// VIEWERLIB: Not stored
Property BirthTime As HS.SDA3.TimeStamp;

/// HL7ToSDA3:<br>
/// Though GT1-9 is not a coded element type of field, HL7ToSDA3 still only<br>
/// parses the first piece with respect to the Component Separator. This is<br>
/// parsed to the to the Gender Code. HL7ToSDA3 does not set the Description.<br><br>
/// HL7:  GT1-9 : GuarantorAdministrativeSex<br>
/// VIEWERLIB: Not stored
Property Gender As HS.SDA3.CodeTableDetail.Gender;

/// Relationship code of the guarantor<br><br>
/// HL7:  GT1-11 : GuarantorRelationship<br>
/// SDATableName=Relationship, ViewerClass=None<br>
/// VIEWERLIB: Not stored
Property Relationship As HS.SDA3.CodeTableDetail.Relationship;

/// Employer, Self, Family, Friend, etc.<br><br>
/// HL7:  GT1-10 : GuarantorType<br>
/// VIEWERLIB: Not stored
Property GuarantorType As %String(MAXLEN = 32000);

/// HL7:  GT1-2  : GuarantorNumber<br>
/// VIEWERLIB: Not stored<br><br>
/// .Number<br>
/// HL7:  GT1-2.1 : IDNumber<br>
/// .Organization<br>
/// The Assigning Authority for the number<br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// HL7:  GT1-2.4.1 : AssigningAuthorityNamespaceID<br>
/// HL7:  MSH-4 : SendingFacility<br>
/// .NumberType<br>
/// HL7:  GT1-2.5 : IdentifierTypeCode
Property GuarantorNumber As HS.SDA3.PatientNumber;

/// HL7:  GT1-12 : GuarantorSSN<br>
/// VIEWERLIB: Not stored
Property SSN As %String(MAXLEN = 220);

/// Effective start date for this guarantor<br><br>
/// HL7:  GT1-13 : GuarantorDateBegin<br>
/// VIEWERLIB: Not stored
Property FromTime As HS.SDA3.TimeStamp;

/// Effective end date for this guarantor<br><br>
/// HL7:  GT1-14 : GuarantorDateEnd<br>
/// VIEWERLIB: Not stored
Property ToTime As HS.SDA3.TimeStamp;

/// The name of the guarantor's employer, if the employer is a person<br><br>
/// HL7:  GT1-16 : GuarantorEmployerName<br>
/// VIEWERLIB: Not stored
Property EmployerName As HS.SDA3.Name;

/// HL7:  GT1-17 : GuarantorEmployerAddress<br>
/// VIEWERLIB: Not stored<br><br>
/// .Street<br>
/// HL7:  GT1-17.1.1 : StreetAddressStreetorMailingAddress<br>
/// HL7:  GT1-17.2 : OtherDesignation<br>
/// .City<br>
/// HL7:  GT1-17.3 : City<br>
/// .State<br>
/// HL7:  GT1-17.4 : StateorProvince<br>
/// .Zip<br>
/// HL7:  GT1-17.5 : ZiporPostalCode<br>
/// .Country<br>
/// HL7:  GT1-17.6 : Country<br>
/// .County<br>
/// HL7:  GT1-17.9 : CountyParishCode<br>
/// .StartDate<br>
/// HL7:  GT1-17.13.1 : EffectiveDateTime<br>
/// .EndDate<br>
/// HL7:  GT1-17.14.1 : ExpirationDateTime<br>
Property EmployerAddress As HS.SDA3.Address;

/// The name of the guarantor's employer, if the employer is an organization<br><br>
/// HL7:  GT1-51 : GuarantorEmployerOrganizationName<br>
/// VIEWERLIB: Not stored
Property EmployerOrganizationName As %String(MAXLEN = 300);

/// HL7:  GT1-18 : GuarantorEmployerPhoneNumber<br>
/// VIEWERLIB: Not stored
Property EmployerPhoneNumber As %String(MAXLEN = 60);

/// HL7:  GT1-20 : GuarantorEmploymentStatusCode<br>
/// VIEWERLIB: Not stored
Property EmploymentStatusCode As HS.SDA3.CodeTableDetail.EmploymentStatusCode;

/// The guarantor's employer's ID number<br><br>
/// HL7:  GT1-29.1 : GuarantorEmployerID.IDNumber<br>
/// VIEWERLIB: Not stored
Property EmployerID As %String(MAXLEN = 220);

/// The date when the guarantor was hired<br><br>
/// HL7:  GT1-31 : GuarantorHireEffectiveDate<br>
/// VIEWERLIB: Not stored
Property HireEffectiveDate As HS.SDA3.TimeStamp;

/// The date when the guarantor's employment ended<br><br>
/// HL7:  GT1-32 : GuarantorEmploymentStopDate<br>
/// VIEWERLIB: Not stored
Property EmploymentStopDate As HS.SDA3.TimeStamp;

/// The guarantor's job title<br><br>
/// HL7:  GT1-49 : GuarantorJobTitle<br>
/// VIEWERLIB: Not stored
Property JobTitle As %String;

/// The guarantor's occupation<br><br>
/// HL7:  GT1-50 : GuarantorOccupation<br>
/// VIEWERLIB: Not stored
Property Occupation As HS.SDA3.CodeTableDetail.Occupation;

/// Not used.
Property ActionScope As %String;

Storage Default
{
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
<Value>Name</Value>
</Value>
<Value name="9">
<Value>Address</Value>
</Value>
<Value name="10">
<Value>ContactInfo</Value>
</Value>
<Value name="11">
<Value>Relationship</Value>
</Value>
<Value name="12">
<Value>StartDate</Value>
</Value>
<Value name="13">
<Value>EndDate</Value>
</Value>
<Value name="14">
<Value>GuarantorType</Value>
</Value>
<Value name="15">
<Value>GuarantorNumber</Value>
</Value>
<Value name="16">
<Value>FromTime</Value>
</Value>
<Value name="17">
<Value>ToTime</Value>
</Value>
<Value name="18">
<Value>Deleted</Value>
</Value>
<Value name="19">
<Value>UpdatedOn</Value>
</Value>
<Value name="20">
<Value>CustomPairs</Value>
</Value>
<Value name="21">
<Value>Extension</Value>
</Value>
<Value name="22">
<Value>BirthTime</Value>
</Value>
<Value name="23">
<Value>Gender</Value>
</Value>
<Value name="24">
<Value>EmployerName</Value>
</Value>
<Value name="25">
<Value>EmployerAddress</Value>
</Value>
<Value name="26">
<Value>EmployerOrganizationName</Value>
</Value>
<Value name="27">
<Value>EmployerPhoneNumber</Value>
</Value>
<Value name="28">
<Value>EmploymentStatusCode</Value>
</Value>
<Value name="29">
<Value>EmployerID</Value>
</Value>
<Value name="30">
<Value>JobTitle</Value>
</Value>
<Value name="31">
<Value>Occupation</Value>
</Value>
<Value name="32">
<Value>HireEffectiveDate</Value>
</Value>
<Value name="33">
<Value>EmploymentStopDate</Value>
</Value>
<Value name="34">
<Value>SSN</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
