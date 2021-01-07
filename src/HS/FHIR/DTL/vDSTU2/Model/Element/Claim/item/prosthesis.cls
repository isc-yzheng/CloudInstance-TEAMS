/// Prosthetic details.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Claim.item.prosthesis Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// boolean
/// <p>
/// Is this the initial service.
Property initial As %Boolean(XMLNAME = "initial", XMLPROJECTION = "ATTRIBUTE");

/// date
/// <p>
/// Initial service Date.
Property priorDate As %String(MAXLEN = 1000000, XMLNAME = "priorDate", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// Prosthetic Material.
/// <p>
/// any FHIR2 code may be used; 
/// oral-prosthodontic-material shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property priorMaterial As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "priorMaterial", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Claim.item.prosthesis";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Claim.item.prosthesis";

}
