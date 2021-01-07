/// Unlike other Streamlet types, the Patient Streamlet class implements its<br>
/// own Aggregate method, as many of the properties of Patient are aggregated<br>
/// at the Access Gateway in non-standard ways. If the annotation on a property<br>
/// below does not include a description of how it is aggregated, then the<br>
/// aggregation logic is:<br>
/// -If [the existing property is null] or [the inbound record is the best<br>
/// record and the inbound property is not null], set the existing property to<br>
/// the inbound.<br>
/// -Otherwise the inbound value is not aggregated.<br>
/// In this context the "best record" refers to the record of the patient's<br>
/// from the most trusted facility, which is the one with the lowest Tier in<br>
/// the Facility Registry.<br><br>
/// <b>IMPORTANT:</b><br>
/// Because the properties of Patient are aggregated manually, if a property is<br>
/// added to this class, the Aggregate method of the Patient streamlet class<br>
/// must be updated to aggregate the new property.
Class HS.SDA3.Patient Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.PatientExtension;

Parameter CANOVERRIDEPROPLIST = "PatientNumbers,InactiveMRNs,SupportContacts,OtherLanguages,Race,Races";

/// Master Patient Index ID<br>
/// MPIID is the first property in this class so that it appears early in the<br>
/// SDA XML and is easy to find during the AG load.<br><br>
/// Aggregation cache:<br>
/// Though this technically can be stored at the Edge, the value at the Edge<br>
/// will not contribute to an aggregated record at the Access Gateway. When a<br>
/// BatchFetchRequest is initiated at the Access Gateway (when a user selects<br>
/// one or more results on the Patient Search Screen, for example), only the<br>
/// first MPIID in the list of requests will be stored with the aggregated SDA.<br><br>
/// VIEWERLIB: User.HS.PAPerson(PAPERForeignId)
Property MPIID As %String(MAXLEN = 220);

/// Primary name for this person (e.g. legal name)<br><br>
/// HL7ToSDA3:<br>
/// PID-5 is a repeating field. Any instance with subfield 7 (Name Type Code)<br>
/// = "A" is considered an Alias and is parsed as such. The first non-Alias<br>
/// instance of PID-5 is used as Name.<br><br>
/// Aggregation cache:<br>
/// When a patient's records are first requested at the Access Gateway, the<br>
/// aggregated record is created using the demographics from the Patient<br>
/// Registry, including Name. HealthShare then attempts to merge into this the<br>
/// Names (including Alias Names) of any record received at the AG. If the<br>
/// inbound and existing Names match on FamilyName, GivenName, and MiddleName,<br>
/// then they are considered a match, and the inbound Name will be merged into<br>
/// the existing one. For PreferredName, FamilyNamePrefix, NamePrefix,<br>
/// NameSuffix, and ProfessionalSuffix, if the existing value is null, it is<br>
/// set to the inbound value. If the inbound Name did not match the existing<br>
/// Name, it is then compared to each of the existing Aliases, matching on<br>
/// FamilyName, MiddleName, and GivenName. If no match is found, the Name is<br>
/// inserted into the list of Aliases. Then, if the Clinical Viewer is<br>
/// installed, the Name will also have its DOB property set from the BirthTime<br>
/// of the inbound SDA Patient, and its MRN property set from the Number of the<br>
/// first PatientNumber of the inbound Patient with NumberType="MRN".<br><br>
/// HL7:  PID-5 : PatientName<br><br>
/// .FamilyName<br>
/// HL7:  PID-5.1.1 : PatientName.FamilyName.Surname<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERName)<br>
/// .FamilyNamePrefix<br>
/// HL7:  PID-5.1.2 : PatientName.FamilyName.OwnSurnamePrefix<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERName5)<br>
/// .GivenName<br>
/// HL7:  PID-5.2 : PatientName.GivenName<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERName2)<br>
/// .MiddleName<br>
/// HL7:  PID-5.3 : PatientName.SecondandFurtherGivenNames<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERName3)<br>
/// .NameSuffix<br>
/// HL7:  PID-5.4 : PatientName.Suffix<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERName6)<br>
/// .NamePrefix<br>
/// HL7:  PID-5.5 : PatientName.Prefix<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERName7)<br>
/// .ProfessionalSuffix<br>
/// HL7:  PID-5.14 : PatientName.ProfessionalSuffix<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERName8)<br>
/// .PreferredName<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERName4)
Property Name As HS.SDA3.Name;

/// If Name is null, this is the reason.<br><br>
/// HL7ToSDA3:<br>
/// If any instance of PID-5.7 is "S" or "U", BlankNameReason will be set to<br>
/// the value of the last such instance.<br>
/// From HL7 code table 2.5.1:200 (Name Type):<br>
/// S - Coded Pseudo-Name to ensure anonymity<br>
/// U - Unspecified<br><br>
/// HL7:  PID-5.7 : PatientName.NameTypeCode<br>
/// VIEWERLIB: Not stored
Property BlankNameReason As %String;

/// Patient's mother's maiden name<br><br>
/// HL7ToSDA3:<br>
/// Though PID-6 is a repeating field, only the first non-null instance will be<br>
/// used.<br><br>
/// HL7:  PID-6.1.1 : MothersMaidenName.FamilyName.Surname<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERComplement)
Property MothersMaidenName As %String;

/// Patient's mother's full name<br><br>
/// HL7ToSDA3:<br>
/// Though PID-6 is a repeating field, only the first non-null instance will be<br>
/// used.<br><br>
/// HL7:  PID-6 : MothersMaidenName<br><br>
/// .FamilyName<br>
/// HL7:  PID-6.1.1 : MothersMaidenName.FamilyName.Surname<br>
/// .FamilyNamePrefix<br>
/// HL7:  PID-6.1.2 : MothersMaidenName.FamilyName.OwnSurnamePrefix<br>
/// .GivenName<br>
/// HL7:  PID-6.2 : MothersMaidenName.GivenName<br>
/// .MiddleName<br>
/// HL7:  PID-6.3 : MothersMaidenName.SecondandFurtherGivenNames<br>
/// .NameSuffix<br>
/// HL7:  PID-6.4 : MothersMaidenName.Suffix<br>
/// .NamePrefix<br>
/// HL7:  PID-6.5 : MothersMaidenName.Prefix<br>
/// .ProfessionalSuffix<br>
/// HL7:  PID-6.14 : MothersMaidenName.ProfessionalSuffix<br>
/// .PreferredName<br>
/// VIEWERLIB: Not stored
Property MothersFullName As HS.SDA3.Name;

/// Aliases (other names)<br><br>
/// HL7ToSDA3:<br>
/// In addition to every non-null instance of PID-9, HL7ToSDA3 will also parse<br>
/// every instance of PID-5 with subfield 7 (Name Type Code) = "A" (Alias<br>
/// Name) as an Alias.<br><br>
/// Aggregation cache:<br>
/// When a patient's records are first requested at the Access Gateway, the<br>
/// aggregated record is created using the demographics from the Patient<br>
/// Registry, including Name. HealthShare then attempts to merge into this the<br>
/// Names (including Alias Names) of any record received at the AG. If the<br>
/// inbound and existing Names match on FamilyName, GivenName, and MiddleName,<br>
/// then they are considered a match, and the inbound Name will be merged into<br>
/// the existing one. For PreferredName, FamilyNamePrefix, NamePrefix,<br>
/// NameSuffix, and ProfessionalSuffix, if the existing value is null, it is<br>
/// set to the inbound value. If the inbound Name did not match the existing<br>
/// Name, it is then compared to each of the existing Aliases, matching on<br>
/// FamilyName, MiddleName, and GivenName. If no match is found, the Name is<br>
/// inserted into the list of Aliases. Then, if the Clinical Viewer is<br>
/// installed, the Name will also have its DOB property set from the BirthTime<br>
/// of the inbound SDA Patient, and its MRN property set from the Number of the<br>
/// first PatientNumber of the inbound Patient with NumberType="MRN".<br><br>
/// Viewer cache:<br>
/// If FamilyName, GivenName, and MiddleName are all null, an alert will be<br>
/// logged in the Ensemble Event Log and the Alias will not be saved.<br><br>
/// HL7:  PID-5 : PatientName<br>
/// HL7:  PID-9 : PatientAlias<br>
/// VIEWERLIB: User.HS.PAPerson(ChildPAPersonSurnameAlias)<br><br>
/// .FamilyName<br>
/// HL7:  PID-5.1.1 : PatientName.FamilyName.Surname<br>
/// HL7:  PID-9.1.1 : PatientAlias.FamilyName.Surname<br>
/// VIEWERLIB: User.HS.PAPersonSurnameAlias(SURName)<br>
/// .FamilyNamePrefix<br>
/// HL7:  PID-5.1.2 : PatientName.FamilyName.OwnSurnamePrefix<br>
/// HL7:  PID-9.1.2 : PatientAlias.FamilyName.OwnSurnamePrefix<br>
/// VIEWERLIB: Not stored<br>
/// .GivenName<br>
/// HL7:  PID-5.2 : PatientName.GivenName<br>
/// HL7:  PID-9.2 : PatientAlias.GivenName<br>
/// VIEWERLIB: User.HS.PAPersonSurnameAlias(SURName2)<br>
/// .MiddleName<br>
/// HL7:  PID-5.3 : PatientName.SecondandFurtherGivenNames<br>
/// HL7:  PID-9.3 : PatientAlias.SecondandFurtherGivenNames<br>
/// VIEWERLIB: User.HS.PAPersonSurnameAlias(SURName3)<br>
/// .NameSuffix<br>
/// HL7:  PID-5.4 : PatientName.Suffix<br>
/// HL7:  PID-9.4 : PatientAlias.Suffix<br>
/// VIEWERLIB: Not stored<br>
/// .NamePrefix<br>
/// HL7:  PID-5.5 : PatientName.Prefix<br>
/// HL7:  PID-9.5 : PatientAlias.Prefix<br>
/// VIEWERLIB: Not stored<br>
/// .ProfessionalSuffix<br>
/// HL7:  PID-5.14 : PatientName.ProfessionalSuffix<br>
/// HL7:  PID-9.14 : PatientAlias.ProfessionalSuffix<br>
/// VIEWERLIB: Not stored<br>  
/// .DOB<br>
/// Set so that an Alias Name in the Clinical Viewer can be displayed with the<br>
/// DOB of the patient record from which it originated.<br>
/// Aggregation cache:<br>
/// DOB is set at the time an inbound Alias is aggregated into the existing<br>
/// list of Aliases. It is set to the BirthTime of the inbound SDA Patient.<br>
/// Note that this is only done if the Clinical Viewer is installed.<br>
/// Viewer cache:<br>
/// Only the date part of DOB is stored. (SURDob is date-only.)<br>
/// VIEWERLIB: User.HS.PAPersonSurnameAlias(SURDob)<br>
/// .MRN<br>
/// Set so that an Alias Name in the Clinical Viewer can be displayed with the<br>
/// MRN of the patient record from which it originated.<br>
/// Aggregation cache:<br>
/// MRN is set at the time an inbound Name is aggregated into the existing list<br>
/// of Alias Names. It is set to the Number of the first PatientNumber of the<br>
/// inbound Patient SDA with NumberType="MRN". Note that this is only done if<br>
/// the Clinical Viewer is installed.<br>
/// VIEWERLIB: User.HS.PAPersonSurnameAlias(SURPatientFromID)
Property Aliases As list Of HS.SDA3.Name;

/// Patient's primary language<br><br>
/// HL7ToSDA3:<br>
/// PID-15 is only parsed if subfield 1 or 2 is not null.<br><br>
/// HL7:  PID-15 : PrimaryLanguage<br>
/// SDATableName=Language, ViewerClass=User.HS.PACPreferredLanguage<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERPrefLanguageDR)<br><br>
/// .Code<br>
/// HL7:  PID-15.1 : PrimaryLanguage.Identifier<br>
/// VIEWERLIB: User.HS.PACPreferredLanguage(PREFLCode)<br>
/// .Description<br>
/// HL7:  PID-15.2 : PrimaryLanguage.Text<br>
/// VIEWERLIB: User.HS.PACPreferredLanguage(PREFLDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  PID-15.3 : PrimaryLanguage.NameofCodingSystem<br>
/// VIEWERLIB: Not stored
Property PrimaryLanguage As HS.SDA3.CodeTableDetail.Language;

/// List of patient's other languages<br><br>
/// Streamlet cache:<br>
/// When an Patient update is received with OtherLanguages, HealthShare will<br>
/// compare the inbound and existing lists for matches and merge where<br>
/// possible. Matching is done on:<br>
/// -PreferredLanguage.Code+Description<br>
/// -Use<br>
/// Matching on PreferredLanguage is ALPHAUP collated. Matching on Use is<br>
/// exact. PreferredLanguage is inbound and existing required for a match. Use<br>
/// is inbound and existing optional (a null value will not cause the<br>
/// comparison to not be a match). If a match is found, the inbound<br>
/// PatientLanguage is merged into the existing (null properties of the<br>
/// existing will be set to the values of the corresponding inbound<br>
/// properties). Otherwise the inbound PatientLanguage is inserted into the<br>
/// existing list.<br><br>
/// Aggregation cache:<br>
/// The logic to update OtherLanguages in the Aggregation Cache is the same as<br>
/// for the Streamlet Cache.<br><br>
/// Viewer cache:<br>
/// If the PatientLanguage does not have a PreferredLanguage, an Alert will be<br>
/// logged in the Ensemble Event Log and the PatientLanguage will not be saved.<br><br>
/// VIEWERLIB: User.HS.PAPerson(ChildPAPersonLanguage)
Property OtherLanguages As list Of HS.SDA3.PatientLanguage;

/// HL7ToSDA3:<br>
/// PID-17 is only parsed if subfield 1 or 2 is not null.<br><br>
/// HL7:  PID-17 : Religion<br>
/// SDATableName=Religion, ViewerClass=User.HS.CTReligion<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERReligionDR)<br><br>
/// .Code<br>
/// HL7:  PID-17.1 : Religion.Identifier<br>
/// VIEWERLIB: User.HS.CTReligion(CTRLGCode)<br>
/// .Description<br>
/// HL7:  PID-17.2 : Religion.Text<br>
/// VIEWERLIB: User.HS.CTReligion(CTRLGDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  PID-17.3 : Religion.NameofCodingSystem<br>
/// VIEWERLIB: Not stored
Property Religion As HS.SDA3.CodeTableDetail.Religion;

/// HL7ToSDA3:<br>
/// PID-16 is only parsed if subfield 1 or 2 is not null.<br><br>
/// HL7:  PID-16 : MaritalStatus<br>
/// SDATableName=MaritalStatus, ViewerClass=User.HS.CTMarital<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERMaritalDR)<br><br>
/// .Code<br>
/// HL7:  PID-17.1 : MaritalStatus.Identifier<br>
/// VIEWERLIB: User.HS.CTMarital(CTMARCode)<br>
/// .Description<br>
/// HL7:  PID-17.2 : MaritalStatus.Text<br>
/// VIEWERLIB: User.HS.CTMarital(CTMARDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  PID-17.3 : MaritalStatus.NameofCodingSystem<br>
/// VIEWERLIB: Not stored
Property MaritalStatus As HS.SDA3.CodeTableDetail.MaritalStatus;

/// HL7ToSDA3:<br>
/// Though PID-8 is not a coded element type of field, HL7ToSDA3 still only<br>
/// parses the first piece with respect to the Component Separator. This is<br>
/// parsed to the to the Gender Code. HL7ToSDA3 does not set the Description.<br><br>
/// Viewer cache:<br>
/// PAPERSexDR can only be set on the initial load to the Viewer Cache and<br>
/// therefore must come from the patient's set of best demographics from the<br>
/// Patient Registry. If these demographics contain no gender, the patient's<br>
/// gender will appear in the Clinical Viewer as "NS" for "Not Specified".<br><br>
/// HL7:  PID-8 : AdministrativeSex<br>
/// SDATableName=Gender, ViewerClass=User.HS.CTSex<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERSexDR)
Property Gender As HS.SDA3.CodeTableDetail.Gender;

/// Birth Gender, as required for meaningful use. 
/// Consistent with FHIR, we make it an attribute of Patient.
/// However, this means we lose the effectiveTime of the SocialHistoryObservation.
Property BirthGender As HS.SDA3.CodeTableDetail.Gender;

/// HealthShare now supports multiple races in the Races property.  The single<br>
/// instance Race property is maintained (as the first Races entry) for<br>
/// backwards compatibility.<br><br>
/// HL7ToSDA3:<br>
/// Though PID-10 is repeating, only the first instance with subfield 1 or 2<br>
/// not null will be parsed to Race.<br><br>
/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the Streamlet class, if Race.Code is the<br>
/// delete instruction (two double quotes), the Description is set to the<br>
/// delete instruction and the Races property is cleared. Else, if the first<br>
/// entry in Races has Code = the delete instruction, both Race.Code and<br>
/// Description are set to the delete instruction, and Races is cleared. Else,<br>
/// if Races has at least 1 entry, Race is set to a clone of the first entry.<br>
/// Else, if Race is defined, a clone of it is inserted into Races.<br>
/// Race and Races are updated in the Streamlet Cache via the OnUpdateSDARace<br>
/// and OnUpdateSDARaces methods. The OnUpdateSDARace method actually doesn't<br>
/// do anything, however the OnUpdateSDARaces method can affect Race in several<br>
/// ways. If the inbound Race.Code is the delete instruction, the existing Race<br>
/// is set to null and the existing Races is cleared. Else, if the inbound Race<br>
/// is defined and the inbound Races is not, a clone of the inbound Race is<br>
/// inserted into the inbound Races. Then, if there is at least one entry in<br>
/// the inbound Races, the existing Race is set set to a clone of the first<br>
/// entry in the inbound Races, and the existing Races is cleared and clones of<br>
/// the entries in the inbound Races inserted.<br><br>
/// Aggregation cache:<br>
/// In the Aggregate method of the Streamlet class, Race is aggregated into the<br>
/// patient record like most other properties of Patient: if the existing value<br>
/// is null or the inbound record is the best record, set the existing value to<br>
/// the inbound one.<br><br>
/// Viewer cache:<br>
/// Note that it is the Race property, and not Races or any of its entries,<br>
/// that is inserted into the Viewer Cache.<br><br>
/// HL7:  PID-10 : Race<br>
/// SDATableName=Race, ViewerClass=User.HS.PACIndigStatus<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERIndigStatDR)<br><br>
/// .Code<br>
/// HL7:  PID-10.1 : Race.Identifier<br>
/// VIEWERLIB: User.HS.PACIndigStatus(INDSTCode)<br>
/// .Description<br>
/// HL7:  PID-10.2 : Race.Text<br>
/// VIEWERLIB: User.HS.PACIndigStatus(INDSTDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  PID-10.3 : Race.NameofCodingSystem<br>
/// VIEWERLIB: Not stored<br>
/// .CodeSystemVersionId<br>
/// HL7:  PID-10.7 : Race.CodingSystemVersionID<br>
/// VIEWERLIB: Not stored
Property Race As HS.SDA3.CodeTableDetail.Race;

/// HL7ToSDA3:<br>
/// Every instance of PID-10 with subfield 1 or 2 not null is parsed to Races.<br><br>
/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the Streamlet class, if Race.Code is the<br>
/// delete instruction (two double quotes), the Description is set to the<br>
/// delete instruction and the Races property is cleared. Else, if the first<br>
/// entry in Races has Code = the delete instruction, both Race.Code and<br>
/// Description are set to the delete instruction, and Races is cleared. Else,<br>
/// if Races has at least 1 entry, Race is set to a clone of the first entry.<br>
/// Else, if Race is defined, a clone of it is inserted into Races.<br>
/// Race and Races are updated in the Streamlet Cache via the OnUpdateSDARace<br>
/// and OnUpdateSDARaces methods. The OnUpdateSDARace method actually doesn't<br>
/// do anything. In OnUpdateSDARaces, if the inbound Race.Code is the delete<br>
/// instruction, the existing Race is set to null and the existing Races is<br>
/// cleared. Else, if the inbound Race is defined and the inbound Races is not,<br>
/// a clone of the inbound Race is inserted into the inbound Races. Then, if<br>
/// there is at least one entry in the inbound Races, the existing Race is set<br>
/// to a clone of the first entry in the inbound Races, and the existing Races<br>
/// is cleared and clones of the entries in the inbound Races inserted.<br><br>
/// Aggregation cache:<br>
/// In the Aggregate method of the Streamlet class, the inbound Races are<br>
/// compared to the existing ones, and any inbound Race that does not match an<br>
/// existing one is inserted into the existing list. Matching is done on Code,<br>
/// Description, and SDACodingStandard.<br><br>
/// HL7:  PID-10 : Race<br>
/// SDATableName=Race, ViewerClass=User.HS.PACIndigStatus<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  PID-10.1 : Race.Identifier<br>
/// VIEWERLIB: User.HS.PACIndigStatus(INDSTCode)<br>
/// .Description<br>
/// HL7:  PID-10.2 : Race.Text<br>
/// VIEWERLIB: User.HS.PACIndigStatus(INDSTDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  PID-10.3 : Race.NameofCodingSystem<br>
/// VIEWERLIB: Not stored<br>
/// .CodeSystemVersionId<br>
/// HL7:  PID-10.7 : Race.CodingSystemVersionID<br>
/// VIEWERLIB: Not stored
Property Races As list Of HS.SDA3.CodeTableDetail.Race;

/// HL7ToSDA3:<br>
/// Though PID-22 is a repeating field, only the first non-null instance will<br>
/// be parsed, and only if subfield 1 or 2 is not null.<br><br>
/// HL7:  PID-22 : EthnicGroup<br>
/// SDATableName=EthnicGroup, ViewerClass=None<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  PID-22.1 : EthnicGroup.Identifier<br>
/// .Description<br>
/// HL7:  PID-22.2 : EthnicGroup.Text<br>
/// .SDACodingStandard<br>
/// HL7:  PID-22.3 : EthnicGroup.NameofCodingSystem<br>
/// .CodeSystemVersionId<br>
/// HL7:  PID-22.7 : EthnicGroup.CodingSystemVersionID<br>
Property EthnicGroup As HS.SDA3.CodeTableDetail.EthnicGroup;

/// List of next of kin/support contacts<br><br>
/// HL7ToSDA3:<br>
/// It is possible for one NK1 segment to be parsed as two SupportContacts.<br>
/// One is parsed from fields 2 through 9, the other from fields 13, 30, 31,<br>
/// and 32. See the SupportContact class for more info.<br><br>
/// HL7:  NK1<br>
/// VIEWERLIB: see HS.SDA3.SupportContact
Property SupportContacts As list Of HS.SDA3.SupportContact;

/// Date and time of birth<br><br>
/// Viewer cache:<br>
/// Only the date part of BirthTime is stored. (PAPERDob is date-only.)<br><br>
/// HL7:  PID-7.1 : DateTimeofBirth.Time<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERDob)<br>
Property BirthTime As HS.SDA3.TimeStamp;

/// Place of birth<br><br>
/// VIEWERLIB: Not stored
Property BirthPlace As HS.SDA3.Address;

/// If the patient was part of a multiple birth, this is an integer indicating<br>
/// the patient's birth order, unless this is "0", which indicates that the<br>
/// patient was not part of a multiple birth.<br><br>
/// HL7ToSDA3:<br>
/// If the first character, case-insensitive, of PID-24 is "N", then BirthOrder<br>
/// will be parsed as "0", else BirthOrder will be parsed from PID-25.<br><br>
/// HL7:  PID-24 : MultipleBirthIndicator<br>
/// HL7:  PID-25 : BirthOrder<br>
/// VIEWERLIB: Not stored
Property BirthOrder As HS.SDA3.Numeric(SCALE = 0);

/// A boolean value indicating whether the patient is protected<br><br>
/// HL7ToSDA3:<br>
/// A value of "Y" in the HL7 will be parsed as 1, "N" will be parsed as 0, the<br>
/// delete instruction (two double quotes) will be parsed as-is, and any other<br>
/// value in the HL7 will not be parsed.<br><br>
/// HL7:  PD1-12 : ProtectionIndicator<br>
/// VIEWERLIB: Not stored<br>
Property IsProtected As HS.SDA3.Boolean;

/// Date when protected status went into effect<br><br>
/// HL7:  PD1-13 : ProtectionIndicatorEffectiveDate<br>
/// VIEWERLIB: Not stored
Property ProtectedEffectiveDate As HS.SDA3.TimeStamp;

/// Time of death<br><br>
/// HL7:  PID-29.1 : PatientDeathDateandTime.Time<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERDeceasedDate) + User.HS.PAPerson(PAPERDeceasedTime)
Property DeathTime As HS.SDA3.TimeStamp;

/// A boolean value indicating whether the patient is dead<br>
/// Death time, location, etc. may not be known.<br><br>
/// HL7ToSDA3:<br>
/// A value of "Y" in the HL7 will be parsed as 1, "N" will be parsed as 0, the<br>
/// delete instruction (two double quotes) will be parsed as-is, and any other<br>
/// value in the HL7 will not be parsed.<br><br>
/// Viewer cache:<br>
/// A value of 1 in the SDA will be stored as "Y" in the Viewer Cache. No other<br>
/// value will be stored.<br><br>
/// HL7:  PID-30 : PatientDeathIndicator<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERDeceased)<br>
Property IsDead As HS.SDA3.Boolean;

/// Where patient died<br><br>
/// VIEWERLIB: User.HS.PAPerson(PAPERLocationOfDeath)
Property DeathLocation As %String(MAXLEN = 255);

/// Care provider who declared patient dead<br><br>
/// SDATableName=CareProvider, ViewerClass=User.HS.CTCareProv<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERDoctorDeclaredDR)
Property DeathDeclaredBy As HS.SDA3.CodeTableDetail.CareProvider;

/// Country of Citizenship (or Nationality)<br><br>
/// HL7ToSDA3:<br>
/// Though PID-26 is a repeating field, only the first non-null instance is<br>
/// used, and only if subfield 1 or 2 is not null. If no value is parsed from<br>
/// PID-26, HL7ToSDA3 will use PID-28, but only if subfield 1 or 2 is not null.<br><br>
/// HL7:  PID-26 : Citizenship<br>
/// HL7:  PID-28 : Nationality<br>
/// SDATableName=Citizenship, ViewerClass=User.HS.CTNation<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERNationDR)<br><br>
/// .Code<br>
/// HL7:  PID-26.1 : Citizenship.Identifier<br>
/// HL7:  PID-28.1 : Nationality.Identifier<br>
/// VIEWERLIB: User.HS.CTNation(CTNATCode)<br>
/// .Description<br>
/// HL7:  PID-26.2 : Citizenship.Text<br>
/// HL7:  PID-28.2 : Nationality.Text<br>
/// VIEWERLIB: User.HS.CTNation(CTNATDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  PID-26.3 : Citizenship.NameofCodingSystem<br>
/// HL7:  PID-28.3 : Nationality.NameofCodingSystem<br>
/// VIEWERLIB: Not stored
Property Citizenship As HS.SDA3.CodeTableDetail.Citizenship;

/// List of Patient Numbers<br><br>
/// HL7ToSDA3:<br>
/// HL7ToSDA3 will attempt to parse PatientNumbers from PID-2, -3, -4, -19, and<br>
/// 20 according to the following logic.<br>
/// PID-2:<br>
/// Will only be parsed if subfield 1 is not null and subfield 5 is "MR",<br>
/// "MRN", "PI", or "". Number is parsed from subfield 1. NumberType is parsed<br>
/// as "MRN". The Organization Code is parsed from subfield 4.1 or, if that is<br>
/// null, MSH-4.1. HL7ToSDA3 does not set the Organization Description.<br>
/// ISOAssigningAuthority is parsed from subfield 4.<br>
/// PID-3:<br>
/// Every instance of PID-3 will be parsed. Number is parsed from subfield 1.<br>
/// NumberType is parsed from subfield 5, but is subject to certain mapping<br>
/// rules. Values of "MRN", "SSN", "DL", "XX", "PPN", "SNC", "NI", "OTH", and<br>
/// "" will always be parsed as-is. Values of "MR" and "PI" will always be<br>
/// parsed as "MRN". What is parsed for any other value depends on the value of<br>
/// the Configuration Registry key<br>
/// "\General\LegacyPatientIdentifierTypeRestriction". If it is logically<br>
/// "true" (1, for example), then any other value of PID-3.5 will be parsed as<br>
/// "OTH". If the registry key is logically "false" or undefined, then the<br>
/// value will be parsed as-is. The Organization Code of the PatientNumber is<br>
/// parsed from PID-3.4.1. If that value is null and the parsed NumberType is<br>
/// "MRN" or "", then MSH-4.1 will be used as the Organization Code. HL7ToSDA3<br>
/// does not set the Organization Description. ISOAssigningAuthority is parsed<br>
/// from subfield 4.<br>
/// PID-4:<br>
/// Is parsed the same way PID-3 is, though sequentially after PID-3, so<br>
/// PatientNumbers that come from PID-4 appear after those from PID-3 in the<br>
/// SDA.<br>
/// PID-19:<br>
/// Will only be parsed if it is not null, and if no PatientNumber with<br>
/// NumberType="SSN" was parsed from PID-3 or -4. In this case, Number is<br>
/// parsed from PID-19 and NumberType is parsed as "SSN".<br>
/// PID-20:<br>
/// Will only be parsed if subfield 1 is not null, and only if no PatientNumber<br>
/// with NumberType="DL" was parsed from PID-3 or -4. In this case, Number is<br>
/// parsed from PID-20.1, NumberType is parsed as "DL", and Organization.Code<br>
/// is parsed from PID-20.2.<br><br>
/// Streamlet cache:<br>
/// When an existing Patient in the Streamlet Cache is updated, only existing<br>
/// PatientNumbers with a NumberType that is not in the inbound list are<br>
/// preserved. Other existing PatientNumbers are replaced in the update.<br>
/// In the OnValidate method of the Streamlet class, the NumberType of each<br>
/// PatientNumber is validated. Values of "MRN", "SSN", "DL", "SNC", "NI",<br>
/// "XX", and "PPN" are always valid. If the value of the Configuration<br>
/// Registry key "\General\LegacyPatientIdentifierTypeRestriction" is logically<br>
/// true, then the only other valid NumberType is "OTH". Otherwise, to be<br>
/// valid, the NumberType must be set up as an Identifier Type in HealthShare<br>
/// (HealthShare Management > Registry > Other Management > Identifier Types)<br>
/// and be flagged as active and an additional patient identifier. If the<br>
/// NumberType is not valid, the PatientNumber will be removed from the list<br>
/// and an alert logged in the Ensemble Event Log.<br><br>
/// Aggregation cache:<br>
/// On aggregate, the inbound list of PatientNumbers will be compared to the<br>
/// existing list, matching on NumberType, Number, and Organization.Code. If a<br>
/// match is found, the ISOAssigningAuthority of the inbound PatientNumber will<br>
/// be saved to the existing. If no match is found, the inbound PatientNumber<br>
/// will be inserted into the existing list.<br><br>
/// Viewer cache:<br>
/// The Number of the first PatientNumber with NumberType="MRN" will be saved<br>
/// to PAPerson.PAPMIIPNo and PAPMIOPNo. Likewise with NumberType="SSN" and<br>
/// PAPerson.PAPMIMedicare, "DL" and PAPERPassportNumber, "SNC" and<br>
/// PAPMISafetyNetCardNo, and "NI" and PAPERID.<br><br>
/// HL7:  PID-2 : PatientID<br>
/// HL7:  PID-3 : PatientIdentifierList<br>
/// HL7:  PID-4 : AlternatePatientID<br>
/// HL7:  PID-19 : SSNNumber<br>
/// HL7:  PID-20 : DriversLicenseNumberPatient<br><br>
/// .Number<br>
/// HL7:  PID-2.1 : PatientID.IDNumber<br>
/// HL7:  PID-3.1 : PatientIdentifierList.IDNumber<br>
/// HL7:  PID-4.1 : AlternatePatientID.IDNumber<br>
/// HL7:  PID-19 : SSNNumber<br>
/// HL7:  PID-20.1 : DriversLicenseNumberPatient.LicenseNumber<br>
/// VIEWERLIB: User.HS.PAPerson(PAPMIIPNo)<br>
/// VIEWERLIB: User.HS.PAPerson(PAPMIOPNo)<br>
/// VIEWERLIB: User.HS.PAPerson(PAPMIMedicare)<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERPassportNumber)<br>
/// VIEWERLIB: User.HS.PAPerson(PAPMISafetyNetCardNo)<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERID)<br>
/// .NumberType<br>
/// HL7:  PID-3.5 : PatientIdentifierList.IdentifierTypeCode<br>
/// HL7:  PID-4.5 : AlternatePatientID.IdentifierTypeCode<br>
/// VIEWERLIB: Not stored<br>
/// .Organization<br>
/// HL7:  PID-2.4.1 : PatientID.AssigningAuthority.NamespaceID<br>
/// HL7:  PID-3.4.1 : PatientIdentifierList.AssigningAuthority.NamespaceID<br>
/// HL7:  PID-4.4.1 : AlternatePatientID.AssigningAuthority.NamespaceID<br>
/// HL7:  PID-20.2 : DriversLicenseNumberPatient.IssuingStateProvinceCountry<br>
/// HL7:  MSH-4.1 : SendingFacility.NamespaceID<br>
/// VIEWERLIB: see HS.SDA3.PatientNumber<br>
/// .ISOAssigningAuthority<br>
/// HL7:  PID-2.4 : PatientID.AssigningAuthority<br>
/// HL7:  PID-3.4 : PatientIdentifierList.AssigningAuthority<br>
/// HL7:  PID-4.4 : AlternatePatientID.AssigningAuthority<br>
/// VIEWERLIB: Not stored<br>
Property PatientNumbers As list Of HS.SDA3.PatientNumber;

/// If this SDA is for a patient merge or change number or encounter move, then<br>
/// this property contains the PatientNumbers for the victim or source patient<br>
/// record.<br><br>
/// HL7ToSDA3:<br>
/// Each instance of MRG-1 with subfield 4 not null will be parsed.<br><br>
/// Steamlet cache:<br>
/// PriorPatientNumbers is not saved to the Streamlet Cache. However, the first<br>
/// entry in it with NumberType="MRN" will be appended to the InactiveMRNs<br>
/// property as "[SendingFacility]^[AssigningAuthority]^[Number]".<br><br>
/// HL7:  MRG-1 : PriorPatientIdentifierList<br>
/// VIEWERLIB: Not stored<br><br>
/// .Number<br>
/// HL7:  MRG-1.1 : PriorPatientIdentifierList.IDNumber<br>
/// VIEWERLIB: Not stored<br>
/// .Organization<br>
/// The Assigning Authority for the number<br>
/// HL7ToSDA3:<br>
/// MRG-1.4.1 is parsed into the Organization Code. HL7ToSDA3 does not set the<br>
/// Description.<br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// HL7:  MRG-1.4.1 : PriorPatientIdentifierList.AssigningAuthority.NamespaceID<br>
/// VIEWERLIB: Not stored<br>
/// .NumberType<br>
/// HL7ToSDA3:<br>
/// The source for NumberType is MRG-1.5, subject to certain mapping rules.<br>
/// Values of "MRN", "SSN", "DL", "XX", "PPN", "SNC", "NI", "OTH", and "" will<br>
/// always be parsed as-is. Values of "MR" and "PI" will always be parsed as<br>
/// "MRN". What is parsed for any other value depends on the value of the<br>
/// Configuration Registry key<br>
/// "\General\LegacyPatientIdentifierTypeRestriction". If it is logically<br>
/// "true" (1, for example), then any other value of MRG-1.5 will be parsed as<br>
/// "OTH". If the registry key is logically "false" or undefined, then the<br>
/// value will be parsed as-is.<br>
/// HL7:  MRG-1.5 : PriorPatientIdentifierList.IdentifierTypeCode<br>
/// VIEWERLIB: Not stored<br>
Property PriorPatientNumbers As list Of HS.SDA3.PatientNumber;

/// HL7ToSDA3:<br>
/// Every non-null instance of PID-11 will be parsed.<br><br>
/// Aggregation cache:<br>
/// The inbound list of Addresses is compared to the existing, matching on<br>
/// Street, City.Code, State.Code, and Zip.Code. If a match is found, the<br>
/// FromTime, ToTime, Country, and County of the inbound Address will update the<br>
/// properties of the existing. Otherwise, the inbound Address is inserted into<br>
/// the existing list.<br><br>
/// Viewer cache:<br>
/// The first Address in the list is loaded into the properties of PAPerson.<br>
/// Every Address in the list, including the first, is loaded into the Viewer<br>
/// Cache as a PATempAddress.<br><br>
/// HL7:  PID-11 : PatientAddress<br><br>
/// .Street<br>
/// HL7ToSDA3:<br>
/// Subfield 2, if not null, is concatenated to subfield 1.1 as: "[1.1]; [2]".<br>
/// Viewer cache:<br>
/// PAPERStName can only be set during the initial load to the Viewer Cache.<br>
/// HL7:  PID-11.1.1 : PatientAddress.StreetAddress.StreetorMailingAddress<br>
/// HL7:  PID-11.2 : PatientAddress.OtherDesignation<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERStName)<br>
/// VIEWERLIB: User.HS.PATempAddress(ADDRStreet)<br>
/// .City<br>
/// HL7ToSDA3:<br>
/// PID-11.3 is parsed to the City Code. HL7ToSDA3 does not set the<br>
/// Description.<br>
/// Viewer cache:<br>
/// PAPERCityCodeDR can only be set during the initial load to the Viewer<br>
/// Cache.<br>
/// HL7:  PID-11.3 : PatientAddress.City<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERCityCodeDR)<br>
/// VIEWERLIB: User.HS.PATempAddress(ADDRCityDR)<br>
/// .State<br>
/// HL7ToSDA3:<br>
/// PID-11.4 is parsed to the State Code. HL7ToSDA3 does not set the<br>
/// Description.<br>
/// Viewer cache:<br>
/// PAPERCTProvinceDR can only be set during the initial load to the Viewer<br>
/// Cache.<br>
/// HL7:  PID-11.4 : PatientAddress.StateorProvince<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERCTProvinceDR)<br>
/// VIEWERLIB: User.HS.PATempAddress(ADDRProvinceDR)<br>
/// .Zip<br>
/// HL7ToSDA3:<br>
/// PID-11.5 is parsed to the Zip Code. HL7ToSDA3 does not set the Description.<br>
/// Viewer cache:<br>
/// PAPERZipDR can only be set during the initial load to the Viewer Cache.<br>
/// HL7:  PID-11.5 : PatientAddress.ZiporPostalCode<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERZipDR)<br>
/// VIEWERLIB: User.HS.PATempAddress(ADDRZipDR)<br>
/// .Country<br>
/// HL7ToSDA3:<br>
/// PID-11.6 is parsed to the Country Code. HL7ToSDA3 does not set the<br>
/// Description.<br>
/// Viewer cache:<br>
/// PAPERCountryDR can only be set if it is null.<br>
/// HL7:  PID-11.6 : PatientAddress.Country<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERCountryBirthDR)<br>
/// VIEWERLIB: User.HS.PATempAddress(ADDRCountryDR)<br>
/// .County<br>
/// HL7ToSDA3:<br>
/// PID-11.9 is parsed to the County Code.  HL7ToSDA3 does not set the<br>
/// Description.<br>
/// Viewer cache:<br>
/// Not Stored.<br>
/// .FromTime<br>
/// Viewer cache:<br>
/// Only the date part is stored in the Viewer Cache. (PAPEREffDateCurrAddress<br>
/// and ADDRDateFrom are both date-only.)<br>
/// If, during the initial load, the first Address in the list has no FromTime,<br>
/// PAPEREffDateCurrAddress is set to the date part of Patient.EnteredOn.<br>
/// HL7:  PID-11.13.1 : PatientAddress.EffectiveDate.Time<br>
/// VIEWERLIB: User.HS.PAPerson(PAPEREffDateCurrAddress)<br>
/// VIEWERLIB: User.HS.PATempAddress(ADDRDateFrom)<br>
/// .ToTime<br>
/// Viewer cache:<br>
/// Not stored for the first (current) Address.<br>
/// HL7:  PID-11.14.1 : PatientAddress.ExpirationDate.Time<br>
/// VIEWERLIB: User.HS.PATempAddress(ADDRDateTo)
Property Addresses As list Of HS.SDA3.Address;

/// Contact information for the Patient<br><br>
/// HL7ToSDA3:<br>
/// For each instance of PID-13 and -14, the algorithm to parse a phone number<br>
/// out of that field is:<br>
/// -If subfields 5, 6, 7, and 8 are not all null, compose the number out of<br>
/// them as "+[.5] ([.6]) [.7] x[.8]".<br>
/// -Else if subfield 12 is not null, use that.<br>
/// -Else if subfield 1 is not null, use that.<br>
/// -Else continue to the next instance of this field.<br><br>
/// Streamlet cache:<br>
/// In the Streamlet Cache, an update to existing ContactInfo updates each<br>
/// property individually, rather than simply overwriting the existing<br>
/// ContactInfo object.<br><br>
/// Aggregation cache:<br>
/// Similar to the Streamlet Cache, in the Aggregation Cache each property of<br>
/// ContactInfo is updated individually.<br><br>
/// HL7:  PID-13 : PhoneNumberHome<br>
/// HL7:  PID-14 : PhoneNumberBusiness<br><br>
/// .HomePhoneNumber<br>
/// HL7ToSDA3:<br>
/// HomePhoneNumber is parsed from the first instance of PID-13 with subfield 2<br>
/// in ["",PRN,ORN,VHN,ASN,EMR], and subfield 3 in ["",PH], and from which a<br>
/// number can be parsed using the above algorithm.<br>
/// HL7:  PID-13 : PhoneNumberHome<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERTelH)<br>
/// .WorkPhoneNumber<br>
/// HL7ToSDA3:<br>
/// WorkPhoneNumber is parsed from the first instance of PID-14 with subfield 2<br>
/// in ["",WPN,ASN,EMR], and subfield 3 in ["",PH], and from a number can be<br>
/// parsed using the above algorithm.<br>
/// HL7:  PID-14 : PhoneNumberBusiness<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERTelO)<br>
/// .MobilePhoneNumber<br>
/// HL7ToSDA3:<br>
/// MobilePhoneNumber is parsed from the first instance of PID-13 with subfield<br>
/// 2="BPN" or subfield 3 in [CP,BP], and from which a number can be parsed<br>
/// using the above algorithm. If no MobilePhoneNumber can be parsed from,<br>
/// PID-13, HL7ToSDA3 attempts to parse one from PID-14 matching the same<br>
/// conditions.<br>
/// HL7:  PID-13 : PhoneNumberHome<br>
/// HL7:  PID-14 : PhoneNumberBusiness<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERMobPhone)<br>
/// .EmailAddress<br>
/// HL7ToSDA3:<br>
/// EmailAddress is parsed from the first non-null instance of PID-13.4, or, if<br>
/// no EmailAddress can be parsed from that field, from the first non-null<br>
/// instance of PID-14.4.<br>
/// HL7:  PID-13.4 : PhoneNumberHome.EmailAddress<br>
/// HL7:  PID-14.4 : PhoneNumberBusiness.EmailAddress<br>
/// VIEWERLIB: User.HS.PAPerson(PAPEREmail)
Property ContactInfo As HS.SDA3.ContactInfo;

/// Patient's family doctor<br>
/// Also known as GeneralPractitioner(GP), PrimaryCareProvider<br><br>
/// HL7ToSDA3:<br>
/// Though PD1-4 is a repeating field, HL7ToSDA3 will only parse the first<br>
/// non-null instance.<br><br>
/// HL7:  PD1-4 : PatientPrimaryCareProvider<br>
/// SDATableName=FamilyDoctor, ViewerClass=User.HS.PACRefDoctor<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERFamilyDoctorDR)<br><br>
/// .Code<br>
/// HL7:  PD1-4.1 : PatientPrimaryCareProvider.IDNumber<br>
/// VIEWERLIB: User.HS.PACRefDoctor(REFDCode)<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// Description is composed of the given and family names concatenated together<br>
/// as: "[FamilyName], [GivenName]".<br>
/// HL7:  PD1-4.2.1 : PatientPrimaryCareProvider.FamilyName.Surname<br>
/// HL7:  PD1-4.3 : PatientPrimaryCareProvider.GivenName<br>
/// VIEWERLIB: User.HS.PACRefDoctor(REFDDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  PD1-4.9 : PatientPrimaryCareProvider.AssigningAuthority<br>
/// VIEWERLIB: Not stored<br>
/// .Name.FamilyName<br>
/// HL7:  PD1-4.2.1 : PatientPrimaryCareProvider.FamilyName.Surname<br>
/// VIEWERLIB: User.HS.PACRefDoctor(REFDFamilyName)<br>
/// .Name.GivenName<br>
/// HL7:  PD1-4.3 : PatientPrimaryCareProvider.GivenName<br>
/// VIEWERLIB: User.HS.PACRefDoctor(REFDForename)<br>
/// .Name.MiddleName<br>
/// HL7:  PD1-4.4 : PatientPrimaryCareProvider.MiddleName<br>
/// VIEWERLIB: User.HS.PACRefDoctor(REFDMiddleName)<br>
/// .Name.NamePrefix<br>
/// HL7:  PD1-4.6 : PatientPrimaryCareProvider.NamePrefix<br>
/// VIEWERLIB: User.HS.PACRefDoctor(REFDTitle)<br>
/// .Name.NameSuffix<br>
/// HL7:  PD1-4.7 : PatientPrimaryCareProvider.NameSuffix<br>
/// VIEWERLIB: Not stored
Property FamilyDoctor As HS.SDA3.CodeTableDetail.FamilyDoctor;

/// A comma-delimited list of a patient's inactive (victim) MRNs.<br><br>
/// Streamlet cache:<br>
/// For a patient merge or change number, the InactiveMRNs value from the<br>
/// victim record is copied to the survivor record, and the MRN of the victim<br>
/// record is added to it. For a regular update, the inbound property will be<br>
/// concatenated to the existing.<br><br>
/// Aggregation cache:<br>
/// In the Aggregation Cache, the inbound property is simply concatenated to<br>
/// existing property.<br><br>
/// VIEWERLIB: User.HS.PAPerson(PAPERRemark)
Property InactiveMRNs As %String(MAXLEN = 1000);

/// The patient's occupation<br><br>
/// VIEWERLIB: Not stored
Property Occupation As HS.SDA3.CodeTableDetail.Occupation;

/// What level of publicity is allowed for this visit (Family only, No<br>
/// publicity, etc.)<br>
/// In the context of immunization messages, this refers to how a person wishes<br>
/// to be contacted in a reminder or recall situation.<br><br>
/// HL7ToSDA3:<br>
/// PD1-11 will only be parsed if subfield 2 is not null.<br><br>
/// HL7:  PD1-11 : PublicityCode<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  PD1-11.1 : PublicityCode.Identifier<br>
/// .Description<br>
/// HL7:  PD1-11.2 : PublicityCode.Text<br>
/// .SDACodingStandard<br>
/// HL7:  PD1-11.3 : PublicityCode.NameofCodingSystem
Property PublicityCode As HS.SDA3.CodeTableDetail.PublicityCode;

/// When the PublicityCode went into effect<br><br>
/// HL7ToSDA3:<br>
/// PD1-18 will only be parsed if PD1-11.2 is not null.<br><br>
/// HL7:  PD1-18 : PublicityCodeEffectiveDate<br>
/// VIEWERLIB: Not stored
Property PublicityEffectiveDate As HS.SDA3.TimeStamp;

/// Comments on the Patient<br><br>
/// HL7ToSDA3:<br>
/// Currently the only message type supported by HealthShare with NTE segments<br>
/// that will be parsed as Patient Comments is ORU_R01.<br><br>
/// HL7:  NTE-3 : Comment<br>
/// VIEWERLIB: Not stored
Property Comments As %String(MAXLEN = 999);

/// HL7:  PD1-16 : ImmunizationRegistryStatus<br>
/// VIEWERLIB: Not stored
Property ImmunizationRegistryStatus As %String;

/// The effective date for ImmunizationRegistryStatus<br><br>
/// HL7ToSDA3:<br>
/// PD1-17 will only be parsed if PD1-16 is not null.<br><br>
/// HL7: PD1-17 : ImmunizationRegistryStatusEffectiveDate<br>
/// VIEWERLIB: Not stored
Property ImmunizationRegistryStatusEffectiveDate As HS.SDA3.TimeStamp;

/// The patient's communication preference<br><br>
/// VIEWERLIB: Not stored
Property CommunicationPreference As %String(VALUELIST = ",Email,Phone,Mail");

/// Used by care community
Property Providers As list Of HS.SDA3.DocumentProvider;

/// Used by care community
Property Organizations As list Of HS.SDA3.DocumentOrganization;

/// HL7ToSDA3:<br>
/// Though EVN-5 is a repeating field, only the first non-null instance will be<br>
/// used.<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if the SDA contains no<br>
/// CreatedBy, it will be defaulted to EnteredBy.<br><br>
/// Aggregation cache:<br>
/// In the Aggregation cache, EnteredBy can only be populated from the best<br>
/// (most trusted) record.<br><br>
/// HL7:  EVN-5 : OperatorID<br>
/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERUserUpdate)<br><br>
/// .Code<br>
/// HL7:  EVN-5.1 : OperatorID.IDNumber<br>
/// VIEWERLIB: User.HS.SSUser(SSUSRInitials)<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// Description is composed of the given and family names concatenated together<br>
/// as: "[FamilyName], [GivenName]".<br>
/// HL7:  EVN-5.2.1 : OperatorID.FamilyName.Surname<br>
/// HL7:  EVN-5.3 : OperatorID.GivenName<br>
/// VIEWERLIB: User.HS.SSUser(SSUSRName)<br>
/// .SDACodingStandard<br>
/// HL7:  EVN-5.9 : OperatorID.AssigningAuthority<br>
/// VIEWERLIB: Not stored
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if the SDA contains no<br>
/// CreatedBy, it will be defaulted to EnteredBy.<br><br>
/// Aggregation cache:<br>
/// In the Aggregation cache, CreatedBy can only be populated from the best<br>
/// (most trusted) record.<br><br>
/// VIEWERLIB: Not stored
Property CreatedBy As HS.SDA3.CodeTableDetail.User;

/// HL7ToSDA3:<br>
/// PID-34.1 will be parsed to the EnteredAt Code if not null, else MSH-4.1<br>
/// will be. In either case, HL7ToSDA3 does not set the Description.<br><br>
/// Aggregation cache:<br>
/// The EnteredAt Code will always be set to the facility code of the best<br>
/// (most trusted) facility that a request goes out to. If the Access Manager<br>
/// has an InboundCodeSystemProfile specified, and that profile specifies an<br>
/// SDACodingStandard for Organization, then that value will be used. If the<br>
/// SDACodingStandard is filled in and there is a Description in the Code<br>
/// Registry for that Code and SDACodingStandard, that Description will be<br>
/// used.<br><br>
/// HL7:  PID-34 : LastUpdateFacility<br>
/// HL7:  MSH-4 : SendingFacility<br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERLastUpdateHospitalDR)<br><br>
/// .Code<br>
/// HL7:  PID-34.1 : LastUpdateFacility.NamespaceID<br>
/// HL7:  MSH-4.1 : SendingFacility.NamespaceID<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPCode)<br>
/// .Description<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPDesc)<br>
/// .SDACodingStandard<br>
/// VIEWERLIB: Not stored
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if EnteredOn is null, it<br>
/// will be defaulted to the current date and time. Then, if CreatedOn is null,<br>
/// it will be defaulted to EnteredOn.<br><br>
/// Aggregation cache:<br>
/// In the Aggregation cache, EnteredOn can only be populated from the best<br>
/// (most trusted) record.<br><br>
/// HL7:  PID-33.1 : LastUpdateDateTime.Time<br>
/// VIEWERLIB: User.HS.PAPerson(PAPERUpdateDate) + User.HS.PAPerson(PAPERUpdateTime)
Property EnteredOn As HS.SDA3.TimeStamp;

/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if CreatedOn is null, it<br>
/// is defaulted to EnteredOn, which may have been defaulted to the current<br>
/// date and time.<br><br>
/// Aggregation cache:<br>
/// In the Aggregation cache, CreatedOn can only be populated from the best<br>
/// (most trusted) record.<br><br>
/// VIEWERLIB: Not stored
Property CreatedOn As HS.SDA3.TimeStamp;

/// For every other streamlet type, this property is used as a tiebreaker when<br>
/// aggregating records from the same tier facility at the Access Gateway. (See<br>
/// the annotation on the superclass property for more info.) And while this<br>
/// property is still set for Patient (by virtue of the Patient streamlet being<br>
/// saved via HS.SDA3.Streamlet.Abstract:SaveStreamlet), it is not used during<br>
/// the aggregation of Patient streamlets. The HS.SDA3.Streamlet.Patient class<br>
/// implements its own Aggregate method that does not use this property. In<br>
/// time the Patient:Aggregate method will incorporate facility tier and how<br>
/// recent the record is into its logic, but for right now we are simply<br>
/// documenting that this property is not used the way it is for other classes.<br><br>
/// VIEWERLIB: Not stored
Property UpdatedOn As HS.SDA3.TimeStamp;

/// Supported values:<br>
/// D = Delete, along with all associated streamlets<br>
/// R = Replace (First delete existing Patient and all associated streamlets,<br>
/// then insert given Patient)<br>
/// Any other value = Add or Update<br>
/// For both "D" and "R", the existing Patient is selected via the inbound<br>
/// Container SendingFacility and the Organization Code and Number of the first<br>
/// inbound PatientNumber with NumberType="MRN".<br><br>
/// VIEWERLIB: Not stored
Property ActionCode As %String;

/// Not used.
Property ActionScope As %String;

/// Not used.
Property EncounterNumber As %String(MAXLEN = 220);

/// Not used.
Property FromTime As HS.SDA3.TimeStamp;

/// Not used.
Property ToTime As HS.SDA3.TimeStamp;

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
<Value>MPIID</Value>
</Value>
<Value name="9">
<Value>Name</Value>
</Value>
<Value name="10">
<Value>MothersMaidenName</Value>
</Value>
<Value name="11">
<Value>Aliases</Value>
</Value>
<Value name="12">
<Value>PrimaryLanguages</Value>
</Value>
<Value name="13">
<Value>OtherLanguages</Value>
</Value>
<Value name="14">
<Value>Religion</Value>
</Value>
<Value name="15">
<Value>MaritalStatus</Value>
</Value>
<Value name="16">
<Value>Gender</Value>
</Value>
<Value name="17">
<Value>Race</Value>
</Value>
<Value name="18">
<Value>SupportContacts</Value>
</Value>
<Value name="19">
<Value>BirthTime</Value>
</Value>
<Value name="20">
<Value>DeathTime</Value>
</Value>
<Value name="21">
<Value>IsDead</Value>
</Value>
<Value name="22">
<Value>DeathLocation</Value>
</Value>
<Value name="23">
<Value>DeathDeclaredBy</Value>
</Value>
<Value name="24">
<Value>Citizenship</Value>
</Value>
<Value name="25">
<Value>PatientNumbers</Value>
</Value>
<Value name="26">
<Value>PriorPatientNumbers</Value>
</Value>
<Value name="27">
<Value>Addresses</Value>
</Value>
<Value name="28">
<Value>ContactInfo</Value>
</Value>
<Value name="29">
<Value>FamilyDoctor</Value>
</Value>
<Value name="30">
<Value>InactiveMRNs</Value>
</Value>
<Value name="31">
<Value>FromTime</Value>
</Value>
<Value name="32">
<Value>ToTime</Value>
</Value>
<Value name="33">
<Value>Deleted</Value>
</Value>
<Value name="34">
<Value>PrimaryLanguage</Value>
</Value>
<Value name="35">
<Value>UpdatedOn</Value>
</Value>
<Value name="36">
<Value>CustomPairs</Value>
</Value>
<Value name="37">
<Value>EthnicGroup</Value>
</Value>
<Value name="38">
<Value>BirthPlace</Value>
</Value>
<Value name="39">
<Value>Occupation</Value>
</Value>
<Value name="40">
<Value>BlankNameReason</Value>
</Value>
<Value name="41">
<Value>ProtectedEffectiveDate</Value>
</Value>
<Value name="42">
<Value>IsProtected</Value>
</Value>
<Value name="43">
<Value>PublicityCode</Value>
</Value>
<Value name="44">
<Value>PublicityEffectiveDate</Value>
</Value>
<Value name="45">
<Value>Comments</Value>
</Value>
<Value name="46">
<Value>ImmunizationRegistryStatus</Value>
</Value>
<Value name="47">
<Value>ImmunizationRegistryStatusEffectiveDate</Value>
</Value>
<Value name="48">
<Value>CommunicationPreference</Value>
</Value>
<Value name="49">
<Value>Races</Value>
</Value>
<Value name="50">
<Value>CreatedBy</Value>
</Value>
<Value name="51">
<Value>CreatedOn</Value>
</Value>
<Value name="52">
<Value>MothersFullName</Value>
</Value>
<Value name="53">
<Value>BirthOrder</Value>
</Value>
<Value name="54">
<Value>Extension</Value>
</Value>
<Value name="55">
<Value>DocumentProviders</Value>
</Value>
<Value name="56">
<Value>DocumentOrganizations</Value>
</Value>
<Value name="57">
<Value>Providers</Value>
</Value>
<Value name="58">
<Value>Organizations</Value>
</Value>
<Value name="59">
<Value>BirthGender</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
