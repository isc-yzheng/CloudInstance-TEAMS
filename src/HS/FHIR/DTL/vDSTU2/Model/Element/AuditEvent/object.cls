/// Specific instances of data or objects that have been accessed.
Class HS.FHIR.DTL.vDSTU2.Model.Element.AuditEvent.object Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Specific instance of object (e.g. 
/// versioned)
Property identifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Specific instance of resource (e.g. 
/// versioned)
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property reference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "reference", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Type of object involved.
/// <p>
/// object-type is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in object-type, 
/// you may formally EXTEND object-type to add codes to it.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// What role the Object played.
/// <p>
/// object-role is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in object-role, 
/// you may formally EXTEND object-role to add codes to it.
Property role As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "role", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Life-cycle stage for the object.
/// <p>
/// object-lifecycle is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in object-lifecycle, 
/// you may formally EXTEND object-lifecycle to add codes to it.
Property lifecycle As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "lifecycle", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Security labels applied to the object.
/// <p>
/// security-labels is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in security-labels, 
/// you may formally EXTEND security-labels to add codes to it.
Property securityLabel As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "securityLabel", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Instance-specific descriptor for Object.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Descriptive text.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// base64Binary
/// <p>
/// Actual query for object.
Property query As %Binary(XMLNAME = "query", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Additional Information about the Object.
Property detail As list Of HS.FHIR.DTL.vDSTU2.Model.Element.AuditEvent.object.detail(XMLNAME = "detail", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AuditEvent.object";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "AuditEvent.object";

}
