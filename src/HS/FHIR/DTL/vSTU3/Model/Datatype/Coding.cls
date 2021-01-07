/// A Coding is a representation of a defined concept using a symbol from a defined "code system"
Class HS.FHIR.DTL.vSTU3.Model.Datatype.Coding Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Identity of the terminology system.
Property system As %String(MAXLEN = 1000000, XMLNAME = "system", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Version of the system - if relevant.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Symbol in syntax defined by the system.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Representation defined by the system.
Property display As %String(MAXLEN = 1000000, XMLNAME = "display", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// If this coding was chosen directly by the user.
Property userSelected As %Boolean(XMLNAME = "userSelected", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Coding";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Coding";

}
