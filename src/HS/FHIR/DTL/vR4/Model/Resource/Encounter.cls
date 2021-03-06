/// An interaction during which services are provided to the patient.
Class HS.FHIR.DTL.vR4.Model.Resource.Encounter Extends HS.FHIR.DTL.vR4.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Identifier(s) by which this encounter is known.
Property identifier As list Of HS.FHIR.DTL.vR4.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// planned | arrived | triaged | in-progress | onleave | finished | cancelled +
/// <p>
/// encounter-status|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend encounter-status|4.0.1 and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// BackboneElement
/// <p>
/// List of past encounter statuses.
Property statusHistory As list Of HS.FHIR.DTL.vR4.Model.Element.Encounter.statusHistory(XMLNAME = "statusHistory", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Classification of patient encounter.
/// <p>
/// v3-ActEncounterCode is the REQUIRED FHIR4 ValueSet for codes, 
/// but if you need to express meanings not found in v3-ActEncounterCode, 
/// you may formally EXTEND v3-ActEncounterCode to add codes to it.
Property class As HS.FHIR.DTL.vR4.Model.Datatype.Coding(XMLNAME = "class", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// List of past encounter classes.
Property classHistory As list Of HS.FHIR.DTL.vR4.Model.Element.Encounter.classHistory(XMLNAME = "classHistory", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Specific type of encounter.
/// <p>
/// any FHIR4 code may be used; 
/// encounter-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Specific type of service.
/// <p>
/// any FHIR4 code may be used; 
/// service-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property serviceType As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "serviceType", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Indicates the urgency of the encounter.
/// <p>
/// any FHIR4 code may be used; 
/// v3-ActPriority shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property priority As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "priority", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The patient or group present at the encounter.
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Episode(s) of care that this encounter should be recorded against.
/// <p>
/// EpisodeOfCare
Property episodeOfCare As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "episodeOfCare", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The ServiceRequest that initiated this encounter.
/// <p>
/// ServiceRequest
Property basedOn As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "basedOn", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// List of participants involved in the encounter.
Property participant As list Of HS.FHIR.DTL.vR4.Model.Element.Encounter.participant(XMLNAME = "participant", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The appointment that scheduled this encounter.
/// <p>
/// Appointment
Property appointment As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "appointment", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// The start and end time of the encounter.
Property period As HS.FHIR.DTL.vR4.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Duration
/// <p>
/// Quantity of time the encounter lasted (less time absent)
Property length As HS.FHIR.DTL.vR4.Model.Datatype.Duration(XMLNAME = "length", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Coded reason the encounter takes place.
/// <p>
/// encounter-reason is the PREFERRED FHIR4 ValueSet for codes, 
/// but if you need to express meanings not found in encounter-reason, 
/// you may use codes from any ValueSet.
Property reasonCode As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "reasonCode", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Reason the encounter takes place (reference)
/// <p>
/// Condition | Procedure | Observation | ImmunizationRecommendation
Property reasonReference As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// The list of diagnosis relevant to this encounter.
Property diagnosis As list Of HS.FHIR.DTL.vR4.Model.Element.Encounter.diagnosis(XMLNAME = "diagnosis", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The set of accounts that may be used for billing for this Encounter.
/// <p>
/// Account
Property account As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "account", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Details about the admission to a healthcare service.
Property hospitalization As HS.FHIR.DTL.vR4.Model.Element.Encounter.hospitalization(XMLNAME = "hospitalization", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// List of locations where the patient has been.
Property location As list Of HS.FHIR.DTL.vR4.Model.Element.Encounter.location(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The organization (facility) responsible for this encounter.
/// <p>
/// Organization
Property serviceProvider As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "serviceProvider", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Another Encounter this encounter is part of.
/// <p>
/// Encounter
Property partOf As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "partOf", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Encounter";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Encounter";

}
