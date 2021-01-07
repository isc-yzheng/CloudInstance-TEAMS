/// The list of diagnosis relevant to this episode of care.
Class HS.FHIR.DTL.vSTU3.Model.Element.EpisodeOfCare.diagnosis Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Conditions/problems/diagnoses this episode of care is for.
/// <p>
/// Condition
Property condition As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "condition", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Role that this diagnosis has within the episode of care (e.g. 
/// admission, 
/// billing, 
/// discharge...)
/// <p>
/// diagnosis-role is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in diagnosis-role, 
/// you may use codes from any ValueSet.
Property role As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "role", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Ranking of the diagnosis (for each role type)
Property rank As %Integer(XMLNAME = "rank", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "EpisodeOfCare.diagnosis";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "EpisodeOfCare.diagnosis";

}
