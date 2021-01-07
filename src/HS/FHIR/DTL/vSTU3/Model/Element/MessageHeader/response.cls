/// If this is a reply to prior message.
Class HS.FHIR.DTL.vSTU3.Model.Element.MessageHeader.response Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// id
/// <p>
/// Id of original message.
Property identifier As %String(MAXLEN = 1000000, XMLNAME = "identifier", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// ok | transient-error | fatal-error
/// <p>
/// response-code is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend response-code and you may NOT use codes from other ValueSets.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Specific list of hints/warnings/errors.
/// <p>
/// OperationOutcome
Property details As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "details", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MessageHeader.response";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MessageHeader.response";

}
