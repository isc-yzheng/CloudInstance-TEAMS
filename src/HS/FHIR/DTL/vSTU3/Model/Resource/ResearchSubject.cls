/// A process where a researcher or organization plans and then executes a series of steps intended to increase the field of healthcare-related knowledge. 
/// This includes studies of safety, 
/// efficacy, 
/// comparative effectiveness and other information about medications, 
/// devices, 
/// therapies and other interventional and investigative techniques. 
/// A ResearchStudy involves the gathering of information about human or animal subjects.
Class HS.FHIR.DTL.vSTU3.Model.Resource.ResearchSubject Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business Identifier for research subject.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// candidate | enrolled | active | suspended | withdrawn | completed
/// <p>
/// research-subject-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend research-subject-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Period
/// <p>
/// Start and end of participation.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Study subject is part of.
/// <p>
/// ResearchStudy
Property study As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "study", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Who is part of study.
/// <p>
/// Patient
Property individual As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "individual", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
/// What path should be followed.
Property assignedArm As %String(MAXLEN = 1000000, XMLNAME = "assignedArm", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// What path was followed.
Property actualArm As %String(MAXLEN = 1000000, XMLNAME = "actualArm", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Agreement to participate in study.
/// <p>
/// Consent
Property consent As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "consent", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ResearchSubject";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ResearchSubject";

}
