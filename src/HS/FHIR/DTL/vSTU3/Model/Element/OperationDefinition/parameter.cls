/// Parameters for the operation/query.
Class HS.FHIR.DTL.vSTU3.Model.Element.OperationDefinition.parameter Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// Name in Parameters.parameter.name or in URL.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// in | out
/// <p>
/// operation-parameter-use is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend operation-parameter-use and you may NOT use codes from other ValueSets.
Property use As %String(MAXLEN = 1000000, XMLNAME = "use", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// integer
/// <p>
/// Minimum Cardinality.
Property min As %Integer(XMLNAME = "min", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Maximum Cardinality (a number or *)
Property max As %String(MAXLEN = 1000000, XMLNAME = "max", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Description of meaning/use.
Property documentation As %String(MAXLEN = 1000000, XMLNAME = "documentation", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// What type this parameter has.
/// <p>
/// all-types is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend all-types and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// number | date | string | token | reference | composite | quantity | uri
/// <p>
/// search-param-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend search-param-type and you may NOT use codes from other ValueSets.
Property searchType As %String(MAXLEN = 1000000, XMLNAME = "searchType", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Profile on the type.
/// <p>
/// StructureDefinition
Property profile As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "profile", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// ValueSet details if this is coded.
Property binding As HS.FHIR.DTL.vSTU3.Model.Element.OperationDefinition.parameter.binding(XMLNAME = "binding", XMLPROJECTION = "ELEMENT");

/// OperationDefinition:parameter
/// <p>
/// Parts of a nested Parameter.
Property part As list Of HS.FHIR.DTL.vSTU3.Model.Element.OperationDefinition.parameter(XMLNAME = "part", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "OperationDefinition.parameter";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "OperationDefinition.parameter";

}
