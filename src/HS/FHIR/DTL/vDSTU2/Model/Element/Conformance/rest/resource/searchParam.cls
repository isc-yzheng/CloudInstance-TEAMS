/// Search params supported by implementation.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.rest.resource.searchParam Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Name of search parameter.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// Source of definition for parameter.
Property definition As %String(MAXLEN = 1000000, XMLNAME = "definition", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// number | date | string | token | reference | composite | quantity | uri
/// <p>
/// search-param-type is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend search-param-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Server-specific usage.
Property documentation As %String(MAXLEN = 1000000, XMLNAME = "documentation", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Types of resource (if a resource reference)
/// <p>
/// resource-types is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend resource-types and you may NOT use codes from other ValueSets.
Property target As list Of %String(MAXLEN = 1000000, XMLNAME = "target", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// missing | exact | contains | not | text | in | not-in | below | above | type
/// <p>
/// search-modifier-code is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend search-modifier-code and you may NOT use codes from other ValueSets.
Property modifier As list Of %String(MAXLEN = 1000000, XMLNAME = "modifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Chained names supported.
Property chain As list Of %String(MAXLEN = 1000000, XMLNAME = "chain", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Conformance.rest.resource.searchParam";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Conformance.rest.resource.searchParam";

}
