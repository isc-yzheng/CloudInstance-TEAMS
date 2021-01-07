/// Process request.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.ProcessRequest Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// code
/// <p>
/// cancel | poll | reprocess | status
/// <p>
/// actionlist is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend actionlist and you may NOT use codes from other ValueSets.
Property action As %String(MAXLEN = 1000000, XMLNAME = "action", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Identifier
/// <p>
/// Business Identifier.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

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
/// Target of the request.
/// <p>
/// Organization
Property target As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "target", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible practitioner.
/// <p>
/// Practitioner
Property provider As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "provider", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible organization.
/// <p>
/// Organization
Property organization As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "organization", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Request reference.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property request As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "request", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Response reference.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property response As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "response", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Nullify.
Property nullify As %Boolean(XMLNAME = "nullify", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Reference number/string.
Property reference As %String(MAXLEN = 1000000, XMLNAME = "reference", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Items to re-adjudicate.
Property item As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ProcessRequest.item(XMLNAME = "item", XMLPROJECTION = "ELEMENT");

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
/// Period.
Property period As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ProcessRequest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ProcessRequest";

}
