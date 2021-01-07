/// How the medication is/was taken or should be taken.
Class HS.FHIR.DTL.vR4.Model.Element.Dosage Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// integer
/// <p>
/// The order of the dosage instructions.
Property sequence As %Integer(XMLNAME = "sequence", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Free text dosage instructions e.g. 
/// SIG.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Supplemental instruction or warnings to the patient - e.g. 
/// \"with meals\", 
/// \"may cause drowsiness\"
/// <p>
/// any FHIR4 code may be used; 
/// additional-instruction-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property additionalInstruction As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "additionalInstruction", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Patient or consumer oriented instructions.
Property patientInstruction As %String(MAXLEN = 1000000, XMLNAME = "patientInstruction", XMLPROJECTION = "ATTRIBUTE");

/// Timing
/// <p>
/// When medication should be administered.
Property timing As HS.FHIR.DTL.vR4.Model.Datatype.Timing(XMLNAME = "timing", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Take \"as needed\" (for x)
Property asNeededBoolean As %Boolean(XMLNAME = "asNeededBoolean", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Take \"as needed\" (for x)
/// <p>
/// any FHIR4 code may be used; 
/// medication-as-needed-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property asNeededCodeableConcept As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "asNeededCodeableConcept", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Body site to administer to.
/// <p>
/// any FHIR4 code may be used; 
/// approach-site-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property site As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "site", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// How drug should enter body.
/// <p>
/// any FHIR4 code may be used; 
/// route-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property route As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "route", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Technique for administering medication.
/// <p>
/// any FHIR4 code may be used; 
/// administration-method-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property method As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "method", XMLPROJECTION = "ELEMENT");

/// Element
/// <p>
/// Amount of medication administered.
Property doseAndRate As list Of HS.FHIR.DTL.vR4.Model.Element.Dosage.doseAndRate(XMLNAME = "doseAndRate", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// Upper limit on medication per unit of time.
Property maxDosePerPeriod As HS.FHIR.DTL.vR4.Model.Datatype.Ratio(XMLNAME = "maxDosePerPeriod", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// Upper limit on medication per administration.
Property maxDosePerAdministration As HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "maxDosePerAdministration", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// Upper limit on medication per lifetime of the patient.
Property maxDosePerLifetime As HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "maxDosePerLifetime", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Dosage";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Dosage";

}
