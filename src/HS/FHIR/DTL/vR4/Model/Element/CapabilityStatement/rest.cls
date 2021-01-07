/// If the endpoint is a RESTful one.
Class HS.FHIR.DTL.vR4.Model.Element.CapabilityStatement.rest Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// client | server
/// <p>
/// restful-capability-mode|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend restful-capability-mode|4.0.1 and you may NOT use codes from other ValueSets.
Property mode As %String(MAXLEN = 1000000, XMLNAME = "mode", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// markdown
/// <p>
/// General description of implementation.
Property documentation As %String(MAXLEN = 1000000, XMLNAME = "documentation", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Information about security of implementation.
Property security As HS.FHIR.DTL.vR4.Model.Element.CapabilityStatement.rest.security(XMLNAME = "security", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Resource served on the REST interface.
Property resource As list Of HS.FHIR.DTL.vR4.Model.Element.CapabilityStatement.rest.resource(XMLNAME = "resource", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// What operations are supported?
Property interaction As list Of HS.FHIR.DTL.vR4.Model.Element.CapabilityStatement.rest.interaction(XMLNAME = "interaction", XMLPROJECTION = "ELEMENT");

/// CapabilityStatement:rest[n].resource[n].searchParam
/// <p>
/// Search parameters for searching all resources.
Property searchParam As list Of HS.FHIR.DTL.vR4.Model.Element.CapabilityStatement.rest.resource.searchParam(XMLNAME = "searchParam", XMLPROJECTION = "ELEMENT");

/// CapabilityStatement:rest[n].resource[n].operation
/// <p>
/// Definition of a system level operation.
Property operation As list Of HS.FHIR.DTL.vR4.Model.Element.CapabilityStatement.rest.resource.operation(XMLNAME = "operation", XMLPROJECTION = "ELEMENT");

/// canonical
/// <p>
/// Compartments served/used by system.
/// <p>
/// TO DO: Unrecognized value type for the FHIR4 model
Property compartment As list Of %String(MAXLEN = 1000000, XMLNAME = "compartment", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CapabilityStatement.rest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CapabilityStatement.rest";

}
