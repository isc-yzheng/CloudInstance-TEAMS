/// An authorization for the supply of glasses and/or contact lenses to a Patient:
Class HS.FHIR.DTL.vSTU3.Model.Resource.VisionPrescription Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business identifier.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | cancelled | draft | entered-in-error
/// <p>
/// fm-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend fm-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who prescription is for.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Created during encounter / admission / stay.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When prescription was authorized.
Property dateWritten As %String(MAXLEN = 1000000, XMLNAME = "dateWritten", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who authorizes the vision product.
/// <p>
/// Practitioner
Property prescriber As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "prescriber", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Reason or indication for writing the prescription.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property reasonCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reasonCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Reason or indication for writing the prescription.
/// <p>
/// Condition.
Property reasonReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Vision supply authorization.
Property dispense As list Of HS.FHIR.DTL.vSTU3.Model.Element.VisionPrescription.dispense(XMLNAME = "dispense", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "VisionPrescription";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "VisionPrescription";

}
