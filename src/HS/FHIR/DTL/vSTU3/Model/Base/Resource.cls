/// The base definition for all resources.
Class HS.FHIR.DTL.vSTU3.Model.Base.Resource Extends (%Library.RegisteredObject, HS.FHIR.DTL.Util.XML.Adapter, HS.FHIR.DTL.Util.JSON.Adapter, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

/// id
/// <p>
/// Logical id of this artifact.
Property id As %String(MAXLEN = 1000000, XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

/// Meta
/// <p>
/// Metadata about the resource.
Property meta As HS.FHIR.DTL.vSTU3.Model.Base.Meta(XMLNAME = "meta", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// A set of rules under which this content was created.
Property implicitRules As %String(MAXLEN = 1000000, XMLNAME = "implicitRules", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Language of the resource content.
/// <p>
/// languages is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in languages, 
/// you may formally EXTEND languages to add codes to it.
Property language As %String(MAXLEN = 1000000, XMLNAME = "language", XMLPROJECTION = "ATTRIBUTE");

/// Generated property, not a FHIR element: Storage space for 'contained' resources that are actually separate from the parent, and need to be serialized as separate objects.
Property newResource As list Of HS.FHIR.DTL.vSTU3.Model.Base.Resource;

/// Generated property, not a FHIR element: Storage space for the location the corresponding newResource entry reference should be stored in after adding it to a repository
Property newResourceReference As %String;

/// Generated property, not a FHIR element: Storage space for extensions of any elements that have a primitive data type.
Property primitiveExtension As list Of HS.FHIR.DTL.vSTU3.Model.Base.Extension;

/// Generated property, not a FHIR element: returns the resource type for the resource object.
Property resourceType As %String [ Calculated ];

Method resourceTypeGet() As %String
{
 quit ..%ClassName(0)
}

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Resource";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Resource";

}
