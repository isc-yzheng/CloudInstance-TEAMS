/// Item containing charge code(s) associated with the provision of healthcare provider products.
Class HS.FHIR.DTL.vR4.Model.Resource.ChargeItem Extends HS.FHIR.DTL.vR4.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business Identifier for item.
Property identifier As list Of HS.FHIR.DTL.vR4.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Defining information about the code of this charge item.
Property definitionUri As list Of %String(MAXLEN = 1000000, XMLNAME = "definitionUri", XMLPROJECTION = "ELEMENT");

/// canonical
/// <p>
/// Resource defining the code of this ChargeItem.
/// <p>
/// TO DO: Unrecognized value type for the FHIR4 model
Property definitionCanonical As list Of %String(MAXLEN = 1000000, XMLNAME = "definitionCanonical", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// planned | billable | not-billable | aborted | billed | entered-in-error | unknown
/// <p>
/// chargeitem-status|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend chargeitem-status|4.0.1 and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Part of referenced ChargeItem.
/// <p>
/// ChargeItem
Property partOf As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "partOf", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// A code that identifies the charge, 
/// like a billing code.
/// <p>
/// any FHIR4 code may be used; 
/// chargeitem-billingcodes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Individual service was done for/to.
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Encounter / Episode associated with event.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the charged service was applied.
Property occurrenceDateTime As %String(MAXLEN = 1000000, XMLNAME = "occurrenceDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// When the charged service was applied.
Property occurrencePeriod As HS.FHIR.DTL.vR4.Model.Datatype.Period(XMLNAME = "occurrencePeriod", XMLPROJECTION = "ELEMENT");

/// Timing
/// <p>
/// When the charged service was applied.
Property occurrenceTiming As HS.FHIR.DTL.vR4.Model.Datatype.Timing(XMLNAME = "occurrenceTiming", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Who performed charged service.
Property performer As list Of HS.FHIR.DTL.vR4.Model.Element.ChargeItem.performer(XMLNAME = "performer", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Organization providing the charged service.
/// <p>
/// Organization
Property performingOrganization As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "performingOrganization", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Organization requesting the charged service.
/// <p>
/// Organization
Property requestingOrganization As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "requestingOrganization", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Organization that has ownership of the (potential, 
/// future) revenue.
/// <p>
/// Organization
Property costCenter As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "costCenter", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// Quantity of which the charge item has been serviced.
Property quantity As HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Anatomical location, 
/// if relevant.
/// <p>
/// any FHIR4 code may be used; 
/// body-site shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property bodysite As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "bodysite", XMLPROJECTION = "ELEMENT");

/// decimal
/// <p>
/// Factor overriding the associated rules.
Property factorOverride As %Decimal(XMLNAME = "factorOverride", XMLPROJECTION = "ATTRIBUTE");

/// Money
/// <p>
/// Price overriding the associated rules.
Property priceOverride As HS.FHIR.DTL.vR4.Model.Datatype.Money(XMLNAME = "priceOverride", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Reason for overriding the list price/factor.
Property overrideReason As %String(MAXLEN = 1000000, XMLNAME = "overrideReason", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Individual who was entering.
/// <p>
/// Practitioner | PractitionerRole | Organization | Patient | Device | RelatedPerson
Property enterer As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "enterer", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date the charge item was entered.
Property enteredDate As %String(MAXLEN = 1000000, XMLNAME = "enteredDate", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Why was the charged  service rendered?
/// <p>
/// any FHIR4 code may be used; 
/// icd-10 shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reason As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Which rendered service is being charged?
/// <p>
/// DiagnosticReport | ImagingStudy | Immunization | MedicationAdministration | MedicationDispense | Observation | Procedure | SupplyDelivery
Property service As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "service", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Product charged.
/// <p>
/// any FHIR4 code may be used; 
/// device-kind shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property productCodeableConcept As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "productCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Product charged.
/// <p>
/// Device | Medication | Substance
Property productReference As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "productReference", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Account to place this charge.
/// <p>
/// Account
Property account As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "account", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Comments made about the ChargeItem.
Property note As list Of HS.FHIR.DTL.vR4.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Further information supporting this charge.
/// <p>
/// Any FHIR4 Resource may be indicated by this Reference
Property supportingInformation As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "supportingInformation", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ChargeItem";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ChargeItem";

}
