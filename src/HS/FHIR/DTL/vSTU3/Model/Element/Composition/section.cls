/// Composition is broken into sections.
Class HS.FHIR.DTL.vSTU3.Model.Element.Composition.section Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Label for section (e.g. 
/// for ToC)
Property title As %String(MAXLEN = 1000000, XMLNAME = "title", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Classification of section (recommended)
/// <p>
/// any FHIR3 code may be used; 
/// doc-section-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// Narrative
/// <p>
/// Text summary of the section, 
/// for human interpretation.
Property text As HS.FHIR.DTL.vSTU3.Model.Base.Narrative(XMLNAME = "text", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// working | snapshot | changes
/// <p>
/// list-mode is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend list-mode and you may NOT use codes from other ValueSets.
Property mode As %String(MAXLEN = 1000000, XMLNAME = "mode", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Order of section entries.
/// <p>
/// list-order is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in list-order, 
/// you may use codes from any ValueSet.
Property orderedBy As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "orderedBy", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// A reference to data that supports this section.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property entry As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "entry", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Why the section is empty.
/// <p>
/// list-empty-reason is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in list-empty-reason, 
/// you may use codes from any ValueSet.
Property emptyReason As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "emptyReason", XMLPROJECTION = "ELEMENT");

/// Composition:section
/// <p>
/// Nested Section.
Property section As list Of HS.FHIR.DTL.vSTU3.Model.Element.Composition.section(XMLNAME = "section", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Composition.section";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Composition.section";

}
