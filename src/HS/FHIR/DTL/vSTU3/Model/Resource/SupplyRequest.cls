/// A record of a request for a medication, 
/// substance or device used in the healthcare setting. 
/// NOTE: This resource is a request resource from a FHIR workflow perspective - see Workflow. 
/// 
Class HS.FHIR.DTL.vSTU3.Model.Resource.SupplyRequest Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Unique identifier.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// draft | active | suspended +
/// <p>
/// supplyrequest-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend supplyrequest-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// The kind of supply (central, 
/// non-stock, 
/// etc.)
/// <p>
/// any FHIR3 code may be used; 
/// supplyrequest-kind shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// routine | urgent | asap | stat
/// <p>
/// request-priority is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend request-priority and you may NOT use codes from other ValueSets.
Property priority As %String(MAXLEN = 1000000, XMLNAME = "priority", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// The item being requested.
Property orderedItem As HS.FHIR.DTL.vSTU3.Model.Element.SupplyRequest.orderedItem(XMLNAME = "orderedItem", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
///  When the request should be fulfilled.
Property occurrenceDateTime As %String(MAXLEN = 1000000, XMLNAME = "occurrenceDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
///  When the request should be fulfilled.
Property occurrencePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "occurrencePeriod", XMLPROJECTION = "ELEMENT");

/// Timing
/// <p>
///  When the request should be fulfilled.
Property occurrenceTiming As HS.FHIR.DTL.vSTU3.Model.Datatype.Timing(XMLNAME = "occurrenceTiming", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the request was made.
Property authoredOn As %String(MAXLEN = 1000000, XMLNAME = "authoredOn", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Who/what is requesting service.
Property requester As HS.FHIR.DTL.vSTU3.Model.Element.SupplyRequest.requester(XMLNAME = "requester", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who is intended to fulfill the request.
/// <p>
/// Organization
Property supplier As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "supplier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
///  Why the supply item was requested.
/// <p>
/// any FHIR3 code may be used; 
/// supplyrequest-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reasonCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
///  Why the supply item was requested.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference.
Property reasonReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The origin of the supply.
/// <p>
/// Organization | Location
Property deliverFrom As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "deliverFrom", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The destination of the supply.
/// <p>
/// Organization | Location | Patient
Property deliverTo As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "deliverTo", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "SupplyRequest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "SupplyRequest";

}
