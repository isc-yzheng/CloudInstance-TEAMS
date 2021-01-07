/// Entry in the bundle - will have a resource, 
/// or information.
Class HS.FHIR.DTL.vSTU3.Model.Element.Bundle.entry Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Bundle:link
/// <p>
/// Links related to this entry.
Property link As list Of HS.FHIR.DTL.vSTU3.Model.Element.Bundle.link(XMLNAME = "link", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Absolute URL for resource (server address, 
/// or UUID/OID)
Property fullUrl As %String(MAXLEN = 1000000, XMLNAME = "fullUrl", XMLPROJECTION = "ATTRIBUTE");

/// Resource
/// <p>
/// A resource in the bundle.
Property resource As HS.FHIR.DTL.vSTU3.Model.Base.Resource(XMLNAME = "resource", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Search related information.
Property search As HS.FHIR.DTL.vSTU3.Model.Element.Bundle.entry.search(XMLNAME = "search", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Transaction Related Information.
Property request As HS.FHIR.DTL.vSTU3.Model.Element.Bundle.entry.request(XMLNAME = "request", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Transaction Related Information.
Property response As HS.FHIR.DTL.vSTU3.Model.Element.Bundle.entry.response(XMLNAME = "response", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Bundle.entry";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Bundle.entry";

}
