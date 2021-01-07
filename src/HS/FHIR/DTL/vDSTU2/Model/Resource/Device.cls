/// An instance of a manufactured te that is used in the provision of healthcare.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Device Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Instance id from manufacturer, 
/// owner, 
/// and others.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// What kind of device this is.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// Annotation
/// <p>
/// Device notes and comments.
Property note As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// available | not-available | entered-in-error
/// <p>
/// devicestatus is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend devicestatus and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name of device manufacturer.
Property manufacturer As %String(MAXLEN = 1000000, XMLNAME = "manufacturer", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Model id assigned by the manufacturer.
Property model As %String(MAXLEN = 1000000, XMLNAME = "model", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Version number (i.e. 
/// software)
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Manufacture date.
Property manufactureDate As %String(MAXLEN = 1000000, XMLNAME = "manufactureDate", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Date and time of expiry of this device (if applicable)
Property expiry As %String(MAXLEN = 1000000, XMLNAME = "expiry", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// FDA mandated Unique Device Identifier.
Property udi As %String(MAXLEN = 1000000, XMLNAME = "udi", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Lot number of manufacture.
Property lotNumber As %String(MAXLEN = 1000000, XMLNAME = "lotNumber", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Organization responsible for device.
/// <p>
/// Organization
Property owner As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "owner", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Where the resource is found.
/// <p>
/// Location
Property location As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// If the resource is affixed to a person.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// Details for human/organization for support.
Property contact As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.ContactPoint(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Network address to contact device.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Device";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Device";

}
