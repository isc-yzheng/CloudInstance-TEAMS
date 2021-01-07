/// Remittance resource.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.ClaimResponse Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Response  number.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Id of resource triggering adjudication.
/// <p>
/// Claim
Property request As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "request", XMLPROJECTION = "ELEMENT");

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
/// Party to be paid any benefits payable.
/// <p>
/// any FHIR2 code may be used; 
/// payeetype shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property payeeType As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "payeeType", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Line items.
Property item As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ClaimResponse.item(XMLNAME = "item", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Insurer added line items.
Property addItem As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ClaimResponse.addItem(XMLNAME = "addItem", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Processing errors.
Property error As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ClaimResponse.error(XMLNAME = "error", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Total Cost of service from the Claim.
Property totalCost As HS.FHIR.DTL.vDSTU2.Model.Datatype.Money(XMLNAME = "totalCost", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Unallocated deductible.
Property unallocDeductable As HS.FHIR.DTL.vDSTU2.Model.Datatype.Money(XMLNAME = "unallocDeductable", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Total benefit payable for the Claim.
Property totalBenefit As HS.FHIR.DTL.vDSTU2.Model.Datatype.Money(XMLNAME = "totalBenefit", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Payment adjustment for non-Claim issues.
Property paymentAdjustment As HS.FHIR.DTL.vDSTU2.Model.Datatype.Money(XMLNAME = "paymentAdjustment", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Reason for Payment adjustment.
/// <p>
/// adjustment-reason is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in adjustment-reason, 
/// you may formally EXTEND adjustment-reason to add codes to it.
Property paymentAdjustmentReason As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "paymentAdjustmentReason", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// Expected data of Payment.
Property paymentDate As %String(MAXLEN = 1000000, XMLNAME = "paymentDate", XMLPROJECTION = "ATTRIBUTE");

/// Money
/// <p>
/// Payment amount.
Property paymentAmount As HS.FHIR.DTL.vDSTU2.Model.Datatype.Money(XMLNAME = "paymentAmount", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Payment identifier.
Property paymentRef As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "paymentRef", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Funds reserved status.
/// <p>
/// any FHIR2 code may be used; 
/// fundsreserve shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reserved As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "reserved", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Printed Form Identifier.
/// <p>
/// forms is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend forms and you may NOT use codes from other ValueSets.
Property form As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "form", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Processing notes.
Property note As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ClaimResponse.note(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Insurance or medical plan.
Property coverage As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ClaimResponse.coverage(XMLNAME = "coverage", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse";

}
