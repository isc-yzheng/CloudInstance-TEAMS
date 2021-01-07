/// Select codes/concepts by their properties (including relationships)
Class HS.FHIR.DTL.vDSTU2.Model.Element.ValueSet.compose.include.filter Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// A property defined by the code system.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property property As %String(MAXLEN = 1000000, XMLNAME = "property", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// = | is-a | is-not-a | regex | in | not-in
/// <p>
/// filter-operator is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend filter-operator and you may NOT use codes from other ValueSets.
Property op As %String(MAXLEN = 1000000, XMLNAME = "op", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// Code from the system, 
/// or regex criteria.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property value As %String(MAXLEN = 1000000, XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet.compose.include.filter";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet.compose.include.filter";

}
