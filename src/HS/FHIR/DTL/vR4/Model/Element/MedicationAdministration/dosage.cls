/// Details of how medication was taken.
Class HS.FHIR.DTL.vR4.Model.Element.MedicationAdministration.dosage Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Free text dosage instructions e.g. 
/// SIG.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Body site administered to.
/// <p>
/// any FHIR4 code may be used; 
/// approach-site-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property site As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "site", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Path of substance into body.
/// <p>
/// any FHIR4 code may be used; 
/// route-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property route As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "route", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// How drug was administered.
/// <p>
/// any FHIR4 code may be used; 
/// administration-method-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property method As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "method", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// Amount of medication per dose.
Property dose As HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "dose", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// Dose quantity per unit of time.
Property rateQuantity As HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "rateQuantity", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// Dose quantity per unit of time.
Property rateRatio As HS.FHIR.DTL.vR4.Model.Datatype.Ratio(XMLNAME = "rateRatio", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationAdministration.dosage";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicationAdministration.dosage";

}
