/// A curated namespace that issues unique symbols within that namespace for the identification of concepts, 
/// people, 
/// devices, 
/// etc. 
/// Represents a "System" used within the Identifier and Coding data types.
Class HS.FHIR.DTL.vSTU3.Model.Resource.NamingSystem Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Name for this naming system (computer friendly)
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
/// codesystem | identifier | root
/// <p>
/// namingsystem-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend namingsystem-type and you may NOT use codes from other ValueSets.
Property kind As %String(MAXLEN = 1000000, XMLNAME = "kind", XMLPROJECTION = "ATTRIBUTE") [ Required ];

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

/// string
/// <p>
/// Who maintains system namespace?
Property responsible As %String(MAXLEN = 1000000, XMLNAME = "responsible", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// e.g. 
/// driver, 
///  provider, 
///  patient, 
/// bank etc.
/// <p>
/// identifier-type is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in identifier-type, 
/// you may formally EXTEND identifier-type to add codes to it.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// markdown
/// <p>
/// Natural language description of the naming system.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// UsageContext
/// <p>
/// Context the content is intended to support.
Property useContext As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.UsageContext(XMLNAME = "useContext", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Intended jurisdiction for naming system (if applicable)
/// <p>
/// jurisdiction is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in jurisdiction, 
/// you may formally EXTEND jurisdiction to add codes to it.
Property jurisdiction As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "jurisdiction", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// How/where is it used.
Property usage As %String(MAXLEN = 1000000, XMLNAME = "usage", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Unique identifiers used for system.
Property uniqueId As list Of HS.FHIR.DTL.vSTU3.Model.Element.NamingSystem.uniqueId(XMLNAME = "uniqueId", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Use this instead.
/// <p>
/// NamingSystem
Property replacedBy As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "replacedBy", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "NamingSystem";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "NamingSystem";

}
