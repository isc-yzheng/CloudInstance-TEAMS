/// The people who performed the procedure.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Procedure.performer Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// The reference to the practitioner.
/// <p>
/// Practitioner | Organization | Patient | RelatedPerson
Property actor As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "actor", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// The role the actor was in.
/// <p>
/// any FHIR2 code may be used; 
/// performer-role shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property role As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "role", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Procedure.performer";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Procedure.performer";

}
