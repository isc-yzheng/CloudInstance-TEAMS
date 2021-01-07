/// Specimen appears in the SDA as a list property of the LabOrder, RadOrder,<br>
/// and OtherOrder HS.SDA3 classes. Specimens (the list of HS.SDA3.Specimen)<br>
/// should not be confused with the Specimen property of every Order class,<br>
/// which is a string.<br><br>
/// HS.SDA3.Specimen is not loaded into the Viewer Cache, however the<br>
/// DisplaySpecimens method of web.SDA3.Order can be invoked to write out in an<br>
/// HTML textarea the details of all the HS.SDA3.Specimens linked to an order.<br>
/// As this method is intended to be invoked from the Clinical Viewer, it takes<br>
/// as parameters the IDs of the Trak PAPerson and OEOrdItem objects (Patient<br>
/// and Order). In the default Clinical Viewer layout, it is invoked from the<br>
/// OEOrder.Lab component (Order Details screen) as a custom expression:<br>
/// <example>
/// do ##class(web.SDA3.Order).DisplaySpecimens($G(%request.Data("PatientID",1)),$G(%request.Data("OEORIROWID",1)))
/// </example>
/// Implementors of HealthShare are free to copy this method to a class of<br>
/// their own, make any changes needed, and customize their layout to call<br>
/// their custom method.
Class HS.SDA3.Specimen Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.SpecimenExtension;

Parameter ORDERITEMTYPE = "SPM";

/// HL7:  SPM-2 : SpecimenID<br>
/// VIEWERLIB: Not stored
Property ExternalId As %String(MAXLEN = 220);

/// Specimen Type<br><br>
/// HL7:  SPM-4 : SpecimenType<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  SPM-4.1 : SpecimenType.Identifier<br>
/// .Description<br>
/// HL7:  SPM-4.2 : SpecimenType.Text<br>
/// .SDACodingStandard<br>
/// HL7:  SPM-4.3 : SpecimenType.NameofCodingSysten<br>
/// .CodeSystemVersionId<br>
/// HL7:  SPM-4.7 : SpecimenType.CodingSystemVersionID<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// If subfield 4 or 5 is not null, then subfields 4, 5, 6, and 8 will be<br>
/// parsed into the Code, Description, CodeSystem, and CodeSystemVersionId,<br>
/// respectively, of a PriorCode in the list of PriorCodes.<br>
/// HL7:  SPM-4.4 : SpecimenType.AlternateIdentifier<br>
/// HL7:  SPM-4.5 : SpecimenType.AlternateText<br>
/// HL7:  SPM-4.6 : SpecimenType.NameofAlternateCodingSystem<br>
/// HL7:  SPM-4.8 : SpecimenType.AlternateCodingSystemVersionID
Property SpecimenType As HS.SDA3.CodeTableDetail.SpecimenType;

/// Specimen Type Modifiers<br><br>
/// HL7ToSDA3:<br>
/// SPM-5 is a repeating field. Each instance will be parsed as a<br>
/// SpecimenTypeModifier in the list.<br><br>
/// HL7:  SPM-5 : SpecimenTypeModifier<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  SPM-5.1 : SpecimenTypeModifier.Identifier<br>
/// .Description<br>
/// HL7:  SPM-5.2 : SpecimenTypeModifier.Text<br>
/// .SDACodingStandard<br>
/// HL7:  SPM-5.3 : SpecimenTypeModifier.NameofCodingSysten<br>
/// .CodeSystemVersionId<br>
/// HL7:  SPM-5.7 : SpecimenTypeModifier.CodingSystemVersionID<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// If subfield 4 or 5 is not null, then subfields 4, 5, 6, and 8 will be<br>
/// parsed into the Code, Description, CodeSystem, and CodeSystemVersionId,<br>
/// respectively, of a PriorCode in the list of PriorCodes.<br>
/// HL7:  SPM-5.4 : SpecimenTypeModifier.AlternateIdentifier<br>
/// HL7:  SPM-5.5 : SpecimenTypeModifier.AlternateText<br>
/// HL7:  SPM-5.6 : SpecimenTypeModifier.NameofAlternateCodingSystem<br>
/// HL7:  SPM-5.8 : SpecimenTypeModifier.AlternateCodingSystemVersionID
Property SpecimenTypeModifiers As list Of HS.SDA3.CodeTableDetail.SpecimenTypeModifier;

/// Specimen Additives<br><br>
/// HL7ToSDA3:<br>
/// SPM-6 is a repeating field. Each instance will be parsed as a<br>
/// SpecimenAdditive in the list.<br><br>
/// HL7:  SPM-6 : SpecimenAdditives<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  SPM-6.1 : SpecimenAdditives.Identifier<br>
/// .Description<br>
/// HL7:  SPM-6.2 : SpecimenAdditives.Text<br>
/// .SDACodingStandard<br>
/// HL7:  SPM-6.3 : SpecimenAdditives.NameofCodingSysten<br>
/// .CodeSystemVersionId<br>
/// HL7:  SPM-6.7 : SpecimenAdditives.CodingSystemVersionID<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// If subfield 4 or 5 is not null, then subfields 4, 5, 6, and 8 will be<br>
/// parsed into the Code, Description, CodeSystem, and CodeSystemVersionId,<br>
/// respectively, of a PriorCode in the list of PriorCodes.<br>
/// HL7:  SPM-6.4 : SpecimenAdditives.AlternateIdentifier<br>
/// HL7:  SPM-6.5 : SpecimenAdditives.AlternateText<br>
/// HL7:  SPM-6.6 : SpecimenAdditives.NameofAlternateCodingSystem<br>
/// HL7:  SPM-6.8 : SpecimenAdditives.AlternateCodingSystemVersionID
Property SpecimenAdditives As list Of HS.SDA3.CodeTableDetail.SpecimenAdditive;

/// Collection Method<br><br>
/// HL7:  SPM-7 : SpecimenCollectionMethod<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  SPM-7.1 : SpecimenCollectionMethod.Identifier<br>
/// .Description<br>
/// HL7:  SPM-7.2 : SpecimenCollectionMethod.Text<br>
/// .SDACodingStandard<br>
/// HL7:  SPM-7.3 : SpecimenCollectionMethod.NameofCodingSysten<br>
/// .CodeSystemVersionId<br>
/// HL7:  SPM-7.7 : SpecimenCollectionMethod.CodingSystemVersionID<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// If subfield 4 or 5 is not null, then subfields 4, 5, 6, and 8 will be<br>
/// parsed into the Code, Description, CodeSystem, and CodeSystemVersionId,<br>
/// respectively, of a PriorCode in the list of PriorCodes.<br>
/// HL7:  SPM-7.4 : SpecimenCollectionMethod.AlternateIdentifier<br>
/// HL7:  SPM-7.5 : SpecimenCollectionMethod.AlternateText<br>
/// HL7:  SPM-7.6 : SpecimenCollectionMethod.NameofAlternateCodingSystem<br>
/// HL7:  SPM-7.8 : SpecimenCollectionMethod.AlternateCodingSystemVersionID
Property CollectionMethod As HS.SDA3.CodeTableDetail.CollectionMethod;

/// Specimen Source Site<br><br>
/// HL7:  SPM-8 : SpecimenSourceSite<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  SPM-8.1 : SpecimenSourceSite.Identifier<br>
/// .Description<br>
/// HL7:  SPM-8.2 : SpecimenSourceSite.Text<br>
/// .SDACodingStandard<br>
/// HL7:  SPM-8.3 : SpecimenSourceSite.NameofCodingSysten<br>
/// .CodeSystemVersionId<br>
/// HL7:  SPM-8.7 : SpecimenSourceSite.CodingSystemVersionID<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// If subfield 4 or 5 is not null, then subfields 4, 5, 6, and 8 will be<br>
/// parsed into the Code, Description, CodeSystem, and CodeSystemVersionId,<br>
/// respectively, of a PriorCode in the list of PriorCodes.<br>
/// HL7:  SPM-8.4 : SpecimenCollectionMethod.AlternateIdentifier<br>
/// HL7:  SPM-8.5 : SpecimenCollectionMethod.AlternateText<br>
/// HL7:  SPM-8.6 : SpecimenCollectionMethod.NameofAlternateCodingSystem<br>
/// HL7:  SPM-8.8 : SpecimenCollectionMethod.AlternateCodingSystemVersionID
Property SpecimenSourceSite As HS.SDA3.CodeTableDetail.SpecimenSourceSite;

/// Specimen Source Site Modifier<br><br>
/// HL7ToSDA3:<br>
/// SPM-9 is a repeating field. Each instance will be parsed as a<br>
/// SpecimenSourceSiteModifier in the list.<br><br>
/// HL7:  SPM-9 : SpecimenSourceSiteModifier<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  SPM-9.1 : SpecimenSourceSiteModifier.Identifier<br>
/// .Description<br>
/// HL7:  SPM-9.2 : SpecimenSourceSiteModifier.Text<br>
/// .SDACodingStandard<br>
/// HL7:  SPM-9.3 : SpecimenSourceSiteModifier.NameofCodingSysten<br>
/// .CodeSystemVersionId<br>
/// HL7:  SPM-9.7 : SpecimenSourceSiteModifier.CodingSystemVersionID<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// If subfield 4 or 5 is not null, then subfields 4, 5, 6, and 8 will be<br>
/// parsed into the Code, Description, CodeSystem, and CodeSystemVersionId,<br>
/// respectively, of a PriorCode in the list of PriorCodes.<br>
/// HL7:  SPM-9.4 : SpecimenSourceSiteModifier.AlternateIdentifier<br>
/// HL7:  SPM-9.5 : SpecimenSourceSiteModifier.AlternateText<br>
/// HL7:  SPM-9.6 : SpecimenSourceSiteModifier.NameofAlternateCodingSystem<br>
/// HL7:  SPM-9.8 : SpecimenSourceSiteModifier.AlternateCodingSystemVersionID
Property SpecimenSourceSiteModifiers As list Of HS.SDA3.CodeTableDetail.SpecimenSourceSiteModifier;

/// Specimen Role<br>
/// HL7ToSDA3:<br>
/// SPM-11 is a repeating field. Each instance will be parsed as a<br>
/// SpecimenRole in the list.<br><br>
/// HL7:  SPM-11 : SpecimenRole<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  SPM-11.1 : SpecimenRole.Identifier<br>
/// .Description<br>
/// HL7:  SPM-11.2 : SpecimenRole.Text<br>
/// .SDACodingStandard<br>
/// HL7:  SPM-11.3 : SpecimenRole.NameofCodingSysten<br>
/// .CodeSystemVersionId<br>
/// HL7:  SPM-11.7 : SpecimenRole.CodingSystemVersionID<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// If subfield 4 or 5 is not null, then subfields 4, 5, 6, and 8 will be<br>
/// parsed into the Code, Description, CodeSystem, and CodeSystemVersionId,<br>
/// respectively, of a PriorCode in the list of PriorCodes.<br>
/// HL7:  SPM-11.4 : SpecimenRole.AlternateIdentifier<br>
/// HL7:  SPM-11.5 : SpecimenRole.AlternateText<br>
/// HL7:  SPM-11.6 : SpecimenRole.NameofAlternateCodingSystem<br>
/// HL7:  SPM-11.8 : SpecimenRole.AlternateCodingSystemVersionID
Property SpecimenRoles As list Of HS.SDA3.CodeTableDetail.SpecimenRole;

/// Specimen Collection Amount<br><br>
/// HL7:  SPM-12.1 : SpecimenCollectionAmount.Quantity<br>
/// VIEWERLIB: Not stored
Property CollectionAmount As %String(MAXLEN = 999);

/// Specimen Collection Amount<br><br>
/// HL7:  SPM-12.2 : SpecimenCollectionAmount.Units<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  SPM-12.2.1 : SpecimenCollectionAmount.Units.Identifier<br>
/// .Description<br>
/// HL7:  SPM-12.2.2 : SpecimenCollectionAmount.Units.Text<br>
/// .SDACodingStandard<br>
/// HL7:  SPM-12.2.3 : SpecimenCollectionAmount.Units.NameofCodingSysten<br>
/// .CodeSystemVersionId<br>
/// HL7:  SPM-12.2.7 : SpecimenCollectionAmount.Units.CodingSystemVersionID<br>
Property CollectionAmountUnits As HS.SDA3.CodeTableDetail.UoM;

/// Start of the time range over which the sample was collected, as opposed to<br>
/// the time the sample collection device was recovered. A minimum of year,<br>
/// month, and day should be provided when the actual date/time is known.<br><br>
/// HL7ToSDA3:<br>
/// OBR-7.1 and SPM-17.1 represent the same value and therefore should contain<br>
/// the same value if both are present, however HealthShare does not enforce<br>
/// this. OBR-7.1 is parsed to Order.SpecimenCollectedTime. For OBXs reporting<br>
/// observations based on this specimen, OBX-14 should contain the same value<br>
/// as SPM-17.1, but again, this is not enforced. (Field 14 is not parsed from<br>
/// OBXs following the SPM.)<br><br>
/// HL7:  SPM-17.1 : SpecimenCollectionDateTime.RangeStartDateTime<br>
/// VIEWERLIB: Not stored
Property FromTime As HS.SDA3.TimeStamp;

/// End of the time range over which the sample was collected<br><br>
/// HL7ToSDA3:<br>
/// OBR-8.1 and SPM-17.2 represent the same value and therefore should contain<br>
/// the same value if both are present, however HealthShare does not enforce<br>
/// this. Currently OBR-8 is not parsed to the SDA.<br><br>
/// HL7:  SPM-17.2 : SpecimenCollectionDateTime.RangeEndDateTime<br>
/// VIEWERLIB: Not stored
Property ToTime As HS.SDA3.TimeStamp;

/// Time the specimen was received at the diagnostic service. The actual time<br>
/// that is recorded is based on how specimen receipt is managed, and may<br>
/// correspond to the time the sample is logged in.<br><br>
/// HL7:  SPM-18 : SpecimenReceivedDateTime<br>
/// VIEWERLIB: Not stored
Property EnteredOn As HS.SDA3.TimeStamp;

/// Specimen Reject Reason<br><br>
/// HL7ToSDA3:<br>
/// SPM-21 is a repeating field. Each instance will be parsed as a<br>
/// SpecimenRejectReason in the list.<br><br>
/// HL7:  SPM-21 : SpecimenRejectReason<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  SPM-21.1 : SpecimenRejectReason.Identifier<br>
/// .Description<br>
/// HL7:  SPM-21.2 : SpecimenRejectReason.Text<br>
/// .SDACodingStandard<br>
/// HL7:  SPM-21.3 : SpecimenRejectReason.NameofCodingSysten<br>
/// .CodeSystemVersionId<br>
/// HL7:  SPM-21.7 : SpecimenRejectReason.CodingSystemVersionID<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// If subfield 4 or 5 is not null, then subfields 4, 5, 6, and 8 will be<br>
/// parsed into the Code, Description, CodeSystem, and CodeSystemVersionId,<br>
/// respectively, of a PriorCode in the list of PriorCodes.<br>
/// HL7:  SPM-21.4 : SpecimenRejectReason.AlternateIdentifier<br>
/// HL7:  SPM-21.5 : SpecimenRejectReason.AlternateText<br>
/// HL7:  SPM-21.6 : SpecimenRejectReason.NameofAlternateCodingSystem<br>
/// HL7:  SPM-21.8 : SpecimenRejectReason.AlternateCodingSystemVersionID<br>
/// .OriginalText<br>
/// HL7:  SPM-21.9 : SpecimenRejectReason.OriginalText<br>
Property RejectReasons As list Of HS.SDA3.CodeTableDetail.SpecimenRejectReason;

/// Specimen Quality<br><br>
/// HL7:  SPM-22 : SpecimenQuality<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  SPM-22.1 : SpecimenQuality.Identifier<br>
/// .Description<br>
/// HL7:  SPM-22.2 : SpecimenQuality.Text<br>
/// .SDACodingStandard<br>
/// HL7:  SPM-22.3 : SpecimenQuality.NameofCodingSysten<br>
/// .CodeSystemVersionId<br>
/// HL7:  SPM-22.7 : SpecimenQuality.CodingSystemVersionID<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// If subfield 4 or 5 is not null, then subfields 4, 5, 6, and 8 will be<br>
/// parsed into the Code, Description, CodeSystem, and CodeSystemVersionId,<br>
/// respectively, of a PriorCode in the list of PriorCodes.<br>
/// HL7:  SPM-22.4 : SpecimenQuality.AlternateIdentifier<br>
/// HL7:  SPM-22.5 : SpecimenQuality.AlternateText<br>
/// HL7:  SPM-22.6 : SpecimenQuality.NameofAlternateCodingSystem<br>
/// HL7:  SPM-22.8 : SpecimenQuality.AlternateCodingSystemVersionID<br>
/// .OriginalText<br>
/// HL7:  SPM-22.9 : SpecimenQuality.OriginalText
Property Quality As HS.SDA3.CodeTableDetail.SpecimenQuality;

/// Specimen Appropriateness<br><br>
/// HL7:  SPM-23 : SpecimenAppropriateness<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  SPM-23.1 : SpecimenAppropriateness.Identifier<br>
/// .Description<br>
/// HL7:  SPM-23.2 : SpecimenAppropriateness.Text<br>
/// .SDACodingStandard<br>
/// HL7:  SPM-23.3 : SpecimenAppropriateness.NameofCodingSysten<br>
/// .CodeSystemVersionId<br>
/// HL7:  SPM-23.7 : SpecimenAppropriateness.CodingSystemVersionID<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// If subfield 4 or 5 is not null, then subfields 4, 5, 6, and 8 will be<br>
/// parsed into the Code, Description, CodeSystem, and CodeSystemVersionId,<br>
/// respectively, of a PriorCode in the list of PriorCodes.<br>
/// HL7:  SPM-23.4 : SpecimenAppropriateness.AlternateIdentifier<br>
/// HL7:  SPM-23.5 : SpecimenAppropriateness.AlternateText<br>
/// HL7:  SPM-23.6 : SpecimenAppropriateness.NameofAlternateCodingSystem<br>
/// HL7:  SPM-23.8 : SpecimenAppropriateness.AlternateCodingSystemVersionID<br>
/// .OriginalText<br>
/// HL7:  SPM-23.9 : SpecimenAppropriateness.OriginalText
Property Appropriateness As HS.SDA3.CodeTableDetail.SpecimenAppropriateness;

/// Specimen Condition<br><br>
/// HL7ToSDA3:<br>
/// SPM-24 is a repeating field. Each instance will be parsed as a<br>
/// SpecimenCondition in the list.<br><br>
/// HL7:  SPM-24 : SpecimenCondition<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  SPM-24.1 : SpecimenCondition.Identifier<br>
/// .Description<br>
/// HL7:  SPM-24.2 : SpecimenCondition.Text<br>
/// .SDACodingStandard<br>
/// HL7:  SPM-24.3 : SpecimenCondition.NameofCodingSysten<br>
/// .CodeSystemVersionId<br>
/// HL7:  SPM-24.7 : SpecimenCondition.CodingSystemVersionID<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// If subfield 4 or 5 is not null, then subfields 4, 5, 6, and 8 will be<br>
/// parsed into the Code, Description, CodeSystem, and CodeSystemVersionId,<br>
/// respectively, of a PriorCode in the list of PriorCodes.<br>
/// HL7:  SPM-24.4 : SpecimenCondition.AlternateIdentifier<br>
/// HL7:  SPM-24.5 : SpecimenCondition.AlternateText<br>
/// HL7:  SPM-24.6 : SpecimenCondition.NameofAlternateCodingSystem<br>
/// HL7:  SPM-24.8 : SpecimenCondition.AlternateCodingSystemVersionID<br>
/// .OriginalText<br>
/// HL7:  SPM-24.9 : SpecimenCondition.OriginalText<br>
Property Condition As list Of HS.SDA3.CodeTableDetail.SpecimenCondition;

/// Specimen Age<br><br>
/// HL7ToSDA3:<br>
/// If there is an OBX segment immediately following the SPM, it will be parsed<br>
/// to the Age and AgeUnits of the Specimen. Though the OBX following the SPM<br>
/// is repeating, only one OBX per SPM will be parsed this way.<br><br>
/// HL7:  OBX-5 : ObservationValue<br>
/// VIEWERLIB: Not stored
Property Age As %String(MAXLEN = 999);

/// Specimen Age Units<br><br>
/// HL7ToSDA3:<br>
/// If there is an OBX segment immediately following the SPM, it will be parsed<br>
/// to the Age and AgeUnits of the Specimen. Though the OBX following the SPM<br>
/// is repeating, only one OBX per SPM will be parsed this way.<br><br>
/// HL7:  OBX-6 : Units<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  OBX-6.1 : Units.Identifier<br>
/// .Description<br>
/// HL7:  OBX-6.2 : Units.Text<br>
/// .SDACodingStandard<br>
/// HL7:  OBX-6.3 : Units.NameofCodingSysten<br>
/// .CodeSystemVersionId<br>
/// HL7:  OBX-6.7 : Units.CodingSystemVersionID<br>
Property AgeUnits As HS.SDA3.CodeTableDetail.UoM;

/// Unlike other SDA types, the ActionCode for Specimen is not functional.<br>
/// There are no restrictions on the values it can contain, and setting it does<br>
/// not do anything to the Specimen.<br><br>
/// HL7ToSDA3:<br>
/// Note that in an ORU message, there can be multiple SPM segments per OBR. In<br>
/// this case, the Specimen parsed from each SPM gets its ActionCode from<br>
/// the preceding OBR-11.<br><br>
/// HL7:  OBR-11 : SpecimenActionCode<br>
/// VIEWERLIB: Not stored
Property ActionCode As %String;

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
<Value>CustomPairs</Value>
</Value>
<Value name="13">
<Value>SpecimenType</Value>
</Value>
<Value name="14">
<Value>SpecimenTypeModifiers</Value>
</Value>
<Value name="15">
<Value>SpecimenAdditives</Value>
</Value>
<Value name="16">
<Value>CollectionMethod</Value>
</Value>
<Value name="17">
<Value>SpecimenSourceSite</Value>
</Value>
<Value name="18">
<Value>SpecimenSourceSiteModifiers</Value>
</Value>
<Value name="19">
<Value>SpecimenRoles</Value>
</Value>
<Value name="20">
<Value>CollectionAmount</Value>
</Value>
<Value name="21">
<Value>CollectionAmountUnits</Value>
</Value>
<Value name="22">
<Value>Age</Value>
</Value>
<Value name="23">
<Value>AgeUnits</Value>
</Value>
<Value name="24">
<Value>RejectReason</Value>
</Value>
<Value name="25">
<Value>Quality</Value>
</Value>
<Value name="26">
<Value>Appropriateness</Value>
</Value>
<Value name="27">
<Value>Condition</Value>
</Value>
<Value name="28">
<Value>RejectReasons</Value>
</Value>
<Value name="29">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
