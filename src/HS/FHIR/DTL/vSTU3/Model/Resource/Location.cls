/// Details and position information for a physical place where services are provided and resources and participants may be stored, 
/// found, 
/// contained or accommodated.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Location Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Unique code or number identifying the location to its users.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | suspended | inactive
/// <p>
/// location-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend location-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// The Operational status of the location (typically only for a bed/room)
/// <p>
/// v2-0116 is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in v2-0116, 
/// you may use codes from any ValueSet.
Property operationalStatus As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "operationalStatus", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Name of the location as used by humans.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// A list of alternate names that the location is known as, 
/// or was known as in the past.
Property alias As list Of %String(MAXLEN = 1000000, XMLNAME = "alias", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Additional details about the location that could be displayed as further information to identify the location beyond its name.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// instance | kind
/// <p>
/// location-mode is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend location-mode and you may NOT use codes from other ValueSets.
Property mode As %String(MAXLEN = 1000000, XMLNAME = "mode", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Type of function performed.
/// <p>
/// v3-ServiceDeliveryLocationRoleType is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in v3-ServiceDeliveryLocationRoleType, 
/// you may formally EXTEND v3-ServiceDeliveryLocationRoleType to add codes to it.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// Contact details of the location.
Property telecom As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.ContactPoint(XMLNAME = "telecom", XMLPROJECTION = "ELEMENT");

/// Address
/// <p>
/// Physical location.
Property address As HS.FHIR.DTL.vSTU3.Model.Datatype.Address(XMLNAME = "address", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Physical form of the location.
/// <p>
/// any FHIR3 code may be used; 
/// location-physical-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property physicalType As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "physicalType", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// The absolute geographic location.
Property position As HS.FHIR.DTL.vSTU3.Model.Element.Location.position(XMLNAME = "position", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Organization responsible for provisioning and upkeep.
/// <p>
/// Organization
Property managingOrganization As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "managingOrganization", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Another Location this one is physically part of.
/// <p>
/// Location
Property partOf As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "partOf", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Technical endpoints providing access to services operated for the location.
/// <p>
/// Endpoint
Property endpoint As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "endpoint", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Location";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Location";

}
