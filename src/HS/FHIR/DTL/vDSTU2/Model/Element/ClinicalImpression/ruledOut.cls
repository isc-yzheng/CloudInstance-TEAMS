/// Diagnosis considered not possible.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ClinicalImpression.ruledOut Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Specific text of code for diagnosis.
/// <p>
/// any FHIR2 code may be used; 
/// condition-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property item As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "item", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
/// Grounds for elimination.
Property reason As %String(MAXLEN = 1000000, XMLNAME = "reason", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClinicalImpression.ruledOut";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClinicalImpression.ruledOut";

}
