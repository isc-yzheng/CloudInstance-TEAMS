Class HS.SDA3.AbstractMedication Extends HS.SDA3.AbstractOrder
{

/// What was dispensed - commercial product name<br><br>
/// HL7ToSDA3:<br>
/// RXO, RXA, and RXE segments are all mutually exclusive among the message<br>
/// types and segments that HealthShare supports, so there is no need to define<br>
/// precedence between segments, though RXO-6 does take precedence over RXO-1.<br>
/// For both RXO-1 and RXE-2, the field will only be parsed if subfield 1 or 2<br>
/// is not null. Though RXO-6 is a repeating field, only the first non-null<br>
/// instance will be parsed.<br><br>
/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the Streamlet class, if the Order has no<br>
/// OrderItem but does have a DrugProduct, then a new OrderItem will be<br>
/// defaulted in with Code, Description, and SDACodingStandard copied from the<br>
/// DrugProduct.<br><br>
/// Viewer cache:<br>
/// The OEOrdItem (Order) in the Viewer Cache references an ARCItmMast (Order<br>
/// Item) via OEORIItmMastDR, which references a PHCDrgForm via ARCIMPHCDFDR,<br>
/// which references a PHCDrgMast (Drug Product) via PHCDFPHCDParRef.<br>
/// PHCDrgForm is a child of PHCDrgMast, and a PHCDrgMast may have more than<br>
/// one linked PHCDrgForm. When a DrugProduct is loaded into the Viewer Cache,<br>
/// it is matched to a PHCDrgMast based on Code, Description, and<br>
/// SDACodingStandard. Then, the existing child PHCDrgForms of that PHCDrgMast<br>
/// are examined to find one that matches the DrugProduct on Form, BaseQty,<br>
/// BaseUnits, Strength, StrengthQty, and StrengthUnits. Form, BaseQty,<br>
/// BaseUnits, and Strength are stored as properties of the PHCDrgForm.<br>
/// StrengthQty and StrengthUnits are stored as properties of a<br>
/// PHCFormDoseEquiv, which is a child of PHCDrgForm, though in the Viewer<br>
/// Cache a PHCDrgForm should only ever have one child PHCFormDoseEquiv. If no<br>
/// matching child PHCDrgForm can be found, a new one is created (along with a<br>
/// child PHCFormDoseEquiv) from the properties of the DrugProduct. Once a<br>
/// matching PHCDrgForm is found or a new one created, an attempt is made to<br>
/// link the ARCItmMast to it by setting the ARCIMPHCDFDR property of the<br>
/// ARCItmMast. If this fails for any reason (for example, if the ARCIMPHCDFDR<br>
/// property already references a different PHCDrgForm), then a new ARCItmMast<br>
/// will be created with the original OrderCategory of the Order, the<br>
/// SDACodingStandard of the DrugProduct, and Code and Description (referencing<br>
/// properties of the DrugProduct):<br>
/// "[Description]([Form.Code]:[BaseQty] [BaseUnits.Description]:[StrengthQty] [StrengthUnits.Description]:[Strength.Description])"<br>
/// Note that it is possible that such an ARCItmMast already exists in the<br>
/// Viewer Cache, in which case the "new" ARCItmMast will simply match the<br>
/// existing one. Finally, an attempt is made to link the new ARCItmMast to the<br>
/// new or matched PHCDrgForm. If this fails for any reason (for example, the<br>
/// "new" ARCItmMast was not new and was already linked to a different<br>
/// PHCDrgForm), then an error will be logged and the Order will not be stored<br>
/// in the Viewer Cache.<br><br>
/// HL7:  RXO-1 : RequestedGiveCode<br>
/// HL7:  RXO-6 : ProvidersPharmacyTreatmentInstructions<br>
/// HL7:  RXA-5 : AdministeredCode<br>
/// HL7:  RXE-2 : GiveCode<br>
/// SDATableName=DrugProduct, ViewerClass=User.HS.PHCDrgMast<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIItmMastDR)<br><br>
/// .Code<br>
/// HL7:  RXO-1.1 : RequestedGiveCode.Identifier<br>
/// HL7:  RXO-6.1 : ProvidersPharmacyTreatmentInstructions.Identifier<br>
/// HL7:  RXA-5.1 : AdministeredCode.Identifier<br>
/// HL7:  RXE-2.1 : GiveCode.Identifier<br>
/// VIEWERLIB: User.HS.PHCDrgMast(PHCDCode)<br>
/// .Description<br>
/// HL7:  RXO-1.2 : RequestedGiveCode.Text<br>
/// HL7:  RXO-6.2 : ProvidersPharmacyTreatmentInstructions.Text<br>
/// HL7:  RXA-5.2 : AdministeredCode.Text<br>
/// HL7:  RXE-2.2 : GiveCode.Text<br>
/// VIEWERLIB: User.HS.PHCDrgMast(PHCDName)<br>
/// .SDACodingStandard<br>
/// HL7:  RXO-1.3 : RequestedGiveCode.NameofCodingSystem<br>
/// HL7:  RXO-6.3 : ProvidersPharmacyTreatmentInstructions.NameofCodingSystem<br>
/// HL7:  RXA-5.3 : AdministeredCode.NameofCodingSystem<br>
/// HL7:  RXE-2.3 : GiveCode.NameofCodingSystem<br>
/// VIEWERLIB: Not stored<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// For each field, the logic to parse PriorCodes is the same: if subfield 4 or<br>
/// 5 is not null, then subfields 4, 5, and 6 will be parsed into the Code,<br>
/// Description, and CodeSystem, respectively, of a PriorCode in the list of<br>
/// PriorCodes. In this case, the PriorCode Type is set to "A". Note that for<br>
/// RXO-1 and RXE-2, subfield 1 or 2 must still be non-null for anything in the<br>
/// field to be parsed.<br>
/// HL7:  RXO-1.4 : RequestedGiveCode.AlternateIdentifier<br>
/// HL7:  RXO-1.5 : RequestedGiveCode.AlternateText<br>
/// HL7:  RXO-1.6 : RequestedGiveCode.NameofAlternateCodingSystem<br>
/// HL7:  RXO-6.4 : ProvidersPharmacyTreatmentInstructions.AlternateIdentifier<br>
/// HL7:  RXO-6.5 : ProvidersPharmacyTreatmentInstructions.AlternateText<br>
/// HL7:  RXO-6.6 : ProvidersPharmacyTreatmentInstructions.NameofAlternateCodingSystem<br>
/// HL7:  RXA-5.4 : AdministeredCode.AlternateIdentifier<br>
/// HL7:  RXA-5.5 : AdministeredCode.AlternateText<br>
/// HL7:  RXA-5.6 : AdministeredCode.NameofAlternateCodingSystem<br>
/// HL7:  RXE-2.4 : GiveCode.AlternateIdentifier<br>
/// HL7:  RXE-2.5 : GiveCode.AlternateText<br>
/// HL7:  RXE-2.6 : GiveCode.NameofAlternateCodingSystem<br>
/// VIEWERLIB: Not stored<br>
/// .OriginalText<br>
/// HL7:  RXO-1.9 : RequestedGiveCode.OriginalText<br>
/// HL7:  RXO-6.9 : ProvidersPharmacyTreatmentInstructions.OriginalText<br>
/// HL7:  RXA-5.9 : AdministeredCode.OriginalText<br>
/// HL7:  RXE-2.9 : GiveCode.OriginalText<br>
/// VIEWERLIB: Not stored
Property DrugProduct As HS.SDA3.CodeTableDetail.DrugProduct;

/// Strength volume (e.g. the "10" in 2mg/10ml)<br><br>
/// HL7ToSDA3:<br>
/// RXO, RXA, and RXE segments are all mutually exclusive among the message<br>
/// types and segments that HealthShare supports, so there is no need to define<br>
/// precedence between segments.<br><br>
/// HL7:  RXO-25 : RequestedDrugStrengthVolume<br>
/// HL7:  RXA-23 : AdministeredDrugStrengthVolume<br>
/// HL7:  RXE-33 : GiveDrugStrengthVolume<br>
/// VIEWERLIB: Not stored
Property StrengthVolume As HS.SDA3.Numeric;

/// Units for StrengthVolume (e.g. ml)<br><br>
/// HL7ToSDA3:<br>
/// RXO, RXA, and RXE segments are all mutually exclusive among the message<br>
/// types and segments that HealthShare supports, so there is no need to define<br>
/// precedence between segments. Each of these fields is coded, and the logic<br>
/// to parse each is the same: if subfield 2 is not null, parse that to<br>
/// StrengthVolumeUnits, else parse subfield 1.<br><br>
/// HL7:  RXO-26 : RequestedDrugStrengthVolumeUnits<br>
/// HL7:  RXA-24 : AdministeredDrugStrengthUnits<br>
/// HL7:  RXE-34 : GiveDrugStrengthVolumeUnits<br>
/// VIEWERLIB: Not stored
Property StrengthVolumeUnits As %String;

/// Rate (e.g. the 100 in 100 ml/hour)<br><br>
/// HL7ToSDA3:<br>
/// RXO and RXE segments are mutually exclusive among the message types and<br>
/// segments that HealthShare supports, so there is no need to define<br>
/// precedence between them.<br><br>
/// HL7:  RXO-21 : RequestedGiveRateAmount<br>
/// HL7:  RXE-23 : GiveRateAmount<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORISpeedFlowRate)
Property RateAmount As HS.SDA3.Numeric;

/// Units for Rate (e.g. the ml in 100 ml/hour)<br><br>
/// HL7ToSDA3:<br>
/// RXO, RXA, and RXE segments are all mutually exclusive among the message<br>
/// types and segments that HealthShare supports, so there is no need to define<br>
/// precedence between segments. Each of these fields is coded and will only be<br>
/// parsed if subfield 1 or 2 is not null.<br><br>
/// HL7:  RXO-22 : RequestedGiveRateUnits<br>
/// HL7:  RXE-24 : GiveRateUnits<br>
/// SDATableName=RateUnits, ViewerClass=User.HS.OECSpeedFlowRate<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIFlowRateUnitDR)<br><br>
/// .Code<br>
/// HL7:  RXO-22.1 : RequestedGiveRateUnits.Identifier<br>
/// HL7:  RXE-24.1 : GiveRateUnits.Identifier<br>
/// VIEWERLIB: User.HS.OECSpeedFlowRate(SFRCode)<br>
/// .Description<br>
/// HL7:  RXO-22.2 : RequestedGiveRateUnits.Text<br>
/// HL7:  RXE-24.2 : GiveRateUnits.Text<br>
/// VIEWERLIB: User.HS.OECSpeedFlowRate(SFRDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  RXO-22.3 : RequestedGiveRateUnits.NameofCodingSystem<br>
/// HL7:  RXE-24.3 : GiveRateUnits.NameofCodingSystem<br>
/// VIEWERLIB: Not stored
Property RateUnits As HS.SDA3.CodeTableDetail.RateUnits;

/// Time units (e.g. per hour, as in 100 ml per hour)<br><br>
/// HL7ToSDA3:<br>
/// RXO, RXA, and RXE segments are all mutually exclusive among the message<br>
/// types and segments that HealthShare supports, so there is no need to define<br>
/// precedence between segments.<br><br>
/// HL7:  RXO-17 : RequestedGivePerTimeUnit<br>
/// HL7:  RXA-12 : AdministeredPerTimeUnit<br>
/// HL7:  RXE-22 : GivePerTimeUnit<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIUnitHrs)
Property RateTimeUnit As %String;

/// Size of dose (e.g. the 20 in 20mg).<br><br>
/// HL7ToSDA3:<br>
/// RXO, RXA, and RXE segments are all mutually exclusive among the message<br>
/// types and segments that HealthShare supports, so there is no need to define<br>
/// precedence between segments, however RXO-18 takes precedence over RXO-2,<br>
/// and RXE-25 takes precendence over RXE-3.<br><br>
/// Viewer cache:<br>
/// If the Order contains at least 1 DosageStep in the DosageSteps property,<br>
/// and if the first DosageStep in that list has a DoseQuantity, then that<br>
/// DoseQuantity will override this one in the Viewer Cache.<br><br>
/// HL7:  RXO-2 : RequestedGiveAmountMinimum<br>
/// HL7:  RXO-18 : RequestedGiveStrength<br>
/// HL7:  RXA-13 : AdministeredStrength<br>
/// HL7:  RXE-3 : GiveAmountMinimum<br>
/// HL7:  RXE-25 : GiveStrength<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIDoseQty)
Property DoseQuantity As HS.SDA3.Numeric;

/// Units for DoseQuantity (e.g. the mg in 20mg)<br><br>
/// HL7ToSDA3:<br>
/// RXO and RXE segments are mutually exclusive among the message types and<br>
/// segments that HealthShare supports, so there is no need to define<br>
/// precedence between them, however RXO-19 takes precedence over RXO-4, and<br>
/// RXE-26 takes precedence over RXE-5. Each of the HL7 fields is coded, and<br>
/// each one will only be parsed if subfield 1 or 2 is not null.<br><br>
/// Viewer cache:<br>
/// If the Order contains at least 1 DosageStep in the DosageSteps property,<br>
/// and if the first DosageStep in that list has a DoseUoM, then that DoseUoM<br>
/// will override this one in the Viewer Cache.<br><br>
/// HL7:  RXO-4 : RequestedGiveUnits<br>
/// HL7:  RXO-19 : RequestedGiveStrengthUnits<br>
/// HL7:  RXE-5 : GiveUnits<br>
/// HL7:  RXE-26 : GiveStrengthUnits<br>
/// HL7:  RXA-14 : AdministeredStrengthUnits<br>
/// SDATableName=UoM, ViewerClass=User.HS.CTUOM<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIUnitDR)<br><br>
/// .Code<br>
/// HL7:  RXO-4.1 : RequestedGiveUnits.Identifier<br>
/// HL7:  RXO-19.1 : RequestedGiveStrengthUnits.Identifier<br>
/// HL7:  RXE-5.1 : GiveUnits.Identifier<br>
/// HL7:  RXE-26.1 : GiveStrengthUnits.Identifier<br>
/// HL7:  RXA-14.1 : AdministeredStrengthUnits.Identifier<br>
/// VIEWERLIB: User.HS.CTUOM(CTUOMCode)<br>
/// .Description<br>
/// HL7:  RXO-4.2 : RequestedGiveUnits.Text<br>
/// HL7:  RXO-19.2 : RequestedGiveStrengthUnits.Text<br>
/// HL7:  RXE-5.2 : GiveUnits.Text<br>
/// HL7:  RXE-26.2 : GiveStrengthUnits.Text<br>
/// HL7:  RXA-14.2 : AdministeredStrengthUnits.Text<br>
/// VIEWERLIB: User.HS.CTUOM(CTUOMDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  RXO-4.3 : RequestedGiveUnits.NameofCodingSystem<br>
/// HL7:  RXO-19.3 : RequestedGiveStrengthUnits.NameofCodingSystem<br>
/// HL7:  RXE-5.3 : GiveUnits.NameofCodingSystem<br>
/// HL7:  RXE-26.3 : GiveStrengthUnits.NameofCodingSystem<br>
/// HL7:  RXA-14.3 : AdministeredStrengthUnits.NameofCodingSystem<br>
/// VIEWERLIB: Not stored
Property DoseUoM As HS.SDA3.CodeTableDetail.UoM;

/// Maximum dose quantity<br><br>
/// HL7ToSDA3:<br>
/// RXO and RXE segments are mutually exclusive among the message types and<br>
/// segments that HealthShare supports, so there is no need to define<br>
/// precedence between them.<br><br>
/// HL7:  RXO-3 : RequestedGiveAmountMaximum<br>
/// HL7:  RXE-4 : GiveAmountMaximum<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIPRNTotNumberDosesAll)
Property MaxDoseQuantity As HS.SDA3.Numeric;

/// HL7ToSDA3:<br>
/// RXO and RXE segments are mutually exclusive among the message types and<br>
/// segments that HealthShare supports, so there is no need to define<br>
/// precedence between them.<br><br>
/// Viewer Cache:<br>
/// The type of OEORIMaxRepeats is "%Float", so NumberOfRefills will only be<br>
/// loaded into OEORIMaxRepeats if it is a valid number according to<br>
/// $IsValidNum(). In the Viewer, the column of an Order Profile (component<br>
/// OEOrdItem.ListEMR) that displays OEORIMaxNumberOfRepeats is called<br>
/// "Repeats" by default. The component name as it appears in the properties<br>
/// of the column in the Layout Editor is "MaxRep". The column that displays<br>
/// OEORIMaxRepeats is called "Repeat" by default, component name "Repeat".<br>
/// The value actually displayed depends on OEORIMaxRepeats and<br>
/// OEORICurrRepeatNumber (populated by the RefillNumber property in SDA):<br>
/// -If OEORIMaxRepeats is null, no value is displayed.<br>
/// -Else if "+[OEORICurrRepeatNumber]" is 0, OEORIMaxRepeats is displayed.<br>
/// -Else the value displayed is "[OEORICurrRepeatNumber] / [OEORIMaxRepeats]",
///  for example: "3 / 10".<br><br>
/// HL7:  RXO-13 : NumberOfRefills<br>
/// HL7:  RXE-12 : NumberOfRefills<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIMaxNumberOfRepeats)<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIMaxRepeats)
Property NumberOfRefills As %String;

/// Dosage Form (e.g. Tablet, Capsule, etc.)<br><br>
/// HL7ToSDA3:<br>
/// RXO, RXA, and RXE segments are all mutually exclusive among the message<br>
/// types and segments that HealthShare supports, so there is no need to define<br>
/// precedence between segments. Each of the HL7 fields is coded, and each one<br>
/// will only be parsed if subfield 1 or 2 is not null.<br><br>
/// HL7:  RXO-5 : RequestedDosageForm<br>
/// HL7:  RXA-8 : AdministeredDosageForm<br>
/// HL7:  RXE-6 : GiveDosageForm<br>
/// SDATableName=DosageForm, ViewerClass=User.HS.PHCDosage<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIDosageDR)<br><br>
/// .Code<br>
/// HL7:  RXO-5.1 : RequestedDosageForm.Identifier<br>
/// HL7:  RXA-8.1 : AdministeredDosageForm.Identifier<br>
/// HL7:  RXE-6.1 : GiveDosageForm.Identifier<br>
/// VIEWERLIB: User.HS.PHCDosage(PHCDOCode)<br>
/// .Description<br>
/// HL7:  RXO-5.2 : RequestedDosageForm.Text<br>
/// HL7:  RXA-8.2 : AdministeredDosageForm.Text<br>
/// HL7:  RXE-6.2 : GiveDosageForm.Text<br>
/// VIEWERLIB: User.HS.PHCDosage(PHCDODesc1)<br>
/// .SDACodingStandard<br>
/// HL7:  RXO-5.3 : RequestedDosageForm.NameofCodingSystem<br>
/// HL7:  RXA-8.3 : AdministeredDosageForm.NameofCodingSystem<br>
/// HL7:  RXE-6.3 : GiveDosageForm.NameofCodingSystem<br>
/// VIEWERLIB: Not stored
Property DosageForm As HS.SDA3.CodeTableDetail.DosageForm;

/// Instructions for administering drug (e.g. Oral)<br><br>
/// HL7ToSDA3:<br>
/// RXO is mutually exclusive to both RXE and RXR segments among the message<br>
/// types and segments that HealthShare supports, however an RDE_O11 message<br>
/// can contain both an RXE and an RXR segment. In this case, RXR-1 takes<br>
/// precedence over RXE-7. Note that though RXO-7 and RXE-7 are repeating<br>
/// fields, HL7ToSDA3 will only parse the first non-null instance of each.<br>
/// RXR-1 will only be parsed if subfield 1 or 2 is not null.<br><br>
/// HL7:  RXO-7 : ProvidersAdministrationInstructions<br>
/// HL7:  RXE-7 : ProvidersAdministrationInstructions<br>
/// HL7:  RXR-1 : Route<br>
/// SDATableName=Route, ViewerClass=User.HS.OECRoute<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIRouteDR)<br><br>
/// .Code<br>
/// HL7:  RXO-7.1 : ProvidersAdministrationInstructions.Identifier<br>
/// HL7:  RXE-7.1 : ProvidersAdministrationInstructions.Identifier<br>
/// HL7:  RXR-1.1 : Route.Identifier<br>
/// VIEWERLIB: User.HS.OECRoute(ROUTECode)<br>
/// .Description<br>
/// HL7:  RXO-7.2 : ProvidersAdministrationInstructions.Text<br>
/// HL7:  RXE-7.2 : ProvidersAdministrationInstructions.Text<br>
/// HL7:  RXR-1.2 : Route.Text<br>
/// VIEWERLIB: User.HS.OECRoute(ROUTEDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  RXO-7.3 : ProvidersAdministrationInstructions.NameofCodingSystem<br>
/// HL7:  RXE-7.3 : ProvidersAdministrationInstructions.NameofCodingSystem<br>
/// HL7:  RXR-1.3 : Route.NameofCodingSystem<br>
/// VIEWERLIB: Not stored
Property Route As HS.SDA3.CodeTableDetail.Route;

/// The condition or problem for which the drug/treatment was prescribed<br><br>
/// HL7ToSDA3:<br>
/// Each of the listed HL7 fields is coded and repeating. The logic to parse<br>
/// each is: only parse the first non-null instance, and within that instance,<br>
/// if subfield 2 is not null, parse the value from that, else parse the value<br>
/// from subfield 1.<br><br>
/// HL7:  RXO-20 : Indication<br>
/// HL7:  RXA-19 : Indication<br>
/// HL7:  RXE-27 : Indication<br>
/// VIEWERLIB: User.HS.OEOrdItem(ITM2Indication)
Property Indication As %String(MAXLEN = 512);

/// The status of this prescription<br>
/// For example, in Sweden, a prescription may go through up to 3 statuses: "O"<br>
/// for "Planned", "F" for "Prescribed", and "U" for "Refilled".<br><br>
/// Streamlet cache:<br>
/// For Medications only, if ActionCode="I" or "C" and ActionScope is one of<br>
/// "ADMISSION", "DISCHARGE", "ADMINISTERED", or "MEDICATIONS", case-<br>
/// insensitive, then only Medications with PharmacyStatus matching ActionScope<br>
/// (case-insensitive) will be affected.<br><br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIPharmacyStatus)<br>
Property PharmacyStatus As %String;

/// The number or ID assigned to the Prescription or Order<br><br>
/// HL7:  RXE-15 : PrescriptionNumber<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIPrescNo)
Property PrescriptionNumber As %String(MAXLEN = 220);

/// The current refill repeat number<br>
/// This could be a sequence number or a full ID for the last refill, if any.<br><br>
/// Viewer Cache:<br>
/// In the Viewer, the column of an Order Profile (component OEOrdItem.ListEMR)<br>
/// that displays OEORICurrRepeatNumber is called "Repeat" by default. The<br>
/// component name as it appears in the properties of the column in the Layout<br>
/// Editor is "Repeat". The value actually displayed depends on<br>
/// OEORICurrRepeatNumber and OEORIMaxRepeats (populated by the NumberOfRefills<br>
/// property in SDA, but only if it is a valid number according to<br>
/// $IsValidNum()):<br>
/// -If OEORIMaxRepeats is null, no value is displayed.<br>
/// -Else if "+[OEORICurrRepeatNumber]" is 0, OEORIMaxRepeats is displayed.<br>
/// -Else the value displayed is "[OEORICurrRepeatNumber] / [OEORIMaxRepeats]",
///  for example: "3 / 10".<br><br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORICurrRepeatNumber)<br>
Property RefillNumber As HS.SDA3.Numeric;

/// A description of when the order will be refilled<br><br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIRepeatDesc)
Property RefillDescription As %String(MAXLEN = 220);

/// Ordered Dosage Steps<br><br>
/// Viewer cache:<br>
/// Every DosageStep is stored in the Viewer Cache as a child OEOrdExec to the<br>
/// parent OEOrdItem. This list is cleared every time a Medication or<br>
/// Vaccination is updated, and the inbound DosageSteps are inserted. However,<br>
/// the first DosageStep in the list (assuming there is at least one) will also<br>
/// populate several properties of the parent OEOrdItem, overriding any values<br>
/// that came from the containing Medication or Vaccination. These properties<br>
/// include FromTime, ToTime, TextInstruction, Frequency, DoseQuantity,<br>
/// DoseUoM, and Duration.<br><br>
/// VIEWERLIB: see HS.SDA3.DosageStep<br>
Property DosageSteps As list Of HS.SDA3.DosageStep;

/// Administration History<br><br>
/// HL7ToSDA3:<br>
/// From HL7, at most one Administration can be parsed.<br><br>
/// HL7:  RXA,RXR<br>
/// VIEWERLIB: Not stored<br>
Property Administrations As list Of HS.SDA3.Administration;

/// The components of a compound medication<br><br>
/// HL7ToSDA3:<br>
/// RXC, as it appears in an RDE_O11 message, is a repeating segment. Each RXC<br>
/// will be parsed to one DrugProduct in the ComponentMeds list. RXC-2, -6, and<br>
/// -9 are all coded fields.  Each will only be parsed if subfield 1 or 2 is<br>
/// not null.<br><br>
/// Viewer Cache:<br>
/// Each DrugProduct in the list of ComponentMeds will be loaded into the<br>
/// Viewer Cache as an OEOrdItem that references the main Order/OEOrdItem via<br>
/// the OEORIOEORIDR property and is linked to the PHCDrgMast created from the<br>
/// DrugProduct. The only exception to this is ComponentMed DrugProducts with<br>
/// Code matching the Code of the main Order DrugProduct. These will not be<br>
/// processed into the Viewer Cache as they are considered redundant. For those<br>
/// ComponentMed DrugProducts that are processed into the Viewer Cache, the<br>
/// OEORIPlacerNo will be populated with the PlacerId of the parent Order,<br>
/// OEORILabEpisodeNo with the FillerId, and OEORIFillerNo with<br>
/// "[FillerId]&[sequential #]". The FromTime (OEORISttDat+OEORISttTim), ToTime<br>
/// (OEORIEndDate+OEORIEndTime), and Status (OEORIItemStatDR) are also copied<br>
/// from the main Order.<br><br>
/// HL7:  RXC-2 : ComponentCode<br>
/// HL7:  RXC-5 : ComponentStrength<br>
/// HL7:  RXC-6 : ComponentStrengthUnits<br>
/// HL7:  RXC-8 : ComponentDrugStrengthVolume<br>
/// HL7:  RXC-9 : ComponentDrugStrengthVolumeUnits<br>
/// VIEWERLIB: User.HS.OEOrdItem<br><br>
/// .Code<br>
/// HL7:  RXC-2.1 : ComponentCode.Identifier<br>
/// VIEWERLIB: User.HS.PHCDrgMast(PHCDCode)<br>
/// .Description<br>
/// HL7:  RXC-2.2 : ComponentCode.Text<br>
/// VIEWERLIB: User.HS.PHCDrgMast(PHCDName)<br>
/// .SDACodingStandard<br>
/// HL7:  RXC-2.3 : ComponentCode.NameofCodingSystem<br>
/// VIEWERLIB: Not stored<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// In addition to RXC-2.1 or .2 not being null, if subfield 4 or 5 is not<br>
/// null, then subfields 4, 5, and 6 will be parsed into the Code, Description,<br>
/// and CodeSystem, respectively, of a PriorCode in the list of PriorCodes. In<br>
/// this case, the PriorCode Type is set to "A".<br>
/// HL7:  RXC-2.4 : ComponentCode.AlternateIdentifier<br>
/// HL7:  RXC-2.5 : ComponentCode.AlternateText<br>
/// HL7:  RXC-2.6 : ComponentCode.NameofAlternateCodingSystem<br>
/// VIEWERLIB: Not stored<br>
/// .OriginalText<br>
/// HL7:  RXC-2.9 : ComponentCode.OriginalText<br>
/// VIEWERLIB: Not stored<br>
/// .StrengthQty<br>
/// HL7:  RXC-5 : ComponentStrength<br>
/// VIEWERLIB: User.HS.PHCFormDoseEquiv(EQQty)<br>
/// .StrengthUnits<br>
/// HL7:  RXC-6 : ComponentStrengthUnits<br>
/// SDATableName=UoM, ViewerClass=User.HS.CTUOM<br>
/// VIEWERLIB: User.HS.PHCFormDoseEquiv(EQCTUOMDR)<br>
/// .StrengthUnits.Code<br>
/// HL7:  RXC-6.1 : ComponentStrengthUnits.Identifier<br>
/// VIEWERLIB: User.HS.CTUOM(CTUOMCode)<br>
/// .StrengthUnits.Description<br>
/// HL7:  RXC-6.2 : ComponentStrengthUnits.Text<br>
/// VIEWERLIB: User.HS.CTUOM(CTUOMDesc)<br>
/// .StrengthUnits.SDACodingStandard<br>
/// HL7:  RXC-6.3 : ComponentStrengthUnits.NameofCodingSystem<br>
/// VIEWERLIB: Not stored<br>
/// .BaseQty<br>
/// HL7:  RXC-8 : ComponentDrugStrengthVolume<br>
/// VIEWERLIB: User.HS.PHCDrgForm(PHCDFBaseQty)<br>
/// .BaseUnits<br>
/// HL7:  RXC-9 : ComponentDrugStrengthVolumeUnits<br>
/// SDATableName=UoM, ViewerClass=User.HS.CTUOM<br>
/// VIEWERLIB: User.HS.PHCDrgForm(PHCDFCTUOMDR)<br>
/// .BaseUnits.Code<br>
/// HL7:  RXC-9.1 : ComponentDrugStrengthVolumeUnits.Identifier<br>
/// VIEWERLIB: User.HS.CTUOM(CTUOMCode)<br>
/// .BaseUnits.Description<br>
/// HL7:  RXC-9.2 : ComponentDrugStrengthVolumeUnits.Text<br>
/// VIEWERLIB: User.HS.CTUOM(CTUOMDesc)<br>
/// .BaseUnits.SDACodingStandard<br>
/// HL7:  RXC-9.3 : ComponentDrugStrengthVolumeUnits.NameofCodingSystem<br>
/// VIEWERLIB: Not stored<br>
Property ComponentMeds As list Of HS.SDA3.CodeTableDetail.DrugProduct;

/// Not used.
Property ResultCopiesTo As list Of HS.SDA3.CodeTableDetail.CareProvider;

/// Not used.
Property Specimen As %String(MAXLEN = 220);

/// Not used.
Property SpecimenCollectedTime As HS.SDA3.TimeStamp;

/// Not used.
Property SpecimenReceivedTime As HS.SDA3.TimeStamp;

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
<Value>PlacerId</Value>
</Value>
<Value name="9">
<Value>FillerId</Value>
</Value>
<Value name="10">
<Value>OrderItem</Value>
</Value>
<Value name="11">
<Value>OrderQuantity</Value>
</Value>
<Value name="12">
<Value>OrderedBy</Value>
</Value>
<Value name="13">
<Value>EnteringOrganization</Value>
</Value>
<Value name="14">
<Value>VerifiedBy</Value>
</Value>
<Value name="15">
<Value>CallbackNumber</Value>
</Value>
<Value name="16">
<Value>Specimen</Value>
</Value>
<Value name="17">
<Value>SpecimenCollectedTime</Value>
</Value>
<Value name="18">
<Value>SpecimenReceivedTime</Value>
</Value>
<Value name="19">
<Value>StartTime</Value>
</Value>
<Value name="20">
<Value>EndTime</Value>
</Value>
<Value name="21">
<Value>ReassessmentTime</Value>
</Value>
<Value name="22">
<Value>Frequency</Value>
</Value>
<Value name="23">
<Value>Duration</Value>
</Value>
<Value name="24">
<Value>Status</Value>
</Value>
<Value name="25">
<Value>Priority</Value>
</Value>
<Value name="26">
<Value>ConfidentialityCode</Value>
</Value>
<Value name="27">
<Value>Condition</Value>
</Value>
<Value name="28">
<Value>TextInstruction</Value>
</Value>
<Value name="29">
<Value>OrderGroup</Value>
</Value>
<Value name="30">
<Value>Comments</Value>
</Value>
<Value name="31">
<Value>ConsultationDepartment</Value>
</Value>
<Value name="32">
<Value>AuthorizationTime</Value>
</Value>
<Value name="33">
<Value>ReceivingLocation</Value>
</Value>
<Value name="34">
<Value>VerifiedComments</Value>
</Value>
<Value name="35">
<Value>ResultCopiesTo</Value>
</Value>
<Value name="36">
<Value>DrugProduct</Value>
</Value>
<Value name="37">
<Value>StrengthVolume</Value>
</Value>
<Value name="38">
<Value>StrengthVolumeUnits</Value>
</Value>
<Value name="39">
<Value>RateAmount</Value>
</Value>
<Value name="40">
<Value>RateUnits</Value>
</Value>
<Value name="41">
<Value>RateTimeUnit</Value>
</Value>
<Value name="42">
<Value>DoseQuantity</Value>
</Value>
<Value name="43">
<Value>MaxDoseQuantity</Value>
</Value>
<Value name="44">
<Value>NumberOfRefills</Value>
</Value>
<Value name="45">
<Value>DoseUoM</Value>
</Value>
<Value name="46">
<Value>DosageForm</Value>
</Value>
<Value name="47">
<Value>Route</Value>
</Value>
<Value name="48">
<Value>Indication</Value>
</Value>
<Value name="49">
<Value>PharmacyStatus</Value>
</Value>
<Value name="50">
<Value>PrescriptionNumber</Value>
</Value>
<Value name="51">
<Value>RefillNumber</Value>
</Value>
<Value name="52">
<Value>RefillDescription</Value>
</Value>
<Value name="53">
<Value>DosageSteps</Value>
</Value>
<Value name="54">
<Value>Administrations</Value>
</Value>
<Value name="55">
<Value>ComponentMeds</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
