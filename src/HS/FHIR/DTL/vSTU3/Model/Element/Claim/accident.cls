/// Details about an accident.
Class HS.FHIR.DTL.vSTU3.Model.Element.Claim.accident Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// date
/// <p>
/// When the accident occurred.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// The nature of the accident.
/// <p>
/// any FHIR3 code may be used; 
/// v3-ActCode shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// Address
/// <p>
///  Accident Place.
Property locationAddress As HS.FHIR.DTL.vSTU3.Model.Datatype.Address(XMLNAME = "locationAddress", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
///  Accident Place.
/// <p>
/// Location.
Property locationReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "locationReference", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Claim.accident";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Claim.accident";

}
