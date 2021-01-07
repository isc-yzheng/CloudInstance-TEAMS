/// A code system resource specifies a set of codes drawn from one or more code systems.
Class HS.FHIR.DTL.vSTU3.Model.Resource.CodeSystem Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Logical URI to reference this code system (globally unique) (Coding.system)
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Additional identifier for the code system.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Business version of the code system (Coding.version)
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for this code system (computer friendly)
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for this code system (human friendly)
Property title As %String(MAXLEN = 1000000, XMLNAME = "title", XMLPROJECTION = "ATTRIBUTE");

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
/// Natural language description of the code system.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// UsageContext
/// <p>
/// Context the content is intended to support.
Property useContext As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.UsageContext(XMLNAME = "useContext", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Intended jurisdiction for code system (if applicable)
/// <p>
/// jurisdiction is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in jurisdiction, 
/// you may formally EXTEND jurisdiction to add codes to it.
Property jurisdiction As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "jurisdiction", XMLPROJECTION = "ELEMENT");

/// markdown
/// <p>
/// Why this code system is defined.
Property purpose As %String(MAXLEN = 1000000, XMLNAME = "purpose", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Use and/or publishing restrictions.
Property copyright As %String(MAXLEN = 1000000, XMLNAME = "copyright", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// If code comparison is case sensitive.
Property caseSensitive As %Boolean(XMLNAME = "caseSensitive", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Canonical URL for value set with entire code system.
Property valueSet As %String(MAXLEN = 1000000, XMLNAME = "valueSet", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// grouped-by | is-a | part-of | classified-with
/// <p>
/// codesystem-hierarchy-meaning is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend codesystem-hierarchy-meaning and you may NOT use codes from other ValueSets.
Property hierarchyMeaning As %String(MAXLEN = 1000000, XMLNAME = "hierarchyMeaning", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// If code system defines a post-composition grammar.
Property compositional As %Boolean(XMLNAME = "compositional", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// If definitions are not stable.
Property versionNeeded As %Boolean(XMLNAME = "versionNeeded", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// not-present | example | fragment | complete
/// <p>
/// codesystem-content-mode is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend codesystem-content-mode and you may NOT use codes from other ValueSets.
Property content As %String(MAXLEN = 1000000, XMLNAME = "content", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// unsignedInt
/// <p>
/// Total concepts in the code system.
Property count As %Integer(XMLNAME = "count", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Filter that can be used in a value set.
Property filter As list Of HS.FHIR.DTL.vSTU3.Model.Element.CodeSystem.filter(XMLNAME = "filter", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Additional information supplied about each concept.
Property property As list Of HS.FHIR.DTL.vSTU3.Model.Element.CodeSystem.property(XMLNAME = "property", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Concepts in the code system.
Property concept As list Of HS.FHIR.DTL.vSTU3.Model.Element.CodeSystem.concept(XMLNAME = "concept", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CodeSystem";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CodeSystem";

}
