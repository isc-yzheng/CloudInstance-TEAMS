/// Related identifiers or resources.
Class HS.FHIR.DTL.vDSTU2.Model.Element.DocumentReference.context.related Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Identifier of related objects or events.
Property identifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Related Resource.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property ref As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "ref", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DocumentReference.context.related";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DocumentReference.context.related";

}
