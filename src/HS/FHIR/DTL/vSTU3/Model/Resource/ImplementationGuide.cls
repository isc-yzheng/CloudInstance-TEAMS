/// A set of rules of how FHIR is used to solve a particular problem. 
/// This resource is used to gather all the parts of an implementation guide into a logical whole and to publish a computable definition of all the parts.
Class HS.FHIR.DTL.vSTU3.Model.Resource.ImplementationGuide Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Logical URI to reference this implementation guide (globally unique)
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Business version of the implementation guide.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for this implementation guide (computer friendly)
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE") [ Required ];

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

/// ContactDetail
/// <p>
/// Contact details for the publisher.
Property contact As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.ContactDetail(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// markdown
/// <p>
/// Natural language description of the implementation guide.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// UsageContext
/// <p>
/// Context the content is intended to support.
Property useContext As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.UsageContext(XMLNAME = "useContext", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Intended jurisdiction for implementation guide (if applicable)
/// <p>
/// jurisdiction is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in jurisdiction, 
/// you may formally EXTEND jurisdiction to add codes to it.
Property jurisdiction As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "jurisdiction", XMLPROJECTION = "ELEMENT");

/// markdown
/// <p>
/// Use and/or publishing restrictions.
Property copyright As %String(MAXLEN = 1000000, XMLNAME = "copyright", XMLPROJECTION = "ATTRIBUTE");

/// id
/// <p>
/// FHIR Version this Implementation Guide targets.
Property fhirVersion As %String(MAXLEN = 1000000, XMLNAME = "fhirVersion", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Another Implementation guide this depends on.
Property dependency As list Of HS.FHIR.DTL.vSTU3.Model.Element.ImplementationGuide.dependency(XMLNAME = "dependency", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Group of resources as used in .page.package.
Property package As list Of HS.FHIR.DTL.vSTU3.Model.Element.ImplementationGuide.package(XMLNAME = "package", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Profiles that apply globally.
Property global As list Of HS.FHIR.DTL.vSTU3.Model.Element.ImplementationGuide.global(XMLNAME = "global", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Image, 
/// css, 
/// script, 
/// etc.
Property binary As list Of %String(MAXLEN = 1000000, XMLNAME = "binary", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Page/Section in the Guide.
Property page As HS.FHIR.DTL.vSTU3.Model.Element.ImplementationGuide.page(XMLNAME = "page", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImplementationGuide";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImplementationGuide";

}
