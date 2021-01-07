/// Search related information.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Bundle.entry.search Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// match | include | outcome - why this is in the result set
/// <p>
/// search-entry-mode is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend search-entry-mode and you may NOT use codes from other ValueSets.
Property mode As %String(MAXLEN = 1000000, XMLNAME = "mode", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Search ranking (between 0 and 1)
Property score As %Decimal(XMLNAME = "score", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Bundle.entry.search";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Bundle.entry.search";

}
