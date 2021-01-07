/// The designation to be excluded.
Class HS.FHIR.DTL.vSTU3.Model.Element.ExpansionProfile.designation.exclude.designation Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// Human language of the designation to be excluded.
/// <p>
/// languages is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in languages, 
/// you may formally EXTEND languages to add codes to it.
Property language As %String(MAXLEN = 1000000, XMLNAME = "language", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// What kind of Designation to exclude.
/// <p>
/// designation-use is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend designation-use and you may NOT use codes from other ValueSets.
Property use As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "use", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExpansionProfile.designation.exclude.designation";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExpansionProfile.designation.exclude.designation";

}
