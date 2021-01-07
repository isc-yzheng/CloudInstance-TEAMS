/// This special resource type is used to represent the operation request and response. 
/// This resource has no other use than for operation parameters, 
/// and there is no RESTful endpoint associated with it.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Parameters Extends HS.FHIR.DTL.vDSTU2.Model.Base.Resource [ Not ProcedureBlock ]
{

/// BackboneElement
/// <p>
/// A parameter passed to or received from the operation. 
/// A parameter must have a value or resource, 
/// but not both.
Property parameter As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Parameters.parameter(XMLNAME = "parameter", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Parameters";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Parameters";

}
