/// SupportContact appears in the SDA as a list property (SupportContacts) of<br>
/// HS.SDA3.Patient.<br><br>
/// HL7ToSDA3:<br>
/// In the HL7ToSDA3 transform, it is possible for one NK1 segment to be parsed<br>
/// as two SupportContacts. One (referred to in these annotations as the<br>
/// "Inidividual Contact") is parsed from fields 2 through 9 (though nothing<br>
/// will be parsed, not even an empty SupportContact, if these are all null).<br>
/// The second ("Organization Contact") is parsed from fields 13, 30, 31, and<br>
/// 32, and only if field 13 is not null.<br><br>
/// Streamlet cache:<br>
/// Note that SupportContacts are not their own type of Streamlets, but are a<br>
/// serial property of HS.SDA3.Patient. In both the Streamlet Cache (Edge<br>
/// Gateway) and the Aggregation Cache (Access Gateway), updates to a Patient's<br>
/// list of SupportContacts are compared to existing SupportContacts. Matches<br>
/// will update existing SupportContacts, while non-matches are simply added to<br>
/// the existing list. Matching is done on:<br>
/// -Name.FamilyName<br>
/// -Name.GivenName<br>
/// -Name.MiddleName<br>
/// -Address.Street<br>
/// -Address.City.Code+Description<br>
/// -Address.State.Code+Description<br>
/// -Address.Zip.Code+Description<br>
/// -Address.Country.Code+Description<br>
/// All properties are ALPHAUP collated before matching. All properties are<br>
/// inbound and existing optional (a null value will not cause the comparison<br>
/// to be a non-match). For the purposes of matching, both inbound and existing<br>
/// Descriptions, if null, will be defaulted to Code.<br>
/// When a match is made and an inbound SupportContact is to be merged into an<br>
/// existing one, the update logic for most properties is: set the existing<br>
/// property to the value of the inbound only if the existing is null.<br>
/// Exceptions to this will be noted below.<br><br>
/// Viewer cache:<br>
/// In the Viewer Cache, no attempt is made to match inbound SupportContacts to<br>
/// existing PANoks. Every time the PAPerson is updated in the Viewer Cache, if<br>
/// the SDA Patient has any SupportContacts, any existing PANoks are deleted,<br>
/// and the entire list of SupportContacts is inserted.
Class HS.SDA3.SupportContact Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.SupportContactExtension;

/// Primary name for this person (e.g. legal name)<br><br>
/// HL7ToSDA3:<br>
/// NK1-2 is parsed to the Individual Contact, and NK1-30 to the Organization<br>
/// Contact. Though both NK1-2 and -30 are repeating fields, HL7ToSDA3 will<br>
/// only use the first instance of each.<br><br>
/// Streamlet cache:<br>
/// When a match is found between an inbound SupportContact and an existing<br>
/// one, each property of Name is updated individually, rather than the update<br>
/// of Name being "all or nothing".<br><br>
/// HL7:  NK1-2 : Name<br>
/// HL7:  NK1-30 : ContactPersonsName<br><br>
/// .FamilyName<br>
/// HL7:  NK1-2.1.1 : Name.FamilyName.Surname<br>
/// HL7:  NK1-30.1.1 : ContactPersonsName.FamilyName.Surname<br>
/// VIEWERLIB: User.HS.PANok(NOKName)<br>
/// .FamilyNamePrefix<br>
/// HL7:  NK1-2.1.2 : Name.FamilyName.OwnSurnamePrefix<br>
/// HL7:  NK1-30.1.2 : ContactPersonsName.FamilyName.OwnSurnamePrefix<br>
/// VIEWERLIB: User.HS.PANok(NOKFamilyNamePrefix)<br>
/// .GivenName<br>
/// HL7:  NK1-2.2 : Name.GivenName<br>
/// HL7:  NK1-30.2 : ContactPersonsName.GivenName<br>
/// VIEWERLIB: User.HS.PANok(NOKName2)<br>
/// .MiddleName<br>
/// HL7:  NK1-2.3 : Name.SecondandFurtherGivenNames<br>
/// HL7:  NK1-30.3 : ContactPersonsName.SecondandFurtherGivenNames<br>
/// VIEWERLIB: User.HS.PANok(NOKName3)<br>
/// .NameSuffix<br>
/// HL7:  NK1-2.4 : Name.Suffix<br>
/// HL7:  NK1-30.4 : ContactPersonsName.Suffix<br>
/// VIEWERLIB: User.HS.PANok(NOKNameSuffix)<br>
/// .NamePrefix<br>
/// HL7:  NK1-2.5 : Name.Prefix<br>
/// HL7:  NK1-30.5 : ContactPersonsName.Prefix<br>
/// VIEWERLIB: User.HS.PANok(NOKNamePrefix)<br>
/// .ProfessionalSuffix<br>
/// HL7:  NK1-2.14 : Name.ProfessionalSuffix<br>
/// HL7:  NK1-30.14 : ContactPersonsName.ProfessionalSuffix<br>
/// VIEWERLIB: User.HS.PANok(NOKProfessionalSuffix)
Property Name As HS.SDA3.Name;

/// The gender of this contact<br><br>
/// VIEWERLIB: Not stored
Property Gender As HS.SDA3.CodeTableDetail.Gender;

/// The date of birth of this contact<br><br>
/// VIEWERLIB: Not stored
Property BirthTime As HS.SDA3.TimeStamp;

/// This contact's primary spoken language<br><br>
/// VIEWERLIB: Not stored
Property PrimaryLanguage As HS.SDA3.CodeTableDetail.Language;

/// Address of the support contact<br><br>
/// HL7ToSDA3:<br>
/// NK1-4 is parsed to the Individual Contact, and NK1-32 to the Organization<br>
/// Contact. Though both NK1-4 and -32 are repeating fields, HL7ToSDA3 will<br>
/// only use the first instance of each.<br><br>
/// Streamlet cache:<br>
/// When a match is found between an inbound SupportContact and an existing<br>
/// one, each property of Address is updated individually, rather than the<br>
/// update of Address being "all or nothing".<br><br>
/// HL7:  NK1-4 : Address<br>
/// HL7:  NK1-32 : ContactPersonsAddress<br><br>
/// .Street<br>
/// HL7ToSDA3:<br>
/// For both fields 4 and 32; subfield 2, if present, is concatenated to<br>
/// subfield 1.1 as "[1.1]; [2]".<br>
/// HL7:  NK1-4.1.1 : Address.StreetAddressStreetorMailingAddress<br>
/// HL7:  NK1-4.2 : Address.OtherDesignation<br>
/// HL7:  NK1-32.1.1 : ContactPersonsAddress.StreetAddressStreetorMailingAddress<br>
/// HL7:  NK1-32.2 : ContactPersonsAddress.OtherDesignation<br>
/// VIEWERLIB: User.HS.PANok(NOKAddress2)<br>
/// .City<br>
/// HL7ToSDA3:<br>
/// For both fields 4 and 32, subfield 3 is parsed as City.Code. HL7ToSDA3 does<br>
/// not set the Description.<br>
/// HL7:  NK1-4.3 : Address.City<br>
/// HL7:  NK1-32.3 : ContactPersonsAddress.City<br>
/// VIEWERLIB: User.HS.PANok(NOKCityCodeDR)<br>
/// .State<br>
/// HL7ToSDA3:<br>
/// For both fields 4 and 32, subfield 4 is parsed as State.Code. HL7ToSDA3<br>
/// does not set the Description.<br>
/// HL7:  NK1-4.4 : Address.StateorProvince<br>
/// HL7:  NK1-32.4 : ContactPersonsAddress.StateorProvince<br>
/// VIEWERLIB: User.HS.PANok(NOKProvinceDR)<br>
/// .Zip<br>
/// HL7ToSDA3:<br>
/// For both fields 4 and 32, subfield 5 is parsed as Zip.Code. HL7ToSDA3 does<br>
/// not set the Description.<br>
/// HL7:  NK1-4.5 : Address.ZiporPostalCode<br>
/// HL7:  NK1-32.5 : ContactPersonsAddress.ZiporPostalCode<br>
/// VIEWERLIB: User.HS.PANok(NOKZipDR)<br>
/// .Country<br>
/// HL7ToSDA3:<br>
/// For both fields 4 and 32, subfield 6 is parsed as Country.Code. HL7ToSDA3<br>
/// does not set the Description.<br>
/// HL7:  NK1-4.6 : Address.Country<br>
/// HL7:  NK1-32.6 : ContactPersonsAddress.Country<br>
/// VIEWERLIB: User.HS.PANok(NOKCountryDR)<br>
/// .County<br>
/// HL7ToSDA3:<br>
/// For both fields 4 and 32, subfield 9 is parsed as County.Code.  HL7ToSDA3<br>
/// does not set the Description.<br>
/// HL7:  NK1-4.9 : Address.CountyParishCode<br>
/// HL7:  NK1-32.9 : Address.CountyParishCode<br>
/// VIEWERLIB: Not stored<br>
/// .FromTime<br>
/// Viewer cache:<br>
/// Only the date part of FromTime is stored in the viewer cache.
/// (NOKAddrStartDate is date-only.)<br>
/// HL7:  NK1-4.13.1 : Address.EffectiveDateTime<br>
/// HL7:  NK1-32.13.1 : ContactPersonsAddress.EffectiveDateTime<br>
/// VIEWERLIB: User.HS.PANok(NOKAddrStartDate)<br>
/// .ToTime<br>
/// Viewer cache:<br>
/// Only the date part of ToTime is stored in the viewer cache. (NOKAddrEndDate<br>
/// is date-only.)<br>
/// HL7:  NK1-4.14.1 : Address.ExpirationDateTime<br>
/// HL7:  NK1-32.14.1 : ContactPersonsAddress.ExpirationDateTime<br>
/// VIEWERLIB: User.HS.PANok(NOKAddrEndDate)
Property Address As HS.SDA3.Address;

/// Contact information for the SupportContact<br><br>
/// HL7ToSDA3:<br>
/// NK1-5 and -6 are parsed to the Individual Contact, while NK1-31 is parsed<br>
/// to the Organization Contact. For each instance of each field, the algorithm<br>
/// to parse a phone number out of that field is:<br>
/// -If subfields 5, 6, 7, and 8 are not all null, compose the number out of<br>
/// them as "+[.5] ([.6]) [.7] x[.8]".<br>
/// -Else if subfield 12 is not null, use that.<br>
/// -Else if subfield 1 is not null, use that.<br>
/// -Else continue to the next instance of this field.<br><br>
/// -Whichever number is parsed, if subfield 9 of that instance is not null, it<br>
/// will be appended to the number, delimited by a semicolon.<br>
/// Ex: "###-###-####;Main Number"<br><br>
/// Streamlet cache:<br>
/// When a match is found between an inbound SupportContact and an existing<br>
/// one, each property of ContactInfo is updated individually, rather than the update<br>
/// of ContactInfo being "all or nothing".<br><br>
/// HL7:  NK1-5 : PhoneNumber<br>
/// HL7:  NK1-6 : BusinessPhoneNumber<br>
/// HL7:  NK1-31 : ContactPersonsTelephoneNumber<br><br>
/// .HomePhoneNumber<br>
/// HL7ToSDA3:<br>
/// From NK1-5, HomePhoneNumber is parsed from the first instance of the field<br>
/// with subfield 2 (Use) in ["",PRN,ORN,VHN,ASN,EMR], and subfield 3 in<br>
/// ["",PH], and from which a number can be parsed using the above algorithm.<br>
/// HL7:  NK1-5 : PhoneNumber<br>
/// VIEWERLIB: User.HS.PANok(NOKTelH)<br>
/// .WorkPhoneNumber<br>
/// HL7ToSDA3:<br>
/// NK1-6 is parsed to the Individual Contact, and NK1-31 is parsed to the<br>
/// Organization Contact. For both fields, WorkPhoneNumber is parsed from the<br>
/// first instance of the field with subfield 2 in ["",WPN,ASN,EMR], and<br>
/// subfield 3 in ["",PH], and from which a number can be parsed using the<br>
/// above algorithm.<br>
/// HL7:  NK1-6 : BusinessPhoneNumber<br>
/// HL7:  NK1-31 : ContactPersonsTelephoneNumber<br>
/// VIEWERLIB: User.HS.PANok(NOKTelO)<br>
/// .MobilePhoneNumber<br>
/// HL7ToSDA3:<br>
/// For the Individual Contact, first NK1-5 is parsed for MobilePhoneNumber,<br>
/// then if none is found there, NK1-6 is parsed. For the Organization Contact,<Br>
/// MobilePhoneNumber is parsed from NK1-31. In both cases, MobilePhoneNumber<br>
/// is parsed from the first instance with subfield 2 = "BPN" or subfield 3 in<br>
/// [CP,BP], and from which a number can be parsed using the above algorithm.<br>
/// HL7:  NK1-5 : PhoneNumber<br>
/// HL7:  NK1-6 : BusinessPhoneNumber<br>
/// HL7:  NK1-31 : ContactPersonsTelephoneNumber<br>
/// VIEWERLIB: User.HS.PANok(NOKMobPhone)<br>
/// .EmailAddress<br>
/// HL7ToSDA3:<br>
/// For the Individual Contact, EmailAddress is parsed from the first non-null<br>
/// instance of subfield 4 in NK1-5 and -6. For the Organization Contact,<br>
/// EmailAddress is parsed from the first non-null instance of subfield 4 in<br>
/// NK1-31.<br>
/// HL7:  NK1-5.4 : PhoneNumber.EmailAddress<br>
/// HL7:  NK1-6.4 : BusinessPhoneNumber.EmailAddress<br>
/// HL7:  NK1-31.4 : ContactPersonsTelephoneNumber.EmailAddress<br>
/// VIEWERLIB: User.HS.PANok(NOKEmail)
Property ContactInfo As HS.SDA3.ContactInfo;

/// Personal relationship of support contact to patient (e.g. brother, daughter)<br><br>
/// HL7ToSDA3:<br>
/// NK1-3 will only be parsed if subfield 1 or 2 is not null.<br><br>
/// HL7:  NK1-3 : Relationship<br>
/// SDATableName=Relationship, ViewerClass=User.HS.CTRelation<br>
/// VIEWERLIB: User.HS.PANok(NOKRelationDR)<br><br>
/// .Code<br>
/// HL7:  NK1-3.1 : Relationship.Identifier<br>
/// VIEWERLIB: User.HS.CTRelation(CTRLTCode)<br>
/// .Description<br>
/// HL7:  NK1-3.2 : Relationship.Text<br>
/// VIEWERLIB: User.HS.CTRelation(CTRLTDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  NK1-3.3 : Relationship.NameofCodingSystem<br>
/// VIEWERLIB: Not stored<br>
/// .CodeSystemVersionId<br>
/// HL7:  NK1-3.7 : Relationship.CodingSystemVersionID<br>
/// VIEWERLIB: Not stored<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// If subfield 4 or 5 is not null, then subfields 4, 5, 6, and 8 are parsed<br>
/// into the Code, Description, CodeSystem, and CodeSystemVersionId,<br>
/// respectively, of a PriorCode in the list of PriorCodes. The Type will be<br>
/// parsed as "A" for "Alternate".<br>
/// HL7:  NK1-3.4 : Relationship.AlternateIdentifier<br>
/// HL7:  NK1-3.5 : Relationship.AlternateText<br>
/// HL7:  NK1-3.6 : Relationship.NameofAlternateCodingSystem<br>
/// HL7:  NK1-3.8 : Relationship.AlternateCodingSystemVersionID<br>
/// VIEWERLIB: Not stored<br>
Property Relationship As HS.SDA3.CodeTableDetail.Relationship;

/// specific relationship role (e.g. employer, emergency contact)<br><br>
/// HL7ToSDA3:<br>
/// NK1-7 is only parsed if subfield 1 or 2 is not null.<br><br>
/// HL7:  NK1-7 : ContactRole<br>
/// SDATableName=ContactType, ViewerClass=User.HS.PACContactType<br>
/// VIEWERLIB: User.HS.PANok(NOKContactTypeDR)<br><br>
/// .Code<br>
/// HL7:  NK1-7.1 : ContactRole.Identifier<br>
/// VIEWERLIB: User.HS.PACContactType(CONTTPCode)<br>
/// .Description<br>
/// HL7:  NK1-7.2 : ContactRole.Text<br>
/// VIEWERLIB: User.HS.PACContactType(CONTTPCode)<br>
/// VIEWERLIB: User.HS.PACContactType(CONTTPPriority)<br>
/// .SDACodingStandard<br>
/// HL7:  NK1-7.3 : ContactRole.NameofCodingSystem<br>
/// VIEWERLIB: Not stored<br>
Property ContactType As HS.SDA3.CodeTableDetail.ContactType;

/// A boolean property indicating whether this contact is the patient's primary<br>
/// contact.<br><br>
/// VIEWERLIB: Not stored
Property PrimaryContact As HS.SDA3.Boolean;

/// A list of identifying numbers for this contact, such as insurance card<br>
/// number, various government-assigned numbers, etc.<br><br>
/// Streamlet cache:<br>
/// Once a match has been identified between an inbound and existing<br>
/// SupportContact, the Identifiers of each are compared for possible matches,<br>
/// matching on Number, NumberType, and Organization.Code. Matching on each<br>
/// property is exact. If no match is found, the inbound PatientNumber is<br>
/// inserted into the existing Identifiers list.<br><br>
/// VIEWERLIB: Not stored
Property Identifiers As list Of HS.SDA3.PatientNumber;

/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: User.HS.PANok(NOKUpdateUserDR)
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// HL7ToSDA3:<br>
/// The Organization Contact will only be parsed from an NK1 segment if NK1-13<br>
/// is not null. Though NK1-13 is a repeating field, HL7ToSDA3 only uses the<br>
/// first instance.<br><br>
/// HL7: NK1-13 : OrganizationNameNK1<br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.PANok(NOKUpdateHospitalDR)<br><br>
/// .Code<br>
/// HL7ToSDA3:<br>
/// If subfield 10 is not null, it will be parsed to Code. Else subfield 3 will<br>
/// be parsed to Code.<br>
/// HL7:  NK1-13.10 : OrganizationNameNK1.OrganizationIdentifier<br>
/// HL7:  NK1-13.3 : OrganizationNameNK1.IDNumber<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPCode)<br>
/// .Description<br>
/// HL7:  NK1-13.1 : OrganizationNameNK1.OrganizationName<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  NK1-13.6 : OrganizationNameNK1.AssigningAuthority<br>
/// VIEWERLIB: Not stored
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// Viewer cache:<br>
/// NOKUpdateDate is set to the date part of EnteredOn, and NOKUpdateTime is<br>
/// set to the time part. Additionally, NOKIDDate is set to the date part.<br><br>
/// VIEWERLIB: User.HS.PANok(NOKUpdateDate) + User.HS.PANok(NOKUpdateTime)<br>
/// VIEWERLIB: User.HS.PANok(NOKIDDate)
Property EnteredOn As HS.SDA3.TimeStamp;

/// Viewer cache:<br>
/// Only the date part of FromTime is stored in the Viewer Cache. (NOKDateFrom<br>
/// is date-only.)<br><br>
/// HL7:  NK1-8 : StartDate<br>
/// VIEWERLIB: User.HS.PANok(NOKDateFrom)
Property FromTime As HS.SDA3.TimeStamp;

/// Viewer cache:<br>
/// Only the date part of ToTime is stored in the Viewer Cache. (NOKDateTo<br>
/// is date-only.)<br><br>
/// HL7:  NK1-9 : EndDate<br>
/// VIEWERLIB: User.HS.PANok(NOKDateTo)
Property ToTime As HS.SDA3.TimeStamp;

/// Streamlet cache:<br>
/// Once a match has been identified between an inbound and existing<br>
/// SupportContact, the CustomPairs of each are compared for possible matches,<br>
/// matching on Name and Value. Matching on each property is exact. If no match<br>
/// is found, the inbound NVPair is inserted into the existing CustomPairs<br>
/// list.<br><br>
/// Viewer Cache: Even though SupportContact is not a streamlet type,<br>
/// CustomPairs are still supported, and stored with info type "NOK".<br><br>
/// .Name<br>
/// VIEWERLIB: web.SDA3.NVPair(Name)<br>
/// .Value<br>
/// VIEWERLIB: web.SDA3.NVPair(Value)<br><br>
Property CustomPairs As list Of HS.SDA3.NVPair;

/// Supported values:<br>
/// D = Delete<br>
/// Any other value = Add or Update<br>
/// HL7ToSDA3:<br>
/// Two double quotes ("") in the Set ID field (NK1-1) will be parsed<br>
/// as ActionCode="D"<br>
/// HL7:  NK1-1 : SetIDNK1<br>
/// VIEWERLIB: Not stored
Property ActionCode As %String;

/// Not used.
Property ActionScope As %String;

/// Not used.
Property UpdatedOn As HS.SDA3.TimeStamp;

/// Not used.
Property EncounterNumber As %String(MAXLEN = 220);

/// Not used.
Property ExternalId As %String(MAXLEN = 220);

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
<Value>ContactType</Value>
</Value>
<Value name="13">
<Value>FromTime</Value>
</Value>
<Value name="14">
<Value>ToTime</Value>
</Value>
<Value name="15">
<Value>Deleted</Value>
</Value>
<Value name="16">
<Value>UpdatedOn</Value>
</Value>
<Value name="17">
<Value>CustomPairs</Value>
</Value>
<Value name="18">
<Value>Gender</Value>
</Value>
<Value name="19">
<Value>BirthTime</Value>
</Value>
<Value name="20">
<Value>PrimaryLanguage</Value>
</Value>
<Value name="21">
<Value>PrimaryContact</Value>
</Value>
<Value name="22">
<Value>Identifiers</Value>
</Value>
<Value name="23">
<Value>Organization</Value>
</Value>
<Value name="24">
<Value>Extension</Value>
</Value>
</Data>
<Data name="SuperSerialClassState">
<Value name="1">
<Value>ActionCode</Value>
</Value>
<Value name="2">
<Value>EnteredBy</Value>
</Value>
<Value name="3">
<Value>EnteredAt</Value>
</Value>
<Value name="4">
<Value>EnteredOn</Value>
</Value>
<Value name="5">
<Value>ExternalId</Value>
</Value>
<Value name="6">
<Value>ActionScope</Value>
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
<Value>ContactType</Value>
</Value>
</Data>
<Data name="SupportContactDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^HS.SDA3.SupportContactD</DataLocation>
<DefaultData>SupportContactDefaultData</DefaultData>
<IdLocation>^HS.SDA3.SupportContactD</IdLocation>
<IndexLocation>^HS.SDA3.SupportContactI</IndexLocation>
<StreamLocation>^HS.SDA3.SupportContactS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
