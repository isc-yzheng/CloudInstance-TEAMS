/// Contract Friendly Language.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Contract.friendly Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Attachment
/// <p>
/// Easily comprehended representation of this Contract.
Property contentAttachment As HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment(XMLNAME = "contentAttachment", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Easily comprehended representation of this Contract.
/// <p>
/// Composition | DocumentReference | QuestionnaireResponse
Property contentReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "contentReference", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Contract.friendly";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Contract.friendly";

}
