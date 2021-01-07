/// Transaction Related Information.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Bundle.entry.response Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Status return code for entry.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// The location, 
/// if the operation returns a location.
Property location As %String(MAXLEN = 1000000, XMLNAME = "location", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// The etag for the resource (if relevant)
Property etag As %String(MAXLEN = 1000000, XMLNAME = "etag", XMLPROJECTION = "ATTRIBUTE");

/// instant
/// <p>
/// Server's date time modified.
Property lastModified As %String(MAXLEN = 1000000, XMLNAME = "lastModified", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Bundle.entry.response";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Bundle.entry.response";

}
