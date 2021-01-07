/// Request for a medication, 
/// substance or device.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.SupplyRequest Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Patient for whom the item is supplied.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who initiated this order.
/// <p>
/// Practitioner | Organization | Patient
Property source As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "source", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the request was made.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Unique identifier.
Property identifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// requested | completed | failed | cancelled
/// <p>
/// supplyrequest-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend supplyrequest-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// The kind of supply (central, 
/// non-stock, 
/// etc.)
/// <p>
/// supplyrequest-kind is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend supplyrequest-kind and you may NOT use codes from other ValueSets.
Property kind As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "kind", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Medication, 
/// Substance, 
/// or Device requested to be supplied.
/// <p>
/// Medication | Substance | Device
Property orderedItem As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "orderedItem", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who is intended to fulfill the request.
/// <p>
/// Organization
Property supplier As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "supplier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Why the supply item was requested.
/// <p>
/// any FHIR2 code may be used; 
/// supplyrequest-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reasonCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Why the supply item was requested.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference.
Property reasonReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// When the request should be fulfilled.
Property when As HS.FHIR.DTL.vDSTU2.Model.Element.SupplyRequest.when(XMLNAME = "when", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "SupplyRequest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "SupplyRequest";

}
