/// What codes are expected.
Class HS.FHIR.DTL.vSTU3.Model.Element.DataRequirement.codeFilter Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// The code-valued attribute of the filter.
Property path As %String(MAXLEN = 1000000, XMLNAME = "path", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Valueset for the filter.
/// <p>
/// ValueSet.
Property valueSetReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "valueSetReference", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Valueset for the filter.
Property valueSetString As %String(MAXLEN = 1000000, XMLNAME = "valueSetString", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// What code is expected.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property valueCode As list Of %String(MAXLEN = 1000000, XMLNAME = "valueCode", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// What Coding is expected.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property valueCoding As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "valueCoding", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// What CodeableConcept is expected.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property valueCodeableConcept As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "valueCodeableConcept", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DataRequirement.codeFilter";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DataRequirement.codeFilter";

}
