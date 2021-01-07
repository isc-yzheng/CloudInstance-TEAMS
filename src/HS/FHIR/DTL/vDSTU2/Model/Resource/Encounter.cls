/// An interaction during which services are provided to the patient.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Encounter Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Identifier(s) by which this encounter is known.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// planned | arrived | in-progress | onleave | finished | cancelled
/// <p>
/// encounter-state is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend encounter-state and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// BackboneElement
/// <p>
/// List of past encounter statuses.
Property statusHistory As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Encounter.statusHistory(XMLNAME = "statusHistory", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// inpatient | outpatient | ambulatory | emergency +
/// <p>
/// encounter-class is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend encounter-class and you may NOT use codes from other ValueSets.
Property class As %String(MAXLEN = 1000000, XMLNAME = "class", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Specific type of encounter.
/// <p>
/// any FHIR2 code may be used; 
/// encounter-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Indicates the urgency of the encounter.
/// <p>
/// any FHIR2 code may be used; 
/// encounter-priority shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property priority As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "priority", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The patient present at the encounter.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Episode(s) of care that this encounter should be recorded against.
/// <p>
/// EpisodeOfCare
Property episodeOfCare As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "episodeOfCare", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The ReferralRequest that initiated this encounter.
/// <p>
/// ReferralRequest
Property incomingReferral As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "incomingReferral", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// List of participants involved in the encounter.
Property participant As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Encounter.participant(XMLNAME = "participant", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The appointment that scheduled this encounter.
/// <p>
/// Appointment
Property appointment As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "appointment", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// The start and end time of the encounter.
Property period As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Duration
/// <p>
/// Quantity of time the encounter lasted (less time absent)
Property length As HS.FHIR.DTL.vDSTU2.Model.Datatype.Duration(XMLNAME = "length", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Reason the encounter takes place (code)
/// <p>
/// any FHIR2 code may be used; 
/// encounter-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reason As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Reason the encounter takes place (resource)
/// <p>
/// Condition | Procedure
Property indication As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "indication", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Details about the admission to a healthcare service.
Property hospitalization As HS.FHIR.DTL.vDSTU2.Model.Element.Encounter.hospitalization(XMLNAME = "hospitalization", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// List of locations where the patient has been.
Property location As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Encounter.location(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The custodian organization of this Encounter record.
/// <p>
/// Organization
Property serviceProvider As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "serviceProvider", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Another Encounter this encounter is part of.
/// <p>
/// Encounter
Property partOf As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "partOf", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Encounter";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Encounter";

}
