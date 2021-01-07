/// Group of resources as used in .page.package.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ImplementationGuide.package Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Name used .page.package.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Human readable text describing the package.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Resource in the implementation guide.
Property resource As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ImplementationGuide.package.resource(XMLNAME = "resource", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImplementationGuide.package";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImplementationGuide.package";

}
