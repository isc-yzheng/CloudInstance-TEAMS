/// Contact for the organization for a certain purpose.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Organization.contact Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// The type of contact.
/// <p>
/// contactentity-type is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in contactentity-type, 
/// you may formally EXTEND contactentity-type to add codes to it.
Property purpose As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "purpose", XMLPROJECTION = "ELEMENT");

/// HumanName
/// <p>
/// A name associated with the contact.
Property name As HS.FHIR.DTL.vDSTU2.Model.Datatype.HumanName(XMLNAME = "name", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// Contact details (telephone, 
/// email, 
/// etc.)  for a contact.
Property telecom As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.ContactPoint(XMLNAME = "telecom", XMLPROJECTION = "ELEMENT");

/// Address
/// <p>
/// Visiting or postal addresses for the contact.
Property address As HS.FHIR.DTL.vDSTU2.Model.Datatype.Address(XMLNAME = "address", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Organization.contact";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Organization.contact";

}
