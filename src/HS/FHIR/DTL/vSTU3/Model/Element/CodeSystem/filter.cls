/// Filter that can be used in a value set.
Class HS.FHIR.DTL.vSTU3.Model.Element.CodeSystem.filter Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// Code that identifies the filter.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// How or why the filter is used.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Operators that can be used with filter.
/// <p>
/// filter-operator is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend filter-operator and you may NOT use codes from other ValueSets.
Property operator As list Of %String(MAXLEN = 1000000, XMLNAME = "operator", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
/// What to use for the value.
Property value As %String(MAXLEN = 1000000, XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CodeSystem.filter";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CodeSystem.filter";

}
