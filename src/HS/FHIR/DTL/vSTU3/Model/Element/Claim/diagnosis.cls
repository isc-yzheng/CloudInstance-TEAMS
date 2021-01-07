/// List of Diagnosis.
Class HS.FHIR.DTL.vSTU3.Model.Element.Claim.diagnosis Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Number to covey order of diagnosis.
Property sequence As %Integer(XMLNAME = "sequence", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
///  Patient's diagnosis.
/// <p>
/// any FHIR3 code may be used; 
/// icd-10 shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property diagnosisCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "diagnosisCodeableConcept", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
///  Patient's diagnosis.
/// <p>
/// Condition.
Property diagnosisReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "diagnosisReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Timing or nature of the diagnosis.
/// <p>
/// any FHIR3 code may be used; 
/// ex-diagnosistype shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Package billing code.
/// <p>
/// any FHIR3 code may be used; 
/// ex-diagnosisrelatedgroup shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property packageCode As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "packageCode", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Claim.diagnosis";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Claim.diagnosis";

}
