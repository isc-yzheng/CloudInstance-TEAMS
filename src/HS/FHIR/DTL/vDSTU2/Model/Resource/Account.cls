/// 
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Account Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Account number.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Human-readable label.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// E.g. 
/// patient, 
/// expense, 
/// depreciation.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | inactive
/// <p>
/// account-status is the PREFERRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in account-status, 
/// you may use codes from any ValueSet.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Valid from..to.
Property activePeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "activePeriod", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Base currency in which balance is tracked.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property currency As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "currency", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// How much is in account?
Property balance As HS.FHIR.DTL.vDSTU2.Model.Datatype.Money(XMLNAME = "balance", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Transaction window.
Property coveragePeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "coveragePeriod", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// What is account tied to?
/// <p>
/// Patient | Device | Practitioner | Location | HealthcareService | Organization
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who is responsible?
/// <p>
/// Organization
Property owner As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "owner", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Explanation of purpose/use.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Account";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Account";

}
