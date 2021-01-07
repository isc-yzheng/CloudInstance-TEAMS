/// The setup operation to perform.
Class HS.FHIR.DTL.vDSTU2.Model.Element.TestScript.setup.action.operation Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// The setup operation type that will be executed.
/// <p>
/// testscript-operation-codes is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in testscript-operation-codes, 
/// you may formally EXTEND testscript-operation-codes to add codes to it.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// Resource type.
/// <p>
/// defined-types is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend defined-types and you may NOT use codes from other ValueSets.
Property resource As %String(MAXLEN = 1000000, XMLNAME = "resource", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Tracking/logging operation label.
Property label As %String(MAXLEN = 1000000, XMLNAME = "label", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Tracking/reporting operation description.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// xml | json
/// <p>
/// content-type is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend content-type and you may NOT use codes from other ValueSets.
Property accept As %String(MAXLEN = 1000000, XMLNAME = "accept", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// xml | json
/// <p>
/// content-type is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend content-type and you may NOT use codes from other ValueSets.
Property contentType As %String(MAXLEN = 1000000, XMLNAME = "contentType", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Which server to perform the operation on.
Property destination As %Integer(XMLNAME = "destination", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Whether or not to send the request url in encoded format.
Property encodeRequestUrl As %Boolean(XMLNAME = "encodeRequestUrl", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Explicitly defined path parameters.
Property params As %String(MAXLEN = 1000000, XMLNAME = "params", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Each operation can have one ore more header elements.
Property requestHeader As list Of HS.FHIR.DTL.vDSTU2.Model.Element.TestScript.setup.action.operation.requestHeader(XMLNAME = "requestHeader", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// Fixture Id of mapped response.
Property responseId As %String(MAXLEN = 1000000, XMLNAME = "responseId", XMLPROJECTION = "ATTRIBUTE");

/// id
/// <p>
/// Fixture Id of body for PUT and POST requests.
Property sourceId As %String(MAXLEN = 1000000, XMLNAME = "sourceId", XMLPROJECTION = "ATTRIBUTE");

/// id
/// <p>
/// Id of fixture used for extracting the [id], 
///  [type], 
/// and [vid] for GET requests.
Property targetId As %String(MAXLEN = 1000000, XMLNAME = "targetId", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Request URL.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.setup.action.operation";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.setup.action.operation";

}
