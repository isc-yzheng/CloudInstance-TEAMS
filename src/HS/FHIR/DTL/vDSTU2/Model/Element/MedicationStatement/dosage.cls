/// Details of how medication was taken.
Class HS.FHIR.DTL.vDSTU2.Model.Element.MedicationStatement.dosage Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Reported dosage information.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

/// Timing
/// <p>
/// When/how often was medication taken.
Property timing As HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing(XMLNAME = "timing", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Take "as needed" (for x)
Property asNeededBoolean As %Boolean(XMLNAME = "asNeededBoolean", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Take "as needed" (for x)
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property asNeededCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "asNeededCodeableConcept", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Where (on body) medication is/was administered.
/// <p>
/// any FHIR2 code may be used; 
/// approach-site-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property siteCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "siteCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Where (on body) medication is/was administered.
/// <p>
/// BodySite.
Property siteReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "siteReference", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// How the medication entered the body.
/// <p>
/// any FHIR2 code may be used; 
/// route-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property route As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "route", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Technique used to administer medication.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property method As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "method", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// Amount administered in one dose.
Property quantityQuantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "quantityQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Amount administered in one dose.
Property quantityRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "quantityRange", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Dose quantity per unit of time.
Property rateRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "rateRange", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// Dose quantity per unit of time.
Property rateRatio As HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio(XMLNAME = "rateRatio", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// Maximum dose that was consumed per unit of time.
Property maxDosePerPeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio(XMLNAME = "maxDosePerPeriod", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationStatement.dosage";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicationStatement.dosage";

}
