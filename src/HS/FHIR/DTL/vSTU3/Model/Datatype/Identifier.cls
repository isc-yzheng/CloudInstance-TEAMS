/// A numeric or alphanumeric string that is associated with a single object or entity within a given system. 
/// Typically, 
/// identifiers are used to connect content in resources to external content available in other frameworks or protocols. 
/// Identifiers are associated with objects, 
/// and may be changed or retired due to human or system process and errors.
Class HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// code
/// <p>
/// usual | official | temp | secondary (If known)
/// <p>
/// identifier-use is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend identifier-use and you may NOT use codes from other ValueSets.
Property use As %String(MAXLEN = 1000000, XMLNAME = "use", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Description of identifier.
/// <p>
/// identifier-type is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in identifier-type, 
/// you may formally EXTEND identifier-type to add codes to it.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// The namespace for the identifier value.
Property system As %String(MAXLEN = 1000000, XMLNAME = "system", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// The value that is unique.
Property value As %String(MAXLEN = 1000000, XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Time period when id is/was valid for use.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Organization that issued id (may be just text)
/// <p>
/// Organization
Property assigner As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "assigner", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Identifier";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Identifier";

}
