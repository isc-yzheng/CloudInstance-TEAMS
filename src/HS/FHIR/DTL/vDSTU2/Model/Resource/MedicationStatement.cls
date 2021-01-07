/// Record of medication being taken by a patient.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.MedicationStatement Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External identifier.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who is/was taking  the medication.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Patient | Practitioner | RelatedPerson
Property informationSource As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "informationSource", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the statement was asserted?
Property dateAsserted As %String(MAXLEN = 1000000, XMLNAME = "dateAsserted", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// active | completed | entered-in-error | intended
/// <p>
/// medication-statement-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend medication-statement-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// True if medication is/was not being taken.
Property wasNotTaken As %Boolean(XMLNAME = "wasNotTaken", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// True if asserting medication was not given.
/// <p>
/// any FHIR2 code may be used; 
/// reason-medication-not-given-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonNotTaken As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reasonNotTaken", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// any FHIR2 code may be used; 
/// condition-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonForUseCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reasonForUseCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Condition.
Property reasonForUseReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "reasonForUseReference", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Over what period was medication consumed?
Property effectiveDateTime As %String(MAXLEN = 1000000, XMLNAME = "effectiveDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Over what period was medication consumed?
Property effectivePeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "effectivePeriod", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Further information about the statement.
Property note As %String(MAXLEN = 1000000, XMLNAME = "note", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Additional supporting information.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property supportingInformation As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "supportingInformation", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// What medication was taken.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property medicationCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "medicationCodeableConcept", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// What medication was taken.
/// <p>
/// Medication.
Property medicationReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "medicationReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// Details of how medication was taken.
Property dosage As list Of HS.FHIR.DTL.vDSTU2.Model.Element.MedicationStatement.dosage(XMLNAME = "dosage", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationStatement";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicationStatement";

}
