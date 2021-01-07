/// HS.SDA3.Procedure corresponds to the CDA Procedures section, also known
/// as Procedures and Interventions, or History of Procedures.
Class HS.SDA3.Procedure Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.ProcedureExtension;

/// Procedure code<br><br>
/// HL7ToSDA3:<br>
/// PR1-3 will be used if subfield 1 or 2 is not null. Else, PR1-4 will be<br>
/// used. In this case, PR1-4 will be parsed to the Procedure Code. HL7ToSDA3<br>
/// will not set the Description.<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet cache, if the SDA contains no<br>
/// Procedure, an error will be logged and the Streamlet will not be saved.<br><br>
/// HL7:  PR1-3 : ProcedureCode<br>
/// HL7:  PR1-4 : ProcedureDescription<br>
/// SDATableName=Procedure, ViewerClass=User.HS.ORCOperation<br>
/// VIEWERLIB: User.HS.MRProcedures(PROCOperationDR)<br><br>
/// .Code<br>
/// HL7:  PR1-3.1 : ProcedureCode.Identifier<br>
/// HL7:  PR1-4 : ProcedureDescription<br>
/// VIEWERLIB: User.HS.ORCOperation(OPERCode)<br>
/// .Description<br>
/// HL7:  PR1-3.2 : ProcedureCode.Text<br>
/// VIEWERLIB: User.HS.ORCOperation(OPERDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  PR1-3.3 : ProcedureCode.NameofCodingSystem<br>
/// VIEWERLIB: Not stored<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// In addition to subfield 1 or 2 not being null, if subfield 4 or 5 of PR1-3<br>
/// is not null, then then subfields 4, 5, and 6 will be parsed to the Code,<br>
/// Description, and CodeSystem of a PriorCode in the SDA. The Type will be<br>
/// parsed as "A".<br>
/// HL7:  PR1-3.4 : ProcedureCode.AlternateIdentifier<br>
/// HL7:  PR1-3.5 : ProcedureCode.AlternateText<br>
/// HL7:  PR1-3.6 : ProcedureCode.NameofAlternateCodingSystem<br>
/// VIEWERLIB: Not stored<br>
/// .OriginalText<br>
/// HL7ToSDA3:<br>
/// Subfield 9 of PR1-3 will only be parsed if subfield 1 or 2 is not null.<br>
/// HL7:  PR1-3.9 : ProcedureCode.OriginalText<br>
/// VIEWERLIB: Not stored
Property Procedure As HS.SDA3.CodeTableDetail.Procedure;

/// Clinician who performed procedure<br><br>
/// HL7ToSDA3:<br>
/// Though PR1-11 is a repeating field, only the first instance is used.<br><br>
/// HL7:  PR1-11 : Surgeon<br>
/// SDATableName=CareProvider, ViewerClass=User.HS.CTCareProv<br>
/// VIEWERLIB: User.HS.MRProcedures(PROCCTCPDR)<br><br>
/// .Code<br>
/// HL7:  PR1-11.1 : Surgeon.IDNumber<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPCode)<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// Description is parsed from the first instance of PR1-11, subfields 2.1<br>
/// (FamilyName.Surname) and 3 (GivenName), formatted as:<br>
/// "[FamilyName.Surname], [GivenName]".<br>
/// HL7:  PR1-11.2.1 : Surgeon.FamilyName.Surname<br>
/// HL7:  PR1-11.3 : Surgeon.GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  PR1-11.9 : Surgeon.AssigningAuthority<br>
/// VIEWERLIB: Not stored<br>
/// .Name.FamilyName<br>
/// HL7:  PR1-11.2.1 : Surgeon.FamilyName.Surname<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPSurname)<br>
/// .Name.GivenName<br>
/// HL7:  PR1-11.3 : Surgeon.GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPFirstName)<br>
/// .Name.MiddleName<br>
/// HL7:  PR1-11.4 : Surgeon.MiddleName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPOtherName)<br>
/// .Name.NamePrefix<br>
/// HL7:  PR1-11.6 : Surgeon.NamePrefix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTitle)<br>
/// .Name.NameSuffix<br>
/// HL7:  PR1-11.5 : Surgeon.Suffix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTextTwo)<br>
/// .Name.ProfessionalSuffix<br>
/// HL7:  PR1-11.21 : Surgeon.ProfessionalSuffix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTextThree)<br>
Property Clinician As HS.SDA3.CodeTableDetail.CareProvider;

/// Devices that were implanted or attached as part of this procedure.
Property Devices As list Of HS.SDA3.Device;

/// Time of the procedure<br><br>
/// HL7:  PR1-5.1 : ProcedureDateTime.Time<br>
/// VIEWERLIB: User.HS.MRProcedures(PROCProcDate) + User.HS.MRProcedures(PROCTimeStart)
Property ProcedureTime As HS.SDA3.TimeStamp;

/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: User.HS.MRProcedures(PROCUserDR)
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// HL7ToSDA3:<br>
/// MSH-4.1 is parsed to the EnteredAt Code. HL7ToSDA3 does not set the<br>
/// Description.<br><br>
/// HL7:  MSH-4.1 : SendingFacility.NamespaceID<br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.MRProcedures(PROCUpdateHospitalDR)
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// VIEWERLIB: User.HS.MRProcedures(PROCDate) + User.HS.MRProcedures(PROCTime)
Property EnteredOn As HS.SDA3.TimeStamp;

/// HL7:  PR1-19.1 : ProcedureIdentifier.EntityIdentifier<br>
/// VIEWERLIB: User.HS.MRProcedures(PROCExternalId)
Property ExternalId As %String(MAXLEN = 220);

/// Supported values:<br>
/// D = Delete<br>
/// C = Clear/Delete All<br>
/// Any other value = Add or Update<br>
/// See the annotation on the superclass property for more information on how<br>
/// ActionCode is used.<br><br>
/// HL7:  PR1-20 : ProcedureActionCode<br>
/// VIEWERLIB: Not stored
Property ActionCode As %String;

/// Not used.
Property ActionScope As %String;

/// The priority of the procedure<br>
/// The value 1 means that this is the primary procedure. Values 2-99 convey ranked secondary procedures.<br><br>
/// HL7:  PR1-14 : ProcedurePriority<br>
/// VIEWERLIB: Not stored
Property ProcedurePriority As %String;

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
<Value>Procedure</Value>
</Value>
<Value name="9">
<Value>Clinician</Value>
</Value>
<Value name="10">
<Value>ProcedureTime</Value>
</Value>
<Value name="11">
<Value>FromTime</Value>
</Value>
<Value name="12">
<Value>ToTime</Value>
</Value>
<Value name="13">
<Value>Deleted</Value>
</Value>
<Value name="14">
<Value>UpdatedOn</Value>
</Value>
<Value name="15">
<Value>CustomPairs</Value>
</Value>
<Value name="16">
<Value>Extension</Value>
</Value>
<Value name="17">
<Value>Devices</Value>
</Value>
<Value name="18">
<Value>ProcedurePriority</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
