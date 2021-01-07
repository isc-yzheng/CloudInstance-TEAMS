/// What operations are supported?
Class HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.rest.interaction Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// transaction | search-system | history-system
/// <p>
/// system-restful-interaction is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend system-restful-interaction and you may NOT use codes from other ValueSets.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Anything special about operation behavior.
Property documentation As %String(MAXLEN = 1000000, XMLNAME = "documentation", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Conformance.rest.interaction";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Conformance.rest.interaction";

}
