/// A person that is related to a patient, 
/// but who is not a direct target of care.
Class HS.FHIR.DTL.vR4.Model.Resource.RelatedPerson Extends HS.FHIR.DTL.vR4.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// A human identifier for this person.
Property identifier As list Of HS.FHIR.DTL.vR4.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Whether this related person's record is in active use.
Property active As %Boolean(XMLNAME = "active", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// The patient this person is related to.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// The nature of the relationship.
/// <p>
/// relatedperson-relationshiptype is the PREFERRED FHIR4 ValueSet for codes, 
/// but if you need to express meanings not found in relatedperson-relationshiptype, 
/// you may use codes from any ValueSet.
Property relationship As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "relationship", XMLPROJECTION = "ELEMENT");

/// HumanName
/// <p>
/// A name associated with the person.
Property name As list Of HS.FHIR.DTL.vR4.Model.Datatype.HumanName(XMLNAME = "name", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// A contact detail for the person.
Property telecom As list Of HS.FHIR.DTL.vR4.Model.Datatype.ContactPoint(XMLNAME = "telecom", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// male | female | other | unknown
/// <p>
/// administrative-gender|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend administrative-gender|4.0.1 and you may NOT use codes from other ValueSets.
Property gender As %String(MAXLEN = 1000000, XMLNAME = "gender", XMLPROJECTION = "ATTRIBUTE");

/// date
/// <p>
/// The date on which the related person was born.
Property birthDate As %String(MAXLEN = 1000000, XMLNAME = "birthDate", XMLPROJECTION = "ATTRIBUTE");

/// Address
/// <p>
/// Address where the related person can be contacted or visited.
Property address As list Of HS.FHIR.DTL.vR4.Model.Datatype.Address(XMLNAME = "address", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Image of the person.
Property photo As list Of HS.FHIR.DTL.vR4.Model.Datatype.Attachment(XMLNAME = "photo", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Period of time that this relationship is considered valid.
Property period As HS.FHIR.DTL.vR4.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// A language which may be used to communicate with about the patient's health.
Property communication As list Of HS.FHIR.DTL.vR4.Model.Element.RelatedPerson.communication(XMLNAME = "communication", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "RelatedPerson";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "RelatedPerson";

}
