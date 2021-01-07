/// Specific service delivered or performed.
Class HS.FHIR.DTL.vDSTU2.Model.Element.HealthcareService.serviceType Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Type of service delivered or performed.
/// <p>
/// c80-practice-codes is the PREFERRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in c80-practice-codes, 
/// you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Specialties handled by the Service Site.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property specialty As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "specialty", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "HealthcareService.serviceType";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "HealthcareService.serviceType";

}
