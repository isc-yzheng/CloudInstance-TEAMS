/// ProcessResponse resource.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.ProcessResponse Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business Identifier.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Request reference.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property request As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "request", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Processing outcome.
/// <p>
/// any FHIR2 code may be used; 
/// process-outcome shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property outcome As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "outcome", XMLPROJECTION = "ELEMENT");

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

/// Reference
/// <p>
/// Authoring Organization.
/// <p>
/// Organization
Property organization As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "organization", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible Practitioner.
/// <p>
/// Practitioner
Property requestProvider As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "requestProvider", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible organization.
/// <p>
/// Organization
Property requestOrganization As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "requestOrganization", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Printed Form Identifier.
/// <p>
/// forms is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend forms and you may NOT use codes from other ValueSets.
Property form As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "form", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Notes.
Property notes As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ProcessResponse.notes(XMLNAME = "notes", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Error code.
/// <p>
/// adjudication-error is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend adjudication-error and you may NOT use codes from other ValueSets.
Property error As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "error", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ProcessResponse";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ProcessResponse";

}
