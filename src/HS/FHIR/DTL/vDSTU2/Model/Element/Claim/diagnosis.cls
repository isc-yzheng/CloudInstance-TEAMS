/// Diagnosis.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Claim.diagnosis Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Sequence of diagnosis.
Property sequence As %Integer(XMLNAME = "sequence", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Coding
/// <p>
/// Patient's list of diagnosis.
/// <p>
/// any FHIR2 code may be used; 
/// icd-10 shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property diagnosis As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "diagnosis", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Claim.diagnosis";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Claim.diagnosis";

}
