/// Delivery of Supply.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.SupplyDelivery Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External identifier.
Property identifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// in-progress | completed | abandoned
/// <p>
/// supplydelivery-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend supplydelivery-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Patient for whom the item is supplied.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Category of dispense event.
/// <p>
/// supplydelivery-type is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend supplydelivery-type and you may NOT use codes from other ValueSets.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// Amount dispensed.
Property quantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Medication, 
/// Substance, 
/// or Device supplied.
/// <p>
/// Medication | Substance | Device
Property suppliedItem As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "suppliedItem", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Dispenser.
/// <p>
/// Practitioner
Property supplier As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "supplier", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Dispensing time.
Property whenPrepared As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "whenPrepared", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Handover time.
Property time As %String(MAXLEN = 1000000, XMLNAME = "time", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Where the Supply was sent.
/// <p>
/// Location
Property destination As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "destination", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who collected the Supply.
/// <p>
/// Practitioner
Property receiver As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "receiver", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "SupplyDelivery";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "SupplyDelivery";

}
