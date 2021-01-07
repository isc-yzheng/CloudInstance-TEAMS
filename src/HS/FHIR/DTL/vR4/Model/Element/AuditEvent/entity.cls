/// Data or objects used.
Class HS.FHIR.DTL.vR4.Model.Element.AuditEvent.entity Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Specific instance of resource.
/// <p>
/// Any FHIR4 Resource may be indicated by this Reference
Property what As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "what", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Type of entity involved.
/// <p>
/// audit-entity-type is the REQUIRED FHIR4 ValueSet for codes, 
/// but if you need to express meanings not found in audit-entity-type, 
/// you may formally EXTEND audit-entity-type to add codes to it.
Property type As HS.FHIR.DTL.vR4.Model.Datatype.Coding(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// What role the entity played.
/// <p>
/// object-role is the REQUIRED FHIR4 ValueSet for codes, 
/// but if you need to express meanings not found in object-role, 
/// you may formally EXTEND object-role to add codes to it.
Property role As HS.FHIR.DTL.vR4.Model.Datatype.Coding(XMLNAME = "role", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Life-cycle stage for the entity.
/// <p>
/// object-lifecycle-events is the REQUIRED FHIR4 ValueSet for codes, 
/// but if you need to express meanings not found in object-lifecycle-events, 
/// you may formally EXTEND object-lifecycle-events to add codes to it.
Property lifecycle As HS.FHIR.DTL.vR4.Model.Datatype.Coding(XMLNAME = "lifecycle", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Security labels on the entity.
/// <p>
/// security-labels is the REQUIRED FHIR4 ValueSet for codes, 
/// but if you need to express meanings not found in security-labels, 
/// you may formally EXTEND security-labels to add codes to it.
Property securityLabel As list Of HS.FHIR.DTL.vR4.Model.Datatype.Coding(XMLNAME = "securityLabel", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Descriptor for entity.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Descriptive text.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// base64Binary
/// <p>
/// Query parameters.
Property query As %Binary(XMLNAME = "query", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Additional Information about the entity.
Property detail As list Of HS.FHIR.DTL.vR4.Model.Element.AuditEvent.entity.detail(XMLNAME = "detail", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AuditEvent.entity";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "AuditEvent.entity";

}
