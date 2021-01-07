/// Possible or likely findings and diagnoses.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ClinicalImpression.finding Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Specific text or code for finding.
/// <p>
/// any FHIR2 code may be used; 
/// condition-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property item As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "item", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
/// Which investigations support finding.
Property cause As %String(MAXLEN = 1000000, XMLNAME = "cause", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClinicalImpression.finding";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClinicalImpression.finding";

}
