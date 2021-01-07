/// Medication supply authorization.
Class HS.FHIR.DTL.vDSTU2.Model.Element.MedicationOrder.dispenseRequest Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Product to be supplied.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property medicationCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "medicationCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Product to be supplied.
/// <p>
/// Medication.
Property medicationReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "medicationReference", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Time period supply is authorized for.
Property validityPeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "validityPeriod", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Number of refills authorized.
Property numberOfRepeatsAllowed As %Integer(XMLNAME = "numberOfRepeatsAllowed", XMLPROJECTION = "ATTRIBUTE");

/// SimpleQuantity
/// <p>
/// Amount of medication to supply per dispense.
Property quantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

/// Duration
/// <p>
/// Number of days supply per dispense.
Property expectedSupplyDuration As HS.FHIR.DTL.vDSTU2.Model.Datatype.Duration(XMLNAME = "expectedSupplyDuration", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationOrder.dispenseRequest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicationOrder.dispenseRequest";

}
