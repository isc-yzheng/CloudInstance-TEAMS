/// A homogeneous material with a definite composition.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Substance Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Unique identifier.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// What class/type of substance this is.
/// <p>
/// substance-category is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in substance-category, 
/// you may formally EXTEND substance-category to add codes to it.
Property category As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// What substance this is.
/// <p>
/// any FHIR2 code may be used; 
/// substance-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
/// Textual description of the substance, 
/// comments.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// If this describes a specific package/container of the substance.
Property instance As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Substance.instance(XMLNAME = "instance", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Composition information about the substance.
Property ingredient As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Substance.ingredient(XMLNAME = "ingredient", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Substance";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Substance";

}
