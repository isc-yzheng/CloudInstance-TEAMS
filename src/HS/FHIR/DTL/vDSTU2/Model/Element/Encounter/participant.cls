/// List of participants involved in the encounter.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Encounter.participant Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Role of participant in encounter.
/// <p>
/// encounter-participant-type is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in encounter-participant-type, 
/// you may formally EXTEND encounter-participant-type to add codes to it.
Property type As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Period of time during the encounter participant was present.
Property period As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Persons involved in the encounter other than the patient.
/// <p>
/// Practitioner | RelatedPerson
Property individual As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "individual", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Encounter.participant";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Encounter.participant";

}
