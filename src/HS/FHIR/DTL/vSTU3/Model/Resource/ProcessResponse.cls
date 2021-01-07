/// This resource provides processing status, 
/// errors and notes from the processing of a resource. 
/// NOTE: This resource is slated to be refactored and reduced in scope as some of its functionality is taken over by the Task resource as part of the FHIR Workflow refactoring. 
/// Readers of this resource are encouraged to review the Task resource and consider using it instead and/or to provide feedback.
Class HS.FHIR.DTL.vSTU3.Model.Resource.ProcessResponse Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
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

/// dateTime
/// <p>
/// Creation date.
Property created As %String(MAXLEN = 1000000, XMLNAME = "created", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Authoring Organization.
/// <p>
/// Organization
Property organization As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "organization", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Request reference.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property request As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "request", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Processing outcome.
/// <p>
/// any FHIR3 code may be used; 
/// process-outcome shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property outcome As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "outcome", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Disposition Message.
Property disposition As %String(MAXLEN = 1000000, XMLNAME = "disposition", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Responsible Practitioner.
/// <p>
/// Practitioner
Property requestProvider As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "requestProvider", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible organization.
/// <p>
/// Organization
Property requestOrganization As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "requestOrganization", XMLPROJECTION = "ELEMENT");

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
/// Processing comments or additional requirements.
Property processNote As list Of HS.FHIR.DTL.vSTU3.Model.Element.ProcessResponse.processNote(XMLNAME = "processNote", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Error code.
/// <p>
/// any FHIR3 code may be used; 
/// adjudication-error shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property error As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "error", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Request for additional information.
/// <p>
/// CommunicationRequest
Property communicationRequest As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "communicationRequest", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ProcessResponse";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ProcessResponse";

}
