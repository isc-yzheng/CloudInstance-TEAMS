/// A collection of error, 
/// warning or information messages that result from a system action.
Class HS.FHIR.DTL.vSTU3.Model.Resource.OperationOutcome Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// BackboneElement
/// <p>
/// A single issue associated with the action.
Property issue As list Of HS.FHIR.DTL.vSTU3.Model.Element.OperationOutcome.issue(XMLNAME = "issue", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "OperationOutcome";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "OperationOutcome";

}
