/// Measure results for each group.
Class HS.FHIR.DTL.vSTU3.Model.Element.MeasureReport.group Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// What group of the measure.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// The populations in the group.
Property population As list Of HS.FHIR.DTL.vSTU3.Model.Element.MeasureReport.group.population(XMLNAME = "population", XMLPROJECTION = "ELEMENT");

/// decimal
/// <p>
/// What score this group achieved.
Property measureScore As %Decimal(XMLNAME = "measureScore", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Stratification results.
Property stratifier As list Of HS.FHIR.DTL.vSTU3.Model.Element.MeasureReport.group.stratifier(XMLNAME = "stratifier", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MeasureReport.group";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MeasureReport.group";

}
