/// A map from one set of concepts to one or more other concepts.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.ConceptMap Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Globally unique logical id for concept map.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Additional identifier for the concept map.
Property identifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Logical id for this version of the concept map.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Informal name for this concept map.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// draft | active | retired
/// <p>
/// conformance-resource-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend conformance-resource-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// If for testing purposes, 
/// not real usage.
Property experimental As %Boolean(XMLNAME = "experimental", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name of the publisher (organization or individual)
Property publisher As %String(MAXLEN = 1000000, XMLNAME = "publisher", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Contact details of the publisher.
Property contact As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ConceptMap.contact(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date for given status.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Human language description of the concept map.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Content intends to support these contexts.
/// <p>
/// use-context is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in use-context, 
/// you may formally EXTEND use-context to add codes to it.
Property useContext As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "useContext", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Why needed.
Property requirements As %String(MAXLEN = 1000000, XMLNAME = "requirements", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Use and/or publishing restrictions.
Property copyright As %String(MAXLEN = 1000000, XMLNAME = "copyright", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Identifies the source of the concepts which are being mapped.
/// <p>
/// ValueSet | StructureDefinition
Property sourceReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "sourceReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// uri
/// <p>
/// Identifies the source of the concepts which are being mapped.
Property sourceUri As %String(MAXLEN = 1000000, XMLNAME = "sourceUri", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Provides context to the mappings.
/// <p>
/// ValueSet | StructureDefinition
Property targetReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "targetReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// uri
/// <p>
/// Provides context to the mappings.
Property targetUri As %String(MAXLEN = 1000000, XMLNAME = "targetUri", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// BackboneElement
/// <p>
/// Mappings for a concept from the source set.
Property element As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ConceptMap.element(XMLNAME = "element", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ConceptMap";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ConceptMap";

}
