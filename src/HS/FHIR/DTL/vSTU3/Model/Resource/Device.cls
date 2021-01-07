/// This resource identifies an instance or a type of a manufactured item that is used in the provision of healthcare without being substantially changed through that activity. 
/// The device may be a medical or non-medical device. 
/// Medical devices include durable (reusable) medical equipment, 
/// implantable devices, 
/// as well as disposable equipment used for diagnostic, 
/// treatment, 
/// and research for healthcare and public health. 
/// Non-medical devices may include items such as a machine, 
/// cellphone, 
/// computer, 
/// application, 
/// etc.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Device Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Instance identifier.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Unique Device Identifier (UDI) Barcode string.
Property udi As HS.FHIR.DTL.vSTU3.Model.Element.Device.udi(XMLNAME = "udi", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | inactive | entered-in-error | unknown
/// <p>
/// device-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend device-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// What kind of device this is.
/// <p>
/// any FHIR3 code may be used; 
/// device-kind shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Lot number of manufacture.
Property lotNumber As %String(MAXLEN = 1000000, XMLNAME = "lotNumber", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name of device manufacturer.
Property manufacturer As %String(MAXLEN = 1000000, XMLNAME = "manufacturer", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Date when the device was made.
Property manufactureDate As %String(MAXLEN = 1000000, XMLNAME = "manufactureDate", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Date and time of expiry of this device (if applicable)
Property expirationDate As %String(MAXLEN = 1000000, XMLNAME = "expirationDate", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Model id assigned by the manufacturer.
Property model As %String(MAXLEN = 1000000, XMLNAME = "model", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Version number (i.e. 
/// software)
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Patient to whom Device is affixed.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Organization responsible for device.
/// <p>
/// Organization
Property owner As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "owner", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// Details for human/organization for support.
Property contact As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.ContactPoint(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Where the resource is found.
/// <p>
/// Location
Property location As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Network address to contact device.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// Annotation
/// <p>
/// Device notes and comments.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Safety Characteristics of Device.
/// <p>
/// any FHIR3 code may be used; 
/// device-safety shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property safety As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "safety", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Device";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Device";

}
