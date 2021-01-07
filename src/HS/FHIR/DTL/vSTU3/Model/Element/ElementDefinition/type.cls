/// Data type and Profile for this element.
Class HS.FHIR.DTL.vSTU3.Model.Element.ElementDefinition.type Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// URI reference to a data type or resource whose name is in the ValueSet called defined-types (extensible).
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// Profile (StructureDefinition) to apply (or IG)
Property profile As %String(MAXLEN = 1000000, XMLNAME = "profile", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Profile (StructureDefinition) to apply to reference target (or IG)
Property targetProfile As %String(MAXLEN = 1000000, XMLNAME = "targetProfile", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// contained | referenced | bundled - how aggregated
/// <p>
/// resource-aggregation-mode is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend resource-aggregation-mode and you may NOT use codes from other ValueSets.
Property aggregation As list Of %String(MAXLEN = 1000000, XMLNAME = "aggregation", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// either | independent | specific
/// <p>
/// reference-version-rules is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend reference-version-rules and you may NOT use codes from other ValueSets.
Property versioning As %String(MAXLEN = 1000000, XMLNAME = "versioning", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "type";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "type";

}
