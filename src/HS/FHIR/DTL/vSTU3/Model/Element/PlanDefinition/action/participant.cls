/// Who should participate in the action.
Class HS.FHIR.DTL.vSTU3.Model.Element.PlanDefinition.action.participant Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// patient | practitioner | related-person
/// <p>
/// action-participant-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend action-participant-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// E.g. 
/// Nurse, 
/// Surgeon, 
/// Parent, 
/// etc.
/// <p>
/// any FHIR3 code may be used; 
/// action-participant-role shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property role As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "role", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "PlanDefinition.action.participant";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "PlanDefinition.action.participant";

}
