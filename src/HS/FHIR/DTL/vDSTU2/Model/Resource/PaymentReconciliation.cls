/// PaymentReconciliation resource.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.PaymentReconciliation Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business Identifier.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Claim reference.
/// <p>
/// ProcessRequest
Property request As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "request", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// complete | error
/// <p>
/// remittance-outcome is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend remittance-outcome and you may NOT use codes from other ValueSets.
Property outcome As %String(MAXLEN = 1000000, XMLNAME = "outcome", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Disposition Message.
Property disposition As %String(MAXLEN = 1000000, XMLNAME = "disposition", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// Resource version.
/// <p>
/// any FHIR2 code may be used; 
/// ruleset shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property ruleset As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "ruleset", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Original version.
/// <p>
/// any FHIR2 code may be used; 
/// ruleset shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property originalRuleset As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "originalRuleset", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Creation date.
Property created As %String(MAXLEN = 1000000, XMLNAME = "created", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Period covered.
Property period As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Insurer.
/// <p>
/// Organization
Property organization As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "organization", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible practitioner.
/// <p>
/// Practitioner
Property requestProvider As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "requestProvider", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible organization.
/// <p>
/// Organization
Property requestOrganization As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "requestOrganization", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Details.
Property detail As list Of HS.FHIR.DTL.vDSTU2.Model.Element.PaymentReconciliation.detail(XMLNAME = "detail", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Printed Form Identifier.
/// <p>
/// forms is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend forms and you may NOT use codes from other ValueSets.
Property form As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "form", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Total amount of Payment.
Property total As HS.FHIR.DTL.vDSTU2.Model.Datatype.Money(XMLNAME = "total", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// Note text.
Property note As list Of HS.FHIR.DTL.vDSTU2.Model.Element.PaymentReconciliation.note(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "PaymentReconciliation";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "PaymentReconciliation";

}
