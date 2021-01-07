/// Who administered substance.
Class HS.FHIR.DTL.vSTU3.Model.Element.MedicationAdministration.performer Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Individual who was performing.
/// <p>
/// Practitioner | Patient | RelatedPerson | Device
Property actor As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "actor", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Organization organization was acting for.
/// <p>
/// Organization
Property onBehalfOf As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "onBehalfOf", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationAdministration.performer";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicationAdministration.performer";

}
