/// Record of delivery of what is supplied. 
/// NOTE: This resource is an event resource from a FHIR workflow perspective - see Workflow. 
/// 
Class HS.FHIR.DTL.vSTU3.Model.Resource.SupplyDelivery Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External identifier.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Fulfills plan, 
/// proposal or order.
/// <p>
/// SupplyRequest
Property basedOn As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "basedOn", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Part of referenced event.
/// <p>
/// SupplyDelivery | Contract
Property partOf As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "partOf", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// in-progress | completed | abandoned | entered-in-error
/// <p>
/// supplydelivery-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend supplydelivery-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Patient for whom the item is supplied.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Category of dispense event.
/// <p>
/// supplydelivery-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend supplydelivery-type and you may NOT use codes from other ValueSets.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// The item that is delivered or supplied.
Property suppliedItem As HS.FHIR.DTL.vSTU3.Model.Element.SupplyDelivery.suppliedItem(XMLNAME = "suppliedItem", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
///  When event occurred.
Property occurrenceDateTime As %String(MAXLEN = 1000000, XMLNAME = "occurrenceDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
///  When event occurred.
Property occurrencePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "occurrencePeriod", XMLPROJECTION = "ELEMENT");

/// Timing
/// <p>
///  When event occurred.
Property occurrenceTiming As HS.FHIR.DTL.vSTU3.Model.Datatype.Timing(XMLNAME = "occurrenceTiming", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Dispenser.
/// <p>
/// Practitioner | Organization
Property supplier As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "supplier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Where the Supply was sent.
/// <p>
/// Location
Property destination As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "destination", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who collected the Supply.
/// <p>
/// Practitioner
Property receiver As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "receiver", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "SupplyDelivery";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "SupplyDelivery";

}
