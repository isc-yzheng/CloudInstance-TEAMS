/// System of unique identification.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.NamingSystem Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Human-readable label.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// draft | active | retired
/// <p>
/// conformance-resource-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend conformance-resource-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// codesystem | identifier | root
/// <p>
/// namingsystem-type is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend namingsystem-type and you may NOT use codes from other ValueSets.
Property kind As %String(MAXLEN = 1000000, XMLNAME = "kind", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Name of the publisher (Organization or individual)
Property publisher As %String(MAXLEN = 1000000, XMLNAME = "publisher", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Contact details of the publisher.
Property contact As list Of HS.FHIR.DTL.vDSTU2.Model.Element.NamingSystem.contact(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Who maintains system namespace?
Property responsible As %String(MAXLEN = 1000000, XMLNAME = "responsible", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Publication Date(/time)
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// e.g. 
/// driver, 
///  provider, 
///  patient, 
/// bank etc.
/// <p>
/// identifier-type is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in identifier-type, 
/// you may formally EXTEND identifier-type to add codes to it.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// What does naming system identify?
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
/// How/where is it used.
Property usage As %String(MAXLEN = 1000000, XMLNAME = "usage", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Unique identifiers used for system.
Property uniqueId As list Of HS.FHIR.DTL.vDSTU2.Model.Element.NamingSystem.uniqueId(XMLNAME = "uniqueId", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Use this instead.
/// <p>
/// NamingSystem
Property replacedBy As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "replacedBy", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "NamingSystem";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "NamingSystem";

}
