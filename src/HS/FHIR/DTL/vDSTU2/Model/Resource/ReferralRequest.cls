/// A request for referral or transfer of care.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.ReferralRequest Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// code
/// <p>
/// draft | requested | active | cancelled | accepted | rejected | completed
/// <p>
/// referralstatus is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend referralstatus and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Identifier
/// <p>
/// Business identifier.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date of creation/activation.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Referral/Transition of care request type.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// The clinical specialty (discipline) that the referral is requested for.
/// <p>
/// any FHIR2 code may be used; 
/// practitioner-specialty shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property specialty As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "specialty", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Urgency of referral / transfer of care request.
/// <p>
/// any FHIR2 code may be used; 
/// diagnostic-order-priority shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property priority As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "priority", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Patient referred to care or transfer.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Requester of referral / transfer of care.
/// <p>
/// Practitioner | Organization | Patient
Property requester As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "requester", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Receiver of referral / transfer of care request.
/// <p>
/// Practitioner | Organization
Property recipient As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "recipient", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Originating encounter.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date referral/transfer of care request is sent.
Property dateSent As %String(MAXLEN = 1000000, XMLNAME = "dateSent", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Reason for referral / transfer of care request.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property reason As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// A textual description of the referral.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Actions requested as part of the referral.
/// <p>
/// any FHIR2 code may be used; 
/// c80-practice-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property serviceRequested As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "serviceRequested", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Additonal information to support referral or transfer of care request.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property supportingInformation As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "supportingInformation", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Requested service(s) fulfillment time.
Property fulfillmentTime As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "fulfillmentTime", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ReferralRequest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ReferralRequest";

}
