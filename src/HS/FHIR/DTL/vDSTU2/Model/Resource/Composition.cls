/// A set of resources composed into a single coherent clinical statement with clinical attestation.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Composition Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Logical identifier of composition (version-independent)
Property identifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Composition editing time.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Kind of composition (LOINC if possible)
/// <p>
/// doc-typecodes is the PREFERRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in doc-typecodes, 
/// you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Categorization of Composition.
/// <p>
/// any FHIR2 code may be used; 
/// doc-classcodes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property class As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "class", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Human Readable name/title.
Property title As %String(MAXLEN = 1000000, XMLNAME = "title", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// preliminary | final | amended | entered-in-error
/// <p>
/// composition-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend composition-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// As defined by affinity domain.
/// <p>
/// v3-Confidentiality is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend v3-Confidentiality and you may NOT use codes from other ValueSets.
Property confidentiality As %String(MAXLEN = 1000000, XMLNAME = "confidentiality", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who and/or what the composition is about.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Who and/or what authored the composition.
/// <p>
/// Practitioner | Device | Patient | RelatedPerson
Property author As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "author", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// Attests to accuracy of composition.
Property attester As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Composition.attester(XMLNAME = "attester", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Organization which maintains the composition.
/// <p>
/// Organization
Property custodian As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "custodian", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// The clinical service(s) being documented.
Property event As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Composition.event(XMLNAME = "event", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Context of the Composition.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Composition is broken into sections.
Property section As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Composition.section(XMLNAME = "section", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Composition";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Composition";

}
