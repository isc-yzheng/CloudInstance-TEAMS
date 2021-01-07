/// This resource provides the target, 
/// request and response, 
/// and action details for an action to be performed by the target on or about existing resources. 
/// NOTE: This resource is slated to be refactored and reduced in scope as some of its functionality is taken over by the Task resource as part of the FHIR Workflow refactoring. 
/// Readers of this resource are encouraged to review the Task resource and consider using it instead and/or to provide feedback.
Class HS.FHIR.DTL.vSTU3.Model.Resource.ProcessRequest Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
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

/// code
/// <p>
/// cancel | poll | reprocess | status
/// <p>
/// actionlist is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend actionlist and you may NOT use codes from other ValueSets.
Property action As %String(MAXLEN = 1000000, XMLNAME = "action", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Party which is the target of the request.
/// <p>
/// Organization
Property target As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "target", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Creation date.
Property created As %String(MAXLEN = 1000000, XMLNAME = "created", XMLPROJECTION = "ATTRIBUTE");

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

/// Reference
/// <p>
/// Reference to the Request resource.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property request As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "request", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Reference to the Response resource.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property response As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "response", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Remove history.
Property nullify As %Boolean(XMLNAME = "nullify", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Reference number/string.
Property reference As %String(MAXLEN = 1000000, XMLNAME = "reference", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Items to re-adjudicate.
Property item As list Of HS.FHIR.DTL.vSTU3.Model.Element.ProcessRequest.item(XMLNAME = "item", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Resource type(s) to include.
Property include As list Of %String(MAXLEN = 1000000, XMLNAME = "include", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Resource type(s) to exclude.
Property exclude As list Of %String(MAXLEN = 1000000, XMLNAME = "exclude", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Selection period.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ProcessRequest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ProcessRequest";

}
