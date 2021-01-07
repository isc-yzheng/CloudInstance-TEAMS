/// The suspected agent causing the adverse event.
Class HS.FHIR.DTL.vSTU3.Model.Element.AdverseEvent.suspectEntity Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Refers to the specific entity that caused the adverse event.
/// <p>
/// Substance | Medication | MedicationAdministration | MedicationStatement | Device
Property instance As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "instance", XMLPROJECTION = "ELEMENT") [ Required ];

/// code
/// <p>
/// causality1 | causality2
/// <p>
/// adverse-event-causality is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend adverse-event-causality and you may NOT use codes from other ValueSets.
Property causality As %String(MAXLEN = 1000000, XMLNAME = "causality", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// assess1 | assess2
/// <p>
/// any FHIR3 code may be used; 
/// adverse-event-causality-assess shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property causalityAssessment As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "causalityAssessment", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// AdverseEvent:suspectEntity.causalityProductRelatedness.
Property causalityProductRelatedness As %String(MAXLEN = 1000000, XMLNAME = "causalityProductRelatedness", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// method1 | method2
/// <p>
/// any FHIR3 code may be used; 
/// adverse-event-causality-method shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property causalityMethod As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "causalityMethod", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// AdverseEvent:suspectEntity.causalityAuthor.
/// <p>
/// Practitioner | PractitionerRole
Property causalityAuthor As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "causalityAuthor", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// result1 | result2
/// <p>
/// any FHIR3 code may be used; 
/// adverse-event-causality-result shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property causalityResult As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "causalityResult", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AdverseEvent.suspectEntity";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "AdverseEvent.suspectEntity";

}
