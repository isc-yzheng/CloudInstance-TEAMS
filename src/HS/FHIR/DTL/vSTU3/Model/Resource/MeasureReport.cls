/// The MeasureReport resource contains the results of evaluating a measure. 
/// NOTE: This resource is an event resource from a FHIR workflow perspective - see Workflow, 
/// specifically Event.
Class HS.FHIR.DTL.vSTU3.Model.Resource.MeasureReport Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Additional identifier for the Report.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// complete | pending | error
/// <p>
/// measure-report-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend measure-report-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// individual | patient-list | summary
/// <p>
/// measure-report-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend measure-report-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// What measure was evaluated.
/// <p>
/// Measure
Property measure As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "measure", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// What patient the report is for.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the report was generated.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who is reporting the data.
/// <p>
/// Organization
Property reportingOrganization As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "reportingOrganization", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// What period the report covers.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// Measure results for each group.
Property group As list Of HS.FHIR.DTL.vSTU3.Model.Element.MeasureReport.group(XMLNAME = "group", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// What data was evaluated to produce the measure score.
/// <p>
/// Bundle
Property evaluatedResources As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "evaluatedResources", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MeasureReport";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MeasureReport";

}
