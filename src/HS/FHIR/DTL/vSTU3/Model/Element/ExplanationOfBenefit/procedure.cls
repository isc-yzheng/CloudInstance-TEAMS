/// Procedures performed.
Class HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.procedure Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Procedure sequence for reference.
Property sequence As %Integer(XMLNAME = "sequence", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// dateTime
/// <p>
/// When the procedure was performed.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
///  Patient's list of procedures performed.
/// <p>
/// any FHIR3 code may be used; 
/// icd-10-procedures shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property procedureCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "procedureCodeableConcept", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
///  Patient's list of procedures performed.
/// <p>
/// Procedure.
Property procedureReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "procedureReference", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExplanationOfBenefit.procedure";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExplanationOfBenefit.procedure";

}
