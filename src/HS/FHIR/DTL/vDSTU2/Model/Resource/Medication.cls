/// Definition of a Medication.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Medication Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Codes that identify this medication.
/// <p>
/// any FHIR2 code may be used; 
/// medication-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// True if a brand.
Property isBrand As %Boolean(XMLNAME = "isBrand", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Manufacturer of the item.
/// <p>
/// Organization
Property manufacturer As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "manufacturer", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Administrable medication details.
Property product As HS.FHIR.DTL.vDSTU2.Model.Element.Medication.product(XMLNAME = "product", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Details about packaged medications.
Property package As HS.FHIR.DTL.vDSTU2.Model.Element.Medication.package(XMLNAME = "package", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Medication";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Medication";

}
