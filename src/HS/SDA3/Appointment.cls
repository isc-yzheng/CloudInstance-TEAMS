Class HS.SDA3.Appointment Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.AppointmentExtension;

/// HL7ToSDA3:<br>
/// Status will be set depending on the type of event received. Possible values<br>
/// are "CANCELLED" (SIU_S15, Notification of appointment cancellation), "DC"<br>
/// for "Discontinued" (SIU_S16, Notification of appointment discontinuation)<br>
/// and null for any other event.<br><br>
/// Streamlet cache:<br>
/// The OnBeforeMatch method of the Streamlet class will default a null value<br>
/// to "BOOKED".<br><br>
/// Viewer cache:<br>
/// In the Viewer Cache, a Status of "CANCELLED" will be stored as "X", "DC" as<br>
/// "D", and all other values as "P". The value that appears in the Viewer does<br>
/// not come from the DISPLAYLIST of the APPTStatus property, but rather the<br>
/// Description for the corresponding RBApptStatus Standard Type Item.  See the<br>
/// HS documentation for guidance on configuring this.<br><br>
/// VIEWERLIB: User.HS.RBAppointment(APPTStatus)
Property Status As %String;

/// HL7ToSDA3:<br>
/// Will be set to 1 if an SIU_S26 (Notification that patient did not show up<br>
/// for scheduled appointment) is received.<br><br>
/// Streamlet cache:<br>
/// The OnBeforeMatch method of the Streamlet class will default a null value<br>
/// to 0. Note that this means that if the value for an existing Appointment is<br>
/// 1 and an update is applied that has no NoShow value, the saved value will<br>
/// become 0.<br><br>
/// Viewer cache:<br>
/// If NoShow is 1, the value stored in the Viewer Cache is the Description for the<br>
/// AppointmentStatus Standard Type Item with Code="N", "Not Attended" by default.<br>
/// See the HS documentation for guidance on configuring this.<br><br>
/// VIEWERLIB: User.HS.RBAppointment(APPTConfirmation)
Property NoShow As HS.SDA3.Boolean;

/// HL7ToSDA3:<br>
/// SCH-7 will only be parsed if subfield 1 or 2 is not null.<br><br>
/// HL7:  SCH-7 : AppointmentReason<br>
/// SDATableName=AppointmentType, ViewerClass=User.HS.RBCSessionType<br>
/// VIEWERLIB: User.HS.RBApptSchedule(ASSessionTypeDR)<br><br>
/// .Code<br>
/// HL7:  SCH-7.1 : AppointmentReason.Identifier<br>
/// VIEWERLIB: User.HS.RBCSessionType(SESSCode)<br>
/// .Description<br>
/// HL7:  SCH-7.2 : AppointmentReason.Text<br>
/// VIEWERLIB: User.HS.RBCSessionType(SESSDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  SCH-7.3 : AppointmentReason.NameofCodingSystem<br>
/// VIEWERLIB: Not stored<br>
Property Type As HS.SDA3.CodeTableDetail.AppointmentType;

/// HL7ToSDA3:<br>
/// If both Placer Appointment ID and Occurrence Number are given, PlacerApptId<br>
/// will be parsed as "[PlacerAppointmentID]:[OccurrenceNumber]".<br><br>
/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the Streamlet class, if both PlacerApptId<br>
/// and FillerApptId are null, an error will be logged and the Streamlet will<br>
/// not be processed.<br><br>
/// HL7:  SCH-1.1 : PlacerAppointmentID.EntityIdentifier<br>
/// HL7:  SCH-3 : OccurrenceNumber<br>
/// VIEWERLIB: User.HS.RBAppointment(APPTUBRN)
Property PlacerApptId As %String;

/// HL7ToSDA3:<br>
/// If both Filler Appointment ID and Occurrence Number are given,<br>
/// FillerApptId will be parsed as "[FillerAppointmentID]:[OccurrenceNumber]".<br><br>
/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the Streamlet class, if both PlacerApptId<br>
/// and FillerApptId are null, an error will be logged and the Streamlet will<br>
/// not be processed.<br><br>
/// HL7:  SCH-2.1 : FillerAppointmentID.EntityIdentifier<br>
/// HL7:  SCH-3 : OccurrenceNumber<br>
/// VIEWERLIB: User.HS.RBAppointment(APPTUSRN)
Property FillerApptId As %String;

/// Used to link an Appointment to an Order<br><br>
/// HL7:  SCH-26.1 : PlacerOrderNumber.EntityIdentifier<br>
/// VIEWERLIB: Not stored
Property PlacerOrderId As %String;

/// Used to link an Appointment to an Order<br><br>
/// HL7:  SCH-27.1 : FillerOrderNumber.EntityIdentifier<br>
/// VIEWERLIB: Not stored
Property FillerOrderId As %String;

/// The service to be performed during the appointment.<br><br>
/// HL7ToSDA3:<br>
/// AIS-3 will only be parsed if subfield 1 or 2 is not null.<br><br>
/// HL7:  AIS-3 : UniversalServiceIdentifier<br>
/// SDATableName=Order, ViewerClass=User.HS.ARCItmMast<br>
/// VIEWERLIB: User.HS.RBAppointment(APPTARCIMDR)<br><br>
/// .Code<br>
/// HL7:  AIS-3.1 : UniversalServiceIdentifier.Identifier<br>
/// VIEWERLIB: User.HS.ARCItmMast(ARCIMCode)<br>
/// .Description<br>
/// HL7:  AIS-3.2 : UniversalServiceIdentifier.Text<br>
/// VIEWERLIB: User.HS.ARCItmMast(ARCIMDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  AIS-3.3 : UniversalServiceIdentifier.NameofCodingSystem<br>
/// VIEWERLIB: Not stored<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// If subfield 4 or 5 is not null, then a PriorCode will be parsed to the SDA<br>
/// with Code coming from subfield 4, Description from 5, and CodingSystem from<br>
/// 6. The Type will be parsed as "A".<br>
/// HL7:  AIS-3.4 : UniversalServiceIdentifier.AlternateIdentifier<br>
/// HL7:  AIS-3.5 : UniversalServiceIdentifier.AlternateText<br>
/// HL7:  AIS-3.6 : UniversalServiceIdentifier.NameofAlternateCodingSystem<br>
/// VIEWERLIB: Not stored<br>
/// .OriginalText<br>
/// HL7:  AIS-3.9 : UniversalServiceIdentifier.OriginalText<br>
/// VIEWERLIB: Not stored
Property OrderItem As HS.SDA3.CodeTableDetail.Order;

/// HL7ToSDA3:<br>
/// Though AIP-3 is a repeating field, HL7ToSDA3 will only parse the first<br>
/// non-null instance. AIP-4, if present, will be parsed as the<br>
/// CareProviderType of the AIP-3 CareProvider.<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if the Appointment<br>
/// does not have a CareProvider or Location, an error will be logged and<br>
/// the streamlet will not be saved.<br><br>
/// HL7:  AIP-3 : PersonnelResourceID<br>
/// HL7:  AIP-4 : ResourceType<br>
/// SDATableName=CareProvider, ViewerClass=User.HS.CTCareProv<br>
/// VIEWERLIB: User.HS.RBAppointment(APPTRequestedCPDR)<br><br>
/// .Code<br>
/// HL7:  AIP-3.1 : IDNumber<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPCode)<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// The name is formatted as "[Family], [Given]" to make the Description.<br>
/// HL7:  AIP-3.2.1 : FamilyName.Surname<br>
/// HL7:  AIP-3.3 : GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  AIP-3.9 : AssigningAuthority<br>
/// VIEWERLIB: Not stored<br>
/// .Name.FamilyName<br>
/// HL7:  AIP-3.2.1 : FamilyName.Surname<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPSurname)<br>
/// .Name.GivenName<br>
/// HL7:  AIP-3.3 : GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPFirstName)<br>
/// .Name.MiddleName<br>
/// HL7:  AIP-3.4 : SecondandFurtherGivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPOtherName)<br>
/// .Name.NamePrefix<br>
/// HL7:  AIP-3.6 : Prefix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTitle)<br>
/// .Name.NameSuffix<br>
/// HL7:  AIP-3.5 : Suffix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTextTwo)<br>
/// .Name.ProfessionalSuffix<br>
/// HL7:  AIP-3.21 : ProfessionalSuffix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTextThree)<br>
/// .CareProviderType<br>
/// HL7ToSDA3:<br>
/// AIP-4 will be parsed as the CareProviderType of the AIP-3 CareProvider, but<br>
/// only if subfield 1 or 2 is not null.<br>
/// HL7:  AIP-4 : ResourceType<br>
/// SDATableName=CareProviderType, ViewerClass=User.HS.CTCarPrvTp<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPCarPrvTpDR)<br>
/// .CareProviderType.Code<br>
/// HL7:  AIP-4.1 : ResourceType.Identifier<br>
/// VIEWERLIB: User.HS.CTPCPCarPrvTpDR(CTCPTCode)<br>
/// .CareProviderType.Description<br>
/// HL7:  AIP-4.2 : ResourceType.Text<br>
/// VIEWERLIB: User.HS.CTPCPCarPrvTpDR(CTCPTDesc)<br>
/// .CareProviderType.SDACodingStandard<br>
/// HL7:  AIP-4.3 : ResourceType.NameofCodingSystem<br>
/// VIEWERLIB: Not stored
Property CareProvider As HS.SDA3.CodeTableDetail.CareProvider;

/// HL7ToSDA3:<br>
/// AIL-3.9 is parsed to the Location Code. HL7ToSDA3 does not set the<br>
/// Description.<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if the Appointment<br>
/// does not have a CareProvider or Location, an error will be logged and<br>
/// the streamlet will not be saved.<br><br>
/// HL7:  AIL-3.9 : LocationResourceID.LocationDescription<br>
/// SDATableName=HealthCareFacility, ViewerClass=User.HS.CTLoc<br>
/// VIEWERLIB: User.HS.RBResource(RESCTLOCDR)
Property Location As HS.SDA3.CodeTableDetail.HealthCareFacility;

/// CRLF-delimited string<br><br>
/// HL7ToSDA3:<br>
/// Only the NTEs following the TQ1 segment (or the SCH if there is no<br>
/// TQ1) will be parsed.<br><br>
/// HL7:  NTE-3 : Comment<br>
/// VIEWERLIB: User.HS.RBAppointment(APPTRemarks)
Property Notes As %String(MAXLEN = "");

/// HL7ToSDA3:<br>
/// Though SCH-20 is a repeating field, HL7ToSDA3 will only use the first<br>
/// non-null instance.<br><br>
/// HL7:  SCH-20 : EnteredByPerson<br>
/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: User.HS.RBAppointment(APPTLastStatusChangeUserDR)<br><br>
/// .Code<br>
/// HL7:  SCH-20.1 : EnteredByPerson.IDNumber<br>
/// VIEWERLIB: User.HS.SSUser(SSUSRInitials)<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// The name is formatted as "[Family], [Given]" to make the Description.<br>
/// HL7:  SCH-20.2.1 : EnteredByPerson.FamilyName.Surname<br>
/// HL7:  SCH-20.3 : EnteredByPerson.GivenName<br>
/// VIEWERLIB: User.HS.SSUser(SSUSRName)<br>
/// .SDACodingStandard<br>
/// HL7:  SCH-20.9 : EnteredByPerson.AssigningAuthority<br>
/// VIEWERLIB: Not stored<br>
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// HL7ToSDA3:<br>
/// SCH-22 is used if subfield 4.1 is not null, else MSH-4 is used.  In either<br>
/// case, the HL7 value is used as the EnteredAt Code. HL7ToSDA3 does not set<br>
/// the Description.<br><br>
/// HL7:  SCH-22.4.1 : EnteredAtLocation.Facility.NamespaceID<br>
/// HL7:  MSH-4.1 : SendingFacility.NamespaceID<br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.RBAppointment(APPTLastStatusChangeHospitalDR)
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if EnteredOn is null, it<br>
/// is defaulted to the current date/time.<br><br>
/// VIEWERLIB: User.HS.RBAppointment(APPTLastStatusChangeDate) + User.HS.RBAppointment(APPTLastStatusChangeTime)
Property EnteredOn As HS.SDA3.TimeStamp;

/// HL7ToSDA3:<br>
/// If a TQ1 is present, TQ1-7 will be used, else SCH-11.4 will be used.<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if FromTime is null, an error will<br>
/// be logged and the Appointment will not be saved.<br><br>
/// Viewer cache:<br>
/// ASDate and ASSession are date-only. ASSessStartTime and APPTETA are time-only.<br><br>
/// HL7:  TQ1-7 : StartDateTime<br>
/// HL7:  SCH-11.4 : AppointmentTimingQuantity.StartDateTime<br>
/// VIEWERLIB: User.HS.RBAppointment(APPTETA)<br>
/// VIEWERLIB: User.HS.RBApptSchedule(ASSessStartTime)<br>
/// VIEWERLIB: User.HS.RBApptSchedule(ASDate)<br>
/// VIEWERLIB: User.HS.RBApptSchedule(ASSession)<br>
Property FromTime As HS.SDA3.TimeStamp;

/// HL7ToSDA3:<br>
/// If a TQ1 is present, only TQ1 fields will be used, else SCH fields will be<br>
/// used.<br>
/// If the HL7 contains a start time but no end time, and it contains a<br>
/// duration (TQ1-6.1 or SCH-9) and a duration units (TQ1-6.2.1 or SCH-10.1)<br>
/// equal to "MINUTES", "M", "HOURS", or "H" (case-insensitive),<br>
/// then ToTime will be calculated from the start time and duration.<br><br>
/// Viewer cache:<br>
/// ASSessEndTime is time-only.<br><br>
/// HL7:  TQ1-6.1 : ServiceDuration.Quantity<br>
/// HL7:  TQ1-6.2.1 : ServiceDuration.Units.Identifier<br>
/// HL7:  TQ1-8 : EndDateTime<br>
/// HL7:  SCH-9 : AppointmentDuration<br>
/// HL7:  SCH-10.1 : AppointmentDurationUnits.Identifer<br>
/// HL7:  SCH-11.5 : AppointmentTimingQuantity.EndDateTime<br>
/// VIEWERLIB: User.HS.RBApptSchedule(ASSessEndTime)
Property ToTime As HS.SDA3.TimeStamp;

/// VIEWERLIB: User.HS.RBAppointment(APPTEBEI)
Property ExternalId As %String(MAXLEN = 220);

/// Supported values:<br>
/// D = Delete<br>
/// C = Clear All<br>
/// Any other value = Add or Update<br>
/// See the annotation on the superclass property for more information on how<br>
/// ActionCode is used.<br><br>
/// VIEWERLIB: Not stored
Property ActionCode As %String;

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
<Value>FromTime</Value>
</Value>
<Value name="9">
<Value>ToTime</Value>
</Value>
<Value name="10">
<Value>Deleted</Value>
</Value>
<Value name="11">
<Value>UpdatedOn</Value>
</Value>
<Value name="12">
<Value>Status</Value>
</Value>
<Value name="13">
<Value>Duration</Value>
</Value>
<Value name="14">
<Value>Type</Value>
</Value>
<Value name="15">
<Value>PlacerApptId</Value>
</Value>
<Value name="16">
<Value>FillerApptId</Value>
</Value>
<Value name="17">
<Value>PlacerOrderId</Value>
</Value>
<Value name="18">
<Value>FillerOrderId</Value>
</Value>
<Value name="19">
<Value>OrderItem</Value>
</Value>
<Value name="20">
<Value>CareProvider</Value>
</Value>
<Value name="21">
<Value>Location</Value>
</Value>
<Value name="22">
<Value>Notes</Value>
</Value>
<Value name="23">
<Value>NoShow</Value>
</Value>
<Value name="24">
<Value>CustomPairs</Value>
</Value>
<Value name="25">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
