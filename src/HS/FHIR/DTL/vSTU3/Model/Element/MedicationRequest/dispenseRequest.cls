/// Medication supply authorization.
Class HS.FHIR.DTL.vSTU3.Model.Element.MedicationRequest.dispenseRequest Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Period
/// <p>
/// Time period supply is authorized for.
Property validityPeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "validityPeriod", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Number of refills authorized.
Property numberOfRepeatsAllowed As %Integer(XMLNAME = "numberOfRepeatsAllowed", XMLPROJECTION = "ATTRIBUTE");

/// SimpleQuantity
/// <p>
/// Amount of medication to supply per dispense.
Property quantity As HS.FHIR.DTL.vSTU3.Model.Datatype.SimpleQuantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

/// Duration
/// <p>
/// Number of days supply per dispense.
Property expectedSupplyDuration As HS.FHIR.DTL.vSTU3.Model.Datatype.Duration(XMLNAME = "expectedSupplyDuration", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Intended dispenser.
/// <p>
/// Organization
Property performer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "performer", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationRequest.dispenseRequest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicationRequest.dispenseRequest";

}
