/// Data controlled by this exception.
Class HS.FHIR.DTL.vSTU3.Model.Element.Consent.except.data Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// instance | related | dependents | authoredby
/// <p>
/// consent-data-meaning is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend consent-data-meaning and you may NOT use codes from other ValueSets.
Property meaning As %String(MAXLEN = 1000000, XMLNAME = "meaning", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// The actual data reference.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property reference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "reference", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Consent.except.data";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Consent.except.data";

}
