/// Audit Event Reporter.
Class HS.FHIR.DTL.vSTU3.Model.Element.AuditEvent.source Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Logical source location within the enterprise.
Property site As %String(MAXLEN = 1000000, XMLNAME = "site", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// The identity of source detecting the event.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT") [ Required ];

/// Coding
/// <p>
/// The type of source where event originated.
/// <p>
/// audit-source-type is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in audit-source-type, 
/// you may formally EXTEND audit-source-type to add codes to it.
Property type As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AuditEvent.source";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "AuditEvent.source";

}
