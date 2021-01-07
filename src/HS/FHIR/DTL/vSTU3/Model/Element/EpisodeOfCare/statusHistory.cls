/// Past list of status codes (the current status may be included to cover the start date of the status)
Class HS.FHIR.DTL.vSTU3.Model.Element.EpisodeOfCare.statusHistory Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// planned | waitlist | active | onhold | finished | cancelled | entered-in-error
/// <p>
/// episode-of-care-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend episode-of-care-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Period
/// <p>
/// Duration the EpisodeOfCare was in the specified status.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "EpisodeOfCare.statusHistory";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "EpisodeOfCare.statusHistory";

}
