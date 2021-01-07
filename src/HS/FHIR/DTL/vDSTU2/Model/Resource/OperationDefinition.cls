/// Definition of an operation or a named query.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.OperationDefinition Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Logical URL to reference this operation definition.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Logical id for this version of the operation definition.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Informal name for this operation.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// draft | active | retired
/// <p>
/// conformance-resource-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend conformance-resource-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// operation | query
/// <p>
/// operation-kind is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend operation-kind and you may NOT use codes from other ValueSets.
Property kind As %String(MAXLEN = 1000000, XMLNAME = "kind", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// If for testing purposes, 
/// not real usage.
Property experimental As %Boolean(XMLNAME = "experimental", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name of the publisher (Organization or individual)
Property publisher As %String(MAXLEN = 1000000, XMLNAME = "publisher", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Contact details of the publisher.
Property contact As list Of HS.FHIR.DTL.vDSTU2.Model.Element.OperationDefinition.contact(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date for this version of the operation definition.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Natural language description of the operation.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Why is this needed?
Property requirements As %String(MAXLEN = 1000000, XMLNAME = "requirements", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Whether content is unchanged by operation.
Property idempotent As %Boolean(XMLNAME = "idempotent", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Name used to invoke the operation.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Additional information about use.
Property notes As %String(MAXLEN = 1000000, XMLNAME = "notes", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Marks this as a profile of the base.
/// <p>
/// OperationDefinition
Property base As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "base", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Invoke at the system level?
Property system As %Boolean(XMLNAME = "system", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// Invoke at resource level for these type.
/// <p>
/// resource-types is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend resource-types and you may NOT use codes from other ValueSets.
Property type As list Of %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Invoke on an instance?
Property instance As %Boolean(XMLNAME = "instance", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// BackboneElement
/// <p>
/// Parameters for the operation/query. 
/// Each member of the OperationDefinition:parameter collection must have OperationDefinition:parameter[n].type or OperationDefinition:parameter[n].parts, 
/// but not both.
Property parameter As list Of HS.FHIR.DTL.vDSTU2.Model.Element.OperationDefinition.parameter(XMLNAME = "parameter", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "OperationDefinition";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "OperationDefinition";

}
