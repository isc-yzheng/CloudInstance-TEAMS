/// A search parameter that defines a named search item that can be used to search/filter on a resource.
Class HS.FHIR.DTL.vSTU3.Model.Resource.SearchParameter Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Logical URI to reference this search parameter (globally unique)
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Business version of the search parameter.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for this search parameter (computer friendly)
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// draft | active | retired | unknown
/// <p>
/// publication-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend publication-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// For testing purposes, 
/// not real usage.
Property experimental As %Boolean(XMLNAME = "experimental", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Date this was last changed.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name of the publisher (organization or individual)
Property publisher As %String(MAXLEN = 1000000, XMLNAME = "publisher", XMLPROJECTION = "ATTRIBUTE");

/// ContactDetail
/// <p>
/// Contact details for the publisher.
Property contact As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.ContactDetail(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// UsageContext
/// <p>
/// Context the content is intended to support.
Property useContext As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.UsageContext(XMLNAME = "useContext", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Intended jurisdiction for search parameter (if applicable)
/// <p>
/// jurisdiction is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in jurisdiction, 
/// you may formally EXTEND jurisdiction to add codes to it.
Property jurisdiction As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "jurisdiction", XMLPROJECTION = "ELEMENT");

/// markdown
/// <p>
/// Why this search parameter is defined.
Property purpose As %String(MAXLEN = 1000000, XMLNAME = "purpose", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Code used in URL.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// The resource type(s) this search parameter applies to.
/// <p>
/// resource-types is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend resource-types and you may NOT use codes from other ValueSets.
Property base As list Of %String(MAXLEN = 1000000, XMLNAME = "base", XMLPROJECTION = "ELEMENT") [ Required ];

/// code
/// <p>
/// number | date | string | token | reference | composite | quantity | uri
/// <p>
/// search-param-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend search-param-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// Original Definition for the search parameter.
Property derivedFrom As %String(MAXLEN = 1000000, XMLNAME = "derivedFrom", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Natural language description of the search parameter.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// FHIRPath expression that extracts the values.
Property expression As %String(MAXLEN = 1000000, XMLNAME = "expression", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// XPath that extracts the values.
Property xpath As %String(MAXLEN = 1000000, XMLNAME = "xpath", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// normal | phonetic | nearby | distance | other
/// <p>
/// search-xpath-usage is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend search-xpath-usage and you may NOT use codes from other ValueSets.
Property xpathUsage As %String(MAXLEN = 1000000, XMLNAME = "xpathUsage", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Types of resource (if a resource reference)
/// <p>
/// resource-types is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend resource-types and you may NOT use codes from other ValueSets.
Property target As list Of %String(MAXLEN = 1000000, XMLNAME = "target", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// eq | ne | gt | lt | ge | le | sa | eb | ap
/// <p>
/// search-comparator is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend search-comparator and you may NOT use codes from other ValueSets.
Property comparator As list Of %String(MAXLEN = 1000000, XMLNAME = "comparator", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// missing | exact | contains | not | text | in | not-in | below | above | type
/// <p>
/// search-modifier-code is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend search-modifier-code and you may NOT use codes from other ValueSets.
Property modifier As list Of %String(MAXLEN = 1000000, XMLNAME = "modifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Chained names supported.
Property chain As list Of %String(MAXLEN = 1000000, XMLNAME = "chain", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// For Composite resources to define the parts.
Property component As list Of HS.FHIR.DTL.vSTU3.Model.Element.SearchParameter.component(XMLNAME = "component", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "SearchParameter";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "SearchParameter";

}
