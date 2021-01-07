/// Who/what is requesting procedure or diagnostic.
Class HS.FHIR.DTL.vSTU3.Model.Element.ProcedureRequest.requester Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Individual making the request.
/// <p>
/// Device | Practitioner | Organization
Property agent As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "agent", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Organization agent is acting for.
/// <p>
/// Organization
Property onBehalfOf As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "onBehalfOf", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ProcedureRequest.requester";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ProcedureRequest.requester";

}
