/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.OperationOutcome when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.OperationOutcome Extends HS.FHIR.Model.Base.DomainResource [ Deprecated, ProcedureBlock ]
{

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "OperationOutcome";

///  
Parameter XMLSEQUENCE = 1;

///  
Property issue As list Of HS.FHIR.Model.Resource.OperationOutcome.Issue(XMLNAME = "issue", XMLPROJECTION = "ELEMENT") [ Required ];

}
