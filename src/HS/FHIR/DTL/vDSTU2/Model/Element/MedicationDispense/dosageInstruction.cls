/// Medicine administration instructions to the patient/caregiver.
Class HS.FHIR.DTL.vDSTU2.Model.Element.MedicationDispense.dosageInstruction Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Dosage Instructions.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// E.g. 
/// "Take with food"
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property additionalInstructions As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "additionalInstructions", XMLPROJECTION = "ELEMENT");

/// Timing
/// <p>
/// When medication should be administered.
Property timing As HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing(XMLNAME = "timing", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Take "as needed" f(or x)
Property asNeededBoolean As %Boolean(XMLNAME = "asNeededBoolean", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Take "as needed" f(or x)
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property asNeededCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "asNeededCodeableConcept", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Body site to administer to.
/// <p>
/// any FHIR2 code may be used; 
/// approach-site-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property siteCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "siteCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Body site to administer to.
/// <p>
/// BodySite.
Property siteReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "siteReference", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// How drug should enter body.
/// <p>
/// any FHIR2 code may be used; 
/// route-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property route As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "route", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Technique for administering medication.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property method As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "method", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// Amount of medication per dose.
Property doseQuantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "doseQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Amount of medication per dose.
Property doseRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "doseRange", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Amount of medication per unit of time.
Property rateRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "rateRange", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// Amount of medication per unit of time.
Property rateRatio As HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio(XMLNAME = "rateRatio", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// Upper limit on medication per unit of time.
Property maxDosePerPeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio(XMLNAME = "maxDosePerPeriod", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationDispense.dosageInstruction";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicationDispense.dosageInstruction";

}
