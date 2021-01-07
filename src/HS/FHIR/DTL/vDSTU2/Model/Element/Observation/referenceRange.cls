/// Provides guide for interpretation.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Observation.referenceRange Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// SimpleQuantity
/// <p>
/// Low Range, 
/// if relevant.
Property low As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "low", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// High Range, 
/// if relevant.
Property high As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "high", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Indicates the meaning/use of this range of this range.
/// <p>
/// any FHIR2 code may be used; 
/// referencerange-meaning shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property meaning As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "meaning", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Applicable age range, 
/// if relevant.
Property age As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "age", XMLPROJECTION = "ELEMENT");

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
