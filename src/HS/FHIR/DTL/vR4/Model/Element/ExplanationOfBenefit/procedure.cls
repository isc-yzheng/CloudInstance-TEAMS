/// Clinical procedures performed.
Class HS.FHIR.DTL.vR4.Model.Element.ExplanationOfBenefit.procedure Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Procedure instance identifier.
Property sequence As %Integer(XMLNAME = "sequence", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Category of Procedure.
/// <p>
/// any FHIR4 code may be used; 
/// ex-procedure-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the procedure was performed.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Specific clinical procedure.
/// <p>
/// any FHIR4 code may be used; 
/// icd-10-procedures shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property procedureCodeableConcept As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "procedureCodeableConcept", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Specific clinical procedure.
/// <p>
/// Procedure.
Property procedureReference As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "procedureReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Unique device identifier.
/// <p>
/// Device
Property udi As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "udi", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExplanationOfBenefit.procedure";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExplanationOfBenefit.procedure";

}
