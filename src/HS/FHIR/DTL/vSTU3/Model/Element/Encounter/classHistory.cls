/// List of past encounter classes.
Class HS.FHIR.DTL.vSTU3.Model.Element.Encounter.classHistory Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// Code values that qualify the encounter (AMB - ambulatory, 
/// EMER - emergency, 
/// etc.)
/// <p>
/// v3-ActEncounterCode is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in v3-ActEncounterCode, 
/// you may formally EXTEND v3-ActEncounterCode to add codes to it.
Property class As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "class", XMLPROJECTION = "ELEMENT") [ Required ];

/// Period
/// <p>
/// The time that the episode was in the specified class.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Encounter.classHistory";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Encounter.classHistory";

}
