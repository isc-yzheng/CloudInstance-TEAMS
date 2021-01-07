/// A Capability Statement documents a set of capabilities (behaviors) of a FHIR Server that may be used as a statement of actual server functionality or a statement of required or desired server implementation.
Class HS.FHIR.DTL.vSTU3.Model.Resource.CapabilityStatement Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Logical URI to reference this capability statement (globally unique)
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Business version of the capability statement.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for this capability statement (computer friendly)
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for this capability statement (human friendly)
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
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE") [ Required ];

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
/// Natural language description of the capability statement.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// UsageContext
/// <p>
/// Context the content is intended to support.
Property useContext As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.UsageContext(XMLNAME = "useContext", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Intended jurisdiction for capability statement (if applicable)
/// <p>
/// jurisdiction is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in jurisdiction, 
/// you may formally EXTEND jurisdiction to add codes to it.
Property jurisdiction As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "jurisdiction", XMLPROJECTION = "ELEMENT");

/// markdown
/// <p>
/// Why this capability statement is defined.
Property purpose As %String(MAXLEN = 1000000, XMLNAME = "purpose", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Use and/or publishing restrictions.
Property copyright As %String(MAXLEN = 1000000, XMLNAME = "copyright", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// instance | capability | requirements
/// <p>
/// capability-statement-kind is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend capability-statement-kind and you may NOT use codes from other ValueSets.
Property kind As %String(MAXLEN = 1000000, XMLNAME = "kind", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// Canonical URL of another capability statement this implements.
Property instantiates As list Of %String(MAXLEN = 1000000, XMLNAME = "instantiates", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Software that is covered by this capability statement.
Property software As HS.FHIR.DTL.vSTU3.Model.Element.CapabilityStatement.software(XMLNAME = "software", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// If this describes a specific instance.
Property implementation As HS.FHIR.DTL.vSTU3.Model.Element.CapabilityStatement.implementation(XMLNAME = "implementation", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// FHIR Version the system uses.
Property fhirVersion As %String(MAXLEN = 1000000, XMLNAME = "fhirVersion", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// no | extensions | elements | both
/// <p>
/// unknown-content-code is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend unknown-content-code and you may NOT use codes from other ValueSets.
Property acceptUnknown As %String(MAXLEN = 1000000, XMLNAME = "acceptUnknown", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// formats supported (xml | json | ttl | mime type)
/// <p>
/// MimeType RFC 4289 is the REQUIRED IETF specification for the FHIR3 code values that may be used.
Property format As list Of %String(MAXLEN = 1000000, XMLNAME = "format", XMLPROJECTION = "ELEMENT") [ Required ];

/// code
/// <p>
/// Patch formats supported.
/// <p>
/// MimeType RFC 4289 is the REQUIRED IETF specification for the FHIR3 code values that may be used.
Property patchFormat As list Of %String(MAXLEN = 1000000, XMLNAME = "patchFormat", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Implementation guides supported.
Property implementationGuide As list Of %String(MAXLEN = 1000000, XMLNAME = "implementationGuide", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Profiles for use cases supported.
/// <p>
/// StructureDefinition
Property profile As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "profile", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// If the endpoint is a RESTful one.
Property rest As list Of HS.FHIR.DTL.vSTU3.Model.Element.CapabilityStatement.rest(XMLNAME = "rest", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// If messaging is supported.
Property messaging As list Of HS.FHIR.DTL.vSTU3.Model.Element.CapabilityStatement.messaging(XMLNAME = "messaging", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Document definition.
Property document As list Of HS.FHIR.DTL.vSTU3.Model.Element.CapabilityStatement.document(XMLNAME = "document", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CapabilityStatement";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CapabilityStatement";

}
