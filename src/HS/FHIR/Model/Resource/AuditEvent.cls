/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.AuditEvent when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.AuditEvent Extends HS.FHIR.Model.Base.DomainResource [ Deprecated, ProcedureBlock ]
{

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "AuditEvent";

///  
Parameter XMLSEQUENCE = 1;

///  
Property event As HS.FHIR.Model.Resource.AuditEvent.Event(XMLNAME = "event") [ Required ];

///  
Property participant As list Of HS.FHIR.Model.Resource.AuditEvent.Participant(XMLNAME = "participant", XMLPROJECTION = "ELEMENT") [ Required ];

///  
Property source As HS.FHIR.Model.Resource.AuditEvent.Source(XMLNAME = "source") [ Required ];

///  
Property object As list Of HS.FHIR.Model.Resource.AuditEvent.Object(XMLNAME = "object", XMLPROJECTION = "ELEMENT");

}
