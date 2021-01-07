/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.TestScript.Action when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.TestScript.Action Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "TestScript.Action";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "TestScript.Action";

///  
Property operation As HS.FHIR.Model.Resource.TestScript.Operation(XMLNAME = "operation");

///  
Property assert As HS.FHIR.Model.Resource.TestScript.Assert(XMLNAME = "assert");

}
