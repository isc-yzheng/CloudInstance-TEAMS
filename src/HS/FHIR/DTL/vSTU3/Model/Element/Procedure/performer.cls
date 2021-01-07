/// The people who performed the procedure.
Class HS.FHIR.DTL.vSTU3.Model.Element.Procedure.performer Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// The role the actor was in.
/// <p>
/// performer-role is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend performer-role and you may NOT use codes from other ValueSets.
Property role As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "role", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The reference to the practitioner.
/// <p>
/// Practitioner | Organization | Patient | RelatedPerson | Device
Property actor As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "actor", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Organization the device or practitioner was acting for.
/// <p>
/// Organization
Property onBehalfOf As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "onBehalfOf", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Procedure.performer";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Procedure.performer";

}
