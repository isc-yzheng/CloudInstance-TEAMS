/// Prescription for vision correction products for a patient.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.VisionPrescription Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business identifier.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When prescription was authorized.
Property dateWritten As %String(MAXLEN = 1000000, XMLNAME = "dateWritten", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who prescription is for.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who authorizes the vision product.
/// <p>
/// Practitioner
Property prescriber As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "prescriber", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Created during encounter / admission / stay.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Reason or indication for writing the prescription.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property reasonCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reasonCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Reason or indication for writing the prescription.
/// <p>
/// Condition.
Property reasonReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Vision supply authorization.
Property dispense As list Of HS.FHIR.DTL.vDSTU2.Model.Element.VisionPrescription.dispense(XMLNAME = "dispense", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "VisionPrescription";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "VisionPrescription";

}
