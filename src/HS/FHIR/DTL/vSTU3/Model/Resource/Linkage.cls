/// Identifies two or more records (resource instances) that are referring to the same real-world "occurrence".
Class HS.FHIR.DTL.vSTU3.Model.Resource.Linkage Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// boolean
/// <p>
/// Whether this linkage assertion is active or not.
Property active As %Boolean(XMLNAME = "active", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who is responsible for linkages.
/// <p>
/// Practitioner | Organization
Property author As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "author", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Item to be linked.
Property item As list Of HS.FHIR.DTL.vSTU3.Model.Element.Linkage.item(XMLNAME = "item", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Linkage";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Linkage";

}
