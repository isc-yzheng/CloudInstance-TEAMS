/// Exceptions, 
/// special considerations, 
/// the condition, 
/// situation, 
/// prior or concurrent issues.
Class HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.information Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Information instance identifier.
Property sequence As %Integer(XMLNAME = "sequence", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// General class of information.
/// <p>
/// any FHIR3 code may be used; 
/// claim-informationcategory shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Type of information.
/// <p>
/// any FHIR3 code may be used; 
/// claim-exception shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
///  When it occurred.
Property timingDate As %String(MAXLEN = 1000000, XMLNAME = "timingDate", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
///  When it occurred.
Property timingPeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "timingPeriod", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
///  Additional Data or supporting information.
Property valueAttachment As HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "valueAttachment", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
///  Additional Data or supporting information.
Property valueQuantity As HS.FHIR.DTL.vSTU3.Model.Datatype.Quantity(XMLNAME = "valueQuantity", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
///  Additional Data or supporting information.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference.
Property valueReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "valueReference", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
///  Additional Data or supporting information.
Property valueString As %String(MAXLEN = 1000000, XMLNAME = "valueString", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// Reason associated with the information.
/// <p>
/// any FHIR3 code may be used; 
/// missing-tooth-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reason As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExplanationOfBenefit.information";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExplanationOfBenefit.information";

}
