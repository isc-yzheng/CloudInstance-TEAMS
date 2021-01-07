/// Logical network location for application activity.
Class HS.FHIR.DTL.vDSTU2.Model.Element.AuditEvent.participant.network Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Identifier for the network access point of the user device.
Property address As %String(MAXLEN = 1000000, XMLNAME = "address", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// The type of network access point.
/// <p>
/// network-type is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend network-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AuditEvent.participant.network";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "AuditEvent.participant.network";

}
