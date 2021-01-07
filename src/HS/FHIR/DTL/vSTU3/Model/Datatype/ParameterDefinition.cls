/// The ParameterDefinition structure defines a parameter to a knowledge asset such as a decision support rule or quality measure. 
/// Parameters are typically used to communicate patient-independent information such as configuration values, 
/// whereas DataRequirements are typically used to communicate patient-dependent information such as MedicationStatements and Encounters.
Class HS.FHIR.DTL.vSTU3.Model.Datatype.ParameterDefinition Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// code
/// <p>
/// Name used to access the parameter value.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// in | out
/// <p>
/// operation-parameter-use is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend operation-parameter-use and you may NOT use codes from other ValueSets.
Property use As %String(MAXLEN = 1000000, XMLNAME = "use", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// integer
/// <p>
/// Minimum cardinality.
Property min As %Integer(XMLNAME = "min", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Maximum cardinality (a number of *)
Property max As %String(MAXLEN = 1000000, XMLNAME = "max", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// A brief description of the parameter.
Property documentation As %String(MAXLEN = 1000000, XMLNAME = "documentation", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// What type of value.
/// <p>
/// all-types is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend all-types and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// What profile the value is expected to be.
/// <p>
/// StructureDefinition
Property profile As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "profile", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ParameterDefinition";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ParameterDefinition";

}
