/// HS.SDA3.HealthFund corresponds to the CDA Payers section.
Class HS.SDA3.HealthFund Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.HealthFundExtension;

/// Code for health fund that provides the insurance<br><br>
/// HL7ToSDA3:<br>
/// If both IN1-3.1 and -4.1 are null, the IN1 segment will not be processed.<br><br>
/// SDATableName=HealthFund, ViewerClass=User.HS.ARCInsuranceType<br>
/// VIEWERLIB: User.HS.PAAdmInsurance(INSInsTypeDR)<br><br>
/// .SDACodingStandard<br>
/// HL7:  IN1-3.4 : InsuranceCompanyID.AssigningAuthority<br>
/// VIEWERLIB: Not stored<br>
/// .Code<br>
/// HL7:  IN1-3.1 : InsuranceCompanyID.IDNumber<br>
/// VIEWERLIB: User.HS.ARCInsuranceType(INSTCode)<br>
/// .Description<br>
/// HL7:  IN1-4.1 : InsuranceCompanyName.OrganizationName<br>
/// VIEWERLIB: User.HS.ARCInsuranceType(INSTDesc)<br><br>
/// .Address<br>
/// HL7ToSDA3:<br>
/// Though IN1-5 is a repeating field, HL7ToSDA3 only uses the first instance.<br>
/// Also, only a Code is parsed for the City, State, Zip, Country, and County<br>
/// properties.  HL7ToSDA3 does not set a Description for these.<br>
/// HL7:  IN1-5 : InsuranceCompanyAddress<br>
/// VIEWERLIB: Not stored<br>
/// .Address.Street<br>
/// HL7ToSDA3:<br>
/// Street is parsed as: "[IN1-5.1.1]; [IN1-5.2]"<br>
/// HL7:  IN1-5.1.1 : InsuranceCompanyAddress.StreetAddress.StreetorMailingAddress<br>
/// HL7:  IN1-5.2 : InsuranceCompanyAddress.OtherDesignation<br>
/// .Address.City<br>
/// HL7:  IN1-5.3 : InsuranceCompanyAddress.City<br>
/// .Address.State<br>
/// HL7:  IN1-5.4 : InsuranceCompanyAddress.StateorProvince<br>
/// .Address.Zip<br>
/// HL7:  IN1-5.5 : InsuranceCompanyAddress.ZiporPostalCode<br>
/// .Address.Country<br>
/// HL7:  IN1-5.6 : InsuranceCompanyAddress.Country<br>
/// .Address.County<br>
/// HL7:  IN1-5.9 : InsuranceCompanyAddress.CountyParishCode<br>
/// .Address.FromTime<br>
/// HL7:  IN1-5.13.1 : InsuranceCompanyAddress.EffectiveDate.Time<br>
/// .Address.ToTime<br>
/// HL7:  IN1-5.14.1 : InsuranceCompanyAddress.ExpirationDate.Time<br>
/// .ContactPerson<br>
/// HL7:  IN1-6 : InsuranceCoContactPerson<br>
/// VIEWERLIB: Not stored<br>
/// .ContactPerson.FamilyName<br>
/// HL7:  IN1-6.1.1 : FamilyName.Surname<br>
/// .ContactPerson.FamilyNamePrefix<br>
/// HL7:  IN1-6.1.2 : FamilyName.OwnSurnamePrefix<br>
/// .ContactPerson.GivenName<br>
/// HL7:  IN1-6.2 : GivenName<br>
/// .ContactPerson.MiddleName<br>
/// HL7:  IN1-6.3 : SecondandFurtherGivenNames<br>
/// .ContactPerson.NameSuffix<br>
/// HL7:  IN1-6.4 : Suffix<br>
/// .ContactPerson.NamePrefix<br>
/// HL7:  IN1-6.5 : Prefix<br>
/// .ContactPerson.ProfessionalSuffix<br>
/// HL7:  IN1-6.14 : ProfessionalSuffix<br><br>
/// .ContactInfo<br>
/// HL7ToSDA3:<br>
/// IN1-7 is a repeating field, and each instance may populate WorkPhoneNumber,<br>
/// MobilePhoneNumber, or EmailAddress, depending on the values contained<br>
/// therein. For each instance of IN1-7, the algorithm to parse a phone number<br>
/// out of that instance is:<br>
/// -If subfields 5, 6, 7, and 8 are not all null, compose the number out of<br>
/// them as "+[.5] ([.6]) [.7] x[.8]".<br>
/// -Else if subfield 12 is not null, use that.<br>
/// -Else if subfield 1 is not null, use that.<br>
/// -Else continue to the next instance of this field.<br><br>
/// -Whichever number is parsed, if subfield 9 of that instance is not null, it<br>
/// will be appended to the number, delimited by a semicolon.<br>
/// Ex: "###-###-####;Main Number"<br>
/// HL7:  IN1-7 : InsuranceCoPhoneNumber<br>
/// VIEWERLIB: Not stored<br>
/// .ContactInfo.WorkPhoneNumber<br>
/// HL7ToSDA3:<br>
/// WorkPhoneNumber is parsed from the first instance of IN1-7 with subfield 2<br>
/// in ["",WPN,ASN,EMR], and subfield 3 in ["",PH], and from which a number can<br>
/// be parsed using the above algorithm.<br>
/// HL7:  IN1-7 : InsuranceCoPhoneNumber<br>
/// .ContactInfo.MobilePhoneNumber<br>
/// HL7ToSDA3:<br>
/// MobilePhoneNumber is parsed from the first instance with subfield 2 = "BPN"<br>
/// or subfield 3 in [CP,BP], and from which a number can be parsed using the<br>
/// above algorithm.<br>
/// HL7:  IN1-7 : InsuranceCoPhoneNumber<br>
/// .ContactInfo.EmailAddress<br>
/// HL7ToSDA3:<br>
/// EmailAddress is parsed from the first non-null instance of subfield 4 in<br>
/// IN1-7.<br>
/// HL7:  IN1-7.4 : InsuranceCoPhoneNumber.EmailAddress
Property HealthFund As HS.SDA3.CodeTableDetail.HealthFund;

/// Code for specific insurance plan<br><br>
/// HL7ToSDA3:<br>
/// HealthFundPlan will only be parsed if IN1-2.1 or .2 is not null.<br><br>
/// HL7:  IN1-2 : InsurancePlanID<br>
/// SDATableName=HealthFundPlan, ViewerClass=User.HS.ARCAuxilInsurType<br>
/// VIEWERLIB: User.HS.PAAdmInsurance(INSAuxInsTypeDR)<br><br>
/// .Code<br>
/// HL7:  IN1-2.1 : InsurancePlanID.Identifier<br>
/// VIEWERLIB: User.HS.ARCAuxilInsurType(AUXITCode)<br>
/// .Description<br>
/// HL7:  IN1-2.2 : InsurancePlanID.Text<br>
/// VIEWERLIB: User.HS.ARCAuxilInsurType(AUXITDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  IN1-2.3 : InsurancePlanID.NameofCodingSystem<br>
/// VIEWERLIB: Not stored
Property HealthFundPlan As HS.SDA3.CodeTableDetail.HealthFundPlan;

/// HL7ToSDA3:<br>
/// Though IN1-9 is a repeating field, HL7ToSDA3 only uses the first instance.<br><br>
/// HL7:  IN1-9.1 : GroupName.OrganizationName<br>
/// VIEWERLIB: Not stored
Property GroupName As %String(MAXLEN = 32000);

/// HL7:  IN1-8 : GroupNumber<br>
/// VIEWERLIB: Not stored
Property GroupNumber As %String(MAXLEN = 32000);

/// Membership Number or Policy Number<br><br>
/// HL7:  IN1-36 : PolicyNumber<br>
/// VIEWERLIB: User.HS.PAAdmInsurance(INSCardNo)
Property MembershipNumber As %String(MAXLEN = 220);

/// HL7:  IN1-15 : PlanType<br>
/// VIEWERLIB: Not stored
Property PlanType As %String(MAXLEN = 32000);

/// The name of the insured person<br><br>
/// HL7ToSDA3:<br>
/// Though IN1-16 is a repeating field, HL7ToSDA3 only uses the first instance.<br><br>
/// Viewer cache:<br>
/// INSCardholderName is a string property that is set as:<br>
/// "[NamePrefix] [GivenName] [MiddleName] [FamilyName]"<br>
/// or simply null if all those properties are null.<br><br>
/// HL7:  IN1-16 : NameOfInsured<br>
/// VIEWERLIB: User.HS.PAAdmInsurance(INSCardholderName)<br>
/// .FamilyName<br>
/// HL7:  IN1-16.1.1 : NameOfInsured.FamilyName.Surname<br>
/// VIEWERLIB: User.HS.PAAdmInsurance(INSCardholderName)<br>
/// .FamilyNamePrefix<br>
/// HL7:  IN1-16.1.2 : NameOfInsured.FamilyName.OwnSurnamePrefix<br>
/// VIEWERLIB: Not stored<br>
/// .GivenName<br>
/// HL7:  IN1-16.2 : NameOfInsured.GivenName<br>
/// VIEWERLIB: User.HS.PAAdmInsurance(INSCardholderName)<br>
/// .MiddleName<br>
/// HL7:  IN1-16.3 : NameOfInsured.SecondandFurtherGivenNames<br>
/// VIEWERLIB: User.HS.PAAdmInsurance(INSCardholderName)<br>
/// .NameSuffix<br>
/// HL7:  IN1-16.4 : NameOfInsured.Suffix<br>
/// VIEWERLIB: Not stored<br>
/// .NamePrefix<br>
/// HL7:  IN1-16.5 : NameOfInsured.Prefix<br>
/// VIEWERLIB: User.HS.PAAdmInsurance(INSCardholderName)<br>
/// .ProfessionalSuffix<br>
/// HL7:  IN1-16.14 : NameOfInsured.ProfessionalSuffix<br>
/// VIEWERLIB: Not stored
Property InsuredName As HS.SDA3.Name;

/// Address of insured person<br><br>
/// HL7ToSDA3:<br>
/// Though IN1-19 is a repeating field, HL7ToSDA3 only uses the first instance.<br>
/// Also, only a Code is parsed for the City, State, Zip, and Country<br>
/// properties.  HL7ToSDA3 does not set a Description for these.<br><br>
/// HL7:  IN1-19 : InsuredsAddress<br><br>
/// .Street<br>
/// HL7ToSDA3:<br>
/// Street is parsed as "[IN-19.1.1]; [IN1-19.2]".<br>
/// HL7:  IN1-19.1.1 : InsuredsAddress.StreetAddress.StreetorMailingAddress<br>
/// HL7:  IN1-19.2 : InsuredsAddress.OtherDesignation<br>
/// VIEWERLIB: User.HS.PAAdmInsurance(INSCardholderAddress)<br>
/// .City<br>
/// HL7:  IN1-19.3 : InsuredsAddress.City<br>
/// VIEWERLIB: User.HS.PAAdmInsurance(INSCardholderCityDR)<br>
/// .State<br>
/// HL7:  IN1-19.4 : InsuredsAddress.StateorProvince<br>
/// VIEWERLIB: Not stored<br>
/// .Zip<br>
/// HL7:  IN1-19.5 : InsuredsAddress.ZiporPostalCode<br>
/// VIEWERLIB: User.HS.PAAdmInsurance(INSCardholderZipDR)<br>
/// .Country<br>
/// HL7:  IN1-19.6 : InsuredsAddress.Country<br>
/// VIEWERLIB: Not stored<br>
/// .County<br>
/// HL7:  IN1-19.9 : InsuredsAddress.CountyParishCode<br>
/// VIEWERLIB: Not stored<br>
/// .FromTime<br>
/// HL7:  IN1-19.13.1 : InsuredsAddress.EffectiveDate.Time<br>
/// VIEWERLIB: Not stored<br>
/// .ToTime<br>
/// HL7:  IN1-19.14.1 : InsuredsAddress.ExpirationDate.Time<br>
/// VIEWERLIB: Not stored
Property InsuredAddress As HS.SDA3.Address;

/// Contact information for the Insured person<br><br>
/// VIEWERLIB: Not stored
Property InsuredContact As HS.SDA3.ContactInfo;

/// Relationship of insured person to patient<br><br>
/// HL7ToSDA3:<br>
/// IN1-17 will only be parsed if IN1-17.1 or .2 are not null.<br><br>
/// HL7:  IN1-17 : InsuredsRelationshipToPatient<br>
/// SDATableName=Relationship, ViewerClass=None<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  IN1-17.1 : InsuredsRelationshipToPatient.Identifier<br>
/// .Description<br>
/// HL7:  IN1-17.2 : InsuredsRelationshipToPatient.Text<br>
/// .SDACodingStandard<br>
/// HL7:  IN1-17.3 : InsuredsRelationshipToPatient.NameofCodingSystem<br>
Property InsuredRelationship As HS.SDA3.CodeTableDetail.Relationship;

/// If the insurance works in conjunction with other insurance plans, this
/// field contains priority sequence. Values are: 1, 2, 3, etc.<br><br>
/// HL7:  IN1-22 : CoordofBenPriority<br>
/// VIEWERLIB: Not stored
Property Priority As %String;

/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: User.HS.PAAdmInsurance(INSUpdateUserDR)
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.PAAdmInsurance(INSUpdateUserHospitalDR)
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// VIEWERLIB: User.HS.PAAdmInsurance(INSUpdateDate) + User.HS.PAAdmInsurance(INSUpdateTime)
Property EnteredOn As HS.SDA3.TimeStamp;

/// Effective date of insurance<br><br>
/// Viewer cache:<br>
/// Only the date part of FromTime is stored in the viewer cache. (Both of the<br>
/// fields it is stored to are date-only.)<br><br>
/// HL7:  IN1-12 : PlanEffectiveDate<br>
/// VIEWERLIB: User.HS.PAAdmInsurance(INSDateTypeFrom)<br>
/// VIEWERLIB: User.HS.PAAdmInsurance(INSDateValidFrom)<br>
Property FromTime As HS.SDA3.TimeStamp;

/// Expiration date of insurance<br><br>
/// Viewer cache:<br>
/// Only the date part of ToTime is stored in the viewer cache. (INSDateTypeTo<br>
/// is date-only.)<br><br>
/// HL7:  IN1-12 : PlanExpirationDate<br>
/// VIEWERLIB: User.HS.PAAdmInsurance(INSDateTypeTo)<br>
Property ToTime As HS.SDA3.TimeStamp;

/// Not used.
Property ActionCode As %String;

/// Not used.
Property ActionScope As %String;

/// Not used.
Property UpdatedOn As HS.SDA3.TimeStamp;

/// Not used.
Property ExternalId As %String(MAXLEN = 220);

/// Not used.
Property EncounterNumber As %String(MAXLEN = 220);

/// Tax ID number for the health fund.
Property TaxId As HS.SDA3.Identifier;

/// Payer ID for the health fund.
Property PayerId As HS.SDA3.Identifier;

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
<Value>HealthFund</Value>
</Value>
<Value name="9">
<Value>HealthFundPlan</Value>
</Value>
<Value name="10">
<Value>GroupName</Value>
</Value>
<Value name="11">
<Value>GroupNumber</Value>
</Value>
<Value name="12">
<Value>MembershipNumber</Value>
</Value>
<Value name="13">
<Value>PlanType</Value>
</Value>
<Value name="14">
<Value>EffectiveDate</Value>
</Value>
<Value name="15">
<Value>ExpirationDate</Value>
</Value>
<Value name="16">
<Value>InsuredName</Value>
</Value>
<Value name="17">
<Value>InsuredAddress</Value>
</Value>
<Value name="18">
<Value>InsuredContact</Value>
</Value>
<Value name="19">
<Value>InsuredRelationship</Value>
</Value>
<Value name="20">
<Value>FromTime</Value>
</Value>
<Value name="21">
<Value>ToTime</Value>
</Value>
<Value name="22">
<Value>Deleted</Value>
</Value>
<Value name="23">
<Value>UpdatedOn</Value>
</Value>
<Value name="24">
<Value>CustomPairs</Value>
</Value>
<Value name="25">
<Value>Priority</Value>
</Value>
<Value name="26">
<Value>Extension</Value>
</Value>
<Value name="27">
<Value>TaxId</Value>
</Value>
<Value name="28">
<Value>PayerId</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
