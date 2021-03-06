/// Specific and identified anatomical structure.
Class HS.FHIR.DTL.vR4.Model.Resource.BodyStructure Extends HS.FHIR.DTL.vR4.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Bodystructure identifier.
Property identifier As list Of HS.FHIR.DTL.vR4.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Whether this record is in active use.
Property active As %Boolean(XMLNAME = "active", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Kind of Structure.
/// <p>
/// any FHIR4 code may be used; 
/// bodystructure-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property morphology As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "morphology", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Body site.
/// <p>
/// any FHIR4 code may be used; 
/// body-site shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property location As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Body site modifier.
/// <p>
/// any FHIR4 code may be used; 
/// bodystructure-relative-location shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property locationQualifier As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "locationQualifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Text description.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// Attachment
/// <p>
/// Attached images.
Property image As list Of HS.FHIR.DTL.vR4.Model.Datatype.Attachment(XMLNAME = "image", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who this is about.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "BodyStructure";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "BodyStructure";

}
