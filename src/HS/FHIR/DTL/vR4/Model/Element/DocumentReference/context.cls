/// Clinical context of document.
Class HS.FHIR.DTL.vR4.Model.Element.DocumentReference.context Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Context of the document  content.
/// <p>
/// Encounter | EpisodeOfCare
Property encounter As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Main clinical acts documented.
/// <p>
/// any FHIR4 code may be used; 
/// v3-ActCode shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property event As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "event", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Time of service that is being documented.
Property period As HS.FHIR.DTL.vR4.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Kind of facility where patient was seen.
/// <p>
/// any FHIR4 code may be used; 
/// c80-facilitycodes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property facilityType As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "facilityType", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Additional details about where the content was created (e.g. 
/// clinical specialty)
/// <p>
/// any FHIR4 code may be used; 
/// c80-practice-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property practiceSetting As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "practiceSetting", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Patient demographics from source.
/// <p>
/// Patient
Property sourcePatientInfo As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "sourcePatientInfo", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Related identifiers or resources.
/// <p>
/// Any FHIR4 Resource may be indicated by this Reference
Property related As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "related", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DocumentReference.context";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DocumentReference.context";

}
