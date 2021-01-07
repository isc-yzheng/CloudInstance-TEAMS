/// HS.SDA3.Diagnosis corresponds to the CDA Hospital Admission Diagnosis
/// section and the Discharge Diagnosis section.
Class HS.SDA3.Diagnosis Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.DiagnosisExtension;

/// Clinician who made the diagnosis<br><br>
/// HL7ToSDA3:<br>
/// Though DG1-16 is a repeating field, HL7ToSDA3 will only parse the first<br>
/// non-null instance.<br><br>
/// HL7:  DG1-16 : DiagnosingClinician<br>
/// SDATableName=CareProvider, ViewerClass=User.HS.CTCareProv<br>
/// VIEWERLIB: User.HS.MRDiagnos(MRDIADocCodeDR)<br><br>
/// .Code<br>
/// HL7:  DG1-16.1 : DiagnosingClinician.IDNumber<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPCode)<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// The name is formatted as "[Family], [Given]" to make the Description.<br>
/// HL7:  DG1-16.2.1 : DiagnosingClinician.FamilyName.Surname<br>
/// HL7:  DG1-16.3 : DiagnosingClinician.GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  DG1-16.9 : DiagnosingClinician.AssigningAuthority<br>
/// VIEWERLIB: Not stored<br>
/// .Name.FamilyName<br>
/// HL7:  DG1-16.2.1 : DiagnosingClinician.FamilyName.Surname<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPSurname)<br>
/// .Name.GivenName<br>
/// HL7:  DG1-16.3 : DiagnosingClinician.GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPFirstName)<br>
/// .Name.MiddleName<br>
/// HL7:  DG1-16.4 : DiagnosingClinician.SecondandFurtherGivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPOtherName)<br>
/// .Name.NamePrefix<br>
/// HL7:  DG1-16.6 : DiagnosingClinician.Prefix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTitle)<br>
/// .Name.NameSuffix<br>
/// HL7:  DG1-16.5 : DiagnosingClinician.Suffix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTextTwo)<br>
/// .Name.ProfessionalSuffix<br>
/// HL7:  DG1-16.21 : DiagnosingClinician.ProfessionalSuffix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTextThree)<br>
Property DiagnosingClinician As HS.SDA3.CodeTableDetail.CareProvider;

/// The diagnosis code or description<br><br>
/// HL7ToSDA3:<br>
/// DG1-3 will only be parsed if subfield 1 or 2 is not null. If they are and<br>
/// DG1-4 is not null, then it will be parsed as the Diagnosis Code. In this<br>
/// case, HL7ToSDA3 will not set the Description.<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if the SDA has no Diagnosis<br>
/// CodeTableDetail, an error will be logged and the Streamlet will not be saved.<br><br>
/// HL7:  DG1-3 : DiagnosisCodeDG1<br>
/// HL7:  DG1-4 : DiagnosisDescription<br>
/// SDATableName=Diagnosis, ViewerClass=User.HS.MRCICDDx<br>
/// VIEWERLIB: User.HS.MRDiagnos(MRDIAICDCodeDR)<br><br>
/// .Code<br>
/// HL7ToSDA3:<br>
/// DG1-4 will only be used if DG1-3.1 and .2 are null.<br>
/// HL7:  DG1-3.1 : DiagnosisCodeDG1.Identifier<br>
/// HL7:  DG1-4 : DiagnosisDescription<br>
/// VIEWERLIB: User.HS.MRCICDDx(MRCIDCode)<br>
/// .Description<br>
/// HL7:  DG1-3.2 : DiagnosisCodeDG1.Text<br>
/// VIEWERLIB: User.HS.MRCICDDx(MRCIDDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  DG1-3.3 : DiagnosisCodeDG1.NameofCodingSystem<br>
/// VIEWERLIB: Not stored<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// If subfield 4 or 5 is not null, then a PriorCode will be parsed to the SDA<br>
/// with Code coming from subfield 4, Description from 5, and CodingSystem from<br>
/// 6. The Type will be parsed as "A".<br>
/// HL7:  DG1-3.4 : DiagnosisCodeDG1.AlternateIdentifier<br>
/// HL7:  DG1-3.5 : DiagnosisCodeDG1.AlternateText<br>
/// HL7:  DG1-3.6 : DiagnosisCodeDG1.NameofAlternateCodingSystem<br>
/// VIEWERLIB: Not stored<br>
/// .OriginalText<br>
/// HL7:  DG1-3.9 : DiagnosisCodeDG1.OriginalText<br>
/// VIEWERLIB: Not stored
Property Diagnosis As HS.SDA3.CodeTableDetail.Diagnosis;

/// The type of diagnosis (e.g. admitting, working, final, discharge)<br><br>
/// HL7ToSDA3:<br>
/// DG1-6 is used as the DiagnosisType Code. HL7ToSDA3 does not set the<br>
/// Description.<br><br>
/// Streamlet cache:<br>
/// See the ActionScope property.<br><br>
/// Viewer cache:<br>
/// Rather than being a property of MRDiagnos directly, the MRCDiagnosType is a<br>
/// property of MRDiagType, which is a child of MRDiagnos. An MRDiagnos can only<br>
/// have one MRDiagType.<br><br>
/// HL7:  DG1-6 : DiagnosisType<br>
/// SDATableName=DiagnosisType, ViewerClass=User.HS.MRCDiagnosType<br>
/// VIEWERLIB: User.HS.MRDiagnos(ChildMRDiagType)->User.HS.MRDiagType(TYPMRCDiagTyp)
Property DiagnosisType As HS.SDA3.CodeTableDetail.DiagnosisType;

/// A related (e.g. secondary) diagnosis<br><br>
/// Viewer cache:<br>
/// If another Diagnosis exists in the same Encounter (or no Encounter if this<br>
/// Diagnosis is Encounter-less) with Diagnosis.Code matching this LinkedDiagnosisCode,<br>
/// MRDIAMRDIADR will be set to a reference to that Diagnosis (as a User.HS.MRDiagnos).<br>
/// Note that the other Diagnosis must already be saved to the viewer cache for the<br>
/// link to be made.<br><br>
/// VIEWERLIB: User.HS.MRDiagnos(MRDIAMRDIADR)
Property LinkedDiagnosisCode As %String;

/// A related (e.g. secondary) diagnosis External ID<br><br>
/// VIEWERLIB: User.HS.MRDiagnos(MRDIALinkedExternalId)
Property LinkedExternalId As %String(MAXLEN = 220);

/// When the diagnosis was made<br><br>
/// VIEWERLIB: User.HS.MRDiagnos(MRDIADateDiagnosisIdentif) + User.HS.MRDiagnos(MRDIATimeDiagnosisIdentif)
Property IdentificationTime As HS.SDA3.TimeStamp;

/// HL7ToSDA3:<br>
/// For any Diagnosis parsed from a DG1 segment, Status will not actually be<br>
/// parsed from any field of the segment, but rather the Code will always be<br>
/// parsed as "A" and the Description as "Active".<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if the SDA has no Status,<br>
/// a Status with Code="A" and Description="Active" will be defaulted in.<br><br>
/// SDATableName=DiagnosisStatus, ViewerClass=User.HS.MRCDiagnosStatus<br>
/// VIEWERLIB: User.HS.MRDiagnos(MRDIADiagStatDR)<br>
Property Status As HS.SDA3.CodeTableDetail.DiagnosisStatus;

/// When the diagnosed condition began<br><br>
/// VIEWERLIB: User.HS.MRDiagnos(MRDIAOnsetDate) + User.HS.MRDiagnos(MRDIAOnsetTime)
Property OnsetTime As HS.SDA3.TimeStamp;

/// D = Delete<br>
/// I = Inactivate All (set Status.Code="I",Description="Inactive")<br>
/// C = Clear All<br>
/// Any other value = Add or Update<br>
/// See the annotation on the superclass property for more information on how<br>
/// ActionCode is used.<br><br>
/// HL7ToSDA3:<br>
/// Two double quotes ("") in DG1-1 will be parsed as ActionCode="I", and four<br>
/// double quotes ("""") as "C".  In either case the rest of the segment is<br>
/// ignored. HL7ToSDA3 will also parse values of "A", "D", and "U" (for "Add",<br>
/// "Delete", and "Update") from DG1-21, though "D" is the only value that is<br>
/// meaningful to HealthShare. Any other non-null value will be parsed as "A".<br><br>
/// HL7:  DG1-1 : SetIDDG1<br>
/// HL7:  DG1-21 : DiagnosisActionCode<br>
/// VIEWERLIB: Not stored
Property ActionCode As %String;

/// "ADMISSION" = Inactivate/Clear all Diagnoses with DiagnosisType.Code="A"<br>
/// "DISCHARGE" = Inactivate/Clear all Diagnoses with DiagnosisType.Code'="A"<br>
/// See the annotation on the superclass property for more information on how<br>
/// ActionScope is used.<br><br>
/// VIEWERLIB: Not stored
Property ActionScope As %String;

/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: User.HS.MRDiagnos(MRDIAUserCreatedDR)
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// HL7ToSDA3:<br>
/// MSH-4.1 is parsed as the EnteredAt Code. HL7ToSDA3 does not set the<br>
/// Description.<br><br>
/// HL7:  MSH-4.1 : SendingFacility.NamespaceID<br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.MRDiagnos(MRDIAUpdateHospitalDR)
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// HL7:  DG1-5.1 : DiagnosisDateTime.Time<br>
/// VIEWERLIB: User.HS.MRDiagnos(MRDIADate) + User.HS.MRDiagnos(MRDIATime)<br>
/// VIEWERLIB: User.HS.MRDiagnos(MRDIAUpdateDate) + User.HS.MRDiagnos(MRDIAUpdateTime)
Property EnteredOn As HS.SDA3.TimeStamp;

/// VIEWERLIB: User.HS.MRDiagnos(MRDIAExternalId)
Property ExternalId As %String(MAXLEN = 220);

/// The priority of the diagnosis code<br>
/// The value 1 means that this is the primary diagnosis. Values 2-99 convey ranked secondary diagnoses.<br><br>
/// HL7:  DG1-15 : DiagnosisPriority<br>
/// VIEWERLIB: Not stored
Property DiagnosisPriority As %String;

ClassMethod StartXMLList()
{
	Quit "<Diagnoses>"
}

ClassMethod EndXMLList()
{
	Quit "</Diagnoses>"
}

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
<Value>DiagnosingClinician</Value>
</Value>
<Value name="9">
<Value>Diagnosis</Value>
</Value>
<Value name="10">
<Value>DiagnosisType</Value>
</Value>
<Value name="11">
<Value>LinkedDiagnosisCode</Value>
</Value>
<Value name="12">
<Value>LinkedExternalId</Value>
</Value>
<Value name="13">
<Value>IdentificationTime</Value>
</Value>
<Value name="14">
<Value>Status</Value>
</Value>
<Value name="15">
<Value>OnsetTime</Value>
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
<Value>DiagnosisPriority</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
