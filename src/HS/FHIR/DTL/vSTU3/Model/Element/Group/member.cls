/// Who or what is in group.
Class HS.FHIR.DTL.vSTU3.Model.Element.Group.member Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Reference to the group member.
/// <p>
/// Patient | Practitioner | Device | Medication | Substance
Property entity As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "entity", XMLPROJECTION = "ELEMENT") [ Required ];

/// Period
/// <p>
/// Period member belonged to the group.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// If member is no longer in group.
Property inactive As %Boolean(XMLNAME = "inactive", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Group.member";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Group.member";

}
