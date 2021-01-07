/// A person who is directly or indirectly involved in the provisioning of healthcare.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Practitioner Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// A identifier for the person as this agent.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Whether this practitioner's record is in active use.
Property active As %Boolean(XMLNAME = "active", XMLPROJECTION = "ATTRIBUTE");

/// HumanName
/// <p>
/// The name(s) associated with the practitioner.
Property name As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.HumanName(XMLNAME = "name", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// A contact detail for the practitioner (that apply to all roles)
Property telecom As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.ContactPoint(XMLNAME = "telecom", XMLPROJECTION = "ELEMENT");

/// Address
/// <p>
/// Address(es) of the practitioner that are not role specific (typically home address)
Property address As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Address(XMLNAME = "address", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// male | female | other | unknown
/// <p>
/// administrative-gender is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend administrative-gender and you may NOT use codes from other ValueSets.
Property gender As %String(MAXLEN = 1000000, XMLNAME = "gender", XMLPROJECTION = "ATTRIBUTE");

/// date
/// <p>
/// The date  on which the practitioner was born.
Property birthDate As %String(MAXLEN = 1000000, XMLNAME = "birthDate", XMLPROJECTION = "ATTRIBUTE");

/// Attachment
/// <p>
/// Image of the person.
Property photo As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "photo", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Qualifications obtained by training and certification.
Property qualification As list Of HS.FHIR.DTL.vSTU3.Model.Element.Practitioner.qualification(XMLNAME = "qualification", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// A language the practitioner is able to use in patient communication.
/// <p>
/// languages is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in languages, 
/// you may formally EXTEND languages to add codes to it.
Property communication As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "communication", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Practitioner";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Practitioner";

}
