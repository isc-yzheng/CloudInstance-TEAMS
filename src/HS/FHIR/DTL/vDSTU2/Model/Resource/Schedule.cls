/// A container for slot(s) of time that may be available for booking appointments.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Schedule Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External Ids for this item.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// The schedule type can be used for the categorization of healthcare services or other appointment types.
/// <p>
/// c80-practice-codes is the PREFERRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in c80-practice-codes, 
/// you may use codes from any ValueSet.
Property type As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The resource this Schedule resource is providing availability information for. 
/// These are expected to usually be one of HealthcareService, 
/// Location, 
/// Practitioner, 
/// Device, 
/// Patient or RelatedPerson.
/// <p>
/// Patient | Practitioner | RelatedPerson | Device | HealthcareService | Location
Property actor As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "actor", XMLPROJECTION = "ELEMENT") [ Required ];

/// Period
/// <p>
/// The period of time that the slots that are attached to this Schedule resource cover (even if none exist). 
/// These  cover the amount of time that an organization's planning horizon; 
/// the interval for which they are currently accepting appointments. 
/// This does not define a "template" for planning outside these dates.
Property planningHorizon As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "planningHorizon", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Comments on the availability to describe any extended information. 
/// Such as custom constraints on the slot(s) that may be associated.
Property comment As %String(MAXLEN = 1000000, XMLNAME = "comment", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Schedule";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Schedule";

}
