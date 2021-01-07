/// The resource ChargeItem describes the provision of healthcare provider products for a certain patient, 
/// therefore referring not only to the product, 
/// but containing in addition details of the provision, 
/// like date, 
/// time, 
/// amounts and participating organizations and persons. 
/// Main Usage of the ChargeItem is to enable the billing process and internal cost allocation.
Class HS.FHIR.DTL.vSTU3.Model.Resource.ChargeItem Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business Identifier for item.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Defining information about the code of this charge item.
Property definition As list Of %String(MAXLEN = 1000000, XMLNAME = "definition", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// planned | billable | not-billable | aborted | billed | entered-in-error | unknown
/// <p>
/// any FHIR3 code may be used; 
/// chargeitem-status shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Part of referenced ChargeItem.
/// <p>
/// ChargeItem
Property partOf As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "partOf", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// A code that identifies the charge, 
/// like a billing code.
/// <p>
/// chargeitem-billingcodes is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend chargeitem-billingcodes and you may NOT use codes from other ValueSets.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Individual service was done for/to.
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Encounter / Episode associated with event.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
///  When the charged service was applied.
Property occurrenceDateTime As %String(MAXLEN = 1000000, XMLNAME = "occurrenceDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
///  When the charged service was applied.
Property occurrencePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "occurrencePeriod", XMLPROJECTION = "ELEMENT");

/// Timing
/// <p>
///  When the charged service was applied.
Property occurrenceTiming As HS.FHIR.DTL.vSTU3.Model.Datatype.Timing(XMLNAME = "occurrenceTiming", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Who performed charged service.
Property participant As list Of HS.FHIR.DTL.vSTU3.Model.Element.ChargeItem.participant(XMLNAME = "participant", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Organization providing the charged sevice.
/// <p>
/// Organization
Property performingOrganization As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "performingOrganization", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Organization requesting the charged service.
/// <p>
/// Organization
Property requestingOrganization As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "requestingOrganization", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// Quantity of which the charge item has been serviced.
Property quantity As HS.FHIR.DTL.vSTU3.Model.Datatype.Quantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Anatomical location, 
/// if relevant.
/// <p>
/// any FHIR3 code may be used; 
/// body-site shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property bodysite As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "bodysite", XMLPROJECTION = "ELEMENT");

/// decimal
/// <p>
/// Factor overriding the associated rules.
Property factorOverride As %Decimal(XMLNAME = "factorOverride", XMLPROJECTION = "ATTRIBUTE");

/// Money
/// <p>
/// Price overriding the associated rules.
Property priceOverride As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "priceOverride", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Reason for overriding the list price/factor.
Property overrideReason As %String(MAXLEN = 1000000, XMLNAME = "overrideReason", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Individual who was entering.
/// <p>
/// Practitioner | Organization | Patient | Device | RelatedPerson
Property enterer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "enterer", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date the charge item was entered.
Property enteredDate As %String(MAXLEN = 1000000, XMLNAME = "enteredDate", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Why was the charged  service rendered?
/// <p>
/// any FHIR3 code may be used; 
/// icd-10 shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reason As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Which rendered service is being charged?
/// <p>
/// DiagnosticReport | ImagingStudy | Immunization | MedicationAdministration | MedicationDispense | Observation | Procedure | SupplyDelivery
Property service As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "service", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Account to place this charge.
/// <p>
/// Account
Property account As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "account", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Comments made about the ChargeItem.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Further information supporting the this charge.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property supportingInformation As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "supportingInformation", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ChargeItem";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ChargeItem";

}
