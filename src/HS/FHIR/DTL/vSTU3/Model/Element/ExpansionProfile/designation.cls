/// When the expansion profile imposes designation contraints.
Class HS.FHIR.DTL.vSTU3.Model.Element.ExpansionProfile.designation Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// BackboneElement
/// <p>
/// Designations to be included.
Property include As HS.FHIR.DTL.vSTU3.Model.Element.ExpansionProfile.designation.include(XMLNAME = "include", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Designations to be excluded.
Property exclude As HS.FHIR.DTL.vSTU3.Model.Element.ExpansionProfile.designation.exclude(XMLNAME = "exclude", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExpansionProfile.designation";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExpansionProfile.designation";

}
