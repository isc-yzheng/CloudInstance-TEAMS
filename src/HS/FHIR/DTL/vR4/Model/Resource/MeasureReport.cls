/// Results of a measure evaluation.
Class HS.FHIR.DTL.vR4.Model.Resource.MeasureReport Extends HS.FHIR.DTL.vR4.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Additional identifier for the MeasureReport.
Property identifier As list Of HS.FHIR.DTL.vR4.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// complete | pending | error
/// <p>
/// measure-report-status|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend measure-report-status|4.0.1 and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// individual | subject-list | summary | data-collection
/// <p>
/// measure-report-type|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend measure-report-type|4.0.1 and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// canonical
/// <p>
/// What measure was calculated.
/// <p>
/// TO DO: Unrecognized value type for the FHIR4 model
Property measure As %String(MAXLEN = 1000000, XMLNAME = "measure", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// What individual(s) the report is for.
/// <p>
/// Patient | Practitioner | PractitionerRole | Location | Device | RelatedPerson | Group
Property subject As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the report was generated.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who is reporting the data.
/// <p>
/// Practitioner | PractitionerRole | Location | Organization
Property reporter As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "reporter", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// What period the report covers.
Property period As HS.FHIR.DTL.vR4.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// increase | decrease
/// <p>
/// measure-improvement-notation|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend measure-improvement-notation|4.0.1 and you may NOT use codes from other ValueSets.
Property improvementNotation As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "improvementNotation", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Measure results for each group.
Property group As list Of HS.FHIR.DTL.vR4.Model.Element.MeasureReport.group(XMLNAME = "group", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// What data was used to calculate the measure score.
/// <p>
/// Any FHIR4 Resource may be indicated by this Reference
Property evaluatedResource As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "evaluatedResource", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MeasureReport";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MeasureReport";

}
