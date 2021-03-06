/// The path by which the pharmaceutical product is taken into or makes contact with the body.
Class HS.FHIR.DTL.vR4.Model.Element.MedicinalProductPharmaceutical.routeOfAdministration Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Coded expression for the route.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property code As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// Quantity
/// <p>
/// The first dose (dose quantity) administered in humans can be specified, 
/// for a product under investigation, 
/// using a numerical value and its unit of measurement.
Property firstDose As HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "firstDose", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// The maximum single dose that can be administered as per the protocol of a clinical trial can be specified using a numerical value and its unit of measurement.
Property maxSingleDose As HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "maxSingleDose", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// The maximum dose per day (maximum dose quantity to be administered in any one 24-h period) that can be administered as per the protocol referenced in the clinical trial authorisation.
Property maxDosePerDay As HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "maxDosePerDay", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// The maximum dose per treatment period that can be administered as per the protocol referenced in the clinical trial authorisation.
Property maxDosePerTreatmentPeriod As HS.FHIR.DTL.vR4.Model.Datatype.Ratio(XMLNAME = "maxDosePerTreatmentPeriod", XMLPROJECTION = "ELEMENT");

/// Duration
/// <p>
/// The maximum treatment period during which an Investigational Medicinal Product can be administered as per the protocol referenced in the clinical trial authorisation.
Property maxTreatmentPeriod As HS.FHIR.DTL.vR4.Model.Datatype.Duration(XMLNAME = "maxTreatmentPeriod", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// A species for which this route applies.
Property targetSpecies As list Of HS.FHIR.DTL.vR4.Model.Element.MedicinalProductPharmaceutical.routeOfAdministration.targetSpecies(XMLNAME = "targetSpecies", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicinalProductPharmaceutical.routeOfAdministration";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicinalProductPharmaceutical.routeOfAdministration";

}
