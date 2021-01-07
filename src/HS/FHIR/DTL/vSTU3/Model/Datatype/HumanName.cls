/// A name of a human with text, 
/// parts and usage information.
Class HS.FHIR.DTL.vSTU3.Model.Datatype.HumanName Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// code
/// <p>
/// usual | official | temp | nickname | anonymous | old | maiden
/// <p>
/// name-use is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend name-use and you may NOT use codes from other ValueSets.
Property use As %String(MAXLEN = 1000000, XMLNAME = "use", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Text representation of the full name.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Family name (often called 'Surname')
Property family As %String(MAXLEN = 1000000, XMLNAME = "family", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Given names (not always 'first'). 
/// Includes middle names.
Property given As list Of %String(MAXLEN = 1000000, XMLNAME = "given", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Parts that come before the name.
Property prefix As list Of %String(MAXLEN = 1000000, XMLNAME = "prefix", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Parts that come after the name.
Property suffix As list Of %String(MAXLEN = 1000000, XMLNAME = "suffix", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Time period when name was/is in use.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "HumanName";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "HumanName";

}
