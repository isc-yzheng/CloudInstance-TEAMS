/// Todo.
Class HS.FHIR.DTL.vR4.Model.Element.SubstancePolymer.monomerSet Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Todo.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property ratioType As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "ratioType", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Todo.
Property startingMaterial As list Of HS.FHIR.DTL.vR4.Model.Element.SubstancePolymer.monomerSet.startingMaterial(XMLNAME = "startingMaterial", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "SubstancePolymer.monomerSet";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "SubstancePolymer.monomerSet";

}
