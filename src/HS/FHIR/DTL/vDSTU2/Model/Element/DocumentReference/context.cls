/// Clinical context of document.
Class HS.FHIR.DTL.vDSTU2.Model.Element.DocumentReference.context Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Context of the document  content.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Main Clinical Acts Documented.
/// <p>
/// any FHIR2 code may be used; 
/// v3-ActCode shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property event As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "event", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Time of service that is being documented.
Property period As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Kind of facility where patient was seen.
/// <p>
/// any FHIR2 code may be used; 
/// c80-facilitycodes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property facilityType As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "facilityType", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Additional details about where the content was created (e.g. 
/// clinical specialty)
/// <p>
/// any FHIR2 code may be used; 
/// c80-practice-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property practiceSetting As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "practiceSetting", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Patient demographics from source.
/// <p>
/// Patient
Property sourcePatientInfo As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "sourcePatientInfo", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Related identifiers or resources.
Property related As list Of HS.FHIR.DTL.vDSTU2.Model.Element.DocumentReference.context.related(XMLNAME = "related", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DocumentReference.context";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DocumentReference.context";

}
