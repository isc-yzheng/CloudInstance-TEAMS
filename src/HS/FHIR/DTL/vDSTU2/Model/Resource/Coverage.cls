/// Insurance or medical plan.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Coverage Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// An identifier for the plan issuer.
/// <p>
/// Organization
Property issuer As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "issuer", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// BIN Number.
Property bin As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "bin", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Coverage start and end dates.
Property period As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Type of coverage.
/// <p>
/// any FHIR2 code may be used; 
/// v3-ActCoverageTypeCode shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Subscriber ID.
Property subscriberId As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "subscriberId", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// The primary coverage ID.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// An identifier for the group.
Property group As %String(MAXLEN = 1000000, XMLNAME = "group", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// An identifier for the plan.
Property plan As %String(MAXLEN = 1000000, XMLNAME = "plan", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// An identifier for the subsection of the plan.
Property subPlan As %String(MAXLEN = 1000000, XMLNAME = "subPlan", XMLPROJECTION = "ATTRIBUTE");

/// positiveInt
/// <p>
/// The dependent number.
Property dependent As %Integer(XMLNAME = "dependent", XMLPROJECTION = "ATTRIBUTE");

/// positiveInt
/// <p>
/// The plan instance or sequence counter.
Property sequence As %Integer(XMLNAME = "sequence", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Plan holder information.
/// <p>
/// Patient
Property subscriber As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subscriber", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Insurer network.
Property network As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "network", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Contract details.
/// <p>
/// Contract
Property contract As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "contract", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Coverage";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Coverage";

}
