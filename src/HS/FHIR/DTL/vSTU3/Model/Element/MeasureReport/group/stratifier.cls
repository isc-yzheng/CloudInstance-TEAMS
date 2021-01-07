/// Stratification results.
Class HS.FHIR.DTL.vSTU3.Model.Element.MeasureReport.group.stratifier Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// What stratifier of the group.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Stratum results, 
/// one for each unique value in the stratifier.
Property stratum As list Of HS.FHIR.DTL.vSTU3.Model.Element.MeasureReport.group.stratifier.stratum(XMLNAME = "stratum", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MeasureReport.group.stratifier";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MeasureReport.group.stratifier";

}
