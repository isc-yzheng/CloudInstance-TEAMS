/// Base for all elements.
Class HS.FHIR.DTL.vR4.Model.Base.Element Extends (%Library.RegisteredObject, HS.FHIR.DTL.Util.XML.Adapter, HS.FHIR.DTL.Util.JSON.Adapter, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

Property id;

/// Extension
/// <p>
/// Additional content defined by implementations.
Property extension As list Of HS.FHIR.DTL.vR4.Model.Base.Extension(XMLNAME = "extension", XMLPROJECTION = "ELEMENT");

/// Generated property, not a FHIR element: Storage space for 'contained' resources that are actually separate from the parent, and need to be serialized as separate objects.
Property newResource As list Of HS.FHIR.DTL.vR4.Model.Base.Resource;

/// Generated property, not a FHIR element: Storage space for the location the corresponding newResource entry reference should be stored in after adding it to a repository
Property newResourceReference As %String;

/// Generated property, not a FHIR element: Storage space for extensions of any elements that have a primitive data type.
Property primitiveExtension As list Of HS.FHIR.DTL.vR4.Model.Base.Extension;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Element";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Element";

}
