/// Systems/Versions to be exclude.
Class HS.FHIR.DTL.vSTU3.Model.Element.ExpansionProfile.excludedSystem Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// The specific code system to be excluded.
Property system As %String(MAXLEN = 1000000, XMLNAME = "system", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Specific version of the code system referred to.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExpansionProfile.excludedSystem";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExpansionProfile.excludedSystem";

}
