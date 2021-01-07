/// Page/Section in the Guide.
Class HS.FHIR.DTL.vSTU3.Model.Element.ImplementationGuide.page Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Where to find that page.
Property source As %String(MAXLEN = 1000000, XMLNAME = "source", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Short title shown for navigational assistance.
Property title As %String(MAXLEN = 1000000, XMLNAME = "title", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// page | example | list | include | directory | dictionary | toc | resource
/// <p>
/// guide-page-kind is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend guide-page-kind and you may NOT use codes from other ValueSets.
Property kind As %String(MAXLEN = 1000000, XMLNAME = "kind", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// Kind of resource to include in the list.
/// <p>
/// resource-types is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend resource-types and you may NOT use codes from other ValueSets.
Property type As list Of %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Name of package to include.
Property package As list Of %String(MAXLEN = 1000000, XMLNAME = "package", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// Format of the page (e.g. 
/// html, 
/// markdown, 
/// etc.)
/// <p>
/// MimeType RFC 4289 is the REQUIRED IETF specification for the FHIR3 code values that may be used.
Property format As %String(MAXLEN = 1000000, XMLNAME = "format", XMLPROJECTION = "ATTRIBUTE");

/// ImplementationGuide:page
/// <p>
/// Nested Pages / Sections.
Property page As list Of HS.FHIR.DTL.vSTU3.Model.Element.ImplementationGuide.page(XMLNAME = "page", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImplementationGuide.page";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImplementationGuide.page";

}
