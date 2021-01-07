/// Item to be linked.
Class HS.FHIR.DTL.vSTU3.Model.Element.Linkage.item Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// source | alternate | historical
/// <p>
/// linkage-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend linkage-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Resource being linked.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property resource As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "resource", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Linkage.item";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Linkage.item";

}
