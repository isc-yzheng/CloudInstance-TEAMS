/// A generic person record.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Person Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// A human identifier for this person.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// HumanName
/// <p>
/// A name associated with the person.
Property name As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.HumanName(XMLNAME = "name", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// A contact detail for the person.
Property telecom As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.ContactPoint(XMLNAME = "telecom", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// male | female | other | unknown
/// <p>
/// administrative-gender is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend administrative-gender and you may NOT use codes from other ValueSets.
Property gender As %String(MAXLEN = 1000000, XMLNAME = "gender", XMLPROJECTION = "ATTRIBUTE");

/// date
/// <p>
/// The date on which the person was born.
Property birthDate As %String(MAXLEN = 1000000, XMLNAME = "birthDate", XMLPROJECTION = "ATTRIBUTE");

/// Address
/// <p>
/// One or more addresses for the person.
Property address As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Address(XMLNAME = "address", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Image of the person.
Property photo As HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment(XMLNAME = "photo", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The organization that is the custodian of the person record.
/// <p>
/// Organization
Property managingOrganization As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "managingOrganization", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// This person's record is in active use.
Property active As %Boolean(XMLNAME = "active", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Link to a resource that concerns the same actual person.
Property link As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Person.link(XMLNAME = "link", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Person";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Person";

}
