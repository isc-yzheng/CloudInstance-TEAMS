/// HS.SDA3.Problem data corresponds to any of three different CDA sections:<br>
/// Problem List, History of Past Illness, Functional Status. Refer to the<br>
/// Section-Modules export XSLs for any of those sections for more details.<br><br>
/// In the default Clinical Viewer layout, Problems are displayed on the<br>
/// Conditions chart in the "Present Illness" and "Past Illness" profiles. The<br>
/// logic to determine whether a Problem is past or present is described in the<br>
/// annotation on the <property>ActionScope</property> property and uses the <property>ToTime</property> and <property>Status</property> values.<br>
/// This is implemented via row filters on these profiles that invoke<br>
/// web.SDA3.Problem::IsProblemPresent.  Users wishing to customize the filter<br>
/// logic may copy this method to their own class, change it to their liking,<br>
/// and configure the filters for the profiles to use this method instead.
Class HS.SDA3.Problem Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.ProblemExtension;

/// Length subject to the total streamlet size limit - 3,000,000<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if the SDA does not have a<br>
/// Problem CodeTableDetail and ProblemDetails is null, an error will be logged<br>
/// and the Streamlet will not be saved.<br><br>
/// HL7:  NTE-3 : Comment<br>
/// VIEWERLIB: User.HS.MRPresentIllness(PRESIDesc)<br>
Property ProblemDetails As %String(MAXLEN = "");

/// HL7ToSDA3:<br>
/// PRB-3 will only be parsed if subfield 1 (Identifier) or 2 (Text) is not<br>
/// null.<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if the SDA does not have a<br>
/// Problem CodeTableDetail and ProblemDetails is null, an error will be logged<br>
/// and the Streamlet will not be saved.<br><br>
/// HL7:  PRB-3 : ProblemID<br>
/// SDATableName=BodyPart, ViewerClass=User.HS.MRCBodyParts<br>
/// VIEWERLIB: User.HS.MRPresentIllness(PRESIBodyPartsDR)<br><br>
/// .Code<br>
/// HL7:  PRB-3 : ProblemID.Identifier<br>
/// VIEWERLIB: User.HS.MRCBodyParts(BODPCode)<br>
/// .Description<br>
/// HL7:  PRB-3 : ProblemID.Text<br>
/// VIEWERLIB: User.HS.MRCBodyParts(BODPDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  PRB-3 : ProblemID.NameofCodingSystem<br>
/// VIEWERLIB: Not stored
Property Problem As HS.SDA3.CodeTableDetail.BodyPart;

/// HL7ToSDA3:<br>
/// Clinician is parsed from the first ROL segment following the PRB segment<br>
/// with ROL-3.1 (Role.Identifier) = AD, AT, CP, FHCP, PP, RP, or RT (HL7 code<br>
/// table 2.5:443, Provider Role).<br><br>
/// HL7:  ROL<br>
/// SDATableName=CareProvider, ViewerClass=User.HS.CTCareProv<br>
/// VIEWERLIB: User.HS.MRPresentIllness(PRESICTCPDR)<br><br>
/// .Code<br>
/// HL7ToSDA3:<br>
/// If ROL-1.1 is non-null, use that as Code. Else, if the first instance of<br>
/// ROL-4.1 is non-null, use that as Code.<br>
/// HL7:  ROL-1.1 : RoleInstanceID.EntityIdentifier<br>
/// HL7:  ROL-4.1 : RolePerson.IDNumber<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPCode)<br><br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// Description is parsed from the first instance of ROL-4 (Role Person),<br>
/// subfields 2.1 (FamilyName.Surname) and 3 (GivenName), formatted as:<br>
/// "[FamilyName.Surname], [GivenName]".<br>
/// HL7:  ROL-4.2.1 : RolePerson.FamilyName.Surname<br>
/// HL7:  ROL-4.3 : RolePerson.GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPDesc)<br><br>
/// .SDACodingStandard<br>
/// HL7ToSDA3:<br>
/// If ROL-1.1 is non-null, use ROL-1.2 as SDACodingStandard. Else, if the<br>
/// first instance of ROL-4.1 is non-null, use that instance of ROL-4.9 as<br>
/// SDACodingStandard.<br>
/// HL7:  ROL-1.2 : RoleInstanceID.NamespaceID<br>
/// HL7:  ROL-4.9 : RolePerson.AssigningAuthority<br>
/// VIEWERLIB: Not stored<br><br>
/// .Name<br>
/// HL7ToSDA3:<br>
/// Only the first instance of ROL-4 is used.<br>
/// HL7:  ROL-4 : RolePerson<br>
/// .Name.FamilyName<br>
/// HL7:  ROL-4.2.1 : RolePerson.FamilyName.Surname<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPSurname)<br>
/// .Name.FamilyNamePrefix<br>
/// HL7:  ROL-4.2.2 : RolePerson.FamilyName.OwnSurnamePrefix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTextOne)<br>
/// .Name.GivenName<br>
/// HL7:  ROL-4.3 : RolePerson.GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPFirstName)<br>
/// .Name.MiddleName<br>
/// HL7:  ROL-4.4 : RolePerson.SecondandFurtherGivenNamesorInitialsThereof<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPOtherName)<br>
/// .Name.NameSuffix<br>
/// HL7:  ROL-4.5 : RolePerson.Suffix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTextTwo)<br>
/// .Name.NamePrefix<br>
/// HL7:  ROL-4.6 : RolePerson.Prefix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTitle)<br>
/// .Name.ProfessionalSuffix<br>
/// HL7:  ROL-4.7 : RolePerson.Degree<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTextThree)<br><br>
/// .Address<br>
/// HL7ToSDA3:<br>
/// Only the first instance of ROL-11 is used.<br>
/// HL7:  ROL-11 : OfficeHomeAddressBirthplace<br>
/// .Adress.Street<br>
/// HL7ToSDA3:<br>
/// ROL-11.2, if present, is concatenated to ROL-11.1 as:<br>
/// "[ROL-11.1]; [ROL-11.2]"<br>
/// HL7:  ROL-11.1 : OfficeHomeAddressBirthplace.StreetAddress<br>
/// HL7:  ROL-11.2 : OfficeHomeAddressBirthplace.OtherDesignation<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPStName)<br>
/// .Address.City<br>
/// HL7ToSDA3:<br>
/// ROL-11.3 is parsed to City.Code. HL7ToSDA3 does not set the Description.<br>
/// HL7:  ROL-11.3 : OfficeHomeAddressBirthplace.City<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPCityDR)<br>
/// .Address.State<br>
/// HL7ToSDA3:<br>
/// ROL-11.4 is parsed to State.Code. HL7ToSDA3 does not set the Description.<br>
/// HL7:  ROL-11.4 : OfficeHomeAddressBirthplace.StateorProvince<br>
/// VIEWERLIB: Not stored<br>
/// .Address.Zip<br>
/// HL7ToSDA3:<br>
/// ROL-11.5 is parsed to Zip.Code. HL7ToSDA3 does not set the Description.<br>
/// HL7:  ROL-11.5 : OfficeHomeAddressBirthplace.ZiporPostalCode<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPZipDR)<br>
/// .Address.Country<br>
/// HL7ToSDA3:<br>
/// ROL-11.6 is parsed to Country.Code. HL7ToSDA3 does not set the Description.<br>
/// HL7:  ROL-11.6 : OfficeHomeAddressBirthplace.Country<br>
/// VIEWERLIB: Not stored<br>
/// .Address.FromTime<br>
/// HL7:  ROL-11.13 : OfficeHomeAddressBirthplace.EffectiveDate<br>
/// VIEWERLIB: Not stored<br>
/// .Address.ToTime<br>
/// HL7:  ROL-11.14 : OfficeHomeAddressBirthplace.ExpirationDate<br>
/// VIEWERLIB: Not stored<br><br>
/// .ContactInfo<br>
/// HL7ToSDA3:<br>
/// ROL-12 is a repeating field, and each instance may populate<br>
/// HomePhoneNumber, WorkPhoneNumber, MobilePhoneNumber, or EmailAddress,<br>
/// depending on the values contained therein. For each instance of ROL-12, the<br>
/// algorithm to parse a phone number out of that instance is:<br>
/// -If subfields 5, 6, 7, and 8 are not all null, compose the number out of<br>
/// them as "+[.5] ([.6]) [.7] x[.8]".<br>
/// -Else if subfield 12 is not null, use that.<br>
/// -Else if subfield 1 is not null, use that.<br>
/// -Else continue to the next instance of ROL-12.<br><br>
/// -Whichever number is parsed, if subfield 9 of that instance is not null, it<br>
/// will be appended to the number, delimited by a semicolon.<br>
/// Ex: "###-###-####;Main Number"<br>
/// HL7:  ROL-12 : Phone<br>
/// .ContactInfo.HomePhoneNumber<br>
/// HL7ToSDA3:<br>
/// HomePhoneNumber is parsed from the first instance of ROL-12 with subfield 2<br>
/// (Use) in [PRN,ORN,VHN,EMR], and subfield 3 in ["",PH], and from which a<br>
/// number can be parsed using the above algorithm.<br>
/// HL7:  ROL-12 : Phone<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTelH)<br>
/// .ContactInfo.WorkPhoneNumber<br>
/// HL7ToSDA3:<br>
/// WorkPhoneNumber is parsed from the first instance of ROL-12 with subfield 2<br>
/// in ["",WPN,ASN], and subfield 3 in ["",PH], and from which a number can be<br>
/// parsed using the above algorithm.<br>
/// HL7:  ROL-12 : Phone<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTelO)<br>
/// .ContactInfo.MobilePhoneNumber<br>
/// HL7ToSDA3:<br>
/// MobilePhoneNumber is parsed from the first instance of ROL-12 with subfield<br>
/// 2 = "BPN" or subfield 3 in [CP,BP], and from which a number can be parsed<br>
/// using the above algorithm.<br>
/// HL7:  ROL-12 : Phone<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPMobilePhone)<br>
/// .ContactInfo.EmailAddress<br>
/// HL7ToSDA3:<br>
/// EmailAddress is parsed from the first non-null instance of subfield 4 in<br>
/// ROL-12.<br>
/// HL7:  ROL-12.4 : Phone.EmailAddress<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPEmail)<br><br>
/// .CareProviderType<br>
/// HL7ToSDA3:<br>
/// CareProviderType will only be parsed from ROL-9 if piece 1 or 2 is not<br>
/// null.<br>
/// HL7:  ROL-9 : ProviderType<br>
/// SDATableName=CareProviderType, ViewerClass=User.HS.CTCarPrvTp<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPCarPrvTpDR)<br>
/// .CareProviderType.Code<br>
/// HL7:  ROL-9.1 : ProviderType.Identifier<br>
/// VIEWERLIB: User.HS.CTCarPrvTp(CTCPTCode)<br>
/// .CareProviderType.Description<br>
/// HL7:  ROL-9.2 : ProviderType.Text<br>
/// VIEWERLIB: User.HS.CTCarPrvTp(CTCPTDesc)<br>
/// .CareProviderType.SDACodingStandard<br>
/// HL7:  ROL-9.3 : ProviderType.NameofCodingSystem<br>
/// VIEWERLIB: Not stored
Property Clinician As HS.SDA3.CodeTableDetail.CareProvider;

/// Whether this Problem contributed as a Cause of Death<br>
/// Supported values: Y, N<br><br>
/// VIEWERLIB: User.HS.MRPresentIllness(PRESICauseOfDeath)<br>
Property CauseofDeath As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 220, TRUNCATE = 1, VALUELIST = ",Y,N");

/// HL7ToSDA3:<br>
/// If PRB-14.1 or .2 is not null, then Status is derived from PRB-14. The<br>
/// actual values parsed to the SDA may not exactly match what is in the HL7.<br>
/// The logic is:<br>
/// -If PRB-14.1 matches one of the SNOMED codes and PRB-14.3 contains "SNOMED"<br>
/// (case-insensitive), use the corresponding SNOMED description.<br>
/// -Else if PRB-14.2 matches one of the SNOMED descriptions (case- and<br>
/// whitespace-insensitive), use the corresponding SNOMED code.<br>
/// -Else if there is a value in PRB-9 (Actual Problem Resolution Date/Time),<br>
/// use Code="413322009", Description="Resolved".<br>
/// -Else default to Code="55561003", Description="Active".<br>
/// In each case, the SDACodingStandard is set to "SNOMED CT".<br>
/// The SNOMED Codes and Descriptions for Problem Status are:<br>
/// 55561003 - Active<br>
/// 73425007 - Inactive<br>
/// 90734009 - Chronic<br>
/// 7087005 - Intermittent<br>
/// 255227004 - Recurrent<br>
/// 415684004 - Suspected<br>
/// 410516002 - Ruled out<br>
/// 413322009 - Resolved<br><br>
/// HL7:  PRB-9 : ActualProblemResolutionDateTime<br>
/// HL7:  PRB-14 : ProblemLifeCycleStatus<br>
/// SDATableName=DiagnosisStatus, ViewerClass=User.HS.MRCDiagnosStatus<br>
/// VIEWERLIB: User.HS.MRPresentIllness(PRESIDiagnosStatusDR)<br>
Property Status As HS.SDA3.CodeTableDetail.DiagnosisStatus;

/// HL7ToSDA3:<br>
/// PRB-10 will only be parsed if subfield 1 or 2 is not null.<br><br>
/// HL7:  PRB-10 : ProblemClassification<br>
/// SDATableName=ProblemCategory, ViewerClass=User.HS.MRCPresIllCategory<br>
/// VIEWERLIB: User.HS.MRPresentIllness(PRESICategoryDR)<br><br>
/// .Code<br>
/// HL7:  PRB-10.1 : ProblemClassification.Identifier<br>
/// VIEWERLIB: User.HS.MRCPresIllCategory(PRESICCode)<br>
/// .Description<br>
/// HL7:  PRB-10.2 : ProblemClassification.Text<br>
/// VIEWERLIB: User.HS.MRCPresIllCategory(PRESICDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  PRB-10.3 : ProblemClassification.NameofCodingSystem<br>
/// VIEWERLIB: Not stored
Property Category As HS.SDA3.CodeTableDetail.ProblemCategory;

/// Length subject to the total streamlet size limit - 3,000,000<br><br>
/// VIEWERLIB: User.HS.MRPresentIllness(PRESIComments)
Property Comments As %String(MAXLEN = "");

/// Supported values:<br>
/// D = Delete<br>
/// C = Clear/Delete All<br>
/// Any other value = Add or Update<br>
/// See the annotation on the superclass property for more information on how<br>
/// ActionCode is used. Also see the annotation on the ActionScope property for<br>
/// information on how ActionScope="C" can be qualified.<br><br>
/// HL7ToSDA3:<br>
/// For a PPR_PC3 message (Problem Delete), ActionCode is always parsed as "D".<br>
/// Otherwise PRB-1 is used if not null.<br><br>
/// HL7:  PRB-1 : ActionCode<br>
/// VIEWERLIB: Not stored<br>
Property ActionCode As %String;

/// Optional scope used to qualify ActionCode="C"<br>
/// Supported values are:<br>
/// PRESENT (case-insensitive) = Clear only Present Problems<br>
/// PAST (case-insensitive) = Clear only Past Problem<br>
/// If ActionScope is null or omitted, all Problems for the Encounter will be<br>
/// deleted.<br>
/// For any other value of ActionScope (ie unrecognized value), nothing will be<br>
/// deleted.<br>
/// The logic to determine whether a Problem is past or present is:<br>
/// -If the Problem has a ToTime in the past, it's past.<br>
/// -Else if the Problem has Status.Code="I", it's past.<br>
/// -Else if Status.SDACodingStandard contains (not necessarily equals)<br>
/// "SNOMED", case-insensitive, and  Status.Code is one of 73425007, 410516002,<br>
/// or 413322009 (Inactive, Ruled Out, Resolved), it's past.<br>
/// -Else the Problem is present.<br>
/// See the annotation on the superclass property for more information on how<br>
/// ActionScope is used.<br><br>
/// VIEWERLIB: Not stored
Property ActionScope As %String;

/// HL7ToSDA3:<br>
/// EnteredBy is parsed from the first ROL segment following the PRB segment<br>
/// with ROL-3.1 (Role.Identifier) = "TR" for "Transcriptionist" (from HL7 code<br>
/// table 2.6:443)<br><br>
/// HL7:  ROL<br>
/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: User.HS.MRPresentIllness(PRESIUpdateUserDR)<br><br>
/// .Code<br>
/// HL7ToSDA3:<br>
/// ROL-1.1 will be used if not null, else the first instance of ROL-4.1 will<br>
/// be used if not null.<br>
/// HL7:  ROL-1.1 : RoleInstanceID.EntityIdentifier<br>
/// HL7:  ROL-4.1 : RolePerson.IDNumber<br>
/// VIEWERLIB: User.HS.SSUser(SSUSRInitials)<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// Description is parsed from the first instance of ROL-4 (Role Person),<br>
/// subfields 2.1 (FamilyName.Surname) and 3 (GivenName), formatted as:<br>
/// "[FamilyName.Surname], [GivenName]".<br>
/// HL7:  ROL-4.2.1 : RolePerson.FamilyName.Surname<br>
/// HL7:  ROL-4.3 : RolePerson.GivenName<br>
/// .SDACodingStandard<br>
/// HL7ToSDA3:<br>
/// If ROL-1.1 is non-null, use ROL-1.2 as SDACodingStandard. Else, if the<br>
/// first instance of ROL-4.1 is non-null, use that instance of ROL-4.9 as<br>
/// SDACodingStandard.<br>
/// HL7:  ROL-1.2 : RoleInstanceID.NamespaceID<br>
/// HL7:  ROL-4.9 : RolePerson.AssigningAuthority<br>
/// VIEWERLIB: Not stored<br>
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// HL7ToSDA3:<br>
/// MSH-4.1 is parsed as the EnteredAt Code. HL7ToSDA3 does not set the<br>
/// Description.<br><br>
/// HL7:  MSH-4.1 : SendingFacility.NamespaceID<br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.MRPresentIllness(PRESIUpdateHospitalDR)
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// HL7ToSDA3:<br>
/// PRB-15 is used if present, else PRB-2 is used if present.<br><br>
/// HL7:  PRB-15 : ProblemLifeCycleStatusDateTime<br>
/// HL7:  PRB-2 : ActionDateTime<br>
/// VIEWERLIB: User.HS.MRPresentIllness(PRESIDate) + VIEWERLIB: User.HS.MRPresentIllness(PRESITime)<br>
Property EnteredOn As HS.SDA3.TimeStamp;

/// HL7ToSDA3:<br>
/// PRB-16 is used if present, else PRB-7 is used if present.<br><br>
/// Viewer cache:<br>
/// Only the date part of FromTime is stored in the Viewer Cache.<br>
/// (PRESIDateOnset is date-only.)<br><br>
/// HL7:  PRB-16 : ProblemDateofOnset<br>
/// HL7:  PRB-7 : ProblemEstablishedDateTime<br>
/// VIEWERLIB: User.HS.MRPresentIllness(PRESIDateOnset)
Property FromTime As HS.SDA3.TimeStamp;

/// HL7ToSDA3:<br>
/// PRB-9 is used if present, else PRB-8 is used if present.<br><br>
/// Viewer cache:<br>
/// Only the date part of ToTime is stored in the Viewer Cache. (PRESIEndDate<br>
/// is date-only.)<br><br>
/// HL7:  PRB-9 : ActualProblemResolutionDateTime<br>
/// HL7:  PRB-8 : AnticipatedProblemResolutionDateTime<br>
/// VIEWERLIB: User.HS.MRPresentIllness(PRESIEndDate)<br>
Property ToTime As HS.SDA3.TimeStamp;

/// HL7:  PRB-4 : ProblemInstanceID<br>
/// VIEWERLIB: User.HS.MRPresentIllness(PRESIExternalId)
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
<Value>FromTime</Value>
</Value>
<Value name="9">
<Value>ToTime</Value>
</Value>
<Value name="10">
<Value>ProblemDetails</Value>
</Value>
<Value name="11">
<Value>Problem</Value>
</Value>
<Value name="12">
<Value>Clinician</Value>
</Value>
<Value name="13">
<Value>CauseofDeath</Value>
</Value>
<Value name="14">
<Value>Status</Value>
</Value>
<Value name="15">
<Value>Category</Value>
</Value>
<Value name="16">
<Value>Comments</Value>
</Value>
<Value name="17">
<Value>Deleted</Value>
</Value>
<Value name="18">
<Value>UpdatedOn</Value>
</Value>
<Value name="19">
<Value>CustomPairs</Value>
</Value>
<Value name="20">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
