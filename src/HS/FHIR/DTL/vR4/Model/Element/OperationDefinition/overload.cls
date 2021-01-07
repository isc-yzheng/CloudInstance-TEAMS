/// Define overloaded variants for when  generating code.
Class HS.FHIR.DTL.vR4.Model.Element.OperationDefinition.overload Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Name of parameter to include in overload.
Property parameterName As list Of %String(MAXLEN = 1000000, XMLNAME = "parameterName", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Comments to go on overload.
Property comment As %String(MAXLEN = 1000000, XMLNAME = "comment", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "OperationDefinition.overload";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "OperationDefinition.overload";

}
