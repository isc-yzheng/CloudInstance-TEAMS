/// This resource is primarily used for the identification and definition of a medication. 
/// It covers the ingredients and the packaging for a medication.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Medication Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Codes that identify this medication.
/// <p>
/// any FHIR3 code may be used; 
/// medication-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | inactive | entered-in-error
/// <p>
/// medication-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend medication-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// True if a brand.
Property isBrand As %Boolean(XMLNAME = "isBrand", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// True if medication does not require a prescription.
Property isOverTheCounter As %Boolean(XMLNAME = "isOverTheCounter", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Manufacturer of the item.
/// <p>
/// Organization
Property manufacturer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "manufacturer", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// powder | tablets | capsule +
/// <p>
/// any FHIR3 code may be used; 
/// medication-form-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property form As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "form", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Active or inactive ingredient.
Property ingredient As list Of HS.FHIR.DTL.vSTU3.Model.Element.Medication.ingredient(XMLNAME = "ingredient", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Details about packaged medications.
Property package As HS.FHIR.DTL.vSTU3.Model.Element.Medication.package(XMLNAME = "package", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Picture of the medication.
Property image As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "image", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Medication";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Medication";

}
