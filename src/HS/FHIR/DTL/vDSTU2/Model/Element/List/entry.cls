/// Entries in the list.
Class HS.FHIR.DTL.vDSTU2.Model.Element.List.entry Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Status/Workflow information about this item.
/// <p>
/// any FHIR2 code may be used; 
/// list-item-flag shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property flag As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "flag", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// If this item is actually marked as deleted.
Property deleted As %Boolean(XMLNAME = "deleted", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// When item added to list.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Actual entry.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property item As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "item", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "List.entry";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "List.entry";

}
