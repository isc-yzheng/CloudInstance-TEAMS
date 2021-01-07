/// Event record kept for security purposes.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.AuditEvent Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// BackboneElement
/// <p>
/// What was done.
Property event As HS.FHIR.DTL.vDSTU2.Model.Element.AuditEvent.event(XMLNAME = "event", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// A person, 
/// a hardware device or software process.
Property participant As list Of HS.FHIR.DTL.vDSTU2.Model.Element.AuditEvent.participant(XMLNAME = "participant", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// Application systems and processes.
Property source As HS.FHIR.DTL.vDSTU2.Model.Element.AuditEvent.source(XMLNAME = "source", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// Specific instances of data or objects that have been accessed.
Property object As list Of HS.FHIR.DTL.vDSTU2.Model.Element.AuditEvent.object(XMLNAME = "object", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AuditEvent";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "AuditEvent";

}
