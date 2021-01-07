/// This resource provides the adjudication details from the processing of a Claim resource.
Class HS.FHIR.DTL.vSTU3.Model.Resource.ClaimResponse Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Response  number.
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
/// The subject of the Products and Services.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Creation date.
Property created As %String(MAXLEN = 1000000, XMLNAME = "created", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Insurance issuing organization.
/// <p>
/// Organization
Property insurer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "insurer", XMLPROJECTION = "ELEMENT");

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

/// Reference
/// <p>
/// Id of resource triggering adjudication.
/// <p>
/// Claim
Property request As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "request", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// complete | error | partial
/// <p>
/// any FHIR3 code may be used; 
/// remittance-outcome shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property outcome As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "outcome", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Disposition Message.
Property disposition As %String(MAXLEN = 1000000, XMLNAME = "disposition", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Party to be paid any benefits payable.
/// <p>
/// any FHIR3 code may be used; 
/// payeetype shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property payeeType As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "payeeType", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Line items.
Property item As list Of HS.FHIR.DTL.vSTU3.Model.Element.ClaimResponse.item(XMLNAME = "item", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Insurer added line items.
Property addItem As list Of HS.FHIR.DTL.vSTU3.Model.Element.ClaimResponse.addItem(XMLNAME = "addItem", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Processing errors.
Property error As list Of HS.FHIR.DTL.vSTU3.Model.Element.ClaimResponse.error(XMLNAME = "error", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Total Cost of service from the Claim.
Property totalCost As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "totalCost", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Unallocated deductible.
Property unallocDeductable As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "unallocDeductable", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Total benefit payable for the Claim.
Property totalBenefit As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "totalBenefit", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Payment details, 
/// if paid.
Property payment As HS.FHIR.DTL.vSTU3.Model.Element.ClaimResponse.payment(XMLNAME = "payment", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Funds reserved status.
/// <p>
/// any FHIR3 code may be used; 
/// fundsreserve shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reserved As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "reserved", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Printed Form Identifier.
/// <p>
/// any FHIR3 code may be used; 
/// forms shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property form As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "form", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Processing notes.
Property processNote As list Of HS.FHIR.DTL.vSTU3.Model.Element.ClaimResponse.processNote(XMLNAME = "processNote", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Request for additional information.
/// <p>
/// CommunicationRequest
Property communicationRequest As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "communicationRequest", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Insurance or medical plan.
Property insurance As list Of HS.FHIR.DTL.vSTU3.Model.Element.ClaimResponse.insurance(XMLNAME = "insurance", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse";

}
