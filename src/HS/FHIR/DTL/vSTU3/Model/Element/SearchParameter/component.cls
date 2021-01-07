/// For Composite resources to define the parts.
Class HS.FHIR.DTL.vSTU3.Model.Element.SearchParameter.component Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Defines how the part works.
/// <p>
/// SearchParameter
Property definition As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "definition", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
/// Subexpression relative to main expression.
Property expression As %String(MAXLEN = 1000000, XMLNAME = "expression", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "SearchParameter.component";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "SearchParameter.component";

}
