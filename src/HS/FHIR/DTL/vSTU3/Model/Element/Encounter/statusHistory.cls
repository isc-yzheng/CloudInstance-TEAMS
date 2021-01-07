/// List of past encounter statuses.
Class HS.FHIR.DTL.vSTU3.Model.Element.Encounter.statusHistory Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// planned | arrived | triaged | in-progress | onleave | finished | cancelled +
/// <p>
/// encounter-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend encounter-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Period
/// <p>
/// The time that the episode was in the specified status.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Encounter.statusHistory";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Encounter.statusHistory";

}
