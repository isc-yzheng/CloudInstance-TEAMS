/// Demographics and other administrative information about an individual or animal receiving care or other health-related services.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Patient Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// An identifier for this patient.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Whether this patient's record is in active use.
Property active As %Boolean(XMLNAME = "active", XMLPROJECTION = "ATTRIBUTE");

/// HumanName
/// <p>
/// A name associated with the patient.
Property name As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.HumanName(XMLNAME = "name", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// A contact detail for the individual.
Property telecom As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.ContactPoint(XMLNAME = "telecom", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// male | female | other | unknown
/// <p>
/// administrative-gender is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend administrative-gender and you may NOT use codes from other ValueSets.
Property gender As %String(MAXLEN = 1000000, XMLNAME = "gender", XMLPROJECTION = "ATTRIBUTE");

/// date
/// <p>
/// The date of birth for the individual.
Property birthDate As %String(MAXLEN = 1000000, XMLNAME = "birthDate", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Indicates if the individual is deceased or not.
Property deceasedBoolean As %Boolean(XMLNAME = "deceasedBoolean", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Indicates if the individual is deceased or not.
Property deceasedDateTime As %String(MAXLEN = 1000000, XMLNAME = "deceasedDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Address
/// <p>
/// Addresses for the individual.
Property address As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Address(XMLNAME = "address", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Marital (civil) status of a patient.
/// <p>
/// marital-status is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in marital-status, 
/// you may formally EXTEND marital-status to add codes to it.
Property maritalStatus As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "maritalStatus", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Whether patient is part of a multiple birth.
Property multipleBirthBoolean As %Boolean(XMLNAME = "multipleBirthBoolean", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Whether patient is part of a multiple birth.
Property multipleBirthInteger As %Integer(XMLNAME = "multipleBirthInteger", XMLPROJECTION = "ATTRIBUTE");

/// Attachment
/// <p>
/// Image of the patient.
Property photo As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "photo", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// A contact party (e.g. 
/// guardian, 
/// partner, 
/// friend) for the patient.
Property contact As list Of HS.FHIR.DTL.vSTU3.Model.Element.Patient.contact(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// This patient is known to be an animal (non-human)
Property animal As HS.FHIR.DTL.vSTU3.Model.Element.Patient.animal(XMLNAME = "animal", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// A list of Languages which may be used to communicate with the patient about his or her health.
Property communication As list Of HS.FHIR.DTL.vSTU3.Model.Element.Patient.communication(XMLNAME = "communication", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Patient's nominated primary care provider.
/// <p>
/// Organization | Practitioner
Property generalPractitioner As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "generalPractitioner", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Organization that is the custodian of the patient record.
/// <p>
/// Organization
Property managingOrganization As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "managingOrganization", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Link to another patient resource that concerns the same actual person.
Property link As list Of HS.FHIR.DTL.vSTU3.Model.Element.Patient.link(XMLNAME = "link", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Patient";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Patient";

}
