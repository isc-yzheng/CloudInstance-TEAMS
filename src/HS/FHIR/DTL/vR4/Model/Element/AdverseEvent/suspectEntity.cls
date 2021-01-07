/// The suspected agent causing the adverse event.
Class HS.FHIR.DTL.vR4.Model.Element.AdverseEvent.suspectEntity Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Refers to the specific entity that caused the adverse event.
/// <p>
/// Immunization | Procedure | Substance | Medication | MedicationAdministration | MedicationStatement | Device
Property instance As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "instance", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// Information on the possible cause of the event.
Property causality As list Of HS.FHIR.DTL.vR4.Model.Element.AdverseEvent.suspectEntity.causality(XMLNAME = "causality", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AdverseEvent.suspectEntity";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "AdverseEvent.suspectEntity";

}
