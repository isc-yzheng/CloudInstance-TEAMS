/// HS.SDA3.Encounter corresponds to the CDA Encounters section
/// and to /ClinicalDocument/componentOf/encompassingEncounter.
Class HS.SDA3.Encounter Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.EncounterExtension;

Parameter CANOVERRIDEPROPLIST = "EncounterType";

/// See the annotation on the superclass property for more info on how the<br>
/// EncounterNumber property is used.<br><br>
/// The method GenerateEncounterNum of the Encounter Streamlet class is used to<br>
/// generate an encounter number when none is given, both in HL7ToSDA3 and in<br>
/// the Streamlet class. They differ in the source of the values passed to the<br>
/// method, but in both cases the logic is:<br>
/// -If the encounter type is "G" or "S", generate EncounterNumber as "HSgenerated[incremental#]".<br>
/// -Else if the MRN and encounter admit date are not null, generate EncounterNumber as "[MRN]-[admit date]"<br>
/// -Else no EncounterNumber can be generated.<br><br>
/// HL7ToSDA3:<br>
/// If a message contains a PV1 segment but has no value in PV1-19.1, HL7ToSDA3<br>
/// will call GenerateEncounterNum to generate one, passing it the following<br>
/// values:<br>
/// -PV1-2 (Patient Class) as encounter type.<br>
/// -The source of the MRN value is:<br>
/// --PID-2.1 (Patient ID.ID Number), if not null.<br>
/// --Else the first PID-3.1 (Patient Identifier List.ID Number) with PID-3.5 (Identifier Type Code) = "MR", "MRN", or "PI", if there is one<br>
/// --Else the first PID-4.1 (Alternate Patient ID.ID Number) with PID-4.5 (Identifier Type Code) = "MR", "MRN", or "PI", if there is one<br>
/// -PV1-44.1 (Admit Date/Time.Time) as the admit date.<br>
/// If no EncounterNumber can be generated, a warning will be logged, no<br>
/// Encounter will be parsed to the SDA, and all streamlets in the SDA will be<br>
/// Encounter-less.<br><br>
/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the Streamlet class, if EncounterNumber is<br>
/// null, it is defaulted to the ExternalId. Then, if EncounterNumber contains<br>
/// a pipe character ("|"), an error will be logged and the Encounter will not<br>
/// be processed. If the EncounterNumber is null at this point,<br>
/// GenerateEncounterNum will be called with the following values:<br>
/// -The SDA EncounterType as the encounter type<br>
/// -The Number of the first PatientNumber in the SDA with NumberType="MRN" as the MRN<br>
/// -The SDA FromTime as as the admit date<br>
/// If no EncounterNumber can be generated, an error will be logged and the<br>
/// Encounter will not be processed.<br>
/// In the EncounterActions method, after OnBeforeMatch is called, if the<br>
/// Streamlet (not SDA) EncounterNumber is null, an error will be logged and<br>
/// the Encounter will not be processed.<br><br>
/// HL7:  PV1-19.1 : VisitNumber.IDNumber<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMADMNo)
Property EncounterNumber As %String(MAXLEN = 220);

/// Type of admission: Accident/Newborn/Elective etc.<br><br>
/// HL7ToSDA3:<br>
/// PV1-4 will be parsed as the AdmissionType Code. HL7ToSDA3 does not set the<br>
/// Description.<br><br>
/// HL7:  PV1-4 : AdmissionType<br>
/// SDATableName=AdmissionType, ViewerClass=User.HS.PACInPatAdmissionType<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMInPatAdmTypeDR)
Property AdmissionType As HS.SDA3.CodeTableDetail.AdmissionType;

/// Type of encounter<br>
/// See also the <property>EncounterCodedType</property> property<br>
/// Supported values:<br>
/// E = Emergency<br>
/// I = Inpatient<br>
/// O = Outpatient<br>
/// C = Community<br>
/// N = Not Applicable (HL7) or New Born (Viewer Cache)<br>
/// P = Pre-admit<br>
/// G = Generated<br>
/// S = Silent<br><br>
/// In the Clinical Viewer, Generated encounters do not appear on the encounter<br>
/// timeline but do appear on the Encounters chart. The data within them is<br>
/// selected unless "Deselect All" is clicked. Silent encounters do not appear<br>
/// on the encounter timeline or the Encounters chart, and the data within them<br>
/// is always selected. Also, if a patient's SDA contains data that is not<br>
/// connected to an Encounter but is "Encounter-level" in the Viewer Cache,<br>
/// HealthShare will connect that data to the patient's silent encounter in the<br>
/// Viewer Cache only. If the patient does not have a silent encounter in their<br>
/// SDA, HealthShare will create one in the Viewer Cache only.<br><br>
/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the Streamlet class, if the EncounterType is<br>
/// "P", it will be mapped to "I". In the OnValidate method, if EncounterType<br>
/// is null, it will be defaulted to "O". Any other invalid values will <br>
/// generate an Alert and be defaulted to "O".<br><br>
/// Viewer cache:<br>
/// Any value that is not E, I, O, N, G, P, S, or C gets defaulted to "O". The<br>
/// value that appears in the Viewer does not come from the DISPLAYLIST of the<br>
/// PAADMType property, but rather the Description for the corresponding<br>
/// AdmType Standard Type Item.  See the HS documentation for guidance on<br>
/// configuring this. Note that by default there are only entries for codes<br>
/// "I", "O", and "E", and in starting in HSVIEWER 15.03, "C". See the Clinical<br>
/// Viewer documentation for instructions on adding "C" to versions prior to<br>
/// 15.03. <br><br>
/// HL7:  PV1-2 : PatientClass<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMType)<br>
Property EncounterType As %String;

/// EncounterCodedType is used to allow SDA3 to support encounter type codes<br>
/// beyond those that are permitted for the <property>EncounterType</property> property. However,<br>
/// EncounterCodedType is not parsed from HL7 and is not used or stored in the<br>
/// Viewer Cache. Ideally, if EncounterCodedType is used, then a mapping should<br>
/// be defined of EncounterCodedType values to EncounterType values, and<br>
/// EncounterType set whenever possible.<br><br>
/// VIEWERLIB: Not stored
Property EncounterCodedType As HS.SDA3.CodeTableDetail.EncounterType;

/// Clinician who admitted the patient in this encounter<br><br>
/// HL7ToSDA3:<br>
/// Though PV1-17 is a repeating field, HL7ToSDA3 will only use the first<br>
/// instance.<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if AdmittingClinician is<br>
/// null, it will be defaulted to the first ConsultingClinician with a Code or<br>
/// Description, if there is one.<br><br>
/// HL7:  PV1-17 : AdmittingDoctor<br>
/// SDATableName=CareProvider, ViewerClass=User.HS.CTCareProv<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMAdmDocCodeDR)<br><br>
/// .Code<br>
/// HL7:  PV1-17.1 : AdmittingDoctor.IDNumber<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPCode)<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// The name is formatted as "[Family], [Given]" to make the Description.<br>
/// HL7:  PV1-17.2.1 : AdmittingDoctor.FamilyName.Surname<br>
/// HL7:  PV1-17.3 : AdmittingDoctor.GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  PV1-17.9 : AdmittingDoctor.AssigningAuthority<br>
/// VIEWERLIB: Not stored<br>
/// .Name.FamilyName<br>
/// HL7:  PV1-17.2.1 : AdmittingDoctor.FamilyName.Surname<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPSurname)<br>
/// .Name.GivenName<br>
/// HL7:  PV1-17.3 : AdmittingDoctor.GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPFirstName)<br>
/// .Name.MiddleName<br>
/// HL7:  PV1-17.4 : AdmittingDoctor.SecondandFurtherGivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPOtherName)<br>
/// .Name.NamePrefix<br>
/// HL7:  PV1-17.6 : AdmittingDoctor.Prefix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTitle)<br>
/// .Name.NameSuffix<br>
/// HL7:  PV1-17.7 : AdmittingDoctor.Degree<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTextTwo)<br>
Property AdmittingClinician As HS.SDA3.CodeTableDetail.CareProvider;

/// List of clinicians who attended to the patient during this encounter<br><br>
/// Viewer cache:<br>
/// Only the first AttendingClinician in the list is included in the patient's<br>
/// record in the Viewer Cache.<br><br>
/// HL7:  PV1-7 : AttendingDoctor<br>
/// SDATableName=CareProvider, ViewerClass=User.HS.CTCareProv<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMTreatingDrDR)<br><br>
/// .Code<br>
/// HL7:  PV1-7.1 : AttendingDoctor.IDNumber<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPCode)<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// The name is formatted as "[Family], [Given]" to make the Description.<br>
/// HL7:  PV1-7.2.1 : AttendingDoctor.FamilyName.Surname<br>
/// HL7:  PV1-7.3 : AttendingDoctor.GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  PV1-7.9 : AttendingDoctor.AssigningAuthority<br>
/// VIEWERLIB: Not stored<br>
/// .Name.FamilyName<br>
/// HL7:  PV1-7.2.1 : AttendingDoctor.FamilyName.Surname<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPSurname)<br>
/// .Name.GivenName<br>
/// HL7:  PV1-7.3 : AttendingDoctor.GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPFirstName)<br>
/// .Name.MiddleName<br>
/// HL7:  PV1-7.4 : AttendingDoctor.SecondandFurtherGivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPOtherName)<br>
/// .Name.NamePrefix<br>
/// HL7:  PV1-7.6 : AttendingDoctor.Prefix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTitle)<br>
/// .Name.NameSuffix<br>
/// HL7:  PV1-7.7 : AttendingDoctor.Degree<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTextTwo)<br>
Property AttendingClinicians As list Of HS.SDA3.CodeTableDetail.CareProvider;

/// List of clinicians who consulted during this encounter<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if AdmittingClinician is<br>
/// null, it will be defaulted to the first ConsultingClinician, if there is<br>
/// one.<br><br>
/// Viewer cache:<br>
/// Only the first ConsultingClinician in the list is included in the patient's<br>
/// record in the Viewer Cache.<br><br>
/// HL7:  PV1-9 : ConsultingDoctor<br>
/// SDATableName=CareProvider, ViewerClass=User.HS.CTCareProv<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMInternalrefDocDR)<br><br>
/// .Code<br>
/// HL7:  PV1-9.1 : ConsultingDoctor.IDNumber<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPCode)<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// The name is formatted as "[Family], [Given]" to make the Description.<br>
/// HL7:  PV1-9.2.1 : ConsultingDoctor.FamilyName.Surname<br>
/// HL7:  PV1-9.3 : ConsultingDoctor.GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  PV1-9.9 : ConsultingDoctor.AssigningAuthority<br>
/// VIEWERLIB: Not stored<br>
/// .Name.FamilyName<br>
/// HL7:  PV1-9.2.1 : ConsultingDoctor.FamilyName.Surname<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPSurname)<br>
/// .Name.GivenName<br>
/// HL7:  PV1-9.3 : ConsultingDoctor.GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPFirstName)<br>
/// .Name.MiddleName<br>
/// HL7:  PV1-9.4 : ConsultingDoctor.SecondandFurtherGivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPOtherName)<br>
/// .Name.NamePrefix<br>
/// HL7:  PV1-9.6 : ConsultingDoctor.Prefix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTitle)<br>
/// .Name.NameSuffix<br>
/// HL7:  PV1-9.7 : ConsultingDoctor.Degree<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTextTwo)<br>
Property ConsultingClinicians As list Of HS.SDA3.CodeTableDetail.CareProvider;

/// Clinician who made the referral for this encounter<br><br>
/// HL7ToSDA3:<br>
/// Though PV1-8 is a repeating field, HL7ToSDA3 will only use the first<br>
/// instance.<br><br>
/// HL7:  PV1-8 : ReferringDoctor<br>
/// SDATableName=ReferralDoctor, ViewerClass=User.HS.PACRefDoctor<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMRefDocListDR)<br><br>
/// .Code<br>
/// HL7:  PV1-8.1 : ReferringDoctor.IDNumber<br>
/// VIEWERLIB: User.HS.PACRefDoctor(REFDCode)<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// The name is formatted as "[Family], [Given]" to make the Description.<br>
/// HL7:  PV1-8.2.1 : ReferringDoctor.FamilyName.Surname<br>
/// HL7:  PV1-8.3 : ReferringDoctor.GivenName<br>
/// VIEWERLIB: User.HS.PACRefDoctor(REFDDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  PV1-8.9 : ReferringDoctor.AssigningAuthority<br>
/// VIEWERLIB: Not stored<br>
/// .Name.FamilyName<br>
/// HL7:  PV1-8.2.1 : PACRefDoctor.FamilyName.Surname<br>
/// VIEWERLIB: User.HS.PACRefDoctor(REFDFamilyName)<br>
/// .Name.GivenName<br>
/// HL7:  PV1-8.3 : ReferringDoctor.GivenName<br>
/// VIEWERLIB: User.HS.PACRefDoctor(REFDForename)<br>
/// .Name.MiddleName<br>
/// HL7:  PV1-8.4 : ReferringDoctor.SecondandFurtherGivenName<br>
/// VIEWERLIB: User.HS.PACRefDoctor(REFDMiddleName)<br>
/// .Name.NamePrefix<br>
/// HL7:  PV1-8.6 : ReferringDoctor.Prefix<br>
/// VIEWERLIB: User.HS.PACRefDoctor(REFDTitle)<br>
/// .Name.NameSuffix<br>
/// HL7:  PV1-8.7 : ReferringDoctor.Degree<br>
/// VIEWERLIB: Not stored
Property ReferringClinician As HS.SDA3.CodeTableDetail.ReferralDoctor;

/// Patient account number<br><br>
/// HL7:  PID-18.1 : PatientAccountNumber.IDNumber<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMAdmRef)
Property AccountNumber As %String(MAXLEN = 220);

/// If the EncounterNumber of this Encounter was changed or if another<br>
/// Encounter was merged into this one, this is the old/other EncounterNumber.<br>
/// See the chapter "Correcting Patient Records" in the book "Data Flow and<br>
/// Message Processing" in the HS documentation for more info.<br><br>
/// HL7:  MRG-5 : PriorVisitNumber<br>
/// VIEWERLIB: Not stored
Property PriorVisitNumber As %String(MAXLEN = 220);

/// A number given to the patient prior to being admitted but while information<br>
/// is being gathered<br><br>
/// HL7:  PV1-5.1 : PreadmitNumber.IDNumber<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMPreAdmNo)
Property PreAdmissionNumber As %String(MAXLEN = 220);

/// Code for source of admission (e.g. referral, accident, walk-in)<br><br>
/// HL7ToSDA3:<br>
/// PV1-14 will be parsed as the AdmissionSource Code. HL7ToSDA3 does not set<br>
/// the Description.<br><br>
/// HL7:  PV1-14 : AdmitSource<br>
/// SDATableName=AdmissionSource, ViewerClass=User.HS.PACAdmSource<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMAdmSrcDR)
Property AdmissionSource As HS.SDA3.CodeTableDetail.AdmissionSource;

/// Last Reported Ward code<br><br>
/// Streamlet cache:<br>
/// AssignedRoom and AssignedBed require an AssignedWard to be stored in the<br>
/// Streamlet Cache. In the OnBeforeMatch method of the Streamlet class, if<br>
/// either AssignedRoom or AssignedBed are not null and AssignedWard is null,<br>
/// an alert will be logged and AssignedRoom and AssignedBed set to null.<br><br>
/// Viewer cache:<br>
/// AssignedWard will be processed into the Viewer Cache as a PACWard code<br>
/// table entry with both WARDCode and WARDDesc = AssignedWard. Because a ward<br>
/// "belongs to" a healthcare facility in the Viewer Cache, a valid<br>
/// HealthCareFacility on the Encounter is required to process AssignedWard.<br><br>
/// HL7:  PV1-3.1 : AssignedPatientLocation.PointOfCare<br>
/// SDATableName=Ward, ViewerClass=User.HS.PACWard<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMCurrentWardDR)<br>
Property AssignedWard As %String;

/// Last Reported Room code<br><br>
/// Streamlet cache:<br>
/// AssignedRoom and AssignedBed require an AssignedWard to be stored in the<br>
/// Streamlet Cache. In the OnBeforeMatch method of the Streamlet class, if<br>
/// either AssignedRoom or AssignedBed are not null and AssignedWard is null,<br>
/// an alert will be logged and AssignedRoom and AssignedBed set to null.<br><br>
/// Viewer cache:<br>
/// AssignedRoom will be processed into the Viewer Cache as a PACRoom code<br>
/// table entry with ROOMDesc=AssignedWard and ROOMCode=[a unique value<br>
/// computed internally]. Because a room "belongs to" a ward in the Viewer<br>
/// Cache, a valid AssignedWard on the Encounter is required to process<br>
/// AssignedRoom.<br><br>
/// HL7:  PV1-3.2 : AssignedPatientLocation.Room<br>
/// SDATableName=Room, ViewerClass=User.HS.PACRoom<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMCurrentRoomDR)<br>
Property AssignedRoom As %String;

/// Last Reported Bed code<br><br>
/// Streamlet cache:<br>
/// AssignedRoom and AssignedBed require an AssignedWard to be stored in the<br>
/// Streamlet Cache. In the OnBeforeMatch method of the Streamlet class, if<br>
/// either AssignedRoom or AssignedBed are not null and AssignedWard is null,<br>
/// an alert will be logged and AssignedRoom and AssignedBed set to null.<br><br>
/// Viewer cache:<br>
/// AssignedBed will be processed into the Viewer Cache as a PACBed code table<br>
/// entry with BEDCode=AssignedBed. PACBed has no description field. Because a<br>
/// bed "belongs to" a ward in the Viewer Cache, a valid AssignedWard on the<br>
/// Encounter is required to process AssignedBed. If the SDA also contains an<br>
/// AssignedRoom, the AssignedBed will be linked to that in the Viewer Cache as<br>
/// well.<br><br>
/// HL7:  PV1-3.3 : AssignedPatientLocation.Bed<br>
/// SDATableName=Bed, ViewerClass=User.HS.PACBed<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMCurrentBedDR)<br>
Property AssignedBed As %String;

/// VIEWERLIB: Not stored
Property PriorWard As %String;

/// VIEWERLIB: Not stored
Property PriorRoom As %String;

/// VIEWERLIB: Not stored
Property PriorBed As %String;

/// Code for reason for admission<br><br>
/// HL7ToSDA3:<br>
/// PV2-3 will only be parsed if subfield 1 or 2 is not null.<br><br>
/// HL7:  PV2-3 : AdmitReason<br>
/// SDATableName=AdmitReason, ViewerClass=User.HS.PACAdmCategory<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMAdmCategDR)<br><br>
/// .Code<br>
/// HL7:  PV2-3.1 : AdmitReason.Identifier<br>
/// VIEWERLIB: User.HS.PACAdmCategory(ADMCATCode)<br>
/// .Description<br>
/// HL7:  PV2-3.2 : AdmitReason.Text<br>
/// VIEWERLIB: User.HS.PACAdmCategory(ADMCATDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  PV2-3.3 : AdmitReason.NameofCodingSystem<br>
/// VIEWERLIB: Not stored
Property AdmitReason As HS.SDA3.CodeTableDetail.AdmitReason;

/// HL7ToSDA3:<br>
/// PV1-10 will be parsed as the HealthCareFacility Code. HL7ToSDA3 does not<br>
/// set the Description.<br><br>
/// Streamlet cache:<br>
/// If the Encounter has no HealthCareFacility, one will be defaulted with Code<br>
/// and Organization.Code = SendingFacility of the SDA Container. On the<br>
/// Edge, this happens in the EncounterActions method of the Streamlet class.<br>
/// On the Access Gateway, this happens in the EPRFetchNotification method of<br>
/// HS.Gateway.Access.Manager. On the Access Gateway, if the Container<br>
/// SendingFacility is null, the Facility property of the EPRFetchNotification<br>
/// is used instead.<br><br>
/// HL7:  PV1-10 : HospitalService<br>
/// SDATableName=HealthCareFacility, ViewerClass=User.HS.CTLoc<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMDepCodeDR)<br><br>
/// .Organization<br>
/// HL7ToSDA3:<br>
/// MSH-4.1 will be parsed as the Organization Code. HL7ToSDA3 does not set the<br>
/// Description.<br>
/// HL7:  MSH-4.1 : SendingFacility.NamespaceID<br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMHospitalDR)
Property HealthCareFacility As HS.SDA3.CodeTableDetail.HealthCareFacility;

/// Discharged-to Location<br><br>
/// HL7ToSDA3:<br>
/// PV1-37.1 is parsed as the DischargeLocation Code.  HL7ToSDA3 does not set<br>
/// the Description.<br><br>
/// HL7:  PV1-37.1 : DischargedtoLocation.DischargeLocation<br>
/// SDATableName = DischargeLocation, ViewerClass=User.HS.PACDischargeDestination<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMMainMRADMDR)->User.HS.MRAdm(MRADMDischDestinDR)
Property DischargeLocation As HS.SDA3.CodeTableDetail.DischargeLocation;

/// Description of visit<br><br>
/// HL7:  PV2-12 : VisitDescription<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMRemark)<br>
Property VisitDescription As %String(MAXLEN = "");

/// Not used.
Property VisitStatus As %String(XMLIO = "IN");

/// The number part of the patient MRN under which this Encounter was<br>
/// last updated. This is needed at the Access Gateway, where Encounters from<br>
/// multiple sources (and probably multiple MRNs) can be aggregated into a<br>
/// single patient record.<br><br>
/// Streamlet cache:<br>
/// In the EncounterActions method of the Streamlet class, EncounterMRN is set<br>
/// to the Number of the Patient's first PatientNumber with NumberType="MRN".<br>
/// Note that this only happens on the Edge, not at the Access Gateway.<br><br>
/// VIEWERLIB: User.HS.PAAdm(PAADMEncounterMRN)
Property EncounterMRN As %String;

/// Assigning Authority of the EncounterMRN
/// VIEWERLIB: Not stored
Property EncounterMRNAA As %String;

/// List of guarantors for this patient.<br><br>
/// VIEWERLIB: Not stored
Property Guarantors As list Of HS.SDA3.Guarantor;

/// List of health funds associated with encounter<br><br>
/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the Streamlet class, if one of the<br>
/// HS.SDA3.HealthFunds does not have a HealthFund CodeTableDetail, or if it<br>
/// has one but the Code and Description are null, then an alert will be logged<br>
/// and the HS.SDA3.HealthFund will be removed from the list.<br><br>
/// HL7:  IN1<br>
/// VIEWERLIB: see HS.SDA3.HealthFund
Property HealthFunds As list Of HS.SDA3.HealthFund;

/// When storing SDA as streamlets, EndTime is not intended to come from the<br>
/// data provider, but rather is calculated from other fields.<br><br>
/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the Streamlet class, the value of EndTime is<br>
/// calculated as:<br>
/// -If ToTime is not null, ToTime<br>
/// -Else if EncounterType="I", two double quotes (the delete instruction)<br>
/// -Else, FromTime.<br><br>
/// Viewer cache:<br>
/// EndTime itself is not stored in the Viewer Cache, but the value of<br>
/// PAADMVisitStatus is derived from it: "D" if EndTime is not null, and "A"<br>
/// otherwise. Also, the value that appears in the Viewer does not come from<br>
/// the DISPLAYLIST of the PAADMVisitStatus property, but rather the<br>
/// Description of the corresponding AdmStatus Standard Type Item.  See the HS<br>
/// documentation for guidance on configuring this.<br><br>
/// VIEWERLIB: User.HS.PAAdm(PAADMVisitStatus)
Property EndTime As HS.SDA3.TimeStamp;

/// The conditions under which the patient was discharged<br><br>
/// HL7ToSDA3:<br>
/// PV1-36 is parsed as the SeparationMode Code. HL7ToSDA3 does not set the<br>
/// Description.<br><br>
/// HL7:  PV1-36 : DischargeDisposition<br>
/// SDATableName=SeparationMode, ViewerClass=None<br>
/// VIEWERLIB: Not stored
Property SeparationMode As HS.SDA3.CodeTableDetail.SeparationMode;

/// The clinical specialties under which the patient was treated during this<br>
/// Encounter<br><br>
/// SDATableName=CareProviderType, ViewerClass=User.HS.CTCarPrvTp<br>
/// VIEWERLIB: Not stored
Property Specialties As list Of HS.SDA3.CodeTableDetail.CareProviderType;

/// The recommendations for this patient forwarded to the specificied providers<br>
/// and organizations on discharge.<br><br>
/// VIEWERLIB: Not stored
Property RecommendationsProvided As list Of HS.SDA3.Recommendation;

/// The time that the patient is expected to be admitted<br><br>
/// VIEWERLIB: Not stored
Property ExpectedAdmitTime As HS.SDA3.TimeStamp;

/// The time that the patient is expected to be discharged<br><br>
/// VIEWERLIB: Not stored
Property ExpectedDischargeTime As HS.SDA3.TimeStamp;

/// What level of publicity is allowed for this visit (Family only, No<br>
/// publicity, etc.)<br><br>
/// VIEWERLIB: Not stored
Property PublicityCode As HS.SDA3.CodeTableDetail.PublicityCode;

/// The priority of this visit (Emergency, Urgent, Elective, etc.)<br><br>
/// VIEWERLIB: Not stored
Property Priority As HS.SDA3.CodeTableDetail.EncounterPriority;

/// The patient's expected return time, if the patient takes a leave of absence<br><br>
/// VIEWERLIB: Not stored
Property ExpectedLOAReturnTime As HS.SDA3.TimeStamp;

/// The diagnosis-related group (DRG) for this visit.<br><br>
/// HL7:  DRG-1 : DiagnosisRelatedGroup<br>
/// VIEWERLIB: Not stored
Property DiagnosisRelatedGroup As HS.SDA3.CodeTableDetail.DiagnosisRelatedGroup;

/// Whether this Encounter began in the Emergency Department before being<br>
/// transferred to the Inpatient Department.<br><br>
/// Streamlet cache:<br>
/// This property is set to 1 automatically when an EncounterType of "E"<br>
/// is changed to "I". This happens in the OnBeforeUpdateSDAEncounterType<br>
/// method, called before an inbound SDA updates a matching existing SDA.<br><br>
/// VIEWERLIB: Not stored
Property TransferredFromED As HS.SDA3.Boolean;

/// If this Encounter began in the Emergency Department before being<br>
/// transferred to the Inpatient Department, this property reflects the<br>
/// original admit time to the Emergency Department, while the FromTime should<br>
/// be the time the patient was admitted to the Inpatient Department.<br><br>
/// Streamlet cache:<br>
/// This property is automatically set to the original FromTime of the<br>
/// Encounter when EncounterType changes from "E" to "I". This happens in the<br>
/// OnBeforeUpdateSDAEncounterType method, called before an inbound SDA updates<br>
/// a matching existing SDA.<br><br>
/// VIEWERLIB: Not stored
Property EmergencyAdmitDateTime As HS.SDA3.TimeStamp;

/// Supported values:<br>
/// D = Delete this Encounter and any other Streamlets linked to it via EncounterNumber<br>
/// E = Delete this Encounter only if no other Streamlets are linked to it via EncounterNumber<br>
/// C = Clear all Encounters for this Patient and any other Streamlets linked to them via EncounterNumber<br>
/// R = Replace (First delete existing Encounter, then insert given Encounter)<br>
/// Any other value = Add or Update<br><br>
/// For ActionCode="R", any Streamlets linked to the original Encounter will<br>
/// also be deleted unless there are matching Streamlets in the inbound SDA.<br>
/// See the annotation on the superclass property for more information on how<br>
/// ActionCode is used.<br><br>
/// VIEWERLIB: Not stored
Property ActionCode As %String;

/// HL7ToSDA3:<br>
/// Though EVN-5 is a repeating field, HL7ToSDA3 will only use the first<br>
/// instance.<br><br>
/// HL7:  EVN-5 : OperatorID<br>
/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMUpdateUserDR)<br><br>
/// .Code<br>
/// HL7:  EVN-5.1 : OperatorID.IDNumber<br>
/// VIEWERLIB: User.HS.SSUser(SSUSRInitials)<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// The name is formatted as "[Family], [Given]" to make the Description.<br>
/// HL7:  EVN-5.2.1 : OperatorID.FamilyName.Surname<br>
/// HL7:  EVN-5.3 : OperatorID.GivenName<br>
/// VIEWERLIB: User.HS.SSUser(SSUSRName)<br>
/// .SDACodingStandard<br>
/// HL7:  EVN-5.9 : OperatorID.AssigningAuthority<br>
/// VIEWERLIB: Not stored<br>
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// HL7ToSDA3:<br>
/// MSH-4.1 is parsed as the EnteredAt Code. HL7ToSDA3 does not set the<br>
/// Description.<br><br>
/// HL7:  MSH-4.1 : SendingFacility.NamespaceID<br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMUpdateUserHospitalDR)<br>
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// HL7:  PV1-44.1 : AdmitDateTime.Time<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMUpdateDate) + User.HS.PAAdm(PAADMUpdateTime)
Property EnteredOn As HS.SDA3.TimeStamp;

/// Time that the encounter started<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if FromTime is null, it is<br>
/// defaulted to the current date/time.<br><br>
/// HL7:  PV1-44.1 : AdmitDateTime.Time<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMAdmDate) + User.HS.PAAdm(PAADMAdmTime)<br>
Property FromTime As HS.SDA3.TimeStamp;

/// Time that the encounter ended<br><br>
/// HL7ToSDA3:<br>
/// Though PV1-45 is a repeating field, HL7ToSDA3 will only use the first<br>
/// instance.<br><br>
/// Streamlet cache:<br>
/// If the EventDescription of the SDA Container is "ADT_A13" (Cancel<br>
/// discharge), then in the EncounterActions method of the Streamlet class<br>
/// (called on the Edge only), ToTime will be set to the delete instruction<br>
/// (two double quotes).<br><br>
/// HL7:  PV1-45.1 : DischargeDateTime.Time<br>
/// VIEWERLIB: User.HS.PAAdm(PAADMDischgDate) + User.HS.PAAdm(PAADMDischgTime)<br>
Property ToTime As HS.SDA3.TimeStamp;

/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the Streamlet class, if the EncounterNumber<br>
/// is initially null, it will be defaulted to the ExternalId.<br><br>
/// VIEWERLIB: User.HS.PAAdm(PAADMRefApprovNo)
Property ExternalId As %String(MAXLEN = 220);

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
<Value>StartTime</Value>
</Value>
<Value name="9">
<Value>EndTime</Value>
</Value>
<Value name="10">
<Value>AdmissionType</Value>
</Value>
<Value name="11">
<Value>EncounterType</Value>
</Value>
<Value name="12">
<Value>AdmittingClinician</Value>
</Value>
<Value name="13">
<Value>AttendingClinicians</Value>
</Value>
<Value name="14">
<Value>ConsultingClinicians</Value>
</Value>
<Value name="15">
<Value>ReferringClinician</Value>
</Value>
<Value name="16">
<Value>AccountNumber</Value>
</Value>
<Value name="17">
<Value>PriorVisitNumber</Value>
</Value>
<Value name="18">
<Value>PreAdmissionNumber</Value>
</Value>
<Value name="19">
<Value>AdmissionSource</Value>
</Value>
<Value name="20">
<Value>AssignedWard</Value>
</Value>
<Value name="21">
<Value>AssignedRoom</Value>
</Value>
<Value name="22">
<Value>AssignedBed</Value>
</Value>
<Value name="23">
<Value>PriorWard</Value>
</Value>
<Value name="24">
<Value>PriorRoom</Value>
</Value>
<Value name="25">
<Value>PriorBed</Value>
</Value>
<Value name="26">
<Value>AdmitReason</Value>
</Value>
<Value name="27">
<Value>HealthCareFacility</Value>
</Value>
<Value name="28">
<Value>DischargeLocation</Value>
</Value>
<Value name="29">
<Value>VisitDescription</Value>
</Value>
<Value name="30">
<Value>AdvanceDirective</Value>
</Value>
<Value name="31">
<Value>VisitStatus</Value>
</Value>
<Value name="32">
<Value>EncounterMRN</Value>
</Value>
<Value name="33">
<Value>HealthFunds</Value>
</Value>
<Value name="34">
<Value>FromTime</Value>
</Value>
<Value name="35">
<Value>ToTime</Value>
</Value>
<Value name="36">
<Value>Deleted</Value>
</Value>
<Value name="37">
<Value>UpdatedOn</Value>
</Value>
<Value name="38">
<Value>CustomPairs</Value>
</Value>
<Value name="39">
<Value>SeparationMode</Value>
</Value>
<Value name="40">
<Value>Specialty</Value>
</Value>
<Value name="41">
<Value>RecommendationProvided</Value>
</Value>
<Value name="42">
<Value>RecommendationRecipient</Value>
</Value>
<Value name="43">
<Value>Specialties</Value>
</Value>
<Value name="44">
<Value>RecommendationsProvided</Value>
</Value>
<Value name="45">
<Value>ExpectedAdmitTime</Value>
</Value>
<Value name="46">
<Value>ExpectedDischargeTime</Value>
</Value>
<Value name="47">
<Value>PublicityCode</Value>
</Value>
<Value name="48">
<Value>Priority</Value>
</Value>
<Value name="49">
<Value>ExpectedLOAReturnTime</Value>
</Value>
<Value name="50">
<Value>DRG</Value>
</Value>
<Value name="51">
<Value>DiagnosisRelatedGroup</Value>
</Value>
<Value name="52">
<Value>DischargeDisposition</Value>
</Value>
<Value name="53">
<Value>TransferredFromED</Value>
</Value>
<Value name="54">
<Value>EDTransferTime</Value>
</Value>
<Value name="55">
<Value>EDFromTime</Value>
</Value>
<Value name="56">
<Value>EmergencyAdmitDateTime</Value>
</Value>
<Value name="57">
<Value>EncounterCodedType</Value>
</Value>
<Value name="58">
<Value>Extension</Value>
</Value>
<Value name="59">
<Value>Guarantors</Value>
</Value>
<Value name="60">
<Value>EncounterMRNAA</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
