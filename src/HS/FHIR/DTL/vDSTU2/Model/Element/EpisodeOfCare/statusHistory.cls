/// Past list of status codes.
Class HS.FHIR.DTL.vDSTU2.Model.Element.EpisodeOfCare.statusHistory Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// planned | waitlist | active | onhold | finished | cancelled
/// <p>
/// episode-of-care-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend episode-of-care-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Period
/// <p>
/// Period for the status.
Property period As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "EpisodeOfCare.statusHistory";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "EpisodeOfCare.statusHistory";

}
