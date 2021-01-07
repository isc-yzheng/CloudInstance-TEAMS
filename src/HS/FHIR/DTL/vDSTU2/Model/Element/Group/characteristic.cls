/// Trait of group members.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Group.characteristic Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Kind of characteristic.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// boolean
/// <p>
/// Value held by characteristic.
Property valueBoolean As %Boolean(XMLNAME = "valueBoolean", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Value held by characteristic.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property valueCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "valueCodeableConcept", XMLPROJECTION = "ELEMENT") [ Required ];

/// Quantity
/// <p>
/// Value held by characteristic.
Property valueQuantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.Quantity(XMLNAME = "valueQuantity", XMLPROJECTION = "ELEMENT") [ Required ];

/// Range
/// <p>
/// Value held by characteristic.
Property valueRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "valueRange", XMLPROJECTION = "ELEMENT") [ Required ];

/// boolean
/// <p>
/// Group includes or excludes.
Property exclude As %Boolean(XMLNAME = "exclude", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Period
/// <p>
/// Period over which characteristic is tested.
Property period As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Group.characteristic";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Group.characteristic";

}
