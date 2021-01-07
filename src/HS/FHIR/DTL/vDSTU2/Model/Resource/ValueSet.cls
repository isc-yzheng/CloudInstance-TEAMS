/// A set of codes drawn from one or more code systems.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.ValueSet Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Globally unique logical identifier for  value set.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Additional identifier for the value set (e.g. 
/// HL7 v2 / CDA)
Property identifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Logical identifier for this version of the value set.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Informal name for this value set.
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
Property contact As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ValueSet.contact(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date for given status.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// date
/// <p>
/// Fixed date for all referenced code systems and value sets.
Property lockedDate As %String(MAXLEN = 1000000, XMLNAME = "lockedDate", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Human language description of the value set.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Content intends to support these contexts.
/// <p>
/// use-context is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in use-context, 
/// you may formally EXTEND use-context to add codes to it.
Property useContext As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "useContext", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Indicates whether or not any change to the content logical definition may occur.
Property immutable As %Boolean(XMLNAME = "immutable", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Why needed.
Property requirements As %String(MAXLEN = 1000000, XMLNAME = "requirements", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Use and/or publishing restrictions.
Property copyright As %String(MAXLEN = 1000000, XMLNAME = "copyright", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Whether this is intended to be used with an extensible binding.
Property extensible As %Boolean(XMLNAME = "extensible", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// An inline code system, 
/// which is part of this value set.
Property codeSystem As HS.FHIR.DTL.vDSTU2.Model.Element.ValueSet.codeSystem(XMLNAME = "codeSystem", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// When value set includes codes from elsewhere.
Property compose As HS.FHIR.DTL.vDSTU2.Model.Element.ValueSet.compose(XMLNAME = "compose", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Used when the value set is "expanded"
Property expansion As HS.FHIR.DTL.vDSTU2.Model.Element.ValueSet.expansion(XMLNAME = "expansion", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet";

}
