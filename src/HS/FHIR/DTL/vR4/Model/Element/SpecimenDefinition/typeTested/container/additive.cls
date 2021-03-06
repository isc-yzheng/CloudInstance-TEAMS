/// Additive associated with container.
Class HS.FHIR.DTL.vR4.Model.Element.SpecimenDefinition.typeTested.container.additive Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Additive associated with container.
/// <p>
/// any FHIR4 code may be used; 
/// v2-0371 shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property additiveCodeableConcept As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "additiveCodeableConcept", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Additive associated with container.
/// <p>
/// Substance.
Property additiveReference As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "additiveReference", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "SpecimenDefinition.typeTested.container.additive";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "SpecimenDefinition.typeTested.container.additive";

}
