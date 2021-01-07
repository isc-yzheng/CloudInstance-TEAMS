/// A homogeneous material with a definite Composition:
Class HS.FHIR.DTL.vSTU3.Model.Resource.Substance Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Unique identifier.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | inactive | entered-in-error
/// <p>
/// substance-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend substance-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// What class/type of substance this is.
/// <p>
/// substance-category is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in substance-category, 
/// you may formally EXTEND substance-category to add codes to it.
Property category As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// What substance this is.
/// <p>
/// any FHIR3 code may be used; 
/// substance-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
/// Textual description of the substance, 
/// comments.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// If this describes a specific package/container of the substance.
Property instance As list Of HS.FHIR.DTL.vSTU3.Model.Element.Substance.instance(XMLNAME = "instance", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Composition information about the substance.
Property ingredient As list Of HS.FHIR.DTL.vSTU3.Model.Element.Substance.ingredient(XMLNAME = "ingredient", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Substance";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Substance";

}
