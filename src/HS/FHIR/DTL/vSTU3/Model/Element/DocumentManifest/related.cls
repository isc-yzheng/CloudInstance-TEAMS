/// Related things.
Class HS.FHIR.DTL.vSTU3.Model.Element.DocumentManifest.related Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Identifiers of things that are related.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Related Resource.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property ref As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "ref", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DocumentManifest.related";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DocumentManifest.related";

}
