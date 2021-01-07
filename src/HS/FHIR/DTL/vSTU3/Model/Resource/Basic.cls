/// Basic is used for handling concepts not yet defined in FHIR, 
/// narrative-only resources that don't map to an existing resource, 
/// and custom resources not appropriate for inclusion in the FHIR specification.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Basic Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business identifier.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Kind of Resource.
/// <p>
/// any FHIR3 code may be used; 
/// basic-resource-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Identifies the focus of this resource.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// When created.
Property created As %String(MAXLEN = 1000000, XMLNAME = "created", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who created.
/// <p>
/// Practitioner | Patient | RelatedPerson
Property author As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "author", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Basic";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Basic";

}
