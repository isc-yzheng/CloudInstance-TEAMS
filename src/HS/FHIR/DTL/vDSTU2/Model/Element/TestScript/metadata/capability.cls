/// Capabilities  that are assumed to function correctly on the FHIR server being tested.
Class HS.FHIR.DTL.vDSTU2.Model.Element.TestScript.metadata.capability Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// boolean
/// <p>
/// Are the capabilities required?
Property required As %Boolean(XMLNAME = "required", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Are the capabilities validated?
Property validated As %Boolean(XMLNAME = "validated", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// The expected capabilities of the server.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Which server these requirements apply to.
Property destination As %Integer(XMLNAME = "destination", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Links to the FHIR specification.
Property link As list Of %String(MAXLEN = 1000000, XMLNAME = "link", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Required Conformance.
/// <p>
/// Conformance
Property conformance As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "conformance", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.metadata.capability";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.metadata.capability";

}
