/// Provides guide for interpretation.
Class HS.FHIR.DTL.vSTU3.Model.Element.Observation.referenceRange Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// SimpleQuantity
/// <p>
/// Low Range, 
/// if relevant.
Property low As HS.FHIR.DTL.vSTU3.Model.Datatype.SimpleQuantity(XMLNAME = "low", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// High Range, 
/// if relevant.
Property high As HS.FHIR.DTL.vSTU3.Model.Datatype.SimpleQuantity(XMLNAME = "high", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Reference range qualifier.
/// <p>
/// referencerange-meaning is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in referencerange-meaning, 
/// you may formally EXTEND referencerange-meaning to add codes to it.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Reference range population.
/// <p>
/// any FHIR3 code may be used; 
/// referencerange-appliesto shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property appliesTo As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "appliesTo", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Applicable age range, 
/// if relevant.
Property age As HS.FHIR.DTL.vSTU3.Model.Datatype.Range(XMLNAME = "age", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Text based reference range in an observation.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Observation.referenceRange";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Observation.referenceRange";

}
