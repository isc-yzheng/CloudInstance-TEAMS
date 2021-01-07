/// Details of an accident.
Class HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.accident Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// date
/// <p>
/// When the accident occurred.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// The nature of the accident.
/// <p>
/// v3-ActCode is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend v3-ActCode and you may NOT use codes from other ValueSets.
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

Parameter XMLNAME = "ExplanationOfBenefit.accident";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExplanationOfBenefit.accident";

}
