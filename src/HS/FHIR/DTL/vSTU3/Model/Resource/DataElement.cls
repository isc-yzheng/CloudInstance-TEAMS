/// The formal description of a single piece of information that can be gathered and reported.
Class HS.FHIR.DTL.vSTU3.Model.Resource.DataElement Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Logical URI to reference this data element (globally unique)
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Additional identifier for the data element.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Business version of the data element.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

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

/// string
/// <p>
/// Name for this data element (computer friendly)
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for this data element (human friendly)
Property title As %String(MAXLEN = 1000000, XMLNAME = "title", XMLPROJECTION = "ATTRIBUTE");

/// ContactDetail
/// <p>
/// Contact details for the publisher.
Property contact As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.ContactDetail(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// UsageContext
/// <p>
/// Context the content is intended to support.
Property useContext As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.UsageContext(XMLNAME = "useContext", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Intended jurisdiction for data element (if applicable)
/// <p>
/// jurisdiction is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in jurisdiction, 
/// you may formally EXTEND jurisdiction to add codes to it.
Property jurisdiction As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "jurisdiction", XMLPROJECTION = "ELEMENT");

/// markdown
/// <p>
/// Use and/or publishing restrictions.
Property copyright As %String(MAXLEN = 1000000, XMLNAME = "copyright", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// comparable | fully-specified | equivalent | convertable | scaleable | flexible
/// <p>
/// dataelement-stringency is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend dataelement-stringency and you may NOT use codes from other ValueSets.
Property stringency As %String(MAXLEN = 1000000, XMLNAME = "stringency", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// External specification mapped to.
Property mapping As list Of HS.FHIR.DTL.vSTU3.Model.Element.DataElement.mapping(XMLNAME = "mapping", XMLPROJECTION = "ELEMENT");

/// ElementDefinition
/// <p>
/// Definition of element.
Property element As list Of HS.FHIR.DTL.vSTU3.Model.Element.ElementDefinition(XMLNAME = "element", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DataElement";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DataElement";

}
