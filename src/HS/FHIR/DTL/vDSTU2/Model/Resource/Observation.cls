/// Measurements and simple assertions.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Observation Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Unique Id for this particular observation.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// registered | preliminary | final | amended +
/// <p>
/// observation-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend observation-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Classification of  type of observation.
/// <p>
/// any FHIR2 code may be used; 
/// observation-category shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Type of observation (code / type)
/// <p>
/// any FHIR2 code may be used; 
/// observation-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Who and/or what this is about.
/// <p>
/// Patient | Group | Device | Location
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Healthcare event during which this observation is made.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Clinically relevant time/time-period for observation.
Property effectiveDateTime As %String(MAXLEN = 1000000, XMLNAME = "effectiveDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Clinically relevant time/time-period for observation.
Property effectivePeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "effectivePeriod", XMLPROJECTION = "ELEMENT");

/// instant
/// <p>
/// Date/Time this was made available.
Property issued As %String(MAXLEN = 1000000, XMLNAME = "issued", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who is responsible for the observation.
/// <p>
/// Practitioner | Organization | Patient | RelatedPerson
Property performer As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "performer", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Actual result.
Property valueAttachment As HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment(XMLNAME = "valueAttachment", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Actual result.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property valueCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "valueCodeableConcept", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Actual result.
Property valueDateTime As %String(MAXLEN = 1000000, XMLNAME = "valueDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Actual result.
Property valuePeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "valuePeriod", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// Actual result.
Property valueQuantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.Quantity(XMLNAME = "valueQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Actual result.
Property valueRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "valueRange", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// Actual result.
Property valueRatio As HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio(XMLNAME = "valueRatio", XMLPROJECTION = "ELEMENT");

/// SampledData
/// <p>
/// Actual result.
Property valueSampledData As HS.FHIR.DTL.vDSTU2.Model.Datatype.SampledData(XMLNAME = "valueSampledData", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Actual result.
Property valueString As %String(MAXLEN = 1000000, XMLNAME = "valueString", XMLPROJECTION = "ATTRIBUTE");

/// time
/// <p>
/// Actual result.
Property valueTime As %String(MAXLEN = 1000000, XMLNAME = "valueTime", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Why the result is missing.
/// <p>
/// observation-valueabsentreason is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in observation-valueabsentreason, 
/// you may formally EXTEND observation-valueabsentreason to add codes to it.
Property dataAbsentReason As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "dataAbsentReason", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// High, 
/// low, 
/// normal, 
/// etc.
/// <p>
/// observation-interpretation is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in observation-interpretation, 
/// you may formally EXTEND observation-interpretation to add codes to it.
Property interpretation As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "interpretation", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Comments about result.
Property comments As %String(MAXLEN = 1000000, XMLNAME = "comments", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Observed body part.
/// <p>
/// any FHIR2 code may be used; 
/// body-site shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property bodySite As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "bodySite", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// How it was done.
/// <p>
/// any FHIR2 code may be used; 
/// observation-methods shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property method As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "method", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Specimen used for this observation.
/// <p>
/// Specimen
Property specimen As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "specimen", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// (Measurement) Device.
/// <p>
/// Device | DeviceMetric
Property device As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "device", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Provides guide for interpretation.
Property referenceRange As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Observation.referenceRange(XMLNAME = "referenceRange", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Resource related to this observation.
Property related As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Observation.related(XMLNAME = "related", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Component results.
Property component As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Observation.component(XMLNAME = "component", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Observation";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Observation";

}
