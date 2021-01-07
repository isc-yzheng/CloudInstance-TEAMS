/// Enrollment request.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.EnrollmentRequest Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

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
/// Insurer.
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
/// The subject of the Products and Services.
/// <p>
/// Patient
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Insurance information.
/// <p>
/// Coverage
Property coverage As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "coverage", XMLPROJECTION = "ELEMENT") [ Required ];

/// Coding
/// <p>
/// Patient relationship to subscriber.
/// <p>
/// any FHIR2 code may be used; 
/// relationship shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property relationship As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "relationship", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "EnrollmentRequest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "EnrollmentRequest";

}
