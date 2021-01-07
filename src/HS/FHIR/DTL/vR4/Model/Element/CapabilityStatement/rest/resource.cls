/// Resource served on the REST interface.
Class HS.FHIR.DTL.vR4.Model.Element.CapabilityStatement.rest.resource Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// A resource type that is supported.
/// <p>
/// resource-types|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend resource-types|4.0.1 and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// canonical
/// <p>
/// Base System profile for all uses of resource.
/// <p>
/// TO DO: Unrecognized value type for the FHIR4 model
Property profile As %String(MAXLEN = 1000000, XMLNAME = "profile", XMLPROJECTION = "ATTRIBUTE");

/// canonical
/// <p>
/// Profiles for use cases supported.
/// <p>
/// TO DO: Unrecognized value type for the FHIR4 model
Property supportedProfile As list Of %String(MAXLEN = 1000000, XMLNAME = "supportedProfile", XMLPROJECTION = "ELEMENT");

/// markdown
/// <p>
/// Additional information about the use of the resource type.
Property documentation As %String(MAXLEN = 1000000, XMLNAME = "documentation", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// What operations are supported?
Property interaction As list Of HS.FHIR.DTL.vR4.Model.Element.CapabilityStatement.rest.resource.interaction(XMLNAME = "interaction", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// no-version | versioned | versioned-update
/// <p>
/// versioning-policy|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend versioning-policy|4.0.1 and you may NOT use codes from other ValueSets.
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

/// code
/// <p>
/// not-supported | modified-since | not-match | full-support
/// <p>
/// conditional-read-status|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend conditional-read-status|4.0.1 and you may NOT use codes from other ValueSets.
Property conditionalRead As %String(MAXLEN = 1000000, XMLNAME = "conditionalRead", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// If allows/uses conditional update.
Property conditionalUpdate As %Boolean(XMLNAME = "conditionalUpdate", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// not-supported | single | multiple - how conditional delete is supported
/// <p>
/// conditional-delete-status|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend conditional-delete-status|4.0.1 and you may NOT use codes from other ValueSets.
Property conditionalDelete As %String(MAXLEN = 1000000, XMLNAME = "conditionalDelete", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// literal | logical | resolves | enforced | local
/// <p>
/// reference-handling-policy|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend reference-handling-policy|4.0.1 and you may NOT use codes from other ValueSets.
Property referencePolicy As list Of %String(MAXLEN = 1000000, XMLNAME = "referencePolicy", XMLPROJECTION = "ELEMENT");

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
/// Search parameters supported by implementation.
Property searchParam As list Of HS.FHIR.DTL.vR4.Model.Element.CapabilityStatement.rest.resource.searchParam(XMLNAME = "searchParam", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Definition of a resource operation.
Property operation As list Of HS.FHIR.DTL.vR4.Model.Element.CapabilityStatement.rest.resource.operation(XMLNAME = "operation", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CapabilityStatement.rest.resource";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CapabilityStatement.rest.resource";

}
