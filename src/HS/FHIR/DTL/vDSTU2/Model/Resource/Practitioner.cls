/// A person with a  formal responsibility in the provisioning of healthcare or related services.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Practitioner Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// A identifier for the person as this agent.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Whether this practitioner's record is in active use.
Property active As %Boolean(XMLNAME = "active", XMLPROJECTION = "ATTRIBUTE");

/// HumanName
/// <p>
/// A name associated with the person.
Property name As HS.FHIR.DTL.vDSTU2.Model.Datatype.HumanName(XMLNAME = "name", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// A contact detail for the practitioner.
Property telecom As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.ContactPoint(XMLNAME = "telecom", XMLPROJECTION = "ELEMENT");

/// Address
/// <p>
/// Where practitioner can be found/visited.
Property address As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Address(XMLNAME = "address", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// male | female | other | unknown
/// <p>
/// administrative-gender is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend administrative-gender and you may NOT use codes from other ValueSets.
Property gender As %String(MAXLEN = 1000000, XMLNAME = "gender", XMLPROJECTION = "ATTRIBUTE");

/// date
/// <p>
/// The date  on which the practitioner was born.
Property birthDate As %String(MAXLEN = 1000000, XMLNAME = "birthDate", XMLPROJECTION = "ATTRIBUTE");

/// Attachment
/// <p>
/// Image of the person.
Property photo As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment(XMLNAME = "photo", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Roles/organizations the practitioner is associated with.
Property practitionerRole As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Practitioner.practitionerRole(XMLNAME = "practitionerRole", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Qualifications obtained by training and certification.
Property qualification As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Practitioner.qualification(XMLNAME = "qualification", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// A language the practitioner is able to use in patient communication.
/// <p>
/// Language RFC 5646 is the REQUIRED IETF specification for the FHIR2 code values that may be used.
Property communication As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "communication", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Practitioner";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Practitioner";

}
