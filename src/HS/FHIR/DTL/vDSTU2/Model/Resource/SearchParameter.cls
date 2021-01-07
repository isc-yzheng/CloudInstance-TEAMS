/// Search Parameter for a resource.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.SearchParameter Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Absolute URL used to reference this search parameter.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Informal name for this search parameter.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// draft | active | retired
/// <p>
/// conformance-resource-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend conformance-resource-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// If for testing purposes, 
/// not real usage.
Property experimental As %Boolean(XMLNAME = "experimental", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name of the publisher (Organization or individual)
Property publisher As %String(MAXLEN = 1000000, XMLNAME = "publisher", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Contact details of the publisher.
Property contact As list Of HS.FHIR.DTL.vDSTU2.Model.Element.SearchParameter.contact(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Publication Date(/time)
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Why this search parameter is defined.
Property requirements As %String(MAXLEN = 1000000, XMLNAME = "requirements", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Code used in URL.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// The resource type this search parameter applies to.
/// <p>
/// resource-types is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend resource-types and you may NOT use codes from other ValueSets.
Property base As %String(MAXLEN = 1000000, XMLNAME = "base", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// number | date | string | token | reference | composite | quantity | uri
/// <p>
/// search-param-type is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend search-param-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Documentation for  search parameter.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// XPath that extracts the values.
Property xpath As %String(MAXLEN = 1000000, XMLNAME = "xpath", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// normal | phonetic | nearby | distance | other
/// <p>
/// search-xpath-usage is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend search-xpath-usage and you may NOT use codes from other ValueSets.
Property xpathUsage As %String(MAXLEN = 1000000, XMLNAME = "xpathUsage", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Types of resource (if a resource reference)
/// <p>
/// resource-types is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend resource-types and you may NOT use codes from other ValueSets.
Property target As list Of %String(MAXLEN = 1000000, XMLNAME = "target", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "SearchParameter";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "SearchParameter";

}
