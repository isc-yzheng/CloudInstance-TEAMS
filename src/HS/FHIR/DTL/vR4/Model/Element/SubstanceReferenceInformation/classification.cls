/// Todo.
Class HS.FHIR.DTL.vR4.Model.Element.SubstanceReferenceInformation.classification Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Todo.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property domain As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "domain", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Todo.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property classification As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "classification", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Todo.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property subtype As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "subtype", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Todo.
/// <p>
/// DocumentReference
Property source As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "source", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "SubstanceReferenceInformation.classification";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "SubstanceReferenceInformation.classification";

}
