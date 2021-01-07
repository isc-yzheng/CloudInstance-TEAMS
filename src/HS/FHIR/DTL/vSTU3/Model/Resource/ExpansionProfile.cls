/// Resource to define constraints on the Expansion of a FHIR ValueSet.
Class HS.FHIR.DTL.vSTU3.Model.Resource.ExpansionProfile Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Logical URI to reference this expansion profile (globally unique)
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Additional identifier for the expansion profile.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Business version of the expansion profile.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for this expansion profile (computer friendly)
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

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

/// markdown
/// <p>
/// Natural language description of the expansion profile.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// UsageContext
/// <p>
/// Context the content is intended to support.
Property useContext As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.UsageContext(XMLNAME = "useContext", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Intended jurisdiction for expansion profile (if applicable)
/// <p>
/// jurisdiction is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in jurisdiction, 
/// you may formally EXTEND jurisdiction to add codes to it.
Property jurisdiction As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "jurisdiction", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Fix use of a code system to a particular version.
Property fixedVersion As list Of HS.FHIR.DTL.vSTU3.Model.Element.ExpansionProfile.fixedVersion(XMLNAME = "fixedVersion", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Systems/Versions to be exclude.
Property excludedSystem As HS.FHIR.DTL.vSTU3.Model.Element.ExpansionProfile.excludedSystem(XMLNAME = "excludedSystem", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Whether the expansion should include concept designations.
Property includeDesignations As %Boolean(XMLNAME = "includeDesignations", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// When the expansion profile imposes designation contraints.
Property designation As HS.FHIR.DTL.vSTU3.Model.Element.ExpansionProfile.designation(XMLNAME = "designation", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Include or exclude the value set definition in the expansion.
Property includeDefinition As %Boolean(XMLNAME = "includeDefinition", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Include or exclude inactive concepts in the expansion.
Property activeOnly As %Boolean(XMLNAME = "activeOnly", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Nested codes in the expansion or not.
Property excludeNested As %Boolean(XMLNAME = "excludeNested", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Include or exclude codes which cannot be rendered in user interfaces in the value set expansion.
Property excludeNotForUI As %Boolean(XMLNAME = "excludeNotForUI", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Include or exclude codes which are post coordinated expressions in the value set expansion.
Property excludePostCoordinated As %Boolean(XMLNAME = "excludePostCoordinated", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Specify the language for the display element of codes in the value set expansion.
/// <p>
/// languages is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in languages, 
/// you may formally EXTEND languages to add codes to it.
Property displayLanguage As %String(MAXLEN = 1000000, XMLNAME = "displayLanguage", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Controls behaviour of the value set expand operation when value sets are too large to be completely expanded.
Property limitedExpansion As %Boolean(XMLNAME = "limitedExpansion", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExpansionProfile";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExpansionProfile";

}
