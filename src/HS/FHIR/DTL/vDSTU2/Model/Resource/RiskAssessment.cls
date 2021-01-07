/// Potential outcomes for a subject with likelihood.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.RiskAssessment Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Who/what does assessment apply to?
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When was assessment made?
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Condition assessed.
/// <p>
/// Condition
Property condition As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "condition", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Where was assessment performed?
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who did assessment?
/// <p>
/// Practitioner | Device
Property performer As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "performer", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Unique identifier for the assessment.
Property identifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Evaluation mechanism.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property method As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "method", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Information used in assessment.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property basis As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "basis", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Outcome predicted.
Property prediction As list Of HS.FHIR.DTL.vDSTU2.Model.Element.RiskAssessment.prediction(XMLNAME = "prediction", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// How to reduce risk.
Property mitigation As %String(MAXLEN = 1000000, XMLNAME = "mitigation", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "RiskAssessment";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "RiskAssessment";

}
