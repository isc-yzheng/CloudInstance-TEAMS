/// What other data should be reported with the measure.
Class HS.FHIR.DTL.vSTU3.Model.Element.Measure.supplementalData Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Identifier, 
/// unique within the measure.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// supplemental-data | risk-adjustment-factor
/// <p>
/// measure-data-usage is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in measure-data-usage, 
/// you may formally EXTEND measure-data-usage to add codes to it.
Property usage As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "usage", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Expression describing additional data to be reported.
Property criteria As %String(MAXLEN = 1000000, XMLNAME = "criteria", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Path to the supplemental data element.
Property path As %String(MAXLEN = 1000000, XMLNAME = "path", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Measure.supplementalData";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Measure.supplementalData";

}
