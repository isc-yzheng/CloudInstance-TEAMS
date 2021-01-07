/// The populations in the group.
Class HS.FHIR.DTL.vSTU3.Model.Element.MeasureReport.group.population Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Population identifier as defined in the measure.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// initial-population | numerator | numerator-exclusion | denominator | denominator-exclusion | denominator-exception | measure-population | measure-population-exclusion | measure-score
/// <p>
/// measure-population is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in measure-population, 
/// you may formally EXTEND measure-population to add codes to it.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// integer
/// <p>
/// Size of the population.
Property count As %Integer(XMLNAME = "count", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// For patient-list reports, 
/// the patients in this population.
/// <p>
/// List
Property patients As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "patients", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MeasureReport.group.population";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MeasureReport.group.population";

}
