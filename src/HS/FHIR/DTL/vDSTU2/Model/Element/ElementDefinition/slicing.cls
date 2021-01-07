/// This element is sliced - slices follow. 
/// If there are no discriminators.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ElementDefinition.slicing Extends HS.FHIR.DTL.vDSTU2.Model.Base.Element [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Element values that are used to distinguish the slices.
Property discriminator As list Of %String(MAXLEN = 1000000, XMLNAME = "discriminator", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Text description of how slicing works (or not)
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// If elements must be in same order as slices.
Property ordered As %Boolean(XMLNAME = "ordered", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// closed | open | openAtEnd
/// <p>
/// resource-slicing-rules is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend resource-slicing-rules and you may NOT use codes from other ValueSets.
Property rules As %String(MAXLEN = 1000000, XMLNAME = "rules", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "slicing";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "slicing";

}
