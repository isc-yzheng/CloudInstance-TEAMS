/// A conformance statement.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Conformance Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Logical uri to reference this statement.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Logical id for this version of the statement.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Informal name for this conformance statement.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

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
Property contact As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.contact(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Publication Date(/time)
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Human description of the conformance statement.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Why is this needed?
Property requirements As %String(MAXLEN = 1000000, XMLNAME = "requirements", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Use and/or publishing restrictions.
Property copyright As %String(MAXLEN = 1000000, XMLNAME = "copyright", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// instance | capability | requirements
/// <p>
/// conformance-statement-kind is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend conformance-statement-kind and you may NOT use codes from other ValueSets.
Property kind As %String(MAXLEN = 1000000, XMLNAME = "kind", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// BackboneElement
/// <p>
/// Software that is covered by this conformance statement.
Property software As HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.software(XMLNAME = "software", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// If this describes a specific instance.
Property implementation As HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.implementation(XMLNAME = "implementation", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// FHIR Version the system uses.
Property fhirVersion As %String(MAXLEN = 1000000, XMLNAME = "fhirVersion", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// no | extensions | elements | both
/// <p>
/// unknown-content-code is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend unknown-content-code and you may NOT use codes from other ValueSets.
Property acceptUnknown As %String(MAXLEN = 1000000, XMLNAME = "acceptUnknown", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// formats supported (xml | json | mime type)
/// <p>
/// MimeType RFC 4289 is the REQUIRED IETF specification for the FHIR2 code values that may be used.
Property format As list Of %String(MAXLEN = 1000000, XMLNAME = "format", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Profiles for use cases supported.
/// <p>
/// StructureDefinition
Property profile As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "profile", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// If the endpoint is a RESTful one.
Property rest As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.rest(XMLNAME = "rest", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// If messaging is supported.
Property messaging As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.messaging(XMLNAME = "messaging", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Document definition.
Property document As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.document(XMLNAME = "document", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Conformance";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Conformance";

}
