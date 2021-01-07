/// Insurance or medical plan.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Claim.coverage Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Service instance identifier.
Property sequence As %Integer(XMLNAME = "sequence", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// The focal Coverage.
Property focal As %Boolean(XMLNAME = "focal", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Insurance information.
/// <p>
/// Coverage
Property coverage As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "coverage", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
/// Business agreement.
Property businessArrangement As %String(MAXLEN = 1000000, XMLNAME = "businessArrangement", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// Patient relationship to subscriber.
/// <p>
/// any FHIR2 code may be used; 
/// relationship shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property relationship As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "relationship", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
/// Pre-Authorization/Determination Reference.
Property preAuthRef As list Of %String(MAXLEN = 1000000, XMLNAME = "preAuthRef", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Adjudication results.
/// <p>
/// ClaimResponse
Property claimResponse As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "claimResponse", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Original version.
/// <p>
/// any FHIR2 code may be used; 
/// ruleset shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property originalRuleset As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "originalRuleset", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Claim.coverage";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Claim.coverage";

}
