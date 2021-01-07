Class HS.SDA3.AbstractResultOrder Extends HS.SDA3.AbstractOrder
{

/// VIEWERLIB: see HS.SDA3.Result<br>
Property Result As HS.SDA3.Result;

/// HL7:  SPM<br>
/// VIEWERLIB: Not stored
Property Specimens As list Of HS.SDA3.Specimen;

/// HL7:  OBR-13 : ReleventClinicalInformation<br>
/// VIEWERLIB: Not stored
Property ClinicalInformation As %String(MAXLEN = "");

/// If the Result in this Order is the child of an observation in another<br>
/// Order, this is a copy of the parent observation (as a LabTestItem). For<br>
/// example, the parent observation could be a bacterial culture identified in<br>
/// a specimen taken from the patient, and this order would contain the<br>
/// antibiotic susceptibilities of that culture.<br><br>
/// Viewer cache:<br>
/// For Orders with atomic Results only, if the ParentFillerId,<br>
/// ParentResultObservation.Code, and ParentResultObservationSubId are all<br>
/// non-null and identify a lab.HS.EPVisitTestSetData (LabResultItem) already<br>
/// in the Viewer Cache, that EPVisitTestSetData will be copied into the<br>
/// current EPVisitTestSet (Result). ParentResultObservation itself is not<br>
/// stored in the Viewer Cache.<br><br>
/// HL7:  OBR-26.1 : ParentResult.ParentObservationIdentifier<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  OBR-26.1.1 : ParentResult.ParentObservationIdentifier.Text<br>
/// .Description<br>
/// HL7:  OBR-26.1.2 : ParentResult.ParentObservationIdentifier.Identifier<br>
/// .SDACodingStandard<br>
/// HL7:  OBR-26.1.3 : ParentResult.ParentObservationIdentifier.NameofCodingSystem<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// If subfield 4 or 5 is not null, then subfields 4, 5, and 6 will be parsed<br>
/// into the Code, Description, and CodeSystem, respectively, of a PriorCode in<br>
/// the list of PriorCodes.<br>
/// HL7:  OBR-26.1.4 : ParentResult.ParentObservationIdentifier.AlternateText<br>
/// HL7:  OBR-26.1.5 : ParentResult.ParentObservationIdentifier.AlternateIdentifier<br>
/// HL7:  OBR-26.1.6 : ParentResult.ParentObservationIdentifier.NameofAlternateCodingSystem<br>
Property ParentResultObservation As HS.SDA3.CodeTableDetail.LabTestItem;

/// If the Result in this Order is the child of an observation in another<br>
/// Order, this is the SubId of the parent observation.<br><br>
/// Viewer cache:<br>
/// For Orders with atomic Results only, if the ParentFillerId,<br>
/// ParentResultObservation.Code, and ParentResultObservationSubId are all<br>
/// non-null and identify a lab.HS.EPVisitTestSetData (LabResultItem) already<br>
/// in the Viewer Cache, that EPVisitTestSetData will be copied into the<br>
/// current EPVisitTestSet (Result). ParentResultObservationSubId itself is not<br>
/// stored in the Viewer Cache.<br><br>
/// HL7:  OBR-26.2 : ParentResult.ParentObservationSubidentifier<br>
/// VIEWERLIB: Not stored<br>
Property ParentResultObservationSubId As %String(MAXLEN = 30);

/// HL7:  OBR-26.3 : ParentResultObservationText<br>
/// VIEWERLIB: Not stored
Property ParentResultObservationText As %String(MAXLEN = "");

/// HL7:  OBR-29.1.1 : Parent.PlacerAssignedIdentifier.EntityIdentifier<br>
/// VIEWERLIB: Not stored
Property ParentPlacerId As %String(MAXLEN = "");

/// The namespace from which the Parent ID is assigned to the order when it was placed<br><br>
/// HL7ToSDA3:<br>
/// OBR-29.1 will be used if a value can be parsed from it.<br>
/// ParentPlacerAssigningAuthority is composed of subfields 2,<br>
/// 3, and 4 concatenated together as "[.2]^[.3]^[.4]", but only if at least<br>
/// one of these is not null.<br><br>
/// HL7:  OBR-29.1.2 : Parent.PlacerAssignedIdentifier.NamespaceID<br>
/// HL7:  OBR-29.1.3 : Parent.PlacerAssignedIdentifier.UniversalID<br>
/// HL7:  OBR-29.1.4 : Parent.PlacerAssignedIdentifier.UniversalIDType<br>
/// VIEWERLIB: Not stored
Property ParentPlacerAssigningAuthority As %String(MAXLEN = 220);

/// If the Result in this Order is the child of an observation in another<br>
/// Order, this is the FillerId of the parent observation.<br><br>
/// Viewer cache:<br>
/// For Orders with atomic Results only, if the ParentFillerId,<br>
/// ParentResultObservation.Code, and ParentResultObservationSubId are all<br>
/// non-null and identify a lab.HS.EPVisitTestSetData (LabResultItem) already<br>
/// in the Viewer Cache, that EPVisitTestSetData will be copied into the<br>
/// current EPVisitTestSet (Result). ParentFillerId itself is not stored in the<br>
/// Viewer Cache.<br><br>
/// HL7:  OBR-29.2.1 : Parent.FillerAssignedIdentifier.EntityIdentifier<br>
/// Not stored
Property ParentFillerId As %String(MAXLEN = "");

/// The namespace from which the Parent ID was assigned to the order when it was<br>
/// filled<br><br>
/// HL7ToSDA3:<br>
/// OBR-29.2 will be used if a value can be parsed from it.<br>
/// ParentFillerAssigningAuthority is composed of subfields 2,<br>
/// 3, and 4 concatenated together as "[.2]^[.3]^[.4]", but only if at least<br>
/// one of these is not null.<br><br>
/// HL7:  OBR-29.2.2 : Parent.FillerAssignedIdentifier.NamespaceID<br>
/// HL7:  OBR-29.2.3 : Parent.FillerAssignedIdentifier.UniversalID<br>
/// HL7:  OBR-29.2.4 : Parent.FillerAssignedIdentifier.UniversalIDType<br>
/// VIEWERLIB: Not stored
Property ParentFillerAssigningAuthority As %String(MAXLEN = 220);

/// HL7:  OBR-31 : ReasonforStudy<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  OBR-31.1 : ReasonforStudy.Identifier<br>
/// .Description<br>
/// HL7:  OBR-31.2 : ReasonforStudy.Text<br>
/// .SDACodingStandard<br>
/// HL7:  OBR-31.3 : ReasonforStudy.NameofCodingSystem<br>
/// .CodeSystemVersionId<br>
/// HL7:  OBR-31.7 : ReasonforStudy.CodingSystemVersionID<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// If subfield 4 or 5 is not null, then subfields 4, 5, 6, and 8 will be<br>
/// parsed into the Code, Description, CodeSystem, and CodeSystemVersionId,<br>
/// respectively, of a PriorCode in the list of PriorCodes.<br>
/// HL7:  OBR-31.4 : ReasonforStudy.AlternateIdentifier<br>
/// HL7:  OBR-31.5 : ReasonforStudy.AlternateText<br>
/// HL7:  OBR-31.6 : ReasonforStudy.NameofAlternateCodingSystem<br>
/// HL7:  OBR-31.8 : ReasonforStudy.AlternateCodingSystemVersionID<br>
Property ReasonForStudy As HS.SDA3.CodeTableDetail.ReasonforStudy;

}
