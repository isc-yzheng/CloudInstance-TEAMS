/// Record details about the anatomical location of a specimen or body part. 
/// This resource may be used when a coded concept does not provide the necessary detail needed for the use case.
Class HS.FHIR.DTL.vSTU3.Model.Resource.BodySite Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Bodysite identifier.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Whether this body site record is in active use.
Property active As %Boolean(XMLNAME = "active", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Named anatomical location.
/// <p>
/// any FHIR3 code may be used; 
/// body-site shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Modification to location code.
/// <p>
/// any FHIR3 code may be used; 
/// bodysite-relative-location shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property qualifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "qualifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Anatomical location description.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// Attachment
/// <p>
/// Attached images.
Property image As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "image", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who this is about.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "BodySite";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "BodySite";

}
