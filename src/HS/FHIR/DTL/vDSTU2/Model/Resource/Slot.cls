/// A slot of time on a schedule that may be available for booking appointments.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Slot Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External Ids for this item.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// The type of appointments that can be booked into this slot (ideally this would be an identifiable service - which is at a location, 
/// rather than the location itself). 
/// If provided then this overrides the value provided on the availability resource.
/// <p>
/// c80-practice-codes is the PREFERRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in c80-practice-codes, 
/// you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The schedule resource that this slot defines an interval of status information.
/// <p>
/// Schedule
Property schedule As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "schedule", XMLPROJECTION = "ELEMENT") [ Required ];

/// code
/// <p>
/// busy | free | busy-unavailable | busy-tentative
/// <p>
/// slotstatus is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend slotstatus and you may NOT use codes from other ValueSets.
Property freeBusyType As %String(MAXLEN = 1000000, XMLNAME = "freeBusyType", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// instant
/// <p>
/// Date/Time that the slot is to begin.
Property start As %String(MAXLEN = 1000000, XMLNAME = "start", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// instant
/// <p>
/// Date/Time that the slot is to conclude.
Property end As %String(MAXLEN = 1000000, XMLNAME = "end", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// This slot has already been overbooked, 
/// appointments are unlikely to be accepted for this time.
Property overbooked As %Boolean(XMLNAME = "overbooked", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Comments on the slot to describe any extended information. 
/// Such as custom constraints on the slot.
Property comment As %String(MAXLEN = 1000000, XMLNAME = "comment", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Slot";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Slot";

}
