/// A person, 
/// a hardware device or software process.
Class HS.FHIR.DTL.vDSTU2.Model.Element.AuditEvent.participant Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// User roles (e.g. 
/// local RBAC codes)
/// <p>
/// dicm-402-roleid is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in dicm-402-roleid, 
/// you may formally EXTEND dicm-402-roleid to add codes to it.
Property role As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "role", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Direct reference to resource.
/// <p>
/// Practitioner | Organization | Device | Patient | RelatedPerson
Property reference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "reference", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Unique identifier for the user.
Property userId As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "userId", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Alternative User id e.g. 
/// authentication.
Property altId As %String(MAXLEN = 1000000, XMLNAME = "altId", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Human-meaningful name for the user.
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
Property location As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Policy that authorized event.
Property policy As list Of %String(MAXLEN = 1000000, XMLNAME = "policy", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Type of media.
/// <p>
/// dicm-405-mediatype is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in dicm-405-mediatype, 
/// you may formally EXTEND dicm-405-mediatype to add codes to it.
Property media As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "media", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Logical network location for application activity.
Property network As HS.FHIR.DTL.vDSTU2.Model.Element.AuditEvent.participant.network(XMLNAME = "network", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Reason given for this user.
/// <p>
/// v3-PurposeOfUse is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in v3-PurposeOfUse, 
/// you may formally EXTEND v3-PurposeOfUse to add codes to it.
Property purposeOfUse As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "purposeOfUse", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AuditEvent.participant";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "AuditEvent.participant";

}
