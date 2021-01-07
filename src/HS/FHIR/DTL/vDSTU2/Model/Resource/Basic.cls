/// Resource for non-supported content.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Basic Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business identifier.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Kind of Resource.
/// <p>
/// any FHIR2 code may be used; 
/// basic-resource-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Identifies the focus of this resource.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who created.
/// <p>
/// Practitioner | Patient | RelatedPerson
Property author As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "author", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// When created.
Property created As %String(MAXLEN = 1000000, XMLNAME = "created", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Basic";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Basic";

}
