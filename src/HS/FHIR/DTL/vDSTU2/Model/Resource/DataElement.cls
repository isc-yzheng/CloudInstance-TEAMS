/// Resource data element.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.DataElement Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Globally unique logical id for data element.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Logical id to reference this data element.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Logical id for this version of the data element.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Descriptive label for this element definition.
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
/// Name of the publisher (Organization or individual)
Property publisher As %String(MAXLEN = 1000000, XMLNAME = "publisher", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Contact details of the publisher.
Property contact As list Of HS.FHIR.DTL.vDSTU2.Model.Element.DataElement.contact(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date for this version of the data element.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

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
/// Use and/or publishing restrictions.
Property copyright As %String(MAXLEN = 1000000, XMLNAME = "copyright", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// comparable | fully-specified | equivalent | convertable | scaleable | flexible
/// <p>
/// dataelement-stringency is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend dataelement-stringency and you may NOT use codes from other ValueSets.
Property stringency As %String(MAXLEN = 1000000, XMLNAME = "stringency", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// External specification mapped to.
Property mapping As list Of HS.FHIR.DTL.vDSTU2.Model.Element.DataElement.mapping(XMLNAME = "mapping", XMLPROJECTION = "ELEMENT");

/// ElementDefinition
/// <p>
/// Definition of element.
Property element As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ElementDefinition(XMLNAME = "element", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DataElement";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DataElement";

}
