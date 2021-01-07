/// Clinical issue with action.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.DetectedIssue Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Associated patient.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Issue Category, 
/// e.g. 
/// drug-drug, 
/// duplicate therapy, 
/// etc.
/// <p>
/// detectedissue-category is the PREFERRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in detectedissue-category, 
/// you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// high | moderate | low
/// <p>
/// detectedissue-severity is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend detectedissue-severity and you may NOT use codes from other ValueSets.
Property severity As %String(MAXLEN = 1000000, XMLNAME = "severity", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Problem resource.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property implicated As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "implicated", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Description and context.
Property detail As %String(MAXLEN = 1000000, XMLNAME = "detail", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// When identified.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// The provider or device that identified the issue.
/// <p>
/// Practitioner | Device
Property author As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "author", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Unique id for the detected issue.
Property identifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Authority for issue.
Property reference As %String(MAXLEN = 1000000, XMLNAME = "reference", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Step taken to address.
Property mitigation As list Of HS.FHIR.DTL.vDSTU2.Model.Element.DetectedIssue.mitigation(XMLNAME = "mitigation", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DetectedIssue";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DetectedIssue";

}
