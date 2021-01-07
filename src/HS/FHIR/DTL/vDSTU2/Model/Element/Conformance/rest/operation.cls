/// Definition of an operation or a custom query.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.rest.operation Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Name by which the operation/query is invoked.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// The defined operation/query.
/// <p>
/// OperationDefinition
Property definition As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "definition", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Conformance.rest.operation";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Conformance.rest.operation";

}
