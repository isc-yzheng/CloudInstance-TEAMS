/// A response to an order.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.OrderResponse Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Identifiers assigned to this order by the orderer or by the receiver.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The order that this is a response to.
/// <p>
/// Order
Property request As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "request", XMLPROJECTION = "ELEMENT") [ Required ];

/// dateTime
/// <p>
/// When the response was made.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who made the response.
/// <p>
/// Practitioner | Organization | Device
Property who As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "who", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// pending | review | rejected | error | accepted | cancelled | replaced | aborted | completed
/// <p>
/// order-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend order-status and you may NOT use codes from other ValueSets.
Property orderStatus As %String(MAXLEN = 1000000, XMLNAME = "orderStatus", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Additional description of the response.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Details of the outcome of performing the order.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property fulfillment As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "fulfillment", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "OrderResponse";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "OrderResponse";

}
