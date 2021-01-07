/// Details about packaged medications.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Medication.package Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// E.g. 
/// box, 
/// vial, 
/// blister-pack.
/// <p>
/// any FHIR2 code may be used; 
/// medication-package-form-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property container As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "container", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// What is  in the package.
Property content As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Medication.package.content(XMLNAME = "content", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Medication.package";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Medication.package";

}
