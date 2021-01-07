/// Immunization event information.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Immunization Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business identifier.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// in-progress | on-hold | completed | entered-in-error | stopped
/// <p>
/// medication-admin-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend medication-admin-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// dateTime
/// <p>
/// Vaccination administration date.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Vaccine product administered.
/// <p>
/// any FHIR2 code may be used; 
/// vaccine-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property vaccineCode As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "vaccineCode", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Who was immunized.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// boolean
/// <p>
/// Flag for whether immunization was given.
Property wasNotGiven As %Boolean(XMLNAME = "wasNotGiven", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// Indicates a self-reported record.
Property reported As %Boolean(XMLNAME = "reported", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Who administered vaccine.
/// <p>
/// Practitioner
Property performer As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "performer", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who ordered vaccination.
/// <p>
/// Practitioner
Property requester As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "requester", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Encounter administered as part of.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Vaccine manufacturer.
/// <p>
/// Organization
Property manufacturer As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "manufacturer", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Where vaccination occurred.
/// <p>
/// Location
Property location As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

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
/// any FHIR2 code may be used; 
/// immunization-site shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property site As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "site", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// How vaccine entered body.
/// <p>
/// any FHIR2 code may be used; 
/// immunization-route shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property route As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "route", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// Amount of vaccine administered.
Property doseQuantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "doseQuantity", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Vaccination notes.
Property note As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Administration/non-administration reasons.
Property explanation As HS.FHIR.DTL.vDSTU2.Model.Element.Immunization.explanation(XMLNAME = "explanation", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Details of a reaction that follows immunization.
Property reaction As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Immunization.reaction(XMLNAME = "reaction", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// What protocol was followed.
Property vaccinationProtocol As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Immunization.vaccinationProtocol(XMLNAME = "vaccinationProtocol", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Immunization";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Immunization";

}
