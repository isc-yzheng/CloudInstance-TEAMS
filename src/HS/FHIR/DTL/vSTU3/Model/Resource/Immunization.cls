/// Describes the event of a patient being administered a vaccination or a record of a vaccination as reported by a patient, 
/// a clinician or another party and may include vaccine reaction information and what vaccination protocol was followed.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Immunization Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business identifier.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// completed | entered-in-error
/// <p>
/// immunization-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend immunization-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// Flag for whether immunization was given.
Property notGiven As %Boolean(XMLNAME = "notGiven", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Vaccine product administered.
/// <p>
/// any FHIR3 code may be used; 
/// vaccine-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property vaccineCode As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "vaccineCode", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Who was immunized.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Encounter administered as part of.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Vaccination administration date.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Indicates context the data was recorded in.
Property primarySource As %Boolean(XMLNAME = "primarySource", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Indicates the source of a secondarily reported record.
/// <p>
/// any FHIR3 code may be used; 
/// immunization-origin shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reportOrigin As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reportOrigin", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Where vaccination occurred.
/// <p>
/// Location
Property location As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Vaccine manufacturer.
/// <p>
/// Organization
Property manufacturer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "manufacturer", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Vaccine lot number.
Property lotNumber As %String(MAXLEN = 1000000, XMLNAME = "lotNumber", XMLPROJECTION = "ATTRIBUTE");

/// date
/// <p>
/// Vaccine expiration date.
Property expirationDate As %String(MAXLEN = 1000000, XMLNAME = "expirationDate", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Body site vaccine  was administered.
/// <p>
/// any FHIR3 code may be used; 
/// immunization-site shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property site As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "site", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// How vaccine entered body.
/// <p>
/// any FHIR3 code may be used; 
/// immunization-route shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property route As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "route", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// Amount of vaccine administered.
Property doseQuantity As HS.FHIR.DTL.vSTU3.Model.Datatype.SimpleQuantity(XMLNAME = "doseQuantity", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Who performed event.
Property practitioner As list Of HS.FHIR.DTL.vSTU3.Model.Element.Immunization.practitioner(XMLNAME = "practitioner", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Vaccination notes.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Administration/non-administration reasons.
Property explanation As HS.FHIR.DTL.vSTU3.Model.Element.Immunization.explanation(XMLNAME = "explanation", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Details of a reaction that follows immunization.
Property reaction As list Of HS.FHIR.DTL.vSTU3.Model.Element.Immunization.reaction(XMLNAME = "reaction", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// What protocol was followed.
Property vaccinationProtocol As list Of HS.FHIR.DTL.vSTU3.Model.Element.Immunization.vaccinationProtocol(XMLNAME = "vaccinationProtocol", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Immunization";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Immunization";

}
