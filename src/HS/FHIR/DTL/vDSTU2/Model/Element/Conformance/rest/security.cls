/// Information about security of implementation.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.rest.security Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// boolean
/// <p>
/// Adds CORS Headers (http://enable-cors.org/)
Property cors As %Boolean(XMLNAME = "cors", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// OAuth | SMART-on-FHIR | NTLM | Basic | Kerberos | Certificates
/// <p>
/// restful-security-service is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in restful-security-service, 
/// you may formally EXTEND restful-security-service to add codes to it.
Property service As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "service", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// General description of how security works.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Certificates associated with security profiles.
Property certificate As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.rest.security.certificate(XMLNAME = "certificate", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Conformance.rest.security";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Conformance.rest.security";

}
