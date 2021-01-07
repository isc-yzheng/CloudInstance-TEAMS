/// A process where a researcher or organization plans and then executes a series of steps intended to increase the field of healthcare-related knowledge. 
/// This includes studies of safety, 
/// efficacy, 
/// comparative effectiveness and other information about medications, 
/// devices, 
/// therapies and other interventional and investigative techniques. 
/// A ResearchStudy involves the gathering of information about human or animal subjects.
Class HS.FHIR.DTL.vSTU3.Model.Resource.ResearchStudy Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business Identifier for study.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Name for this study.
Property title As %String(MAXLEN = 1000000, XMLNAME = "title", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Steps followed in executing study.
/// <p>
/// PlanDefinition
Property protocol As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "protocol", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Part of larger study.
/// <p>
/// ResearchStudy
Property partOf As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "partOf", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// draft | in-progress | suspended | stopped | completed | entered-in-error
/// <p>
/// research-study-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend research-study-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Classifications for the study.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property category As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Drugs, 
/// devices, 
/// conditions, 
/// etc. 
/// under study.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property focus As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "focus", XMLPROJECTION = "ELEMENT");

/// ContactDetail
/// <p>
/// Contact details for the study.
Property contact As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.ContactDetail(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// RelatedArtifact
/// <p>
/// References and dependencies.
Property relatedArtifact As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.RelatedArtifact(XMLNAME = "relatedArtifact", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Used to search for the study.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property keyword As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "keyword", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Geographic region(s) for study.
/// <p>
/// jurisdiction is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in jurisdiction, 
/// you may formally EXTEND jurisdiction to add codes to it.
Property jurisdiction As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "jurisdiction", XMLPROJECTION = "ELEMENT");

/// markdown
/// <p>
/// What this is study doing.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Inclusion & exclusion criteria.
/// <p>
/// Group
Property enrollment As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "enrollment", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// When the study began and ended.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Organization responsible for the study.
/// <p>
/// Organization
Property sponsor As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "sponsor", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The individual responsible for the study.
/// <p>
/// Practitioner
Property principalInvestigator As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "principalInvestigator", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Location involved in study execution.
/// <p>
/// Location
Property site As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "site", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Reason for terminating study early.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property reasonStopped As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reasonStopped", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Comments made about the event.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Defined path through the study for a subject.
Property arm As list Of HS.FHIR.DTL.vSTU3.Model.Element.ResearchStudy.arm(XMLNAME = "arm", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ResearchStudy";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ResearchStudy";

}
