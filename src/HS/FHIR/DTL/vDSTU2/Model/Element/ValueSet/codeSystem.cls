/// An inline code system, 
/// which is part of this value set.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ValueSet.codeSystem Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// URI to identify the code system (e.g. 
/// in Coding.system)
Property system As %String(MAXLEN = 1000000, XMLNAME = "system", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Version (for use in Coding.version)
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// If code comparison is case sensitive.
Property caseSensitive As %Boolean(XMLNAME = "caseSensitive", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Concepts in the code system.
Property concept As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ValueSet.codeSystem.concept(XMLNAME = "concept", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet.codeSystem";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet.codeSystem";

}
