/// Stratum results, 
/// one for each unique value, 
/// or set of values, 
/// in the stratifier, 
/// or stratifier components.
Class HS.FHIR.DTL.vR4.Model.Element.MeasureReport.group.stratifier.stratum Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// The stratum value, 
/// e.g. 
/// male.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property value As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "value", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Stratifier component values.
Property component As list Of HS.FHIR.DTL.vR4.Model.Element.MeasureReport.group.stratifier.stratum.component(XMLNAME = "component", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Population results in this stratum.
Property population As list Of HS.FHIR.DTL.vR4.Model.Element.MeasureReport.group.stratifier.stratum.population(XMLNAME = "population", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// What score this stratum achieved.
Property measureScore As HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "measureScore", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MeasureReport.group.stratifier.stratum";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MeasureReport.group.stratifier.stratum";

}
