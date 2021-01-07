/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.TestScript.Metadata when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.TestScript.Metadata Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "TestScript.Metadata";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "TestScript.Metadata";

///  
Property link As list Of HS.FHIR.Model.Resource.TestScript.Link(XMLNAME = "link", XMLPROJECTION = "ELEMENT");

///  
Property capability As list Of HS.FHIR.Model.Resource.TestScript.Capability(XMLNAME = "capability", XMLPROJECTION = "ELEMENT") [ Required ];

}
