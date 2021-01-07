/// Element values that are used to distinguish the slices.
Class HS.FHIR.DTL.vSTU3.Model.Element.ElementDefinition.slicing.discriminator Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// code
/// <p>
/// value | exists | pattern | type | profile
/// <p>
/// discriminator-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend discriminator-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Path to element value.
Property path As %String(MAXLEN = 1000000, XMLNAME = "path", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "discriminator";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "discriminator";

}
