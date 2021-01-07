/// Stratification results.
Class HS.FHIR.DTL.vR4.Model.Element.MeasureReport.group.stratifier Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// What stratifier of the group.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property code As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Stratum results, 
/// one for each unique value, 
/// or set of values, 
/// in the stratifier, 
/// or stratifier components.
Property stratum As list Of HS.FHIR.DTL.vR4.Model.Element.MeasureReport.group.stratifier.stratum(XMLNAME = "stratum", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MeasureReport.group.stratifier";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MeasureReport.group.stratifier";

}
