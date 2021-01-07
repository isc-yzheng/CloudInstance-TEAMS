Class HS.FHIR.vDSTU2.Model.Resource.AuditEvent Extends HS.FHIR.vDSTU2.Model.Base.DomainResource [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AuditEvent";

Parameter XMLSEQUENCE = 1;

/// Identifies the name, action type, time, and disposition of the audited event.
Property event As HS.FHIR.vDSTU2.Model.Resource.AuditEvent.Event(XMLNAME = "event") [ Required ];

/// A person, a hardware device or software process.
Property participant As list Of HS.FHIR.vDSTU2.Model.Resource.AuditEvent.Participant(XMLNAME = "participant", XMLPROJECTION = "ELEMENT") [ Required ];

/// Application systems and processes.
Property source As HS.FHIR.vDSTU2.Model.Resource.AuditEvent.Source(XMLNAME = "source") [ Required ];

/// Specific instances of data or objects that have been accessed.
Property object As list Of HS.FHIR.vDSTU2.Model.Resource.AuditEvent.Object(XMLNAME = "object", XMLPROJECTION = "ELEMENT");

}
