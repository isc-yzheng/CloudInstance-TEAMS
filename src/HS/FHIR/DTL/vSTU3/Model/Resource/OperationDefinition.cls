/// A compartment definition that defines how resources are accessed on a server.
Class HS.FHIR.DTL.vSTU3.Model.Resource.OperationDefinition Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Logical URI to reference this operation definition (globally unique)
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Business version of the operation definition.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for this operation definition (computer friendly)
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// draft | active | retired | unknown
/// <p>
/// publication-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend publication-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// operation | query
/// <p>
/// operation-kind is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend operation-kind and you may NOT use codes from other ValueSets.
Property kind As %String(MAXLEN = 1000000, XMLNAME = "kind", XMLPROJECTION = "ATTRIBUTE") [ Required ];

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
/// Natural language description of the operation definition.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// UsageContext
/// <p>
/// Context the content is intended to support.
Property useContext As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.UsageContext(XMLNAME = "useContext", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Intended jurisdiction for operation definition (if applicable)
/// <p>
/// jurisdiction is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in jurisdiction, 
/// you may formally EXTEND jurisdiction to add codes to it.
Property jurisdiction As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "jurisdiction", XMLPROJECTION = "ELEMENT");

/// markdown
/// <p>
/// Why this operation definition is defined.
Property purpose As %String(MAXLEN = 1000000, XMLNAME = "purpose", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Whether content is unchanged by the operation.
Property idempotent As %Boolean(XMLNAME = "idempotent", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Name used to invoke the operation.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Additional information about use.
Property comment As %String(MAXLEN = 1000000, XMLNAME = "comment", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Marks this as a profile of the base.
/// <p>
/// OperationDefinition
Property base As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "base", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// Types this operation applies to.
/// <p>
/// resource-types is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend resource-types and you may NOT use codes from other ValueSets.
Property resource As list Of %String(MAXLEN = 1000000, XMLNAME = "resource", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Invoke at the system level?
Property system As %Boolean(XMLNAME = "system", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// Invole at the type level?
Property type As %Boolean(XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// Invoke on an instance?
Property instance As %Boolean(XMLNAME = "instance", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// BackboneElement
/// <p>
/// Parameters for the operation/query.
Property parameter As list Of HS.FHIR.DTL.vSTU3.Model.Element.OperationDefinition.parameter(XMLNAME = "parameter", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Define overloaded variants for when  generating code.
Property overload As list Of HS.FHIR.DTL.vSTU3.Model.Element.OperationDefinition.overload(XMLNAME = "overload", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "OperationDefinition";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "OperationDefinition";

}
