/// A financial tool for tracking value accrued for a particular purpose. 
/// In the healthcare field, 
/// used to track charges for a patient, 
/// cost centers, 
/// etc.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Account Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Account number.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | inactive | entered-in-error
/// <p>
/// account-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend account-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// E.g. 
/// patient, 
/// expense, 
/// depreciation.
/// <p>
/// any FHIR3 code may be used; 
/// account-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Human-readable label.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// What is account tied to?
/// <p>
/// Patient | Device | Practitioner | Location | HealthcareService | Organization
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Transaction window.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Time window that transactions may be posted to this account.
Property active As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "active", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// How much is in account?
Property balance As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "balance", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// The party(s) that are responsible for covering the payment of this account, 
/// and what order should they be applied to the account.
Property coverage As list Of HS.FHIR.DTL.vSTU3.Model.Element.Account.coverage(XMLNAME = "coverage", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who is responsible?
/// <p>
/// Organization
Property owner As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "owner", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Explanation of purpose/use.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Responsible for the account.
Property guarantor As list Of HS.FHIR.DTL.vSTU3.Model.Element.Account.guarantor(XMLNAME = "guarantor", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Account";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Account";

}
