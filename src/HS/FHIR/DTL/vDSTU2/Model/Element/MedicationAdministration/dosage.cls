/// Details of how medication was taken.
Class HS.FHIR.DTL.vDSTU2.Model.Element.MedicationAdministration.dosage Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Dosage Instructions.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Body site administered to.
/// <p>
/// any FHIR2 code may be used; 
/// approach-site-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property siteCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "siteCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Body site administered to.
/// <p>
/// BodySite.
Property siteReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "siteReference", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Path of substance into body.
/// <p>
/// any FHIR2 code may be used; 
/// route-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property route As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "route", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// How drug was administered.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property method As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "method", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// Amount administered in one dose.
Property quantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Dose quantity per unit of time.
Property rateRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "rateRange", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// Dose quantity per unit of time.
Property rateRatio As HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio(XMLNAME = "rateRatio", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationAdministration.dosage";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicationAdministration.dosage";

}
