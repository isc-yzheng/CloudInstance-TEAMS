/// Details about the admission to a healthcare service.
Class HS.FHIR.DTL.vSTU3.Model.Element.Encounter.hospitalization Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Pre-admission identifier.
Property preAdmissionIdentifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "preAdmissionIdentifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The location from which the patient came before admission.
/// <p>
/// Location
Property origin As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "origin", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// From where patient was admitted (physician referral, 
/// transfer)
/// <p>
/// encounter-admit-source is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in encounter-admit-source, 
/// you may use codes from any ValueSet.
Property admitSource As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "admitSource", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// The type of hospital re-admission that has occurred (if any). 
/// If the value is absent, 
/// then this is not identified as a readmission.
/// <p>
/// any FHIR3 code may be used; 
/// v2-0092 shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reAdmission As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reAdmission", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Diet preferences reported by the patient.
/// <p>
/// any FHIR3 code may be used; 
/// encounter-diet shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property dietPreference As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "dietPreference", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Special courtesies (VIP, 
/// board member)
/// <p>
/// encounter-special-courtesy is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in encounter-special-courtesy, 
/// you may use codes from any ValueSet.
Property specialCourtesy As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "specialCourtesy", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Wheelchair, 
/// translator, 
/// stretcher, 
/// etc.
/// <p>
/// encounter-special-arrangements is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in encounter-special-arrangements, 
/// you may use codes from any ValueSet.
Property specialArrangement As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "specialArrangement", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Location to which the patient is discharged.
/// <p>
/// Location
Property destination As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "destination", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Category or kind of location after discharge.
/// <p>
/// any FHIR3 code may be used; 
/// encounter-discharge-disposition shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property dischargeDisposition As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "dischargeDisposition", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Encounter.hospitalization";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Encounter.hospitalization";

}
