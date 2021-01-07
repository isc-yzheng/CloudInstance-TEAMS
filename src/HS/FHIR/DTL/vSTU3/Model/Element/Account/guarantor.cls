/// Responsible for the account.
Class HS.FHIR.DTL.vSTU3.Model.Element.Account.guarantor Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Responsible entity.
/// <p>
/// Patient | RelatedPerson | Organization
Property party As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "party", XMLPROJECTION = "ELEMENT") [ Required ];

/// boolean
/// <p>
/// Credit or other hold applied.
Property onHold As %Boolean(XMLNAME = "onHold", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Guarrantee account during.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Account.guarantor";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Account.guarantor";

}
