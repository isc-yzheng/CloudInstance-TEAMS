/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.TestScript.Setup when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.TestScript.Setup Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "TestScript.Setup";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "TestScript.Setup";

///  
Property metadata As HS.FHIR.Model.Resource.TestScript.Metadata(XMLNAME = "metadata");

///  
Property action As list Of HS.FHIR.Model.Resource.TestScript.Action(XMLNAME = "action", XMLPROJECTION = "ELEMENT") [ Required ];

}
