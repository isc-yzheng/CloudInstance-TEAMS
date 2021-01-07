/// Financial instrument which may be used to reimburse or pay for health care products and services.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Coverage Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// The primary coverage ID.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | cancelled | draft | entered-in-error
/// <p>
/// fm-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend fm-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Type of coverage such as medical or accident.
/// <p>
/// coverage-type is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in coverage-type, 
/// you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Owner of the policy.
/// <p>
/// Patient | RelatedPerson | Organization
Property policyHolder As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "policyHolder", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Subscriber to the policy.
/// <p>
/// Patient | RelatedPerson
Property subscriber As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subscriber", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// ID assigned to the Subscriber.
Property subscriberId As %String(MAXLEN = 1000000, XMLNAME = "subscriberId", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Plan Beneficiary.
/// <p>
/// Patient
Property beneficiary As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "beneficiary", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Beneficiary relationship to the Subscriber.
/// <p>
/// any FHIR3 code may be used; 
/// policyholder-relationship shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property relationship As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "relationship", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Coverage start and end dates.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Identifier for the plan or agreement issuer.
/// <p>
/// Organization | Patient | RelatedPerson
Property payor As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "payor", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Additional coverage classifications.
Property grouping As HS.FHIR.DTL.vSTU3.Model.Element.Coverage.grouping(XMLNAME = "grouping", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Dependent number.
Property dependent As %String(MAXLEN = 1000000, XMLNAME = "dependent", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// The plan instance or sequence counter.
Property sequence As %String(MAXLEN = 1000000, XMLNAME = "sequence", XMLPROJECTION = "ATTRIBUTE");

/// positiveInt
/// <p>
/// Relative order of the coverage.
Property order As %Integer(XMLNAME = "order", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Insurer network.
Property network As %String(MAXLEN = 1000000, XMLNAME = "network", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Contract details.
/// <p>
/// Contract
Property contract As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "contract", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Coverage";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Coverage";

}
