/// This resource provides payment details and claim references supporting a bulk payment.
Class HS.FHIR.DTL.vSTU3.Model.Resource.PaymentReconciliation Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
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

/// Period
/// <p>
/// Period covered.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Creation date.
Property created As %String(MAXLEN = 1000000, XMLNAME = "created", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Insurer.
/// <p>
/// Organization
Property organization As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "organization", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Claim reference.
/// <p>
/// ProcessRequest
Property request As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "request", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// complete | error | partial
/// <p>
/// remittance-outcome is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend remittance-outcome and you may NOT use codes from other ValueSets.
Property outcome As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "outcome", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Disposition Message.
Property disposition As %String(MAXLEN = 1000000, XMLNAME = "disposition", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Responsible practitioner.
/// <p>
/// Practitioner
Property requestProvider As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "requestProvider", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible organization.
/// <p>
/// Organization
Property requestOrganization As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "requestOrganization", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// List of settlements.
Property detail As list Of HS.FHIR.DTL.vSTU3.Model.Element.PaymentReconciliation.detail(XMLNAME = "detail", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Printed Form Identifier.
/// <p>
/// any FHIR3 code may be used; 
/// forms shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property form As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "form", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Total amount of Payment.
Property total As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "total", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Processing comments.
Property processNote As list Of HS.FHIR.DTL.vSTU3.Model.Element.PaymentReconciliation.processNote(XMLNAME = "processNote", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "PaymentReconciliation";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "PaymentReconciliation";

}
