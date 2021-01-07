/// Resource served on the REST interface.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.rest.resource Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// A resource type that is supported.
/// <p>
/// resource-types is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend resource-types and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Base System profile for all uses of resource.
/// <p>
/// StructureDefinition
Property profile As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "profile", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// What operations are supported?
Property interaction As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.rest.resource.interaction(XMLNAME = "interaction", XMLPROJECTION = "ELEMENT") [ Required ];

/// code
/// <p>
/// no-version | versioned | versioned-update
/// <p>
/// versioning-policy is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend versioning-policy and you may NOT use codes from other ValueSets.
Property versioning As %String(MAXLEN = 1000000, XMLNAME = "versioning", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Whether vRead can return past versions.
Property readHistory As %Boolean(XMLNAME = "readHistory", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// If update can commit to a new identity.
Property updateCreate As %Boolean(XMLNAME = "updateCreate", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// If allows/uses conditional create.
Property conditionalCreate As %Boolean(XMLNAME = "conditionalCreate", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// If allows/uses conditional update.
Property conditionalUpdate As %Boolean(XMLNAME = "conditionalUpdate", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// not-supported | single | multiple - how conditional delete is supported
/// <p>
/// conditional-delete-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend conditional-delete-status and you may NOT use codes from other ValueSets.
Property conditionalDelete As %String(MAXLEN = 1000000, XMLNAME = "conditionalDelete", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// _include values supported by the server.
Property searchInclude As list Of %String(MAXLEN = 1000000, XMLNAME = "searchInclude", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// _revinclude values supported by the server.
Property searchRevInclude As list Of %String(MAXLEN = 1000000, XMLNAME = "searchRevInclude", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Search params supported by implementation.
Property searchParam As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.rest.resource.searchParam(XMLNAME = "searchParam", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Conformance.rest.resource";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Conformance.rest.resource";

}
