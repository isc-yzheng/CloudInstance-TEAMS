/// Base for elements defined inside a resource.
Class HS.FHIR.DTL.vR4.Model.Base.BackboneElement Extends HS.FHIR.DTL.vR4.Model.Base.Element [ Not ProcedureBlock ]
{

Property id;

/// Extension
/// <p>
/// Additional content defined by implementations.
Property extension As list Of HS.FHIR.DTL.vR4.Model.Base.Extension(XMLNAME = "extension", XMLPROJECTION = "ELEMENT");

/// Extension
/// <p>
/// Extensions that cannot be ignored even if unrecognized.
Property modifierExtension As list Of HS.FHIR.DTL.vR4.Model.Base.Extension(XMLNAME = "modifierExtension", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "BackboneElement";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "BackboneElement";

}
