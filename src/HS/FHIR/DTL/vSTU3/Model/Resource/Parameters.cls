/// This special resource type is used to represent the operation request and response. 
/// This resource has no other use than for operation parameters, 
/// and there is no RESTful endpoint associated with it.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Parameters Extends HS.FHIR.DTL.vSTU3.Model.Base.Resource [ Not ProcedureBlock ]
{

/// BackboneElement
/// <p>
/// A parameter passed to or received from the operation. 
/// A parameter must have only one of (value*, 
/// resource, 
/// part).
Property parameter As list Of HS.FHIR.DTL.vSTU3.Model.Element.Parameters.parameter(XMLNAME = "parameter", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Parameters";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Parameters";

}
