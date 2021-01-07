/// Responses to this message.
Class HS.FHIR.DTL.vSTU3.Model.Element.MessageDefinition.allowedResponse Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Reference to allowed message definition response.
/// <p>
/// MessageDefinition
Property message As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "message", XMLPROJECTION = "ELEMENT") [ Required ];

/// markdown
/// <p>
/// When should this response be used.
Property situation As %String(MAXLEN = 1000000, XMLNAME = "situation", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MessageDefinition.allowedResponse";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MessageDefinition.allowedResponse";

}
