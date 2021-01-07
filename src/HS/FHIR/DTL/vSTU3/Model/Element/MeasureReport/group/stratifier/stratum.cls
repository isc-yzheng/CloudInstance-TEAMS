/// Stratum results, 
/// one for each unique value in the stratifier.
Class HS.FHIR.DTL.vSTU3.Model.Element.MeasureReport.group.stratifier.stratum Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// The stratum value, 
/// e.g. 
/// male.
Property value As %String(MAXLEN = 1000000, XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// BackboneElement
/// <p>
/// Population results in this stratum.
Property population As list Of HS.FHIR.DTL.vSTU3.Model.Element.MeasureReport.group.stratifier.stratum.population(XMLNAME = "population", XMLPROJECTION = "ELEMENT");

/// decimal
/// <p>
/// What score this stratum achieved.
Property measureScore As %Decimal(XMLNAME = "measureScore", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MeasureReport.group.stratifier.stratum";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MeasureReport.group.stratifier.stratum";

}
