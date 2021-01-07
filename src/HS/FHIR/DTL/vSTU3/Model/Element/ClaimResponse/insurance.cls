/// Insurance or medical plan.
Class HS.FHIR.DTL.vSTU3.Model.Element.ClaimResponse.insurance Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Service instance identifier.
Property sequence As %Integer(XMLNAME = "sequence", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// Is the focal Coverage.
Property focal As %Boolean(XMLNAME = "focal", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Insurance information.
/// <p>
/// Coverage
Property coverage As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "coverage", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
/// Business agreement.
Property businessArrangement As %String(MAXLEN = 1000000, XMLNAME = "businessArrangement", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Pre-Authorization/Determination Reference.
Property preAuthRef As list Of %String(MAXLEN = 1000000, XMLNAME = "preAuthRef", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Adjudication results.
/// <p>
/// ClaimResponse
Property claimResponse As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "claimResponse", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse.insurance";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse.insurance";

}
