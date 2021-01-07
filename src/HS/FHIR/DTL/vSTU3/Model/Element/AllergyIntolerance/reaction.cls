/// Adverse Reaction Events linked to exposure to substance.
Class HS.FHIR.DTL.vSTU3.Model.Element.AllergyIntolerance.reaction Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Specific substance or pharmaceutical product considered to be responsible for event.
/// <p>
/// any FHIR3 code may be used; 
/// substance-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property substance As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "substance", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Clinical symptoms/signs associated with the Event.
/// <p>
/// any FHIR3 code may be used; 
/// clinical-findings shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property manifestation As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "manifestation", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
/// Description of the event as a whole.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Date(/time) when manifestations showed.
Property onset As %String(MAXLEN = 1000000, XMLNAME = "onset", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// mild | moderate | severe (of event as a whole)
/// <p>
/// reaction-event-severity is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend reaction-event-severity and you may NOT use codes from other ValueSets.
Property severity As %String(MAXLEN = 1000000, XMLNAME = "severity", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// How the subject was exposed to the substance.
/// <p>
/// any FHIR3 code may be used; 
/// route-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property exposureRoute As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "exposureRoute", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Text about event not captured in other fields.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AllergyIntolerance.reaction";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "AllergyIntolerance.reaction";

}
