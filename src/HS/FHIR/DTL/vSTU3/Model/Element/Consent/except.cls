/// Additional rule -  addition or removal of permissions.
Class HS.FHIR.DTL.vSTU3.Model.Element.Consent.except Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// deny | permit
/// <p>
/// consent-except-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend consent-except-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Period
/// <p>
/// Timeframe for this exception.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Who | what controlled by this exception (or group, 
/// by role)
Property actor As list Of HS.FHIR.DTL.vSTU3.Model.Element.Consent.except.actor(XMLNAME = "actor", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Actions controlled by this exception.
/// <p>
/// any FHIR3 code may be used; 
/// consent-action shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property action As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Security Labels that define affected resources.
/// <p>
/// security-labels is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in security-labels, 
/// you may formally EXTEND security-labels to add codes to it.
Property securityLabel As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "securityLabel", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Context of activities covered by this exception.
/// <p>
/// v3-PurposeOfUse is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in v3-PurposeOfUse, 
/// you may formally EXTEND v3-PurposeOfUse to add codes to it.
Property purpose As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "purpose", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// e.g. 
/// Resource Type, 
/// Profile, 
/// or CDA etc.
/// <p>
/// consent-content-class is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in consent-content-class, 
/// you may formally EXTEND consent-content-class to add codes to it.
Property class As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "class", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// e.g. 
/// LOINC or SNOMED CT code, 
/// etc in the content.
/// <p>
/// any FHIR3 code may be used; 
/// consent-content-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Timeframe for data controlled by this exception.
Property dataPeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "dataPeriod", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Data controlled by this exception.
Property data As list Of HS.FHIR.DTL.vSTU3.Model.Element.Consent.except.data(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Consent.except";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Consent.except";

}
