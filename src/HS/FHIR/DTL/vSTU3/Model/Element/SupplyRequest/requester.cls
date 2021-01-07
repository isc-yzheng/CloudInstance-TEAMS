/// Who/what is requesting service.
Class HS.FHIR.DTL.vSTU3.Model.Element.SupplyRequest.requester Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Individual making the request.
/// <p>
/// Practitioner | Organization | Patient | RelatedPerson | Device
Property agent As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "agent", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Organization agent is acting for.
/// <p>
/// Organization
Property onBehalfOf As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "onBehalfOf", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "SupplyRequest.requester";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "SupplyRequest.requester";

}
