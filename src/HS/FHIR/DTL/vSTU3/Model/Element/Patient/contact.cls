/// A contact party (e.g. 
/// guardian, 
/// partner, 
/// friend) for the patient.
Class HS.FHIR.DTL.vSTU3.Model.Element.Patient.contact Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// The kind of relationship.
/// <p>
/// v2-0131 is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in v2-0131, 
/// you may formally EXTEND v2-0131 to add codes to it.
Property relationship As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "relationship", XMLPROJECTION = "ELEMENT");

/// HumanName
/// <p>
/// A name associated with the contact person.
Property name As HS.FHIR.DTL.vSTU3.Model.Datatype.HumanName(XMLNAME = "name", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// A contact detail for the person.
Property telecom As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.ContactPoint(XMLNAME = "telecom", XMLPROJECTION = "ELEMENT");

/// Address
/// <p>
/// Address for the contact person.
Property address As HS.FHIR.DTL.vSTU3.Model.Datatype.Address(XMLNAME = "address", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// male | female | other | unknown
/// <p>
/// administrative-gender is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend administrative-gender and you may NOT use codes from other ValueSets.
Property gender As %String(MAXLEN = 1000000, XMLNAME = "gender", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Organization that is associated with the contact.
/// <p>
/// Organization
Property organization As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "organization", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// The period during which this contact person or organization is valid to be contacted relating to this patient.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Patient.contact";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Patient.contact";

}
