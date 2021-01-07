/// Codes in the value set.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ValueSet.expansion.contains Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// System value for the code.
Property system As %String(MAXLEN = 1000000, XMLNAME = "system", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// If user cannot select this entry.
Property abstract As %Boolean(XMLNAME = "abstract", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Version in which this code/display is defined.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Code - if blank, 
/// this is not a selectable code.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// User display for the concept.
Property display As %String(MAXLEN = 1000000, XMLNAME = "display", XMLPROJECTION = "ATTRIBUTE");

/// ValueSet:expansion.contains
/// <p>
/// Codes contained under this entry.
Property contains As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ValueSet.expansion.contains(XMLNAME = "contains", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet.expansion.contains";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet.expansion.contains";

}
