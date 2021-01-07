/// Actor involved in the event.
Class HS.FHIR.DTL.vSTU3.Model.Element.AuditEvent.agent Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Agent role in the event.
/// <p>
/// security-role-type is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in security-role-type, 
/// you may formally EXTEND security-role-type to add codes to it.
Property role As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "role", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Direct reference to resource.
/// <p>
/// Practitioner | Organization | Device | Patient | RelatedPerson
Property reference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "reference", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Unique identifier for the user.
Property userId As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "userId", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Alternative User id e.g. 
/// authentication.
Property altId As %String(MAXLEN = 1000000, XMLNAME = "altId", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Human-meaningful name for the agent.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Whether user is initiator.
Property requestor As %Boolean(XMLNAME = "requestor", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Where.
/// <p>
/// Location
Property location As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Policy that authorized event.
Property policy As list Of %String(MAXLEN = 1000000, XMLNAME = "policy", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Type of media.
/// <p>
/// dicm-405-mediatype is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in dicm-405-mediatype, 
/// you may formally EXTEND dicm-405-mediatype to add codes to it.
Property media As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "media", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Logical network location for application activity.
Property network As HS.FHIR.DTL.vSTU3.Model.Element.AuditEvent.agent.network(XMLNAME = "network", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Reason given for this user.
/// <p>
/// v3-PurposeOfUse is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in v3-PurposeOfUse, 
/// you may formally EXTEND v3-PurposeOfUse to add codes to it.
Property purposeOfUse As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "purposeOfUse", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AuditEvent.agent";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "AuditEvent.agent";

}
