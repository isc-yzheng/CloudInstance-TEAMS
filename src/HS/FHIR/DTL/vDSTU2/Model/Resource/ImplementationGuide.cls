/// A set of rules about how FHIR is used.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.ImplementationGuide Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Absolute URL used to reference this Implementation Guide.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Logical id for this version of the Implementation Guide.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Informal name for this Implementation Guide.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE") [ Required ];

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
Property contact As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ImplementationGuide.contact(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date for this version of the Implementation Guide.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Natural language description of the Implementation Guide.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// The implementation guide is intended to support these contexts.
/// <p>
/// use-context is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in use-context, 
/// you may formally EXTEND use-context to add codes to it.
Property useContext As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "useContext", XMLPROJECTION = "ELEMENT");

/// string
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
Property dependency As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ImplementationGuide.dependency(XMLNAME = "dependency", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Group of resources as used in .page.package.
Property package As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ImplementationGuide.package(XMLNAME = "package", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// Profiles that apply globally.
Property global As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ImplementationGuide.global(XMLNAME = "global", XMLPROJECTION = "ELEMENT");

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
Property page As HS.FHIR.DTL.vDSTU2.Model.Element.ImplementationGuide.page(XMLNAME = "page", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImplementationGuide";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImplementationGuide";

}
