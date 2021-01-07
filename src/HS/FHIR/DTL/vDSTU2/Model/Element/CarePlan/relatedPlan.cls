/// Plans related to this one.
Class HS.FHIR.DTL.vDSTU2.Model.Element.CarePlan.relatedPlan Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// includes | replaces | fulfills
/// <p>
/// care-plan-relationship is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend care-plan-relationship and you may NOT use codes from other ValueSets.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Plan relationship exists with.
/// <p>
/// CarePlan
Property plan As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "plan", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CarePlan.relatedPlan";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CarePlan.relatedPlan";

}
