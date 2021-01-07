/// Indicates an actual or potential clinical issue with or between one or more active or proposed clinical actions for a patient; 
/// e.g. 
/// Drug-drug interaction, 
/// Ineffective treatment frequency, 
/// Procedure-condition conflict, 
/// etc.
Class HS.FHIR.DTL.vSTU3.Model.Resource.DetectedIssue Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Unique id for the detected issue.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// registered | preliminary | final | amended +
/// <p>
/// observation-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend observation-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Issue Category, 
/// e.g. 
/// drug-drug, 
/// duplicate therapy, 
/// etc.
/// <p>
/// detectedissue-category is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in detectedissue-category, 
/// you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// high | moderate | low
/// <p>
/// detectedissue-severity is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend detectedissue-severity and you may NOT use codes from other ValueSets.
Property severity As %String(MAXLEN = 1000000, XMLNAME = "severity", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Associated patient.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When identified.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// The provider or device that identified the issue.
/// <p>
/// Practitioner | Device
Property author As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "author", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Problem resource.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property implicated As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "implicated", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Description and context.
Property detail As %String(MAXLEN = 1000000, XMLNAME = "detail", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Authority for issue.
Property reference As %String(MAXLEN = 1000000, XMLNAME = "reference", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Step taken to address.
Property mitigation As list Of HS.FHIR.DTL.vSTU3.Model.Element.DetectedIssue.mitigation(XMLNAME = "mitigation", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DetectedIssue";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DetectedIssue";

}
