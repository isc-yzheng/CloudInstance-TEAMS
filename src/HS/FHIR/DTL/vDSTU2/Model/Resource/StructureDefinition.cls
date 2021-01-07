/// Structural Definition.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.StructureDefinition Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Absolute URL used to reference this StructureDefinition.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Identifier
/// <p>
/// Other identifiers for the StructureDefinition.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Logical id for this version of the StructureDefinition.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Informal name for this StructureDefinition.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Use this name when displaying the value.
Property display As %String(MAXLEN = 1000000, XMLNAME = "display", XMLPROJECTION = "ATTRIBUTE");

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
/// Name of the publisher (Organization or individual)
Property publisher As %String(MAXLEN = 1000000, XMLNAME = "publisher", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Contact details of the publisher.
Property contact As list Of HS.FHIR.DTL.vDSTU2.Model.Element.StructureDefinition.contact(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date for this version of the StructureDefinition.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Natural language description of the StructureDefinition.
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
/// Scope and Usage this structure definition is for.
Property requirements As %String(MAXLEN = 1000000, XMLNAME = "requirements", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Use and/or publishing restrictions.
Property copyright As %String(MAXLEN = 1000000, XMLNAME = "copyright", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// Assist with indexing and finding.
/// <p>
/// any FHIR2 code may be used; 
/// profile-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// FHIR Version this StructureDefinition targets.
Property fhirVersion As %String(MAXLEN = 1000000, XMLNAME = "fhirVersion", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// External specification that the content is mapped to.
Property mapping As list Of HS.FHIR.DTL.vDSTU2.Model.Element.StructureDefinition.mapping(XMLNAME = "mapping", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// datatype | resource | logical
/// <p>
/// structure-definition-kind is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend structure-definition-kind and you may NOT use codes from other ValueSets.
Property kind As %String(MAXLEN = 1000000, XMLNAME = "kind", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// Any datatype or resource, 
/// including abstract ones.
/// <p>
/// defined-types is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend defined-types and you may NOT use codes from other ValueSets.
Property constrainedType As %String(MAXLEN = 1000000, XMLNAME = "constrainedType", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Whether the structure is abstract.
Property abstract As %Boolean(XMLNAME = "abstract", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// resource | datatype | mapping | extension
/// <p>
/// extension-context is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend extension-context and you may NOT use codes from other ValueSets.
Property contextType As %String(MAXLEN = 1000000, XMLNAME = "contextType", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Where the extension can be used in instances.
Property context As list Of %String(MAXLEN = 1000000, XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Structure that this set of constraints applies to.
Property base As %String(MAXLEN = 1000000, XMLNAME = "base", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Snapshot view of the structure.
Property snapshot As HS.FHIR.DTL.vDSTU2.Model.Element.StructureDefinition.snapshot(XMLNAME = "snapshot", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Differential view of the structure.
Property differential As HS.FHIR.DTL.vDSTU2.Model.Element.StructureDefinition.differential(XMLNAME = "differential", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "StructureDefinition";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "StructureDefinition";

}
