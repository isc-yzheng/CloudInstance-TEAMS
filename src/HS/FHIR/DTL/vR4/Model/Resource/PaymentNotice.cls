/// PaymentNotice request.
Class HS.FHIR.DTL.vR4.Model.Resource.PaymentNotice Extends HS.FHIR.DTL.vR4.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business Identifier for the payment noctice.
Property identifier As list Of HS.FHIR.DTL.vR4.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | cancelled | draft | entered-in-error
/// <p>
/// fm-status|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend fm-status|4.0.1 and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Request reference.
/// <p>
/// Any FHIR4 Resource may be indicated by this Reference
Property request As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "request", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Response reference.
/// <p>
/// Any FHIR4 Resource may be indicated by this Reference
Property response As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "response", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Creation date.
Property created As %String(MAXLEN = 1000000, XMLNAME = "created", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Responsible practitioner.
/// <p>
/// Practitioner | PractitionerRole | Organization
Property provider As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "provider", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Payment reference.
/// <p>
/// PaymentReconciliation
Property payment As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "payment", XMLPROJECTION = "ELEMENT") [ Required ];

/// date
/// <p>
/// Payment or clearing date.
Property paymentDate As %String(MAXLEN = 1000000, XMLNAME = "paymentDate", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Party being paid.
/// <p>
/// Practitioner | PractitionerRole | Organization
Property payee As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "payee", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Party being notified.
/// <p>
/// Organization
Property recipient As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "recipient", XMLPROJECTION = "ELEMENT") [ Required ];

/// Money
/// <p>
/// Monetary amount of the payment.
Property amount As HS.FHIR.DTL.vR4.Model.Datatype.Money(XMLNAME = "amount", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Issued or cleared Status of the payment.
/// <p>
/// any FHIR4 code may be used; 
/// payment-status shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property paymentStatus As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "paymentStatus", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "PaymentNotice";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "PaymentNotice";

}
