/// Participants in producing the report.
Class HS.FHIR.DTL.vSTU3.Model.Element.DiagnosticReport.performer Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Type of performer.
/// <p>
/// any FHIR3 code may be used; 
/// performer-role shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property role As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "role", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Practitioner or Organization  participant.
/// <p>
/// Practitioner | Organization
Property actor As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "actor", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DiagnosticReport.performer";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DiagnosticReport.performer";

}
