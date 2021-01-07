/// If the endpoint is a RESTful one.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.rest Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// client | server
/// <p>
/// restful-conformance-mode is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend restful-conformance-mode and you may NOT use codes from other ValueSets.
Property mode As %String(MAXLEN = 1000000, XMLNAME = "mode", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// General description of implementation.
Property documentation As %String(MAXLEN = 1000000, XMLNAME = "documentation", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Information about security of implementation.
Property security As HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.rest.security(XMLNAME = "security", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Resource served on the REST interface.
Property resource As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.rest.resource(XMLNAME = "resource", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// What operations are supported?
Property interaction As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.rest.interaction(XMLNAME = "interaction", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// not-supported | batch | transaction | both
/// <p>
/// transaction-mode is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend transaction-mode and you may NOT use codes from other ValueSets.
Property transactionMode As %String(MAXLEN = 1000000, XMLNAME = "transactionMode", XMLPROJECTION = "ATTRIBUTE");

/// Conformance:rest[n].resource[n].searchParam
/// <p>
/// Search params for searching all resources.
Property searchParam As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.rest.resource.searchParam(XMLNAME = "searchParam", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Definition of an operation or a custom query.
Property operation As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.rest.operation(XMLNAME = "operation", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Compartments served/used by system.
Property compartment As list Of %String(MAXLEN = 1000000, XMLNAME = "compartment", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Conformance.rest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Conformance.rest";

}
