/// This special resource type is used to represent an operation request and response (operations.html). It has no other use, and there is no RESTful endpoint associated with it.<br>
/// If the element is present, it must have either a @value, an @id, or extensions
Class HS.FHIR.vSTU3.Model.Resource.Parameters Extends HS.FHIR.vSTU3.Model.Base.Resource [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Parameters";

Parameter XMLSEQUENCE = 1;

/// A parameter passed to or received from the operation.
Property parameter As list Of HS.FHIR.vSTU3.Model.Resource.Parameters.Parameter(XMLNAME = "parameter", XMLPROJECTION = "ELEMENT");

}
