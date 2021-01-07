/// An identifier intended for computation.
Class HS.FHIR.DTL.vR4.Model.Datatype.Identifier Extends HS.FHIR.DTL.vR4.Model.Base.Element [ Not ProcedureBlock ]
{

/// code
/// <p>
/// usual | official | temp | secondary | old (If known)
/// <p>
/// identifier-use|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend identifier-use|4.0.1 and you may NOT use codes from other ValueSets.
Property use As %String(MAXLEN = 1000000, XMLNAME = "use", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Description of identifier.
/// <p>
/// identifier-type is the REQUIRED FHIR4 ValueSet for codes, 
/// but if you need to express meanings not found in identifier-type, 
/// you may formally EXTEND identifier-type to add codes to it.
Property type As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

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
Property period As HS.FHIR.DTL.vR4.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Organization that issued id (may be just text)
/// <p>
/// Organization
Property assigner As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "assigner", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Identifier";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Identifier";

}
