/// What operations are supported?
Class HS.FHIR.DTL.vSTU3.Model.Element.CapabilityStatement.rest.resource.interaction Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// read | vread | update | patch | delete | history-instance | history-type | create | search-type
/// <p>
/// type-restful-interaction is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend type-restful-interaction and you may NOT use codes from other ValueSets.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Anything special about operation behavior.
Property documentation As %String(MAXLEN = 1000000, XMLNAME = "documentation", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CapabilityStatement.rest.resource.interaction";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CapabilityStatement.rest.resource.interaction";

}
