/// A request to perform an action.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Order Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Identifiers assigned to this order by the orderer or by the receiver.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the order was made.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Patient this order is about.
/// <p>
/// Patient | Group | Device | Substance
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who initiated the order.
/// <p>
/// Practitioner | Organization
Property source As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "source", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who is intended to fulfill the order.
/// <p>
/// Organization | Device | Practitioner
Property target As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "target", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Text - why the order was made.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property reasonCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reasonCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Text - why the order was made.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference.
Property reasonReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// When order should be fulfilled.
Property when As HS.FHIR.DTL.vDSTU2.Model.Element.Order.when(XMLNAME = "when", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// What action is being ordered.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property detail As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "detail", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Order";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Order";

}
