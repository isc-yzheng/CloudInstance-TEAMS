/// Condition that the related person had.
Class HS.FHIR.DTL.vDSTU2.Model.Element.FamilyMemberHistory.condition Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Condition suffered by relation.
/// <p>
/// any FHIR2 code may be used; 
/// condition-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// deceased | permanent disability | etc.
/// <p>
/// any FHIR2 code may be used; 
/// condition-outcome shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property outcome As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "outcome", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// When condition first manifested.
Property onsetPeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "onsetPeriod", XMLPROJECTION = "ELEMENT");

/// Age
/// <p>
/// When condition first manifested.
Property onsetQuantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.Age(XMLNAME = "onsetQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// When condition first manifested.
Property onsetRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "onsetRange", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// When condition first manifested.
Property onsetString As %String(MAXLEN = 1000000, XMLNAME = "onsetString", XMLPROJECTION = "ATTRIBUTE");

/// Annotation
/// <p>
/// Extra information about condition.
Property note As HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "FamilyMemberHistory.condition";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "FamilyMemberHistory.condition";

}
