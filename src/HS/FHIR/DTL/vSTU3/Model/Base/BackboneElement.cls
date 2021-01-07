/// The base definition for elements defined as part of a resource definition. 
/// Data Type elements do not use this type. 
/// 
Class HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// Extension
/// <p>
/// Extensions that cannot be ignored.
Property modifierExtension As list Of HS.FHIR.DTL.vSTU3.Model.Base.Extension(XMLNAME = "modifierExtension", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "BackboneElement";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "BackboneElement";

}
