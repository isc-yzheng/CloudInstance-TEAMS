/// This resource provides the status of the payment for goods and services rendered, 
/// and the request and response resource references.
Class HS.FHIR.DTL.vSTU3.Model.Resource.PaymentNotice Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business Identifier.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | cancelled | draft | entered-in-error
/// <p>
/// fm-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend fm-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Request reference.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property request As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "request", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Response reference.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property response As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "response", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// Payment or clearing date.
Property statusDate As %String(MAXLEN = 1000000, XMLNAME = "statusDate", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Creation date.
Property created As %String(MAXLEN = 1000000, XMLNAME = "created", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Insurer or Regulatory body.
/// <p>
/// Organization
Property target As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "target", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible practitioner.
/// <p>
/// Practitioner
Property provider As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "provider", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible organization.
/// <p>
/// Organization
Property organization As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "organization", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Whether payment has been sent or cleared.
/// <p>
/// any FHIR3 code may be used; 
/// payment-status shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property paymentStatus As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "paymentStatus", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "PaymentNotice";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "PaymentNotice";

}
