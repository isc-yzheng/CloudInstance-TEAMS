/// Link to another patient resource that concerns the same actual person.
Class HS.FHIR.DTL.vSTU3.Model.Element.Patient.link Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// The other patient or related person resource that the link refers to.
/// <p>
/// Patient | RelatedPerson
Property other As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "other", XMLPROJECTION = "ELEMENT") [ Required ];

/// code
/// <p>
/// replaced-by | replaces | refer | seealso
/// <p>
/// link-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend link-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Patient.link";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Patient.link";

}
